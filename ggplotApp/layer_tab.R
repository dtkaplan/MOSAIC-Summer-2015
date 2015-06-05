library("shiny")

layer_1_cond <- tabPanel(conditionalPanel(
  condition = "input.show_layer_1 == true",
  "Layer 1"), plotOutput("l1_plot")
  )

#tabPanel("l1","Layer 1")

layer_2_cond <- tabPanel(conditionalPanel(
  condition = "input.show_layer_2 == true",
  tabPanel("l2", "Layer 2")))


layer_3_cond <- tabPanel(conditionalPanel(
  condition = "input.show_layer_3 == true",
  tabPanel("l3","Layer 3")))

layer_4_cond <- tabPanel(conditionalPanel(
  condition = "input.show_layer_4 == true",
  tabPanel("l4", "Layer 4")))

layer_5_cond <- tabPanel(conditionalPanel(
  condition = "input.show_layer_5 == true",
  tabPanel("l5", "Layer 5")))


layer_tab <- tabPanel(
  "Layer",
  fluidRow(
    column(4,
           wellPanel(radioButtons("geoms", "Geoms", 
                                  choices = list("geom_text", "geom_line", "geom_point"))),
           actionButton("plot","Plot"),
           actionButton("reset","Reset")),
    #actionButton("more","Add another layer")),
    
    column(8,
           tabsetPanel(id="tabset",
                       tabPanel("Manage layers", 
                                checkboxInput("show_layer_1", "Display Layer 1", value=FALSE),
                                checkboxInput("show_layer_2", "Display Layer 2", value=FALSE),
                                checkboxInput("show_layer_3", "Display Layer 3", value=FALSE),
                                checkboxInput("show_layer_4", "Display Layer 4", value=FALSE),
                                checkboxInput("show_layer_5", "Display Layer 5", value=FALSE)), 
                       layer_1_cond,
                       layer_2_cond,
                       layer_3_cond,
                       layer_4_cond,
                       layer_5_cond,
                       uiOutput("display_layer1")
                       #tabPanel(id="layer_1","Layer 1"),
                       #tabPanel(id="layer_2", "Layer 2"))
    )
  ))
)