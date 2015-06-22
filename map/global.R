
library(mosaicData)

geom_aesthetics <- list(
  geom_path = list(color = "any", group = "any", linetype = "few", size = "num_or_few", alpha="num_or_few"
  ),
  geom_polygon = list(color = "any", group = "any", fill = "few", linetype = "few", size = "num_or_few", alpha="num_or_few"
  ),
  geom_point = list(x = "any", y = "any", color = "num_or_few", size = "num_or_few", 
                    alpha = "num_or_few", fill = "few", shape = "few"
  )
  
)