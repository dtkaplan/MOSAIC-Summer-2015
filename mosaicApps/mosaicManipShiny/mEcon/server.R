library(shiny)
library(mosaic)
library(lattice)
library(grid)


shinyServer(
  
  function(input, output, session) {
    source("mEcon.R", local=TRUE)
    
    
    output$graph <- renderPlot({
      
      args <- list()
      args$sup1  = input$s10
      args$sup2  = input$s20
      args$dem1  = input$d10
      args$dem2  = input$d20
      
      do.call(myFun, args)
    })
    
  }
)