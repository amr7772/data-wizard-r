# Become a Data Wizard with R
# Chapter 8: Building charts with ggplot2
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# The grammar of a chart
# ----------------------------------------------------------------------

library(ggplot2)
library(dplyr)
library(gapminder)

gap_2007 <- gapminder |>
  filter(year == 2007)

ggplot(gap_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()


# ----------------------------------------------------------------------
# Mapping variables to color, shape, and size
# ----------------------------------------------------------------------

library(palmerpenguins)

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g,
                     color = species, shape = species)) +
  geom_point()


# ----------------------------------------------------------------------
# Lines for change over time
# ----------------------------------------------------------------------

malawi <- gapminder |>
  filter(country == "Malawi")

ggplot(malawi, aes(x = year, y = lifeExp)) +
  geom_line(color = "#1F4FA8", linewidth = 0.8) +
  geom_point(color = "#1F4FA8")

ggplot(gapminder, aes(x = year, y = lifeExp, group = country)) +
  geom_line(color = "grey80", linewidth = 0.3) +
  geom_line(data = malawi, color = "#1F4FA8", linewidth = 1)


# ----------------------------------------------------------------------
# Bars for counts and amounts
# ----------------------------------------------------------------------

ggplot(penguins, aes(x = species)) +
  geom_bar()

gap_2007 |>
  group_by(continent) |>
  summarize(pop_billions = sum(pop) / 1e9) |>
  ggplot(aes(x = pop_billions,
             y = reorder(continent, pop_billions))) +
  geom_col()


# ----------------------------------------------------------------------
# Histograms and box plots for spread
# ----------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram()

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()


# ----------------------------------------------------------------------
# Small multiples with facets
# ----------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200) +
  facet_wrap(~ species, ncol = 1)


# ----------------------------------------------------------------------
# Labels that say what the chart shows
# ----------------------------------------------------------------------

p <- ggplot(gap_2007, aes(x = gdpPercap, y = lifeExp,
                          size = pop / 1e6)) +
  geom_point(color = "#1F4FA8", alpha = 0.5)

p + labs(
  title = "Life expectancy rises steeply with income, then levels off",
  subtitle = "142 countries in 2007; circles sized by population",
  x = "GDP per capita (US dollars, inflation-adjusted)",
  y = "Life expectancy at birth (years)",
  size = "Population (millions)",
  caption = "Data: Gapminder, via the gapminder package"
)


# ----------------------------------------------------------------------
# Rebuilding Figure 4.2
# ----------------------------------------------------------------------

by_dept <- as_tibble(UCBAdmissions) |>
  group_by(Dept, Gender) |>
  summarize(
    rate = round(100 * sum(n[Admit == "Admitted"]) / sum(n)),
    .groups = "drop"
  )

ggplot(by_dept, aes(x = rate, y = Dept,
                    color = Gender, shape = Gender)) +
  geom_line(aes(group = Dept), color = "grey70") +
  geom_point(size = 2.5) +
  scale_y_discrete(limits = rev) +
  labs(x = "Applicants admitted (%)", y = "Department",
       color = NULL, shape = NULL)
