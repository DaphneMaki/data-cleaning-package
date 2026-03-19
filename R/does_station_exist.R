does_the_station_exist <- function(station_ID){

  load("data/station_meta_data.rda")

  ID_check <- which(station_meta_data$Station.ID == station_ID)
  dat_subset <- station_meta_data[ID_check,]


  if(length(ID_check) < 1){
    station_id_does_not_exist <- paste("Station ID", station_ID, "does not exist.")
    return(station_id_does_not_exist)
  }


}




