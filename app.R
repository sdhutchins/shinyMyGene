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
  gData <- read.table(file.path("Data/final_gene_info.csv"), sep = ",",
                     header = TRUE, row.names = NULL, allowEscapes = FALSE)
  
  gData
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
                                  selectInput("Tier", "Choose Tier", choices = c("All", "1", "2", "3", "0"), selected = "1"))),
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
  
  tiers <- reactive({
    t <- subset(gDataRaw, Tier == input$Tier)
    return(t)
  })
  output$table1 <- DT::renderDataTable(DT::datatable({tiers()
  },
  escape = FALSE,
  rownames = NULL,
  style = 'bootstrap'))

  output$downloadData = downloadHandler(filename = function() { paste('tier', input$Tier, 'genes.csv', sep='') }, 
                                        content = function(file) {write.csv(tiers(), file, sep = ",", row.names = FALSE)})
  
  output$citemygene <- renderText({ invisible("Adam Mark, Ryan Thompson, Cyrus Afrasiabi and Chunlei Wu (2014). mygene: Access MyGene.Info_ services. R package version 1.10.0.") })
  
}

  
shinyApp(ui = ui, server = server)