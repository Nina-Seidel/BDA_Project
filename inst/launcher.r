### Main script to run the full analysis pipeline


### Intermediate project
##0. Install packages if necessary
# install.packages(c(
#   "rgbif", "rinat", "dplyr", "ggplot2",
#   "sf", "rnaturalearth", "rnaturalearthdata",
#   "raster", "terra", "elevatr", "Rchelsa"
# ))


##1. Load packages
library(rgbif)              # GBIF data
library(rinat)              # iNaturalist data
library(dplyr)              # Data manipulation
library(ggplot2)            # Visualisation
library(sf)                 # Vector spatial data handling
library(rnaturalearth)      # Country boundaries
library(rnaturalearthdata)  # Country boundaries data
library(raster)             # Raster data handling
library(terra)              # Raster data handling (terra is newer than raster)
library(elevatr)            # Elevation data
library(Rchelsa)            # CHELSA Climate data


##2. Save figures in a folder
#dir.create("data/figures", showWarnings = FALSE)


##3. Run code
source("./src/Intermediate project/1. orchid.r")
source("./src/Intermediate project/2. bumblebee.r")
source("./src/Intermediate project/3. matrix_full.r")
source("./src/Intermediate project/4. ecosystems.r")
source("./src/Intermediate project/5. elevation.r")
source("./src/Intermediate project/6. climate.r")
source("./src/Intermediate project/7. satellite.r")



### Final project
##0. Preparation
# Install packages if necessary
# install.packages(c(
#   "tidyverse", "FactoMineR", "factoextra", "randomForest",
#   "terra", "sf", "rnaturalearth", "ggplot2", "cowplot",
#   "plotly"
# ))

# Load packages
library(tidyverse)          # Data manipulation and visualisation
library(FactoMineR)         # PCA and multivariate analysis
library(factoextra)         # PCA visualisation
library(randomForest)       # Random forest analysis
library(terra)              # Raster data handling
library(sf)                 # Vector spatial data handling
library(rnaturalearth)      # Country boundaries
library(ggplot2)            # Visualisation
library(cowplot)            # Combining plots
library(plotly)             # Interactive plots


##1. Load the final environmental matrix
source("./src/Final project/1. read_matrix.r")

##2. PCA or ordination analysis
source("./src/Final project/2. analysis_1_PCA.r")

##3. Environmental comparison between species or groups
source("./src/Final project/3. analysis_2_environmental_comparison.r")

##4. Random forest / discriminating variable analysis
source("./src/Final project/4. analysis_3_random_forest.r")

##5. Final summary panel figure
source("./src/Final project/5. analysis_4_summary_panel.r")

##6. Optional interactive, animated or other advanced figure
source("./src/Final project/6. analysis_5_advanced_plot.r")