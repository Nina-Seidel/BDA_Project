### Script qui sert à lancer les scripts de src en une fois
##Install packages if necessary
#install.packages("rgbif")
#install.packages("rinat")
#install.packages("dplyr")
#install.packages("raster")
#install.packages("sf")
#install.packages("rnaturalearth")
#install.packages("ggplot2")
#install.packages("elevatr")
#install.packages("Rchelsa")
#install.packages("terra")

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

##Run code
source("./src/orchid.r")
source("./src/bumblebee.r")
source("./src/matrix_full.r")
source("./src/ecosystems.r")
source("./src/elevation.r")
