# Wind Turbine Blade Material Selection Model

## Overview

This project uses an R-based multi-criteria decision model to compare aluminum alloy, fiberglass composite, and carbon composite for wind turbine blade structures under performance and cost constraints.

The goal of the project is to show how engineering material selection depends on tradeoffs between weight, stiffness, fatigue resistance, and cost instead of one single material property.

## Research Question

Which material is most suitable for wind turbine blade structures when performance and cost constraints are weighted differently?

## Materials Compared

- Aluminum Alloy
- Fiberglass Composite
- Carbon Composite

## Variables Used

The model compares each material using:

- Density
- Young's Modulus
- Strength
- Fatigue Score
- Cost Index
- Specific Stiffness
- Specific Strength

## Methodology

The project calculates specific stiffness and specific strength to compare material performance relative to weight. Each material property is normalized to a 0 to 1 scale so different variables can be compared in one scoring model.

The base weighted scoring model uses:

- 35% weight efficiency
- 30% stiffness efficiency
- 20% fatigue efficiency
- 15% cost efficiency

The model also tests three scenarios:

1. Performance-focused
2. Balanced
3. Cost-focused

## Key Findings

Carbon composite achieved the highest score in performance-focused and balanced scenarios because of its high stiffness-to-weight ratio and fatigue resistance.

Fiberglass composite became more competitive in the cost-focused scenario because it provides acceptable structural performance at a lower cost.

Aluminum alloy ranked lowest overall because its higher density and lower fatigue resistance make it less suitable for wind turbine blade applications.

## Tools Used

- R
- RMarkdown
- ggplot2
- dplyr
- tidyr

## Files

- `Research.Rmd`: Original RMarkdown analysis file
- `wind_turbine_material_selection.R`: R script version of the model
- `report/material_selection_report.pdf`: Full written report
- `figures/`: Output plots from the model

## Skills Demonstrated

- Engineering tradeoff analysis
- Multi-criteria decision modeling
- Data normalization
- Weighted scoring
- Scenario analysis
- Data visualization in R
- Technical writing
- Materials selection reasoning

## How to Run

Open `Research.Rmd` in RStudio and knit the file, or run the R script:

```bash
Rscript wind_turbine_material_selection.R
```

##Project Summary

This project demonstrates how data analysis can support engineering decisions. The final result shows that the "best" material depends on the design priority: carbon composite is strongest for performance, while fiberglass composite becomes more attractive when cost is weighted more heavily.


---

# .gitignore

Create a file called `.gitignore` and put this inside:

```gitignore
.Rhistory
.RData
.Rproj.user/
.DS_Store
*.html
