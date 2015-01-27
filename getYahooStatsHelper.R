## fantasy helper functions


makeURL <- function(pos,sea,week){
  # use to generate urls for yahoo site
  return(paste("http://sports.yahoo.com/nfl/stats/byposition?pos=",pos,
        "&conference=NFL&year=season_",sea,"&timeframe=Week",week,sep=""))
}

library(XML)

scrapeYahooDF <- function(url){
  tables <- readHTMLTable(url)
  
  ## one of these has data. figure out which one. 
  names(tables) <- paste("tab",1:length(tables),sep="") #rename tables so not null
  n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))
  tab2get <- attr(n.rows[which.max(n.rows)],"names")
  newdf <- tables[[tab2get]]
  
  # some columns have empty white space. find them, then select only meaningful columns
  needtoKill <- NULL
  for(x in 1:length(newdf[1,])){
    if(newdf[1,x]== ""){
      needtoKill <- c(needtoKill,x)
    }   
  }
  newdf <- newdf[setdiff(1:length(newdf[1,]),needtoKill)]
  
  # sometimes first row of df is variable names, fix if needed
  if(any(unlist(lapply(newdf[1,],function(x)grepl("Name",x))))){  
    newnames <- NULL
    for(x in 1:length(newdf[1,])){
      newnames <- c(newnames,as.character(newdf[1,x]))
    }
    names(newdf)<- newnames
    #drop first row
    newdf <- newdf[2:dim(newdf)[1],]
  }
  return(newdf)
}

wk1df <- scrapeYahooDF(makeURL("RB",2011,1))
