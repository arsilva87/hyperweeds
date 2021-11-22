cat("\naffineCoords(), a function to apply affine transformation, i.e.,
  rotation and translation on the 2D coordinates of a spatial object, 
  such as extent, raster/brick/stack, SpatialPolygon etc.).\n")

affineCoords <- function(s, angle = 0, xy_shift = c(0, 0)) 
{
   stopifnot(angle >= -360 & angle <= 360)
   xy <- coordinates(s)
   if (angle != 0 & angle != 360 & angle != -360) { 
      a <- angle*pi/180
      rot <- matrix(c(cos(a), -sin(a), sin(a), cos(a)), nrow = 2)
      cen <- colMeans(xy)
      rxy <- sweep(sweep(xy, 2, cen) %*% rot, 
         2, cen + xy_shift, FUN = "+")
      rxy <- as.data.frame(rxy)
      colnames(rxy) <- c("x", "y")
      coordinates(rxy) <- ~x+y
      new_coords <- rxy
   } else {
      new_coords <- xy
   }
   return(new_coords)
}
