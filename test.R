path <- getwd()
setwd(path)

gDat <- read.table(file.path("Data/final_gene_info.csv"), sep = ",",
                   header = TRUE, row.names = NULL, allowEscapes = FALSE)

tier1 <- subset(gDat, Tier == 1)
tier2 <- subset(gDat, Tier == 2)
tier3 <- subset(gDat, Tier == 3)
notier <- subset(gDat, Tier == 0)