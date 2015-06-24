
library(mosaicData)


library(mosaicMapShapes)

 lst<-data(package="mosaicMapShapes")$results[,"Item"]
# lst1 <- grepl("_data",lst)
# data_lst <- list()
# data_lst <- as.list(lst[lst1])
# lst2 <- grepl("_shapes",lst)
# shapes_lst <- as.list(lst[lst2])

#
# tmp<-grep("_data",lst)
# data_lst<-lst[tmp]
# tmp<-grep("_shapes",lst)
# shapes_lst<-lst[tmp]
#
# lst1<- gsub("\(\w+\_shapefile\)", "", data_lst)

 lst<- list_shapefiles()$name
  data_lst <- paste0(lst,"_data")
  shapes_lst <- paste0(lst,"_shapes")



geom_aesthetics <- list(
  geom_path = list(color = "any", group = "any", linetype = "few", size = "num_or_few", alpha="num_or_few"
  ),
  geom_polygon = list(color = "any", group = "any", fill = "few", linetype = "few", size = "num_or_few", alpha="num_or_few"
  ),
  geom_point = list(x = "any", y = "any", color = "num_or_few", size = "num_or_few",
                    alpha = "num_or_few", fill = "few", shape = "few"
  )

)
