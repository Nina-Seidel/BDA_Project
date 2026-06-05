### Script for Environmental comparison between species

##1. Reshape data for plotting
plot_data <- matrix_analysis %>%
  pivot_longer(
    cols = c(
      elevation,
      NDVI,
      prec_mean_annual,
      tmax_mean_c
    ),
    names_to = "Variable",
    values_to = "Value"
  )


##2. Create boxplots
windows()

p_box <- ggplot(
  plot_data,
  aes(
    x = species,
    y = Value,
    fill = species
  )
) +
  geom_boxplot() +
  scale_fill_manual(values = species_colors) +
  facet_wrap(
    ~Variable,
    scales = "free"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_blank(),
    plot.margin = ggplot2::margin(5, 5, 5, 5)
  ) +
  labs(
    title = "Environmental variables by species",
    x = "Species",
    y = "Value",
    fill = "Species"
  )

print(p_box)


##3. Interpretation
# Elevation: 
# Dactylorhiza sambucina is found at higher elevations than Bombus terrestris,
# with limited overlap between the two species.

# NDVI:
# NDVI values are largely overlapping between the two species, 
# suggesting similar vegetation conditions.

# Precipitation (prec_mean_annual):
# Precipitation shows overlap between the two species, 
# but Bombus terrestris tends to have a slightly higher median precipitation,
# which may reflect its occurrence in more humid lowland areas.

# Temperature (tmax_mean_c):
# Bombus terrestris is associated with higher temperatures, 
# consistent with its occurence at lower elevations.
# Dactylorhiza sambucina is found in cooler conditions, 
# reflecting its alpine habitat.

# Overall, Dactylorhiza sambucina shows a broader distribution 
# across environmental variables. 
# However, this pattern may partly reflect differences in sampling effort
# rather than true ecological range.


##4. Save figure
ggsave(
  "data/figures/environmental_comparison.png",
  plot = p_box,
  width = 10,
  height = 6
)
