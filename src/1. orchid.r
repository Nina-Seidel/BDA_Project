### Script pour charger les données D. sambucina et en faire un tableau

##1. Définition de l'espèce
myspecies <- "Dactylorhiza sambucina"

##2. Télécharger les données GBIF
gbif_raw <- occ_data(
  scientificName = myspecies,
  hasCoordinate = TRUE,
  limit = 1000
)

##3. Extraire les données
gbif_occ <- gbif_raw$data

##4. Filtrer Suisse
gbif_ch <- gbif_occ %>%
  filter(country == "Switzerland")

##5. Tableau GBIF
data_gbif <- data.frame(
  species   = gbif_ch$species,
  latitude  = gbif_ch$decimalLatitude,
  longitude = gbif_ch$decimalLongitude,
  source    = "gbif"
)

head(data_gbif)
summary(data_gbif)

##6. Télécharger les données iNaturalist
inat_raw <- get_inat_obs(
  query = myspecies,
  place_id = "switzerland",
  maxresults = 1000
)

##7. Tableau iNat
data_inat <- data.frame(
  species   = inat_raw$scientific_name,
  latitude  = inat_raw$latitude,
  longitude = inat_raw$longitude,
  source    = "inat"
)

head(data_inat)
colnames(data_inat)
summary(data_inat)

##8. Stack les données GBIF et iNat
data_orchid <- bind_rows(data_gbif, data_inat)

##9. Nettoyage (on garde seulement les lignes avec latitude ET longitude,
#donc les coordonnées complètes)
data_orchid <- data_orchid %>%
  filter(!is.na(latitude), !is.na(longitude))

head(data_orchid)
summary(data_orchid)

##10. Création du fichier csv
write.csv(data_orchid, "data/data_orchid.csv", row.names = FALSE)

##11. Visualisation des occurrences
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

p_orchid <- ggplot(data = Switzerland) +
  geom_sf(fill = "grey95") +
  geom_point(
    data = data_orchid,
    aes(x = longitude, y = latitude),
    color = "darkgreen",
    size = 2
  ) +
  theme_classic() +
  labs(title = "Occurrences de Dactylorhiza sambucina en Suisse")

print(p_orchid)
