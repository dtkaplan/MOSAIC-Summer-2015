library(shiny)
library(mosaicData)
#source("helper.R")


get_uploaded_data <- reactive({
  if (is.null(input$data_own)) {
    # User has not uploaded a file yet
    Dataset <- data.frame()
  } else {
    Dataset <- read.csv(input$data_own$datapath, #data.table::fread(), readr::readr()
                        stringsAsFactors=FALSE)
  }
  
  Dataset
})

