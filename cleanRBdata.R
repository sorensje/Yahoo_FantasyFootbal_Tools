
setwd("/Users/Jim/projects/fantasyfootball/yahooHistoricData/")

seasons <- c(2011:2013)
RBdat <- read.csv("ffdatRB2001.csv") #fencepost
for (year in seasons){
  print(year)
  saveName <- paste("ffdat","RB",year,".csv",sep="")
  tempdat <- read.csv(saveName)
  RBdat <- rbind(RBdat,tempdat)
}


# View(RBdat[RBdat$year==2013,])
# sort(levels(RBdat$Name))
names(RBdat) <- c("rowNum","Name","Team","Games","RushAtt","RushYds","RushYdAvg",
                  "RushLong","RushTD","Rec","Tgts","RecYds","RecYdAvg","RecLong",
                  "RecTD","Fum","FumL","pos","year","week")
RBdat$points <- RBdat$RushYds*.1 + RBdat$RushTD*6 + RBdat$RecYds*.1 +
  RBdat$RecTD*6 - RBdat$FumL*2




