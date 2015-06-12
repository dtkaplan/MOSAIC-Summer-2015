library("shiny")

# layer_1_cond <- tabPanel(conditionalPanel(
#   condition = "input.show_layer_1 == true",
#   "Layer 1"), plotOutput("l1_plot")
#   )
# 
# layer_2_cond <- tabPanel(conditionalPanel(
#   condition = "input.show_layer_2 == true",
#   tabPanel("l2", "Layer 2"))) 
# 
# layer_3_cond <- tabPanel(conditionalPanel(
#   condition = "input.show_layer_3 == true",
#   tabPanel("l3","Layer 3")))
# 
# layer_4_cond <- tabPanel(conditionalPanel(
#   condition = "input.show_layer_4 == true",
#   tabPanel("l4", "Layer 4")))
# 
# layer_5_cond <- tabPanel(conditionalPanel(
#   condition = "input.show_layer_5 == true",
#   tabPanel("l5", "Layer 5")))

layer_tab <- tabPanel(
  "Layer",
  tabsetPanel(
    tabPanel("Layer 1",
             column(4, 
                    wellPanel(
                      selectInput("geom1", "Geom for this layer:",
                                  choices = c(names(geom_aesthetics)),
                                  selected = "geom_blank"),
                      tableOutput("disp_aes_1"),
                      
                      wellPanel(
                        selectInput("map1", "Map aesthetic:", 
                                    choices = c("first, select geom")),
                        selectInput("var1", "Pick variable", choices=c(1,2,3)),
                        actionButton("do_map_1", "Map it!")
                      ),
                      
                      wellPanel(
                        textInput("set_val_1","Set aesthetic, e.g. color = 'red'"),
                        actionButton("do_set_1", "Set it!")  
                      ),
                      
                      wellPanel(
                        tableOutput("disp_aes_1")
                      )
                    )),
             
             column(8, 
                    wellPanel("This is where the plot is")
             )),
    
    #                        layer_1_cond,
    #                        layer_2_cond,
    #                        layer_3_cond,
    #                        layer_4_cond,
    #                        layer_5_cond
    
    tabPanel("Layer 2"
    ),
    
    tabPanel("Layer 3")
  ))
