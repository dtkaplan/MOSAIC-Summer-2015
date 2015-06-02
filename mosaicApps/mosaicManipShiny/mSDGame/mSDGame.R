chooseDist <- reactive({
  input$nxt               # create the dependency
  act.sd <<- runif(1, .01, 5)
  act.mean <<- 0
  guess.mean <<-0
  
  dist = input$dist
  
#   browser()
  if(dist==0){#mychoice, random
    dist=sample(1:4, 1)
  }
  
  #Result from line 7 will correspond to one of these:
  if(dist==1){  #normal
    distFun=function(x) dnorm(x, sd=act.sd)
  }
  if(dist==2){ #Uniform
    rng=3.464102*act.sd
    distFun=function(x) dunif(x, min=-rng/2, max=rng/2)
  }
  if(dist==3){  #exp dist
    rate=1/act.sd
    act.mean=1/rate
    guess.mean=1/rate
    distFun=function(x) dexp(x, rate=rate)
  }
  if(dist==4){         #t dist between 2 and 3 df
    dfree=runif(1, 2, 3)
    act.sd=sqrt(dfree/(dfree-2))
    # dfree=(-2*act.sd^2)/(1-act.sd^2)
    #      print(dfree)
    #    if(dfree<0)
    #         dfree=abs(dfree)
    distFun=function(x) dt(x, df=dfree)
  }
  if(dist==5){        #t3 dist. ## THIS MAY NEED TO BE FIXED
    act.sd=sqrt(3)
    distFun=function(x) dt(x*sqrt(3)/(act.sd), df=3)
    
  }
  if(dist==6){    #F dist
    df1=runif(1, 1, 20)
    df2=runif(1, 4, 20)
    act.sd=sqrt((2*df2^2*(df1+df2-2))/(df1*(df2-2)^2*(df2-4)))
    act.mean=df2/(df2-2)
    guess.mean=act.mean
    distFun=function(x) df(x, df1=df1, df2=df2)
  }
  if(dist==7){    #Chi Squared  ## May need to have scale adjusted, currently SD values of >4 
    df=act.sd^2/2   #             ## have a mean around 7 and it cuts off around the peak of the hump
    act.mean=df
    guess.mean=df
    distFun=function(x) dchisq(x, df=df)
  }  
  return(distFun)
  
})



myFun=function(guess.sd, myDist, sol, nxt){  
  percent.off = abs((guess.sd-act.sd)/act.sd)*100
  guess=dnorm(x, sd=guess.sd, mean=guess.mean)
  actual=dnorm(x,sd=act.sd, mean=act.mean)
  
  #=========
  myPanel=function(x,y, ...){
    panel.xyplot(x,y, lwd=2, type ="l", col=dist.col)
    panel.xyplot(x, guess, lwd=2, type = "l", col=guess.col)
    lpolygon(c(min(x),x,max(x)),c(0,y,0), border=FALSE, col =trans.dist.col)
    lpolygon(c(min(x),x,max(x)),c(0,guess,0), border=FALSE, col = trans.guess.col)
    larrows(x0=guess.mean, x1=-guess.sd+guess.mean, 
            y0=dnorm(guess.sd+guess.mean, mean=guess.mean, sd=guess.sd),
            y1=dnorm(guess.sd+guess.mean, mean=guess.mean, sd=guess.sd),
            length=.1, lwd=2, col=guess.col)
    
  }
  #==========  
  solPanel=function(x,y, ...){
    panel.xyplot(x,y, lwd=2, type ="l", col=dist.col)
    panel.xyplot(x, guess, lwd=2, type = "l", col=guess.col)
    panel.xyplot(x, actual, lwd=2, type ="l", col = actual.col)
    lpolygon(c(min(x),x,max(x)),c(0,y,0), border=FALSE, col =trans.dist.col)
    lpolygon(c(min(x),x,max(x)),c(0,guess,0), border=FALSE, col = trans.guess.col)
    lpolygon(c(min(x),x,max(x)),c(0,actual,0), border=FALSE, col= trans.actual.col)
    larrows(x0=guess.mean, x1=-guess.sd+guess.mean, 
            y0=dnorm(guess.sd+guess.mean, mean=guess.mean, sd=guess.sd),
            y1=dnorm(guess.sd+guess.mean, mean=guess.mean, sd=guess.sd),
            length=.1, lwd=2, col=guess.col)
    larrows(x0=act.mean, x1=act.sd+act.mean, 
            y0=dnorm(act.sd+act.mean, mean=act.mean, sd=act.sd),
            y1=dnorm(act.sd+act.mean, mean=act.mean, sd=act.sd),
            length=.1, lwd=2, col=actual.col)      
    grid.text(x=unit(.03, "npc"), y=unit(.95, "npc"),
              label=paste("Your SD:", signif(guess.sd, 3)), just="left", 
              gp=gpar(col=guess.col))
    grid.text(x=unit(.97, "npc"), y=unit(.95, "npc"),
              label=paste("Actual SD:", signif(act.sd, 3)), just="right",
              gp=gpar(col=rgb(0,.5,0,1)))
  }
  if(percent.off<20)
    perc.text=paste("You were", signif(percent.off, 3), "percent off. Nice!")
  else
    perc.text=paste("You were", signif(percent.off, 3), "percent off. It seems you've deviated from your studies...")
  
  if(sol==TRUE){
    myPlot = xyplot(myDist(x)~x, type = "l", panel=solPanel,
           scales = list(x=list(cex=1.7)), ylab="Probability",
           main=perc.text)
    print(myPlot)
#       if (sol==FALSE) {
#         myPlot = xyplot(dist~x, type = "l", panel=myPanel, ylab="Probability",
#                         scales = list(x=list(cex=1.7)))
#         print(myPlot)
#       }
  }  
  else{
    myPlot = xyplot(myDist(x)~x, type = "l", panel=myPanel, ylab="Probability",
           scales = list(x=list(cex=1.7)))
    print(myPlot)
#    iter = iter + nxt
  }
}