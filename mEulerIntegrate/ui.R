library(shiny)

shinyUI(fluidPage(
  titlePanel("Euler Integration Method"),
  
  p("XXX"),
  
  sidebarLayout(position = "right",
                
                sidebarPanel( 
                  
                  selectInput("dynfun", label = h4("Dynamics"), choices = list("linear" = 1 ,"logistic" = 2 ,
                                                                                "Newton Cooling" = 3,"cows" = 4,"pills" = 5,"Gompertz" = 6),
                              selected = "1"),
                  
                  br(),
                  
                  actionButton("go", label = h4("Go")),
                
                  br(), 
                  
                  sliderInput("dt", label = h4("Euler Stepsize: dt"),
                              min = 0.05, max = 10, step = 0.05, value = 0.5),
                  
                  br(),
                  
                  sliderInput("nsteps", label = h4("Number of Euler steps to take"),
                              min = 1, max = 20, value = 1),
                  
                  br(),
                  
                  sliderInput("xval0", label = h4("Initial value: x0"),
                              min = -.5, max = 3.5 , step = 0.01, value = 0.5),
                  br(),
                  
                  checkboxInput("showeq", label = h4("Show Equilibrium"), value = FALSE),
                  
                  br(),
                  
                  selectInput("ntraj", label = h4("Active Trajectory"), choices = list("red" = 1, "blue" = 2, "black" = 3)),
                  
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

# manipulate(draw.state(dynfunname=dynfun,xval0=xval0,dt=dt,ntraj=ntraj,go=go,restart=restart,nsteps=nsteps,showequilibria=showeq,editfun=editfun),
#            dynfun=picker("linear","logistic","Newton Cooling","cows","pills","Gompertz",label="Dynamics",initial="logistic"), 
#            go = button("GO!"),
#            dt = slider(0.05,10.0,step=0.05,init=0.5,label="Euler Stepsize: dt"),
#            nsteps=slider(1,20,init=1,label="Number of Euler steps to take"),
#            xval0 = slider(-.5,3.5,step=0.01,init=.5,label="Initial value: x0"),
#            showeq = checkbox("Show Equilibria",initial=FALSE),
#            ntraj = picker("red"=1,"blue"=2,"black"=3, label="Active Trajectory"),
#            restart=button(label="Start Over"),
#            editfun = button( label="Edit the Dynamical Function")
# )

