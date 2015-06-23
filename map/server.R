# x <- c("maptools","ggmap","rgdal","ggplot2","rgeos","dplyr","tidyr","shiny", "mosaicData","DCF", "foreign")
# install.packages(x)
# lapply (x,library,character.only=TRUE)

#setwd("~/MOSAIC-Summer-2015/map")
`%then%` <- shiny:::`%OR%`

# #China Data
China <- rgdal::readOGR(dsn = "www/China", "CopyOfch")
China.f <- ggplot2::fortify(China, region = "ADMIN_NAME")
China_pop <- read.csv("~/MOSAIC-Summer-2015/map/www/China/China Provincial Pop.csv")


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

data1 <- list ("China" = China.f, "World" = world.f, "London" = sport.wgs84.f)
data2 <- list ("China Pop" = China@data, "London Sports" = sport.wgs84@data)


shinyServer(function(input, output, session) {
  
#   #A function that returns a datatable based on whether you choose to join a table or not
  data_chosen <- reactive({
    
    validate(
      need(input$data_source != "None", "A data source must be provided in shape panel") %then%
       need(input$data_to_join!= "None", label = "A dataset to join" )
    )
    
    tmp1 <- data1[[input$data_source]]
    tmp2 <- data2[[input$data_to_join]]
    
    if(input$data_to_join == "None") {return (tmp1) }
    else {
      #need a helper function to handle join
      if(input$data_to_join == "China Pop"){
        data_joined <- left_join(tmp1, tmp2, by = c("id" = "ADMIN_NAME"))
      }
      if(input$data_to_join == "London Sports"){
#        browser()
        data_joined <- left_join(tmp1, tmp2, by = c("id" = "ons_label"))
      }
      data_joined
    }
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
      need(input$location, "location must be provided in tile panel") %then%
        need(input$map_source != "None", "map source must be provided in tile panel" ) %then% 
        need(input$map_type != "None", "map type must be provided in tile panel" )
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
    DC <- data1[[input$data_source]]
    validate(  #check datasource
      need(input$data_source != "None", label = "a dataset")
    )
    p <- ggplot(data = DC,
                aes_string(x="long", y="lat",group = "group"
                ))
    p
    
  })
  
  output$shapeOutput <- renderPlot({
    p <- ggplot_frame()
    validate(
      need( input$geom1 != "None", label = "a layer"
      ))
    if (input$geom1 == "geom_path")
      p <- p + geom_path()
    if (input$geom1 == "geom_polygon")
      p <- p + geom_polygon()
    p
  })
  
# ====================== entityOutput =========================
    observe({
      data_chosen()
      updateSelectInput(session, inputId = "fill_var",
                        choices = names(data_chosen())
      )
      
    })
    
    ggmap_geom <- reactive({
      validate(
        need( input$geomEnt != "None", label = "a layer"
        ))
      if (input$geomEnt == "geom_polygon"){
        geom <- geom_polygon(data = data_chosen(), aes_string(x="long", y="lat",group = "group",fill = input$fill_var),
                             size = input$size, colour = input$col, alpha = input$alpha
                             )
      }
      #browser()
      if (input$geomEnt == "geom_path"){
        geom <- geom_path(data = data_chosen(), aes_string(x="long", y="lat",group = "group"),
                          size = input$size, colour = input$col, alpha = input$alpha, linetype = input$lt) 
        #implement color and size (color = input$col, size = input$size)
      }
      
      geom
    })

#     ggplot_geom <- reactive({
#       validate(
#         need( input$geomEnt != "None", label = "a layer"
#       ))
#       browser()
#       if (input$geomEnt == "geom_path"){ 
#         geom <- geom_path()}
#       if (input$geomEnt == "geom_polygon") {
#        geom <- geom_polygon(aes_string(fill = input$fill_var))
#       }
#       geom
#     })   
    
  output$entityOutput <- renderPlot({
    data_chosen()
    if (input$display_tile){
      p <- ggmap_frame() + ggmap_geom()
    } else{
      p <- ggplot_frame() + ggmap_geom()
    }
    p
    
  })


  #=================== positionOutput ===================
  
  output$positionOutput <- renderPlot({
    validate(
      need(input$pos_data != "None", label = "a position dataset") %then%
        need(input$geomPos != "None", label = "a layer")
    )
    
    p <- ggmap_frame()
    if (input$geomPos == "geom_point") {
      p <- p + geom_point(data = China_pop, aes_string(x = "lon", y = "lat",  size = "POP_ADMIN"), color = "blue")
    }
    p
  })
  
  
  ###Error message in UI
  #   output$errorEntity <- renderUI({
  #     if (shape_not_ready()) {
  #       tags$div(style="float:right; padding-right:10px; padding-top:10px; 
  #               color:Red; background-color:white; font-family:arial; font-size:20px",
  #                "Please first choose a dataset for shape panel")
  #       }
  #     if (tile_not_ready()){
  #       tags$div(style="float:right; padding-right:10px; padding-top:10px; 
  #               color:Red; background-color:white; font-family:arial; font-size:20px",
  #                "Please first choose a dataset for tile panel")
  #     }
  # 
  #   })
  
  #   shape_not_ready <- reactive({
  #     input$data_source == "None" || input$geom1 == "None"
  #   })
#   tile_not_ready <- reactive({
#     is.null(input$location) || input$map_source == "None" 
#   })
#   
  
  
})