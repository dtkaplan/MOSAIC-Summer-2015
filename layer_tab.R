<<<<<<< HEAD
library("shiny")

layer_1_cond <- tabPanel(conditionalPanel(
  condition = "input.show_layer_1 == true",
  "Layer 1"), plotOutput("l1_plot")
  )

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
  tabPanel("l5", "Layer 5")),
  make_layer()
  )


make_layer <- function(){
  layer <- tabPanel("layer n",
                    wellPanel(selectizeInput("geoms", "Geoms", 
                                             choices = list("geom_text" = 1, "geom_line" = 2, "geom_point" = 3)
                    ),
                    actionButton("plot","Plot"),
                    actionButton("reset","Reset"),
                    #                             geom_list(),
                    conditionalPanel(
                      condition = "input.geoms == 1",
                      selectizeInput("x","Var X", choices = list(1,2,3)),
                      selectizeInput("y","Var Y", choices = list(1,2,3))
                    ) 
                    )    
                    
                    
  )       
  
  return (layer)
} 



# geom_list <- reactive({
#   if (input$geoms == NULL) {
#     print("Please choose a geom")
#   }
#   else {
#     selectizeInput("x","Var X", choices = list(1,2,3)),
#     selectizeInput("y","Var Y", choices = list(1,2,3))
#     selectizeInput("col","Choose Colors")
#   }          
# })


layer_tab <- tabPanel(
  "Layer",
  fluidRow(
#     column(4,
#            wellPanel(radioButtons("geoms", "Geoms", 
#                                   choices = list("geom_text", "geom_line", "geom_point"))),
#            actionButton("plot","Plot"),
#            actionButton("reset","Reset")),
    
    column(8,
           tabsetPanel(id="tabset",
                       tabPanel("Manage layers", 
                                checkboxInput("show_layer_1", "Display Layer 1", value=FALSE),
                                checkboxInput("show_layer_2", "Display Layer 2", value=FALSE),
                                checkboxInput("show_layer_3", "Display Layer 3", value=FALSE),
                                checkboxInput("show_layer_4", "Display Layer 4", value=FALSE),
                                checkboxInput("show_layer_5", "Display Layer 5", value=FALSE)),
#                        create_cond_layer_tab()
                       layer_1_cond,
                       layer_2_cond,
                       layer_3_cond,
                       layer_4_cond,
                       layer_5_cond 
                                
  
    )
  ))
)
=======
make_layer <- function(){
  wellPanel(
    selectizeInput("geoms", "Geoms", 
                   choices = list("geom_text" = 1, "geom_line" = 2, "geom_point" = 3)
    ),
    actionButton("plot","Plot"),
    actionButton("reset","Reset"),
    selectizeInput("x","Var X", choices = list(1,2,3)),
    selectizeInput("y","Var Y", choices = list(1,2,3))
  )  
}

layer_1_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_1 == true",
    "Layer 1"
  ), 
  make_layer()
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






>>>>>>> 0832a339b11e954b3aa4317b783b039e0c8fd58f
