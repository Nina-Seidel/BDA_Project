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
  aes(x = reorder(Variable, Importance), y = Importance)
) +
  geom_col(fill = "#4E6A7A") +
  coord_flip() +
  theme_classic() +
  theme(
    plot.margin = ggplot2::margin(5, 5, 5, 5)
  ) +
  labs(
    title = "Variable importance",
    x = "",
    y = "Importance"
  )

print(p_rf)


##4. Interpretation
# The random forest model shows that elevation is the most important
# variable explaining species distribution, followed by precipitation,
# temperature and NDVI.
# This confirms the strong role of the altitudinal gradient observed 
# in the previous analyses.

# Although precipitation differences were less visible in the boxplots,
# the model suggests that it still contributes to distinguishing the two species.

# NDVI appears to be the least important variable, which is consistent
# with the strong overlap observed between species in the boxplots.

# Overall, the random forest results are consistent with the patterns
# observed in the PCA and environmental comparisons.


##5. Save figure
ggsave(
  "data/figures/random_forest_importance.png",
  plot = p_rf,
  width = 6,
  height = 4
)
