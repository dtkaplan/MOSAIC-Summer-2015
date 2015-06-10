make_layer <- function(n){
# The function takes an input n and makes a well panel where allows users to choose from different 
# geoms types and aesthetics. If the function is called in multiple layers, it will assign unique id to
# each geom and aesthetics input for future reference
  
  id <- paste0("geoms",n)
  label <- paste0("Geoms",n)
  controlId <- paste0("controls",n)
  
  wellPanel(
    selectizeInput(id, label, 
                   choices = list("geom_line" = 1, "geom_point" = 2, "geom_bar" = 3)
    ),
    selectizeInput(controlId,"Select Aesthetics",choices = list()),
    actionButton("plot","Plot"),
    actionButton("reset","Reset")
  )  
}



make_tabPanel <- function(n){
  cond <- paste0("input.show_layer_",n," == true")
  label <- paste("Layer", n)
  
  tabPanel(    
    conditionalPanel(
      conditon = cond,
      label
    ),    
    make_layer(n)
    )
  
}



# layer_1_cond <- tabPanel(
#   conditionalPanel(
#     condition = "input.show_layer_1 == true",
#     "Layer 1"
#   ), 
#   column(4,
#             make_layer(1)
#          ),
#   column(8)
# )
# 
# layer_2_cond <- tabPanel(
#   conditionalPanel(
#     condition = "input.show_layer_2 == true",
#     "Layer 2"
#   ),
#   make_layer(2)
# )
# 
# layer_3_cond <- tabPanel(
#   conditionalPanel(
#     condition = "input.show_layer_3 == true",
#     "Layer 3"),
#     make_layer(3)
# )
# 
# layer_4_cond <- tabPanel(
#   conditionalPanel(
#     condition = "input.show_layer_4 == true",
#     "Layer 4"),
#     make_layer(4)
#   )
# 
# layer_5_cond <- tabPanel(
#   conditionalPanel(
#     condition = "input.show_layer_5 == true",
#     "Layer 5"),
#     make_layer(5)
# )

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
#         layer_1_cond,
#         layer_2_cond,
#         layer_3_cond,
#         layer_4_cond,
#         layer_5_cond 
make_tabPanel(1),
make_tabPanel(2),
make_tabPanel(3)

        
      )
    ))





