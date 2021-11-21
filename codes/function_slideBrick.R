cat("\nslideBrick(), a function to comput statistics calculated through 
  the bands of a sliding (moving) windows over a hyperspectral 
  image (raster brick)\n")

source("https://raw.githubusercontent.com/arsilva87/hyperweeds/main/codes/function_slideWindows.R")

slideBrick <- function(Brick, slide_windows, fun = median) 
{
   stopifnot(inherits(slide_windows, "slideWindows"))
   win_exts <- slide_windows
   brickset <- lapply(win_exts, crop, x = Brick)
   stats <- sapply(brickset, cellStats, stat = fun)
   return(stats)
}