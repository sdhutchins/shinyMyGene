library(shiny)
library(shinythemes)
library(shinyjs)
library(magrittr)
library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(mygene)

getData <- function() {
  
  # read the data file
  gDat <- read.table(file.path("Data/final_gene_info.csv"), sep = ",",
                     header = TRUE, row.names = NULL, allowEscapes = FALSE)
  
  gDat
}

# Get the raw data
gDatRaw <- getData()


ui <- navbarPage(inverse = TRUE,
                 title = "Gene Info Viz",
                theme = shinytheme("sandstone"),
                
                # Create a tab panel for the MyGene Tool
                tabPanel("MyGene Tool",
                         verbatimTextOutput("citemygene")),
                tabPanel("MyGene Tool"),
  
                # Create a tab panel for the table view
                tabPanel("Gene Table View",
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
  ))
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
  
  output$citemygene <- renderText({ invisible("Adam Mark, Ryan Thompson, Cyrus Afrasiabi and Chunlei Wu (2014). mygene: Access MyGene.Info_ services. R package version 1.10.0.") })
  
}

  
shinyApp(ui = ui, server = server)