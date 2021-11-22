cat("\naffineCoords(), a function to apply affine transformation of
  rotation and translation on the 2D coordinates of a spatial object, 
  such as extent, raster/brick/stack, SpatialPolygon etc.).\n")

affineCoords <- function(s, angle = 0, xy_shift = c(0, 0)) 
{
   stopifnot(angle >= -360 & angle <= 360)
   xy <- coordinates(s)
   a <- angle*pi/180
   cen <- colMeans(xy)
   aff_mat <- matrix(c(cos(a), -sin(a), cen[1] + xy_shift[1], 
      sin(a), cos(a), cen[2] + xy_shift[2]), nrow = 3)
   xy_cen <- sweep(xy, 2, cen)
   new_xy <- cbind(xy_cen, 1) %*% aff_mat
   return(new_xy)
}
