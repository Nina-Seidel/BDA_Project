### Script to add ecosystem data to species occurrences

##1. Load the main dataset
matrix_full <- read.csv("data/matrix_full.csv")

head(matrix_full)
summary(matrix_full)


##2. Load ecosystem raster
# Define the path to the GeoTIFF file
file_path <- "./data/WorldEcosystem.tif"

# Read the raster layer
ecosystem_raster <- raster(file_path)

print(ecosystem_raster)

# Quick visualization
windows()
plot(ecosystem_raster, main = "Global ecosystem raster")


##3. Load Switzerland boundary
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

windows()
plot(st_geometry(Switzerland), main = "Switzerland boundary")


##4. Crop and mask raster
ecosystem_crop <- crop(ecosystem_raster, extent(Switzerland))
ecosystem_ch <- mask(ecosystem_crop, Switzerland)

windows()
plot(ecosystem_ch, main = "Ecosystems in Switzerland")


##5. Convert occurrence points to spatial object
spatial_points <- SpatialPoints(
  coords = matrix_full[, c("longitude", "latitude")],
  proj4string = CRS("+proj=longlat +datum=WGS84")
)

# Plot occurrences on raster
windows()
plot(ecosystem_ch, main = "Occurrences on ecosystem map")
plot(spatial_points, add = TRUE, pch = 16, cex = 1)


##6. Extract ecosystem values at each point
eco_values <- raster::extract(ecosystem_ch, spatial_points)

head(eco_values)


##7. Add ecosystem codes to dataset
matrix_full_eco <- matrix_full %>%
  mutate(eco_code = eco_values)

head(matrix_full_eco)


##8. Add ecosystem metadata (names)
metadata_eco <- read.delim("./data/WorldEcosystem.metadata.tsv")

matrix_full_eco <- merge(
  matrix_full_eco,
  metadata_eco,
  by.x = "eco_code",
  by.y = "Value"
)

head(matrix_full_eco)


##9. Visualization (validation step)
windows()

p_eco <- ggplot(matrix_full_eco, aes(x = Climate_Re, fill = species)) +
  geom_bar(position = "dodge") +
  theme_classic() +
  labs(
    title = "Number of observations per ecosystem type",
    x = "Ecosystem type",
    y = "Number of observations"
  )
# Climate_Re comes from ecosystem classification (categorical climate proxy),
# not from extracted climate variables (temperature/precipitation)

print(p_eco)


##10. Save enriched dataset
write.csv(matrix_full_eco, "data/matrix_full_eco.csv", row.names = FALSE)


##11. Save figure
ggsave(
  "data/figures/observations_by_ecosystem.png",
  plot = p_eco,
  width = 8,
  height = 5
)
