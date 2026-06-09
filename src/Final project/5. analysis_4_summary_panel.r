### Script for Summary panel

##1. Combine plots
windows()

summary_panel <- ggdraw() +

  # PCA biplot
  draw_plot(
    p_pca,
    x = 0.00,
    y = 0.38,
    width = 0.52,
    height = 0.62
  ) +

  # Violin plot
  draw_plot(
    p_violin,
    x = 0.48,
    y = 0.38,
    width = 0.52,
    height = 0.62
  ) +

  # Random forest
  draw_plot(
    p_rf,
    x = 0.12,
    y = 0.00,
    width = 0.76,
    height = 0.35
  ) +

  # Labels
  draw_label(
    "A",
    x = 0.02,
    y = 0.98,
    fontface = "bold",
    size = 14
  ) +

  draw_label(
    "B",
    x = 0.50,
    y = 0.98,
    fontface = "bold",
    size = 14
  ) +

  draw_label(
    "C",
    x = 0.12,
    y = 0.36,
    fontface = "bold",
    size = 14
  )

print(summary_panel)


##2. Interpretation
# All results show a clear difference between the species.

# Dactylorhiza sambucina prefers higher and colder areas.
# Bombus terrestris prefers lower and warmer areas.

# Both species still overlap in some environments.

# Elevation is the main factor explaining the difference.

# A limitation is that we have more data for Dactylorhiza sambucina
# which may influence the results.


##3. Save figure
ggsave(
  "data/figures/summary_panel.png",
  plot = summary_panel,
  width = 13,
  height = 9,
  dpi = 300
)
