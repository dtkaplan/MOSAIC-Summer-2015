library(shiny)
source("helper.R", local = TRUE)



shinyServer(
  function(input, output, session) {
    
    output$graph <- renderPlot({
      args <- list()
      
      useT <<- input$t_or_f == 1
      useF <<- input$t_or_f == 2
      show_alt <<- input$show.alt
      
      args$effect <- input$effect
      args$n <- input$n
      args$ang <- input$ang
      args$resid <- input$resid
      args$signif <- input$signif
      args$m <- input$m
      args$show.alt <- input$show.alt
      
      do.call(drawIt, args)
    })
  })