cat("\nrotateRaster(), a function to rotate a raster object \nin a specified angle.\n")

rotateRaster <- function(r, angle = 0) {
   stopifnot(angle >= -360 & angle <= 360)
   if (angle != 0 & angle != 360 & angle != -360) { 
      xy <- coordinates(r)
      a <- angle*pi/180
      rot <- matrix(c(cos(a), -sin(a), sin(a), cos(a)), nrow = 2)
      xyr <- xy %*% rot 
      dif_cen <- apply(xyr, 2, mean) - apply(xy, 2, mean)
      xy_rot <- data.frame(sweep(xyr, 2, dif_cen))
      colnames(xy_rot) <- c("x", "y")
      coordinates(xy_rot) <- ~x+y
      rr <- raster()
      extent(rr) <- extent(xy_rot)
      crs(rr) <- crs(r)
      rrot <- rasterize(x = xy_rot, y = rr, field = values(r))
   } else {
      rrot <- r
   }
   rrot
}