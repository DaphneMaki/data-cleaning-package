# My package that Needs a better name


## Quick intro to whatever better name I come up with for this package

This is a package designed to help you download, create an SQL database for, and visualise, hourly climate data from Environment Canada.


## What can we do

As of April 21st, you can:

- explore available stations that meet certain criteria
- download a singular month from a singular year from a singular station
- download all of the hourly data from a given year from a given station
- download all of the available hourly data across all available years from a given station
- download all of the data from all of the stations
- create an SQLite database
- create two types of shiny app to visualise missing data


## Quick Tip!

Because the station download functions rely on knowledge about the station meta data (i.e the station ID and/or name), it may be a good idea to have a quick look at the metadata.

```r
library(Datacleaning)

metadata <- load("data/station_meta_data.rda")

head(metadata)

```

If you do wish to parse the entire metadata, you can use the `station_helper` function to help you find what you are looking for. This function can help you look for stations with data available in a specific year, are in a specific province, or have a station name that starts with a particular sting/letter.


```r
library(Datacleaning)

station_helper(province = "BC")

```

After figuring out the station you want, you can start downloading data using the `download_one_csv_checks`, `download_all_one_station_one_year`, or `download_all_one_station` functions.

```r
library(Datacleaning)

download_one_csv_checks(station_ID = 1706, year = 2001, month = 6)

download_all_one_station_one_year(station_ID = 1706, year = 2001)

download_all_one_station(station_ID = 1706)

```
`

After downloading the data, you can make an SQLite database

```r
library(Datacleaning)

make_database(file_path_to_csv_files = "./station_data",
database_name = "Environment_Canada_database.sqlite")

```

You can also make some shiny apps to check for missing-ness

```r
library(Datacleaning)

missing_data_visualiser_heatmap(dat = demo_data)

```

```r
library(Datacleaning)

missing_data_visualiser_barcodes(dat = demo_data)

```
