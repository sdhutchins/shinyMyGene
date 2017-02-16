library(shiny)
library(shinythemes)
library(shinyjs)
library(magrittr)
library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)

getData <- function() {
  
  # read the data file
  gDat <- read.table(file.path("Data/final_gene_info.csv"), sep = ",",
                     header = TRUE, row.names = NULL, allowEscapes = FALSE)
  
  gDat
}

getPlotCols <- function() {
  g3 <- c("dodgerblue2", # red
          "green4",
          "#6A3D9A") # purple
  g3
}

# Get the raw data
gDatRaw <- getData()

# Get the list of colours to use for plotting
plotCols <- getPlotCols()

ui <- fluidPage(inverse = TRUE,
                theme = shinytheme("sandstone"),
                tags$head(
                  tags$link(rel = "icon", href = "favicon-96x96.png")),
  titlePanel("Gene Info Viz"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("t",
                       "Tier:",
                       c("All",
                         unique(as.character(gDatRaw$Tier)))))),
  fluidRow(
    column(4,
           selectInput("name",
                       "Gene Name:",
                       c("All",
                         unique(as.character(gDatRaw$Gene.Symbol)))))),
  fluidRow(
    column(4,
           br(),
           downloadButton("downloadData", "Download table"),
           br(), br())),
  
  # Create a new row for the table.
  fluidRow(
    DT::dataTableOutput("table")
  )
)

server <- function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- gDatRaw
    if (input$t != "All") {
      data <- data[data$Tier == input$t,]
    }
    if (input$name != "All") {
      data <- data[data$Gene.Symbol == input$name,]
    }
    data
  },
  escape = FALSE,
  rownames = NULL,
  style = 'bootstrap'))
  
  output$downloadData = downloadHandler('genedata.csv', content = function(file) {
    s = input$table_rows_selected
    write.csv(gDatRaw[s,], file, sep = ",", row.names = FALSE)
  })
  
}

  
shinyApp(ui = ui, server = server)