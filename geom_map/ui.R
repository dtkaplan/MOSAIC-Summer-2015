
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)
library(mosaicData)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interactive geom_map testbed"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        selectInput("plotFun", "Choose a plotting function:", choices = list("ggplot" = 1, "ggmap" = 2)),
        
        conditionalPanel(condition = "input.plotFun == '1'",
                         selectInput("data_source","Please choose a dataset",
                                     choices = list("None", "China","World","London"),
                                     selected = "None")
        ),
        
        conditionalPanel(condition = "input.plotFun == '2'", 
                         textInput("location", "Please type a location you want", value = ""),
                         selectInput("map_source", "Choose a map source:", 
                                     choices = list("None", "stamen", "google", "osm"), selected = "None"),
                         selectInput("map_type", "Choose a map type:", choices = "") 
        ),
        
        actionButton("make_plot", "Plot the map")

      ),
      
      wellPanel(
        selectInput("data_to_join","Choose a data to join", choices = list("None", "China Pop", "London Sports"),
                    selected = "None"
                    ),
        selectInput("geom1", "Choose a geom for this layer:",
                    choices = 
                      c(names(geom_aesthetics)),
                    selected = "geom_map"),
        selectInput("fill_var", "Choose a variable to fill with", choices = "any")
        # tableOutput("disp_aes_1"),
#         wellPanel(
#           selectInput("map1", "Map aesthetic:", 
#                       choices = c("first, select geom")),
#           selectInput("var1", "Pick variable", choices=c(1,2,3)),
#           actionButton("do_map_1", "Map it!")
#         ),
#         wellPanel(
#           textInput("set_val_1","Set aesthetic, e.g. color = 'red'"),
#           actionButton("do_set_1", "Set it!")
#           
#         )
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("frame_plot")
    )
  )
)
)
