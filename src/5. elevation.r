### Script to add elevation data to species occurrences

# Disable s2 geometry engine
#can avoid issues during spatial operations
sf_use_s2(FALSE)

##1. Load the ecosystem dataset
matrix_full_eco <- read.csv("data/matrix_full_eco.csv")

head(matrix_full_eco)
summary(matrix_full_eco)

##2. Load Switzerland boundary (from Natural Earth)
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

##3. Download elevation raster
# z controls raster resolution
# higher z = more detail but slower
elevation_switzerland <- get_elev_raster(
  Switzerland,
  z = 8
)

# Quick raster visualization
windows()
plot(
  elevation_switzerland,
  main = "Elevation raster of Switzerland"
)

##4. Convert occurrence coordinates to spatial points
spatial_points <- SpatialPoints(
  coords = matrix_full_eco[, c("longitude", "latitude")],
  proj4string = CRS("+proj=longlat +datum=WGS84")
)

##5. Extract elevation values
elevation_values <- raster::extract(
  elevation_switzerland,
  spatial_points
)

head(elevation_values)

##6. Add elevation values to dataset
matrix_full_eco_elev <- matrix_full_eco %>%
  mutate(elevation = elevation_values)

# Remove missing elevation values
matrix_full_eco_elev <- matrix_full_eco_elev %>%
  filter(!is.na(elevation))

head(matrix_full_eco_elev)
summary(matrix_full_eco_elev)

##7. Visualization of elevation distributions

# Cleaning
# Remove groups with <2 points since density plots require distributions
plot_data <- matrix_full_eco_elev %>%
  filter(!is.na(Climate_Re)) %>%
  group_by(Climate_Re) %>%
  filter(n() > 1) %>%   # remove groups with <2 points
  ungroup()

# Visualisation
windows()

p_elev <- ggplot(
  plot_data,
  aes(x = elevation, fill = Climate_Re)
) +
  geom_density(alpha = 0.5, adjust = 3) +
  theme_classic() +
  labs(
    title = "Elevation distribution by ecosystem type",
    x = "Elevation (m)",
    y = "Density"
  )

print(p_elev)

##8. Save enriched dataset
write.csv(
  matrix_full_eco_elev,
  "data/matrix_full_eco_elev.csv",
  row.names = FALSE
)
