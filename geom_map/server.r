# x <- c("maptools","ggmap","rgdal","ggplot2","rgeos","dplyr","tidyr","shiny", "mosaicData","DCF", "foreign")
# install.packages(x)
# lapply (x,library,character.only=TRUE)


#China Data
China <- rgdal::readOGR(dsn = "www/China", "ch")
China.f <- ggplot2::fortify(China, region = "ADMIN_NAME")

# World Map Data
world <- rgdal::readOGR(dsn = "www/WorldCountries", "world_country_admin_boundary_shapefile_with_fips_codes")
world.f <- ggplot2::fortify(world, region = "CNTRY_NAME")    #Convert to a form suited to ggplot

data1 <- list ("China" = China.f, "World" = world.f, "London" = sport.wgs84.f)
data2 <- list ("China Pop" = China@data, "London Sports" = sport.wgs84@data)


shinyServer(function(input, output, session) {
  
  data_chosen <- reactive({
    tmp1 <- data1[[input$data_source]]
    tmp2 <- data2[[input$data_to_join]]
    
    #cann't plot without joining
    if(is.null(input$data_to_join)) {return (tmp1) }
    else {
      #browser()  #need a helper function to handle join
      data_joined<- left_join(tmp1, tmp2, by = c("id" = "ADMIN_NAME"))
      return (data_joined)
    }
    })
  
  
#   output$disp_aes_1 <- renderTable(layer_1_values$aes)
#   layer_1_values <- layer_n_values(1)
#  
#   observe({
# #     this_dataset() # for the dependency if data changes
#     frame_def$x <<- input$frame_x
#     frame_def$y <<- input$frame_y
#     frame_def$data <<- datasets
#   })
#  

  
# Let user choose from different maps    
  observe({   
    
    stamen <- list("terrain", "toner", "watercolor")
    google <- list ("roadmap", "terrain", "satellite", "hybrid") 
    
    #input$map_source must be character string
    relevant <- switch(input$map_source,
                       "stamen" = stamen,
                       "google" = google            
    )       
    
    updateSelectInput(session, inputId = "map_type",
                      choices = relevant
    )
    ### Update choices for fill
#     browser()
#     updateSelectInput(session, inputId = "fill_var",
#                       choices = names(data_chosen())
#     )
    
  })

  
  frame_for_plot <- reactive({
    # if (frame_def$x == "pick data set") return(NULL)
    if (input$plotFun == "1"){
      #browser()  #Note aes_string doesn't work
      p <- ggplot(data=data_chosen(),
                  aes(x=long, y=lat,group = group))} 
   
    if (input$plotFun == "2"){
      # browser() #input must all be character strings
      p <- ggmap(get_map(location = input$location, 
                    source = input$map_source, maptype = input$map_type, crop=FALSE) 
      )
    }
    return (p)
    
  })
  
  output$frame_plot <- renderPlot({
    if (input$geom1 == "geom_path")
      P <- frame_for_plot() + geom_path()
    if (input$geom1 == "geom_polygon")
      P<- frame_for_plot() + geom_polygon()
    
    #     if( !(input$show_layer_1 | input$show_layer_2 | input$show_layer_3) )
    #       P <- P + geom_blank()
    #     if( input$show_layer_1 ) 
    # P <- P + layer_1_glyphs()
    #     if( input$show_layer_2 )
    #       P <- P + layer_2_glyphs()
    #     if( input$show_layer_3 )
    #       P <- P + layer_3_glyphs()
    #     
    P
  })
  
#   
#   
# eventReactive( input$make_plot,
#   { ggmap(get_map(location = input$location, 
#                   source = input$map_source, maptype = input$map_type, crop=FALSE)
#           ) 
#   })
#   
  
#   observe({ 
#     # put the data into frame_def$data
#     #     data_name <- data_name()
#     frame_def$data <<- datasets
# #     frame_def$data_name <<- input$data_source
#     updateSelectInput(session, "frame_x", choices=names(frame_def$data))
#     updateSelectInput(session, "frame_y", choices=names(frame_def$data))
#   })
  
#   observe({ # the geom has been set or changed
#     if(frame_def$x != "bogus x") {
#       # remember, assignment is <<- for assignment at higher level        
#       layer_1_values$geom <<- input$geom1
#       
#       # pull in the old values
#       old <- layer_1_values$aes
#       
#       # keep those that are appropriate for new
#       relevant <- geom_aesthetics[[input$geom1]]
#       new_aes_table <<- 
#         new_aes_table_helper(names(relevant), old)
#       
#       # update the choices for mapping and setting
#       updateSelectInput(session, inputId="map1",
#                         choices = names(relevant))
#       
#       # Get names from frame data or, if it's set, layer data
#       variable_names <- if (is.null(layer_1_values$data)) names(data_chosen())
#       else names(layer_1_values$data)
#       # Set the x and y aesthetics if they haven't already been set.
#       x_ind <- which(new_aes_table$aes == 'x')
#       y_ind <- which(new_aes_table$aes == 'y')
#       new_aes_table$value[x_ind] <- frame_def$x
#       new_aes_table$value[y_ind] <- frame_def$y
#       new_aes_table$role[x_ind] <- "variable"
#       new_aes_table$role[y_ind] <- "variable"
#       # More control updates
#       updateSelectInput(session, inputId="var1",
#                         choices = c(variable_names,
#                                     "none of them"))
#       layer_1_values$aes <<- new_aes_table
#     }
#   })
  
  # These will need to be replicated for each layer  
#   observeEvent(input$do_map_1, {
#     ind <- which(input$map1 == layer_1_values$aes$aes)
#     layer_1_values$aes$value[ind] <<- 
#       ifelse("none of them" == input$var1, "", input$var1)
#     layer_1_values$aes$role[ind]  <<- 
#       ifelse("none of them" == input$var1, "", "variable")
#   }) 
#   
#   observeEvent(input$do_set_1, {
#     S <- input$set_val_1
#     S <- gsub('“', "", S)
#     S <- gsub('\"', "", S)
#     S <- gsub("'", "", S)
#     S <- gsub("‘", "", S)
#     S <- gsub(" ", "", S)
#     aes_name <- gsub("=.+$","",S)
#     aes_name <- gsub(" ", "", aes_name)
#     value <- gsub("^.+=","",S)
#     num_value <- as.numeric(value)
#     if( ! is.na(num_value)) value <- num_value
#     ind <- which(aes_name == layer_1_values$aes$aes)
#     if( length(ind) == 1 ) {
#       layer_1_values$aes$value[ind] <<- value
#       layer_1_values$aes$role[ind]  <<- "constant"
#     }
#   })
# # 
#   layer_1_glyphs <- reactive({
#     args <- make_geom_argument_list(layer_1_values$aes)
#     do.call(layer_1_values$geom, args)
#   })
#    
 
  
})