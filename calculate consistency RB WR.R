## clean WR stats
names(WRdat)
names(WRdat) <- c("rowNum","Name","Team","Games","Rec","Tgts","RecYds","RecYdAvg","RecLong",
                  "RecTD","nKR","KRyds","KRavgYds","KRlong","KRTD",
                  "nPR","PRyds","PRavgYds","PRlong","PRTD",
                  "Fum","FumL","pos","year","week")

WRdat$points <- WRdat$RecYds*.1 + WRdat$RecTD*6 + WRdat$KRTD*6 + 
  WRdat$PRTD*6 - WRdat$FumL*2 

WRdat$EdraftWRConsistent <- WRdat$RecYds > 59.5 | WRdat$RecTD > 1 | WRdat$KRTD >1 | WRdat$PRTD > 1
consistent <- aggregate(EdraftWRConsistent~Name+year,WRdat,sum)
names(consistent) <- c("Name","year","n_EdraftWRConsistent")
WRdat <- merge(WRdat,consistent,sort=FALSE)

WRconst <- subset(consistent,n_EdraftWRConsistent>5)

ggplot(consistent,aes(x=n_EdraftWRConsistent))+geom_histogram()+facet_grid(~year)


library('reshape2')
# WRS_nconstant <- dcast(WRconst,formula = Name~year)
WRS_nconstant <- dcast(consistent,formula = Name~year)
names(WRS_nconstant)<- paste("n_60ydsORTD",names(WRS_nconstant),sep="_")
str(WRS_nconstant)
for(name in names(WRS_nconstant)){
  print(name)
  WRS_nconstant[is.na(WRS_nconstant[,name]),name] <- 0
}


View(subset(WRS_nconstant,n_60ydsORTD_2013>4))


names(RBdat) <- c("rowNum","Name","Team","Games","RushAtt","RushYds","RushYdAvg",
                  "RushLong","RushTD","Rec","Tgts","RecYds","RecYdAvg","RecLong",
                  "RecTD","Fum","FumL","pos","year","week")
RBdat$points <- RBdat$RushYds*.1 + RBdat$RushTD*6 + RBdat$RecYds*.1 +
  RBdat$RecTD*6 - RBdat$FumL*2



RBdat$EdraftRBConsistent <- RBdat$RushYds > 60 | RBdat$RushTD > 1
rbconsistent <- aggregate(EdraftRBConsistent~Name+year,RBdat,sum)
names(rbconsistent) <- c("Name","year","n_EdraftRBConsistent")

RBS_nconstant <- dcast(rbconsistent,formula = Name~year)
names(RBS_nconstant)<- paste("n_60ydsORTD",names(RBS_nconstant),sep="_")
str(RBS_nconstant)
for(name in names(RBS_nconstant)){
  print(name)
  RBS_nconstant[is.na(RBS_nconstant[,name]),name] <- 0
}

consistentAggs <- rbind(RBS_nconstant,WRS_nconstant)
uber <- merge(pickprosESPN,consistentAggs,by.x="Player",by.y="n_60ydsORTD_Name",all.x=T,all.y=F,sort=F)

View(subset(uber,n_60ydsORTD_2013>6 & n_60ydsORTD_2013>6))


##### 
CONSISTENT_CUTOFF <- 4
subsetdat <- subset(uber,n_60ydsORTD_2013>CONSISTENT_CUTOFF & n_60ydsORTD_2013>CONSISTENT_CUTOFF)
xtabs(~POS,subsetdat)
# write.csv(subsetdat,"~/projects/fantasyfootball/draft_2014/Consistent.csv")


summary(res4)
ggplot(subsetdat,aes(x=yahooADP,y=n_60ydsORTD_2013))+geom_point()
ggplot(subsetdat,aes(x=espnauction_residyahooADP,y=n_60ydsORTD_2013,label=Player))+geom_point()+
  geom_text(data=subset(subsetdat,espnauction_residyahooADP < 0 & n_60ydsORTD_2013 > 6 ))

### anything leftover yahoo variance. 
res4 <- lm(yahooADP~n_60ydsORTD_2013+n_60ydsORTD_2012+PAL_wk,subsetdat)
res5 <- lm(yahooADP~n_60ydsORTD_2013+n_60ydsORTD_2012+PAL_wk+PAA_wk,subsetdat)
anova(res4,res5)
summary(res4)
subsetdat$resid4 <- as.numeric(unlist(res4$residuals))
ggplot(subsetdat,aes(x=yahooADP,y=resid4,label=Player))+geom_point()
View(subsetdat[order(subsetdat$yahooADP),])
