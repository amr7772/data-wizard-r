# Become a Data Wizard with R
# Chapter 6: Reshaping and joining tables
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# What a tidy table looks like
# ----------------------------------------------------------------------

library(dplyr)
library(tidyr)

relig_income


# ----------------------------------------------------------------------
# Making a wide table long
# ----------------------------------------------------------------------

relig_long <- relig_income |>
  pivot_longer(
    cols = -religion,
    names_to = "income",
    values_to = "count"
  )
relig_long

relig_long |>
  mutate(income = factor(income, levels = unique(income))) |>
  group_by(income) |>
  summarize(respondents = sum(count))

billboard |>
  select(artist, track, date.entered, wk1:wk4)

billboard |>
  pivot_longer(cols = starts_with("wk"), names_to = "week",
               values_to = "rank") |>
  nrow()

billboard_long <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    names_transform = as.integer,
    values_to = "rank",
    values_drop_na = TRUE
  )
billboard_long

billboard_long |>
  group_by(artist, track) |>
  summarize(weeks = n(), best = min(rank), .groups = "drop") |>
  arrange(desc(weeks))


# ----------------------------------------------------------------------
# Splitting a column that holds several values
# ----------------------------------------------------------------------

who2 |>
  select(country, year, sp_m_014, sp_m_1524, sp_f_014)

who_long <- who2 |>
  pivot_longer(
    cols = -c(country, year),
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  )
who_long

who_tidy <- who_long |>
  separate_wider_delim(
    key,
    delim = "_",
    names = c("diagnosis", "sex", "age")
  )
who_tidy


# ----------------------------------------------------------------------
# Making a long table wide
# ----------------------------------------------------------------------

who_tidy |>
  filter(country == "Egypt", year == 2010) |>
  select(country, year, sex, cases) |>
  pivot_wider(names_from = sex, values_from = cases)

who_tidy |>
  filter(country %in% c("Egypt", "Morocco"), year %in% 2009:2012) |>
  group_by(country, year, sex) |>
  summarize(cases = sum(cases), .groups = "drop") |>
  pivot_wider(names_from = sex, values_from = cases) |>
  mutate(men_per_woman = round(m / f, 2))


# ----------------------------------------------------------------------
# Keys, the columns that link tables
# ----------------------------------------------------------------------

library(nycflights13)

flights |>
  select(month, day, carrier, flight, tailnum, origin, dest)

planes |>
  count(tailnum) |>
  filter(n > 1)

weather |>
  count(origin, year, month, day, hour) |>
  filter(n > 1)


# ----------------------------------------------------------------------
# Joining two tables
# ----------------------------------------------------------------------

flights_named <- flights |>
  left_join(airlines, join_by(carrier))

nrow(flights)
nrow(flights_named)

flights_named |>
  select(carrier, flight, origin, dest, name)

dest_counts <- flights |>
  count(dest)

dest_counts |>
  left_join(airports, join_by(dest == faa)) |>
  select(dest, n, name, alt)

dest_counts |> left_join(airports, join_by(dest == faa)) |> nrow()
dest_counts |> inner_join(airports, join_by(dest == faa)) |> nrow()
dest_counts |> full_join(airports, join_by(dest == faa)) |> nrow()


# ----------------------------------------------------------------------
# Checking every join
# ----------------------------------------------------------------------

flights |>
  anti_join(airports, join_by(dest == faa)) |>
  count(dest)

airports |>
  semi_join(flights, join_by(faa == dest)) |>
  nrow()

flights |>
  anti_join(planes, join_by(tailnum)) |>
  count(carrier, sort = TRUE)

flights |>
  left_join(weather, join_by(time_hour)) |>
  nrow()

flights_weather <- flights |>
  left_join(
    weather |> select(origin, time_hour, temp, wind_speed),
    join_by(origin, time_hour),
    relationship = "many-to-one"
  )
nrow(flights_weather)

flights |>
  left_join(planes) |>
  summarize(rows = n(), with_type = sum(!is.na(type)))
