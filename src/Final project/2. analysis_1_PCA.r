### Script for PCA analysis

##1. Run PCA
pca <- prcomp(
  matrix_analysis[, -1],  # remove species column
  scale. = TRUE
)

summary(pca)
str(pca)


##2. Plot PCA biplot
windows()

p_pca <- fviz_pca_biplot(
  pca,
  geom.ind = "point",
  col.ind = matrix_analysis$species,
  palette = species_colors,
  addEllipses = TRUE,
  label = "var",
  col.var = "black",
  repel = TRUE,
  legend.title = "Species"
) +
  theme_classic() +
  labs(
    title = "PCA biplot: environmental gradients",
    color = "Species"
  )

print(p_pca)


##3. Interpretation
# The PCA shows a main environmental gradient.
# This gradient is mostly linked to elevation and temperature.

# The two species are a bit separated:
# - Dactylorhiza sambucina is found in colder and higher places
# - Bombus terrestris is found in warmer areas

# However, there is some overlap.
# This means the two species can live in similar environments.

# Dactylorhiza sambucina looks more spread,
# but this may be due to more data, not real ecology.


##4. Save figure
ggsave(
  "data/figures/pca_biplot.png",
  plot = p_pca,
  width = 7,
  height = 6,
  dpi = 300
)
