### Script pour extraire les data d'elevation en Suisse + visualisation

# Disable s2 geometry engine (can avoid issues in some spatial operations)
sf_use_s2(FALSE)

##1. Load Switzerland boundaries
# Retrieve country borders from Natural Earth
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

##2. Download elevation data
# z controls resolution (higher = more detail but slower)
elevation_switzerland <- get_elev_raster(Switzerland, z = 8)

# Quick visualization of the elevation raster
plot(elevation_switzerland)

##3. Prepare sampling points
# Convert coordinates into a spatial object (SpatialPoints format)
spatial_points <- SpatialPoints(
  coords = matrix_full_eco[, c("longitude", "latitude")],
  proj4string = CRS("+proj=longlat +datum=WGS84")
)

##4. Extract elevation values
# Extract raster values at each point location
elevation <- raster::extract(elevation_switzerland, spatial_points)

##5. Add elevation to the dataset
matrix_full_eco_elev <- data.frame(
  matrix_full_eco,
  elevation = elevation
)

##6. Visualization: elevation distribution
# Compare elevation distributions across climate categories

p3 <- ggplot(matrix_full_eco_elev, aes(x = elevation, fill = Climate_Re)) +
  geom_density(alpha = 0.5, adjust = 3) +  # smoothed density curves
  labs(
    title = "Elevation Distribution by Climate",
    x = "Elevation (m)",
    y = "Density"
  ) +
  theme_minimal()

# Display the plot
print(p3)
