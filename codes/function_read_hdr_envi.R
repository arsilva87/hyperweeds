cat("\nread_hdr_envi(), a function to read and compute spatial 
 data from ENVI header files of remote sensing images\n")

read_hdr_envi <- function(path, 
	hFOV = NULL, vFOV = NULL, height = NULL) 
{
   # retrieving spectral attributes
   h <- read.table(path, sep = "=", strip.white = TRUE, 
        row.names = NULL, as.is = TRUE, fill = TRUE)
   o <- match(c("samples", "lines", "bands", "wavelength", 
      "data gain values", "solar irradiance"), h[,1])
   n_rows <- as.integer(h[o[1], 2])
   n_cols <- as.integer(h[o[2], 2])
   n_bands <- as.integer(h[o[3], 2])
   N <- n_cols * n_rows * n_bands
   wave_length <- as.numeric(gsub("[[:punct:]]", "", 
      gsub(".0", "", unlist(strsplit(h[o[4], 2], split = ",")), 
         fixed = TRUE)))
   gain <- as.numeric(gsub("}", "", 
      gsub("{", "", unlist(strsplit(h[o[5], 2], split = ",")), 
         fixed = TRUE), fixed = TRUE))
   irradiance <- as.numeric(gsub("}", "", 
      gsub("{", "", unlist(strsplit(h[o[6], 2], split = ",")), 
         fixed = TRUE), fixed = TRUE))
   # retrieving coordinates
   gps <- h[grep("gps", h[,1]), 2]
   ss <- unlist(strsplit(gps, "GNRMC,"))[-1]
   locN <- regexpr("A,", ss) + 2
   locE <- regexpr("N,", ss) + 2
   n <- as.numeric(substring(ss, locN, locN + 1)) +
      as.numeric(substring(ss, locN + 2, locN + 3))/60 + 
         (as.numeric(substring(ss, locN + 5, locN + 8))/10000)/60
   e <- as.numeric(substring(ss, locE, locE + 2)) +
      as.numeric(substring(ss, locE + 3, locE + 4))/60 + 
         (as.numeric(substring(ss, locE + 6, locE + 9))/10000)/60
   coords <- cbind(x = e, y = n)
   # building spatial extents
   if(!is.null(hFOV) & !is.null(vFOV) & !is.null(height)) {
      utm_zone <- floor((coords[1,1] + 180)/6) + 1
      utmproj <- paste0("+proj=utm +zone=", utm_zone, 
         " +datum=WGS84 +ellps=intl +units=m +no_defs")
      coords_utm <- rgdal::project(coords, utmproj)
      xfov <- hFOV*pi/180
      yfov <- vFOV*pi/180
      x_range <- 2*height*tan(xfov/2)
      y_range <- 2*height*tan(yfov/2)
      mat_aux <- kronecker(coords_utm, matrix(c(1, 1), nrow = 1))
      aux_ext <- c(c(0.5, -0.5)*x_range, c(0.5, -0.5)*y_range)
      extents <- sweep(mat_aux, MARGIN = 2, STATS = aux_ext)
      colnames(extents) <- c("xmin", "xmax", "ymin", "ymax")
   } else { extents = NULL; utmproj = NULL}
   # output
   out <- list(dim = c(n_cols, n_rows, n_bands),
      wavelength = wave_length, gain = gain,
      irradiance = irradiance, 
      coordinates = as.matrix(coords), 
      extents = extents, CRS = utmproj)
   return(out)
}

