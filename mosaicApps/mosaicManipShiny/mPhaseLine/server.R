library(shiny)
library(manipulate)
source("helper.R", local = TRUE)


dyn <- function(x) {x*(1-x)}
  
shinyServer(
  function(input, output, session) {
    if( !require(manipulate) ) 
      stop("Must use a manipulate-compatible version of R, e.g. RStudio")
    
    output$graph <- renderPlot({
       #browser()
      
      xpts <<- seq(x_limit[1],x_limit[2],length=500) 
      ypts <<- dyn(xpts)
      inds <<- ceiling(rank(-ypts))
      ninds <<- max(inds)
      #arrange the colors so that zero always has a fixed color
      nLessThanZero <<- max( inds[ypts<0])
      color_s <<- c(rainbow(start=0,end=.5,n=ninds-nLessThanZero,alpha=.75),
                  rainbow(start=.5,end=1,n=nLessThanZero,alpha=.75))
      #colors <- topo.colors(ninds+round(length(xpts)/5),alpha=.75)
      
      show_Dyn <<- input$showDyn
      field <<- input$field
      
      args <- list()
      
      args$x <- input$x
      args$field <- input$field
      args$npts <- input$npts
      args$dt <- input$dt
      args$showDyn <- input$showDyn
      
      do.call(drawGraph, args)
    })
  })