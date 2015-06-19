library("shiny")
source("layer_tab.R")

runApp(
  list(
    server = shinyServer(
      function(input, output, session) {

        geom_line_options <- list("color" = 1,"width" = 2)
        geom_point_options <- list("color" = 1, "size" = 3,"alpha" = 4)
        geom_bar_options <- list("color" = 1,"type" = 5,"stat" = 6,"position" = 7)
    
        updateAesthetics <- function(n){                                
          # The function takes an input n. It updates the choices of aesthetics based on the type of geom
          # chosen by the user. 
                  
          id <- paste0("geoms",n)
          controlId <- paste0("controls",n)
          
          observe({          
            choices <-switch(input[[id]],
                             "1" = geom_line_options,
                             "2" = geom_point_options,
                             "3" = geom_bar_options)
            
            updateSelectInput(session, controlId,
                              label = paste("Select aesthetics"),
                              choices = choices)
          })
          
          conditionalPanel(condition = "input.controlId == 1",
                           sliderInput("size", "Please select a size", min = 1, max = 10, value = 1)
          )      
          
        } 
        
        for (i in 1:5){
          updateAesthetics(i)
        }
        
        
      }),
    
    ui = shinyUI(
      fluidPage(
        layer_tab
      )
    )
    
  )
)






