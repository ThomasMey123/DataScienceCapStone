library(shiny)

print(getwd())
#setwd("C:/Dev/Repos/10-DataScienceCapStone/WordPredictionApp")
#setwd("C:\\Dev\\Repos\\10-DataScienceCapStone\\WordPredictionApp")

n1GramTable<-read.csv("./data/N1Grams.csv",colClasses = c("character","character","integer"))
n2GramTable<-read.csv("./data/N2Grams.csv",colClasses = c("character","character","integer"))
n3GramTable<-read.csv("./data/N3Grams.csv",colClasses = c("character","character","integer"))


n1GramTable<-n1GramTable[n1GramTable$freq>1,]
n2GramTable<-n2GramTable[n2GramTable$freq>1,]
n3GramTable<-n3GramTable[n3GramTable$freq>1,]

head(n1GramTable)
head(n2GramTable)
head(n3GramTable)

#get up the last three words
getTail <-function(x,nWords=3){
    matches<-gregexpr("[[:alpha:](\'[:alpha:])?]+",x)
    tail(matches[[1]],n=nWords)
    m3<-tail(matches[[1]],n=nWords)
    res<-substr(x,m3[1],nchar(x))
    trimws(res)
}

makeNGramMatchRegex<-function(x){
    paste0("^",x," ")
}


predictWord <-function(test,n) {
    print(paste0("Predicting for \'",test,"\'"))
    testNGram<-getTail(test)
    
    testNGram<-makeNGramMatchRegex(testNGram)
    
    
    testNGram2<-getTail(testNGram,2)
    testNGram2<-makeNGramMatchRegex(testNGram2)
    f<-grep(testNGram2,n3GramTable$word)
    r<-NULL
    
    if(length(f)>0){
        r<-n3GramTable[f[1:3],]
    } else {
        testNGram1<-getTail(testNGram,1)
        testNGram1<-makeNGramMatchRegex(testNGram1)
        f<-grep(testNGram1,n2GramTable$word)
        
        if(length(f)>0){
            r<-n2GramTable[f[1:3],]
        } else{
            r<-n1GramTable[1:3,]
        }
    }
    r
}


shinyServer(
    function(input,output){
        #output$output <- renderText({paste0(input$text, input$select)})
        
        res <- reactive({
            r<-predictWord(input$text,5)
            return(r$word)
        })

        output$dynInput = renderUI({
            textInput("text", label = "Enter some text")
        })
        
                
        output$recommendations = renderUI({
                selectInput('recs', 'Recommendations',choices=c(Choose='', res()), selectize=FALSE)
        })
        
        output$output <- renderText({paste0(input$text, input$recs)})
    }
)
