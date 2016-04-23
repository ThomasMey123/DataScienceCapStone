library(shiny)
shinyUI(fluidPage(
    titlePanel("Next Word Prediction App"),
    mainPanel(width=12,
        p("This application allows you to enter some text and allows you to select a recommendation for the next word form a dropdown."),
        p("Enter text and select a recommendation from the dropdown "),

        textInput("text", label = "Enter some text"),

        #submitButton("Apply"),

        htmlOutput("selectUI"),
        selectInput('recs', 'Recommendations',choices=c(Choose='', c("")), selectize=FALSE),
		
        hr(),  
		h3("You entered"),  
        verbatimTextOutput("output")  

        
   ) 
))
