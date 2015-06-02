library(shiny)


shinyUI(fluidPage(
  titlePanel("Guessing the Standard Deviation!"),
  
  p("Your goal to is to manipulate the blue curve (which is a
    normal distribution) to try to match the standard deviation of the 
    red curve.  The default red distribution is a random distribution.
    However, you can set the red distribution to normal, uniform, 
    exponential, t with 2 to 3 degrees of freedom, t with 3 degrees of 
    freedom, F, and Chi-Squared. "),
  
  sidebarLayout(position = "right",
                
    sidebarPanel( 
      sliderInput("sd", label = h4("Guess Standard Deviation"),
                  min = 0.1, max = 5, , step = 0.1, value = 1),
      
      br(),

      radioButtons("dist", label = h4("Red Distribution Type"),
                   choices = list("Random"=0, "Normal"=1, "Uniform"=2,
                                  "Exponential"=3, "t (2<df<3)"=4,
                                  "t (df=3)"=5, "F" = 6, "Chi Squared" = 7),
                   selected = 0),
      
      br(),
      
      checkboxInput("sol", label = "Show Solution", value = FALSE),
      
      br(),
      
      actionButton("nxt", label = "Get the next distribution")
      ),
    
    
    mainPanel(
      br(),
      br(),
      plotOutput("graph")
      )
  )
  
))
