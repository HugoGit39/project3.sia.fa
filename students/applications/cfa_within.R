# Within-person model (multilevel CFA: subject = cluster, nested by day)

# Create long version with item names
within_df <- final_df %>%
  select(Name, day = Scheduled.Time, starts_with("X.")) %>%
  mutate(day = as.Date(day)) %>%
  group_by(Name, day) %>%
  summarise(across(starts_with("X."), ~ mean(.x, na.rm = TRUE)), .groups = "drop")

# Clean names
colnames(within_df) <- gsub("X\\.\\d+_VAS\\.\\.", "", colnames(within_df))
colnames(within_df) <- gsub("\\.$", "", colnames(within_df))

# 2-factor CFA model for within-level (multilevel structure)
cfa_model_within <- '
  level: 1
    PositiveAffect =~ Hoe.gelukkig.voel.je.je.op.dit.moment +
                       Hoe.ontspannen.voel.je.je.op.dit.moment +
                       Hoe.energiek.voel.je.je.op.dit.moment +
                       Hoe.tevreden.voel.je.je.op.dit.moment

    NegativeAffect =~ Hoe.gestrest.voel.je.je.op.dit.moment +
                       Hoe.angstig.voel.je.je.op.dit.moment +
                       Hoe.geirriteerd.voel.je.je.op.dit.moment +
                       Hoe.neerslachtig.voel.je.je.op.dit.moment

  level: 2
    PositiveAffect =~ Hoe.gelukkig.voel.je.je.op.dit.moment +
                       Hoe.ontspannen.voel.je.je.op.dit.moment +
                       Hoe.energiek.voel.je.je.op.dit.moment +
                       Hoe.tevreden.voel.je.je.op.dit.moment

    NegativeAffect =~ Hoe.gestrest.voel.je.je.op.dit.moment +
                       Hoe.angstig.voel.je.je.op.dit.moment +
                       Hoe.geirriteerd.voel.je.je.op.dit.moment +
                       Hoe.neerslachtig.voel.je.je.op.dit.moment
'

# Fit the multilevel CFA
fit_within <- sem(cfa_model_within, data = within_df, cluster = "Name", missing = "fiml", fixed.x = FALSE)

# Summary
summary(fit_within, fit.measures = TRUE, standardized = TRUE)
