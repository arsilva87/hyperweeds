
cat("\nregisterBand3(), a function for band-to-band (raster layers) 
  registration (spatial alignment, translation and rotation) 
  based on HOG descriptor.\n")
cat("Warning: use it carefully, for rotation affects the spatial dimensions.\n")

source("https://raw.githubusercontent.com/arsilva87/hyperweeds/main/codes/function_affineBrick.R")

registerBand3 <- function(slave, master, ncells = 24, orient = 8) 
{
   bx <- res(master)[1] * ncol(master)/10
   by <- res(master)[2] * nrow(master)/10
   ex <- extent(master)[]
   pol <- extent(c(ex[1]+bx, ex[2]-bx, ex[3]+by, ex[4]-by))
   r1c <- crop(master, pol)
   hog1 <- OpenImageR::HOG(as.matrix(r1c), cells = ncells, 
      orientations = orient)
   fun_affine <- function(par) {
      sx <- par[1]; sy <- par[2]; a <- par[3]
      affpol <- affineCoords(pol, angle = a, c(sx, sy))
      r2c <- crop(slave, extent(affpol))
      hog2 <- OpenImageR::HOG(as.matrix(r2c), cells = ncells, 
         orientations = orient)
      dist(rbind(hog1, hog2))[1]
   }
   p <- dfoptim::nmk(c(0, 0, 0), fun_affine)
   sx <- p$par[1]; sy <- p$par[2]; a <- p$par[3]
   fixed <- affineBrick(slave, a, c(-sx, -sy))
   attr(fixed, "affine_pars") <- c(angle = a, sx = sx, sy = sy)
   return(fixed)
}
