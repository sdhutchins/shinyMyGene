library(mygene)


# # Read in the data table
# data <- read.csv(file.path("Data/final_gene_info.csv"), sep = ",", stringsAsFactors=FALSE,
#                     header = TRUE, row.names = NULL, allowEscapes = FALSE)
# 
# # Convert column to list
# accessions <- as.data.frame(data$RefSeqRNA.Accession)
# 
# # Create an objectfor the queryMany results. It's a dataframe.
# results <- queryMany(accessions, scopes="accession", fields=c("entrezgene", "symbol", "name", "summary"), species="human")
# 

getresults <- reactive({
  queryMany(input$accession, scopes="accession", fields=c("entrezgene", "symbol", "name", "summary"), species="human")
})


#FYI: This is eons simpler than Python.