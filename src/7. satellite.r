### Script to add satellite (NDVI) data to the project

##1. Load dataset (with climate)
matrix_full_climate <- read.csv("data/matrix_full_climate.csv")

head(matrix_full_climate)
summary(matrix_full_climate)


##2. Create Switzerland polygon for AppEEARS
#switzerland_sf <- ne_countries(
#  scale = "medium",
#  country = "Switzerland",
#  returnclass = "sf"
#)

#dir.create("data", showWarnings = FALSE)

#st_write(
#  switzerland_sf,
#  "./data/switzerland.geojson",
#  delete_dsn = TRUE
#)

#plot(st_geometry(switzerland_sf), col = "lightgray", main = "Switzerland")


##3. Load and combine NDVI rasters
ndvi_path <- "./data/modis"

ndvi_files <- list.files(
  ndvi_path,
  pattern = "\\.(tif|tiff)$",
  full.names = TRUE
)

print(length(ndvi_files)) #check the number of files


##4. Stack rasters and compute mean NDVI
# Stack ALL rasters
ndvi_stack <- rast(ndvi_files)

# Compute mean NDVI across time
ndvi_raster <- mean(ndvi_stack, na.rm = TRUE)

# Check NDVI scale
minmax(ndvi_raster)

# If needed to fix scale (spoiler: yes it is):
ndvi_raster <- ndvi_raster / 10000

# Check NDVI scale
minmax(ndvi_raster)
#Ideally: between 0 and 1, 
#but here we are between 0.1 and 1.54
#Probably due to clouds, snow, or other factors affecting reflectance

# Quick visualization
windows()
plot(ndvi_raster, main = "Mean NDVI (2017–2019)")


##5. Load Switzerland boundary
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

switzerland_vect <- vect(Switzerland)

# Reproject to raster CRS
switzerland_vect <- project(switzerland_vect, crs(ndvi_raster))


##6. Clip NDVI raster to Switzerland
ndvi_switzerland <- crop(ndvi_raster, switzerland_vect)
ndvi_switzerland <- mask(ndvi_switzerland, switzerland_vect)

windows()
plot(ndvi_switzerland, main = "NDVI raster (Switzerland)")
plot(switzerland_vect, add = TRUE)


##7. Convert occurrences to spatial points
points_vect <- vect(
  matrix_full_climate,
  geom = c("longitude", "latitude"),
  crs = "EPSG:4326"
)

# Reproject points to raster CRS
points_vect <- project(points_vect, crs(ndvi_switzerland))

# Visual check
plot(ndvi_switzerland, main = "Sampling points over NDVI")
plot(points_vect, add = TRUE, col = "red", pch = 16)


##8. Extract NDVI values at occurrence locations
ndvi_values <- terra::extract(ndvi_switzerland, points_vect)

head(ndvi_values)


##9. Add NDVI to dataset
matrix_full_satellite <- matrix_full_climate %>%
  mutate(NDVI = ndvi_values[, 2])

summary(matrix_full_satellite)


##10. Save final dataset
write.csv(
  matrix_full_satellite,
  "data/matrix_full_satellite.csv",
  row.names = FALSE
)


##11. Visualization
# Clean data for plotting
plot_data <- matrix_full_satellite %>%
  filter(!is.na(NDVI), !is.na(Climate_Re))

windows()
p_ndvi <- ggplot(plot_data, aes(x = NDVI, fill = Climate_Re)) +
  geom_density(alpha = 0.5, adjust = 3) +
  theme_classic() +
  labs(
    title = "NDVI distribution by climate category",
    x = "NDVI",
    y = "Density"
  )

print(p_ndvi)


##12. Save figure
ggsave(
  "data/figures/ndvi_distribution.png",
  plot = p_ndvi,
  width = 8,
  height = 6,
  dpi = 300
)
