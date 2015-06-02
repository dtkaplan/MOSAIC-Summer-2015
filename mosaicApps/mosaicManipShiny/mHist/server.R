library(shiny)
library(mosaic)
library(lattice)
library(grid)
source("mHist.R", local=TRUE)

newCol=rgb(0,.2,.8,.6)
oldCol=rgb(.9,.9,0,.3)
oldBreaks <- NULL

shinyServer(
  
  function(input, output, session) {
    
    output$graph <- renderPlot({
      
      args <- list()
      args$nBands  = input$bins
      args$cBreak  = input$center
      args$seed    = input$seed
        
      do.call(myFun, args)
    })
    
  }
)