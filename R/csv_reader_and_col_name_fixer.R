#' csv reader and column name fixer
#'
#' All this does is read in your csv file and gets rid of special characters so that it's easier to work with and/or make an SQLite database out of. I use this a lot, so maybe it'll be helpful to you, user, because the way Environment Canada does thing make me frustrated.
#'
#' @param csv the csv that you want read in with nice column names
#'
#' @return your read in csv file with fixed names
#' @export
#'

reader_and_name_fixer <- function(csv){

  if(grepl("[$.csv]", csv) == FALSE){
    stop("Are you sure that's a csv file? This only works for csv files.")
    }

  test_dat <- read.csv(file = csv, check.names = FALSE) # first reading in the csv
  test_all_cols <- colnames(test_dat)
  new_col_names <- c()
  for(test_col_name in test_all_cols){
    test_col_name <- gsub(pattern = "[/(/)/°/.]", "", test_col_name)
    test_col_name2 <- gsub(pattern = "[/%]", "per_cent", test_col_name)
    test_col_name3 <- gsub(pattern = "[ ]", "_", test_col_name2)
    new_col_names <- c(new_col_names, test_col_name3)
  } # fixing all the column names
  colnames(test_dat) <- new_col_names # applying the fixed column names

  return(test_dat)
}
