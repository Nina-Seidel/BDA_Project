### Script for advanced plots

##1. 2D environmental niche
##1a. Visualisation
windows()

p_niche <- ggplot(
  matrix_analysis,
  aes(
    x = tmax_mean_c,
    y = prec_mean_annual,
    color = species
  )
) +
  geom_point(alpha = 0.4) +
  geom_density_2d(size = 1) +
  scale_color_manual(values = species_colors) +
  theme_classic() +
  labs(
    title = "Environmental niche (temperature vs precipitation)",
    x = "Mean temperature (°C)",
    y = "Annual precipitation",
    color = "Species"
  )

print(p_niche)


##1b. Interpretation
# This plot shows the niche of each species with temperature and precipitation.

# Temperature clearly separates the species:
# - Dactylorhiza sambucina = colder
# - Bombus terrestris = warmer
# Even though there is still some overlap between species.

# Precipitation differences are less clear.

# The orchid shows a wider range of conditions.


##1c. Save figure
ggsave(
  filename = "./data/figures/environmental_niche.png",
  plot = p_niche,
  width = 12,
  height = 8
)


##2. Elevation-temperature relationship
##2a. Visualisation
windows()

# Switzerland polygon
switzerland <- ne_countries(
  country = "Switzerland",
  returnclass = "sf"
)

# occurrence points
occ_sf <- st_as_sf(
  matrix_full,
  coords = c("longitude","latitude"),
  crs = 4326
)

# DEM
elevation_switzerland <- get_elev_raster(
  locations = switzerland,
  z = 7,
  clip = "locations"
)

elmat <- raster_to_matrix(elevation_switzerland)

elmat %>%
  sphere_shade(texture = "desert") %>%
  add_shadow(ray_shade(elmat),0.5) %>%
  add_shadow(ambient_shade(elmat),0.3) %>%
  plot_3d(
    elmat,
    zscale = 120,
    theta = 135,
    phi = 45,
    zoom = 0.75
  )

render_points(
  extent = raster::extent(elevation_switzerland),
  lat = matrix_full$latitude,
  long = matrix_full$longitude,
  altitude = matrix_full$elevation + 100,
  zscale = 120,
  size = 4,
  color = species_colors[
    as.character(matrix_full$species)
  ]
)


##2b. Interpretation
# This map shows species distribution with elevation.

# Dactylorhiza sambucina is mostly in mountains.
# Bombus terrestris is mostly in lower areas.

# This confirms that elevation is very important.

# Some overlap exists, but preferences are different.


##2c. Save figure
# Save a snapshot of the 3D map
rayshader::render_snapshot(
  filename = "./data/figures/3D_species_distribution.png",
  clear = FALSE
)

