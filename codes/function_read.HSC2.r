cat("\nread.HSC2(), a function to read hyperspectral data from the \nSenop HSC-2 camera\n")

read.HSC2 <- function(path, headerfile = sub(".dat", ".hdr", path)) 
{
   # retrieving spectral attributes
   h <- read.table(headerfile, sep = "=", strip.white = TRUE, 
        row.names = NULL, as.is = TRUE, fill = TRUE)
   n_rows <- as.integer(h[3, 2])
   n_cols <- as.integer(h[4, 2])
   n_bands <- as.integer(h[10, 2])
   N <- n_rows * n_cols * n_bands
   wave_length <- as.numeric(gsub("[[:punct:]]", "", 
      gsub(".0", "", unlist(strsplit(h[13, 2], split = ",")), 
         fixed = TRUE)))
   gain <- as.numeric(gsub("}", "", 
      gsub("{", "", unlist(strsplit(h[15, 2], split = ",")), 
         fixed = TRUE), fixed = TRUE))
   irradiance <- as.numeric(gsub("}", "", 
      gsub("{", "", unlist(strsplit(h[16, 2], split = ",")), 
         fixed = TRUE), fixed = TRUE))

   # retrieving coordinates
   coords <- bandcoords(headerfile)

   # retrieving raw data (digital numbers)
   X <- readBin(path, what = integer(), n = N, 
      size = 2, signed = FALSE, endian = "swap")
   A <- array(X, dim = c(n_cols, n_rows, n_bands))
   cat("Read", object.size(A)/1000000, 
      "Megabytes from array of dim.", dim(A), "\n")
   attr(A, "wavelength") <- wave_length
   attr(A, "gain") <- gain
   attr(A, "irradiance") <- irradiance
   attr(A, "coordinates") <- as.matrix(coords)
   return(A)
}

# --------------------------------------
cat("\nbandcoords(), a function to retrieve the spatial coordinates \nof each spectral band from header files of the Senop HSC-2 camera\n")

bandcoords <- function(x) 
{
   rr <- readLines(x)[24]
   ss <- unlist(strsplit(rr, "GNRMC,"))[-1]
   locN <- regexpr("A,", ss) + 2
   locE <- regexpr("N,", ss) + 2
   n <- as.numeric(substring(ss, locN, locN + 1)) +
      as.numeric(substring(ss, locN + 2, locN + 3))/60 + 
         (as.numeric(substring(ss, locN + 5, locN + 8))/10000)/60
   e <- as.numeric(substring(ss, locE, locE + 2)) +
      as.numeric(substring(ss, locE + 3, locE + 4))/60 + 
         (as.numeric(substring(ss, locE + 6, locE + 9))/10000)/60
   return(data.frame(x = e, y = n))
}
