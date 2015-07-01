library(shiny)
library(mosaic)
library(lattice)
library(grid)

shinyServer(
  
  function(input, output, session) {
    
    showPlot <- reactive({
      
      #set up intial value
      #       showResids <- FALSE
      #       showSquares <- FALSE
      # interceptRange <- sort(sd(response)*c(-2,2))
      # curIntercept <- mean(interceptRange)
      # slopeRange <- sort(coef(mod)[2]*c(-1,1.5))
      # curSlope <- 1
      
      data <- datasets[[input$data]]
      formula <- as.formula(input$expr)
      mod <- lm(formula, data=data)
      bestSlope <- coef(mod)[2]
      
      curSlope <- input$slope * bestSlope
      curIntercept <- input$inter
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
      
      if( input$resids == TRUE ) {
        for( k in 1:length(explanatory) ) {
          thisColor <- c("red","green","blue")[sign(response[k]-modelVals[k])+2]
          lines( c(0,0)+explanatory[k], c(response[k],modelVals[k]), col=thisColor)
        }
      }
      if( input$squares == TRUE )  {
        foo <- par("usr")
        goo <- par("pin")
        text(foo[1],foo[4]-.05*(foo[4]-foo[3]),paste("Sum Sq. Resids=",signif(sum((response-modelVals)^2),3)),pos=4)
        hscale <- (goo[2]/goo[1])*(foo[2]-foo[1])/(foo[4]-foo[3]) # scale horizontal appropriately
        for( k in 1:length(explanatory) ) {
          hlength <- hscale*abs(response[k] - modelVals[k])
          polygon( explanatory[k]+c(0,0,hlength,hlength),
                   c(response[k],modelVals[k],modelVals[k],response[k]),
                   col="lightblue", border=NA)
        }
      } 
      
      abline(curIntercept+my-curSlope*mx, curSlope,col=rgb(0,0,0,.3),lwd=2)
      points( explanatory, modelVals, pch=10, col="black") 
      points( explanatory, response, pch=20, col="blue")
      
      
    })
    
    
    
    
    output$graph <- renderPlot({
      
      if(input$plot == 0){
        return (NULL)}
      showPlot()

    })
    
    
    
  }
)

