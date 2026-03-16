download_all_one_station <- function(station_name = NULL, station_ID = NULL){

  station_name_real <- station_name
  station_ID_real <- station_ID


  load("data/station_meta_data.rda")

  `%dopar%` <- foreach::`%dopar%`

  years <- station_meta_data |>
    dplyr::filter(Station.ID == station_ID_real) |>
    dplyr::select(HLY.First.Year, HLY.Last.Year)

  all_year <- years$HLY.First.Year:years$HLY.Last.Year

  total_cores <- parallel::detectCores()

  cores_to_use <- as.numeric(total_cores) - 4

  cl <- parallel::makeCluster(cores_to_use)

  doParallel::registerDoParallel(cl)

  all_dat <- foreach::foreach(y = all_year,
                   .packages = "Datacleaning"
  ) %dopar% {
    Datacleaning::download_all_one_station_one_year(station_ID = station_ID_real, year = y)}

  parallel::stopCluster(cl)
  return(all_dat)






}



