library(mosaicData)
library(mosaicMapShapes)


`%then%` <- shiny:::`%OR%`


lst <- mosaicMapShapes::list_shapefiles()$name
data_lst <- paste0(lst,"_data")           #provide choices for input$data_source
shapes_lst <- paste0(lst,"_shapes")    #provide choices for input$ent_data_to_join & input$pos_data_to_join


geom_aesthetics <- list(
  geom_path = list(color = "any", group = "any", linetype = "few", size = "num_or_few", alpha="num_or_few"
  ),
  geom_polygon = list(color = "any", group = "any", fill = "few", linetype = "few", size = "num_or_few", alpha="num_or_few"
  ),
  geom_point = list(x = "any", y = "any", color = "num_or_few", size = "num_or_few",
                    alpha = "num_or_few", fill = "few", shape = "few"
  )

)


