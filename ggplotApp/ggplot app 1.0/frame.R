library(shiny)
library(DCF)



frame_tab <- tabPanel(
  "Frame",
  column(4,
         wellPanel(
           selectInput(
             "frame_x", "X variable:",
             "Bogus_x"
           ),
           
           selectInput(
             "frame_y", "Y variable:",
             "Bogus_y"
           ),
           wellPanel(
             checkboxInput("show_layer_1", "Display Layer 1", value=FALSE),
             checkboxInput("show_layer_2", "Display Layer 2", value=FALSE),
             checkboxInput("show_layer_3", "Display Layer 3", value=FALSE)
           )
         )),
  column(8,
         wellPanel(
                   plotOutput(id="frame_plot")           
         ))
)

