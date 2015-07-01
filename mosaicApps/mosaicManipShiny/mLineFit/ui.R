shinyUI(fluidPage(
  
  titlePanel("Interactive line-fitting application"),
  
  p("An interactive demonstration program for showing how the residuals
      and the sum of square residuals relates to the slope and intercept of a fitted
      line.  There are sliders to modify the slope and intercept of the fitted
      line and checkboxes that control whether to display the residuals (as lines)
      or the sum of square residuals (as filled boxes).  The numerical value
      of the sum of square residuals is always shown.  By modifying the slope and intercept,
      you can see how the sum of square residuals increases compared to the 
      optimal, least squares value."),
  
  sidebarLayout(
    position = "right",
    sidebarPanel(
      selectInput("data", "Please selet a dataset", choices = list("Galton", "KidsFeet")), 
      textInput("expr", "Please enter the expression for model"),
      sliderInput("inter", "Intercept Offset", min = -3, max = 3, step = .05, value = 0),
      sliderInput("slope", "Slope Multiplier", min = -1, max = 2, step = .05, value = 1),
      checkboxInput("resids", "Show Residuals", value = FALSE),
      checkboxInput("squares", "Square resids", value = FALSE),
      actionButton("plot", label = "Make a plot")
    ),
    
    mainPanel(
      plotOutput("graph")
    )
    
  )
  
)

)
