require(data.table)
require(dplyr)
require(tm)
require(hash)

debug.print<-FALSE

makeFileName<- function(...) {
    dots<-list(...)
    paste0( "./",paste(sapply(dots, paste), collapse="/"))
    
}

preprocess<-function(docs,p) {
    msg<-Sys.setlocale("LC_ALL","English")
    
    #Remove URLS
    removeURL<-function(x) gsub("http[^[:space:]]*","",x)
    docs <- tm_map(docs, content_transformer(removeURL))   
    
    # Handle right single quotes
    # http://stackoverflow.com/questions/2477452/%C3%A2%E2%82%AC%E2%84%A2-showing-on-page-instead-of
    
    #replaceQuotes<-function(x) gsub("(\ue2\u80\u99\ub4\u92)", "'", x)
    #replaceQuotes<-function(x) gsub("(\u92\ub4)", "'", x,perl=TRUE)
    #docs <- tm_map(docs, content_transformer(replaceQuotes))
    
    #replaceQuotes2<-function(x) gsub("(\u02BC\u02C8\u0301\u05F3\u2032\uA78C\u02B9)", "'", x, perl = TRUE)
    #docs <- tm_map(docs, content_transformer(replaceQuotes2))
    
    #remove anything but english letters or space
    removeNumPunct<-function(x) gsub("[^A-Za-z']"," ",x)
    docs <- tm_map(docs, content_transformer(removeNumPunct))   
    
    #tolower
    docs <- tm_map(docs, content_transformer(tolower))
    
    #remove any character sequence where a character is repeated more than 4 times  
    removeRepeatedChars<-function(x) gsub("([^ ])\\1{3,}","",x)
    docs <- tm_map(docs, content_transformer(removeRepeatedChars))   
    
    #remove profanity 
    if(!is.null(p)){
        docs <- tm_map(docs, removeWords, p)
    }
    
    
    #strip whitespace
    docs <- tm_map(docs, stripWhitespace) 
    docs
}

#get up the last three words
getTail <-function(x,nWords=3){
    if(is.null(x)) x<-""
    matches<-gregexpr("[[:alpha:](\'[:alpha:])?]+",x)
    m3<-tail(matches[[1]],n=nWords)
    res<-substr(x,m3[1],nchar(x))
    trimws(res)
}

makeNGramMatchRegex<-function(x){
    paste0("^",x," ")
}

read1GramTable<-function(dir,f) { 
    n1GramTable<-read.csv(makeFileName(dir,f), colClasses = c("character","integer"))
    n1GramTable
}

readNGramTable<-function(dir,f) { 
    nGramTable<-read.csv(makeFileName(dir,f), colClasses = c("character","character","integer"))
    nGramTable
}

readNGramDataTable<-function(dir,f) { 
    nGramTable<-data.frame(read.csv(makeFileName(dir,f), colClasses = c("character","character")))
    #colnames(nGramTable)<-c("key","value")
    dt<-data.table(nGramTable)
    dummy<-dt[t1=="a"]
    dt
}

collapsedMatches<-function(dt,x){
    y<-dt[t1==x]
    paste0(tstrsplit(y$t2," ",fixed=TRUE))
}



predictWord <-function(ngt1,ngt2,ngt3,test,n,collapsed=FALSE) {
    if(debug.print){
        print(paste0("Predicting for \'",test,"\'"))
    }
    
    d <- Corpus(VectorSource(test))
    d <- preprocess(d,NULL)    
    test<-d[[1]]$content[1]
    
    testNGram<-getTail(test)

    r<-NULL
    testNGram2<-getTail(testNGram,2)
    if( collapsed == FALSE)
    {
        f<-filter(ngt3, t1 == testNGram2)
        if(nrow(f)>0){
            r<-f[1:(min(nrow(f),n)),2]
        } 
    }
    else
    {
        r<-collapsedMatches(ngt3,testNGram2)    
    }
    
    
    if(length(r)<n) 
    {
        testNGram1<-getTail(testNGram,1)
        if( collapsed == FALSE)
        {    
            f<-filter(ngt2, t1 == testNGram1)
            
            if(nrow(f)>0){
                r<-c(r,f[1:min(nrow(f),n-length(r)),2])
            }
        }
        else
        {
            f<-collapsedMatches(ngt2,testNGram1)    
            r<-c(r,f)
        }
    }
    
    if(length(r)<n) 
    {
        r2<-ngt1[1:(n-length(r)),1]
        r<-c(r,r2)
    }
    r[1:min(length(r),n)]
}

isBlank<-function(y) substr(y,nchar(y),nchar(y)) == " "
appendBlank<- function(x) ifelse(isBlank(x) || nchar(x) == 0, ""," ")

