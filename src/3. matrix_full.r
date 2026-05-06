### Script pour combiner les tableaux orchid et bumblebee

##1. Lire les fichiers csv des deux espèces
data_orchid <- read.csv("data/data_orchid.csv")
data_bumblebee <- read.csv("data/data_bumblebee.csv")

##2. Vérifier les noms des colonnes
# Colonnes
colnames(data_orchid)
colnames(data_bumblebee)

# Aperçu
str(data_orchid)
str(data_bumblebee)

##3. Combiner les deux espèces en un tableau
matrix_full <- bind_rows(data_orchid, data_bumblebee)

#Nettoyage final pour être sûre
matrix_full <- matrix_full %>%
  filter(!is.na(latitude), !is.na(longitude))

head(matrix_full)
summary(matrix_full)
table(matrix_full$species)
#Apparemment il y a différents noms pour Bombus terrestris
#Il faut corriger ça :
matrix_full <- matrix_full %>%
  mutate(
    species = case_when(
      species %in% c("Bombus", "Bombus terrestris", "Bombus terrestris terrestris") ~ "Bombus terrestris",
      TRUE ~ species
    )
  )

#On reteste:
table(matrix_full$species)
#C'est parfait maintenant

##4. Création d'un fichier csv
write.csv(matrix_full, "data/matrix_full.csv", row.names = FALSE)

##5. Visualisation des occurences combinées
Switzerland <- ne_countries(
  scale = "medium",
  returnclass = "sf",
  country = "Switzerland"
)

windows()

p_full <- ggplot(data = Switzerland) +
  geom_sf(fill = "grey95") +
  geom_point(
    data = matrix_full,
    aes(x = longitude, y = latitude, color = species),
    size = 2
  ) +
  theme_classic() +
  labs(title = "Occurrences des deux espèces en Suisse")

print(p_full)
