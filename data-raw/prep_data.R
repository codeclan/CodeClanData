library(readr)
library(usethis)
library(httr)
library(purrr)
library(dplyr)
library(stringr)

students <- read_rds('data-raw/data/students_data.rds')
colour_list <- read_rds('data-raw/data/colour_list.rds')
starwars <- jsonlite::fromJSON(read_file('data-raw/data/starwars_data.json'), simplifyVector = FALSE)$results
temp <- read_table('data-raw/data/maxtemp.txt')
beer <- read_delim('data-raw/data/beer.txt', delim = ';')
olympics <- read_csv('data-raw/data/athlete_events.csv')
load('data-raw/data/whisky.Rdata')
load("data-raw/data/chinesemeal.Rdata")
load("data-raw/data/UK_poly.Rdata")
load("data-raw/data/pets.Rdata")
load("data-raw/data/cuckoo.Rdata")
load("data-raw/data/scottish_exports.Rdata")
load("data-raw/data/scot_exp.Rdata")
load("data-raw/data/lotka_volterra.Rdata")
load("data-raw/data/polydata.Rdata")
load("data-raw/data/energy_scotland.Rdata")

get_title <- function(url, name = 'name'){
  request <- GET(url)
  content(request)[[name]]
}

for (i in 1:length(starwars)){
  starwars[[i]]$films <- map(starwars[[i]]$films, get_title, name = 'title')
  starwars[[i]]$homeworld <- get_title(starwars[[i]]$homeworld)
  starwars[[i]]$species <- map(starwars[[i]]$species, get_title)
  starwars[[i]]$vehicles <- map(starwars[[i]]$vehicles, get_title)
  starwars[[i]]$starships <- map(starwars[[i]]$starships, get_title)
}


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

response <- GET('https://anapioficeandfire.com/api/books/1')
game_of_thrones <- content(response)

for (i in 1:length(game_of_thrones$characters)){

  response <- GET(game_of_thrones$characters[[i]])
  character <- content(response)

  game_of_thrones$characters[[i]] <- list(name = character$name, gender = character$gender)
}

game_of_thrones$povCharacters <- NULL

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


