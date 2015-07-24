library(shiny)
 
shinyUI(fluidPage(
  titlePanel("SIR Model"),
  
  p("Using the sliders, a user may control the probability of infection, the
  number of contacts per day, duration of disease decay, the number of the initial population that is infected, and finally the number of births per
  day. With these parameters, the model can be substantially altered. For
  example, if the probability of infection is high and contact is high, the
  disease sweeps through the population quickly. If probability of infection
  and contact are low, the disease may not infect every member of the
  population. If there are many babies added per day and a long disease decay,
  sometimes a recurring epidemic occurs. The model starts with a population of
  1000 initially and runs for 100 days."),
  
  sidebarLayout(position = "right",
                
    sidebarPanel( 
      sliderInput("probInfect", label = h4("Probability of Infection"),
                  min = 0, max = 1, , step = 0.001, value = 0.1),
      
      br(),

      sliderInput("nContact", label = h4("Contacts per day"),
                  min = 0, max = 100, step = 1, value = 10),
      
      br(),
      
      sliderInput("duration", label = h4("Duration of disease decay"),
                  min = 0.01, max = 1, step = 0.001, value = 0.2),
      br(),
      
      sliderInput("initialI", label = h4("Initial Infected"),
                  min = 1, max = 50, step = 1, value = 1),
      
      br(),
      
      sliderInput("birth", label = h4("Births/day"),
                  min = 0, max = 20 , step = 1, value = 0)
      
      ),
    

    mainPanel(
      br(),
      br(),
      plotOutput("graph")
      )
  )
  
))

