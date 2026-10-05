# Become a Data Wizard with R
# Chapter 9: Honest charts, ready to publish
# Companion script: the code shown in the chapter, in the order it appears.
# Run it from the RStudio project you set up in Chapter 1.
# The whole file runs from top to bottom; code that the book shows but does not
# run, or that stops with an error on purpose, is commented out and marked.


# ----------------------------------------------------------------------
# Which way is up
# ----------------------------------------------------------------------

library(ggplot2)
library(dplyr)
library(gapminder)

theme_set(theme_minimal(base_size = 9))

zimbabwe <- gapminder |>
  filter(country == "Zimbabwe")

zim_plot <- ggplot(zimbabwe, aes(x = year, y = lifeExp)) +
  geom_area(fill = "#D5DEF0") +
  geom_line(color = "#1F4FA8", linewidth = 0.8) +
  labs(x = NULL, y = "Life expectancy at birth (years)")

zim_plot + scale_y_reverse()

zim_plot


# ----------------------------------------------------------------------
# Where the axis starts
# ----------------------------------------------------------------------

continent_life <- gapminder |>
  filter(year == 2007) |>
  group_by(continent) |>
  summarize(median_life = median(lifeExp))

continent_life

bars <- ggplot(continent_life, aes(x = continent, y = median_life)) +
  geom_col(fill = "#1F4FA8", width = 0.6) +
  labs(x = NULL, y = "Median life expectancy (years)")

bars + coord_cartesian(ylim = c(50, 82), expand = FALSE)

bars + scale_y_continuous(expand = expansion(mult = c(0, 0.05)))


# ----------------------------------------------------------------------
# Scales that fit the numbers
# ----------------------------------------------------------------------

gapminder_2007 <- gapminder |>
  filter(year == 2007)

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(color = "#1F4FA8", alpha = 0.7) +
  scale_x_log10(breaks = c(300, 1000, 3000, 10000, 30000),
                labels = scales::label_comma()) +
  labs(x = "GDP per capita (US dollars, log scale)",
       y = "Life expectancy (years)")

long_lives <- gapminder |>
  group_by(year) |>
  summarize(share_70 = sum(lifeExp >= 70) / n())

ggplot(long_lives, aes(x = year, y = share_70)) +
  geom_line(color = "#1F4FA8", linewidth = 0.8) +
  geom_point(color = "#1F4FA8") +
  scale_y_continuous(labels = scales::label_percent(),
                     limits = c(0, 1)) +
  labs(x = NULL, y = "Countries at 70 years or more")


# ----------------------------------------------------------------------
# Color with a purpose
# ----------------------------------------------------------------------

palette.colors()

library(palmerpenguins)

species_colors <- palette.colors()[c("orange", "reddishpurple",
                                     "blue")]
names(species_colors) <- c("Adelie", "Chinstrap", "Gentoo")

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g,
                     color = species, shape = species)) +
  geom_point(alpha = 0.8, na.rm = TRUE) +
  scale_color_manual(values = species_colors) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)",
       color = NULL, shape = NULL)


# ----------------------------------------------------------------------
# Words on the chart
# ----------------------------------------------------------------------

continent_70 <- gapminder |>
  filter(continent != "Oceania") |>
  group_by(continent, year) |>
  summarize(share_70 = sum(lifeExp >= 70) / n(), .groups = "drop")

ends <- continent_70 |> filter(year == 2007)
ends

continent_plot <- ggplot(continent_70,
                         aes(x = year, y = share_70,
                             group = continent)) +
  geom_line(color = "grey65", linewidth = 0.7) +
  geom_line(data = filter(continent_70, continent == "Africa"),
            color = "#1F4FA8", linewidth = 1.1) +
  geom_text(data = ends, aes(label = continent),
            hjust = 0, nudge_x = 1.5) +
  annotate("text", x = 2004, y = 0.25, hjust = 1,
           label = "No African\ncountry reached\n70 until 1987") +
  scale_x_continuous(breaks = c(1952, 1967, 1982, 1997, 2007),
                     expand = expansion(mult = c(0.02, 0.16))) +
  scale_y_continuous(labels = scales::label_percent(),
                     limits = c(0, 1)) +
  labs(title = paste("By 2007, 7 of 52 African countries",
                     "had reached 70 years"),
       subtitle = paste("Share of countries with a life expectancy",
                        "at birth of 70 years or more"),
       caption = paste("Data: gapminder R package, from",
                       "Gapminder.org. Oceania (two countries)",
                       "not shown."),
       x = NULL, y = NULL)

continent_plot


# ----------------------------------------------------------------------
# A house theme
# ----------------------------------------------------------------------

house_colors <- unname(palette.colors()[c("blue", "orange",
                                          "bluishgreen", "skyblue",
                                          "vermillion",
                                          "reddishpurple")])

theme_house <- function(base_size = 9, base_family = "") {
  theme_minimal(base_size = base_size,
                base_family = base_family) +
    theme(
      plot.title = element_text(face = "bold"),
      plot.title.position = "plot",
      plot.caption = element_text(color = "grey40", hjust = 0),
      plot.caption.position = "plot",
      panel.grid.minor = element_blank(),
      axis.title = element_text(color = "grey30"),
      legend.position = "top",
      palette.color.discrete = house_colors,
      palette.fill.discrete = house_colors
    )
}

continent_plot + theme_house()


# ----------------------------------------------------------------------
# Saving for print and screen
# ----------------------------------------------------------------------

long_lives_plot <- continent_plot + theme_house()
out_dir <- tempdir()

ggsave(file.path(out_dir, "long-lives.png"), plot = long_lives_plot,
       width = 5.5, height = 3.4, units = "in", dpi = 300)
ggsave(file.path(out_dir, "long-lives.pdf"), plot = long_lives_plot,
       width = 5.5, height = 3.4, units = "in")
ggsave(file.path(out_dir, "long-lives-web.png"),
       plot = long_lives_plot,
       width = 1200, height = 740, units = "px", dpi = 150)

list.files(out_dir, pattern = "^long-lives")


# ----------------------------------------------------------------------
# Three more ways a chart misleads
# ----------------------------------------------------------------------

library(datasauRus)

ggplot(box_plots_long, aes(x = Values, y = Plot)) +
  geom_jitter(height = 0.3, width = 0, size = 0.3, alpha = 0.25,
              color = "grey40") +
  geom_boxplot(fill = NA, color = "#1F4FA8", linewidth = 0.6,
               outlier.shape = NA) +
  labs(x = NULL, y = NULL)
