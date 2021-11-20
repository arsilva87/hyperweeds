cat("\nbuildBrick(), a function to read ENVI data from hyperspectral 
 image and to readly build the spatial raster brick (stack)\n")

buildBrick <- function(path, 
	path_hdr = sub(".dat", ".hdr", path),
	hFOV = NULL, vFOV = NULL, height = NULL,
	ref_layer = 1, 
	spectral_feature = c("raw", "radiance", "reflectance"),
	reflectance_method = c("irradiance", "white_panel"),
	DOS = TRUE, dark_path = NULL, dark_quantile = 0.25,
	white_path = NULL)
{
   HDR <- read_hdr_envi(path_hdr, hFOV, vFOV, height)
   dat <- caTools::read.ENVI(path, path_hdr)
   A <- array(dat, dim = HDR$dim)
   if (DOS) {
      if(is.null(dark_path)) 
         stop("Please provide the path for the dark reference file.")
      dark_raw <- caTools::read.ENVI(dark_path, 
         sub(".dat", ".hdr", dark_path))
      dark_cube <- array(dark_raw, dim = HDR$dim)
      dark_vals <- apply(dark_cube, 3, quantile, 
         p = dark_quantile)
      A <- sweep(A, 3, dark_vals)
   }
   feat <- match.arg(spectral_feature)
   if (feat == "radiance") {
      A <- sweep(A, 3, HDR$gain, FUN = "*")
   } else if (feat == "reflectance") {
      refl <- match.arg(reflectance_method)
      if(refl == "irradiance") {
         rad_cube <- sweep(A, 3, HDR$gain, FUN = "*")
         A <- sweep(rad_cube, 3, HDR$irradiance, FUN = "/")
      } else {
         white_raw <- caTools::read.ENVI(white_path, 
            sub(".dat", ".hdr", white_path))
         white_cube <- array(white_raw, dim = HDR$dim)
         if (DOS) white_cube <- sweep(white_cube, 3, dark_vals)
         white_vals <- apply(white_cube, 3, max)
         A <- sweep(A, 3, white_vals, FUN = "/")
      } 
   }
   rb <- raster::brick(A)
   if(!is.null(HDR$extents)) {
      extent(rb) <- raster::extent(HDR$extents[ref_layer,])
      crs(rb) <- HDR$CRS
   }
   attr(rb, "wavelength") <- HDR$wavelength
   return(rb)
}
