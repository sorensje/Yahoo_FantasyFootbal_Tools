
### play with stats, run "cleanRBdata.R" first.

library('ggplot2')

RBdat$EdraftRBConsistent <- RBdat$RushYds > 99.5 | RBdat$RushTD > 1
consistent <- aggregate(EdraftRBConsistent~Name+year,RBdat,sum)
names(consistent) <- c("Name","year","n_EdraftRBConsistent")
RBdat <- merge(RBdat,consistent,sort=FALSE)


consistent <- aggregate(Games~Name+year,RBdat,sum)
names(consistent) <- c("Name","year","tot_Games")
RBdat <- merge(RBdat,consistent,sort=FALSE)

RBdat$consistPCT <- RBdat$n_EdraftRBConsistent/RBdat$tot_Games

#rleation btwn rank and consistency
consistent <- aggregate(EdraftRBConsistent~Name+year + Rank + tot_Games,RBdat,sum)
consistent$consistPCT <- consistent$EdraftRBConsistent/consistent$tot_Games

ggplot(consistent,aes(x=Rank,y=EdraftRBConsistent))+geom_point()+geom_smooth(method="lm")
ggplot(consistent,aes(x=Rank,y=EdraftRBConsistent))+geom_point()+geom_smooth(method="lm") + 
  facet_grid(~year)

ggplot(consistent,aes(x=Rank,y=consistPCT))+geom_point()+geom_smooth(method="lm") + 
  facet_grid(~year)



ggplot(consistent,aes(x=year,y=consistPCT,color=Name))+geom_point()+geom_line()
ggplot(consistent,aes(x=year,y=consistPCT))+geom_point()+geom_smooth(method='lm')

### find out if player ever ranked top 50
toprank <- aggregate(Rank~Name,RBdat,min)
toprank$istop50 <- toprank$Rank < 51
consistent <- merge(consistent,toprank[,c("Name","istop50"),])
ggplot(consistent,aes(x=year,y=consistPCT,color=Name))+geom_point()+geom_line()+facet_grid(~istop50)


library("lme4")
r1 <- lmer(EdraftRBConsistent~Rank+(1|Name),consistent)
summary(r1)

r1 <- lmer(EdraftRBConsistent~Rank+(1|Name) + ,consistent)
summary(r1)



### let's flatten this. Does consistency one year to the next matter?
library('reshape2')
consistent <- aggregate(EdraftRBConsistent~Name+year + Rank,RBdat,sum)
consM <- melt(consistent,id.vars=c("Name","year"),measure.vars = c("EdraftRBConsistent"))
consM <- melt(consistent,id.vars=c("Name","year"),measure.vars = c("Rank"))

rankYears <- dcast(consM,formula = Name~year,sum)
names(rankYears) <- c("Name",paste("Rank_",2008:2013,sep=""))

consYears <- dcast(consM,formula = Name~year,sum)
names(consYears) <- c("Name",paste("cons_",2008:2013,sep="")
                      
                      
  rankCons <- merge(rankYears,consYears)
  
  
  #### let's do between year tracking...
  # for instance, find players who increased number of consistent games
  
  
  
  ### first what does it mean to be consistent? is this special?
  
  RBdat$EdraftRBConsistent <- RBdat$RushYds > 60 | RBdat$RushTD > 1
  consistent <- aggregate(EdraftRBConsistent~Name+year,RBdat,sum)
  names(consistent) <- c("Name","year","n_EdraftRBConsistent")
  
  ggplot(consistent,aes(x=EdraftRBConsistent))+geom_histogram()+facet_grid(~year)
  ggplot(consistent,aes(x=consistPCT))+geom_histogram()+facet_grid(~year)
  
  
  consistent[consistent$EdraftRBConsistent>6, ]
  
  ## find first consistent year
  firstConsyear <- aggregate(year~Name,consistent[consistent$EdraftRBConsistent>3, ],min)
  names(firstConsyear) <- c("Name","firstConsyear")
  consistent <- merge(consistent,firstConsyear)
  lastConsyear <- aggregate(year~Name,consistent[consistent$EdraftRBConsistent>3, ],max)
  names(lastConsyear) <- c("Name","lastConsyear")
  consistent <- merge(consistent,lastConsyear)
  nConsyear <- aggregate(year~Name,consistent[consistent$EdraftRBConsistent>3, ],length)
  names(nConsyear) <- c("Name","nConsyear")
  consistent <- merge(consistent,nConsyear)