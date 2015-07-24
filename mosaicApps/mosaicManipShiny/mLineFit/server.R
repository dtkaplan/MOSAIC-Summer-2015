library(shiny)
library(mosaic)
library(lattice)
library(grid)


shinyServer(
  
  function(input, output, session) {
    
    showPlot <- reactive({
      
      if(input$plot == 0){
        return (NULL)}
      
      #set up intial value
      #       showResids <- FALSE
      #       showSquares <- FALSE
      # interceptRange <- sort(sd(response)*c(-2,2))
      # curIntercept <- mean(interceptRange)
      # slopeRange <- sort(coef(mod)[2]*c(-1,1.5))
      # curSlope <- 1
      
      data <- datasets[[isolate(input$data)]]
      formula <- as.formula(isolate(input$expr))
      mod <- lm(formula, data=data)
      bestSlope <- coef(mod)[2]
      
      curSlope <- isolate(input$slope) * bestSlope
      curIntercept <- isolate(input$inter)
      # browser()
      
      mod <- lm(formula, data=data)
      responseName <- deparse(mod$terms[[2L]])
      bestSlope <- coef(mod)[2]
      bestInter <- coef(mod)[1]
      mat <- model.matrix(mod)
      independIndex <- min(ncol(mat), 2)
      response <- fitted(mod) + resid(mod)
      explanatory <- mat[,independIndex]
      vecnames <- colnames(mat)
      mx <- mean(explanatory)
      my <- mean(response)
      
      modelVals <- curSlope*(explanatory-mx) + (curIntercept+my)
      plot( explanatory, response,
            ylab=responseName,
            xlab=vecnames[independIndex],
            pch=20,col="blue")
      # browser()
      if(input$resids == TRUE && input$plot != 0) {
        for( k in 1:length(explanatory) ) {
          thisColor <- c("red","green","blue")[sign(response[k]-modelVals[k])+2]
          lines( c(0,0)+explanatory[k], c(response[k],modelVals[k]), col=thisColor)
        }
      }
      if(input$squares == TRUE && input$plot != 0)  {
        foo <- par("usr")
        goo <- par("pin")
        text(foo[1],foo[4]-.05*(foo[4]-foo[3]),paste("Sum Sq. Resids=",signif(sum((response-modelVals)^2),3)),pos=4)
        hscale <- (goo[2]/goo[1])*(foo[2]-foo[1])/(foo[4]-foo[3]) # scale horizontal appropriately
        for( k in 1:length(explanatory) ) {
          hlength <- hscale*abs(response[k] - modelVals[k])
          polygon( explanatory[k]+c(0,0,hlength,hlength),
                   c(response[k],modelVals[k],modelVals[k],response[k]),
                   col=rgb(204,255,255,120,maxColorValue = 255), border=NA)
        }
      } 
      
      abline(curIntercept+my-curSlope*mx, curSlope,col=rgb(0,0,0,.3),lwd=2)
      points( explanatory, modelVals, pch=10, col="black") 
      points( explanatory, response, pch=20, col="blue")
      
      
    })
    
    
    
    
    output$graph <- renderPlot({
#       isolate(input$resids)
#       isolate(input$squares)
      
 
      showPlot()

    })
    
    
    
  }
)

