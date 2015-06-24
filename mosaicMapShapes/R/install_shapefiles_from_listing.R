#' Install shapefiles for setting up the package
#'
#' This is not intended for users and not exported from the package.
#' How to use ... Find a compressed shapefile that you want.  Enter a unique but informative
#' name for that shapefile in the \code{inst/shape_file_sources.csv} file.  You will need to look
#' at the .dbf file to find a suitable id variable.
#' (Suitable means that each row in the .dbf has a unique value.) Often this means you
#' will have to download the shapefile manually and look at the dbf file (using \code{foreign::read.dbf()}
#' before you will know what the id variable will be.
#'
#'
#' @examples \dontrun{
#' shapes_in_package <- list_shapefiles()
#' install_shapefiles_from_listing(shapes_in_package)
#' }

install_shapefiles_from_listing <- function(listing) {
  # listing will typically be a row or rows from <list_shapefiles()>
  for (k in 1:nrow(listing)) {
    T <- listing[k,]
    with(T, install_shapefile(name=name,
                              location = location,
                              zfile = compressed_file,
                              id_variable = id)
    )
  }

  return(listing$name)
}
