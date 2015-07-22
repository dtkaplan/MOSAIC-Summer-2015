library(shiny)
library(mosaic)
library(lattice)
library(grid)

shinyServer(
  
  function(input, output, session) {
    
    source("mPower.R", local=TRUE)
    
    output$graph <- renderPlot({
      
      args <- list()
      
      args$mu  <- input$mu
      args$sigma <- input$sigma
      args$n  <- input$n

      do.call(myFun, args)
    })
    
  }
)