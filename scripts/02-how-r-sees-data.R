# Become a Data Wizard with R
# Chapter 2: How R sees data
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# Four types of value
# ----------------------------------------------------------------------

typeof(71.3)
typeof(2007)
typeof(2007L)
typeof("Egypt")
typeof(TRUE)

# This code stops with an error on purpose. Remove the '# ' to see the message.
# "2007" + 1

class(71.3)
class(2007L)
class("Egypt")


# ----------------------------------------------------------------------
# Vectors: many values of one type
# ----------------------------------------------------------------------

life <- c(41.9, 44.4, 47.0, 49.3, 51.1, 53.3,
          56.0, 59.8, 63.7, 67.2, 69.8, 71.3)
life
length(life)

1952:1957
year <- seq(1952, 2007, by = 5)
year
rep("Egypt", times = 3)
rep(c("female", "male"), times = 3)
rep(c("female", "male"), each = 3)

typeof(1952:1957)
typeof(year)


# ----------------------------------------------------------------------
# Arithmetic on whole vectors
# ----------------------------------------------------------------------

life - 41.9

c(1, 2, 3, 4) + c(10, 20)
c(1, 2, 3, 4, 5) + c(10, 20)

life > 60

sum(life > 60)
mean(life > 60)


# ----------------------------------------------------------------------
# Picking values with square brackets
# ----------------------------------------------------------------------

life[1]
life[c(1, 12)]
life[10:12]

life[-1]
life[-(1:6)]

life[life > 60]
year[life > 60]
life[year >= 1990]


# ----------------------------------------------------------------------
# When R changes a type
# ----------------------------------------------------------------------

c(TRUE, 2, "three")
c(TRUE, 2)
c(2L, 2.5)

as.numeric(c("42", "3.5", "1,200", "n/a"))
as.integer(3.9)

sort(c("10", "9", "100"))
"10" > "9"
sort(c(10, 9, 100))


# ----------------------------------------------------------------------
# Missing values
# ----------------------------------------------------------------------

life_gap <- c(41.9, 44.4, NA, 49.3)
life_gap
mean(life_gap)

mean(life_gap, na.rm = TRUE)
is.na(life_gap)
sum(is.na(life_gap))


# ----------------------------------------------------------------------
# Factors: categories with a fixed set of values
# ----------------------------------------------------------------------

months <- c("Sep", "Mar", "Dec", "Mar")
months_f <- factor(months)
months_f
levels(months_f)

months_f <- factor(months, levels = month.abb)
months_f
summary(months_f)

factor(c("Sep", "Mrach"), levels = month.abb)

typeof(months_f)
class(months_f)
as.integer(months_f)


# ----------------------------------------------------------------------
# Lists hold anything
# ----------------------------------------------------------------------

study <- list(
  authors = c("Ziemann", "Eren", "El-Osta"),
  year = 2016L,
  journals = 18L,
  share_affected = 0.196
)
str(study)

names(study)
study[["year"]]
study$authors
study$authors[3]


# ----------------------------------------------------------------------
# Data frames and tibbles
# ----------------------------------------------------------------------

library(dplyr)

studies <- tibble(
  study = c("Ziemann 2016", "Abeysooriya 2021"),
  first_year = c(2005L, 2014L),
  last_year = c(2015L, 2020L),
  with_lists = c(3597L, 11117L),
  affected = c(704L, 3436L)
)
studies

studies$affected / studies$with_lists

glimpse(studies)

library(gapminder)
gapminder

gapminder$lifeExp[gapminder$country == "Egypt"]

library(palmerpenguins)
glimpse(penguins)

summary(penguins)

mean(penguins$body_mass_g)
sum(is.na(penguins$body_mass_g))
mean(penguins$body_mass_g, na.rm = TRUE)
