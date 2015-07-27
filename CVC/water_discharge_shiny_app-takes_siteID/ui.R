library(shiny)
library(dplyr)
library(dygraphs)
library(xts)

shinyUI(fluidPage(
  titlePanel("Water Discharge"),
  
  p("Text here with more information."),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  textInput("site", label = h5("Enter the site ID here")),
                  
                  dateRangeInput("dates", label = h5("Date range")),
                  
                  actionButton("button", label = "Plot")
                ),
                
                
                mainPanel(
                  dygraphOutput("graph"), 
                  p("Author: Jingjing Yang")
                )
  )
  
))