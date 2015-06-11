
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(dplyr)
library(mosaicData)


new_aes_table_helper <- function(new_aes_names, old_aes_df) {
  new_df <- data.frame(aes=new_aes_names, stringsAsFactors=FALSE)
  dplyr::left_join(new_df, old_aes_df, by="aes")
}


shinyServer(function(input, output, session) {
  
  output$disp_aes_1 <- renderTable(layer_1_values$aes)
  
  observe({ # put the data into frame_def$data
    data_name <- input$data_source
    do.call(data, list(data_name, package="mosaicData") )
    frame_def$data <<- eval(parse(text=data_name))
    frame_def$data_name <<- data_name
    updateSelectInput(session, "frame_x", choices=names(frame_def$data))
    updateSelectInput(session, "frame_y", choices=names(frame_def$data))
  })
  
  observe({
    input$data_source # for dependencies
    frame_def$x <<- input$frame_x
    frame_def$y <<- input$frame_y
  })
  
  observe({ # the geom has been set or changed
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
    updateSelectInput(session, inputId="set1",
                      choices = names(relevant))
    layer_1_values$aes <<- new_aes_table
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
  
  
  
  output$layer_1_plot <- renderPlot({
    args <- make_geom_argument_list(layer_1_values$aes)
    if (frame_def$x == "pick data set") return(NULL)
    ggplot(data=frame_def$data, 
           aes_string(x=frame_def$x, y=frame_def$y)) +
      do.call(layer_1_values$geom, args)
  })

})
