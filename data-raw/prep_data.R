library(readr)
library(usethis)
library(httr)
library(purrr)

students <- read_rds('data-raw/data/students_data.rds')
colour_list <- read_rds('data-raw/data/colour_list.rds')
starwars <- jsonlite::fromJSON(read_file('data-raw/data/starwars_data.json'), simplifyVector = FALSE)$results

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

use_data(students, overwrite = TRUE)
use_data(colour_list, overwrite = TRUE)
use_data(starwars, overwrite = TRUE)
