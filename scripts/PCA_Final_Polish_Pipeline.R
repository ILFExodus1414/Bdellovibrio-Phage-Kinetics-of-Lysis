
# ==========================================================
# FINAL PCA POLISHING SCRIPT — JOURNAL-READY
# ==========================================================

library(tidyverse)
library(ggplot2)
library(factoextra)
library(ggrepel)
library(scales)

# Load PCA input data
pca_data <- read_csv("PCA_Input_Table.csv")

# Select numeric variables for PCA
pca_vars <- pca_data %>% select(BurstSize, LysisEfficiency, SynergyIndex)
pca_result <- prcomp(pca_vars, scale. = TRUE)

# Variance explained
explained_var <- pca_result$sdev^2 / sum(pca_result$sdev^2) * 100

# PCA scores for plotting
pca_scores <- as.data.frame(pca_result$x)
pca_scores <- bind_cols(pca_data %>% select(Host, Treatment), pca_scores)

# Loadings for variable vectors
loadings <- as.data.frame(pca_result$rotation)
loadings$varname <- rownames(loadings)

# Harmonized color palette
color_map <- c("A.sobria" = "#1f77b4", "E.coli" = "#d62728")

# PCA biplot — polished version
p <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = Host, shape = Treatment)) +
  geom_point(size = 5, alpha = 0.9) +
  geom_text_repel(aes(label = Treatment), size = 4) +
  scale_color_manual(values = color_map) +
  scale_shape_manual(values = c("2M" = 21, "3M" = 24)) +
  labs(title = "PCA of Lysis Kinetics Parameters",
       x = paste0("PC1 (", round(explained_var[1], 1), "% variance)"),
       y = paste0("PC2 (", round(explained_var[2], 1), "% variance)")) +
  theme_bw(base_size = 16) +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(face = "bold", size = 18),
    axis.title = element_text(size = 16),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  )

# Add loadings (variable vectors)
p <- p +
  geom_segment(data = loadings, aes(x = 0, y = 0, xend = PC1*2, yend = PC2*2),
               arrow = arrow(length = unit(0.3, "cm")), color = "gray30",
               inherit.aes = FALSE) +
  geom_text_repel(data = loadings, aes(x = PC1*2.3, y = PC2*2.3, label = varname),
                  size = 5, color = "black", inherit.aes = FALSE)

# Export polished plot
ggsave("PCA_Lysis_Kinetics_FINAL_POLISHED.pdf", plot = p, width = 7, height = 6)
