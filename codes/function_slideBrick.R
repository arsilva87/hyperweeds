cat("\nslideBrick(), a function to comput statistics calculated through 
  the bands of a sliding (moving) windows over a hyperspectral 
  image (raster brick)\n")

source("https://raw.githubusercontent.com/arsilva87/hyperweeds/main/codes/function_slideWindows.R")

slideBrick <- function(Brick, n = c(8, 8), fun = median) 
{
   win_exts <- slideWindows(Brick, n = n)
   brickset <- lapply(win_exts, crop, x = Brick)
   stats <- sapply(brickset, cellStats, stat = fun)
   class(stats) <- "slideBrick"
   return(stats)
}