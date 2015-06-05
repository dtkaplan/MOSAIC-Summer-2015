library(DCF)
library(shiny)
library(shinythemes)
library(mosaic)
source("data.R")
source("frame_tab.R",local=TRUE)
source("layer_tab.R",local=TRUE)
source("helper.R",local=TRUE)


shinyUI(
  
  navbarPage( "ProjectMosaic!", 
              theme = shinytheme("cerulean"),
              tabPanel("Plotting",
                       navlistPanel(
                         widths = c(2,10),  
                         specify_data_source_panel,                           
                         frame_tab,
                         layer_tab)
                         
                       )                 
              )
              
  )     
