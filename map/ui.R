library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)
library(shinythemes)

tile <- tabPanel("Tile",
                  column(4, 
                         wellPanel(
                           textInput("location", "Please type a location you want", value = ""),
                           selectInput("map_source", "Choose a map source:", 
                                       choices = list("None", "stamen", "google", "osm"), selected = "None"),
                           selectInput("map_type", "Choose a map type:", choices = ""),
                           sliderInput("zoom_num", "Please adjust the sliderbar to zoom in", min = 1, max = 21, value = 10),
                           p("Zoom is an number from 3 (continent) to 21 (building), 
                             default value 10 (city). OpenStreetMaps limits a zoom of 18, 
                             and the limit on stamen maps depends on the maptype.")
              
        
                         )),
                  
                  column(6, 
                         plotOutput("tileOutput"))
)

shape <- tabPanel("Shape",
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
                          plotOutput("shapeOutput"))
)

entity <- tabPanel("Entity Data",
                   column(4, 
                          wellPanel(
                            selectInput("data_to_join","Choose a data to join", choices = list("None", "China Pop", "London Sports"),
                                        selected = "None"
                            ),
                            selectInput("geomEnt", "Choose a geom for this layer:",
                                        choices = 
                                          c("None",names(geom_aesthetics)),
                                        selected = "geom_map"),
                            selectInput("fill_var", "Choose a variable to fill with", choices = "any"),
                            checkboxInput("display_tile", "Click if you want to display tile", value = FALSE),
                            wellPanel(
                              textInput("col", "Please set the color of the boundary", value = "black"),
                              sliderInput("size", "Please adjust the map's boundary size", min = 0, max = 8, value = 0.5, step = 0.2 ),
                              sliderInput("alpha", "Please ajust the map's transparency", min = 0.1, max = 1, value = 0.5, step = 0.1),
                              textInput("lt", "Please enter a linetype", value = "solid" )
                            )
                          )),
                   column(6, 
                          plotOutput("entityOutput"))
)


position <- tabPanel("Position Data",
                   column(4, 
                          wellPanel(
                            selectInput("pos_data","Choose a data to plot", choices = list("None", "China Province Pop"),
                                        selected = "None"
                            ),
                            selectInput("geomPos", "Choose a geom for this layer:",
                                        choices = 
                                          c("None",names(geom_aesthetics)),
                                        selected = "None")
                          )),
                   column(6, 
                          plotOutput("positionOutput"))
)

shinyUI( 
  navbarPage( "ProjectMosaic!", 
              theme = shinytheme("cerulean"),
              tabPanel("Have fun with the maps",
                       tabsetPanel(
                       tile,
                       shape,
                       position,
                       entity
                         
                       )
                       
              )                 
  )
  
)    


