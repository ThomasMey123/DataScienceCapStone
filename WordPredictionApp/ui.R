library(shiny)
shinyUI(fluidPage(
    titlePanel("Next Word Prediction App"),
    mainPanel(width=8,
        p("This application makes recommendations for the next word and allows you to select the next word form a dropdown."),
        p("Enter text and select a recommendation from the dropdown "),

        textInput("text", label = "Enter some text"),

        #submitButton("Apply"),

        htmlOutput("selectUI"),
        selectInput('recs', 'Recommendations',choices=c(Choose='', c("")), selectize=FALSE)
        
   ) 
))
