# Between-person model (average per item per subject)

# Get average per subject per item
between_df <- final_df %>%
  group_by(Name) %>%
  summarise(across(starts_with("X."), ~ mean(.x, na.rm = TRUE)))

# Rename items for lavaan clarity
colnames(between_df) <- gsub("X\\.\\d+_VAS\\.\\.", "", colnames(between_df))
colnames(between_df) <- gsub("\\.$", "", colnames(between_df))

# 2-factor CFA model (between)
cfa_model_between <- '
  PositiveAffect =~ Hoe.gelukkig.voel.je.je.op.dit.moment +
                     Hoe.ontspannen.voel.je.je.op.dit.moment +
                     Hoe.energiek.voel.je.je.op.dit.moment +
                     Hoe.tevreden.voel.je.je.op.dit.moment

  NegativeAffect =~ Hoe.gestrest.voel.je.je.op.dit.moment +
                     Hoe.angstig.voel.je.je.op.dit.moment +
                     Hoe.geirriteerd.voel.je.je.op.dit.moment +
                     Hoe.neerslachtig.voel.je.je.op.dit.moment
'

# Fit the model
fit_between <- cfa(cfa_model_between, data = between_df, missing = "fiml")

# Summary
summary(fit_between, fit.measures = TRUE, standardized = TRUE)
