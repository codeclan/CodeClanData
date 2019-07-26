library(readr)
library(usethis)
library(httr)
library(purrr)
library(dplyr)
library(stringr)
library(plotKML)
library(readxl)
library(janitor)

students <- read_rds('data-raw/data/students_data.rds')
colour_list <- read_rds('data-raw/data/colour_list.rds')
temp <- read_table('data-raw/data/maxtemp.txt')
beer <- read_delim('data-raw/data/beer.txt', delim = ';')
olympics <- read_csv('data-raw/data/athlete_events.csv')

# Fixing whisky data
load("data-raw/data/whisky.RData")
whisky2 <- read_csv("data-raw/data/whiskies.csv") %>% select(Latitude, Longitude)
whisky <- select(whisky, -Latitude, -Longitude) %>% cbind(whisky2)

monthly_sales <- read_excel("data-raw/data/sales1.xlsx", skip = 1) %>%
  rename(branch = ...1) %>%
  tidyr::gather(month, sales, -branch)

total_sales <- monthly_sales %>%
  group_by(branch) %>%
  summarise(
    sales = sum(sales)
  )

load("data-raw/data/chinesemeal.Rdata")
load("data-raw/data/UK_poly.Rdata")
load("data-raw/data/pets.Rdata")
load("data-raw/data/cuckoo.Rdata")
load("data-raw/data/scottish_exports.Rdata")
load("data-raw/data/scot_exp.Rdata")
load("data-raw/data/lotka_volterra.Rdata")
load("data-raw/data/polydata.Rdata")
load("data-raw/data/energy_scotland.Rdata")
load("data-raw/data/Benefits.Rdata")
load("data-raw/data/Backpack.Rdata")
load("data-raw/data/synthdat.Rdat")
load("data-raw/data/BMI.Rdata")
load("data-raw/data/Guerry.Rdata")
load("data-raw/data/hills2000.Rdat")
load("data-raw/data/volcano.Rdata")
load("data-raw/data/physical_activity.Rdata")
load("data-raw/data/data3.Rdata")
bayestown_survey <- read.csv("data-raw/data/bayestownIncomeSurvey.csv")
load("data-raw/data/QikBit_Competitors.Rdata")
load("data-raw/data/QikBit_MonthlyFigs.Rdata")
load("data-raw/data/QikBit_RevBreakdown.Rdata")
load("data-raw/data/accData.Rdata")
load("data-raw/data/bank_expense.RData")
load("data-raw/data/competencies.RData")
load("data-raw/data/EUbank.RData")
load("data-raw/data/euro_ineq.RData")
load("data-raw/data/inflation4.RData")
load("data-raw/data/invest_alluvial.RData")
load("data-raw/data/invest_lodes.RData")
load("data-raw/data/invest_lodes2.RData")
load("data-raw/data/late_deliveries.RData")
load("data-raw/data/milk.RData")
load("data-raw/data/scot_exports_2017.RData")
load("data-raw/data/stonybridge.RData")
load("data-raw/data/VoteEU.RData")
load("data-raw/data/death_note.RData")
load("data-raw/data/flatPrices.RData")
load("data-raw/data/world.RData")

qb_competitors <- Q4data
rm(Q4data)

qb_monthly_sales <- Q23data
rm(Q23data)

qb_revenue_breakdown <- Q1data
rm(Q1data)

qb_device_data <- accData
rm(accData)

# This is how the starwars data is generated, keeping for reference but commented out because
# it takes a long time to run.

# Star wars
# starwars <- jsonlite::fromJSON(read_file('data-raw/data/starwars_data.json'), simplifyVector = FALSE)$results
#
# get_title <- function(url, name = 'name'){
#   request <- GET(url)
#   content(request)[[name]]
# }
#
# for (i in 1:length(starwars)){
#   starwars[[i]]$films <- map(starwars[[i]]$films, get_title, name = 'title')
#   starwars[[i]]$homeworld <- get_title(starwars[[i]]$homeworld)
#   starwars[[i]]$species <- map(starwars[[i]]$species, get_title)
#   starwars[[i]]$vehicles <- map(starwars[[i]]$vehicles, get_title)
#   starwars[[i]]$starships <- map(starwars[[i]]$starships, get_title)
# }
#
# write_rds(starwars, "data-raw/data/starwars.rda")

