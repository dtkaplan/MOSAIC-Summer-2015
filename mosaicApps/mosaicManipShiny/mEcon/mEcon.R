xlim=c(0,20)
x <- seq(min(xlim), max(xlim), length=1000)

myFun <- function(sup1, sup2, dem1, dem2){
  supFun <- splinefun(c(0,mean(x),max(x)), y=c(0, sup1, sup2)) 
  demFun <- splinefun(c(0,mean(x),max(x)), y=c(50, dem1, dem2))
  func <- function(x){supFun(x)-demFun(x)}
  equil <- uniroot(func, interval=xlim) #Solve for equil qty.
  xEquil <- equil$root
  yEquil <- supFun(xEquil)
  Supply <- supFun(x)          #making my life easy with auto.key by naming vars Supply and Demand
  Demand <- demFun(x)
  xx <- x     #To avoid duplication in the polygons in the panel function
  
  panel.Econ <- function(x,y,...){
    panel.xyplot(x,y,...)
    panel.lines(x=c(xEquil, -999999), y=c(yEquil, yEquil), lty=2, col="black")
    panel.lines(x=c(xEquil, xEquil), y=c(yEquil, -999999), lty=2, col="black")
    # controlPoints <- data.frame(x=c(mean(x), max(x), mean(x), max(x)), y=c(sup1, sup2, dem1, dem2), spline=rep('supply','demand', each=2))
    panel.points(x=c(0, mean(x), max(x)), y=c(0, sup1, sup2), col="blue", cex=1.5)
    panel.points(x=c(0, mean(x), max(x)), y=c(50 , dem1, dem2), col="red", cex=1.5)
    leftx <- xx[xx<=xEquil]
    ySup <- c(supFun(leftx), rep(yEquil, length(leftx)))
    xpts <- c(min(leftx),leftx,max(leftx))
    panel.polygon(x=c(leftx, rev(leftx), min(leftx)), y=c(rep(yEquil, length(leftx)), supFun(rev(leftx)), yEquil ), 
                  col=rgb(0,0,.8,.2), border=FALSE)
    yDem <- c(demFun(leftx), rep(yEquil, length(leftx)))
    panel.polygon(x=c(min(leftx), leftx, max(leftx)), y=c(yEquil, demFun(leftx), yEquil), 
                  col=rgb(.8,0,0,.2), border=FALSE)
  }
    
    plot2=xyplot(Supply+Demand~x, auto.key=list(lines=TRUE,points=FALSE, columns=2), xlab="Quantity", ylab="Price",
           type="l", lwd=3, panel=panel.Econ)
  
    print(plot2)
  }
