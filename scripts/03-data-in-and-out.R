# Become a Data Wizard with R
# Chapter 3: Getting data in and out
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# Where R looks for files
# ----------------------------------------------------------------------

dir.create("data", showWarnings = FALSE)
file.exists("data")


# ----------------------------------------------------------------------
# Writing a file and reading it back
# ----------------------------------------------------------------------

library(readr)
library(gapminder)

write_csv(gapminder, "data/gapminder.csv")

read_lines("data/gapminder.csv", n_max = 4)

gap_csv <- read_csv("data/gapminder.csv")
gap_csv

gapminder

nrow(gap_csv)
length(read_lines("data/gapminder.csv"))


# ----------------------------------------------------------------------
# Telling R what each column holds
# ----------------------------------------------------------------------

gap_typed <- read_csv(
  "data/gapminder.csv",
  col_types = cols(
    country = col_factor(),
    continent = col_factor(),
    year = col_integer(),
    lifeExp = col_double(),
    pop = col_integer(),
    gdpPercap = col_double()
  )
)
gap_typed

levels(gapminder$continent)
levels(gap_typed$continent)

spec(gap_csv)


# ----------------------------------------------------------------------
# When a column does not read cleanly
# ----------------------------------------------------------------------

# Afghanistan's 12 rows, formatted the way many reports show numbers
afg <- head(gapminder, 12)
afg$pop <- format(afg$pop, big.mark = ",", trim = TRUE)
afg$gdpPercap <- paste0("$", round(afg$gdpPercap, 2))
afg$lifeExp[3:4] <- "n/a"
write_csv(afg, "data/afghanistan_formatted.csv")
read_lines("data/afghanistan_formatted.csv", n_max = 5)

afg_guess <- read_csv("data/afghanistan_formatted.csv")
afg_guess

afg_strict <- read_csv(
  "data/afghanistan_formatted.csv",
  col_types = cols(lifeExp = col_double(), gdpPercap = col_double())
)

# The fifth column, the file's full path, is left out to save space
problems(afg_strict)[1:4]

afg_clean <- read_csv(
  "data/afghanistan_formatted.csv",
  col_types = cols(gdpPercap = col_number()),
  na = c("", "NA", "n/a")
)
afg_clean


# ----------------------------------------------------------------------
# Reading Excel workbooks
# ----------------------------------------------------------------------

library(readxl)
library(writexl)

write_xlsx(list(gapminder = gapminder, country_codes = country_codes),
           "data/gapminder.xlsx")
excel_sheets("data/gapminder.xlsx")

gap_xlsx <- read_excel("data/gapminder.xlsx")
gap_xlsx

read_excel("data/gapminder.xlsx", sheet = "country_codes",
           range = "A1:C4")

afg5 <- head(gapminder, 5)
notes_sheet <- data.frame(
  A = c("Life expectancy at birth, Afghanistan",
        "Source: gapminder R package", NA, "year", afg5$year),
  B = c(NA, NA, NA, "lifeExp", afg5$lifeExp)
)
write_xlsx(notes_sheet, "data/afghanistan_notes.xlsx",
           col_names = FALSE)

read_excel("data/afghanistan_notes.xlsx")

afg_notes <- read_excel("data/afghanistan_notes.xlsx", skip = 3)
afg_notes

type_convert(afg_notes)


# ----------------------------------------------------------------------
# Text in languages other than English
# ----------------------------------------------------------------------

charToRaw("e")
charToRaw("é")

spellings <- data.frame(
  gapminder = c("Cote d'Ivoire", "Reunion", "Sao Tome and Principe"),
  accented = c("Côte d'Ivoire", "Réunion", "São Tomé and Príncipe")
)
write.csv(spellings, "data/spellings_latin1.csv", row.names = FALSE,
          fileEncoding = "latin1")
read_csv("data/spellings_latin1.csv", col_types = "cc")

guess_encoding("data/spellings_latin1.csv")

read_csv("data/spellings_latin1.csv", col_types = "cc",
         locale = locale(encoding = "latin1"))

own_names <- data.frame(
  country = c("Egypt", "China", "Greece"),
  own_name = c("مصر", "中国", "Ελλάδα")
)
write_csv(own_names, "data/own_names.csv")
read_csv("data/own_names.csv", col_types = "cc")

write.csv(own_names, "data/own_names_latin1.csv", row.names = FALSE,
          fileEncoding = "latin1")
read_lines("data/own_names_latin1.csv")
nrow(read_csv("data/own_names_latin1.csv", col_types = "cc"))


# ----------------------------------------------------------------------
# Saving your results
# ----------------------------------------------------------------------

saveRDS(gapminder, "data/gapminder.rds")
gap_rds <- readRDS("data/gapminder.rds")
identical(gap_rds, gapminder)

nrow(read_excel("data/gapminder.xlsx")) == nrow(gapminder)
