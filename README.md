# My package that Needs a better name


## Quick intro to whatever better name I come up with for this package

This is a package designed to help you download, create an SQL database for, and visualise, hourly climate data from Environment Canada.


## What can we do

As of April 1 2026, you can:

- download a singular month from a singular year from a singular station
- download all of the hourly data from a given year from a given station
- download all of the available hourly data across all available years from a given station

In the future, I will be adding:

- a function to download all of the data from all of the stations
- a function to create an SQLite database
- a function to create a shiny app to visualise missing data
- more EDA stuff


## Quick Tip!

Because the station download functions rely on knowledge about the station meta data (i.e the station ID and/or name), it may be a good idea to have a quick look at the metadata.

```{r}
library(Datacleaning)

metadata <- load("data/station_meta_data.rda")

head(metadata)

```

