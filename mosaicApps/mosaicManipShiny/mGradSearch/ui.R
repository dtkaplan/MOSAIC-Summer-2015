library(shiny)

shinyUI(fluidPage(
  titlePanel("Gradient Search"),
  
  p("This is an applet for finding local extrema."),
  
  sidebarLayout(position = "right",
                
                sidebarPanel(
                  selectInput("ty", "Optimization Type:", 
                              choices = list("Value","Gradient","NewtonAlongGrad",
                                             "NewtonLinearAlgebra")),
                  
                  sliderInput("scale", label = h5("Scale (log2)"),
                              min = -4, max = 8, value = 2),
                  
                  actionButton("cent", label = "Center on Last Point"),
                  
                  actionButton("history", label = "Clear History"),
                  
                  sliderInput("trans", label = h5("Transparency"),
                              min = 0, max = 1, step = .01, value = 0),
                  
                  checkboxInput("contours", label = "Show Contours")),
                
                mainPanel(
                  plotOutput("graph", click ="user")
                )
  )
  
))
