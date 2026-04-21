#' Station Helper
#'
#'This function helps you sort through the metadata to find the stations that fit a certain criteria. This function can help you find stations based on their Province, the years for which they have hourly data, and the starting letter(s) of the station name.
#'
#' @param province the province of interest
#' @param available_year the year of interest
#' @param starting_letter the starting letter that you are looking for
#'
#' @return A data frame that contains all of the stations that fit the inputted criteria. This \code{data.frame} contains the station name, station ID, province, and the first and last year of hourly data collection.
#' @export
#'
#' @examples
#' station_helper(province = "Ontario", available_year = 1999,starting_letter = "A")
#'
station_helper <- function(province, available_year, starting_letter){

  data("station_meta_data", package = "Datacleaning")

  dat <- station_meta_data |> dplyr::filter(HLY.First.Year > 1)

  if(missing(province) == FALSE){

    if(length(province) > 1){
      stop("Please enter only a singular province/territory.")
    }

    prov <- gsub(pattern = "[ /./_]", "", province) |> toupper()

    prov2 <- dplyr::case_when(
      prov == "AB" ~ "ALBERTA",
      prov == "BC" ~ "BRITISHCOLUMBIA",
      prov == "MB" ~ "MANITOBA",
      prov == "NB" ~ "NEWBRUNSWICK",
      prov == "NL" ~ "NEWFOUNDLAND",
      prov == "NS" ~ "NOVASCOTIA",
      prov == "ON" ~ "ONTARIO",
      prov == "PE" ~ "PRINCEEDWARDISLAND",
      prov == "QC" ~ "QUEBEC",
      prov == "SK" ~ "SASKATCHEWAN",
      prov == "NT" ~ "NORTHWESTTERRITORIES",
      prov == "NU" ~ "NUNAVUT",
      prov == "YT" ~ "YUKONTERRITORY",
      .default = prov
    )

    if(prov2 == "QUÉBEC"){
      message("I'm getting rid of your accent because it messes everything up, Frenchie.")
      prov2 <- "QUEBEC"
    }

    all_provinces <- gsub(pattern = "[ /./_]", "", unique(station_meta_data$Province))

    if((prov2 %in% all_provinces) == FALSE){
      stop("Please check that you have properly imputted your province/territory name")
    }

    province_in_dat <- gsub(pattern = "[ /./_]", "", station_meta_data$Province)

    province_rows <- which(province_in_dat == prov2)

    all_data_in_province <- station_meta_data[province_rows,]


    all_hourly_data <- all_data_in_province |>
      dplyr::filter(HLY.First.Year > 0) |>
      dplyr::select(Name, Province, Station.ID, HLY.First.Year, HLY.Last.Year)

    dat <- all_hourly_data
  }



###################################################################################################################

  if(missing(available_year) == FALSE){

    if(is.numeric(available_year) == FALSE){
      stop("Check that you're year is actually a year, also known as a number.")
    }
    if(length(available_year) > 1){
      stop("Please enter only a single year.")

    }

    hourly_dat_avalible <- dat |>
      dplyr::filter(HLY.First.Year > 0) |>
      dplyr::mutate(HLY.Last.Year = ifelse(is.na(HLY.Last.Year), HLY.First.Year, HLY.Last.Year))

    contains_available_year <- hourly_dat_avalible |>
      dplyr::mutate(avalible = available_year >= HLY.First.Year & available_year <= HLY.Last.Year) |>
      dplyr::filter(avalible == TRUE) |>
      dplyr::select(Name, Province, Station.ID, HLY.First.Year, HLY.Last.Year)

    dat <- contains_available_year
  }



#####################################################################################################################


  if(missing(starting_letter) == FALSE){
    if(is.character(starting_letter) == FALSE){
      stop("Please ensure that your starting letter is, in fact, a single or multiple letters, and not whatever it is that you put in.")
    }

  starting_letters <- dat |> dplyr:: filter(startsWith(Name, starting_letter))|>
    dplyr::select(Name, Province, Station.ID, HLY.First.Year, HLY.Last.Year)


  dat <- starting_letters

  }

  if(nrow(dat) < 1){
    message("No stations fit your criteria.")
  } else {
  return(dat)
  }

  }
