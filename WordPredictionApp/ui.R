library(shiny)
shinyUI(pageWithSidebar(
    titlePanel("Next Word Prediction App"),
    sidebarPanel( width=4,
        p("This application makes recommendation for the next word and allows you to select the next word")
    ),
    mainPanel(width=8,
        p("Enter text and select a recommendation from the dropdown "),

        #textInput("text", label = "Enter some text"),
        uiOutput("dynInput"),
        
        submitButton("Apply"),

        htmlOutput("selectUI"),
        #selectInput("select", label = "recommendations", choices=c(Choose='', state.name), selectize=FALSE), 
        uiOutput("recommendations"),
        hr(),
        h3("You entered"),
        verbatimTextOutput("output")
   ) 
))
