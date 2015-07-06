library(shiny)
library(manipulate)
library(graphics)
library(SparseM)
#source("helper.R", local = TRUE)

shinyServer(function(input, output, session) {

  browser()
  fun <<- NULL
  seed <<- NULL
  
  if( ! require(mosaic))
    stop("Must install mosaic package.")
  if( !require(manipulate) ) 
    stop("Must use a manipulate-compatible version of R, e.g. RStudio")

    gfunx <- D( fun(x,y)~x)
    gfuny <- D( fun(x,y)~y)
    dirD <- D(fun(x+cos(theta)*s,y+sin(theta)*s)~s,theta=0)
    dirD2 <- D(fun(x+cos(theta)*s,y+sin(theta)*s)~s&s,
               theta=0)
    gfunxx <- D( fun(x=x,y=y)~x&x)
    gfunyy <- D( fun(x=x,y=y)~y&y)
    gfunxy <- D( fun(x=x,y=y)~x&y)
    
    # ====== The State
  
    drawState <- reactive({
      ptsX <- c(); ptsY <- c()
      centerpt <- c(0,0)
      scale <- input$scale
      type <- input$ty
      centerit <- input$cent
      trans <- input$trans
      history <- input$history
      contours <- input$contours
      
      if( is.null(fun)) {
        if( is.null(seed)) seed <- round(runif(1,min=1,max=100000))
        fun <- rfun( ~x&y, seed=seed)
      }
      
      #browser()
      
      if( centerit ) {
        if (length(ptsX)>0)
          centerpt <- c(ptsX[length(ptsX)],ptsY[length(ptsY)])
      }
      x <- seq(-scale+centerpt[1],scale+centerpt[1],length=50)
      y <- seq(-scale+centerpt[2],scale+centerpt[2],length=50)
      z <- outer(x,y,fun)
      contour(x,y,z,col=ifelse(contours,rgb(0,0,0,min(1,trans+.1)),"white"))
      if(contours & trans>0) { 
        image(x,y,z,add=TRUE, col=topo.colors(10,alpha=trans))
        }
      if( history ){
        ptsX<<-ptsX[length(ptsX)]; ptsY<<-ptsY[length(ptsY)]
      }
      Pos
    })
      
      
    Pos <- reactive({  
    pos <- manipulatorMouseClick()
      if (!is.null(pos)) {
        ptsX <<- c(ptsX,pos$userX)
        ptsY <<- c(ptsY,pos$userY)
      }
      if( length(ptsX)>0){
        text(ptsX,ptsY,signif(fun(ptsX,ptsY),3),pos=3)
        points(ptsX,ptsY,pch=20)
        for(k in c(length(ptsX))){
          gx <- gfunx( x=ptsX[k],y=ptsY[k])
          gy <- gfuny( x=ptsX[k],y=ptsY[k])
          the.ang <- atan2(gy,gx)
          displacement <- (2^scale)/20
          
          # ============= Newton step along the gradient
          newtonStep <-  -dirD(s=0,theta=the.ang,x=ptsX[k],y=ptsY[k])/dirD2(s=0,theta=the.ang,x=ptsX[k],y=ptsY[k])
          
          # ============ Newton step in 2-D
          grad <- rbind(gx,gy)
          dxx <- gfunxx(x=ptsX[k],y=ptsY[k])
          dyy <- gfunyy(x=ptsX[k],y=ptsY[k])
          dxy <- 0 # gfunxy(x=ptsX[k],y=ptsY[k])  FIX THIS.
          H <- rbind( cbind(dxx,dxy),cbind(dxy,dyy))
          real.step <- solve(H,-grad)
          
          
          if( any(type %in% c("Gradient","NewtonAlongGrad","NewtonLinearAlgebra"))){
            lines( ptsX[k]+10000*c(-1,1)*gx, 
                   ptsY[k]+10000*c(-1,1)*gy,col="red")
          }
          if( any(type %in% c("Gradient", "NewtonAlongGrad","NewtonLinearAlgebra"))){  
            text( ptsX[k]+displacement*cos(the.ang), ptsY[k]+displacement*sin(the.ang),">",srt=the.ang*180/pi,col="red")
          }
          if( any(type %in% c("NewtonAlongGrad","NewtonLinearAlgebra"))){
            text( ptsX[k]+newtonStep*cos(the.ang), ptsY[k]+newtonStep*sin(the.ang),"*",cex=2,srt=the.ang*180/pi,col="red")
          }
          
          if( any(type %in% c("NewtonLinearAlgebra"))){
            text( ptsX[k]+real.step[1], ptsY[k]+real.step[2],"o",col="blue")
          }
        }
      }
    })
      
    
#   tryCatch( .mGradSearch.core(), 
#             error=function(e){ 
#               stop(paste(e,"Need newer version of RStudio", collapse="\n"))
#             }
#   )
  
    output$graph <- renderPlot({
      p <- drawState()
      p
    })
  
  #browser()
  
#   args <- list()
#  
#  scale <- input$scale 
#  args$scale <- 2 ^ scale
#   args$type <- input$ty
#   args$trans <- input$trans
#   args$center <- input$cent
#   args$contours <- input$contours
#   args$history <- input$history
#   
#   do.call(drawState, args)
})

