# Extract only the 8 items from your data
items_df <- between_df %>%
  select(starts_with("Hoe."))  # or list the specific item names directly

colnames(items_df) <- c("Happy", "Relaxed", "Energetic", "Content",
                        "Stressed", "Anxious", "Irritated", "Down")

# Compute correlation matrix
cor_matrix <- cor(items_df, use = "pairwise.complete.obs")

ggcorrplot(cor_matrix, 
           method = "circle",       # circle or square
           type = "lower",          # show only lower triangle
           lab = TRUE,              # add correlation coefficients
           lab_size = 3, 
           colors = c("red", "white", "blue"), 
           title = "Correlation Matrix of Affect Items", 
           ggtheme = theme_minimal())

#network
items_cor <- items_df %>%
  correlate(use = "pairwise.complete.obs")

network_plot(items_cor, min_cor = 0.2, colours = c("red", "gray80", "blue"))
