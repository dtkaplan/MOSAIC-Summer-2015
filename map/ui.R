library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)
library(shinythemes)

tile <- tabPanel(tile,
                  column(4, 
                         wellPanel(
                           textInput("location", "Please type a location you want", value = ""),
                           selectInput("map_source", "Choose a map source:", 
                                       choices = list("None", "stamen", "google", "osm"), selected = "None"),
                           selectInput("map_type", "Choose a map type:", choices = "") 
                           
                           
                         )),
                  
                  column(6, 
                         plotOutput("tileOutput"))
)

shape <- tabPanel(shape,
                   column(4, 
                          wellPanel(
                            selectInput("data_source","Please choose a dataset",
                                        choices = list("None", "China","World","London"),
                                        selected = "None"),
                            selectInput("geom1", "Choose a geom for this layer:",
                                        choices = 
                                          c("None",names(geom_aesthetics)),
                                        selected = "geom_map")
                            
                          )),
                   
                   column(6, 
                          plotOutput("tileOutput"))
)






shinyUI( 
  navbarPage( "ProjectMosaic!", 
              theme = shinytheme("cerulean"),
              tabPanel("Have fun with the maps",
                       tabsetPanel(
                       tile,
                       shape
#                        positionData,
#                        entityData
                         
                       )
                       
              )                 
  )
  
)    


