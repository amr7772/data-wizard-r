# Become a Data Wizard with R
# Chapter 10: From question to report
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# A project and a question
# ----------------------------------------------------------------------

# Run once, in the console, from the project folder
dir.create("data")
readr::write_csv(dplyr::storms, "data/storms.csv")

library(dplyr)
library(readr)
library(ggplot2)

storms_raw <- read_csv("data/storms.csv")
glimpse(storms_raw)

storms_raw |> count(status, sort = TRUE)


# ----------------------------------------------------------------------
# Cleaning with the question in mind
# ----------------------------------------------------------------------

storms_raw |>
  filter(month == 1) |>
  count(name, year)

library(stringr)

first_try <- storms_raw |>
  filter(year >= 1979) |>
  filter_out(str_detect(str_to_upper(name), "^AL[0-9]")) |>
  group_by(name, year) |>
  summarize(peak_kt = max(wind), .groups = "drop")

first_try |> arrange(peak_kt)

# The text and the captions say 1979-2024; stop if the data differ
stopifnot(max(storms_raw$year) == 2024)

cyclone <- c("tropical depression", "tropical storm", "hurricane",
             "subtropical depression", "subtropical storm")

storm_list <- storms_raw |>
  filter(year >= 1979) |>
  # Zeta's January 2006 rows continue a storm that began in 2005
  filter_out(name == "Zeta", year == 2006) |>
  # Keep only the times when the system was a cyclone
  filter(status %in% cyclone) |>
  # Names come back every six years, so a storm is a name in a year
  group_by(name, year) |>
  summarize(
    month = min(month),
    peak_kt = max(wind),
    hurricane = any(status == "hurricane"),
    .groups = "drop"
  ) |>
  # Drop the depressions that never reached tropical-storm strength
  filter(peak_kt >= 34)

storm_list


# ----------------------------------------------------------------------
# From a clean table to a finding
# ----------------------------------------------------------------------

by_month <- storm_list |>
  group_by(month) |>
  summarize(
    storms = n(),
    hurricanes = sum(hurricane),
    pct = round(100 * hurricanes / storms),
    peak_kmh = round(median(peak_kt * 1.852))
  ) |>
  mutate(month = month.abb[month])
by_month

outcome_colors <- c("Below hurricane strength" = "grey75",
                    "Hurricane" = "#1F4FA8")

storm_list |>
  mutate(
    month = factor(month.abb[month], levels = month.abb),
    outcome = if_else(hurricane, "Hurricane",
                      "Below hurricane strength")
  ) |>
  ggplot(aes(x = month, fill = outcome)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE) +
  scale_fill_manual(values = outcome_colors) +
  labs(x = NULL, y = "Storms", fill = NULL,
       caption = "Data: NOAA HURDAT2, from the storms data in dplyr") +
  theme_minimal(base_size = 9) +
  theme(legend.position = "top",
        panel.grid.major.x = element_blank())

n_storms <- nrow(storm_list)
pct_aug_oct <- round(100 * mean(storm_list$month %in% 8:10))
pct_sep <- round(100 * mean(storm_list$month == 9))
pct_hurricane <- round(100 * mean(storm_list$hurricane))
c(n_storms, pct_aug_oct, pct_sep, pct_hurricane)
