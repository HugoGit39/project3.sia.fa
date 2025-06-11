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

# Fit the model
fit_between <- cfa(cfa_model_between, data = between_df, missing = "fiml")

# Summary
summary(fit_between, fit.measures = TRUE, standardized = TRUE)

# This will show if adding correlated residuals could improve fit.
mod <- modindices(fit_between, sort = TRUE, minimum.value = 10)

# Reuslt: add residual covariance between antonyms
# Hoe.ontspannen.voel.je.je.op.dit.moment ~~ Hoe.gestrest.voel.je.je.op.dit.moment

