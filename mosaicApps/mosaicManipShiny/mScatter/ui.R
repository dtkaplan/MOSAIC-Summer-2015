library(shiny)

shinyUI(fluidPage(
  titlePanel("Visualizing a Scatter Plot"),
  
  p("An applet which lets the user manipulate the Scatter Plot by choosing ......"),
  
  sidebarLayout(position = "right",
                
    sidebarPanel( 
      actionButton("expression", label = "Show Expression"),
            
      br(),
      
      selectInput("data",label=h4("Choose a dataset"),
                  choices=list("Galton", "Heightweight", 
                               "SwimRecords", "TenMileRace")), 
      br(),
      
      selectInput("xaxis", label = h4("Choose x axis:"),
                  choices=list(1, 2)),  
      br(),

      selectInput("yaxis", label = h4("Choose y axis:"),
                  choices = list(1, 2)),    
      br(),

      selectInput("color", label = h4("Choose group color:"),
                  choices = list(1, 2)),  
      br(),
      
      selectInput("size", label = h4("Choose group size:"),
                  choices = list(1, 2)),    
      br(),
      
      selectInput("facet", label = h4("Choose facet:"),
                  choices = list(1, 2)),     
      br(),
      
      checkboxInput("logx",label=h4("Log X-axis"),
                    value=TRUE),
      br(),
      
      checkboxInput("logy",label=h4("Log Y-axis"),
                    value=TRUE),
      br(),
      selectInput("model", label=h4("Choose model"),
                  choices=list("None","Linear","Smoother") )            
    ),
    
    mainPanel(
      plotOutput("graph")
      )
  )
  
))
