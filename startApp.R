setwd("~/git-repos/DataScienceCapStone")
file.copy("data/small/NGrams/N1GramsKN.csv", "WordPredictionApp/Data",overwrite = TRUE)
file.copy("data/small/NGrams/shrunk_N2GramsKN.csv", "WordPredictionApp/Data/N2GramsKN.csv",overwrite = TRUE)
file.copy("data/small/NGrams/shrunk_N3Grams.csv", "WordPredictionApp/Data/N3Grams.csv",overwrite = TRUE)

library(shiny)
runApp("WordPredictionApp")
