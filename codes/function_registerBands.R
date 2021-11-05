
cat("\nregisterBands(), a function for raster-to-raster registration (alignment)\n",
   "based on mutual info. of texture descriptors (GLCM).\n",
   "Warning: it does not correct rotation, only translation (xy) shifts.\n")

registerBands <- function(master, slave, px = 15) {
   r1 <- master; r2 <- slave
   tex1 <- glcm::glcm(r1, statistics = "entropy")
   tex2 <- glcm::glcm(r2, statistics = "entropy")
   nr <- nrow(r1)
   nc <- ncol(r1)
   pol <- extent(round(c(nc/2, 3*nc/4, nr/2, 3*nr/4)))
   tex1_pol <- crop(tex1, pol)
   gr <- expand.grid(x = seq(-px, px), y = seq(-px, px))
   exts_aux <- kronecker(as.matrix(gr), matrix(c(1, 1), nr = 1))
   for(i in 1:nrow(gr)) {
      tex2_poli <- crop(tex2, extent(pol[] + exts_aux[i, ]))
      gr[i, 3] <- infotheo::mutinformation(X = round(values(tex1_pol)*10000), 
         Y = round(values(tex2_poli)*10000))
   }
   o <- which.max(gr[, 3])
   drift <- gr[o, 1:2]
   r2_shifted <- shift(r2, dx = -drift[1], dy = -drift[2])
   intersect(r2_shifted, r1)
}
