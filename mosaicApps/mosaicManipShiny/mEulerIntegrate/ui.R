library(shiny)

shinyUI(fluidPage(
  titlePanel("Euler Integration Method"),
  
  p("An applet which allows the user to explore the Euler method for numerical integration of ordinary differential equations "),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
              
                  
                  selectInput("dynfun", label = h4("Dynamics"), choices = list("linear","logistic",
                                                                               "Newton Cooling","cows","pills" ,"Gompertz"),
                              selected = "linear"),
                  
                  br(),
                  
                  actionButton("go", label = h4("Go")),
                
                  br(), 
                  
                  sliderInput("dt", label = h4("Euler Stepsize: dt"),
                              min = 0.05, max = 10, step = 0.05, value = 1),
                  
                  br(),
                  
                  sliderInput("nsteps", label = h4("Number of Euler steps to take"),
                              min = 1, max = 20, value = 1),
                  
                  br(),
                  
                  sliderInput("xval0", label = h4("Initial value: x0"),
                              min = -.5, max = 3.5 , step = 0.01, value = 0.5),
                  br(),
                  
                  checkboxInput("showeq", label = h4("Show Equilibrium"), value = FALSE),
                  
                  br(),
                  
                  selectInput("ntraj", label = h4("Active Trajectory"), choices = list("red" = 1, "blue" = 2, "green" = 3), selected = 1),
                  
                  br(),
                  
                  actionButton("restart", label = h4("Start Over")),
                  
                  br(), 
                  
                  actionButton("editfun", label = h4("Edit the dynamical function")),
                  
                  br() 
                  
                ),
                
                
                mainPanel(
                  br(),
                  plotOutput("graph")
                )
  )
  
  ))
