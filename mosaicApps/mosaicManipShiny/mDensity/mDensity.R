
myFun=function(bandwidth, dist, trans, npts, ...){
  if(dist=="Normal")
    x=rnorm(npts, mean=0, sd=5)
  if(dist=="Uniform")
    x=runif(npts, min=-10, max=10)
  if(dist=="Exponential")
    x=rexp(npts, rate=1)
  trans.x=trans(x)
  dens = densityplot(trans.x, xlab= "Values", bw=bandwidth,
              scales = list(x=list(cex=1.5)))
  print(dens)
}
