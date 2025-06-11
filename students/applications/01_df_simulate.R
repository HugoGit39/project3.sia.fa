set.seed(123)

# Parameters
n_subjects <- 100
n_days <- 7
n_prompts <- 8
n_items <- 8
start_date <- as.POSIXct("2022-08-24 08:00:00", tz = "Europe/Amsterdam")

# Subject metadata
subjects <- data.frame(
  Name = paste0("subject_", sprintf("%03d", 1:n_subjects)),
  Device.ID = sample(100000:999999, n_subjects)
)

# All combinations
df <- expand.grid(
  Name = subjects$Name,
  day = 0:(n_days - 1),
  prompt = 0:(n_prompts - 1)
) %>%
  left_join(subjects, by = "Name") %>%
  arrange(Name, day, prompt)

# Add timestamps
df <- df %>%
  mutate(
    Scheduled.Time = start_date + days(day) + hours(2 * prompt),
    Issued.Time = Scheduled.Time + seconds(sample(0:60, n(), replace = TRUE)),
    Response.Time = as.POSIXct(
      ifelse(runif(n()) < 0.1, NA, as.character(Issued.Time + seconds(sample(60:900, n(), replace = TRUE)))),
      tz = "Europe/Amsterdam"
    ),
    Duration..seconds..from.scheduled.to.completion.time = as.numeric(difftime(Response.Time, Scheduled.Time, units = "secs")),
    Duration..seconds..from.first.response.to.completion.time = sample(10:60, n(), replace = TRUE)
  )

# Simulate day-level missingness: randomly remove all prompts for 1-2 days for ~20% of subjects
subjects_missing_days <- sample(subjects$Name, size = round(0.2 * n_subjects))
missing_days_df <- expand.grid(Name = subjects_missing_days, day = sample(0:6, 2, replace = FALSE))

df <- df %>%
  mutate(miss_day = paste(Name, day) %in% paste(missing_days_df$Name, missing_days_df$day))

# Simulate prompt-level missingness: ~15% of prompts removed entirely
df <- df %>%
  group_by(Name, day, prompt) %>%
  mutate(miss_prompt = runif(1) < 0.15) %>%
  ungroup()

# Add VAS item responses
for (i in 1:n_items) {
  col_name <- sprintf("X.%d_VAS..%s.", i, c(
    "Hoe.gelukkig.voel.je.je.op.dit.moment",
    "Hoe.ontspannen.voel.je.je.op.dit.moment",
    "Hoe.energiek.voel.je.je.op.dit.moment",
    "Hoe.tevreden.voel.je.je.op.dit.moment",
    "Hoe.gestrest.voel.je.je.op.dit.moment",
    "Hoe.angstig.voel.je.je.op.dit.moment",
    "Hoe.geirriteerd.voel.je.je.op.dit.moment",
    "Hoe.neerslachtig.voel.je.je.op.dit.moment"
  )[i])

  df[[col_name]] <- ifelse(
    df$miss_day | df$miss_prompt | is.na(df$Response.Time) | runif(nrow(df)) < 0.05,
    NA,
    sample(0:10, nrow(df), replace = TRUE)
  )
}

# Final dataset
final_df <- df %>%
  select(
    Name,
    Device.ID,
    Scheduled.Time,
    Issued.Time,
    Response.Time,
    Duration..seconds..from.scheduled.to.completion.time,
    Duration..seconds..from.first.response.to.completion.time,
    starts_with("X.")
  )

# Set proper timezone display
for (col in c("Scheduled.Time", "Issued.Time", "Response.Time")) {
  attr(final_df[[col]], "tzone") <- "Europe/Amsterdam"
}

# Optional: Rename columns for readability
names(final_df)[(ncol(final_df)-7):ncol(final_df)] <- c(
  "Happy", "Relaxed", "Energetic", "Content",
  "Stressed", "Anxious", "Irritated", "Down"
)

#create long format
long_df <- final_df %>%
  select(Name, day = Scheduled.Time, Happy, Relaxed, Energetic, Content,
         Stressed, Anxious, Irritated, Down) %>%
  mutate(day = as.Date(day)) %>%
  pivot_longer(cols = c(Happy, Relaxed, Energetic, Content,
                        Stressed, Anxious, Irritated, Down),
               names_to = "Item",
               values_to = "Value")

