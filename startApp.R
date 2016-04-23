setwd("~/git-repos/DataScienceCapStone")
file.copy("data/55/NGrams/N1GramsKNS.csv", "WordPredictionApp/Data/N1Grams.csv",overwrite = TRUE)
file.copy("data/55/NGrams/N2GramsKNSC.csv", "WordPredictionApp/Data/N2Grams.csv",overwrite = TRUE)
file.copy("data/55/NGrams/N3GramsSC.csv", "WordPredictionApp/Data/N3Grams.csv",overwrite = TRUE)

library(shiny)
runApp("WordPredictionApp")
