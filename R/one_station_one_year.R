#' csv downloader, one year, one station
#'
#' Function that downloads hourly data of one year from one station.
#'
#' @param station_name \code{station_name}; the station name
#' @param station_ID \code{station_ID}; the station ID
#' @param year \code{year}; the year
#'
#' @return dat \code{dat}; a list containing all the downloaded csv files
#' @export
#'

download_all_one_station_one_year <- function(station_name = NULL,
                                              station_ID = NULL,
                                              year){
  station_ID2 <- station_ID
  if(is.null(station_ID2)){
    station_ID2 <- Datacleaning:::station_id_finder(station_name = station_name)
  }

  if(is.character(station_ID2)){
    stop(station_ID2)
  }

  does_id_exist <- Datacleaning:::does_the_station_exist(station_ID2)

  if(is.null(does_id_exist) == FALSE){
    stop(does_id_exist)
  }

  if(is.null(station_name) == FALSE){

    id_name_match_check <- Datacleaning:::matching_station_names_and_ids(station_ID = station_ID2, station_name = station_name)

    if(is.null(id_name_match_check) == FALSE){
      stop(id_name_match_check)
    }
  }



  station_ID_checks <- Datacleaning:::all_station_id_checks_slapped_into_one(station_ID = station_ID2)

  if(is.null(station_ID_checks) == FALSE){
    stop(station_ID_checks)
  }



  months <- 1:12
  year_to_run <- year
  station_ID_real <- station_ID
  `%dopar%` <- foreach::`%dopar%`

  cl <- parallel::makeCluster(2)
  doParallel::registerDoParallel(cl)
  dat <- foreach::foreach(m = months,
                          .packages = "Datacleaning"
                          ) %dopar% {
                            Datacleaning::download_just_one_csv_with_checks(
                              station_ID = station_ID_real,
                              year = year_to_run,
                              month = m)}
  parallel::stopCluster(cl)
  dat2 <- do.call("rbind", dat)
  return(dat2)
}



