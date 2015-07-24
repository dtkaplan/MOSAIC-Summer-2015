library(mosaicData)

if( !require(manipulate) ) 
    stop("Must use a manipulate-compatible version of R, e.g. RStudio")

datasets <- list("Galton" = Galton, "KidsFeet" = KidsFeet,  "Heightweight" = Heightweight,
                 "SwimRecords" = SwimRecords, "TenMileRace" = TenMileRace)


