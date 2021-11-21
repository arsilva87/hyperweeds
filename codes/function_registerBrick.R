cat("\nregisterBrick(), a function for band-to-band (raster layers) 
   registration (spatial alignment) based on HOG descriptor.
Warning: it does not correct rotation, only translation (xy) shifts.\n")

registerBrick <- function(Brick, ref_layer = 1, 
	layers = "all",
	ncells = 24, orient = 8) 
{
   if (layers[1] == "all") {
      w <- 1:nlayers(Brick) 
   } else { 
      w <- as.integer(layers)
   }
   fRegBrick <- function(j, Brick, ref_layer) {
      registerBand(Brick[[ref_layer]], slave = Brick[[j]],
         ncells = ncells, orient = orient)
   }
   newbands <- pbapply::pblapply(w, fRegBrick, 
      Brick = Brick, ref_layer = ref_layer)
   rexts <- t(sapply(newbands, function(x) extent(x)[]))
   cropped_ext <- extent(c(max(rexts[,1]), min(rexts[,2]),
      max(rexts[,3]), min(rexts[,4])))
   newlist <- lapply(newbands, function(x) {
      origin(x) <- c(0,0)      
      crop(x, cropped_ext)
   })
   regbrick <- brick(newlist)
   return(regbrick)
}

