library(shiny)
library(mosaicData)

data1 <<- get("CPS85")

shinyUI(fluidPage(
  titlePanel("Investigating Model Bias"),
  
  p("This applet explore integrals as applied to economics."),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  textInput("expression", label = h5("Enter the expression to be plotted"),
                            value = "wage~sex+educ+exper"),
                  
                  sliderInput("n", label = h5("n points to sample"),
                              min = ncol(data1)*3 + 20, max = 5*nrow(data1), step = round( max(1,nrow(data1)/200)), value = nrow(data1)),
                  
                  checkboxGroupInput("checks", label = NULL, choices = names(data1)[names(data1)!="wage"]),
                  
                  sliderInput("seed", label = h5("Random seed"),
                              min = 100, max = 500, step = 1, value = sample(100:500,1)),
                  
                  sliderInput("signif", label = h5("Significance level"),
                              min = .5, max = .99, step = .01, value = 0.95),
                  
                  checkboxInput("use.orig", label = "Use Original Data", value = FALSE)
                ),
                
                
                mainPanel(
                  br(),
                  br(),
                  plotOutput("graph")
                )
  )
  
  ))
