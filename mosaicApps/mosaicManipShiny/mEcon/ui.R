library(shiny)


shinyUI(fluidPage(
  titlePanel("Supply and Demand"),
  
  p("An applet that shows relationship between supply and demand"),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  sliderInput("s10", label = h4("Supply when Qd equals 10"),
                              min = 1, max = 40, step = .1, value = 25),
                  
                  br(),
                  
                  sliderInput("s20", label = h4("Supply when Qd equals 20"),
                              min = 1, max = 60,step = .1, value = 50),
                  
                  br(),
                  
                  sliderInput("d10", label = h4("Demand when Qs equals 20"),
                              min = 1, max = 60,step = .1, value = 10),
                  br(), 
                  
                  sliderInput("d20", label = h4("Demand when Qs equals 20"),
                              min = 1, max = 40,step = .1, value = 10)
                  
                ),
                
                mainPanel(
                  plotOutput("graph")
                )
  )
  
  ))