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
                                              year, temporary = FALSE, testing = FALSE){
  if(!is.logical(testing)){
    stop("What are we even doing here? Either it's testing or not.")
  }

  if(is.logical(temporary) == FALSE){
    stop("Please set 'temporary' to TRUE or FALSE")
  }

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

  if(is.null(station_name) == FALSE & is.null(station_ID) == FALSE){

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
  station_ID_real <- station_ID2
  `%dopar%` <- foreach::`%dopar%`

  cl <- parallel::makeCluster(1) # I honestly don't think this is worth parallelise this, I say, after having written the code to paralaise it
  doParallel::registerDoParallel(cl)
  dat <- foreach::foreach(m = months,
                          .packages = "Datacleaning"
                          ) %dopar% {
                            Datacleaning::download_just_one_csv_with_checks(
                              station_ID = station_ID_real,
                              year = year_to_run,
                              month = m,
                              temporary = temporary,
                              testing = testing)}
  parallel::stopCluster(cl)
  dat2 <- do.call("rbind", dat)

  if(temporary == TRUE){
    return(dat2)
  }
  if(temporary == FALSE){

    working_dir <- getwd()

    station_name_real <- Datacleaning:::station_name_finder(station_ID = station_ID2)

    station_name_real_2 <- gsub(pattern = "[ ]", "_", station_name_real)

    where_saved <- paste0(working_dir, "/station_data", "/", station_name_real_2)

    where_saved_message <- paste0("12 Files save to the file path ", where_saved)

    if(testing == TRUE){
      return(dat2)
      message(where_saved_message)

    }else{
    message(where_saved_message)
      }
  }
}



