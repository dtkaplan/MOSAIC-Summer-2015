library(shiny)
library(mosaic)
library(lattice)
library(ggplot2)
library(grid)


shinyServer(
  
  function(input, output, session){
    source("helper.R", local = TRUE)
      output$graph <- renderPlot({
                
#         args <- list()
#         args$p <- input$probInfect
#         args$ncontact <- input$nContact
#         args$gamma <- input$duration
#         args$Iinit <- input$initialI
#         args$births <- input$births
# 
#         
#         dat<- do.call(myFun, args)  #unused arguments error?
        
        dat <- myFun()
        #lattice::xyplot(S+I+R~t, data=dat, auto.key=list(points=FALSE, lines=TRUE, columns=3), lwd=lwd, type=type)

        ggplot(dat,aes(x=t))+geom_line(aes(y=S,color ="blue",size = 0.5))+geom_line(aes(y=I,color = "red",size =0.5))+geom_line(aes(y=R, color ="green",size = 0.5))+ylab("SIR")+xlab("Time")

      })  
    

  
  }
  
  )