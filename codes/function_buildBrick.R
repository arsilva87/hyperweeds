cat("\nbuildBrick(), a function to build raster layers (brick, stack) from a .h5 
	file containing hypespectral data of the Senop HSC-2 camera.\n")

buildBrick <- function(path, 
        spectral_feature = c("radiance", "dn", "reflectance"), 
        layers = 35)    # ref. band
{
   feat <- match.arg(spectral_feature)
   dat <- rhdf5::h5read(path, paste0("array_", feat), 
      index = list(NULL, NULL, layers), 
      read.attributes = TRUE)
   ra <- raster::brick(dat)
   extent(ra) <- raster::extent(c(attr(dat, "spatial_extent")))
   crs(ra) <- attr(dat, "CRS")
   return(ra)
}
