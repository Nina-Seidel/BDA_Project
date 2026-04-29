### Script qui sert à lancer les scripts de src en une fois
##Install packages if necessary
#install.packages(c(
#   "rgbif", "rinat", "dplyr", "Rchelsa",
#   "tidyverse", "sf", "rnaturalearth", "rnaturalearthdata",
#   "ggplot2", "ggrepel", "ggiraph", "plotly", "leaflet",
#   "MASS", "viridis", "elevatr", "raster", "terra", "rayshader"
# ))

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

##Run code
source("./src/orchid.r")
source("./src/bumblebee.r")
source("./src/matrix_full.r")
source("./src/ecosystems.r")
source("./src/elevation.r")
source("./src/climate.r")
source("./src/satellite.r")