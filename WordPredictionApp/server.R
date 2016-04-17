library(shiny)
require(data.table)
require(dplyr)


n1GramTable<-read.csv("Data/N1GramsKN.csv",colClasses = c("character","integer"))
n2GramTable<-read.csv("Data/N2GramsKN.csv",colClasses = c("character","character","integer"))
n3GramTable<-read.csv("Data/N3Grams.csv",colClasses = c("character","character","integer"))

head(n1GramTable)
head(n2GramTable)
head(n3GramTable)

source("Common.R")
Sys.sleep(1)

shinyServer(
    function(input,output,clientData,session){
        res <- reactive({
            r<-predictWord(n1GramTable,n2GramTable,n3GramTable,input$text,5)
            return(r)
        })

        output$dynInput = renderUI({
            textInput("text", label = "Enter some text")
        })
        
                
        output$recommendations = renderUI({
                selectInput('recs', 'Recommendations',choices=c(Choose='', res()), selectize=FALSE)
        })
        

        observe({ 
            updateTextInput(session, "text", value = paste0(input$text, appendBlank(input$text) ,input$recs))
        })
            
        output$output <- renderText({paste0(input$text, appendBlank(input$text), input$recs)})
    }
)
