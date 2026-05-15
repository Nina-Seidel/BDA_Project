### Script to combine orchid and bumblebee datasets

##1. Load datasets
data_orchid <- read.csv("data/data_orchid.csv")
data_bumblebee <- read.csv("data/data_bumblebee.csv")


##2. Check structure
# Columns should be the same for both datasets to be able to combine them
colnames(data_orchid)
colnames(data_bumblebee)

# Overview
str(data_orchid)
str(data_bumblebee)


##3. Combine the two species into a single dataset
matrix_full <- bind_rows(data_orchid, data_bumblebee)


##4. Final cleaning to be sure
matrix_full <- matrix_full %>%
  filter(!is.na(latitude), !is.na(longitude))

head(matrix_full)
summary(matrix_full)
table(matrix_full$species)
#Apparently there are different names for Bombus terrestris
#We need to correct this:
matrix_full <- matrix_full %>%
  mutate(
    species = case_when(
      species %in% c("Bombus", "Bombus terrestris", "Bombus terrestris terrestris") ~ "Bombus terrestris",
      TRUE ~ species
    )
  )

#Check again:
table(matrix_full$species)
#Perfect now


##5. Save the combined dataset
write.csv(matrix_full, "data/matrix_full.csv", row.names = FALSE)


##6. Plot combined occurences
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


##7. Save figure
ggsave(
  "data/figures/full_occurrences.png",
  plot = p_full,
  width = 6,
  height = 5
)
