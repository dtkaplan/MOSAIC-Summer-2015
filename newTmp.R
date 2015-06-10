library("shiny")
source("layer_tab.R")

runApp(
  list(
    server = shinyServer(
      function(input, output, session) {
        observe({
          
          geom_line_options <- list("color","width")
          geom_point_options <- list("color", "size","alpha")
          geom_bar_options <- list("color","type","stat","position")
          
          choices <-switch(input$geoms,
                 "1" = geom_line_options,
                 "2" = geom_point_options,
                 "3" = geom_bar_options)
          
          updateSelectInput(session, "controls",
                            label = paste("Select aesthetics"),
                            choices = choices)
          
        })
      }),
    
    ui = shinyUI(
      fluidPage(
        layer_tab
      )
    )
    
  )
)






