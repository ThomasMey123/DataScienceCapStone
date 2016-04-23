library(shiny)
shinyUI(fluidPage(
    titlePanel("Next Word Prediction App"),
    mainPanel(width=12,
        p("Enter some english text in the input field and select a recommendation from the recommendations dropdown."),

        textInput("text", label = "Input", width = "80%"),

        htmlOutput("selectUI"),
        selectInput('recs', 'Recommendations',choices=c(Choose='', c("")), selectize=FALSE),
		
        hr(),  
		h3("You entered"),  
        verbatimTextOutput("output")  
   ) 
))
