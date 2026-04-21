#' SQLite Database maker
#'
#' @param file_path_to_csv_files the directory in which your csv files are stored
#' @param database_name the name you want to give your database. This should end in "sqlite".
#'
#' @return Makes an SQLite database on your computer in your working directory. In this database is the station metadata as well as all of the observations from the csv files provided.
#' @export
#'

make_database <- function(file_path_to_csv_files, database_name){


  if(grepl("[$.sqlite]", database_name) == FALSE){
    stop("Please enure that your database name ends in 'sqlite'. (It's just convention).")
  }

  if(file.exists(database_name)){
    stop("A file with this name already exists. If you wanr to apend an existing database, figure it out yourself. This function doesn't do that.")
  }

  if(missing(file_path_to_csv_files)){

    current_dir <- getwd()

    file_path_to_csv_files <- paste0(current_dir, "/station_data")
    warning(paste("Missing the file path to csv files, using defult of", file_path_to_csv_files))

  }

  if(!dir.exists(file.path(file_path_to_csv_files))){
    stop("That directory does not exist. Try Again.")
  }

  # shove all the station data into the database
  database <- DBI::dbConnect(RSQLite::SQLite(), database_name)

  DBI::dbExecute(database, string2) # makes the station table in the database

  DBI::dbAppendTable(database, "station", meta)


  # making the station table

  meta <- Datacleaning:::col_fixer(station_meta_data)|> dplyr::filter(HLY_First_Year > 1)

  string <- "CREATE TABLE station (" # we add the column names to this string because doing by hand would be a bitch

  for(i in 1:ncol(meta)){
    if(colnames(meta[i]) == "Climate_ID"){
      string <- paste0(string, colnames(meta[i]), " TEXT PRIMARY KEY, ")
    } else if(is.character(meta[,i])){
      string <- paste0(string, colnames(meta[i]), " TEXT, ") # the string we will put through dbEcecute
    } else if (is.numeric(meta[,i])){
      string <- paste0(string, colnames(meta[i]), " DECIMAL, ")
    } else if(is.integer(meta[,i])){
      string <- paste0(string, colnames(meta[i]), " INTEGER, ")
    }
  }

  string2 <- gsub(pattern = ", $", ")", string) # gets rid of the trailing comma



  # starting the observation table

  all_files <- list.files(path = file_path_to_csv_files, recursive = TRUE, full.names = TRUE,
                          pattern = ".csv$")

  random_csv <- Datacleaning:::reader_and_name_fixer(all_files[1])

  all_col_names <- colnames(random_csv)

  if(! "Precip_Amount_mm" %in% all_col_names){
    all_col_names <- c(all_col_names, "Precip_Amount_mm")
  }

  if(! "Precip_Amount_Flag" %in% all_col_names){
    all_col_names <- c(all_col_names, "Precip_Amount_Flag")
  }


  obs_string <- "CREATE TABLE observation ("

  #Just know that I hated every second of writing this out by hand

  should_be_num <- c("Longitude_x", "Latitude_y", "Year", "Month",
                     "Day", "Temp_C", "Dew_Point_Temp_C", "Rel_Hum_per_cent",
                     "Wind_Dir_10s_deg", "Wind_Spd_kmh", "Visibility_km",
                     "Stn_Press_kPa", "Precip_Amount_mm", "Wind_Chill", "Hmdx")



  should_be_character <- c("Station_Name", "Climate_ID", "Time_LST", "Flag",
                           "Temp_Flag", "Dew_Point_Temp_Flag", "Rel_Hum_Flag",
                           "Precip_Amount_Flag", "Wind_Dir_Flag", "Wind_Spd_Flag",
                           "Visibility_Flag","Stn_Press_Flag", "Hmdx_Flag",
                           "Wind_Chill_Flag",
                           "Weather")
  date_time <- "DateTime_LST"


  for(col_name in all_col_names){

    if(col_name %in% should_be_num){
      obs_string <- paste0(obs_string, col_name, " DECIMAL, ")
    } else if(col_name %in% should_be_character){
      obs_string <- paste0(obs_string, col_name, " TEXT, ")
    } else if(col_name %in% date_time){
      obs_string <- paste0(obs_string, col_name, " DATETIME, ")
    } else{
      stop("Look, I don't know what you did or how you did it, but this isn't going to work.")
    }
    }

  obs_string2 <- paste(obs_string, "PRIMARY KEY (Climate_ID, DateTime_LST),",
                       "FOREIGN KEY (Climate_ID) REFERENCES station(Climate_ID))")

  DBI::dbExecute(database, obs_string2) # makes the observation table in the database

  for(file_name in all_files){
    working_dat <- Datacleaning:::reader_and_name_fixer(file_name)
    DBI::dbAppendTable(database, "observation", working_dat)
  }

  DBI::dbDisconnect(database)


  message(paste0("Database ", database_name, " has been created in ", getwd(), "."))


}
