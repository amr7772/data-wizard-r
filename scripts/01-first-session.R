# Become a Data Wizard with R
# Chapter 1: Your first session in R
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# Projects and scripts
# ----------------------------------------------------------------------

# Shown in the book but not run there. Remove the '# ' to run it.
# getwd()


# ----------------------------------------------------------------------
# R as a calculator
# ----------------------------------------------------------------------

# Span of the data, in years
2007 - 1952
# One row every five years, counting the first
(2007 - 1952) / 5 + 1

2 + 3 * 4
(2 + 3) * 4

5 * 1e9

Nile


# ----------------------------------------------------------------------
# Asking R yes-or-no questions
# ----------------------------------------------------------------------

1000 >= 1000
"Aswan" == "aswan"

# Years with a flow above 1,000 units
sum(Nile > 1000)
# Years with a flow from 800 to 1,000 units, both ends included
sum(Nile >= 800 & Nile <= 1000)
# Years that were not above 1,000 units
sum(!(Nile > 1000))


# ----------------------------------------------------------------------
# Keeping results in objects
# ----------------------------------------------------------------------

highest <- 1370
lowest <- 456
highest - lowest
highest / lowest

# This code stops with an error on purpose. Remove the '# ' to see the message.
# 1874_flow <- 1210


# ----------------------------------------------------------------------
# Functions, arguments, and help
# ----------------------------------------------------------------------

length(Nile)
mean(Nile)
max(Nile)
min(Nile)

round(919.35)
round(919.35, digits = 1)
round(919.35, 1)

args(round)

round(mean(Nile), digits = 1)

# Shown in the book but not run there. Remove the '# ' to run it.
# ?round


# ----------------------------------------------------------------------
# Packages
# ----------------------------------------------------------------------

# Shown in the book but not run there. Remove the '# ' to run it.
# install.packages(c("tidyverse", "writexl", "gapminder",
#                    "palmerpenguins", "nycflights13", "datasauRus",
#                    "janitor", "colorspace"))

# This code stops with an error on purpose. Remove the '# ' to see the message.
# gapminder

library(gapminder)
nrow(gapminder)

packageVersion("dplyr")


# ----------------------------------------------------------------------
# Reading error messages
# ----------------------------------------------------------------------

# This code stops with an error on purpose. Remove the '# ' to see the message.
# higest
# Max(Nile)

# This code stops with an error on purpose. Remove the '# ' to see the message.
# round(3.14159 digits = 2)

# This code stops with an error on purpose. Remove the '# ' to see the message.
# sqrt("16")

sqrt(-1)
