#' Full Station Data Downloader
#'
#' This function downloads all of the hourly data from a single station.
#'
#' @param station_name the station whose data you want downloaded. This is not necessary to have, but it is nice.
#' @param station_ID the station ID of the station whose data you want downloaded. If left empty, will be found using the station name.
#' @param testing this determines if the url will actually be downloaded, or if we are just pretending for the sake of both my sanity and my computer. Defaults to FALSE.
#' @param temporary this determines if the files are temporary or if they are saved to the computer. Defaults to FALSE.
#'
#' @return Creates a data frame of all of a single stations hourly data across all of the available years if \code{temporary} is set to TRUE, and saves one csv file per month for each available month to your computer if \code{temporary} is set to FALSE.
#' @export
#'
#' @examples
#' kenora_data <- download_all_one_station(station_ID = 3959, temporary = TRUE)
#' str(kenora_data)
#'
download_all_one_station <- function(station_name = NULL, station_ID = NULL, testing = FALSE, temporary = FALSE){

  if(!is.logical(testing)){
    stop("What are we even doing here. Either it's it's a test or it's not.")
  }

  if(!is.logical(temporary)){
    stop("Please set temporary to TRUE or FALSE")
  }

  station_ID_real <- station_ID


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


  if(is.null(station_ID)){
  check_name <- Datacleaning:::station_id_finder(station_name = station_name)
    if(is.numeric(check_name) == FALSE){
      stop(check_name)
    } else{
      station_ID_real <- check_name

      }

  }

  check_ID <- Datacleaning:::all_station_id_checks_slapped_into_one(station_ID = station_ID_real)

  if(is.null(check_ID) == FALSE){
    stop(check_ID)
  }



  station_name_real <- station_name


  load("data/station_meta_data.rda")

  `%dopar%` <- foreach::`%dopar%`

  station_meta <- station_meta_data |> dplyr::mutate(HLY.Last.Year = ifelse(HLY.Last.Year > HLY.First.Year, HLY.Last.Year, HLY.First.Year))

  years <- station_meta |>
    dplyr::filter(Station.ID == station_ID_real) |>
    dplyr::select(HLY.First.Year, HLY.Last.Year)

  all_year <- years$HLY.First.Year:years$HLY.Last.Year

  total_cores <- parallel::detectCores()

  cores_to_use <- round(((as.numeric(total_cores))/2), 0) -1 # this is just to ensure that there are some cores left

  cl <- parallel::makeCluster(cores_to_use)

  doParallel::registerDoParallel(cl)

  all_dat <- foreach::foreach(y = all_year,
                   .packages = c("Datacleaning", "dplyr"),
                   .combine = dplyr::bind_rows
  ) %dopar% {
    Datacleaning::download_all_one_station_one_year(station_ID = station_ID_real,
                                                    year = y,
                                                    testing = testing,
                                                    temporary = temporary)}

  parallel::stopCluster(cl)
  #all_dat2 <- do.call("rbind", all_dat)



  if(temporary == TRUE){
    return(all_dat)
  }
  if(temporary == FALSE){

    working_dir <- getwd()

    station_name_real <- Datacleaning:::station_name_finder(station_ID = station_ID2)

    station_name_real_2 <- gsub(pattern = "[ ]", "_", station_name_real)

    where_saved <- paste0(working_dir, "/station_data", "/", station_name_real_2)

    where_saved_message <- paste0("Files save to the file path ", where_saved)

    if(testing == TRUE){
      return(all_dat)
      message(where_saved_message)

    }else{
      message(where_saved_message)
    }
  }





}



