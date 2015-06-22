# x <- c("maptools","ggmap","rgdal","ggplot2","rgeos","dplyr","tidyr","shiny", "mosaicData","DCF", "foreign")
# install.packages(x)
# lapply (x,library,character.only=TRUE)

#setwd("~/MOSAIC-Summer-2015/map")

# #China Data
China <- rgdal::readOGR(dsn = "www/China", "CopyOfch")
China.f <- ggplot2::fortify(China, region = "ADMIN_NAME")
# 
# # World Map Data
world <- rgdal::readOGR(dsn = "www/World", "CopyOfworld_country_admin_boundary_shapefile_with_fips_codes")
world.f <- ggplot2::fortify(world, region = "CNTRY_NAME")    #Convert to a form suited to ggplot
# 
#London data
sport <- rgdal::readOGR(dsn = "www/London", "CopyOflondon_sport")
# # fixes an error in the london_sport file
proj4string(sport) <- CRS("+init=epsg:27700")
sport.wgs84 <- spTransform(sport, CRS("+init=epsg:4326"))   #shape file
sport.wgs84.f <- fortify(sport.wgs84, region = "ons_label")
sport.wgs84.f <- left_join(sport.wgs84.f, sport.wgs84@data, by = c("id" = "ons_label"))

# p <- ggmap(get_map(location = "london", zoom = 10, source = "google", maptype = "roadmap", crop=FALSE) )
# pp <- p + geom_polygon(data = sport.wgs84.f, aes_string(x="long", y="lat",group = "group",fill = "Partic_Per"))
# ppp<-p + geom_path(data = sport.wgs84.f, aes_string(x="long", y="lat",group = "group",fill = "Partic_Per.x"), size = 1, color = "blue")

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


# ================= tileOutput ============================================  
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
  
  ggmap_frame <- reactive({
    p <- ggmap(get_map(location = input$location, zoom = input$zoom_num,
                       source = input$map_source, maptype = input$map_type, crop=FALSE))
               
    p
  })
  
  
  output$tileOutput <- renderPlot({
    if(is.null(input$location) || input$map_source == "None") {
      # make a bogus plot --- with text geom saying "Choose the stuff you need."
      # 
    } 
    else {
     ggmap_frame()  # don't need return??
    }
  })
  
  # ================= shapeOutput ============================================  
  ggplot_frame <- reactive({
    DC <- data_chosen()
    if (is.null(DC)) return(NULL)
    else {  p <- ggplot(data = DC,
                        aes_string(x="long", y="lat",group = "group"
                        ))} 
    p

  })
  
  output$shapeOutput <- renderPlot({
    if(shape_not_ready()) {
      # make a bogus plot --- with text geom saying "Choose the stuff you need."
    } 
    else {
      if (input$geom1 == "geom_path")
        P <- ggplot_frame() + geom_path()
      if (input$geom1 == "geom_polygon")
        P<- ggplot_frame() + geom_polygon()
      P
    }
  })
  
# ====================== entityOutput =========================
  shape_not_ready <- reactive({
    input$data_source == "None" || input$geom1 == "None"
  })
  
    observe({
      DC <- data2[[input$data_to_join]]
      #     if (is.null(DC)) return(NULL)
      updateSelectInput(session, inputId = "fill_var",
                        choices = names(DC)
      )
      
    })
    
    ggmap_geom <- reactive({
      if (input$geomEnt == "geom_polygon"){
        geom <- geom_polygon(data = data_chosen(), aes_string(x="long", y="lat",group = "group",fill = input$fill_var))
      }
      if (input$geomEnt == "geom_path"){
        geom <- geom_path(data = data_chosen(), aes_string(x="long", y="lat",group = "group")) #implement color and size (color = input$col, size = input$size)
      }
      
      geom
    })
   
    ggplot_geom <- reactive({
      if (input$geomEnt == "geom_path"){ 
        p <- geom_path()}
      if (input$geomEnt == "geom_polygon") {
        p <- geom_polygon(aes_string(fill = input$fill_var))
      }
    })   
    
  output$entityOutput <- renderPlot({
    # HOW TO Make entity data dependent on shapeOutput??
    if (shape_not_ready()){
      # USE A TEXTINPUT TO SHOW ERROR MESSAGE
    }
    
    if (input$data_to_join == "None"){
      # USE A TEXTINPUT TO SHOW ERROR MESSAGE 
      print("Please choose a dataset to join")
    }
    
    if (input$display_tile){
      p <- ggmap_frame() + ggmap_geom()
    } else{
#      browser()
      p <- ggplot_frame() + ggplot_geom()
    }
    p
    
  })
  
  
  
  
  #=================== positionOutput ===================
  
  
  
  
  
})