
# ==========================================================
# JOURNAL SUBMISSION MASTER SCRIPT: FIGURES 1A–1D
# ==========================================================
# Load libraries
library(tidyverse)
library(ggplot2)
library(viridis)
library(patchwork)
library(scales)

# ----------------------------------------------------------
# Load full dataset for kinetics
df <- read_csv("Fig5_Kinetics_cleaned.csv")

# ----------------------------------------------------------
# 1A: Kinetics with manual annotation

# Summarize replicate means
df_summary <- df %>%
  filter(Metric %in% c("CFU", "PFU", "OD")) %>%
  group_by(Time_hr, Host, Type, Metric) %>%
  summarise(
    mean_value = mean(Value_clean),
    sd_value = sd(Value_clean),
    n_value = n(),
    .groups = "drop"
  ) %>%
  mutate(sem_value = sd_value / sqrt(n_value))

# Define latent time and burst size by Host
host_info <- tibble(
  Host = c("A.sobria", "E.coli", "BALO", "Phage"),
  latent_time = c(3, 4, 5, 2),
  burst_size = c(0.5, 0.4, 0.3, 0.2)
)

# Expand to all combinations of Host × Type and join info
manual_annot <- expand.grid(
  Type = c("1M", "2M", "3M"),
  Host = c("A.sobria", "E.coli", "BALO", "Phage"),
  stringsAsFactors = FALSE
) %>%
  as_tibble() %>%
  left_join(host_info, by = "Host") %>%
  mutate(
    # Dynamic Y-position for burst size label
    y_burst_label = case_when(
      Host == "Phage" ~ 5e6,
      Host == "BALO" ~ 7e6,
      TRUE ~ 1e7
    ),
    # Optional: Assign annotation color
    annot_color = case_when(
      Host == "A.sobria" ~ "#1b9e77",
      Host == "E.coli"   ~ "#d95f02",
      Host == "BALO"     ~ "#7570b3",
      Host == "Phage"    ~ "#e7298a"
    )
  )

# Build the plot
g1 <- ggplot(df_summary, aes(x = Time_hr, y = mean_value, color = Metric, fill = Metric)) +
  geom_ribbon(aes(ymin = mean_value - sem_value, ymax = mean_value + sem_value),
              alpha = 0.2, color = NA) +
  geom_line(size = 1.2) +
  scale_y_log10(labels = trans_format("log10", math_format(10^.x))) +
  facet_grid(Type ~ Host) +
  scale_color_viridis_d(option = "D", end = 0.85) +
  scale_fill_viridis_d(option = "D", end = 0.85) +
  labs(
    title = "Synchronous Single-Cycle Lysis Kinetics",
    subtitle = "Latent period and burst size estimates",
    x = "Time (h)", y = expression("Abundance ("*log[10]*" CFU / PFU / OD)"),
    color = "Metric", fill = "Metric"
  ) +
  theme_bw(base_size = 16) +
  theme(
    strip.text = element_text(face = "italic", size = 14),
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 16),
    legend.position = "top"
  ) +
  coord_cartesian(clip = "off") +
  geom_vline(data = manual_annot, aes(xintercept = latent_time),
             linetype = "dotted", color = "black") +
  geom_text(data = manual_annot, aes(x = latent_time, y = 1.2,
                                     label = paste0("Latent\n", latent_time, " h")),
            inherit.aes = FALSE, hjust = 0.5, vjust = -0.5, size = 4) +
  geom_text(data = manual_annot, aes(x = latent_time, y = y_burst_label,
                                     label = paste0("Burst size: ", round(burst_size, 1))),
            inherit.aes = FALSE, hjust = 0.5, vjust = 0, size = 4,
            color = manual_annot$annot_color)  # optional colored label

print(g1)

# Define filename and size
output_file <- "Fig1_Kinetics_Annotated.png"  # Change to .tiff or .pdf if needed
output_file <- "Fig1_Kinetics_Annotated.pdf"

# Save the plot (300 DPI for publication)
ggsave(
  filename = output_file,
  plot = g1,
  width = 12,         # in inches
  height = 8,         # adjust to fit your layout
  dpi = 300,          # high-resolution
  units = "in",       # inches, cm, or mm
  bg = "white"        # ensures white background (esp. for PNG)
)


