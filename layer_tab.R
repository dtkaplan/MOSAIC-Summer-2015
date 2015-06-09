# geom_list <- reactive({
#   if (input$geoms == NULL) {
#     print("Please choose a geom")
#   }
#   else {
#     selectizeInput("x","Var X", choices = list(1,2,3))
#     selectizeInput("y","Var Y", choices = list(1,2,3))
#     selectizeInput("col","Choose Colors")
#   }          
# })

make_layer <- function(){
  wellPanel(
    selectizeInput("geoms", "Geoms", 
                   choices = list("geom_line" = 1, "geom_point" = 2, "geom_bar" = 3)
    ),
    selectizeInput("controls","Select Aesthetics",choices = list()),
    actionButton("plot","Plot"),
    actionButton("reset","Reset")
  )  
}

layer_1_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_1 == true",
    "Layer 1"
  ), 
  column(4,
            make_layer()),
  column(8)
)

layer_2_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_2 == true",
    "Layer 2"
  ),
  make_layer()
)

layer_3_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_3 == true",
    "Layer 3"),
    make_layer()
)

layer_4_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_4 == true",
    "Layer 4"),
    make_layer()
  )

layer_5_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_5 == true",
    "Layer 5"),
    make_layer()
)

layer_tab <- 
  tabPanel(
    "Layer",
    fluidRow(
      tabsetPanel(
        id="tabset",
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
        layer_5_cond 
        
        
      )
    ))






