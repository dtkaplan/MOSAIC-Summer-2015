library(shiny)
library(manipulate)
source("helper.R", local = TRUE)

shinyServer(
  function(input, output, session) {
    
    if( !require(manipulate) ) 
      stop("Must use a manipulate-compatible version of R, e.g. RStudio")
    if(!is.null(seed)) set.seed(seed)
    
    output$graph <- renderPlot({
      xpts <<- runif(npts,min=-1.4,max=1.4)
      ypts <<- runif(npts,min=-1.4,max=1.4)
      sizes <<- exp(-runif(npts,min=-.2,max=1.4))
      
      args <- list()
      
      args$mag <- input$mag
      args$dmag <- input$dmag
      args$rot <- input$rot
      args$xtrans <- input$xtrans
      args$ytrans <- input$ytrans
      args$dt <- input$dt
      
      do.call(plotPts, args)
    })
  })