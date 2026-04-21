#' csv downloader
#'
#' Function that downloads one file from one year from one station
#'
#' @param station_name \code{station_name}; the station name
#' @param station_ID \code{station_ID}; the station ID
#' @param year \code{year}; the year
#' @param month \code{month}; the month
#'
#' @return a \code{data.frame} that has the hourly data from one month from one year from one station.
#' @export
#'

download_just_one_csv_with_checks <- function(station_name = NULL, station_ID = NULL, year, month, temporary = FALSE, testing = FALSE){

  load("data/station_meta_data.rda")
  check <- station_meta_data # yeah idk how to get around this yet...
  station_ID_real <- station_ID
  station_name_real <- station_name

  #checking for a mismatch in station ID and name




  # this will check if one of either station ID or station name is missing. If one is there, we can continue, but if both are missing, we can't do shit
  if(is.null(station_ID)){
    if(is.null(station_name)){
      message("Please enter either a station ID or a station name")
    }

    station_name_upper <- station_name |> toupper()
    station_name_nospaces_or_underscores <-  gsub(pattern = "[ /_]", "", station_name_upper)
    check_names <- gsub(pattern = "[ /_]", "", check$Name)

    station_name_doubles <- which(check_names == station_name_nospaces_or_underscores)

    if(length(station_name_doubles) > 1){
      station_ID_multiple_same_name_dat <- check[station_name_doubles, ]
      station_ID_multiple_same_name <-paste(station_ID_multiple_same_name_dat$Station.ID, collapse = ", ")
      multiple_stations_same_name <- paste0("There are several stations with the station name ", station_name, ". ",
                                            "Which station ID did you wish to use? Options: ", station_ID_multiple_same_name)

      message(multiple_stations_same_name)
    } else {
      station_ID_dat <- check[station_name_doubles, ]
      station_ID_real <-station_ID_dat$Station.ID |> as.numeric()
      #return(station_ID)
    }
  }

  if(class(station_ID_real) != "numeric"){
    message("Please enter the station ID as a numeric")
  }
  if(class(year) != "numeric"){
    message("Please enter the year as a numeric")
  }
  if(class(month) != "numeric"){
    message("Please enter the month as a numeric")
  }
  if(any(month == c(1:12))){
  } else {
    message("Please enter the month as a number between 1 and 12")
  }


  #making sure the station exists...

  ID_check <- which(check$Station.ID == station_ID_real)
  dat_subset <- check[ID_check,]


  if(length(ID_check) < 1){
    station_id_does_not_exist <- paste("Station ID", station_ID_real, "does not exist.")
    message(station_id_does_not_exist)
  }
  if(length(ID_check) > 1){
    multiple_stations_same_ID <- paste("There are multiple stations with the Station ID", station_ID)
    message(multiple_stations_same_ID)
  }


  if(is.null(station_name)){
    if(is.null(station_ID_real)){
      message("Please enter either a station name or station ID")
    } else{
      station_name_real <- dat_subset$Name
    }
  }


  if(is.na(dat_subset$HLY.First.Year)){
    no_hourly_data <- paste(station_name_real, "has no hourly data.")
    message(no_hourly_data)
  }

  if(is.na(dat_subset$HLY.Last.Year)){
    if(is.na(dat_subset$HLY.First.Year)){
      message(no_hourly_data)
    } else{
      dat_subset$HLY.Last.Year <- 2025 # the last complete calandar year
    }
  }

  if(any(year == c(dat_subset$HLY.First.Year:dat_subset$HLY.Last.Year))){
  } else{
    no_hourly_data_for_year <- paste("Station", station_name_real, "has no hourly data from the year", year)
    return(no_hourly_data_for_year)
  }

  #getting the file path based on the function inputs
  file_path <- paste0("https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=",
                      station_ID,"&Year=", year, "&Month=", month, "&Day=14&timeframe=1&submit=Download+Data")



  if(temporary == TRUE){

    if(testing == TRUE){

      #message("Would hypothetically download ", file_path)
      return(paste("Would hypothetically download ", file_path))
    } else {

  temp <- tempfile(fileext = ".csv") #makes the temporary file

  download.file(file_path, destfile = temp, method = "auto")  # I have it as "method = auto" because I just couldn't get "method = wget" to work :(
  dat <- read.csv(temp)
  return(dat)}

  } else if(temporary == FALSE){

    if(testing == TRUE){

      #message("Would hypothetically download ", file_path)
      return(paste("Would hypothetically download ", file_path))
    } else{

    working_dir <- getwd()

    where_to_save <- paste0(working_dir, "/station_data", "/", station_name_real, "_", station_ID,  "/", station_name_real, "_", station_ID, "_", year, "_", month, ".csv")

    folder_path <- dirname(where_to_save)
    if (!dir.exists(folder_path)) {
      dir.create(folder_path, recursive = TRUE, showWarnings = FALSE)
    }

    download.file(file_path, destfile = where_to_save, method = "auto")
    }  # I have it as "method = auto" because I just couldn't get "method = wget" to work :(

  } else {
    stop("temporary must be set to TRUE or FALSE")
  }
  }
