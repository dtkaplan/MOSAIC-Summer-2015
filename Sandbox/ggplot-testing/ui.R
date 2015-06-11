
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interactive ggplot testbed"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        selectInput("data_source", "Choose data set:",
                    choices = data(package="mosaicData")$results[,"Item"]),
        selectInput("frame_x","Frame x variable",
                    choices = 'pick data set'),
        selectInput("frame_y","Frame y variable",
                    choices = 'pick data set')
      ),
      wellPanel(
        selectInput("geom1", "Geom for this layer:",
                    choices = 
                      c(names(geom_aesthetics)),
                    selected = "geom_blank"),
        tableOutput("disp_aes_1"),
        wellPanel(
          selectInput("map1", "Map aesthetic:", 
                    choices = c("first, select geom")),
          selectInput("var1", "Pick variable", choices=c(1,2,3)),
          actionButton("do_map_1", "Map it!")
        ),
        wellPanel(
          textInput("set_val_1","Set aesthetic, e.g. color = 'red'"),
          actionButton("do_set_1", "Set it!")
          
        )
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("layer_1_plot")
    )
  )
)
)
