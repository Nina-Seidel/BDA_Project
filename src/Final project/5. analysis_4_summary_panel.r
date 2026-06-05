### Script for Summary panel

##1. Combine plots
windows()

# Top row: PCA + environmental comparison
top_row <- plot_grid(
  p_pca,
  p_box,
  labels = c("A", "B"),
  ncol = 2,
  rel_widths = c(1, 1.2)
)

# Bottom row: random forest
bottom_row <- plot_grid(
  p_rf,
  labels = "C"
)

# Final panel
summary_panel <- plot_grid(
  top_row,
  bottom_row,
  ncol = 1,
  rel_heights = c(1.4, 0.7)
)

print(summary_panel)


##2. Save figure
ggsave(
  "data/figures/summary_panel.png",
  plot = summary_panel,
  width = 12,
  height = 9,
  dpi = 300
)
