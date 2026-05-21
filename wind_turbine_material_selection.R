```{r}
# ==========================================================
# Wind Turbine Blade Material Selection Model
# Comparing Aluminum, Fiberglass Composite, Carbon Composite
# ==========================================================

# Clear workspace
rm(list = ls())

# Load packages
library(ggplot2)
library(dplyr)
library(tidyr)

# ----------------------------------------------------------
# 1. Create base dataset
# ----------------------------------------------------------
materials <- data.frame(
  Material = c("Aluminum Alloy", "Fiberglass Composite", "Carbon Composite"),
  Density_kg_m3 = c(2700, 1900, 1600),
  Modulus_GPa = c(69, 40, 100),
  Strength_MPa = c(300, 600, 1000),
  Fatigue_Score = c(4, 7, 9),   # representative screening score
  Cost_Score = c(6, 8, 3)       # higher = cheaper in this setup? No. We will fix below.
)

# IMPORTANT:
# For Cost_Score in this setup, LOWER means cheaper? That gets confusing.
# Let's redefine clearly:
# Cost_Index: higher means MORE expensive
materials$Cost_Index <- c(5, 3, 9)

# ----------------------------------------------------------
# 2. Compute specific properties
# ----------------------------------------------------------
# Convert modulus from GPa to MPa so units are consistent if desired
materials$Modulus_MPa <- materials$Modulus_GPa * 1000

materials$Specific_Stiffness <- materials$Modulus_MPa / materials$Density_kg_m3
materials$Specific_Strength <- materials$Strength_MPa / materials$Density_kg_m3

# ----------------------------------------------------------
# 3. Helper functions for normalization
# ----------------------------------------------------------
normalize_high_good <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

normalize_low_good <- function(x) {
  (max(x) - x) / (max(x) - min(x))
}

# ----------------------------------------------------------
# 4. Normalize categories
# ----------------------------------------------------------
# Weight efficiency: lower density is better
materials$Weight_Efficiency <- normalize_low_good(materials$Density_kg_m3)

# Stiffness efficiency: higher specific stiffness is better
materials$Stiffness_Efficiency <- normalize_high_good(materials$Specific_Stiffness)

# Fatigue: higher fatigue score is better
materials$Fatigue_Efficiency <- normalize_high_good(materials$Fatigue_Score)

# Cost: lower cost index is better
materials$Cost_Efficiency <- normalize_low_good(materials$Cost_Index)

# ----------------------------------------------------------
# 5. Base weighting scenario
# ----------------------------------------------------------
w_weight <- 0.35
w_stiffness <- 0.30
w_fatigue <- 0.20
w_cost <- 0.15

materials$Total_Score <- w_weight * materials$Weight_Efficiency +
  w_stiffness * materials$Stiffness_Efficiency +
  w_fatigue * materials$Fatigue_Efficiency +
  w_cost * materials$Cost_Efficiency

# Sort results
results_base <- materials %>%
  select(Material, Density_kg_m3, Modulus_GPa, Strength_MPa,
         Specific_Stiffness, Specific_Strength,
         Weight_Efficiency, Stiffness_Efficiency,
         Fatigue_Efficiency, Cost_Efficiency, Total_Score) %>%
  arrange(desc(Total_Score))

print("=== Base Scenario Results ===")
print(results_base)

# ----------------------------------------------------------
# 6. Plot specific stiffness and specific strength
# ----------------------------------------------------------
plot_data_props <- materials %>%
  select(Material, Specific_Stiffness, Specific_Strength) %>%
  pivot_longer(cols = c(Specific_Stiffness, Specific_Strength),
               names_to = "Metric",
               values_to = "Value")

ggplot(plot_data_props, aes(x = Material, y = Value)) +
  geom_col() +
  facet_wrap(~ Metric, scales = "free_y") +
  labs(
    title = "Material Performance Metrics",
    x = "Material",
    y = "Value"
  ) +
  theme_minimal(base_size = 13)

# ----------------------------------------------------------
# 7. Plot base weighted score
# ----------------------------------------------------------
ggplot(materials, aes(x = reorder(Material, Total_Score), y = Total_Score)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Overall Material Score: Base Scenario",
    x = "Material",
    y = "Total Score"
  ) +
  theme_minimal(base_size = 13)

# ----------------------------------------------------------
# 8. Sensitivity analysis with different weighting scenarios
# ----------------------------------------------------------
scenarios <- data.frame(
  Scenario = c("Performance_Focused", "Balanced", "Cost_Focused"),
  Weight_WeightEff = c(0.35, 0.35, 0.25),
  Weight_Stiffness = c(0.35, 0.30, 0.20),
  Weight_Fatigue = c(0.20, 0.20, 0.15),
  Weight_Cost = c(0.10, 0.15, 0.40)
)

sensitivity_results <- data.frame()

for (i in 1:nrow(scenarios)) {
  temp <- materials
  
  temp$Scenario <- scenarios$Scenario[i]
  
  temp$Scenario_Score <-
    scenarios$Weight_WeightEff[i] * temp$Weight_Efficiency +
    scenarios$Weight_Stiffness[i] * temp$Stiffness_Efficiency +
    scenarios$Weight_Fatigue[i] * temp$Fatigue_Efficiency +
    scenarios$Weight_Cost[i] * temp$Cost_Efficiency
  
  sensitivity_results <- rbind(
    sensitivity_results,
    temp[, c("Material", "Scenario", "Scenario_Score")]
  )
}

print("=== Sensitivity Results ===")
print(sensitivity_results)

# ----------------------------------------------------------
# 9. Plot sensitivity results
# ----------------------------------------------------------
ggplot(sensitivity_results, aes(x = Scenario, y = Scenario_Score, fill = Material)) +
  geom_col(position = "dodge") +
  labs(
    title = "Sensitivity of Material Ranking to Design Priorities",
    x = "Scenario",
    y = "Score"
  ) +
  theme_minimal(base_size = 13)

# ----------------------------------------------------------
# 10. Optional: tradeoff chart
# ----------------------------------------------------------
ggplot(materials, aes(x = Cost_Index, y = Specific_Stiffness, label = Material)) +
  geom_point(size = 3) +
  geom_text(vjust = -0.7) +
  labs(
    title = "Tradeoff Between Cost and Specific Stiffness",
    x = "Cost Index (higher = more expensive)",
    y = "Specific Stiffness"
  ) +
  theme_minimal(base_size = 13)
```

