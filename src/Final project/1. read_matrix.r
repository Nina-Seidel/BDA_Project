### Script to load final dataset and define ecological question

##1. Load final dataset
matrix_full <- read.csv("data/matrix_full_satellite.csv")

head(matrix_full)
summary(matrix_full)
colnames(matrix_full)


##2. Check species distribution
table(matrix_full$species)


##3. Define ecological question

# Ecological question:
# Do the alpine orchid Dactylorhiza sambucina and a generalist bumblebee, 
#Bombus terrestris, occupy similar environmental niches?

# Objectives:
# - Compare the environmental distributions of both species
# - Identify the main environmental gradients structuring species occurrence
# - Evaluate which environmental variables differentiate best the two species


##4. Prepare dataset for analysis
# Select variables for environmental analysis
matrix_analysis <- matrix_full %>%
  select(species, elevation, tmax_mean_c, prec_mean_annual, NDVI)

# Remove missing values
matrix_analysis <- na.omit(matrix_analysis)

# Convert species to factor
matrix_analysis$species <- as.factor(matrix_analysis$species)

summary(matrix_analysis)
str(matrix_analysis)
