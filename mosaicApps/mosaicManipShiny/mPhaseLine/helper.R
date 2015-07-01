drawGraph <- function(dt,x,field=FALSE,npts=6,showDyn=FALSE){
  type <- ifelse(show_Dyn,"p","n") # plotting type
  ylabel <- ifelse(show_Dyn,"d State / dt","")
  plot( xpts, ypts, col=color_s[inds],pch=20,
        xaxt="n",yaxt="n",bty="n",
        x_limit=x_limit,
        ylim=c(min(0,min(ypts)),max(0,max(ypts))),
        main="Dynamics",cex=.75,xlab="State",ylab=ylabel,type=type)
  
  
  pointAtX <- function(x,dt=0.1){
    #browser()
    xind <- max(1,sum( x>=xpts )) #Where does it fall in the x-sequence
    cinds <- inds[xind]
    lines( c(x,x+dt*dyn(x)), c(0,0),col=color_s[cinds],lwd=10,xpd=NA)
    text(x+dt*dyn(x), 0, ifelse(dyn(x)>0,">","<"),col=color_s[cinds],cex=2)
    if( show_Dyn) {
      lines( c(x,x,min(x_limit)),c(0,dyn(x),dyn(x)),col=color_s[cinds],lty=3,lwd=2)
      points(min(x_limit),dyn(x),cex=2,col=color_s[cinds],pch=20)
    }
    points(x,0,pch=20,col="black")
    points(x,0,pch=20,cex=2,col=color_s[cinds])
    #arrows( min(x_limit),0, min(x_limit),dyn(x),code=2,col=colors[cinds], lwd=5,length=.1)
  }
  if( field ) {
    edge <- abs(diff(x_limit))/10
    states <- seq(x_limit[1]+edge,x_limit[2]-edge,length=npts)
    for(k in states) pointAtX(k, dt)
  }
  
  pointAtX(x,dt)
  
  axis(1,pos=0,col="red")
  if( show_Dyn ) axis(2, pos=min(x_limit),col="black")
  
}