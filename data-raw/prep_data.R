library(readr)
library(usethis)

students <- read_rds('data-raw/data/students_data.rds')
colour_list <- read_rds('data-raw/data/colour_list.rds')
starwars <- jsonlite::fromJSON(read_file('data-raw/data/starwars_data.json'), simplifyVector = FALSE)$results

use_data(students, overwrite = TRUE)
use_data(colour_list, overwrite = TRUE)
use_data(starwars, overwrite = TRUE)
