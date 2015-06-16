# Name aesthetics for each geom type:

library(mosaicData)

# Available datasets
# CHANGE THIS logic to pull from any of a list of packages.
datasets <- list( Galton = mosaicData::Galton, Heightweight = mosaicData::Heightweight,
                  SwimRecords = mosaicData::SwimRecords, TenMileRace = mosaicData::TenMileRace)


geom_aesthetics <- list(
  geom_line  = list(x = "any", y = "any", color = "few", alpha = "num",
                    size = "num_or_few", linetype = "few"),
  geom_point = list(x = "any", y = "any", color = "num_or_few", size = "num_or_few", 
                    alpha = "num_or_few", fill = "few", shape = "few"),
  geom_bar   = list(x = "any", color = "few", alpha = "num_or_few", fill = "few",
                    linetype = "few", size ="num_or_few", weight = "num_or_few"),
  geom_hline = list(x = "any", y = "any", alpha = "num_or_few", color = "num_or_few",
                    linetype = "few",size = "num_or_few"),
  geom_vline = list(x = "any", y = "any", alpha = "num_or_few", color = "num_or_few",
                    linetype = "few",size = "num_or_few"),
  geom_abline = list(x = "any", y = "any", alpha = "num_or_few", color = "num_or_few", 
                     linetype = "few", size = "num_or_few"),
  geom_smooth = list(x = "any", y = "any", color = "few", alpha = "num",
                     size = "num_or_few", linetype = "few", fill = "few", weight = "num_or_few"),
  geom_blank = list(x = "any", y = "any")
)

# Storage for the frame
# These need to be set by 
frame_def <<- reactiveValues(
  data = NULL,
  data_name = "",
  x = NULL,
  y = NULL,
  facet_x = NULL,
  facet_y = NULL
)

# Helper functions

layer_n_values <<- function(n){
  
  reactiveValues(
    layer = n,
    data = NULL,
    geom = "geom_text",
    aes = data.frame(aes=c("x","y"), 
                     value=c("x","y"), 
                     role=rep("variable",2), 
                     stringsAsFactors=FALSE)
  )
  
}


# Turn the layer values into something suited to do.call() in making plot.
make_geom_argument_list <- function(values) {

  mapping_inds <- 
    which(values$role == "variable")
  setting_inds <-
    which(values$role == "constant")
  map_list <- as.list((values$value[mapping_inds]))
  names(map_list) <- values$aes[mapping_inds]
  # turn numerals into numbers
  settings <- values$value[setting_inds]
  numerical_values <- as.numeric(settings)
  number_inds <- which(!is.na(numerical_values))
  set_list <- as.list(settings)
  for (ind in number_inds) set_list[[ind]] <- numerical_values[ind]
  names(set_list) <- values$aes[setting_inds]
  res <- list(mapping = do.call(aes_string, map_list))
  res <- c(res, set_list)
  
  res
}


new_aes_table_helper <- function(new_aes_names, old_aes_df) {
  new_df <- data.frame(aes=new_aes_names, stringsAsFactors=FALSE)
  dplyr::left_join(new_df, old_aes_df, by="aes")
}

