# x <- c("maptools","ggmap","rgdal","ggplot2","rgeos","dplyr","tidyr","shiny", "mosaicData","DCF", "foreign")
# install.packages(x)
# lapply (x,library,character.only=TRUE)


#China Data
China <- rgdal::readOGR(dsn = "www/China", "ch")
#China.f <- ggplot2::fortify(China, region = "ADMIN_NAME")

# World Map Data
world <- rgdal::readOGR(dsn = "www/WorldCountries", "world_country_admin_boundary_shapefile_with_fips_codes")
<<<<<<< HEAD
#world.f <- ggplot2::fortify(world, region = "CNTRY_NAME")    #Convert to a form suited to ggplot
=======
world.f <- ggplot2::fortify(world, region = "CNTRY_NAME")    #Convert to a form suited to ggplot
>>>>>>> 583c5dc278787ef4633282a35ef8cacbb2a3b220

data1 <- list ("China" = China.f, "London" = sport.wgs84.f)
data2 <- list ("China Pop" = China@data, "London Sports" = sport.wgs84@data)


shinyServer(function(input, output, session) {
  
  #A function that returns a datatable based on whether you choose to join a table or not
  data_chosen <- reactive({
    tmp1 <- data1[[input$data_source]]
    tmp2 <- data2[[input$data_to_join]]
    
    if(input$data_to_join == "None") {return (tmp1) }
    else {
    #need a helper function to handle join
      if(input$data_to_join == "China Pop"){
        data_joined <- left_join(tmp1, tmp2, by = c("id" = "ADMIN_NAME"))
      }
      if(input$data_to_join == "London Sports"){
        data_joined<- left_join(tmp1, tmp2, by = c("id" = "ons_label"))
      }
    data_joined
    }
    })

  
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

  })
  
  observe({
    DC <- data_chosen()
#     if (is.null(DC)) return(NULL)
    updateSelectInput(session, inputId = "fill_var",
                      choices = names(DC)
    )
    
  })
  
  frame_for_plot <- reactive({
    #browser()
    DC <- data_chosen()
    if (is.null(DC)) return(NULL)
    if (input$plotFun == "1"){
      p <- ggplot(data = DC,
                  aes_string(x="long", y="lat",group = "group"
                  ))}  
   
    if (input$plotFun == "2"){
      p <- ggmap(get_map(location = input$location, zoom = as.numeric(input$zoom_num),
                    source = input$map_source, maptype = input$map_type, crop=FALSE) 
      )
    }
    return (p)
  })
  
  output$frame_plot <- renderPlot({
    Frame <- frame_for_plot()
    if(is.null(Frame)) {
      # make a bogus plot --- with text geom saying "Choose the stuff you need."
    } 
    if (input$plotFun == "2") return(Frame)
    if (input$geom1 == "geom_path"){ 
      Frame <- frame_for_plot() + geom_path()}
    if (input$geom1 == "geom_polygon") {
      Frame <- frame_for_plot() + geom_polygon(aes_string(fill = input$fill_var))
    }
    
    return (Frame)
    
  })
  
})