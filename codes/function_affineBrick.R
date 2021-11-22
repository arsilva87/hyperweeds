cat("\naffineBrick(), a function to apply affine transformations ,i.e., 
  rotation and translation on a brick or raster.\n")

affineBrick <- function(Brick, angle = 0, xy_shift = c(0, 0)) 
{
   stopifnot(angle >= -360 & angle <= 360)
   if (angle != 0 & angle != 360 & angle != -360) { 
      xy <- coordinates(Brick)
      a <- angle*pi/180
      rot <- matrix(c(cos(a), -sin(a), sin(a), cos(a)), nrow = 2)
      cen <- colMeans(xy)
      rxy <- sweep(sweep(xy, 2, cen) %*% rot, 
         2, cen + xy_shift, FUN = "+")
      rxy <- as.data.frame(rxy)
      colnames(rxy) <- c("x", "y")
      coordinates(rxy) <- ~x+y
      rb <- raster::brick()
      extent(rb) <- extent(rxy)
      crs(rb) <- crs(Brick)
      newb <- rasterize(x = rxy, y = rb, field = values(Brick))
   } else {
      newb <- Brick
   }
   return(newb)
}
