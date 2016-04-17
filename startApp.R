setwd("~/git-repos/DataScienceCapStone")
file.copy("data/small/NGrams/N1GramsKN.csv", "WordPredictionApp/Data",overwrite = TRUE)
file.copy("data/small/NGrams/N2GramsKN.csv", "WordPredictionApp/Data",overwrite = TRUE)
file.copy("data/small/NGrams/N3Grams.csv", "WordPredictionApp/Data",overwrite = TRUE)

library(shiny)
runApp("WordPredictionApp")
