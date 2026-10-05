# Become a Data Wizard with R
# Chapter 5: Cleaning data
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# Looking before you change anything
# ----------------------------------------------------------------------

library(dplyr)
library(palmerpenguins)

glimpse(penguins_raw)

penguins_raw |> count(Species)

penguins_raw |> distinct(Region, Stage)


# ----------------------------------------------------------------------
# Names a script can use
# ----------------------------------------------------------------------

library(janitor)

raw <- penguins_raw |> clean_names()
names(raw)

raw <- raw |>
  rename(bill_length_mm = culmen_length_mm,
         bill_depth_mm = culmen_depth_mm,
         delta_15n = delta_15_n_o_oo,
         delta_13c = delta_13_c_o_oo)


# ----------------------------------------------------------------------
# Missing values have reasons
# ----------------------------------------------------------------------

colSums(is.na(raw))

raw |>
  filter(is.na(sex)) |>
  count(comments)

library(tidyr)

raw |> drop_na() |> nrow()
raw |> drop_na(body_mass_g) |> nrow()

raw |>
  replace_na(list(comments = "none")) |>
  count(comments, sort = TRUE) |>
  slice_head(n = 3)

rain <- tibble(
  day = 1:5,
  main_mm = c(12.4, -99, 0, NA, 3.1),
  backup_mm = c(12.1, 8.6, 0, 5.0, NA)
)

rain |>
  mutate(main_mm = na_if(main_mm, -99),
         rain_mm = coalesce(main_mm, backup_mm))


# ----------------------------------------------------------------------
# Giving each column the right type
# ----------------------------------------------------------------------

raw <- raw |>
  mutate(across(c(flipper_length_mm, body_mass_g), as.integer))

prices <- c("1,250", "$980", "1 100", "about 700", "n/a")
as.numeric(prices)

library(readr)

parse_number(prices, na = "n/a")

codes <- factor(c("10", "20", "5"))
as.numeric(codes)


# ----------------------------------------------------------------------
# Cleaning text
# ----------------------------------------------------------------------

library(stringr)

cities <- tibble(
  city = c("Cairo", "cairo ", " CAIRO", "São Paulo", "Sao  Paulo",
           "Lima", NA)
)
cities |> count(city)

cities |>
  mutate(city = str_to_lower(str_squish(city))) |>
  count(city)

raw |>
  filter(str_detect(comments, "blood")) |>
  count(comments)


# ----------------------------------------------------------------------
# Recoding categories with case_when()
# ----------------------------------------------------------------------

raw |>
  mutate(sex = case_when(sex == "MALE" ~ "male",
                         .default = "female")) |>
  count(sex)

raw |>
  mutate(sex = case_when(
    is.na(sex) ~ NA,
    sex == "MALE" ~ "male",
    sex == "FEMALE" ~ "female",
    .default = "check"
  )) |>
  count(sex)

raw |>
  mutate(species = case_when(
    str_detect(species, "Adelie") ~ "Adelie",
    str_detect(species, "Chinstrap") ~ "Chinstrap",
    str_detect(species, "Gentoo") ~ "Gentoo"
  )) |>
  count(species)

cities |>
  mutate(city = str_to_lower(str_squish(city)),
         city = replace_values(city, "são paulo" ~ "sao paulo"),
         city = str_to_title(city)) |>
  count(city)


# ----------------------------------------------------------------------
# Dates
# ----------------------------------------------------------------------

library(lubridate)

raw |>
  count(year = year(date_egg), month = month(date_egg, label = TRUE))

c(dmy("03/04/2024"), mdy("03/04/2024"))
dmy(c("3 April 2024", "3.4.2024", "31/02/2024"))


# ----------------------------------------------------------------------
# Duplicates
# ----------------------------------------------------------------------

raw |> distinct() |> nrow()

n_distinct(raw$individual_id)

raw |>
  count(species, island, study_name, individual_id) |>
  filter(n > 1) |>
  nrow()

invoices <- tibble(
  invoice = c("A-101", "A-102", "A-102", "A-103", "A-103"),
  office = c("Lagos", "Cairo", "Cairo", "Lima", "lima "),
  amount = c(250, 400, 400, 175, 175)
)

invoices |> distinct() |> nrow()
invoices |>
  mutate(office = str_to_title(str_squish(office))) |>
  distinct() |>
  nrow()


# ----------------------------------------------------------------------
# One unit per column
# ----------------------------------------------------------------------

parcels <- tibble(
  parcel = 1:4,
  weight = c("12 lb", "4 kg", "2,100 g", "950 g")
)

parcels |>
  mutate(value = parse_number(weight),
         weight_kg = case_when(
           str_detect(weight, "lb") ~ value * 0.4536,
           str_detect(weight, "g") ~ value / 1000,
           str_detect(weight, "kg") ~ value
         ))

parcels <- parcels |>
  mutate(value = parse_number(weight),
         weight_kg = case_when(
           str_detect(weight, "lb") ~ value * 0.4536,
           str_detect(weight, "kg") ~ value,
           str_detect(weight, "g") ~ value / 1000
         ))
parcels


# ----------------------------------------------------------------------
# From penguins_raw to penguins
# ----------------------------------------------------------------------

penguins_clean <- penguins_raw |>
  clean_names() |>
  rename(bill_length_mm = culmen_length_mm,
         bill_depth_mm = culmen_depth_mm) |>
  mutate(
    species = case_when(
      str_detect(species, "Adelie") ~ "Adelie",
      str_detect(species, "Chinstrap") ~ "Chinstrap",
      str_detect(species, "Gentoo") ~ "Gentoo"
    ),
    sex = str_to_lower(sex),
    year = as.integer(year(date_egg))
  ) |>
  mutate(across(c(flipper_length_mm, body_mass_g), as.integer)) |>
  mutate(across(c(species, island, sex), factor)) |>
  select(species, island, bill_length_mm, bill_depth_mm,
         flipper_length_mm, body_mass_g, sex, year)

all.equal(penguins_clean, penguins)

attr(penguins_clean, "spec") <- NULL
identical(penguins_clean, penguins)
