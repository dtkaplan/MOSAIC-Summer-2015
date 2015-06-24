#' Translates a compressed shapefile into the glyph-ready .rda file
#'
#' See \code{install_shapefiles_from_listing()} for an example of use. In addition to
#' creating data tables "[name]_shapefile" and "[name]_datafile" in the global environment,
#' this function creates a "[name].rda" file in the current working directory.
#'
#' @export
install_shapefile <- function(name, location, zfile, id_variable="GMI_ADMIN") {
  where <- tempdir()
  # clean up
  file.remove(paste(where, dir(path=where, pattern=".{3}$"), sep="/")) # delete temp files

  dest_file <- paste0(where, '/shapefile.zip')
  source_file <- paste0(location, zfile)
  download.file(url = source_file,
                destfile = dest_file,
                method = 'curl')
  unzip(zipfile = dest_file, exdir = where)
  # find the code name used in the files
  code <- gsub(".dbf", "", dir(path = where, pattern = ".dbf"))
  shapes <- rgdal::readOGR(dsn = where, code)
  country_shapes <- ggplot2::fortify(shapes, region=id_variable)
  country_data <- foreign::read.dbf(paste0(where, "/", code, ".dbf" ))
  country_data$id <- country_data[[id_variable]]
  assign(paste0(name, "_shapes"), country_shapes, envir=.GlobalEnv)
  assign(paste0(name, '_data'), country_data, envir=.GlobalEnv)
  do.call("save",
          as.list(c(ls( pattern=paste0("^", name,
                                       "_(shapes|data)$"),
                        envir=.GlobalEnv),
                    file=paste0(name, "_shapefile.rda")
          )
          )
  )
  file.remove(paste(where, dir(path=where), sep="/")) # delete temp files

}

