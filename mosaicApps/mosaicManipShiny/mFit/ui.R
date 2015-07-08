library(shiny)

shinyUI(fluidPage(
  titlePanel("Visualizing a Density Plot"),
  
  p(" Interactive applet for term selection and nonlinear parameters for fitting.
  Displays data and a menu of modeling functions.  Finds a linear combination
   of the selected modeling functions, with the user setting nonlinear
   parameters manually."),
  
  sidebarLayout(position = "right",
                sidebarPanel(
                  tabsetPanel(
                    tabPanel( title = "Set up basic parameters",
                              p(),
                              selectInput("data", "Please selet a dataset", choices = list("Galton", "KidsFeet", "Heightweight", "SwimRecords","TenMileRace")),
                              textInput("expr", "Please enter the expression for model"),
                              checkboxGroupInput("checkbox1", label = "Please select the function that you want to fit with", choices = choice_lst1),
                              sliderInput("k", label = h5("k"),
                                          min = -2, max = 2, step = .05, value = 0.1),
                              
                              sliderInput("P", label = h5("P"),
                                          min = .1, max = 10, step = .01, value = 5),
                              
                              sliderInput("n", label = h5("n"),
                                          min = 1, max = 20, step = 1, value = 1),
                              actionButton("plot", label = "Make a plot")
                              
                    ),
                    
                    tabPanel( title = "Set up mu and sd",
                              p(),
                              actionButton("reset", "Reset mu and sd"),
                              p(),
                              checkboxGroupInput("checkbox2", label = "Please select the function that you want to fit with", choices = choice_lst2),
                              p(),
                              lapply(1:5, function(i) {
                                sliderInput(paste0('mu', i), paste0('mu', i),
                                            min = 7.9, max = 9.8, step =.1, value = 8)
                              }),
                              
                              sliderInput("sd", label = h5("sd"),
                                          min = 0.1, max = 3, step = .1, value = 0.5))
                  )
                ),
                
                mainPanel (
                  plotOutput("graph")
                )
                
  )
  
  
)

)
