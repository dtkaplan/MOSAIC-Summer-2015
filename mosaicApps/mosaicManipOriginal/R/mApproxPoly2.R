#' Interactive applet for exploring fitting multivariate models
#' 
#' Displays a shaded level and contour plot. A circle in which z values are
#' fitted based on the best linear combination of terms selected is
#' overplotted. Root mean squared error of the fit is displayed as the title.
#' 
#' The x and y sliders change where in the plane the circle is centered, and
#' the radius slider adjusts how large the circle of fitted values is. Each
#' checkbox adds the indicated term to the fitted function. The circle
#' transparency slider controls the transparency of the circle, where 1 is
#' opaque and 0 is invisible - it is an alpha transparency. Number of pixels
#' controls how many points are in the square grid upon which the function is
#' calculated. \code{mApproxPoly2} may run slower at higher pixel counts.
#' Approximate number of contour lines is a slider that controls the number of
#' contour lines through the \code{pretty} algorithm such that they are evenly
#' spaced at nice intervals.
#' 
#' @param expr A mathematical formula of two variables of the form f(x,y)~x&y)
#' @param \dots Extra arguments to be passed with \code{expr} as part of the
#' mathematical function. Generally these are not evaluated.
#' @param xlim The limits of the x axis.
#' @param ylim The limits of the y axis.
#' @return A function that implements and displays the colored level plot
#' contour plot of a given two-dimensional function, and plots a best fit
#' function with selected variables in a transparent circle over the plot.
#' @author Andrew Rich (\email{andrew.joseph.rich@@gmail.com}) and Daniel
#' Kaplan (\email{kaplan@@macalester.edu})
#' @keywords calculus multivariate calculus
#' @examples
#' 
#' if(require(manipulate)) {
#' mApproxPoly2(sin(x*y)~x&y)
#' mApproxPoly2(sin(x*y)+cos(x)~x&y, xlim=c(0,5), ylim=c(0,5))
#' }
#' 
mApproxPoly2 = function(expr, ..., xlim = c(0,1), ylim = c(0,1)){
  if(!require(manipulate)) 
	  stop("Must use a manipulate-compatible version of R, e.g. RStudio")
  if (!require("mosaic")) stop("Must install mosaic package.")

  vals = list(...) 
  #fun = mosaic:::.createMathFun(sexpr = substitute(expr), ...)
  fun=mosaic::makeFun(expr)
  ylab = fun$names[2]
  xlab = fun$names[1]
  xlim2 = xlim
  ylim2 = ylim
  if( fun$names[1] %in% names(vals) ) {
    xlim2 = vals[[fun$names[1]]]
      }
  if( fun$names[2] %in% names(vals) ) {
    ylim2 = vals[[fun$names[2]]]
      }
         
  #=======================       
    myFun = function(xpt=xpt, ypt=ypt, radius = radius, const=const, xyes=xyes, yyes=yyes, xyyes=xyyes,
                     xsqyes=xsqyes, ysqyes=ysqyes, myalpha=myalpha, nlevels = nlevels, npts=npts){
      .xset = seq(min(xlim2),max(xlim2),length=npts)
      .yset = seq(min(ylim2),max(ylim2),length=npts)
      .zset = (outer(.xset, .yset, fun$fun )) #.zset is a npts x npts matrix
      minbig = min(.zset)
      maxbig = max(.zset) #THESE LINES NEED TO GO IN myFun if npts is a slider
      
      yMat = outer(rep(1, npts), .yset, "*") #2 matrices of xpts and ypts
      xMat = outer(.xset, rep(1, npts), "*")
      
      dist = (yMat-ypt)^2+(xMat-xpt)^2
      in.Circle = dist<radius^2
      xvals = xMat[in.Circle]          #creating a circle subset
      yvals = yMat[in.Circle]
      zvals = .zset[in.Circle]
      
      A = c()                          #creating the matrix to calculate coefs
      if(const){
        A=cbind(A, rep(1, length(zvals)))
      }
      if(xyes){
        A=cbind(A, xvals)
      }
      if(yyes){
        A=cbind(A, yvals)
      }
      if(xyyes){
        A=cbind(A, xvals*yvals)
      }
      if(xsqyes){
        A=cbind(A, xvals^2)
      }
      if(ysqyes){
        A=cbind(A, yvals^2)
      }

      coefs = qr.solve(A, zvals)
      newvals = A %*% coefs
      zNew = matrix(nrow=npts, ncol=npts)
      zNew[in.Circle] = newvals
      zNew[!in.Circle] = NA
      
      bigstart=.05; bigend=.95 #Not using full color spectrum to allow the fit to exceed the zrange
      
      maxsmall = max(newvals)
      minsmall = min(newvals)      #Making the colors from circle and background correspond to same values
      startparam = min(1,max(0,bigstart+ (bigend-bigstart)*(minsmall-minbig)/(maxbig-minbig)))
      endparam = max(0,min(1,bigend - (bigend-bigstart)*(maxbig-maxsmall)/(maxbig-minbig)))
      RMS = sqrt(mean((newvals-zvals)^2)*pi*radius^2)
      mylevels = pretty(range(.zset),nlevels)   #number of contours
      
      #Plotting!
      image( .xset, .yset, .zset, col=rainbow(npts, alpha=0.8, start=bigstart, end=bigend),
             add=FALSE, xlab=xlab,ylab=ylab,main=NULL )
      contour(.xset, .yset, .zset, col=rgb(0,0,0,.4),lwd=3,add=TRUE, labcex=1.2, 
              levels=mylevels, method="edge")
      image( .xset, .yset, zNew, col=rainbow(npts, start=startparam, end = endparam,alpha = myalpha),add=TRUE, xlab=xlab,ylab=ylab,main=NULL )
      contour(.xset, .yset, zNew, col="black",lwd=5, labcex=1.5, add=TRUE, 
              levels=mylevels,method="flattest")
      title(main = paste("RMS Error:", signif(RMS, 3)))
    }
    #=========================
manipulate(myFun(xpt=xpt, ypt=ypt, radius = radius, const=const, xyes=xyes, yyes=yyes, xyyes=xyyes, 
                 xsqyes=xsqyes, ysqyes=ysqyes, myalpha=myalpha, nlevels=nlevels, npts = npts),
           xpt = slider(min(xlim2),max(xlim2), initial = mean(xlim2), label = paste("Circle center:", xlab), step=.01),
           ypt = slider(min(ylim2),max(ylim2), initial = mean(ylim2), label = paste("Circle center:", ylab), step=.01),
           radius = slider(.01, (min(max(xlim2),max(ylim2))), initial = .5*mean(min(max(xlim2),max(ylim2)))),
           const = checkbox(TRUE, label = "Constant"),
           xyes = checkbox(TRUE, label = "x"),
           yyes = checkbox(FALSE, label = "y"),
           xyyes = checkbox(FALSE, label = "xy"),
           xsqyes = checkbox(FALSE, label = "x^2"),
           ysqyes = checkbox(FALSE, label = "y^2"),
           myalpha = slider(0,1, initial = .5, label = "Circle Transparency"),
           npts = slider(20, 200, initial = 100, label = "Number of pixels"),
           nlevels = slider(5, 50, initial = 20, label = "Approx. number of contour lines")
           )
}

#Take out col.scheme
#x and y axis reversed
