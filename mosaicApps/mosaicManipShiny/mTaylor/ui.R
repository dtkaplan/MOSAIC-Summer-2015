library(shiny)

shinyUI(fluidPage(
  titlePanel("Comparing different approximations"),
  
  p("This applet displays a plot of a function, its Taylor series approximation,
    and a least squares approximation."),
  
  sidebarLayout(position = "right",
                
    sidebarPanel( 
      
      textInput("fun", label = h5("Enter the function to be plotted"),
                value = "sin(x) ~ x"),
      
      radioButtons("what", label = h5("What to plot?"),
                   choices = list("Plot the function",
                                  "Plot the errors")),

      sliderInput("position", label = h5("Position:"),
                  min = -5, max = 5, , step = 0.1, value = 0),

      numericInput("order", 
                   label = h5("Order of the polynomial"), value = 0,
                   min = 0, max = 10, step = 1),  
      
      checkboxInput("taylor", label = "Show Taylor Series", value = FALSE),
      
      checkboxInput("least", label = "Show Least Squares", value = FALSE),
      
      sliderInput("width", label = h5("Least Squares Width:"),
                  min = 0, max = 10, , step = 1, value = 5),
      
      checkboxInput("error", label = "View error area", value = FALSE)
      ),
    
    
    mainPanel(
      br(),
      br(),
      plotOutput("graph")
      )
  )
  
))
