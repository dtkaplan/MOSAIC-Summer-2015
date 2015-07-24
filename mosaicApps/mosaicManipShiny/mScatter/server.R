library(shiny)
library(mosaic)
library(lattice)
library(grid)



datasets <- list( Galton = Galton, Heightweight = Heightweight,
                  SwimRecords = SwimRecords, TenMileRace = TenMileRace)

shinyServer(
  
  function(input, output, session) {
    
    source("mScatter.R", local=TRUE)
    
    data<-reactive({
      datasets[[input$data]]      
    })
    
    xaxis<-reactive({
      input$xaxis 
    })
    
    yaxis<-reactive({
      input$yaxis
    })
    
    color<-reactive({
      input$color
    })
    
    facet<-reactive({
      input$facet      
    })
    
    size<-reactive({
      input$size
    })
    
    logx<-reactive({
      input$logx
    })
    
    logy<-reactive({
      input$logy
    })
    
    model<-reactive({
      input$model
    })
    
    #     output$xaxis<-render
    
    
    #     output$graph <- renderPlot({     
    #       args <- list()
    #       args$dat   <- input$data
    #       args$Xaxis <- input$xaxis  
    #       args$Yaxis <- input$yaxis
    #       args$Color <- input$color
    #       args$Facet <- input$facet       
    #       args$Size  <- input$size
    #       args$Logx  <- input$logx
    #       args$Logy  <- input$logy
    #       args$Model <- input$model
    #       
    #       do.call(mScatter, args)
    #     })
    
    output$graph <- renderPlot({
      input$data
      input$xaxis  
      input$yaxis
      input$color
      input$facet       
      input$size
      input$logx
      input$logy
      input$model
      
      
      mScatter(dat,Xaxis,Yaxis,Color,Facet,Size....)
      
    })
    
  }
)





