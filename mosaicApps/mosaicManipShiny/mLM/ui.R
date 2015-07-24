shinyUI(fluidPage(
  titlePanel("Visualizing a Linear Model"),
  
  p("An interactive app that allows you to fit linear model by entering an expression.
    Note that while the expression can take several x variables simultaneously, 
    the graph only models one x varibale at a time"),
  
  sidebarLayout(position = "right",
                sidebarPanel(
                  selectInput("data", "Please selet a dataset", choices = list("Galton", "KidsFeet")),
                  selectInput("var_choices", "These are the variables available to model", choices = list(x = "x", y = "y")),
                  textInput("expr", "Please enter the expression for model"),
                  actionButton("plot", label = "Make a plot")
                ),
                
                mainPanel(
                  plotOutput("graph")
                )
  )
  
  ))
