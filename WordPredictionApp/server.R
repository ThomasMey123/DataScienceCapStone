library(shiny)
require(data.table)
require(dplyr)

nGramDirectory<-"Data"
ngt1<-read1GramTable(nGramDirectory,"Data/N1Grams.csv")
ngt2<-readNGramDataTable(nGramDirectory,"Data/N2Grams.csv")
ngt3<-readNGramDataTable(nGramDirectory,"Data/N3Grams.csv")

head(ngt1)
head(ngt2)
head(ngt2)

source("Common.R")
Sys.sleep(1)

shinyServer(
    function(input,output,clientData,session){
        res <- reactive({
            r<-predictWord(ngt1,ngt2,ngt3,input$text,6,TRUE)
            return(r)
        })

        observeEvent(input$recs,{
		    newtext<-paste0(input$text, appendBlank(input$text) ,input$recs)
            updateTextInput(session, "text", value = newtext)
			 output$output <- renderText({newtext}) 
        })
        
        observeEvent(input$text, {
            updateSelectInput(session, "recs", choices=c(Choose='', res()))
        })
    }
)
