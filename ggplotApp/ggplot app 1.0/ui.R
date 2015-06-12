library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)
library(shinythemes)
source("data.R")
source("layer.R")
source("frame.R")

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