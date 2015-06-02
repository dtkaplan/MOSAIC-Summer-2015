library(shiny)


shinyUI(fluidPage(
  titlePanel("Visualizing a Histogram"),
  
  p("An applet which lets the user manipulate the number of bins and the center
    break of a histogram corresponding to a random normal distribution."),
  
  sidebarLayout(position = "right",
                
    sidebarPanel( 
      sliderInput("bins", label = h4("Number of histogram bins"),
                  min = 4, max = 50, , step = 1, value = 10),
      
      br(),
      
      sliderInput("center", label = h4("Center Break"),
                  min = -5, max = 5, , step = 0.1, value = 0),
      
      br(),
      
      sliderInput("seed", label = h4("Random Seed"),
                  min = 1, max = 100, , step = 1, value = 1)
    ),
    
    mainPanel(
      plotOutput("graph")
      )
  )
  
))
