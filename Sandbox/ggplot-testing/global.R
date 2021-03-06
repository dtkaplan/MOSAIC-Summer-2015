# Name aesthetics for each geom type:

library(mosaicData)

geom_aesthetics <- list(
  geom_line  = list(x="any", y="any", 
                    color = "few", size="num_or_few", type="few",
                    group = "few"),
  geom_point = list(x="any", y="any", 
                    color="num_or_few", size ="num_or_few", alpha="num_or_few"),
  geom_bar   = list(x="any", y="any", color = "few", position = "bar_positions"),
  geom_blank = list(x="any", y="any")
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

# Storage for layers
layer_1_values <<- 
  reactiveValues(
    layer = 1,
    data = NULL, 
    geom = "geom_point",
    aes = data.frame(aes=c("x","y"), 
                     value=c("x","y"), 
                     role=rep("variable",2), 
                     stringsAsFactors=FALSE)
  ) 
layer_2_values <<-
  reactiveValues(
    layer = 2,
    data = NULL,
    geom = "geom_text",
    aes = data.frame(aes=c("x","y"), 
                     value=c("x","y"), 
                     role=rep("variable",2), 
                     stringsAsFactors=FALSE)
    )

# Helper functions

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
