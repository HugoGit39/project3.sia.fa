

efa_bay_model <- '
  efa("block1")*F1 + F2 =~ Happy + Relaxed + Energetic + Content + 
                          Stressed + Anxious + Irritated + Down
'

fit_bayes_efa <- bcfa(
  model = efa_bay_model,
  data = between_df,
  n.chains = 3,
  burnin = 2000,
  sample = 10000,
  std.lv = TRUE
)

summary(fit_bayes_efa, standardized = TRUE)

plot(fit_bayes_efa, type = "trace")

