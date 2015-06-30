data1 <<- get("CPS85")

#=============================myFun Starts!
myFun=function(n, seed, signif, use.orig, checks){
  set.seed(seed)
  # fit the new model to the original data to set the scale for the axes
  # this makes it easier to see how the CI changes with seed and n and signif
  #browser()
  scaleData=data1
  scaleData[[yvar]]=NULL
  if (length(checks) != 0) {scaleData = scaleData[checks]}
  else {scaleData = data.frame()}# Just the selected variables
  scaleData[["newname"]] = data1[[yvar]]
  #browser()
  scaleCIs = confint(lm( newname ~ ., data=scaleData), signif=0.95) # always 0.95 for reference
  
  if (use.orig) {
    newData=data1
  } else {
    newData=resample(data1, n)
  }
  foo = newData[[yvar]]
  newData[[yvar]]=NULL
  if (use.orig) { 
    newResids = resid(origMod)
  } else {
    newResids=resample(resid(origMod), n)
  } 
  # DTK gets rid of the prediction from the original model --- just the data tells
  # foo=predict(origMod, newdata=newData)+newResids
  newData=newData[checks]
  newData[["newname"]]=foo
  newMod=lm(newname ~., data=newData)    #newMod from newData with only selected terms
  newCIs=confint(newMod,level=signif)
  limCIs=c(min(newCIs), max(newCIs))
  limCIs=c(min(newCIs)-.1*diff(range(limCIs)), max(newCIs)+.1*diff(range(limCIs)))
  levelNames=rownames(newCIs)
  coefs=c(rep(0, length(levelNames)))
  for (nm in names(origCoefs)) {
    if (nm %in% levelNames) {
      coefs[levelNames==nm]=origCoefs[names(origCoefs)==nm]
    }
  }
  
  plot( 1:2, type="n", ylim=.5+c(0,nrow(newCIs)),xlim=c(0,1),xaxt="n",yaxt="n",
        ylab="",xlab="",bty="n")
  
  
  for(b in 1:nrow(newCIs)){
    if( !is.na( coefs[b]) ) {
      draw.CI.axis( coefs[b], newCIs[b,1], newCIs[b,2], 1+nrow(newCIs)-b, levelNames[b],
                    low.for.scale=scaleCIs[b,1], high.for.scale=scaleCIs[b,2])
    }
  }
  
}
#=========================myFun ends noooooo

#=====================Begin draw.CI.axis function
draw.CI.axis = function( true, low, high,k,name,low.for.scale=low,high.for.scale=high){
  left = min(true,low.for.scale) - 0.66*abs(high.for.scale-low.for.scale)
  right = max(true,high.for.scale) + 0.66*abs(high.for.scale-low.for.scale)
  ticks = signif(pretty( c(left,right), n=5),5)
  axis( side=1,pos=k,at=seq(0,1,length=length(ticks)),
        labels=paste(ticks))
  # convert the units
  axis.left = min(ticks)
  axis.right = max(ticks)
  do.convert = function(val,left,right){ (val - left)/abs(right-left)}
  true = do.convert(true, axis.left, axis.right)
  low = do.convert(low, axis.left, axis.right)
  high = do.convert(high, axis.left, axis.right)
  lines(c(true,true),k+c(-.2,.2),lty=3,col="black")
  points(mean(c(low,high)),k, pch=20,col="red",cex=2)
  text( c(low,high),c(k,k),c("(",")"),col="red")
  lines( c(low,high),c(k,k),lwd=3,col=rgb(1,0,0,.5))
  text( 0.05, k, name, pos=3, xpd=NA) # xpd about clipping.
}
#=====================End draw.CI.axis function        
