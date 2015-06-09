library("shiny")
source("layer_tab.R")

runApp(
  list(
    server = shinyServer(
      function(input, output, session) {
    
        
        #         geom_list <- reactive({
        #           if (input$geoms == NULL) {
        #             print("Please choose a geom")
        #           }
        #           else {
        # selectizeInput("x","Var X", choices = list(1,2,3)),
        # selectizeInput("y","Var Y", choices = list(1,2,3))
        #             selectizeInput("col","Choose Colors")
        #           }          
        #         })
        
#         output$ui <- renderUI({
#           while (input$show_layer_1 || input$show_layer_2) { 
#             make_layer()
#             
#           }
#         })
          
      }),
    
    ui = shinyUI(
      fluidPage(
        layer_tab
      )
    )
    
  )









)



# make_layer <- function(){
#   layer <- tabPanel("layer n",
#                     wellPanel(selectizeInput("geoms", "Geoms", 
#                                              choices = list("geom_text" = 1, "geom_line" = 2, "geom_point" = 3)
#                     ),
#                     actionButton("plot","Plot"),
#                     actionButton("reset","Reset")
#                     #                             geom_list(),
# #                     conditionalPanel(
# #                       condition = "input.geoms == 1",
# #                       selectizeInput("x","Var X", choices = list(1,2,3)),
# #                       selectizeInput("y","Var Y", choices = list(1,2,3))
# #                     ) 
#                     )    
#                     
#                     
#   )       
#   
#   return (layer)
# }  


make_layer <- function(){
  wellPanel(
    selectizeInput("geoms", "Geoms", 
                   choices = list("geom_text" = 1, "geom_line" = 2, "geom_point" = 3)
    ),
    actionButton("plot","Plot"),
    actionButton("reset","Reset"),
    selectizeInput("x","Var X", choices = list(1,2,3)),
    selectizeInput("y","Var Y", choices = list(1,2,3))
  )  
}


layer_1_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_1 == true",
    "Layer 1"
#     make_layer()
    )
)

layer_2_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_2 == true",
    "Layer 2",
    make_layer()
    )
)

layer_3_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_3 == true",
    "Layer 3",
    make_layer()
    )
)

layer_4_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_4 == true",
    "Layer 4",
    make_layer()
    )
)

layer_5_cond <- tabPanel(
  conditionalPanel(
    condition = "input.show_layer_5 == true",
    "Layer 5",
    make_layer()
  )
)




