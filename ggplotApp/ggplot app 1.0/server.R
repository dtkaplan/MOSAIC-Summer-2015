library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)
source("layer.R")
source("frame.R")

datasets <- list( Galton = Galton, Heightweight = Heightweight,
                 SwimRecords = SwimRecords, TenMileRace = TenMileRace)


#datasets <- as.list(data(package="mosaicData")$results[,"Item"])


shinyServer(function(input,output,session){
  
  source("data.R", local=TRUE)
  
  # provides the currently specified data table
  this_dataset <- reactive({
    if (is.null(input$data_own) || input$file_or_package == "1") 
      Tmp <- datasets[[input$data]]
    else
      Tmp <- get_uploaded_data()
    
    if(input$random_subset){ # grab a random subset
      Tmp <- dplyr::sample_n(Tmp, size=input$random_subset_nrow)
    }
    
    Tmp    
  })
  
  # fill in the display in the data selection panel
  output$table <- renderDataTable({ this_dataset() })
 
  
})