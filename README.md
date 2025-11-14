

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


---

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

This project requires:

Install via:

```r
install.packages(c("tidyverse", "viridis", "survival", "survminer", "patchwork", "scales"))

Forteza, I. (2025). Dual Predation Kinetics: EMS–M7f analysis workflow.
GitHub & Zenodo. DOI: <insert DOI>
