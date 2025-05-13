# Compute descriptive stats per subject, per item, per day
subject_day_item_descriptives <- long_df %>%
  group_by(Name, day, Item) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE),
    Variance = var(Value, na.rm = TRUE),
    N = sum(!is.na(Value)),
    .groups = "drop"
  )


