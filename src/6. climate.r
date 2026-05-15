### Script to add climate data to the project

##1. Load dataset (ecosystem + elevation)
matrix_full_eco_elev <- read.csv("data/matrix_full_eco_elev.csv")

head(matrix_full_eco_elev)
summary(matrix_full_eco_elev)


##2. Create unique coordinate table
# To avoid duplicated coordinates
coords_unique <- matrix_full_eco_elev %>%
  dplyr::select(longitude, latitude) %>%
  distinct()

head(coords_unique)


##3. Extract temperature (Tmax)
tmax_r <- getChelsa(
  var       = "tasmax",
  coords    = coords_unique,
  startdate = as.Date("2018-01-01"),
  enddate   = as.Date("2019-01-01"),
  dataset   = "chelsa-monthly"
)

# Convert to matrix and compute annual mean
tmax_mat <- tmax_r %>%
  dplyr::select(-time) %>%
  as.matrix()

tmax_mean_c <- colMeans(tmax_mat, na.rm = TRUE) - 273.15

# Create temperature dataframe (linked to coordinates)
tmax_df <- coords_unique %>%
  mutate(tmax_mean_c = as.numeric(tmax_mean_c))

head(tmax_df)


##4. Extract precipitation
prec_r <- getChelsa(
  var       = "pr",
  coords    = coords_unique,
  startdate = as.Date("2018-01-01"),
  enddate   = as.Date("2019-01-01"),
  dataset   = "chelsa-monthly"
)

# Convert to matrix and compute annual mean
prec_mat <- prec_r %>%
  dplyr::select(-time) %>%
  as.matrix()

prec_mean <- colMeans(prec_mat, na.rm = TRUE)

# Create precipitation dataframe
prec_df <- coords_unique %>%
  mutate(prec_mean_annual = as.numeric(prec_mean))

head(prec_df)


##5. Merge climate variables with dataset (join by coordinates)
matrix_full_climate <- matrix_full_eco_elev %>%
  left_join(tmax_df, by = c("longitude", "latitude")) %>%
  left_join(prec_df, by = c("longitude", "latitude"))

head(matrix_full_climate)
summary(matrix_full_climate)


##6. Save dataset
write.csv(
  matrix_full_climate,
  "data/matrix_full_climate.csv",
  row.names = FALSE
)


##7. Visualization
# Clean data for plotting
plot_data <- matrix_full_climate %>%
  filter(!is.na(tmax_mean_c), !is.na(prec_mean_annual))

windows()

# Temperature
p_temp <- ggplot(plot_data, aes(x = tmax_mean_c, fill = species)) +
  geom_density(alpha = 0.5) +
  theme_classic() +
  labs(
    title = "Temperature distribution by species",
    x = "Annual mean temperature (°C)",
    y = "Density"
  )

print(p_temp)

# Precipitation
p_prec <- ggplot(plot_data, aes(x = prec_mean_annual, fill = species)) +
  geom_density(alpha = 0.5) +
  theme_classic() +
  labs(
    title = "Precipitation distribution by species",
    x = "Annual precipitation",
    y = "Density"
  )

print(p_prec)


##8. Save figures
ggsave(
  "data/figures/temperature_distribution.png", 
  p_temp, 
  width = 8, 
  height = 6
)

ggsave(
  "data/figures/precipitation_distribution.png", 
  p_prec, 
  width = 8, 
  height = 6
)
