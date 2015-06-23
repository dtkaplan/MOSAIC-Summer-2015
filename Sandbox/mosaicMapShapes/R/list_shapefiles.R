#' List the available resources
#'
#' @return  a data table. Each shapefile is one case.  The shape data are available under
#' the \code{code} variable.
#'
#' @seealso \code{get_shapefile()} \code{get_datafile()}
#'
#' @export
list_shapefiles <- function(type = NULL) {
  shape_table <-
    read.csv(
      system.file("shape_file_sources.csv", package = "mosaicMapShapes"),
      stringsAsFactors = FALSE
    )
  if (is.null(type)) {
    return(shape_table)
  } else {
    return(shape_table[shape_table$type == type,])
  }
}
