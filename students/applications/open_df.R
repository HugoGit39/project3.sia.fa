

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected
if (file_path != "") {
  final_df <- read.csv(file_path)
  print(head(final_df))  # Corrected
} else {
  cat("No file selected.\n")
}

col_rename_map <- c(
  "X.1_VAS..Hoe.gelukkig.voel.je.je.op.dit.moment."     = "Happy",
  "X.2_VAS..Hoe.ontspannen.voel.je.je.op.dit.moment."   = "Relaxed",
  "X.3_VAS..Hoe.energiek.voel.je.je.op.dit.moment."     = "Energetic",
  "X.4_VAS..Hoe.tevreden.voel.je.je.op.dit.moment."     = "Content",
  "X.5_VAS..Hoe.gestrest.voel.je.je.op.dit.moment."     = "Stressed",
  "X.6_VAS..Hoe.angstig.voel.je.je.op.dit.moment."      = "Anxious",
  "X.7_VAS..Hoe.geïrriteerd.voel.je.je.op.dit.moment."  = "Irritated",
  "X.8_VAS..Hoe.neerslachtig.voel.je.je.op.dit.moment." = "Down"
)

names(final_df)[names(final_df) %in% names(col_rename_map)] <- col_rename_map[names(final_df)[names(final_df) %in% names(col_rename_map)]]


# Convert to long format
long_df <- final_df %>%
  select(Name, day = Scheduled.Time, all_of(unname(col_rename_map))) %>%
  mutate(day = as.Date(day)) %>%
  pivot_longer(cols = all_of(unname(col_rename_map)),
               names_to = "Item",
               values_to = "Value")
