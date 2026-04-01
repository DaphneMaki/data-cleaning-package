#' Station Name and ID checker
#'
#' Function that makes sure that, when both the station name and ID are provided, the station and ID match.
#'
#' @param station_ID  the station ID
#' @param station_name the station name
#'
#' @return NULL if nothing is wrong and an error code when something has gone wrong.
#'
#'
matching_station_names_and_ids <- function(station_ID, station_name){

  load("data/station_meta_data.rda")


  check_station_exist <- Datacleaning:::does_the_station_exist(station_ID)

  if(length(check_station_exist) > 0){
    return(check_station_exist)
  }


  station_name_upper <- station_name |> toupper()
  station_name_nospaces_or_underscores <-  gsub(pattern = "[ /_]", "", station_name_upper)
  check_names <- gsub(pattern = "[ /_]", "", station_meta_data$Name)

  station_name_row <- which(check_names == station_name_nospaces_or_underscores)

  if(length(station_name_row) >= 0){
    no <- paste0("Station with station name ", station_name, " does not exist.")
    return(no)
  }


  dat <- station_meta_data[station_name_row, ]


  if((dat$Station.ID == station_ID) & (check_names[station_name_row] == station_name_nospaces_or_underscores)){
    return(NULL)
  } else {
    station_name_missmatch <- paste0("Station ", station_name, " is not associated with the station ID", station_ID, ".")
    return(station_name_missmatch)
  }


}
