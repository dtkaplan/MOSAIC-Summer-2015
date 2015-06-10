library("shiny")
source("layer_tab.R")

runApp(
  list(
    server = shinyServer(
      function(input, output, session) {

        geom_line_options <- list("color","width")
        geom_point_options <- list("color", "size","alpha")
        geom_bar_options <- list("color","type","stat","position")
        
    
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






