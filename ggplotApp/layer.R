make_layer <- function(n) {
  #The function takes an input n and create layer panel. It will assign unique Id to each input in each layer 
  label <- paste("Layer",n)
  geom_id <- paste0("geom",n)
  select_map_id <- paste0("map",n)
  select_var_id <- paste0("var",n)
  act_map_id <- paste0("do_map_",n)
  set_var_id <- paste0("set_val_",n)
  act_var_id <- paste0("do_set_",n)
  plot_id <- paste0("layer_",n,"_plot")
  table_id <- paste0("disp_aes_",n)
  icon_id <- paste0("icon",n)
  
  tabPanel(label,
           column(4,
                  selectInput(geom_id, "Geom for this layer:",
                                choices = c(names(geom_aesthetics)),
                                selected = "geom_blank"),
                    imageOutput(icon_id),
                  
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
  

