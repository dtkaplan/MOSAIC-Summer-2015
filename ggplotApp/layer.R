library("shiny")

make_layer <- function(n=1) {
  
  
}

layer_tab <- tabPanel(
  "Layer",
  tabsetPanel(
    tabPanel("Layer 1",
             column(4, 
                    wellPanel(
                      selectInput("geom1", "Geom for this layer:",
                                  choices = c(names(geom_aesthetics)),
                                  selected = "geom_blank"),
                      
                      wellPanel(
                        selectInput("map1", "Map aesthetic:", 
                                    choices = c("first, select geom")),
                        selectInput("var1", "Pick variable", choices=c(1,2,3)),
                        actionButton("do_map_1", "Map it!")
                      ),
                      
                      wellPanel(
                        textInput("set_val_1","Set aesthetic, e.g. color = 'red'"),
                        actionButton("do_set_1", "Set it!")  
                      )
                    )),
             
             column(8, 
                    wellPanel(
                      plotOutput("layer_1_plot")
                    ),
                    
                    wellPanel(
                      tableOutput("disp_aes_1")
                    )
             )),
    
    tabPanel("Layer 2"
    ),
    
    tabPanel("Layer 3")
  ))
