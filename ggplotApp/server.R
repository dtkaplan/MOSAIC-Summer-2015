library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)



#datasets <- as.list(data(package="mosaicData")$results[,"Item"])

# JUST FOR DEBUGGING
shinyServer(function(input, output, session) {
  
  # ===============================
  # Data reading reactives
  #
  this_dataset <- reactive({
    if (is.null(input$data_own) || input$file_or_package == "1") 
      Tmp <- datasets[[input$package_data_name]]
    else
      Tmp <- get_uploaded_data()
    
    if(input$random_subset){ # grab a random subset
      Tmp <- dplyr::sample_n(Tmp, size=input$random_subset_nrow)
    }
    
    Tmp    
  })
  
  get_uploaded_data <- reactive({
    if (is.null(input$data_own)) {
      # User has not uploaded a file yet
      Dataset <- data.frame()
    } else {
      Dataset <- read.csv(input$data_own$datapath, #data.table::fread(), readr::readr()
                          stringsAsFactors=FALSE)
    }
    
    Dataset
  })
  
  data_name <- reactive({
    input$package_data_name
    # CHANGE NEEDED
    # This needs to be changed to get the name of the csv file, if that's how data were loaded.
  })
  
  # ===================================
  # Interface between UI and plotting data structures and logic
  #
  observe({
    this_dataset() # for the dependency if data changes
    frame_def$x <<- input$frame_x
    frame_def$y <<- input$frame_y
  })
  
  
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
  
  # ==== SAME STUFF BUT DUPLICATED FOR LAYER 2=====================================
  observe({ # the geom has been set or changed
    if(frame_def$x != "bogus x") {
      # remember, assignment is <<- for assignment at higher level
      layer_2_values$geom <<- input$geom2 
      # pull in the old values
      old <- layer_2_values$aes
      
      # keep those that are appropriate for new
      relevant <- geom_aesthetics[[input$geom2]]
      new_aes_table <<- 
        new_aes_table_helper(names(relevant), old)
      
      # update the choices for mapping and setting
      updateSelectInput(session, inputId="map2",
                        choices = names(relevant))
      # Get names from frame data or, if it's set, layer data
      variable_names <- if (is.null(layer_2_values$data)) names(frame_def$data)
      else names(layer_2_values$data)
      # Set the x and y aesthetics if they haven't already been set.
      x_ind <- which(new_aes_table$aes == 'x')
      y_ind <- which(new_aes_table$aes == 'y')
      new_aes_table$value[x_ind] <- frame_def$x
      new_aes_table$value[y_ind] <- frame_def$y
      new_aes_table$role[x_ind] <- "variable"
      new_aes_table$role[y_ind] <- "variable"
      # More control updates
      updateSelectInput(session, inputId="var2",
                        choices = c(variable_names,
                                    "none of them"))
      updateSelectInput(session, inputId="map2",
                        choices = names(relevant))
      layer_2_values$aes <<- new_aes_table
    }
  })
  
#   These will need to be replicated for each layer  
  observeEvent(input$do_map_2, {
    ind <- which(input$map2 == layer_2_values$aes$aes)
    layer_2_values$aes$value[ind] <<- 
      ifelse("none of them" == input$var2, "", input$var2)
    layer_2_values$aes$role[ind]  <<- 
      ifelse("none of them" == input$var2, "", "variable")
  }) 
  
  observeEvent(input$do_set_2, {
    S <- input$set_val_2
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
    ind <- which(aes_name == layer_2_values$aes$aes)
    if( length(ind) == 1 ) {
      layer_2_values$aes$value[ind] <<- value
      layer_2_values$aes$role[ind]  <<- "constant"
    }
  })
  
  
 # ==== When that works, then add in Layer 3
  
  observe({ # the geom has been set or changed
    if(frame_def$x != "bogus x") {
      # remember, assignment is <<- for assignment at higher level
      layer_3_values$geom <<- input$geom3 
      # pull in the old values
      old <- layer_3_values$aes
      
      # keep those that are appropriate for new
      relevant <- geom_aesthetics[[input$geom3]]
      new_aes_table <<- 
        new_aes_table_helper(names(relevant), old)
      
      # update the choices for mapping and setting
      updateSelectInput(session, inputId="map3",
                        choices = names(relevant))
      # Get names from frame data or, if it's set, layer data
      variable_names <- if (is.null(layer_3_values$data)) names(frame_def$data)
      else names(layer_3_values$data)
      # Set the x and y aesthetics if they haven't already been set.
      x_ind <- which(new_aes_table$aes == 'x')
      y_ind <- which(new_aes_table$aes == 'y')
      new_aes_table$value[x_ind] <- frame_def$x
      new_aes_table$value[y_ind] <- frame_def$y
      new_aes_table$role[x_ind] <- "variable"
      new_aes_table$role[y_ind] <- "variable"
      # More control updates
      updateSelectInput(session, inputId="var3",
                        choices = c(variable_names,
                                    "none of them"))
      updateSelectInput(session, inputId="map3",
                        choices = names(relevant))
      layer_3_values$aes <<- new_aes_table
    }
  })
  
  # These will need to be replicated for each layer  
  observeEvent(input$do_map_3, {
    ind <- which(input$map1 == layer_3_values$aes$aes)
    layer_3_values$aes$value[ind] <<- 
      ifelse("none of them" == input$var3, "", input$var3)
    layer_3_values$aes$role[ind]  <<- 
      ifelse("none of them" == input$var3, "", "variable")
  }) 
  
  observeEvent(input$do_set_3, {
    S <- input$set_val_3
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
    ind <- which(aes_name == layer_3_values$aes$aes)
    if( length(ind) == 1 ) {
      layer_3_values$aes$value[ind] <<- value
      layer_3_values$aes$role[ind]  <<- "constant"
    }
  })
  
  
  # ===================================
  # Display outputs
  
  # fill in the display in the data selection panel
  output$table <- renderDataTable({ this_dataset() })
  
  output$disp_aes_1 <- renderTable(layer_1_values$aes)
  output$disp_aes_2 <- renderTable(layer_2_values$aes)
  output$disp_aes_3 <- renderTable(layer_3_values$aes)
  
  observe({ # put the data into frame_def$data
    data_name <- data_name()
    frame_def$data <<- this_dataset()
    frame_def$data_name <<- data_name
    updateSelectInput(session, "frame_x", choices=names(frame_def$data))
    updateSelectInput(session, "frame_y", choices=names(frame_def$data))
  })
  
  layer_1_glyphs <- reactive({
    args <- make_geom_argument_list(layer_1_values$aes)
    do.call(layer_1_values$geom, args)
  })
  
  layer_2_glyphs <- reactive({
    args <- make_geom_argument_list(layer_2_values$aes)
    do.call(layer_2_values$geom, args)
  })
  
  layer_3_glyphs <- reactive({
    args <- make_geom_argument_list(layer_3_values$aes)
    do.call(layer_3_values$geom, args)
  })
  
  frame_for_plot <- reactive({
    ## Why the return(NULL) here?  is this a BOGUS STOP POINT?
    if (frame_def$x == "pick data set") return(NULL)
    ggplot(data=frame_def$data, 
           aes_string(x=frame_def$x, y=frame_def$y))
  })
  
  
  output$frame_plot <- renderPlot({
    P <- frame_for_plot() 
    if( !(input$show_layer_1 | input$show_layer_2 | input$show_layer_3) )
      P <- P + geom_blank()
    if( input$show_layer_1 ) 
      P <- P + layer_1_glyphs()
    if( input$show_layer_2 )
      P <- P + layer_2_glyphs()
    if( input$show_layer_3 )
      P <- P + layer_3_glyphs()
    # and similarly for layer 3
    
    P
  })
  
  output$layer_1_plot <- renderPlot({
    frame_for_plot() + layer_1_glyphs()
  })
  
  output$layer_2_plot <- renderPlot({
    frame_for_plot() + layer_2_glyphs()
  })
  
  output$layer_3_plot <- renderPlot({
    frame_for_plot() + layer_3_glyphs()
  })
  
})


# ============== Server and Observers ============
# shinyServer(
foo <-   function(input,output,session){

  
 
  

  


  
}