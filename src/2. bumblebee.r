### Script pour charger les données B. terrestris et en faire un tableau

##1. Définition de l'espèce
myspecies <- "Bombus terrestris"

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
#Que 2 points pour GBIF, mais les données iNat compensent

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
summary(data_inat)

##8. Stack les données GBIF et iNat
data_bumblebee <- bind_rows(data_gbif, data_inat)

##9. Nettoyage (on garde seulement les lignes avec latitude ET longitude,
#donc les coordonnées complètes)
data_bumblebee <- data_bumblebee %>%
  filter(!is.na(latitude), !is.na(longitude))

head(data_bumblebee)
summary(data_bumblebee)

##10. Création du fichier csv
write.csv(data_bumblebee, "data/data_bumblebee.csv", row.names = FALSE)

##11. Visualisation des occurrences
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

p_bumblebee <- ggplot(data = Switzerland) +
  geom_sf(fill = "grey95") +
  geom_point(
    data = data_bumblebee,
    aes(x = longitude, y = latitude),
    color = "darkorange",
    size = 2
  ) +
  theme_classic() +
  labs(title = "Occurrences de Bombus terrestris en Suisse")

print(p_bumblebee)