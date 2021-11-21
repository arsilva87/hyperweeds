cat("\nslideWindows(), a function to create sliding windows over a raster.\n")

slideWindows <- function(x, n = c(8, 8))
{
   test_class <- c("Extent", "RasterLayer", 
      "RasterBrick", "RasterStack")
   stopifnot(any(test_class %in% class(x)))
   ext <- raster::extent(x)[] 
   stopifnot(any(n > 1))
   n <- as.integer(n)
   x_win <- diff(ext[1:2])/n[1]
   y_win <- diff(ext[3:4])/n[2]
   win1 <- c(ext[1], ext[1] + x_win, ext[3], ext[3] + y_win)
   gr <- expand.grid(x = 0:(n[1]-1), y = 0:(n[2]-1))
   wins <- t(apply(gr, 1, function(z) {
      c(win1[1:2] + x_win*z[1], win1[3:4] + y_win*z[2])
   }))
   win_exts <- apply(wins, 1, extent)
   class(win_exts) <- "slideWindows"
   attr(win_exts, "win_size") <- c(x = x_win, y = y_win)
   return(win_exts)
}
