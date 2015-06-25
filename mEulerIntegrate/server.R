library(shiny)
library(mosaic)
library(lattice)
library(grid)


shinyServer(
  
  function(input, output, session){
    
    source("helper.R", local = TRUE)
    
    output$graph <- renderPlot({
      
#       args <- list()
#       args$dynfun <- chooseDist()
#       args$go <- input$go
#       args$dt <- input$dt
#       args$xval0 <- input$xval0
#       args$showequilibria <- input$showeq
#       args$ntraj <- input$ntraj
#       args$restart <- input$restart
#       args$editfun <- input$editfun
#       
#       do.call(draw.state, args)
      
      draw.state()
      
    })  
    
    
    
  }
  
)

