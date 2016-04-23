#Function for Processing the files for the word predition app

#Common definitions
#Diretories
dir.root<-"data"
dir.train<-"train"
dir.test<-"test"
dir.ngrams<-"ngrams"
dir.download<-"download"
dir.testresults<-"testresults"


#Filenames
swiftkeyUri<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
profanityUri<-"https://raw.githubusercontent.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/master/en"

ngramFile.1    = "N1Grams.csv"
ngramFile.1S   = "N1GramsS.csv"
ngramFile.1F   = "N1GramsF.csv"
ngramFile.1KN  = "N1GramsKN.csv"
ngramFile.1KNS = "N1GramsKNS.csv"
ngramFile.2    = "N2Grams.csv"
ngramFile.2S   = "N2GramsS.csv"
ngramFile.2SC  = "N2GramsSC.csv"
ngramFile.2F   = "N2GramsF.csv"
ngramFile.2KN  = "N2GramsKN.csv"
ngramFile.2KNS = "N2GramsKNS.csv"
ngramFile.2KNSC= "N2GramsKNSC.csv"
ngramFile.3    = "N3Grams.csv"
ngramFile.3S   = "N3GramsS.csv"
ngramFile.3SC  = "N3GramsSC.csv"
ngramFile.3F   = "N3GramsF.csv"

ngramFileCollapse<-NULL
ngramFile1Test<-NULL
ngramFile2Test<-NULL
ngramFile3Test<-NULL

ngramFileCollapse[1]<-FALSE
ngramFile1Test[1]<-ngramFile.1S
ngramFile2Test[1]<-ngramFile.2S
ngramFile3Test[1]<-ngramFile.3S


ngramFileCollapse[2]<-FALSE
ngramFile1Test[2]<-ngramFile.1KNS
ngramFile2Test[2]<-ngramFile.2KNS
ngramFile3Test[2]<-ngramFile.3S

ngramFileCollapse[3]<-FALSE
ngramFile1Test[3]<-ngramFile.1F
ngramFile2Test[3]<-ngramFile.2F
ngramFile3Test[3]<-ngramFile.3

ngramFileCollapse[4]<-TRUE
ngramFile1Test[4]<-ngramFile.1KNS
ngramFile2Test[4]<-ngramFile.2KNSC
ngramFile3Test[4]<-ngramFile.3SC


#Sample sizes
library(numbers)
percentages<-sapply( 1:11, fibonacci)[2:11]
percentageTest <- 10

#Common funcitons
createDir <- function (d) {
  if(!file.exists(d)) {
    dir.create(d)
  }
}

makeFileName<- function(...) {
  dots<-list(...)
  paste0( "./",paste(sapply(dots, paste), collapse="/"))
  
}

downloadFiles<-function(swiftkeyUri, profanityUri) {
  createDir("./data")
  dateDownloaded<-as.POSIXlt(Sys.time()) # the current time in UTC
  if(!file.exists(".\\data\\Coursera-SwiftKey.zip")) {
    download.file(swiftkeyFile,destfile = ".\\data\\Coursera-SwiftKey.zip", method="auto", mode="wb")
  }else {
    fileinfo<-file.info(".\\data\\Coursera-SwiftKey.zip")
    dateDownloaded<-fileinfo$mtime
  }
  
  if(!file.exists(".\\data\\final")) {
    unzip(zipfile=".\\data\\Coursera-SwiftKey.zip", exdir=".\\data")
  }
  
  if(!file.exists(".\\data\\profanity_en.txt")) {
    download.file(profanityUri,destfile = ".\\data\\profanity_en.txt", method="auto", mode="w")
  }
}

readProfanity<-function(){
  con <- file(".\\data\\profanity_en.txt", "r") 
  p<-readLines(con) 
  close(con)
  p
}

#produce small files

makeSmall<-function(root,train,test,name,percentages,percentageTest){
  if(name == "en_US.news.txt" ) {
    readmode = "rb"
  } else if(name == "en_US.blogs.txt" ) {
    readmode = "r"
  }else{
    readmode = "r"
  }

  source<-makeFileName(root,"final/en_US",name)
  print(paste0("Reading ",source  ))
  
  con1<-file(source,readmode )
  t1<-readLines(con1)
  l1<-length(t1 )
  close(con1)

  #set aside test set
  print(paste0("Building Test set with" ))
  testDir<-makeFileName(root,test)
  createDir(testDir)    
  testFile<-makeFileName(root,test,name)
  
  l3<-l1-10000
  t3<-t1[l3:l1]
  con3<-file(testFile,"w")
  writeLines(t3,con3)
  close(con3)
  
  #Use remaining lines for train set
  t1<-t1[1:l3-1]

  set.seed(123)
  for(i in 1:length(percentages)){
    percentage<-percentages[i]
    print(paste0("Building training set with ", percentage, "%"  ))

    baseDir<-makeFileName(root,percentage)
    trainDir<-makeFileName(root,percentage,train)
    createDir(baseDir)    
    createDir(trainDir)    

    trainFile<-makeFileName(root,percentage,train,name)
    
    t2<-sample(t1,l1*percentage/100)
    con2<-file(trainFile,"w")
    writeLines(t2,con2)
    close(con2)
  }  
  print(paste0("Building training and test finished"  ))
  
  
}

require(data.table)
nGramTable <- function( nGramTokens) {
  nGramTable <- data.frame(table(nGramTokens))
  colnames(nGramTable) <- c("word", "freq")
  
  #nGramTable <-  nGramTable[order(nGramTable$freq,decreasing=TRUE),]
  nGramTable[,1]<-as.character(nGramTable[,1])
  nGramTable
}




