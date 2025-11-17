
# ========================================================
# FINAL KAPLAN-MEIER SURVIVAL PLOTTING PIPELINE (FIGURE 2)
# ========================================================

library(tidyverse)
library(survival)
library(survminer)
library(ggplot2)
library(viridis)

# ----------------------------------------------------
# Load cleaned kinetics dataset
kinetics_df <- read_csv("Fig5_Kinetics_cleaned.csv")

# ----------------------------------------------------
# Prepare dataset for survival analysis

# We'll define lysis as CFU falling below a given threshold (example: 10% of initial CFU)
lysis_threshold_fraction <- 0.1

# First, extract initial CFU per Host-Treatment group
cfu_initial <- kinetics_df %>%
  filter(Metric == "CFU", Time_hr == 0) %>%
  group_by(Host, Treatment) %>%
  summarise(CFU_0 = mean(Value_clean), .groups = "drop")

# Merge initial CFU back into the main dataset
cfu_data <- kinetics_df %>%
  filter(Metric == "CFU") %>%
  left_join(cfu_initial, by = c("Host", "Treatment")) %>%
  mutate(Lysis_Event = if_else(Value_clean <= CFU_0 * lysis_threshold_fraction, 1, 0))

# Aggregate time-to-lysis data for survival analysis (for simplicity, here we use population level)
time_to_lysis <- cfu_data %>%
  group_by(Host, Treatment, Time_hr) %>%
  summarise(Event = max(Lysis_Event), .groups = "drop")

# For survival analysis, we simulate that all time points with no lysis yet are censored (Event = 0)
surv_data <- time_to_lysis

# ----------------------------------------------------
# Kaplan-Meier analysis and plotting

# Build survival curves per group
surv_data <- surv_data %>% mutate(Group = paste(Host, Treatment, sep = "_"))

fit <- survfit(Surv(Time_hr, Event) ~ Group, data = surv_data)

# Plot using harmonized journal style
km_plot <- ggsurvplot(
  fit, data = surv_data,
  risk.table = FALSE, censor = FALSE,
  palette = viridis::viridis(length(unique(surv_data$Group)), end = 0.85),
  ggtheme = theme_bw(base_size = 14),
  title = "Figure 2. Kaplan-Meier Lysis Timing",
  xlab = "Time (h)", ylab = "Survival Probability (CFU above threshold)"
)

print(km_plot)
# Export high-res PDF version
ggsave("Figure_2_KaplanMeier_FINAL.pdf", km_plot$plot, width = 7, height = 5)
