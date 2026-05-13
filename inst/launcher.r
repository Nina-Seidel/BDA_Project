### Script qui sert à lancer les scripts de src en une fois
##Install packages if necessary
#install.packages(c(
#   "rgbif", "rinat", "dplyr", "Rchelsa",
#   "tidyverse", "sf", "rnaturalearth", "rnaturalearthdata",
#   "ggplot2", "ggrepel", "ggiraph", "plotly", "leaflet",
#   "MASS", "viridis", "elevatr", "raster", "terra", "rayshader"
#))

#install.packages('luna', repos='https://rspatial.r-universe.dev')

##Load packages
library(rgbif) #GBIF
library(rinat) #iNaturalist
library(dplyr) #Manipulation des données
library(raster) # to read and manipulate raster files
library(sf) # to handle vector spatial data
library(rnaturalearth) # to download country boundaries
library(ggplot2) # to create graphs
library(elevatr)   # download elevation data
library(Rchelsa)
library(terra)
library(tidyverse)
library(rnaturalearthdata)
library(ggrepel)
library(ggiraph)
library(plotly)
library(leaflet)
library(MASS)
library(viridis)
library(rayshader)
library(luna)
library(MODIStsp)
library(appeears)

##Run code
source("./src/1. orchid.r")
source("./src/2. bumblebee.r")
source("./src/3. matrix_full.r")
source("./src/4. ecosystems.r")
source("./src/5. elevation.r")
source("./src/6. climate.r")
source("./src/7. satellite.r")