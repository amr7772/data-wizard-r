# Become a Data Wizard with R
# Chapter 7: Describing data with numbers
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# The middle of a column
# ----------------------------------------------------------------------

library(dplyr)
library(gapminder)

gm_2007 <- gapminder |> filter(year == 2007)
life <- gm_2007$lifeExp

mean(life)
median(life)

sum(life) / length(life)
sort(life)[71:72]

mean(c(life, 396))
median(c(life, 396))

library(palmerpenguins)

count(penguins, island, sort = TRUE)


# ----------------------------------------------------------------------
# How far the values spread
# ----------------------------------------------------------------------

range(life)
max(life) - min(life)

north_africa <- c("Algeria", "Egypt", "Libya", "Morocco", "Tunisia")
north_2007 <- gm_2007 |> filter(country %in% north_africa)
north_life <- north_2007$lifeExp

north_life - mean(north_life)

squares <- (north_life - mean(north_life))^2
sum(squares) / (length(north_life) - 1)
var(north_life)
sd(north_life)

quantile(life)

quantile(penguins$body_mass_g, probs = c(0.25, 0.75), na.rm = TRUE)
IQR(penguins$body_mass_g, na.rm = TRUE)


# ----------------------------------------------------------------------
# The shape of a column
# ----------------------------------------------------------------------

summary(gm_2007$gdpPercap)


# ----------------------------------------------------------------------
# Values far from the rest
# ----------------------------------------------------------------------

gdp <- gm_2007$gdpPercap
quartiles <- quantile(gdp, probs = c(0.25, 0.75))
iqr <- IQR(gdp)

quartiles[1] - 1.5 * iqr
quartiles[2] + 1.5 * iqr

gm_2007 |> filter(gdpPercap > quartiles[2] + 1.5 * iqr)

gm_2007 |>
  group_by(continent) |>
  filter(lifeExp < quantile(lifeExp, 0.25) - 1.5 * IQR(lifeExp) |
           lifeExp > quantile(lifeExp, 0.75) + 1.5 * IQR(lifeExp)) |>
  ungroup()


# ----------------------------------------------------------------------
# Comparing groups and weighting means
# ----------------------------------------------------------------------

penguins |>
  group_by(species) |>
  summarize(
    birds = n(),
    missing = sum(is.na(body_mass_g)),
    mean_g = mean(body_mass_g, na.rm = TRUE),
    sd_g = sd(body_mass_g, na.rm = TRUE),
    median_g = median(body_mass_g, na.rm = TRUE),
    iqr_g = IQR(body_mass_g, na.rm = TRUE)
  )

sum(gm_2007$lifeExp * gm_2007$pop) / sum(gm_2007$pop)
weighted.mean(gm_2007$lifeExp, w = gm_2007$pop)

by_continent <- gm_2007 |>
  group_by(continent) |>
  summarize(mean_life = mean(lifeExp), countries = n())

mean(by_continent$mean_life)
weighted.mean(by_continent$mean_life, w = by_continent$countries)


# ----------------------------------------------------------------------
# Percentages, changes, and rates
# ----------------------------------------------------------------------

pop_by_continent <- gapminder |>
  filter(year %in% c(1952, 2007)) |>
  group_by(year, continent) |>
  summarize(pop = sum(pop), .groups = "drop")

pop_by_continent |>
  group_by(year) |>
  mutate(share = round(100 * pop / sum(pop), 1))

pop_by_continent |>
  group_by(continent) |>
  summarize(
    change = 100 * (pop[year == 2007] - pop[year == 1952]) /
      pop[year == 1952]
  )


# ----------------------------------------------------------------------
# Two columns together: correlation
# ----------------------------------------------------------------------

cor(penguins$flipper_length_mm, penguins$body_mass_g)
cor(penguins$flipper_length_mm, penguins$body_mass_g,
    use = "complete.obs")

cor(gm_2007$gdpPercap, gm_2007$lifeExp)
cor(gm_2007$gdpPercap, gm_2007$lifeExp, method = "spearman")

cor(penguins$bill_length_mm, penguins$bill_depth_mm,
    use = "complete.obs")

penguins |>
  group_by(species) |>
  summarize(r = cor(bill_length_mm, bill_depth_mm,
                    use = "complete.obs"))

anscombe |> summarize(across(everything(), mean))
anscombe |> summarize(across(everything(), sd)) |> round(3)
anscombe |>
  summarize(r1 = cor(x1, y1), r2 = cor(x2, y2),
            r3 = cor(x3, y3), r4 = cor(x4, y4))
