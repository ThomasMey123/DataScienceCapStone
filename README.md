# DataScienceCapStone
This repository contains the Milestone report for the Datascience capstone project

## Folders Files and their purpose:

The following files are used/ should be used in the order they are listed here

- BuildTrainingAndTestSet.Rmd: Download and unzip files. Split into train and test set and build training set with an increasing percentage of the corpus (using fibonacci numbers for the percentages)
- BuildNGrams.Rmd: Perform preprocessing and build 1-3 Grams for the train data, this might be computational intensive
- BuildKNGrams.Rmd: Based on 1-3 Grams apply the Kneser-Ney smooting to unigrams and bigrams
- BuildShrinkedFiles2.Rmd: Shrink the N-gram tables to list only the first n endings of n gram, used to compact the ngrams. Creates the result as list or with endings in one line
- TestPredictionQuality.Rmd: Run a test set against some selections of ngrams and determine response time and model quality
- TestPredictWord.Rmd: Debugging utility for the prediction algorithm
- startApp.R: utility to start the shiny app

Other files:
- commonProcess.R: Include file with funcions and definitions
- WordPredictionApp/ui.R: Shiny UI
- WordPredictionApp/server.R: Shiny server
- WordPredictionApp/common.R: Common functions for processing and shiny app (including the prediction)
- shrinktable/: A C# source and executable to shrink the files (had problems with memory usage in R)
- WordPredictionAppFinalPresentation.Rpres: Presentation for the project
- backlog.xlsx: a work backlog for the project


