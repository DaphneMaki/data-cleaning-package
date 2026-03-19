#' Station ID finder
#'
#'This function will find your station ID based on the station name and will tell you if there are multiple stations that have the same name.
#'
#' @param station_name
#'
#' @return station_ID
#'
station_id_finder <- function(station_name){

  load("data/station_meta_data.rda")


  station_name_upper <- station_name |> toupper()
  station_name_nospaces_or_underscores <-  gsub(pattern = "[ /_]", "", station_name_upper)
  check_names <- gsub(pattern = "[ /_]", "", station_meta_data$Name)

  station_name_doubles <- which(check_names == station_name_nospaces_or_underscores)



  if(length(station_name_doubles) < 1){
    station_does_not_exist <- paste("Station", station_name, "does not exist.")
    return(station_does_not_exist)
    }

  if(length(station_name_doubles) > 1){
    station_ID_multiple_same_name_dat <- station_meta_data[station_name_doubles, ]
    station_ID_multiple_same_name <-paste(station_ID_multiple_same_name_dat$Station.ID, collapse = ", ")
    multiple_stations_same_name <- paste0("Several stations with the station name ", station_name, ". ",
                                          "Options: ", station_ID_multiple_same_name)
    return(multiple_stations_same_name)
    } else {

    station_ID_dat <- station_meta_data[station_name_doubles, ]
    return(station_ID_dat$Station.ID)


    #station_ID_real <-station_ID_dat$Station.ID #|> as.numeric() for some reason this shit doesn't work and just returns 123456789
    #return(station_ID)
    }


}

