% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/install_shapefiles_from_listing.R
\name{install_shapefiles_from_listing}
\alias{install_shapefiles_from_listing}
\title{Install shapefiles for setting up the package}
\usage{
install_shapefiles_from_listing(listing)
}
\description{
This is not intended for users and not exported from the package.
How to use ... Find a compressed shapefile that you want.  Enter a unique but informative
name for that shapefile in the \code{inst/shape_file_sources.csv} file.  You will need to look
at the .dbf file to find a suitable id variable.
(Suitable means that each row in the .dbf has a unique value.) Often this means you
will have to download the shapefile manually and look at the dbf file (using \code{foreign::read.dbf()}
before you will know what the id variable will be.
}
\examples{
\dontrun{
shapes_in_package <- list_shapefiles()
install_shapefiles_from_listing(shapes_in_package)
}
}

