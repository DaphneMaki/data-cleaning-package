#' Interactive heatmap for visulising missing data
#'
#'Makes an interactive heatmap that shows where and which data point are missing. I for some reason could not get my checks to work, so just don't be an idiot and use the data from the database.
#'
#' @param dat a \code{data.frame} of Environment Canada data
#'
#' @return a shiny app that you can interact with to help compare missingness of data across stations.
#' @export
#'
#' @examples
#' missing_data_visualiser_heatmap(demo_data)
#'
missing_data_visualiser_heatmap <- function(dat){

  # all_col_names <- colnames(dat)
  #
  # station_ID_check <- "Station_Name" %in% all_col_names
  #
  # if(!station_ID_check){
  #   print("works")
  # } else{
  #   return(station_ID_check)
  # }



  dat2 <- dat |> dplyr::mutate(
    Station_Name_and_ID = paste(Station_Name, Climate_ID)
  )



  ui <- shiny::fluidPage(
    shiny::titlePanel("Missing Climate Data Viewer"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::selectInput("Station_Name_and_ID", "Select a Station:",
                    choices = unique(dat2$Station_Name_and_ID))
      ),
      shiny::mainPanel(
        shiny::plotOutput("missplot")
      )
    )
  )

  server <- function(input, output) {
    output$missplot <- shiny::renderPlot({
      dat_sub <- dat2 |>
        dplyr::filter(Station_Name_and_ID == input$Station_Name_and_ID) |>
        dplyr::select(-c("Station_Name", "Climate_ID", "Month" ,"Day", "Time_LST",
                  "Station_Name_and_ID"), -ends_with("lag"))

      naniar::gg_miss_fct(dat_sub, fct = Year) +
        ggplot2::xlim(min(dat2$Year), max(dat2$Year))
    })
  }

  shiny::shinyApp(ui, server)


}
