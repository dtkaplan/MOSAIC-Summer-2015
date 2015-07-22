library(shiny)


shinyUI(fluidPage(
  titlePanel("Power Test"),
  
  p("An applet that shows power of a hypothesis (t) test"),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  sliderInput("mu", label = h4("Mu"),
                              min = 5, max = 7, step = 0.1, value = 6),
                  
                  br(),
                  
                  sliderInput("sigma", label = h4("Sigma"),
                              min = 0, max = 4, step = 0.1, value = 2),
                  
                  br(),
                  
                  sliderInput("n", label = h4("N sample points"),
                              min = 5, max = 305, step = 5, value = 50)
                ),
              
                
                mainPanel(
                  plotOutput("graph")
                )
  )
  
  ))