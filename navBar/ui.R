library(shiny)
library(shinythemes)
library(mosaic)
source("data.R")


shinyUI(
  
  navbarPage( "ProjectMosaic!", 
              theme = shinytheme("cerulean"),
              tabPanel("Plotting",
                       specify_data_source_panel                      
              )
            
  )     
)