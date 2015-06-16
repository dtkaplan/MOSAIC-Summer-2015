library("shiny")

make_layer <- function(n) {
  
  label <- paste("Layer",n)
  geom_id <- paste0("geom",n)
  select_map_id <- paste0("map",n)
  select_var_id <- paste0("var",n)
  act_map_id <- paste0("do_map_",n)
  set_var_id <- paste0("set_val_",n)
  act_var_id <- paste0("do_set_",n)
  plot_id <- paste0("layer_",n,"_plot")
  table_id <- paste0("disp_aes_",n)
  
  tabPanel(label,
           column(4,
                  selectInput(geom_id, "Geom for this layer:",
                              choices = c(names(geom_aesthetics)),
                              selected = "geom_blank"),
                  wellPanel(
                    selectInput(select_map_id, "Map aesthetic:", 
                                choices = c("first, select geom")),
                    selectInput(select_var_id, "Pick variable", choices=c(1,2,3)),
                    actionButton(act_map_id, "Map it!")
                  ),
                  
                  wellPanel(
                    textInput(set_var_id,"Set aesthetic, e.g. color = 'red'"),
                    actionButton(act_var_id, "Set it!") 
                  )
           ),
           column(8, 
                  wellPanel(
                    plotOutput(plot_id)
                  ),
                  
                  wellPanel(
                    tableOutput(table_id)
                  )
           )
  )
  
}

layer_tab <- tabPanel(
  "Layer",
  tabsetPanel(
    make_layer(1),
    make_layer(2),
    make_layer(3)
    )
)
  




# layer_tab <- tabPanel(
#   "Layer",
#   tabsetPanel(
#     tabPanel("Layer 1",
#              column(4, 
#                     wellPanel(
#                       selectInput("geom1", "Geom for this layer:",
#                                   choices = c(names(geom_aesthetics)),
#                                   selected = "geom_blank"),
#                       
#                       wellPanel(
#                         selectInput("map1", "Map aesthetic:", 
#                                     choices = c("first, select geom")),
#                         selectInput("var1", "Pick variable", choices=c(1,2,3)),
#                         actionButton("do_map_1", "Map it!")
#                       ),
#                       
#                       wellPanel(
#                         textInput("set_val_1","Set aesthetic, e.g. color = 'red'"),
#                         actionButton("do_set_1", "Set it!")  
#                       )
#                     )),
#              
#              column(8, 
#                     wellPanel(
#                       plotOutput("layer_1_plot")
#                     ),
#                     
#                     wellPanel(
#                       tableOutput("disp_aes_1")
#                     )
#              )),
#     
#     tabPanel("Layer 2"
#     ),
#     
#     tabPanel("Layer 3")
#   ))
