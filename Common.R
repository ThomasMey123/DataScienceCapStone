---
title: "DataScienceCapstone"
author: "Thomas Mey"
date: "17.3.2016"
output: html_document
---



#Set processing options
```{r}
processing.size<-"small"
processing.percentage <- 0.5
processing.percentageTest <- processing.percentage /3


```

## Download and unzip files the file to folder 'data' using R and supply smaller versions
```{r echo=FALSE}
if(!file.exists("data")) {
     dir.create("data")
}

fileurl<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
dateDownloaded<-as.POSIXlt(Sys.time()) # the current time in UTC


if(!file.exists(".\\data\\Coursera-SwiftKey.zip")) {
    download.file(fileurl,destfile = ".\\data\\Coursera-SwiftKey.zip", method="auto", mode="wb")
}else {
    fileinfo<-file.info(".\\data\\Coursera-SwiftKey.zip")
    dateDownloaded<-fileinfo$mtime
}

if(!file.exists(".\\data\\final")) {
    unzip(zipfile=".\\data\\Coursera-SwiftKey.zip", exdir=".\\data")
}

if(!file.exists(".\\data\\small")) {
     dir.create(".\\data\\small")
     dir.create(".\\data\\small\\en_US")
}

if(!file.exists(".\\data\\test")) {
     dir.create(".\\data\\test")
     dir.create(".\\data\\test\\en_US")
}

directory<-paste0(".\\data\\", processing.size, "\\en_US")
nGramDirectory<-paste0(".\\data\\", processing.size, "\\NGrams")
if(!file.exists(nGramDirectory)) {
     dir.create(nGramDirectory)
}


fileurl<-"https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en"

if(!file.exists(".\\data\\profanity_en.txt")) {
   download.file(fileurl,destfile = ".\\data\\profanity_en.txt", method="auto", mode="w")
}
```


#produce small files
```{r}
makeSmall<-function(name,percentage,percentageTest){
    n1<-paste0(".\\data\\final\\en_US\\",name)
    n2<-paste0(".\\data\\small\\en_US\\",name)
    n3<-paste0(".\\data\\test\\en_US\\test_",name)
    

    l1<-0
    if(name == "en_US.news.txt" ) {
      readmode = "rb"
      l1<-1010242
    } else if(name == "en_US.blogs.txt" ) {
      readmode = "r"
      l1<-899288
    }else{
      l1<-2360148
      readmode = "r"
    }

    pt<-percentage+percentageTest
    if( pt < 50.0 ){
      linesToRead <- as.integer(pt / 100.0 *2 *l1)
    }
      
    con1<-file(n1,readmode )
    t1<-readLines(con1, n=linesToRead)
    close(con1)

    t2<-sample(t1,l1/100*percentage)
    con2<-file(n2,"w")
    writeLines(t2,con2)
    close(con2)

    t3<-sample(t1,l1/100*percentageTest)
    con3<-file(n3,"w")
    writeLines(t3,con3)
    close(con3)
}

set.seed(123)
makeSmall("en_US.twitter.txt",processing.percentage,processing.percentageTest)
makeSmall("en_US.blogs.txt",processing.percentage,processing.percentageTest)
makeSmall("en_US.news.txt",processing.percentage,processing.percentageTest)
```



## read profanity
```{r }
con <- file(".\\data\\profanity_en.txt", "r") 
p<-readLines(con) 
close(con)
``` 


## print summary statistics
```{r}
#Define functions for counting lines, character and words
lineCount<-function(x) {length(x$content)}
charCount<-function(x) {sum(nchar(x$content))}
wordCount<-function(x) {
    sum(sapply(gregexpr("([[:alpha:]])*", x$content), function(x) sum(x > 0)))
}
performCount<-function(d,f) {sapply(1:length(d),function(x){f(d[[x]])})}

#Function for summary as a table
docsSummary<-function(docs) {
  #get line, character and wordcounts
  l2<-performCount(docs,lineCount)
  c2<-performCount(docs,charCount)
  w2<-performCount(docs,wordCount)
  
  
  #Print table with line, character and word counts after cleansing
  rnames<-NULL
  for(i in 1:3){ rnames<-c(rnames,docs[[i]]$meta$id)}
  d<-data.frame(l2,w2,c2)
  rownames(d)<-rnames
  colnames(d)<-c("#Lines","#Words","#Characters")
  suppressWarnings( require(htmlTable))
  htmlTable(d)
}
```