# ----------------------------------------------------------
library(tidyverse)
library(ggplot2)
library(viridis)

# ----------------------------------------------------------
# Load and prepare significance table
final_table <- read_csv("Treatment_Comparison_Stats_0_5hr.csv") %>%
  mutate(sig_label = case_when(
    p_value < 0.001 ~ "***",
    p_value < 0.01  ~ "**",
    p_value < 0.05  ~ "*",
    p_value < 0.1   ~ ".",
    TRUE ~ ""
  ))

# Filter out Control and NA comparisons
plot_data <- final_table %>%
  filter(!str_detect(Treatment, "^1M"), !is.na(Percent_Diff_vs_1M))

# ----------------------------------------------------------
# Create plot
g2 <- ggplot(plot_data, aes(x = Treatment, y = Percent_Diff_vs_1M, fill = Host)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9), color = "black") +
  geom_text(aes(label = sig_label),
            position = position_dodge(width = 0.9),
            vjust = -0.5, size = 4) +
  facet_wrap(~ Metric, scales = "free_y") +
  scale_fill_viridis_d(option = "D", end = 0.85) +
  labs(
    title = "B. Percent Difference vs Control",
    y = "% Difference from Control (vs 1M)",
    x = "Treatment",
    fill = "Host"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    strip.text = element_text(face = "italic"),
    legend.position = "top"
  )

# ----------------------------------------------------------
# Save PNG (high-resolution, 300 DPI)
ggsave(
  filename = "Fig5B_PercentDiff_vs_Control.png",
  plot = g2,
  width = 10,
  height = 6,
  dpi = 300,
  units = "in",
  bg = "white"
)

# ----------------------------------------------------------
# Save PDF (vector format for journals)
ggsave(
  filename = "Fig5B_PercentDiff_vs_Control.pdf",
  plot = g2,
  width = 10,
  height = 6,
  units = "in",
  bg = "white"
)

# ----------------------------------------------------------
# 1C: Burst Size Comparison

burst_size_table <- read_csv("Recalculated_Burst_Size.csv")

burst_size_clean <- burst_size_table %>%
  filter(!is.na(Burst_Size), Treatment %in% c("2M", "3M"))

g3 <- ggplot(burst_size_clean, aes(x = Treatment, y = Burst_Size, fill = Host)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "black") +
  scale_fill_viridis_d(option = "D", end = 0.85) +
  labs(title = "Burst Size Comparison",
       y = "Burst Size (PFU increase per CFU)", x = "Treatment", fill = "Host") +
  theme_minimal(base_size = 14)
print(g3)

# ----------------------------------------------------------
# 1D: Effective MOI

df_moi <- read_csv("Effective_MOI_TimeSeries.csv") %>%
  filter(!is.na(Effective_MOI), Effective_MOI > 0)

g4 <- ggplot(df_moi, aes(x = Time_hr, y = Effective_MOI, color = Treatment)) +
  geom_line(size = 1.2) +
  facet_wrap(~ Host, scales = "free_y") +
  scale_y_log10(limits = c(0.1, NA)) +
  scale_color_viridis_d(option = "D", end = 0.85) +
  labs(title = "Effective MOI Dynamics",
       y = "Effective MOI (log10 PFU/CFU)", x = "Time (hr)", color = "Treatment") +
  theme_minimal(base_size = 14)

print(g4)
# ----------------------------------------------------------
# FINAL assembly

library(patchwork)

final_figure <- (g3 / g4) #+ plot_layout(nrow = 1)

ggsave("MOIBURST_FINAL.pdf", final_figure, width = 12, height = 24)

#Figure 1. Synchronous single-cycle lysis kinetics and treatment effects across hosts and predator combinations.
#(A) Bacterial lysis kinetics showing CFU, PFU, and OD across Host × Treatment combinations. Latent periods (dotted lines) and burst size estimates (annotated) were calculated from replicate means with 95% CI shown (log₁₀ scale).
#(B) Percent difference vs control for CFU at 5 h. Significance levels from ANOVA indicated.
#(C) Burst size comparison (PFU increase per CFU) across treatments from recalculated data.
#(D) Effective MOI dynamics (log₁₀ PFU/CFU) over time..


