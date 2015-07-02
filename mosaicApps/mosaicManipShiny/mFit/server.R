library(shiny)

if( !require(manipulate)) stop("Must use a manipulate-compatible version of R, e.g. RStudio")
if (!require("mosaic")) stop("Must install mosaic package.")

shinyServer(
  
  function(input,output,session){
  
    .makeA <- function(xx) {
      #browser()
      
      funchoice <- lst %in% fun_lst  #return a logical object
      
      A = matrix(0,nrow=length(xx),ncol = sum(funchoice[1:11])) 
      # get rid of columns potentially for 7 and 8.  They are made with cbind()
      col.count = 1
      mu.count = 1
      for (fun.k in which(funchoice)) {
        if(fun.k %in% c(12,13)){
          newA = f[[fun.k]](xx,P=P,n=n)
          A = cbind(A,newA)
          col.count=col.count+ncol(newA)
        }
        else{
          A[,col.count] = f[[fun.k]](xx,k=k,P=P,mu=get(paste("mu",mu.count,sep="")),sd=sd,n=n)   
          col.count = col.count+1
          if(fun.k %in% 7:11) mu.count = mu.count+1   
        }
      } 
      return(A)
    }
    
# 
#     reactFun <- reactiveValues(
#       
#       n <- input$n,
#       p <- input$P,
#       sd <- input$sd
#       
  
#       f[[6]] = function(x, k, ...) exp(input$k*x),
#       f[[7]] = function(x, mu, sd, ...) pnorm(q = x, mean = input$mu1, sd = input$sd),
#       f[[8]] = function(x, mu, sd, ...) pnorm(q = x, mean = input$mu2, sd = input$sd),
#       f[[9]] = function(x, mu, sd, ...) pnorm(q = x, mean = input$mu3, sd = input$sd),
#       f[[10]] = function(x, mu, sd, ...) pnorm(q = x, mean = input$mu4, sd = input$sd),
#       f[[11]] = function(x, mu, sd, ...) pnorm(q = x, mean = input$mu5, sd = input$sd),
#       
#       # The sines and cosines MUST go at the end since they are duplicated with a slider
#       f[[12]] = function(x, P, n, ...){
#         
#         n <- input$n
#         p <- input$P
#         res = matrix(0,nrow=length(x),ncol=n)
#         for(j in 1:n) {res[,j] = sin(2*j*pi*x/P)}
#         return(res)
#       }
#       
#       f[[13]] = function(x, P, n, ...){
#         n <- input$n
#         p <- input$P
#         res = matrix(0,nrow=length(x),ncol=n)
#         for(j in 1:n) {res[,j] = cos(2*j*pi*x/P)}
#         return(res)
#         }
#    )
    
    
    myPlot <- reactive({
      
      # browser()
      line.red = rgb(1,0,0,.6)
      data <- datasets[[input$data]]
      expr <- as.formula(input$expr)

      xvar = as.character(expr[3])
      yvar = as.character(expr[2])
      xvals = data[[xvar]]
      yvals = data[[yvar]]
  
      validate(need(xvals, "Please enter a valid expression"))
      
      if(class(xvals)=="factor"){
        stop("Categorical explanatory variable in play! What do we do now? Treat it as numeric?")
      }

      x = seq(min(xvals),max(xvals), length = 1000)
#       
#       funchoice = c(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, 
#                     a11, a12, a13)
      
      browser()

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
        
        #browser()
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
    
    if(input$plot == 0){
      return (NULL)
    }
      myPlot()
    
  })
  
  
})
  
