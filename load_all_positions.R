### are there players w/ points on multiple sheets?
setwd("~/projects/fantasyfootball/yahooHistoricData/")

rm(RBdat,WRdat,TEdat,QBdat)
seasons <- c(2010:2013)
RBdat <- read.csv(paste("ffdat","RB",seasons[1],".csv",sep="")) #fencepost
for (year in seasons[2:length(seasons)]){
  print(year)
  saveName <- paste("ffdat","RB",year,".csv",sep="")
  tempdat <- read.csv(saveName)
  RBdat <- rbind(RBdat,tempdat)
}


QBdat <- read.csv(paste("ffdat","QB",seasons[1],".csv",sep="")) #fencepost
for (year in seasons[2:length(seasons)]){
  print(year)
  saveName <- paste("ffdat","QB",year,".csv",sep="")
  tempdat <- read.csv(saveName)
  QBdat <- rbind(QBdat,tempdat)
}


WRdat <- read.csv(paste("ffdat","WR",seasons[1],".csv",sep="")) #fencepost
for (year in seasons[2:length(seasons)]){
  print(year)
  saveName <- paste("ffdat","WR",year,".csv",sep="")
  tempdat <- read.csv(saveName)
  WRdat <- rbind(WRdat,tempdat)
}


TEdat <- read.csv(paste("ffdat","TE",seasons[1],".csv",sep="")) #fencepost
for (year in seasons[2:length(seasons)]){
  print(year)
  saveName <- paste("ffdat","TE",year,".csv",sep="")
  tempdat <- read.csv(saveName)
  TEdat <- rbind(TEdat,tempdat)
}



intersect(QBdat$Name,RBdat$Name)
intersect(QBdat$Name,WRdat$Name)
intersect(WRdat$Name,RBdat$Name)
intersect(TEdat$Name,RBdat$Name)
intersect(TEdat$Name,WRdat$Name)
## maybe only Chris henry then?