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

download_all_one_station_one_year <- function(station_name = NULL, station_ID = NULL, year){

  months <- 1:12
  year_to_run <- year
  station_ID_real <- station_ID
  `%dopar%` <- foreach::`%dopar%`

  cl <- parallel::makeCluster(3)
  doParallel::registerDoParallel(cl)
  dat <- foreach::foreach(m = months,
                          .packages = "Datacleaning"
                          ) %dopar% {
                            Datacleaning::download_just_one_csv_with_checks(
                              station_ID = station_ID_real,
                              year = year_to_run,
                              month = m)}
  parallel::stopCluster(cl)
  return(dat)
}



