### Script to download occurrences of Dactylorhiza sambucina and create a dataset

##1. Define species
myspecies <- "Dactylorhiza sambucina"


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
# Use dplyr:: to avoid conflicts with other packages


##5. Create GBIF dataset
data_gbif <- data.frame(
  species   = gbif_ch$species,
  latitude  = gbif_ch$decimalLatitude,
  longitude = gbif_ch$decimalLongitude,
  source    = "gbif"
)

head(data_gbif)
summary(data_gbif)


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


##8. Merge GBIF and iNaturalist data
data_orchid <- dplyr::bind_rows(data_gbif, data_inat)


##9. Clean dataset (keep only lines with complete coordinates)
data_orchid <- data_orchid %>%
  dplyr::filter(!is.na(latitude), !is.na(longitude))

head(data_orchid)
summary(data_orchid)


##10. Save dataset
write.csv(
  data_orchid, 
  "data/data_orchid.csv", 
  row.names = FALSE
)


##11. Plot occurrences
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

windows()
p_orchid <- ggplot(data = Switzerland) +
  geom_sf(fill = "grey95") +
  geom_point(
    data = data_orchid,
    aes(x = longitude, y = latitude),
    color = "darkgreen",
    size = 2
  ) +
  theme_classic() +
  labs(title = "Occurrences of Dactylorhiza sambucina in Switzerland")

print(p_orchid)


##12. Save figure
ggsave(
  "data/figures/orchid_occurrences.png",
  plot = p_orchid,
  width = 6,
  height = 5
)