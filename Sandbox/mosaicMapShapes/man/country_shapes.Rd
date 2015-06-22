\name{Country Shape Files}
\alias{Country Shape Files}
\docType{data}
\title{
Shapefiles for drawing choropleth-type maps
}
\description{
There are two data tables for each country: a shape file and a data file.  The \code{[country_code]_data} file contains a small bit of information about the geographical elements (provinces, states, districts, etc.) in the country. The \code{[country_code]_shapes} is the shapefile for those elements.  See "examples".
}
\usage{}
\format{
  The shapefile ... FILL THIS IN
  \describe{
    \item{\code{x}}{a numeric vector}
    \item{\code{y}}{a numeric vector}
  }
  The datafile ... FILE THIS IN
}
\details{
The countries:
\describe{
  \item{\code{af}}{Afghanistan}
  \item{\code{ag}}{Angola}
  \item{\code{ca}}{Canada}
  \item{\code{ch}}{China}
  \item{\code{mx}}{Mexico}
  \item{To do}{List the others as well here }

}
}
\source{
%%  ~~ reference to a publication or URL from which the data were obtained ~~
}
\references{
The CDC and other sites ... GIVE URLS here
}
\examples{
\dontrun{
library(ggplot2)
# for Canada, country code \code{ca}.
ggplot(ca_shapes, aes(x=long, y=lat, group=group)) + geom_path()
}
}
}
\keyword{maps}
