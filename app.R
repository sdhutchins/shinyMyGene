library(shiny)
library(shinythemes)
library(shinyjs)
library(DT)

getData <- function() {
  
  # read the data file
  gDat <- read.table(file.path('Data/final_gene_info.csv'), sep = ",",
                     header = TRUE, row.names = NULL, allowEscapes = FALSE,
                     as.is = c(1,2,3,4,5,6,7))
  
  gDat
}

# Get the raw data
gDataRaw <- getData()



ui <- navbarPage(inverse = TRUE,
                 title = "Gene Info Viz",
                 theme = shinytheme("sandstone"),
                 
                 # Create a tab panel for the MyGene Tool
                 tabPanel("MyGene Tool",
                          tags$footer(verbatimTextOutput("citemygene"))),
                 tabPanel("MyGene Tool"),
                 
                 # Create a tab panel for the table view
                 tabPanel("Gene Table View",
                          fluidRow(
                            column(4,
                                   selectInput("t", "Gene Tier: ", c("All", unique(as.character(gDataRaw$Tier)))))),
                          fluidRow(
                            column(4,
                                   br(),
                                   downloadButton("downloadData", "Download table"),
                                   br(), br())),
                          
                          # Create a new row for the table.
                          fluidRow(
                            DT::dataTableOutput("table1")
                          ))
)

server <- function(input, output) {
  
  output$table1 <- DT::renderDataTable(DT::datatable({
    data <- gDataRaw
    if (input$t != "All") {
      data <- data[data$Tier == input$t,]
    }
    data
  },
  escape = FALSE,
  rownames = NULL,
  style = 'bootstrap'))
  
  # Download Button for the table
  output$downloadData = downloadHandler(paste('tier_', input$t, '_genes.csv', sep=''), content = function(file) {
    data <- gDataRaw
    if (input$t != "All") {
      data <- data[data$Tier == input$t,]
    }
    write.csv(data, file, sep = ",", row.names = FALSE)
  })
  
  output$citemygene <- renderText({ invisible("Adam Mark, Ryan Thompson, Cyrus Afrasiabi and Chunlei Wu (2014). mygene: Access MyGene.Info_ services. R package version 1.10.0.") })
  
}


shinyApp(ui = ui, server = server)