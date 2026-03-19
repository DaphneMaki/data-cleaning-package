all_the_checks_slapped_into_one <- function(station_ID){

  missing_id <- Datacleaning:::miss_id(station_ID)

  exists <- Datacleaning::does_the_station_exist(station_ID)

  hourly_exists <- Datacleaning::does_have_hourly_data(station_ID)


  error_message <- NULL

  if(length(missing_id > 0)){
    error_message <- missing_id
  } else if(length(hourly_exists > 0)){
    error_message <- hourly_exists
  }

  return(error_message)
}
