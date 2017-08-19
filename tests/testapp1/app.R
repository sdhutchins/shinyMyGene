library(shiny)
library(mygene)
library(DT)
library(shinyjs)
library(shinythemes)

ui <- 
  navbarPage(inverse = TRUE,
             title = "Gene Info Viz",
             theme = shinytheme("sandstone"),
             tabPanel("MyGene Tool",
                      tags$footer(verbatimTextOutput("citemygene")),
                      sidebarLayout(
                        sidebarPanel(textInput("accession", "Human Accession #", value="NM_000680.3"),
                                     width = 2),
                        mainPanel(dataTableOutput('mygene_table'),
                                  width = 10)
  )
  ))

server <- function(input, output) {

  mygene_results <- reactive({
    queryMany(input$accession, scopes="accession", fields=c("entrezgene", "symbol", "name", "summary"), species="human")
  })
  
  output$citemygene <- renderText({ invisible("Adam Mark, Ryan Thompson, Cyrus Afrasiabi and Chunlei Wu (2014). mygene: Access MyGene.Info_ services. R package version 1.10.0.") })
  
  
  output$mygene_table <- renderDataTable({as.data.frame(mygene_results())})
}

shinyApp(ui, server)