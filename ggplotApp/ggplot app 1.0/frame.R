library(shiny)
library(DCF)

dataset <- BabyNames

frame_tab <- tabPanel(
  "Frame",
  column(4,
         wellPanel(
         selectInput("x", "X variable:",
                     c(unique(as.character(names(dataset))))),
         
         selectInput("y", "Y variable:",
                     c(unique(as.character(names(dataset))))),
         wellPanel(
           checkboxInput("show_layer_1", "Display Layer 1", value=FALSE),
           checkboxInput("show_layer_2", "Display Layer 2", value=FALSE),
           checkboxInput("show_layer_3", "Display Layer 3", value=FALSE))
  )),
  column(8,
         wellPanel(id="plot_panel",
                  p("This is where the plot is.")
                  
         )))
  
