frame_tab <- tabPanel(
  "Frame",
  column(4,
         wellPanel(
           selectInput(
             "frame_x", "X variable:",
             list("bogus x")
           ),
           
           selectInput(
             "frame_y", "Y variable:",
             list("bogus y")
           ),
           wellPanel(
             checkboxInput("show_layer_1", "Display Layer 1", value=FALSE),
             checkboxInput("show_layer_2", "Display Layer 2", value=FALSE),
             checkboxInput("show_layer_3", "Display Layer 3", value=FALSE)
           )
         )),
  column(8,
         wellPanel(
                   plotOutput(outputId="frame_plot")           
         ))
)

