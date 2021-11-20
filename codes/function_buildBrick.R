cat("\nbuildBrick(), a function to read ENVI data from hyperspectral 
 image and to readly build the spatial raster brick (stack)\n")

buildBrick <- function(path, 
	path_hdr = sub(".dat", ".hdr", path),
	hFOV = NULL, vFOV = NULL, height = NULL,
	ref_layer = 1, radiance = TRUE)
{
   HDR <- read_hdr_envi(path_hdr, hFOV, vFOV, height)
   dat <- caTools::read.ENVI(path, path_hdr)
   A <- array(dat, dim = HDR$dim)
   if(radiance) {
      A <- sweep(A, 3, HDR$gain, FUN = "*")
   }
   rb <- raster::brick(A)
   if(!is.null(HDR$extents)) {
      extent(rb) <- raster::extent(HDR$extents[ref_layer,])
      crs(rb) <- HDR$CRS
   }
   attr(rb, "bands") <- HDR$wavelength
   return(rb)
}
