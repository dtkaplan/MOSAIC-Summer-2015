library(shiny)


shinyUI(fluidPage(
  titlePanel("Visualizing a Density Plot"),
  
  p("An applet which lets the user manipulate the bandwidth of a density plot and 
    apply different transformations to examine how density plots reflect smoothed
    data"),
  
  sidebarLayout(position = "right",
                
    sidebarPanel( 
      sliderInput("band", label = h4("Choose bandwidth:"),
                  min = 0.01, max = 5, step = 0.01, value = 1),
      
      br(),

      selectInput("trans", label = h4("Choose transformation:"),
                  choices = list("None", "Log", "Sqrt", "Rank", "arcCos")),
      
      br(),

      selectInput("dist", label = h4("Choose distribution:"),
                  choices = list("Normal", "Uniform", "Exponential")),
      
      br(),
      
      sliderInput("seed", label = h4("Choose random seed"),
                  min = 1, max = 100, step = 1, value = 1),
      
      br(),
      
      sliderInput("points", label = h4("Choose number of points:"),
                  min = 10, max = 1000, step = 1, value = 100)
    ),
    
    mainPanel(
      plotOutput("graph")
      )
  )
  
))
