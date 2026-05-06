### Script pour ajouter les données climatiques au projet

##1. Charger le dataset existant (avec écosystème + altitude)
data_climate <- matrix_full_eco_elev

##2. Ajouter un ID unique pour chaque occurrence
data_climate <- data_climate %>%
  mutate(occurrence_id = 1:n())

##3. Créer un tableau avec les coordonnées
coords_df <- data_climate %>%
  select(longitude, latitude, occurrence_id)

head(coords_df)

##4. Extraire la température (Tmax)
tmax_r <- getChelsa(
  var       = "tasmax",
  coords    = coords_df %>% select(longitude, latitude),
  startdate = as.Date("2018-01-01"),
  enddate   = as.Date("2019-01-01"),
  dataset   = "chelsa-monthly"
)

# Transformer en matrice et calculer la moyenne annuelle
tmax_mat <- tmax_r %>%
  select(-time) %>%
  as.matrix()

tmax_mean_c <- colMeans(tmax_mat, na.rm = TRUE) - 273.15

# Créer un tableau température
tmax_df <- data.frame(
  occurrence_id = coords_df$occurrence_id,
  tmax_mean_c = as.numeric(tmax_mean_c)
)

head(tmax_df)

##5. Extraire les précipitations
prec_r <- getChelsa(
  var       = "pr",
  coords    = coords_df %>% select(longitude, latitude),
  startdate = as.Date("2018-01-01"),
  enddate   = as.Date("2019-01-01"),
  dataset   = "chelsa-monthly"
)

# Transformer en matrice et calculer la moyenne annuelle
prec_mat <- prec_r %>%
  select(-time) %>%
  as.matrix()

prec_mean <- colMeans(prec_mat, na.rm = TRUE)

# Créer un tableau précipitations
prec_df <- data.frame(
  occurrence_id = coords_df$occurrence_id,
  prec_mean_annual = as.numeric(prec_mean)
)

head(prec_df)

##7. Ajouter les variables climatiques au dataset
matrix_full_final <- data_climate %>%
  left_join(tmax_df, by = "occurrence_id") %>%
  left_join(prec_df, by = "occurrence_id")

head(matrix_full_final)
summary(matrix_full_final)

##8. Sauvegarder le dataset final
write.csv(matrix_full_final, "data/matrix_full_final.csv", row.names = FALSE)

##9. Visualisation simple
# Température
p_temp <- ggplot(matrix_full_final, aes(x = tmax_mean_c, fill = species)) +
  geom_density(alpha = 0.5) +
  theme_classic() +
  labs(
    title = "Distribution de la température par espèce",
    x = "Température moyenne annuelle (°C)",
    y = "Densité"
  )

print(p_temp)

# Précipitations
p_prec <- ggplot(matrix_full_final, aes(x = prec_mean_annual, fill = species)) +
  geom_density(alpha = 0.5) +
  theme_classic() +
  labs(
    title = "Distribution des précipitations par espèce",
    x = "Précipitations annuelles",
    y = "Densité"
  )

print(p_prec)
