library(shiny)


x_limit <<- c(-.2,1.2)

shinyUI(fluidPage(
  titlePanel("Phase Line"),
  
  p("...."),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  
                  sliderInput("x", label = h5("State Value"),
                              min = x_limit[1], max = x_limit[2], step = abs(diff(x_limit))/100, value = mean(x_limit)),
                  
                  checkboxInput("field", label = "Draw Flow Field", value = TRUE),
                  
                  sliderInput("npts", label = h5("Number of Field Points"),
                              min = 1, max = 20, value = 6),
                  
                  
                  sliderInput("dt", label = h5("dt"),
                              min = 0, max = 2, step = .01, value = .5),
                  
                  checkboxInput("showDyn", label = "Show dx/dt Function", value = FALSE)
                ),
                
                
                mainPanel(
                  br(),
                  br(),
                  plotOutput("graph")
                )
  )))
