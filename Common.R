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
    lapply(r, function(y) getTail(y,1))
}

isBlank<-function(y) substr(y,nchar(y),nchar(y)) == " "
appendBlank<- function(x) ifelse(isBlank(x), ""," ")

