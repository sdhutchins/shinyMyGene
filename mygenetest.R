library(mygene)

# Read in the data table
gData <- read.csv(file.path("Data/final_gene_info.csv"), sep = ",", stringsAsFactors=FALSE,
                    header = TRUE, row.names = NULL, allowEscapes = FALSE)

# Convert column to list
accessions <- as.data.frame(gData$RefSeqRNA.Accession)

# Create an objectfor the queryMany results. It's a dataframe.
results <- queryMany(accessions, scopes="accession", fields="entrezgene", species="human")


#FYI: This is eons simpler than Python.