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


##2. Create violin plots
windows()

p_violin <- ggplot(
  plot_data,
  aes(
    x = species,
    y = Value,
    fill = species
  )
) +
  geom_violin(
    alpha = 0.7,
    trim = FALSE
  ) +
  geom_boxplot(
    width = 0.12,
    fill = "white",
    outlier.size = 0.8
  ) +
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
    title = "Environmental distributions by species",
    x = "Species",
    y = "Value",
    fill = "Species"
  )

print(p_violin)


##3. Interpretation
# The violin plots show how each species uses the environment.

# Elevation is the biggest difference:
# - Dactylorhiza sambucina lives higher
# - Bombus terrestris lives lower

# NDVI is very similar, so both species live in similar vegetation.

# Precipitation is also quite similar for both species.

# Temperature shows some difference, linked to elevation:
# - Dactylorhiza lives higher, so in colder environments
# - Bombus terrestris lives lower, so in warmer environments

# Dactylorhiza sambucina seems more variable,
# but this may be due to more observations.


##4. Save figure
ggsave(
  "data/figures/environmental_comparison.png",
  plot = p_violin,
  width = 11,
  height = 6.5,
  dpi = 300
)
