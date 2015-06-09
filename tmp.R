library(shiny)
library(mosaic)
#source("helper.R")
#Wmengdiw

#####################################################################
# datasets <- list( Galton = Galton, Heightweight = Heightweight,
#                   SwimRecords = SwimRecords, TenMileRace = TenMileRace)

runApp(
  list(
    server = shinyServer(
      function(input, output, session) {
        
        make_layer <- function(){
          layer <- tabPanel("layer n",
                            wellPanel(selectizeInput("geoms", "Geoms", 
                                                     choices = list("geom_text" = 1, "geom_line" = 2, "geom_point" = 3)
                            ),
                            actionButton("plot","Plot"),
                            actionButton("reset","Reset"),
                            conditionalPanel(
                              condition = "input.geoms == 1",
                              selectizeInput("x","Var X", choices = list(1,2,3)),
                              selectizeInput("y","Var Y", choices = list(1,2,3))
                            ) 
                            )    
                            
                              
          )       
          
          return (layer)
        }  
        
        
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
        
        output$ui <- renderUI({
          if (input$show_layer_1 || input$show_layer_2) { 
            make_layer()
          
          }
        })
        
      




      }),
    
    ui = shinyUI(
      fluidPage(
        "Project Mosaic!!!",      
        column(2, 
               checkboxInput("show_layer_1", "Display Layer 1", value=FALSE),
               checkboxInput("show_layer_2", "Display Layer 2", value=FALSE)
               ), 
        column(4, uiOutput("ui")),
        column(6, textOutput("Here is the plot Output"))
      )
    )
    
  )
)



# radio <- radioButtons(
#   "radio", 
#   label = NULL,
#   choices = list("Choice Datasets" = 1, "Upload Datasets" = 2), 
#   selected = 1)
# 
# 
# condition1 <- 
#   conditionalPanel(
#     condition = "input.radio == 1",
#     selectizeInput("data", label = "Choose Dataset", 
#                    choices = list( "Galton", "Heightweight",
#                                    "SwimRecords", "TenMileRace"
#                                    )
#     )
#   )
# 
# condition2 <- 
#   conditionalPanel(
#     condition = "input.radio == 2",
#     fileInput('data_own', 'Choose CSV File',
#               accept=c('text/csv', 
#                        'text/comma-separated-values,text/plain', 
#                        '.csv')
#               )
#   )
# 
# 
# subset <- 
#   fluidRow(
#     column(6, 
#            checkboxInput("randomsub", "Random Subset")
#     ),
#     conditionalPanel(
#       condition = "input.randomsub == true", 
#       column(6, 
#              numericInput("randomsubrows", "Rows", value = 1, min = 1)
#       )
#     )
#   )
# 
# 
# 
# runApp(
#   list(
#     ui = shinyUI(
#       
#       fluidPage(
#         radio,
#         condition1,
#         condition2,
#         subset
#       )     
#     ),
#     
#     server = shinyServer(function(input, output){
#       
#     })
#   )
# )
