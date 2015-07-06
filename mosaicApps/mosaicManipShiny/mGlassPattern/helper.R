
transform = function(xpts,ypts,mag,dmag,rot,xtrans,ytrans,dt){
  cs = cos( rot*pi/180); sn = sin(rot*pi/180)
  nx = (mag+dmag)*xpts
  ny = (mag-dmag)*ypts
  nx = (1-dt)*xpts + dt*(cs*nx + sn*ny + xtrans)
  ny = (1-dt)*ypts + dt*(-sn*nx + cs*ny + ytrans)
  return( list(x=nx,y=ny))
  
}

plotPts = function(mag=1,dmag=0,rot=0,xtrans=0,ytrans=0,dt=1) {
  p = list( x=c(1,0),y=c(0,1))
  p = transform(p$x,p$y,mag=mag,dmag=dmag,rot=rot,xtrans=xtrans,ytrans=ytrans,dt=dt)
  mat = cbind( p$x, p$y)
  evals = signif(eigen(mat)$values,4)
  plot( xpts, ypts, cex=sizes,
        xlim=c(-1,1),ylim=c(-1,1),
        main=paste("Eigenvalues:",evals[1],"and",evals[2]),
        xlab="",ylab="",xaxt="n",yaxt="n",pch=20,col=rgb(0,0,0,.5))
  p = list(x=xpts,y=ypts)
  for( k in 1:5 ) {
    p = transform(p$x,p$y,mag=mag,dmag=dmag,rot=rot,xtrans=xtrans,ytrans=ytrans,dt=dt)
    points( p$x, p$y, cex=sizes-.5+k/10,pch=20,col=rgb(0,0,0,.5))
  }
  p=list(x=c(-.5,0,.5,-.5,0,.5,-.5,0,.5)*1.5,
         y=c(-.5,-.5,-.5,0,0,0,.5,.5,.5)*1.5)
  for (k in 1:10 ) {
    p = transform(p$x,p$y,mag=mag,dmag=dmag,rot=rot,xtrans=xtrans,ytrans=ytrans,dt=dt)
    points( p$x, p$y, pch=20,col=rgb(1,0,0,k/10),cex=1.05^k)
  } 
}