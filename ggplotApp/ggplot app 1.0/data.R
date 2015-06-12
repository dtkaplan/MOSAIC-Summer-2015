library(shiny)
library(mosaic)


choose_data_source <- radioButtons(
  "file_or_package", 
  label = NULL,
  choices = list("Choose Datasets" = 1, "Upload Datasets" = 2), 
  selected = 1)

condition1 <- 
  conditionalPanel(
    condition = "input.file_or_package == 1",
    selectizeInput("data", label = "Choose Dataset", 
                   choices = list( "Galton", "Heightweight",
                                   "SwimRecords", "TenMileRace"
                   )
    )
  )

condition2 <- 
  conditionalPanel(
    condition = "input.file_or_package == 2",
    fileInput('data_own', 'Choose CSV File',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv')
    )
  )


subset <- 
  fluidRow(    
    checkboxInput("random_subset", "Random Subset"),
    conditionalPanel(
      condition = "input.random_subset == true",      
      numericInput("random_subset_nrow", "Rows", value = 10, min = 1)
      
    )
  )

well <- wellPanel(
  choose_data_source,
  condition1,
  condition2,
  subset)

specify_data_source_panel <- 
  tabPanel(
    "Data",
    column(4, 
           well
    ),
    column(6,
           dataTableOutput("table")
    )
  )

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




   


