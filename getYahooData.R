### script to scrape yahoo historic fantasy football data from static HTML

seasons <- c(2001:2013)
positions <- c("QB","RB","WR","TE")
setwd("~/projects/fantasyfootball/yahooHistoricData//")

for ( pos in positions){
  for (year in seasons){
    scrapeDF <- scrapeYahooDF(makeURL(pos,year,1))
    scrapeDF$position <- pos
    scrapeDF$year <- year
    scrapeDF$week <- 1
    for( w in 2:17){
      df <- scrapeYahooDF(makeURL(pos,year,w))
      df$position <- pos
      df$year <- year
      df$week <- w
      scrapeDF <- rbind(scrapeDF,df)  
    }
    saveName <- paste("ffdat",pos,year,".csv",sep="")
    write.csv(scrapeDF,saveName)
  }
}