cat("\nregisterBands(), a function for raster-to-raster registration (alignment)\n",
   "based on mutual info. of texture descriptors (GLCM).\n",
   "Warning: it does not correct rotation, only translation (xy) shifts.\n")

registerBands <- function(master, slave, px = 20) {
   r1 <- master; r2 <- slave
   nr <- nrow(r1); nc <- ncol(r1)
   extent(r1) <- extent(r2) <- extent(c(0, nc, 0, nr))
   tex1 <- glcm::glcm(r1, statistics = "entropy")
   tex2 <- glcm::glcm(r2, statistics = "entropy")
   pol <- extent(round(c(nc/2, 3*nc/4, nr/2, 3*nr/4)))
   tex1_pol <- crop(tex1, pol)
   vals1 <- round(values(tex1_pol)*10000)
   gr <- expand.grid(x = seq(-px, px), y = seq(-px, px))
   f_sxy <- function(s) {
      vals2 <- extract(tex2, extent(pol[] + c(s[1], s[1], s[2], s[2])))
      infotheo::mutinformation(X = vals1, Y = round(vals2*10000))
   }
   mi <- apply(gr, 1, f_sxy)
   sxy <- unlist(gr[which.max(mi), ])
   r2_shifted <- shift(r2, dx = -sxy[1], dy = -sxy[2])
   re <- res(slave)
   extent(r2_shifted) <- extent(extent(slave)[] - 
      c(re[1]*sxy[1], re[1]*sxy[1], re[2]*sxy[2], re[2]*sxy[2]))
   crs(r2_shifted) <- crs(slave)
   attr(r2_shifted, "shift") <- sxy
   return(r2_shifted)
}

