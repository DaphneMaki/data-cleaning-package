#' Name standardiser
#'
#'All this does is makes the names the same, no matter if they have weird spaces, characters, or brackets. Note that it does not account for differences in spaces or in capitalisation.
#'
#' @param dat the \code{data.frame} for which you want to pretty up the column names.
#'
#' @return Returns a \code{data.frame} with the nice column names.
#'


col_fixer <- function(dat){
  test_all_cols <- colnames(dat)
  new_col_names <- c()
  for(test_col_name in test_all_cols){
    test_col_name <- gsub(pattern = "[/(/)/°]", "", test_col_name)
    test_col_name2 <- gsub(pattern = "[/%]", "per_cent", test_col_name)
    test_col_name3 <- gsub(pattern = "[/.]", "_", test_col_name2)
    test_col_name4 <- gsub(pattern = "([[:punct:]])\\1+", "\\1", test_col_name3)
    test_col_name5 <- gsub(pattern = "_$", "", test_col_name4)
    new_col_names <- c(new_col_names, test_col_name5)
  }
  colnames(dat) <- new_col_names
  new_dat <- dat
  return(new_dat)
}
