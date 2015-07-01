library(shiny)
library(mosaic)
library(lattice)
library(grid)

shinyServer(
  
  function(input, output, session) {
    
    source("mDensity.R", local=TRUE)
    
    output$graph <- renderPlot({
      
      args <- list()
      args$trans <- switch(input$trans, 
                           "None"   = c,
                           "Log"    = log,
                           "Sqrt"   = sqrt,
                           "Rank"   = rank,
                           "arcCos" = acos)
      
      args$bandwidth  <- input$band
      args$dist       <- input$dist
      args$seed       <- input$seed
      args$npts       <- input$points
      
      do.call(myFun, args)
    })
    
  }
)