#' Interactive graphs for visulising missing data
#'
#'Makes an interactive barcoode looking graph that shows where and which data point are missing.Just like the other shiny app,  I for some reason could not get my checks to work, so just don't be an idiot and use the data from the database.
#'
#' @param dat a \code{data.frame} of Environment Canada data
#'
#' @return a shiny app that you can interact with to help compare missingness of data across stations.
#' @export
#'
#'
missing_data_visualiser_barcodes <- function(dat){

  dat2 <- dat |> dplyr::mutate(
    Station_Name_and_ID = paste(Station_Name, Climate_ID)
  )

ui2 <- shiny::fluidPage(
  shiny::titlePanel("Interactive Missing-Data Viewer"),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::selectInput(
        "station",
        "Choose Station:",
        choices = unique(dat2$Station_Name_and_ID) # gives the choices for all the stations
      ),
      shiny::selectInput(
        "year",
        "Choose Year:",
        choices = NULL   # gets filled later on based on the years that the station actually has any data
      )
    ),
    shiny::mainPanel(
      shiny::plotOutput("missplot")
    )
  )
)

server2 <- function(input, output, session) {

  # updating the year dropdown when the station selection changes so that we don't get an error message
  shiny::observeEvent(input$station, {
    available_years <- dat2 |>
      dplyr::filter(Station_Name_and_ID == input$station) |>
      dplyr::pull(Year) |>
      unique() |>
      sort()

    shiny::updateSelectInput(
      session,
      "year",
      choices = available_years,
      selected = available_years[1]
    )
  })

  output$missplot <- shiny::renderPlot({
    req(input$year)

    dat_sub <- dat2 |>
      dplyr::filter(
        Station_Name_and_ID == input$station,
        Year == input$year) |>
      dplyr::select(-c("Station_Name", "Climate_ID", "Month" ,"Day", "Time_LST",
                "Station_Name_and_ID", "Year"))


    naniar::vis_miss(dat_sub)
  })
}

shiny::shinyApp(ui2, server2)
}
