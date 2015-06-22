# x <- c("maptools","ggmap","rgdal","ggplot2","rgeos","dplyr","tidyr","shiny", "mosaicData","DCF", "foreign")
# install.packages(x)
# lapply (x,library,character.only=TRUE)

#setwd("~/MOSAIC-Summer-2015/map")

# #China Data
# China <- rgdal::readOGR(dsn = "www/China", "CopyOfch")
# China.f <- ggplot2::fortify(China, region = "ADMIN_NAME")
# 
# # World Map Data
# world <- rgdal::readOGR(dsn = "www/WorldCountries", "CopyOfworld_country_admin_boundary_shapefile_with_fips_codes")
# world.f <- ggplot2::fortify(world, region = "CNTRY_NAME")    #Convert to a form suited to ggplot
# 
#London data
# Read in the shapefile
# sport <- rgdal::readOGR(dsn = "www/London", "london_sport")
# # fixes an error in the london_sport file
# proj4string(sport) <- CRS("+init=epsg:27700")
# sport.f <- ggplot2::fortify(sport, region = "ons_label")
# sport.f <- merge(sport.f, sport@data, by.x = "id", by.y = "ons_label")
# sport.wgs84 <- spTransform(sport, CRS("+init=epsg:4326"))   #shape file
# sport.wgs84.f <- fortify(sport.wgs84, region = "ons_label")
# sport.wgs84.f <- merge(sport.wgs84.f, sport.wgs84@data, by.x = "id", by.y = "ons_label")
# 

data1 <- list ("China" = China.f, "World" = world.f, "London" = sport.wgs84.f)
data2 <- list ("China Pop" = China@data, "London Sports" = sport.wgs84@data)


shinyServer(function(input, output, session) {
  
#   #A function that returns a datatable based on whether you choose to join a table or not
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
#   
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
    
  })

# ================= tileOutput ============================================  
  output$tileOutput <- renderPlot({
    if(is.null(input$location) || input$map_source == "None") {
      # make a bogus plot --- with text geom saying "Choose the stuff you need."
      # ggplot() + 
    } 
    else {
      p <- ggmap(get_map(location = input$location, zoom = input$zoom_num,
                         source = input$map_source, maptype = input$map_type, crop=FALSE) 
      )
    }
    
    return (p)
  })
  
  
  # ================= shapeOutput ============================================  
  frame_for_plot <- reactive({
    #browser()
    # DC <- data1[[input$data_source]]
    DC <- data_chosen()
    if (is.null(DC)) return(NULL)
    else {  p <- ggplot(data = DC,
                        aes_string(x="long", y="lat",group = "group"
                        ))} 
    p

  })
  
  output$shapeOutput <- renderPlot({
    #browser()
    if(input$data_source == "None" || input$geom1 == "None") {
      # make a bogus plot --- with text geom saying "Choose the stuff you need."
    } 
    else {
      if (input$geom1 == "geom_path")
        P <- frame_for_plot() + geom_path()
      if (input$geom1 == "geom_polygon")
        P<- frame_for_plot() + geom_polygon()
      P
    }
  })
  
  
# ====================== entityOutput =========================
  
    observe({
      DC <- data2[[input$data_to_join]]
      #     if (is.null(DC)) return(NULL)
      updateSelectInput(session, inputId = "fill_var",
                        choices = names(DC)
      )
      
    })
   
  output$entityOutput <- renderPlot({
    # HOW TO Make entity data dependent on shapeOutput??
#     if (is.null(output$shapeOutput)){
#       print("warning message: you need a shape as a frame in order to plot entity data")
#     }
    
    if (input$data_to_join == "None"){
      print("Please choose a dataset to join")
    }
   
    if (input$geomEnt == "geom_path"){ 
      p <- frame_for_plot() + geom_path()}
    if (input$geomEnt == "geom_polygon") {
      p <- frame_for_plot() + geom_polygon(aes_string(fill = input$fill_var))
    }
    p
    
  })
  
  #=================== positionOutput ===================
  
  
  
  
  
})