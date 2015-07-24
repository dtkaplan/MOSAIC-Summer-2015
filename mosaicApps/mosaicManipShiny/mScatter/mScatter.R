mScatter <- function(dat,Xaxis,Yaxis,Color,Facet,Size....) {
  
  nm = varsByType(head(data))
  # nm$q is the quantitative variables.
  snames <- NAprepend(nm$all)
  cnames <- NAprepend(nm$c)
  mnames <- list("none", linear="linear","smoother")
  
  # Utilities
  # Pull out the names of the quantitative and categorical variables in a data frame
  varsByType = function(data) {
    # Utility function for converting a vector of names into a list.
    v2list <- function(nms) {
      res = list()
      res[nms] <- nms
      return(res)
    }
    nm = names(data)
    type = nm
    for (k in 1:length(data)) type[k] <- class(data[[k]])
    numberNames <- v2list(nm[type %in% c("integer","numeric")])
    factorNames <- v2list(nm[type %in% c("factor","character","logical","ordered")])
    return( list( c=factorNames, q=numberNames, all=v2list(nm) ) )
  }
  # Prepend a list with NA for optional items
  NAprepend <- function(L) {
    c(list(`none `=NA),L)
  }
  
  # Converting a vector of names into a list.
  v2list <- function(nms) {
    res = list()
    res[nms] <- nms
    return(res)
  }
  
  
  df = substitute(dat)
  scatter<-doScatter(show,df,x=Xaxis,y=Yaxis,color=Color,size=Size,
                           facet=Facet,logx=Logx,logy=Logy,model=Model)
  # Utility:
  doScatter <- function(show=FALSE,dname,x=NA,y=NA,color=NA,size=NA,facet=NA,logx=FALSE,logy=FALSE,model=""){
    vals <- list(dat=dname,x=x,y=y,color=color,size=size,facet=facet,logx=logx,logy=logy,model=model)
    s <- scatterString(vals)
    if (show) cat(paste(s,"\n"))
    p <- eval(parse(text=s))
    print(p)
    return(p)}
  
  
  print(scatter)      

  
#   mScatter <- function(dat) {
#     df = substitute(dat)
#     nm = varsByType(head(dat))
#     # nm$q is the quantitative variables.
#     snames <- NAprepend(nm$all)
#     cnames <- NAprepend(nm$c)
#     mnames <- list("none", linear="linear","smoother")
#     manipulate({p<-doScatter(show,df,x=x,y=y,color=color,size=size,
#                              facet=facet,logx=logx,logy=logy,model=model)},
#                show = button("Show Expression"),
#                x = picker(nm$q,initial=nm$q[[1]],label="x axis"),
#                y = picker(nm$q,initial=nm$q[[2]],label="y axis"),
#                color = picker(snames, initial="none ",label="Color"),
#                size = picker(snames, initial="none ",label="Size"),
#                facet = picker(cnames, initial="none ", label="Facet"),
#                logx = checkbox(label="Log X-axis"),
#                logy = checkbox(label="Log Y-axis"),
#                model = picker(mnames, initial="none", label="Model")
#     )
#   }  
#   


}

