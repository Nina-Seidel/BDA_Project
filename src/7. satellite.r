### Script to add satellite (NDVI) data to the project

##1. Load dataset (with climate)
matrix_full_climate <- read.csv("data/matrix_full_climate.csv")

head(matrix_full_climate)
summary(matrix_full_climate)

##2. Load NDVI raster (downloaded manually from AppEEARS)
ndvi_path <- "./data/modis"

ndvi_files <- list.files(
  ndvi_path,
  pattern = "\\.tif$",
  full.names = TRUE
)

ndvi_raster <- rast(ndvi_files[1])

# Quick visualization
windows()
plot(ndvi_raster, main = "NDVI raster")

##3. Load Switzerland boundary
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

switzerland_vect <- vect(Switzerland)

# Reproject to raster CRS
switzerland_vect <- project(switzerland_vect, crs(ndvi_raster))

##4. Clip raster to Switzerland
ndvi_switzerland <- crop(ndvi_raster, switzerland_vect)
ndvi_switzerland <- mask(ndvi_switzerland, switzerland_vect)

windows()
plot(ndvi_switzerland, main = "NDVI Switzerland")

##5. Convert occurrences to spatial points
points_vect <- vect(
  matrix_full_climate,
  geom = c("longitude", "latitude"),
  crs = "EPSG:4326"
)

# Reproject to raster CRS
points_vect <- project(points_vect, crs(ndvi_switzerland))

##6. Extract NDVI values
ndvi_values <- terra::extract(ndvi_switzerland, points_vect)

head(ndvi_values)

##7. Add NDVI to dataset
matrix_full_satellite <- matrix_full_climate %>%
  mutate(NDVI = ndvi_values[, 2])

head(matrix_full_satellite)
summary(matrix_full_satellite)

##8. Save final dataset
write.csv(
  matrix_full_satellite,
  "data/matrix_full_satellite.csv",
  row.names = FALSE
)

##9. Visualization

# Clean data for plotting
plot_data <- matrix_full_satellite %>%
  filter(!is.na(NDVI), !is.na(Climate_Re))

windows()

p_ndvi <- ggplot(plot_data, aes(x = NDVI, fill = Climate_Re)) +
  geom_density(alpha = 0.5, adjust = 3) +
  theme_classic() +
  labs(
    title = "NDVI distribution by climate",
    x = "NDVI",
    y = "Density"
  )

print(p_ndvi)