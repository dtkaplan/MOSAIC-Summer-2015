# x <- c("maptools","ggmap","rgdal","ggplot2","rgeos","dplyr","tidyr","shiny", "foreign")
# install.packages(x)
# lapply (x,library,character.only=TRUE)


shinyServer(function(input, output, session) {

  # A function that returns a datatable based on whether you choose to join a table or not
  ent_data_joined <- reactive({
    validate(
      need(input$data_source != "None", "A data source must be provided in shape panel")  %then%
        need(input$ent_data_to_join != "None", label = "A entity dataset")
    )
    # browser()
    tmp1 <- get(input$data_source)

    if (input$ent_data_to_join != "None") {
      tmp3 <- get(input$ent_data_to_join)
      validate(
        need(any(unique(tmp1$id) %in% unique(tmp3$id)), "Please choose two datasets that are valid to join")
      )
      ent_joined <- left_join(tmp1, tmp3, by = "id")
      return(ent_joined)
    }
  })

  pos_data_joined <- reactive({
    validate(
      need(input$data_source != "None", "A data source must be provided in shape panel") %then%
        need(input$pos_data_to_join != "None", label = "A position dataset")
    )
    #     browser()
    tmp1 <- get(input$data_source)

    if (input$pos_data_to_join != "None") {
      tmp2 <- get(input$pos_data_to_join)
      validate(
        need(any(unique(tmp1$id) %in% unique(tmp2$id)), "Please choose two datasets that are valid to join")
      )
      pos_joined <- left_join(tmp1, tmp2, by = "id")

    }
    pos_joined

  })



  # ================= tileOutput ============================================
  # Let user choose from different maps
  observe({
    stamen <- list("terrain", "toner", "watercolor")
    google <- list ("roadmap", "terrain", "satellite", "hybrid")

    relevant <- switch(input$map_source,
                       "stamen" = stamen,
                       "google" = google
    )

    updateSelectInput(session, inputId = "map_type",
                      choices = relevant
    )
  })

  ggmap_frame <- reactive({
    validate( #check ggmap location and source
      need(input$location, "Location must be provided in tile panel") %then%
        need(input$map_source != "None", "Map source must be provided in tile panel" ) %then%
        need(input$map_type != "None", "Map type must be provided in tile panel" )
    )

    p <- ggmap::ggmap(get_map(location = input$location, zoom = input$zoom_num,
                              source = input$map_source, maptype = input$map_type, crop=FALSE))
    p
  })

  output$tileOutput <- renderPlot({
    ggmap_frame()

  })

  # ================= shapeOutput ============================================
  ggplot_frame <- reactive({
    validate(  #check datasource
      need(input$data_source != "None", label = "A dataset")
    )

    tmp1 <- get(input$data_source)

    p <- ggplot(data = tmp1,
                aes_string(x="long", y="lat",group = "group"
                ))
    p

  })

  output$shapeOutput <- renderPlot({
    p <- ggplot_frame()
    validate(
      need( input$geom1 != "None", label = "A layer"
      ))

    if (input$geom1 == "geom_path")
      p <- p + geom_path()
    if (input$geom1 == "geom_polygon")
      p <- p + geom_polygon()
    p
  })

  # ====================== entityOutput =========================
  observe({
    #browser()
    ent_data_joined()
    updateSelectInput(session, inputId = "fill_var",
                      choices = names(ent_data_joined())  #update not working
    )

  })

  ggmap_geom <- reactive({
    validate(
      need( input$geomEnt != "None", label = "A layer"
      ))
    if (input$geomEnt == "geom_polygon"){
      geom <- geom_polygon(data =  ent_data_joined(), aes_string(x="long", y="lat",group = "group",fill = input$fill_var),
                           size = input$size, colour = input$col, alpha = input$alpha, linetype = input$lt
      )
    }
    if (input$geomEnt == "geom_path"){
      geom <- geom_path(data =  ent_data_joined(), aes_string(x="long", y="lat",group = "group"),
                        size = input$size, colour = input$col, alpha = input$alpha, linetype = input$lt)
    }

    geom
  })

  output$entityOutput <- renderPlot({
    ent_data_joined()
    validate(
      need(input$ent_data_to_join != "None", label = "Entity data to join"
      ))

    if (input$display_tile){
      p <- ggmap_frame() + ggmap_geom()
    } else{
      p <- ggplot_frame() + ggmap_geom()
    }
    p

  })


  #=================== positionOutput ===================

  output$positionOutput <- renderPlot({
    pos_data_joined()
    validate(
      need(input$geomPos != "None", label = "A layer")
    )

    p <- ggmap_frame()
    if (input$geomPos == "geom_point") {
      p <- p + geom_point(data = pos_data_joined(), aes_string(x = "long", y = "lat",  size = "POP_ADMIN"), color = "blue")
    }
    p
  })


})
