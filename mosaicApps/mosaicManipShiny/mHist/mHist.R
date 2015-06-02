myFun=function(nBands, cBreak, seed){
  set.seed(seed)
  x=rnorm(500, mean=0, sd=5)
  
  rng=diff(range(x))
  myby=rng/(nBands)
  c.rng = diff(c(min(x),cBreak))
  myBreaks = seq(cBreak, (max(x)+rng/5), by=myby)
  myBreaks = c(seq(cBreak, (min(x)-rng/5), by=-myby), myBreaks)
  
  myPan=function(x,...){
    panel.histogram(x, breaks=myBreaks, col=newCol)
    if(!is.null(oldBreaks)){
      panel.histogram(x, col=oldCol, breaks=oldBreaks, border=FALSE)
    }
  }
  
  newHist=histogram(x, panel=myPan, type = "density",
                    scales = list(x=list(cex=1.7)))
  print(newHist)
  oldBreaks<<-myBreaks   #Keep the old breaks for next time
}
