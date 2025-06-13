# Between-person model (average per item per subject)


# 2-factor CFA model (between)
cfa_model_between <- '
  PositiveAffect =~ Happy +
                    Relaxed +
                    Energetic +
                    Content

  NegativeAffect =~ Stressed +
                    Anxious +
                    Irritated +
                    Down

  # Residual correlations
  Relaxed ~~ Stressed
  Relaxed ~~ Down
  Stressed ~~ Down
'

# Remove missing sex (coded as 3, n = 5)
between_df_clean <- between_df %>%
  filter(Sex %in% c(1, 2)) %>%
  mutate(Sex = factor(Sex, levels = c(1, 2), labels = c("Male", "Female")))

# Fit the model
fit_between <- cfa(cfa_model_between, data = between_df_clean, missing = "fiml")

summary(fit_between, fit.measures = TRUE, standardized = TRUE)

# This will show if adding correlated residuals could improve fit.
mod <- modindices(fit_between, sort = TRUE, minimum.value = 10)

# Reuslt: add residual covariance between antonyms
# Hoe.ontspannen.voel.je.je.op.dit.moment ~~ Hoe.gestrest.voel.je.je.op.dit.moment

# Measurement invariance male/female
fit_configural <- cfa(cfa_model_between, data = between_df_clean, group = "Sex", missing = "fiml")

summary(fit_configural, fit.measures = TRUE, standardized = TRUE)

#metric invariance - equal loadings
fit_metric <- cfa(cfa_model_between,
                  data = between_df_clean,
                  group = "Sex",
                  group.equal = c("loadings"),
                  missing = "fiml")

summary(fit_metric, fit.measures = TRUE, standardized = TRUE)

anova(fit_configural, fit_metric)

#scalar invariance - equal intercepts

fit_scalar <- cfa(cfa_model_between,
                  data = between_df_clean,
                  group = "Sex",
                  group.equal = c("loadings", "intercepts"),
                  missing = "fiml")

anova(fit_metric, fit_scalar)


