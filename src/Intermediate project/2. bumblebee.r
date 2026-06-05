### Script to download occurrences of Bombus terrestris and create a dataset

##1. Define species
myspecies <- "Bombus terrestris"


##2. Download GBIF data
gbif_raw <- occ_data(
  scientificName = myspecies,
  hasCoordinate = TRUE,
  limit = 1000
)


##3. Extract occurences
gbif_occ <- gbif_raw$data


##4. Filter for Switzerland
gbif_ch <- gbif_occ %>%
  dplyr::filter(country == "Switzerland")


##5. Create GBIF dataset
data_gbif <- data.frame(
  species   = gbif_ch$species,
  latitude  = gbif_ch$decimalLatitude,
  longitude = gbif_ch$decimalLongitude,
  source    = "gbif"
)

head(data_gbif)
summary(data_gbif)
#Only 2 points for GBIF, but iNaturalist data compensates


##6. Download iNaturalist data
inat_raw <- get_inat_obs(
  query = myspecies,
  place_id = "switzerland",
  maxresults = 1000
)


##7. Create iNaturalist dataset
data_inat <- data.frame(
  species   = inat_raw$scientific_name,
  latitude  = inat_raw$latitude,
  longitude = inat_raw$longitude,
  captive   = inat_raw$captive_cultivated,
  source    = "inat"
)

# Remove captive/cultivated observations
data_inat <- data_inat %>%
  dplyr::filter(captive == "false" | is.na(captive)) %>%
  dplyr::select(-captive) 

head(data_inat)
colnames(data_inat)
summary(data_inat)


##8. Combine GBIF and iNaturalist data
data_bumblebee <- dplyr::bind_rows(data_gbif, data_inat)


##9. Clean dataset (keep only lines with complete coordinates)
data_bumblebee <- data_bumblebee %>%
  dplyr::filter(!is.na(latitude), !is.na(longitude))

head(data_bumblebee)
summary(data_bumblebee)


##10. Save dataset
write.csv(
  data_bumblebee, 
  "data/data_bumblebee.csv", 
  row.names = FALSE
)


##11. Plot occurrences
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

windows()
p_bumblebee <- ggplot(data = Switzerland) +
  geom_sf(fill = "grey95") +
  geom_point(
    data = data_bumblebee,
    aes(x = longitude, y = latitude),
    color = "#D18F00",
    size = 2
  ) +
  theme_classic() +
  labs(title = "Occurrences de Bombus terrestris en Suisse")

print(p_bumblebee)


##12. Save figure
ggsave(
  "data/figures/bumblebee_occurrences.png",
  plot = p_bumblebee,
  width = 6,
  height = 5
)