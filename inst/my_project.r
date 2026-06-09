### Main script to run the full analysis pipeline

### Intermediate project
##0. Preparation
# Install packages if necessary
# install.packages(c(
#   "rgbif", "rinat", "dplyr", "ggplot2",
#   "sf", "rnaturalearth", "rnaturalearthdata",
#   "raster", "terra", "elevatr", "Rchelsa"
# ))

# Load packages
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

# Save figures in a folder
#dir.create("data/figures", showWarnings = FALSE)

# Custom color palette
species_colors <- c(
  "Bombus terrestris" = "#D18F00",
  "Dactylorhiza sambucina" = "#952365"
)

##1. Load orchid data
source("./src/Intermediate project/1. orchid.r")

##2. Load bumblebee data
source("./src/Intermediate project/2. bumblebee.r")

##3. Combine datasets and create matrix
source("./src/Intermediate project/3. matrix_full.r")

##4. Extract ecosystem data
source("./src/Intermediate project/4. ecosystems.r")

##5. Extract elevation data
source("./src/Intermediate project/5. elevation.r")

##6. Extract climate data
source("./src/Intermediate project/6. climate.r")

##7. Extract satellite data
source("./src/Intermediate project/7. satellite.r")



### Final project
##0. Preparation
# Install packages if necessary
# install.packages(c(
#   "tidyverse", "FactoMineR", "factoextra", "randomForest",
#   "terra", "sf", "rnaturalearth", "ggplot2", "cowplot",
#   "plotly", "elevatr", "raster", "rayshader"
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
library(elevatr)            # Elevation data
library(raster)             # Raster data handling
library(rayshader)          # 3D visualisation

# Custom color palette 
species_colors <- c(
  "Bombus terrestris" = "#D18F00",
  "Dactylorhiza sambucina" = "#952365"
)


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


##7. Additional comments
# I acknowledge the use of ChatGPT for assistance in code writing and troubleshooting, 
# as well as for improving the clarity of comments and interpretations. 
# However, all analyses, code structuring, figure design, and ecological interpretations
# were performed by myself, and I take full responsibility for the content of this project.

