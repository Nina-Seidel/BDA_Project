### Script for Random Forest analysis

##1. Run model
rf_model <- randomForest(
  species ~ elevation + tmax_mean_c + prec_mean_annual + NDVI,
  data = matrix_analysis,
  importance = TRUE
)

print(rf_model)


##2. Variable importance
importance(rf_model)


##3. Variable importance data
importance_df <- data.frame(
  Variable = rownames(importance(rf_model)),
  Importance = importance(rf_model)[, "MeanDecreaseAccuracy"]
)

windows()

p_rf <- ggplot(
  importance_df,
  aes(
    x = reorder(Variable, Importance),
    y = Importance
  )
) +
  geom_col(fill = "#4E6A7A") +
  coord_flip() +
  theme_classic() +
  theme(
    plot.margin = ggplot2::margin(5, 5, 5, 5)
  ) +
  labs(
    title = "Environmental variable importance",
    x = "",
    y = "Mean decrease in accuracy"
  )

print(p_rf)


##4. Interpretation
# The model works well to separate the two species.

# Elevation is the most important variable.

# Temperature and precipitation are also important.

# NDVI is less important.

# This means species differences are mainly explained
# by elevation and climate, not vegetation.

# The model has a low error rate (4.41%), so the results are reliable.


##5. Save figure
ggsave(
  "data/figures/random_forest_importance.png",
  plot = p_rf,
  width = 7,
  height = 4.5,
  dpi = 300
)
