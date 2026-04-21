#' Station Name Finder
#'
#'That's it. That's all it does. It finds your station name based on the station ID.
#'
#' @param station_ID
#'
#' @return Give you the station name associated with the entered station ID.
#'
#'
#' @examples
#' station_name_finder(1234)
#'
station_name_finder <- function(station_ID){

  exist <- Datacleaning:::does_the_station_exist(station_ID = station_ID)

  if(is.null(exist) == FALSE){
    stop(exist)
  }

  load("data/station_meta_data.rda")

  station_name <- station_meta_data[which(station_meta_data$Station.ID == station_ID),1]

  return(station_name)

}
