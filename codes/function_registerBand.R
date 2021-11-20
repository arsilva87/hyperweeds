cat("\nregisterBand(), a function for band-to-band (raster layers) 
   registration (spatial alignment) based on HOG descriptor.
Warning: it does not correct rotation, only translation (xy) shifts.\n")

registerBand <- function(slave, master, ncells = 24, orient = 8) 
{
   bx <- res(master)[1] * ncol(master)/10
   by <- res(master)[2] * nrow(master)/10
   ex <- extent(master)[]
   pol <- extent(c(ex[1]+bx, ex[2]-bx, ex[3]+by, ex[4]-by))
   r1c <- crop(master, pol)
   hog1 <- OpenImageR::HOG(as.matrix(r1c), cells = ncells, 
      orientations = orient)
   fun_sxy <- function(par) {
      sx <- par[1]; sy <- par[2]
      pol2 <- extent(pol[] - c(sx, sx, sy, sy))
      r2c <- crop(slave, pol2)
      hog2 <- OpenImageR::HOG(as.matrix(r2c), cells = ncells, 
         orientations = orient)
      dist(rbind(hog1, hog2))[1]
   }
   p <- dfoptim::nmk(c(0, 0), fun_sxy)
   sxy <- p$par
   r2_shifted <- shift(slave, dx = sxy[1], dy = sxy[2])
   attr(r2_shifted, "shift") <- sxy
   return(r2_shifted)
}
