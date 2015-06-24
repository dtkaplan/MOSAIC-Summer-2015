library(shiny)
library(mosaic)
library(lattice)
library(grid)
source("mTaylor.R", local=TRUE)

trans.blue <- rgb(0,0,1,.1) # least squares rectangle color
rect.trans.blue <- rgb(0,0,1,.05)
trans.red <- rgb(1,0,0,.1) # red polygon fill color
font.size <- 13

line.blue <- rgb(0,0,1,.5) # least squares line color
line.red <- rgb(1,0,0,.5) # Taylor line color

shinyServer(

  function(input, output, session) {

    output$graph <- renderPlot({

      f <<- mosaic::makeFun(as.formula(input$fun))
      x <<- seq(-5, 5, length = 1000)

      # Derivatives of function for Taylor Series
      dd <<- list()
      for (k in 1:10) {dd[[k]] <<-
                         mosaic::symbolicD(as.formula(input$fun), .order=k)}

      args <- list()

      args$a            <- input$position
      args$TaylorBeTrue <- input$taylor
      args$lsquares     <- input$least
      args$xwid         <- input$width
      args$n            <- input$order
      args$err          <- input$error
      args$which.plot   <- input$what

      do.call(myplot, args)
    })

  }
)
