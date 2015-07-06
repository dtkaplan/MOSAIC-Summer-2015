library(shiny)

if( !require(manipulate)) stop("Must use a manipulate-compatible version of R, e.g. RStudio")
if (!require("mosaic")) stop("Must install mosaic package.")

shinyServer(
  function(input,output,session){
  
     .makeA <- function(xx) {
      #browser()
      #Several changes made for this app:
      #Turn funchoice from a vector of TRUE AND FALSE into a checkbox group, and create a new funchoice that returns a logical object
       #indicating which functions have been selected
     funchoice <- lst %in% fun_lst 
     A = matrix(0,nrow=length(xx),ncol = sum(funchoice[1:11])) 
     # get rid of columns potentially for 7 and 8.  They are made with cbind()
     col.count = 1
     mu.count = 1
     for (fun.k in which(funchoice)) {
       if(fun.k %in% c(12,13)){
         newA = f[[fun.k]](xx, P=input$P, n=input$n)  #the function takes input from UI directly
         A = cbind(A,newA)
         col.count=col.count+ncol(newA)
       }
        if(fun.k %in% c(7,8,9,10,11)){
#          A[,col.count] = f[[fun.k]](xx,input$paste0("mu",mu.count),input$sd) #the function doesn't take input from UI directly
#          col.count = col.count+1
#          mu.count = mu.count+1
       if (fun.k == 7){
         A[,col.count] = f[[fun.k]](xx,input$mu1,input$sd) #the function takes input from UI directly
         col.count = col.count+1
       }
       if (fun.k == 8){
         A[,col.count] = f[[fun.k]](xx,input$mu2,input$sd) #the function takes input from UI directly
         col.count = col.count+1
       }
       if (fun.k == 9){
         A[,col.count] = f[[fun.k]](xx,input$mu3,input$sd) #the function takes input from UI directly
         col.count = col.count+1
       }
       if (fun.k == 10){
         A[,col.count] = f[[fun.k]](xx,input$mu4,input$sd) #the function takes input from UI directly
         col.count = col.count+1
       }
       if (fun.k == 11){
         A[,col.count] = f[[fun.k]](xx,input$mu5,input$sd) #the function takes input from UI directly
         col.count = col.count+1
       }
        }
       else{
           A[,col.count] = f[[fun.k]](xx,k=input$k,P=input$P,mu=input$paste0("mu",mu.count),sd=input$sd,n=input$n) #the function takes input from UI directly
           col.count = col.count+1
           # if(fun.k %in% 7:11) mu.count = mu.count+1   
       }
     } 
     return(A)
     }
     
     vals <- reactiveValues(
       data = NULL,
       expr = NULL,
       xvar = NULL,
       xvals = NULL,
       yvar = NULL,
       yvals = NULL
     )
     
     observeEvent(input$reset,{ 
       
       #reset button updates slider inputs for mu and sd
       vals$data <<- datasets[[input$data]]
       vals$expr <<- as.formula(input$expr)
       vals$xvar <<- as.character(vals$expr[3])
       vals$xvals <<- vals$data[[vals$xvar]]
       vals$yvar <<- as.character(vals$expr[2])
       vals$yvals <<- vals$data[[vals$yvar]]
       
       lapply(1:5, function(i) {
         updateSliderInput(session, inputId = paste0('mu', i),
                           value = min(vals$xvals)+i*diff(range(vals$xvals))/6, min = min(vals$xvals),max = max(vals$xvals))
       })
       updateSliderInput(session, inputId = sd, value = diff(range(vals$xvals))/4, min = 0.1, max = diff(range(vals$xvals))/2)
       
     })
     

     
    myPlot <- reactive({
 
      line.red = rgb(1,0,0,.6)
      xvar = vals$xvar
      yvar = vals$yvar
      xvals = vals$xvals
      data = vals$data
      yvals = vals$yvals
  
      validate(need(xvals, "Please enter a valid expression"))
      
      if(class(xvals)=="factor"){
        stop("Categorical explanatory variable in play! What do we do now? Treat it as numeric?")
      }

      x = seq(min(xvals),max(xvals), length = 1000)
      lst <<- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
      fun_lst <<- as.numeric(input$checkbox)
      
      if( length(input$checkbox)==0) {
        print("You must select at least one function to fit a curve!")
        bigy = 0*x
      }
      else{
        A = .makeA(xvals)
        bigA = .makeA(x)
        coefs = qr.solve(A, yvals)
        bigy = bigA %*% coefs
        predict.y = A %*% coefs
        RMS = abs(sqrt(mean((predict.y-yvals)^2))*diff(range(xvals)))
      }
      
      bigx=x #Avoid conflicting variable names
      mypanel = function(x, y){
        panel.xyplot(x, y, pch = 16)
        panel.xyplot(bigx, bigy, type = "l", col=line.red, lwd = 5)
        #       grid.text(paste("RMS Error: ", signif(RMS, 3)), 
        #                 x = unit(0, "npc")+unit(1, "mm"),
        #                 y = unit(1, "npc")-unit(2, "mm"),
        #                 just = "left",
        #                 gp = gpar(col = "red", fontsize =10))
      }
      
      #PLOTTING F'REAL
      
      #browser()
      xyplot(yvals~xvals, data, xlab = xvar, ylab = yvar, panel = mypanel, 
             main = paste("RMS Error:", signif(RMS, 3)))
      
    })
    
  
    
    
  output$graph <- renderPlot({
    
    if(input$plot == 0)
      return (NULL)

    
      myPlot()
  })
    

  
})
  


