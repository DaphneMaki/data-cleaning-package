all_station_id_checks_slapped_into_one <- function(station_ID){

  missing_id <- Datacleaning:::miss_id(station_ID)

  hourly_exists <- Datacleaning:::does_have_hourly_data(station_ID)


  error_message <- NULL

  if(length(missing_id > 0)){
    error_message <- missing_id
  } else if(length(hourly_exists > 0)){
    error_message <- hourly_exists
  }

  if(is.numeric(station_ID) == FALSE){
    error_message <- "Station ID is not entered as a numeric."
  }


  return(error_message)
}