starwars <- read_rds("data-raw/data/starwars.rda")


temp <-
  temp %>%
  filter(Year <= 2015) %>%
  select(JAN:DEC) %>%
  as.matrix()


beer <-
  beer %>%
  mutate(
    percent = str_remove(percent, '%') %>% as.numeric(),
    carbohydrates = str_remove(carbohydrates, 'g') %>% as.numeric()
  ) %>%
  na.omit()


# Game of Thrones

# This is how the game of thrones data is generated, keeping for reference but commented out because
# it takes a long time to run.

# response <- GET('https://anapioficeandfire.com/api/books/1')
# game_of_thrones <- content(response)
#
# for (i in 1:length(game_of_thrones$characters)){
#
#   response <- GET(game_of_thrones$characters[[i]])
#   character <- content(response)
#
#   game_of_thrones$characters[[i]] <- list(name = character$name, gender = character$gender)
# }
#
# game_of_thrones$povCharacters <- NULL
#
# write_rds(game_of_thrones, "data-raw/data/game_of_thrones.rda")

game_of_thrones <- read_rds("data-raw/data/game_of_thrones.rda")

# Olympics

olympics <- janitor::clean_names(olympics)

olympics_overall_medals <-
olympics %>%
  filter(!is.na(medal)) %>%
  group_by(team, season, medal) %>%
  summarise(
    count = n()
  ) %>%
  ungroup %>%
  mutate(medal = factor(medal, levels = c('Gold', 'Silver', 'Bronze'))) %>%
  arrange(season, medal, desc(count))

# Temperature Data Frame
temp_df <- as_tibble(temp) %>%
  mutate(year = 1910:2015) %>%
  tidyr::gather(month, max_temp, JAN:DEC) %>%
  mutate(month = str_to_lower(month)) %>%
  mutate(month = factor(month, levels = str_to_lower(month.abb)))

# Students Big
students_big <- read_csv("data-raw/data/uk_school_census.csv") %>% select(-21)
students_big <- janitor::clean_names(students_big)
students_big <- na.omit(students_big)
students_big <- filter(students_big, importance_reducing_pollution != 0)

# Dogs of NYC
nyc_dogs <- read_csv("data-raw/data/nyc_dogs.csv")

nyc_dogs <-
nyc_dogs %>%
  select(dog_name, gender, breed, birth, colour = dominant_color, borough) %>%
  filter(gender != "n/a") %>%
  mutate(
    dog_name = dog_name %>% str_to_lower %>% str_to_title,
    colour  = colour %>% str_to_lower %>% str_to_title,
    gender = if_else(gender == "F", "Female", "Male")
  )

# Cycle route data

CycleRoute2 <- readGPX("data-raw/data/LAL_Route_2.gpx") # read GPX data
route2 <- CycleRoute2$tracks[[1]]$`LAL Route 2`[, 1:2] # strip out the long/lat coordinates

CycleRoute3 <- readGPX("data-raw/data/LAL_Route_3.gpx") # read GPX data
route3 <- CycleRoute3$tracks[[1]]$`LAL Route 3`[, 1:2] # strip out long/lat coords

cycle_routes <- list(route2 = route2, route3 = route3)

# Intro to visualisation

playfair_denmark <- readr::read_csv("data-raw/data/playfair_Denmark.csv")

# Selecting the right chart excerise data

path <- "data-raw/data/ExerciseSet.xlsx"

late_deliveries <-
read_excel(path, sheet = 1) %>%
  clean_names() %>%
  mutate(date = as.Date(date))

recovery_times <-
  read_excel(path, sheet = 2) %>%
  clean_names()

fitness_levels <-
  read_excel(path, sheet = 3) %>%
  clean_names()

fitness_levels <-
fitness_levels %>%
  tidyr::gather(age, fitness_score, x8:x13) %>%
  mutate(age = str_remove(age, 'x') %>% as.numeric)

blood_pressure <-
  read_excel(path, sheet = 4) %>%
  clean_names()

car_use <-
  read_excel(path, sheet = 5) %>%
  clean_names() %>%
  rename(car_use_percent = car_use, population = population_thousands) %>%
  mutate(population = population*1000)

