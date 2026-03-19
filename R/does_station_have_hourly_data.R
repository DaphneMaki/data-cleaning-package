#' Does the station have hourly data
#'
#'This function checks if the imputed station ID has any hourly data. This function assumes that the station ID does indeed exist, as it is for use of me and only me, I did not idiot proof it, although maybe I should given that I am an idiot. So it turns out that I AM an idiot, so I added the check.
#'
#' @param station_ID the station ID
#'
#' @return \code{no_hourly_data} gives NULL when nothing is wrong, and an "error code" (read a string that will then be used as an error code in another function) when something is wrong.
#'


does_have_hourly_data <- function(station_ID){
  load("data/station_meta_data.rda")


  if(length(Datacleaning:::does_the_station_exist(station_ID)) > 0){
    return(Datacleaning:::does_the_station_exist(station_ID))

  }


  ID_check <- which(station_meta_data$Station.ID == station_ID)
  dat_subset <- station_meta_data[ID_check,]


  if(is.na(dat_subset$HLY.First.Year)){
    no_hourly_data <- paste("This station has no hourly data.")
    return(no_hourly_data)
  }



  }