#preprocess and build dtm
```{r}
preprocess<-function(docs,p) {
  msg<-Sys.setlocale("LC_ALL","English")
  
  #Remove URLS
  removeURL<-function(x) gsub("http[^[:space:]]*","",x)
  docs <- tm_map(docs, content_transformer(removeURL))   
  
  # Handle right single quotes
  # http://stackoverflow.com/questions/2477452/%C3%A2%E2%82%AC%E2%84%A2-showing-on-page-instead-of
  
  #replaceQuotes<-function(x) gsub("(\ue2\u80\u99\ub4\u92)", "'", x)
  replaceQuotes<-function(x) gsub("(\u92\ub4)", "'", x,perl=TRUE)
  
  docs <- tm_map(docs, content_transformer(replaceQuotes))
  #replaceQuotes2<-function(x) gsub("(\u02BC\u02C8\u0301\u05F3\u2032\uA78C\u02B9)", "'", x, perl = TRUE)
  #docs <- tm_map(docs, content_transformer(replaceQuotes2))
  
  #remove anything but english letters or space
  removeNumPunct<-function(x) gsub("[^A-Za-z']"," ",x)
  docs <- tm_map(docs, content_transformer(removeNumPunct))   

  #tolower
  docs <- tm_map(docs, content_transformer(tolower))

  #remove any character sequence where a character is repeated more than 4 times  
  removeRepeatedChars<-function(x) gsub("(.)\\1{3,}","",x)
  docs <- tm_map(docs, content_transformer(removeRepeatedChars))   

  #remove profanity 
  docs <- tm_map(docs, removeWords, p)
  

  #strip whitespace
  docs <- tm_map(docs, stripWhitespace) 
  docs
}

library(tm)   
docs <- Corpus(DirSource(directory))
docsSummary(docs)

docs<-preprocess(docs,p)

docs[[3]]$content[500]

corpus_df <- data.frame(text=lapply(docs[1], '[',"content"), stringsAsFactors=F)
corpus_df <- rbind(corpus_df,data.frame(text=lapply(docs[2], '[',"content"), stringsAsFactors=F))
corpus_df <- rbind(corpus_df,data.frame(text=lapply(docs[3], '[',"content"), stringsAsFactors=F))


corpus_df<-corpus_df$content
corpus_df[19]

corpus_df<-paste(corpus_df,collapse = "")

require(quanteda)

ng1<-tokenize(corpus_df, what="fastestword",concatenator = " ", ngrams=1)
ng2<-tokenize(corpus_df, what="fastestword",concatenator = " ", ngrams=2)
ng3<-tokenize(corpus_df, what="fastestword",concatenator = " ", ngrams=3)

require(data.table)
nGramTable <- function( nGramTokens) {
  nGramTable <- data.frame(table(nGramTokens))
  colnames(nGramTable) <- c("word", "freq")
  
  nGramTable <-  nGramTable[order(nGramTable$freq,decreasing=TRUE),]
 
  nGramTable
}


ngt1<-nGramTable(ng1)
rownames(ngt1)<-NULL
ngt1<-ngt1[ngt1$freq>1,]
head(ngt1)
tail(ngt1)
write.csv(ngt1,file= paste0(nGramDirectory,"\\N1Grams.csv"),row.names = FALSE)


ngt2<-nGramTable(ng2)
rownames(ngt2)<-NULL
ngt2<-ngt2[ngt2$freq>1,]
head(ngt2)
tail(ngt2)
write.csv(ngt2,file= paste0(nGramDirectory,"\\N2Grams.csv"),row.names = FALSE)

ngt3<-nGramTable(ng3)
rownames(ngt3)<-NULL
ngt3<-ngt3[ngt3$freq>1,]
head(ngt3)
tail(ngt3)
write.csv(ngt3,file= paste0(nGramDirectory,"\\N3Grams.csv"),row.names = FALSE)
```


```{r}
n1GramTable<-read.csv("./data/N1Grams.csv",colClasses = c("character","integer"))
n2GramTable<-read.csv("./data/N2Grams.csv",colClasses = c("character","integer"))
n3GramTable<-read.csv("./data/N3Grams.csv",colClasses = c("character","integer"))


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
    lapply(r, function(y) getTail(y,1))$word
}

predictWord("This is",3)
```


