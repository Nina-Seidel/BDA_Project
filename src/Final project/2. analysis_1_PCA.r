### Script for PCA analysis

##1. Run PCA
pca <- prcomp(
  matrix_analysis[, -1],  # on enlève species
  scale. = TRUE
)

summary(pca)
str(pca)


##2. Plot PCA
fviz_pca_ind(
  pca,
  geom = "point",
  col.ind = matrix_analysis$species,
  palette = c("#1b9e77", "#d95f02"),
  addEllipses = TRUE,
  legend.title = "Species"
)

fviz_pca_var(pca)


##3. Interpretation

# The PCA shows a strong environmental gradient along the first axis (PC1),
# which explains more than 80% of the total variance.
# PC1 mainly represents an altitudinal and climatic gradient.  
# The two species show a partial separation along this axis, 
# suggesting differences in their environmental niches.
# However, the overlap between the two indicates that they also share 
# some of their environmental space. 
# Interestingly, Dactylorhiza sambucina appears more widely distributed
# across the PCA space, suggesting a larger range of environmental conditions
# compared to Bombus terrestris, which is more clustered.
