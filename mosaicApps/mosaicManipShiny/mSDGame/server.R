library(shiny)
library(mosaic)
library(lattice)
library(grid)

dist.col = rgb(1,0,0,1) #red
guess.col=rgb(0,0,1,1) #blue
actual.col = rgb(0,1,0,1) #green
trans.dist.col = rgb(1,0,0,.2)
trans.guess.col=rgb(0,0,1,.2)
trans.actual.col=rgb(0,1,0,.2)

iter=sample(1:100000, 1) #replace with manipulatorGetState
x=seq(-10,10, length=1000)
set.seed(iter)

act.sd <- runif(1, .01, 5)
act.mean <- 0
guess.mean <-0

shinyServer(
  
  function(input, output, session) {
    source("mSDGame.R", local=TRUE)
    output$graph <- renderPlot({
      
      args <- list()
      args$guess.sd = input$sd
      args$myDist   = chooseDist()
      args$sol      = input$sol
      args$nxt      = input$nxt
        
      do.call(myFun, args)
    })
    
  }
)