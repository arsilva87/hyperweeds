cat("\naffineBrick(), a function to apply affine transformations of 
  rotation and translation on the 2D spatial coordinates of a brick/raster.\n")

source("https://raw.githubusercontent.com/arsilva87/hyperweeds/main/codes/function_affineCoords.R")

affineBrick <- function(Brick, angle = 0, xy_shift = c(0, 0)) 
{
   stopifnot(angle >= -360 & angle <= 360)
   if (angle != 0 & angle != 360 & angle != -360) { 
      rxy <- affineCoords(Brick, angle, xy_shift)
      rb <- raster::brick()
      extent(rb) <- extent(rxy)
      crs(rb) <- crs(Brick)
      newb <- rasterize(x = rxy, y = rb, field = values(Brick))
   } else {
      newb <- shift(Brick, xy_shift[1], xy_shift[2])
   }
   return(newb)
}