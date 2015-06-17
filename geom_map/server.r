shinyServer(function(input, output, session) {
  
  output$disp_aes_1 <- renderTable(layer_1_values$aes)
  layer_1_values <- layer_n_values(1)
  
  observe({
#     this_dataset() # for the dependency if data changes
    
    frame_def$x <<- input$frame_x
    frame_def$y <<- input$frame_y
    frame_def$data <<- datasets
  })
  
# Let user choose from different maps    
stamen_opts <- list("terrain", "toner", "watercolor") 
google_opts <- list ("roadmap", "terrain", "satellite", "hybrid") 

observe({          
  choices <-switch(input$map_source,
                   "1" = stamen_opts,
                   "2" = google_opts,
  )
  
  updateSelectInput(session, input$map_type,
                    label = paste("Choose map_type"),
                    choices = choices)
})


#   observe({ 
#     # put the data into frame_def$data
#     #     data_name <- data_name()
#     frame_def$data <<- datasets
# #     frame_def$data_name <<- input$data_source
#     updateSelectInput(session, "frame_x", choices=names(frame_def$data))
#     updateSelectInput(session, "frame_y", choices=names(frame_def$data))
#   })
  
  observe({ # the geom has been set or changed
    if(frame_def$x != "bogus x") {
      # remember, assignment is <<- for assignment at higher level        
      layer_1_values$geom <<- input$geom1
      
      # pull in the old values
      old <- layer_1_values$aes
      
      # keep those that are appropriate for new
      relevant <- geom_aesthetics[[input$geom1]]
      new_aes_table <<- 
        new_aes_table_helper(names(relevant), old)
      
      # update the choices for mapping and setting
      updateSelectInput(session, inputId="map1",
                        choices = names(relevant))
      # Get names from frame data or, if it's set, layer data
      variable_names <- if (is.null(layer_1_values$data)) names(frame_def$data)
      else names(layer_1_values$data)
      # Set the x and y aesthetics if they haven't already been set.
      x_ind <- which(new_aes_table$aes == 'x')
      y_ind <- which(new_aes_table$aes == 'y')
      new_aes_table$value[x_ind] <- frame_def$x
      new_aes_table$value[y_ind] <- frame_def$y
      new_aes_table$role[x_ind] <- "variable"
      new_aes_table$role[y_ind] <- "variable"
      # More control updates
      updateSelectInput(session, inputId="var1",
                        choices = c(variable_names,
                                    "none of them"))
      updateSelectInput(session, inputId="map1",
                        choices = names(relevant))
      layer_1_values$aes <<- new_aes_table
    }
  })
  
  # These will need to be replicated for each layer  
  observeEvent(input$do_map_1, {
    ind <- which(input$map1 == layer_1_values$aes$aes)
    layer_1_values$aes$value[ind] <<- 
      ifelse("none of them" == input$var1, "", input$var1)
    layer_1_values$aes$role[ind]  <<- 
      ifelse("none of them" == input$var1, "", "variable")
  }) 
  
  observeEvent(input$do_set_1, {
    S <- input$set_val_1
    S <- gsub('“', "", S)
    S <- gsub('\"', "", S)
    S <- gsub("'", "", S)
    S <- gsub("‘", "", S)
    S <- gsub(" ", "", S)
    aes_name <- gsub("=.+$","",S)
    aes_name <- gsub(" ", "", aes_name)
    value <- gsub("^.+=","",S)
    num_value <- as.numeric(value)
    if( ! is.na(num_value)) value <- num_value
    ind <- which(aes_name == layer_1_values$aes$aes)
    if( length(ind) == 1 ) {
      layer_1_values$aes$value[ind] <<- value
      layer_1_values$aes$role[ind]  <<- "constant"
    }
  })

  layer_1_glyphs <- reactive({
    args <- make_geom_argument_list(layer_1_values$aes)
    do.call(layer_1_values$geom, args)
  })
  
frame_for_plot <- reactive({
  ## Why the return(NULL) here?  is this a BOGUS STOP POINT?
  if (frame_def$x == "pick data set") return(NULL)
  if (input$plotFun == 1){
    browser()
    ggplot(data=frame_def$data, 
           aes_string(x=frame_def$x, y=frame_def$y, group = frame_def$data$group))
  }
  if (input$plotFun == 2){
    ggmap(get_map(location = input$location, 
                  source= input$map_source, maptype=input$map_type, crop=FALSE) 
    )
  }  
})
  
  output$frame_plot <- renderPlot({
    P <- frame_for_plot() 
#     if( !(input$show_layer_1 | input$show_layer_2 | input$show_layer_3) )
#       P <- P + geom_blank()
#     if( input$show_layer_1 ) 
      P <- P + layer_1_glyphs()
#     if( input$show_layer_2 )
#       P <- P + layer_2_glyphs()
#     if( input$show_layer_3 )
#       P <- P + layer_3_glyphs()
#     
    P
  })
  
})