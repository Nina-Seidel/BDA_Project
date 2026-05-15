### Main script to run the full analysis pipeline

##1. Install packages if necessary
#install.packages(c(
#   "rgbif", "rinat", "dplyr", "Rchelsa",
#   "tidyverse", "sf", "rnaturalearth", "rnaturalearthdata",
#   "ggplot2", "ggrepel", "Rcpp", "ggiraph", "plotly", "leaflet",
#   "MASS", "viridis", "elevatr", "raster", "terra", "rayshader"
#))


##2. Load packages
library(rgbif)              # GBIF data
library(rinat)              # iNaturalist data
library(dplyr)              # Data manipulation
library(ggplot2)            # Visualisation
library(sf)                 # Vector spatial data handling
library(rnaturalearth)      # Country boundaries
library(rnaturalearthdata)  
library(raster)             # Raster data handling
library(terra)              # Raster data handling (terra is newer than raster)
library(elevatr)            # Elevation data
library(Rchelsa)            # CHELSA Climate data


##3. Save figures in a folder
#dir.create("data/figures", showWarnings = FALSE)

##Run code
source("./src/1. orchid.r")
source("./src/2. bumblebee.r")
source("./src/3. matrix_full.r")
source("./src/4. ecosystems.r")
source("./src/5. elevation.r")
source("./src/6. climate.r")
source("./src/7. satellite.r")
