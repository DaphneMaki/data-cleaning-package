#' Download All Station Data
#'
#'This function downloads all of the hourly station data across all avalible stations for every year that data is avalible.
#'
#' @param testing this determines if the url will actually be downloaded, or if we are just pretending for the sake of both my sanity and my computer. Defults to FALSE.
#' @param limit_for_testing_purposes because I want to show that it actually works, you can limit the number of stations that you want, and it will pick that many random stations to download in their entirety.
#' @param temporary this determines if the files are temporary or if they are saved to the computer. Defaults to FALSE.
#'
#' @return if \code{temporary} is set to TRUE, this (theoretically) returns a giant data frame of all of the hourly station data from all available years and all available stations. Or apparently as a list of \code{data.frame}s, which I'm not sure why it's doing that and am too tired to figure out. If \code{temporary} is set to FALSE, those files will be downloaded in subdirectories named after their associated station.
#' @export
#'
#' @examples
#' full_station_data <- download_all_station_data(limit_for_testing_purposes = 2, temporary = TRUE)
#' str(full_station_data)

download_all_station_data <- function(testing = FALSE, limit_for_testing_purposes, temporary = FALSE){

  if(!is.logical(testing)){
    stop("Please set testing to either TRUE or FALSE.")
  }
  if(!is.logical(temporary)){
    stop("Please enter if you wish for the files to be downloaded to your computer (set temporary to either TRUE or FALSE.)")
  }

  valid_stations <- station_meta_data |> dplyr::filter(HLY.First.Year > 1)

  if(missing(limit_for_testing_purposes)){
    limit_for_testing_purposes <- nrow(valid_stations)
  }



  if (utils::askYesNo("You are about to download a metric butload of files. Are you sure you want to do this?")) {
    if (utils::askYesNo("Are you 100% sure? This may take a few days just so you know. I haven't actually used it to download all the files so I'm not sure the exact amount of time")) {
      }
    } else {
    return(NULL)
    }


  `%dopar%` <- foreach::`%dopar%`

  stations_for_testing <- runif(limit_for_testing_purposes, 1, nrow(valid_stations))

  all_station_ID <- valid_stations$Station.ID[stations_for_testing]

  total_cores <- parallel::detectCores()

  cores_to_use <- round(((as.numeric(total_cores))/2), 0) -1 # this is just to ensure that there are some cores left

  cl <- parallel::makeCluster(cores_to_use)

  doParallel::registerDoParallel(cl)

  all_dat <- foreach::foreach(station_id = all_station_ID,
                              .packages = c("Datacleaning", "dplyr"),
                              .combine = dplyr::bind_rows
  ) %dopar% {
    Datacleaning::download_all_one_station(station_ID = station_id, testing = testing, temporary = temporary)}

  parallel::stopCluster(cl)
  return(all_dat)






}
