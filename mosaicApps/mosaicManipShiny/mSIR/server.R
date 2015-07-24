library(shiny)
library(mosaic)
library(lattice)
library(ggplot2)
library(grid)

# Known bug:
# Error message:missing value where TRUE/FALSE needed, when choosing probability and contact is too high

shinyServer(
  
  function(input, output, session){
    source("helper.R", local = TRUE)
      output$graph <- renderPlot({
        dat <- myFun()
        mdat<-melt(dat,id.vars = "t",measure.vars=c("S","I","R"),variable.name = "group")
        ggplot(mdat,aes(x=t,y=value))+geom_line(aes(color = group),size = 0.8)+ylab("SIR")+xlab("Time")
      })  
 
  }
  
  )