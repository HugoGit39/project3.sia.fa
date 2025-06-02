

# Open file dialog to select CSV
file_path <- tclvalue(tkgetOpenFile(filetypes = "{{CSV Files} {.csv}} {{All files} *}"))

# Check if a file was selected
if (file_path != "") {
  final_df <- read.csv(file_path)
  print(head(data))  # Show the first few rows
} else {
  cat("No file selected.\n")
}

# change columns name from final_df$X.7_VAS..Hoe.geïrriteerd.voel.je.je.op.dit.moment. to final_df$X.7_VAS..Hoe.geirriteerd.voel.je.je.op.dit.moment
names(final_df)[names(final_df) == "X.7_VAS..Hoe.geïrriteerd.voel.je.je.op.dit.moment."] <- 
  "X.7_VAS..Hoe.geirriteerd.voel.je.je.op.dit.moment"

# create long format for analysis
long_df <- final_df %>%
  select(Name, day = Scheduled.Time, starts_with("X.")) %>%
  mutate(day = as.Date(day)) %>%
  pivot_longer(cols = starts_with("X."),
               names_to = "Item",
               values_to = "Value")




