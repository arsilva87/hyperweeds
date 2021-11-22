cat("\naffineBrick(), a function to apply affine transformations ,i.e., 
  rotation and translation on a brick or raster.\n")

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
      newb <- Brick
   }
   return(newb)
}