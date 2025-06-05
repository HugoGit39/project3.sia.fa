
# 1. Compute weekly mean per subject per item
weekly_means <- long_df %>%
  group_by(Name, Item) %>%
  summarise(WeeklyMean = mean(Value, na.rm = TRUE), .groups = "drop")

# 2. Compute daily mean per subject per item
daily_means <- long_df %>%
  group_by(Name, day, Item) %>%
  summarise(DailyMean = mean(Value, na.rm = TRUE), .groups = "drop")

# 3. Join and subtract to get centered values
within_centered <- daily_means %>%
  left_join(weekly_means, by = c("Name", "Item")) %>%
  mutate(Centered = DailyMean - WeeklyMean)

# 4. Pivot to wide format (1 row per subject-day, 1 column per item)
within_df <- within_centered %>%
  select(Name, day, Item, Centered) %>%
  pivot_wider(names_from = Item, values_from = Centered)

# 5. Define 2-factor CFA model
cfa_model_within <- '
  PositiveAffect =~ Happy + Relaxed + Energetic + Content
  NegativeAffect =~ Stressed + Anxious + Irritated + Down
'

# 6. Fit CFA model with clustering on Name
fit_within <- cfa(
  model = cfa_model_within,
  data = within_df,
  cluster = "Name",
  missing = "fiml"
)

# 7. Summary
summary(fit_within, fit.measures = TRUE, standardized = TRUE)

mod_within <- modindices(fit_within, sort = TRUE, minimum.value = 10)
head(mod_within, 20)  # See top 20 suggested changes

cfa_model_within_adj <- '
  level: 1
    PositiveAffect =~ Happy + Relaxed + Energetic + Content
    NegativeAffect =~ Stressed + Anxious + Irritated + Down

    # Add residual correlations suggested by modindices
    Relaxed ~~ Stressed
    Relaxed ~~ Down
    Stressed ~~ Down

  level: 2
    PositiveAffect =~ Happy + Relaxed + Energetic + Content
    NegativeAffect =~ Stressed + Anxious + Irritated + Down
'

fit_within_adj <- sem(
  cfa_model_within_adj,
  data = within_df,
  cluster = "Name",
  missing = "fiml"
)

summary(fit_within_adj, fit.measures = TRUE, standardized = TRUE)