d20_outcomes <-
  read_excel(path, sheet = 6) %>%
  clean_names()

d20x5_outcomes <-
  read_excel(path, sheet = 7) %>%
  clean_names()

pension_surplus <-
  read_excel(path, sheet = 8) %>%
  clean_names()

pension_liabilities <-
  read_excel(path, sheet = 9) %>%
  clean_names() %>%
  rename(widowed_people = widow_er_s)

# Table of numbers
set.seed(100)

table_of_numbers <- data.frame(
  x = rep(1:10, times = 10),
  y = rep(1:10, each = 10),
  num = rpois(100, 3)
)


use_data(students, overwrite = TRUE)
use_data(colour_list, overwrite = TRUE)
use_data(starwars, overwrite = TRUE)
use_data(temp, overwrite = TRUE)
use_data(beer, overwrite = TRUE)
use_data(game_of_thrones, overwrite = TRUE)
use_data(olympics_overall_medals, overwrite = TRUE)
use_data(whisky, overwrite = TRUE)
use_data(chinesemeal, overwrite = TRUE)
use_data(UK_poly, overwrite = TRUE)
use_data(pets, overwrite = TRUE)
use_data(cuckoo, overwrite = TRUE)
use_data(scottish_exports, overwrite = TRUE)
use_data(scot_exp, overwrite = TRUE)
use_data(lotka_volterra, overwrite = TRUE)
use_data(polydata, overwrite = TRUE)
use_data(energy_scotland, overwrite = TRUE)
use_data(Benefits, overwrite = TRUE)
use_data(Backpack, overwrite = TRUE)
use_data(data1, overwrite = TRUE)
use_data(data2, overwrite = TRUE)
use_data(exercise_data, overwrite = TRUE)
use_data(list_weights, overwrite = TRUE)
use_data(Guerry, overwrite = TRUE)
use_data(hills2000, overwrite = TRUE)
use_data(data3, overwrite = TRUE)
use_data(physical_activity, overwrite = TRUE)
use_data(volcano, overwrite = TRUE)
use_data(bayestown_survey, overwrite = TRUE)
use_data(qb_competitors, overwrite = TRUE)
use_data(qb_device_data, overwrite = TRUE)
use_data(qb_monthly_sales, overwrite = TRUE)
use_data(qb_revenue_breakdown, overwrite = TRUE)
use_data(bank_expense, overwrite = TRUE)
use_data(competencies, overwrite = TRUE)
use_data(EUbank, overwrite = TRUE)
use_data(euro_ineq, overwrite = TRUE)
use_data(inflation4, overwrite = TRUE)
use_data(invest_alluvial, overwrite = TRUE)
use_data(invest_lodes, overwrite = TRUE)
use_data(invest_lodes2, overwrite = TRUE)
use_data(late_deliveries, overwrite = TRUE)
use_data(milk, overwrite = TRUE)
use_data(scot_exports_2017, overwrite = TRUE)
use_data(stonybridge, overwrite = TRUE)
use_data(vote19_eu, overwrite = TRUE)
use_data(death_males, overwrite = TRUE)
use_data(flatPrices, overwrite = TRUE)
use_data(world, overwrite = TRUE)
use_data(temp_df, overwrite = TRUE)
use_data(students_big, overwrite = TRUE)
use_data(nyc_dogs, overwrite = TRUE)
use_data(cycle_routes, overwrite = TRUE)
use_data(playfair_denmark, overwrite = TRUE)
use_data(blood_pressure, overwrite = TRUE)
use_data(car_use, overwrite = TRUE)
use_data(d20_outcomes, overwrite = TRUE)
use_data(d20x5_outcomes, overwrite = TRUE)
use_data(fitness_levels, overwrite = TRUE)
use_data(pension_liabilities, overwrite = TRUE)
use_data(pension_surplus, overwrite = TRUE)
use_data(recovery_times, overwrite = TRUE)
use_data(late_deliveries, overwrite = TRUE)
use_data(table_of_numbers, overwrite = TRUE)
use_data(monthly_sales, overwrite = TRUE)
use_data(total_sales, overwrite = TRUE)
