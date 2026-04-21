station_meta_data <- read.csv("raw-data/hourly_climate_stations.csv", skip = 3) # yeah idk how to get around this yet...
usethis::use_data(station_meta_data)


demo_data <- readRDS("demo_data.rds")
usethis::use_data(demo_data)
