#' Missing station ID checker
#'
#'This is a function that checks to make sure the user inserted a station ID because I really don't want to write this code a hundred times.
#'
#' @param station_ID the station ID
#'
#' @return missing_id
#'

miss_id <- function(station_ID = NULL){
  if(is.null(station_ID)){
    missing_id <- "Missing station ID"

    return(missing_id)
  }
}


