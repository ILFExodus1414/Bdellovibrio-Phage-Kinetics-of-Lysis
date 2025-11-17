<p align="center">
  <a href="https://doi.org/10.5281/zenodo.17626134">
    <img src="https://zenodo.org/badge/DOI/10.5281/zenodo.17626134.svg" alt="DOI">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License">
  </a>
  <img src="https://img.shields.io/badge/R-4.x.x-1f72ff" alt="R version">
  <img src="https://img.shields.io/badge/made%20with-tidyverse-1f77b4" alt="tidyverse">
</p>


<img width="1536" height="1024" alt="banner" src="https://github.com/user-attachments/assets/2ee48c76-73ff-4d5c-ad04-68e6971b1ea8" />


---

## 📘 Overview

This repository contains the complete R workflow and datasets used to reproduce all analyses and figures for the dual predation kinetics study involving a *Bdellovibrio*-like organism (EMS) and a lytic bacteriophage (M7f).  
The pipeline includes:

- Lysis kinetics (CFU, PFU, OD)  
- Latent period & burst size annotations  
- Percent-difference treatment effects  
- Effective MOI (PFU/CFU) trajectories  
- Kaplan–Meier survival analysis  
- Log-rank tests & median survival times  

All scripts are modular, fully reproducible, and match the figures included in the manuscript.

---

## 📂 Repository Structure
data/                         # Cleaned input datasets (CSV)
scripts/                      # R scripts for analysis and figure generation
figures/                      # High-resolution PNG/PDF outputs
README.md                     # Project documentation
LICENSE                       # MIT License
CITATION.cff                  # Citation metadata
.gitignore                    # Ignore rules for R and temporary files


## 📊 Statistical Workflow

### **1. Lysis Kinetics (Figure 1A)**
- Calculates mean, SD, and SEM for CFU, PFU, and OD.
- Plots log10 kinetics for each Host × Treatment.
- Annotates latent periods and burst size estimates.

### **2. Percent Difference vs Control (Figure 1B)**
- Uses `% Difference vs 1M` as effect size.
- Significance labels determined via p-value thresholds.

### **3. Burst Size Comparison (Figure 1C)**
- Recalculated PFU/CFU burst sizes.
- Focused on 2M and 3M treatments.

### **4. Effective MOI Dynamics (Figure 1D)**
- PFU/CFU over time on a log10 scale.
- Faceted per host.

### **5. Survival Analysis**
- Lysis defined as CFU < 50% of initial.
- Kaplan–Meier curves and log-rank tests performed.
- Median survival times exported.

---

## 🔧 Dependencies

This project uses the following R packages:
tidyverse
ggplot2
viridis
patchwork
survival
survminer
scales


```r
install.packages(c("tidyverse", "viridis", "survival", "survminer", "patchwork", "scales"))


---



📄 Citation

If you use this workflow, please cite:

Forteza, I. (2025). Dual Predation Kinetics: EMS–M7f analysis workflow.
GitHub & Zenodo. DOI: https://doi.org/10.5281/zenodo.17626134


dual-predation
Bdellovibrio
bacteriophage
microbial-ecology
lysis-kinetics
R
reproducible-research
survival-analysis

This release corresponds to the archived Zenodo record (DOI: 10.5281/zenodo.17626134).

