# Become a Data Wizard with R
# Chapter 4: Asking questions of a table
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# Five verbs and a pipe
# ----------------------------------------------------------------------

library(dplyr)
library(gapminder)

gapminder


# ----------------------------------------------------------------------
# Keeping the rows you need
# ----------------------------------------------------------------------

gapminder |>
  filter(country == "Egypt")

gapminder |>
  filter(year == 2007, lifeExp > 75) |>
  count(continent)

north_africa <- c("Algeria", "Egypt", "Libya", "Morocco", "Tunisia")

gapminder |>
  filter(country %in% north_africa, year == 2007)

library(palmerpenguins)

penguins |> filter(sex != "female") |> nrow()
penguins |> filter_out(sex == "female") |> nrow()


# ----------------------------------------------------------------------
# Choosing columns and putting rows in order
# ----------------------------------------------------------------------

gapminder |>
  filter(country == "Egypt") |>
  select(year, lifeExp, gdpPercap)

gapminder |>
  filter(year == 2007) |>
  arrange(lifeExp)

gapminder |>
  filter(year == 2007) |>
  arrange(desc(gdpPercap)) |>
  slice_head(n = 5)


# ----------------------------------------------------------------------
# Computing new columns
# ----------------------------------------------------------------------

gapminder |>
  filter(country == "Egypt") |>
  mutate(gdp_billions = gdpPercap * pop / 1e9) |>
  select(year, pop, gdpPercap, gdp_billions)

gapminder |>
  filter(year == 2007) |>
  mutate(income = if_else(gdpPercap > 10000,
                          "above 10,000", "10,000 or less")) |>
  count(income)

gapminder |>
  filter(year == 2007) |>
  mutate(life_band = case_when(
    lifeExp < 50 ~ "under 50",
    lifeExp < 70 ~ "50 to 69",
    .default = "70 or more"
  )) |>
  count(life_band)


# ----------------------------------------------------------------------
# Reading code as a sentence: the pipe
# ----------------------------------------------------------------------

# Shown in the book but not run there. Remove the '# ' to run it.
# slice_head(arrange(filter(gapminder, year == 2007), desc(gdpPercap)),
#            n = 5)

# Shown in the book but not run there. Remove the '# ' to run it.
# rows_2007 <- filter(gapminder, year == 2007)
# sorted_2007 <- arrange(rows_2007, desc(gdpPercap))
# top_five <- slice_head(sorted_2007, n = 5)

# Shown in the book but not run there. Remove the '# ' to run it.
# top_five <- gapminder |>
#   filter(year == 2007) |>
#   arrange(desc(gdpPercap)) |>
#   slice_head(n = 5)


# ----------------------------------------------------------------------
# Summaries by group
# ----------------------------------------------------------------------

gapminder |>
  filter(year == 2007) |>
  summarize(
    mean_life = mean(lifeExp),
    median_life = median(lifeExp),
    countries = n()
  )

gapminder |>
  filter(year == 2007) |>
  group_by(continent) |>
  summarize(median_life = median(lifeExp), countries = n())

ucb <- as_tibble(UCBAdmissions)
ucb

ucb |>
  group_by(Gender) |>
  summarize(
    applied = sum(n),
    admitted = sum(n[Admit == "Admitted"]),
    rate = admitted / applied
  )

by_dept <- ucb |>
  group_by(Dept, Gender) |>
  summarize(
    applied = sum(n),
    admitted = sum(n[Admit == "Admitted"]),
    rate = round(100 * admitted / applied)
  )
by_dept

ucb |>
  filter(Gender == "Female") |>
  group_by(Dept) |>
  summarize(applied = sum(n)) |>
  mutate(share = round(100 * applied / sum(applied)))


# ----------------------------------------------------------------------
# Building a chain one step at a time
# ----------------------------------------------------------------------

gapminder |>
  filter(year %in% c(1952, 2007)) |>
  group_by(continent, year) |>
  summarize(median_life = median(lifeExp), .groups = "drop")

gapminder |>
  filter(year %in% c(1952, 2007)) |>
  group_by(continent, year) |>
  summarize(median_life = median(lifeExp), .groups = "drop") |>
  group_by(continent) |>
  summarize(
    rise = median_life[year == 2007] - median_life[year == 1952]
  ) |>
  arrange(desc(rise))

gapminder |>
  filter(year == 2007) |>
  group_by(continent) |>
  summarize(across(c(lifeExp, gdpPercap), median))
