###########
#
# between_df 
#
###########

# Compute correlation matrix
cor_matrix <- cor(between_test, use = "pairwise.complete.obs")

ggcorrplot(cor_matrix, 
           method = "circle",       # circle or square
           type = "lower",          # show only lower triangle
           lab = TRUE,              # add correlation coefficients
           lab_size = 3, 
           colors = c("red", "white", "blue"), 
           title = "Between Correlation Matrix of Affect Items", 
           ggtheme = theme_minimal())

#network
items_cor <- between_test %>%
  correlate(use = "pairwise.complete.obs")

network_plot(items_cor, min_cor = 0.2, colours = c("red", "gray80", "blue"))

###########
#
# within_df 
#
###########

# Compute correlation matrix
cor_matrix <- cor(within_test, use = "pairwise.complete.obs")

ggcorrplot(cor_matrix, 
           method = "circle",       # circle or square
           type = "lower",          # show only lower triangle
           lab = TRUE,              # add correlation coefficients
           lab_size = 3, 
           colors = c("red", "white", "blue"), 
           title = "Within Correlation Matrix of Affect Items", 
           ggtheme = theme_minimal())

#network
items_cor <- within_test %>%
  correlate(use = "pairwise.complete.obs")

network_plot(items_cor, min_cor = 0.2, colours = c("red", "gray80", "blue"))
