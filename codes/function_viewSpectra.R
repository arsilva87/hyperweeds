cat("\nviewSpectra(), a function to visualize statistics calculated 
  through the bands of a hyperspectral image (raster brick)\n")

viewSpectra <- function(x, ...) {
   if (length(dim(x)) > 1) bands <- rownames(x) else bands <- names(x)
   wavelength <- as.numeric(sub("b", "", bands))
   matplot(wavelength, x, type = "l", ...)
}
