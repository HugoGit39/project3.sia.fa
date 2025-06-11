Multilevel Exploratory Factor Analysis (EFA) – NTR Experience Sampling Data
This repository provides a reproducible workflow in R to perform both between-person and within-person (person-by-day) Exploratory Factor Analysis (EFA) using data from the Netherlands Twin Register (NTR) Experience Sampling Method (ESM) project.

🔍 Goal
The primary goal of this project is to investigate the latent structure of affective experience using EFA at multiple levels of analysis:

Between-person analysis
Identifies stable individual differences by aggregating repeated affect measurements across time. Each participant is represented by their average responses, capturing how they differ from others.

Within-person analysis (person-by-day)
Explores daily fluctuations in affect within individuals. This helps determine whether the same factor structure that exists between individuals also holds across days within the same person.

Together, these analyses assess the stability and generalizability of emotion structures across time and individuals, using multilevel EFA methods.

📊 Methods Overview
Data Preparation

Load and clean raw ESM data

Rename items and reshape to long format for multilevel aggregation

Suitability for EFA

Compute Kaiser-Meyer-Olkin (KMO) measure of sampling adequacy

Perform Bartlett’s test of sphericity

Factor Extraction

Extract factors from person-averaged (between) and person-day (within) data

Determine the number of factors using eigenvalues, scree plots, and parallel analysis

Rotation

Use orthogonal (Varimax) or oblique (Oblimin) rotation to improve interpretability of factor loadings

Interpretation

Analyze pattern matrices and communalities

Compare structures across levels

Model Comparison (optional)

Fit confirmatory factor analysis (CFA) models based on the EFA results

Assess model fit using standardized estimates, RMSEA, TLI, etc.

📁 Source Data
The synthetic data structure in the project is inspired by the Netherlands Twin Register (NTR) ESM project:

https://tweelingenregister.vu.nl/

Real-world data must be requested from NTR for actual analyses.

📦 Dependencies
The following R packages are used:

tidyverse

lubridate

psych

lavaan

corrr

ggcorrplot

readxl

tcltk

Ensure all packages are installed before running the R Markdown file.

✍️ Author
This project was developed as part of a research effort to better understand the structure of affect across and within individuals using ecological momentary data from the NTR.
