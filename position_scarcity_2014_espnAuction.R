require("ggplot2")
require("psych")
ff_ranks <- read.csv("~/Dropbox/randos/preseason_2014_fantasy.csv")
ff_ranks$position <- factor(gsub("\\d","",ff_ranks$Pos..Rank))
ff_ranks$Auction <- gsub("\\$","",ff_ranks$Auction)
ff_ranks$Auction <- gsub("--",0,ff_ranks$Auction)
ff_ranks$Auction <- as.numeric(ff_ranks$Auction)
ff_ranks$AuctionR <- max(ff_ranks$Auction) - ff_ranks$Auction
ff_ranks$Team <- factor(gsub(".*, ","",ff_ranks$Player))
ff_ranks$Player <- gsub("?,.*$","",ff_ranks$Player)


ff_ranks <- ff_ranks[!ff_ranks$position %in% c("DEF","K"),]

ggplot(ff_ranks,aes(x=Auction,color=position))+geom_histogram()+facet_grid(~position)
ggplot(ff_ranks,aes(x=Auction,color=position))+stat_ecdf()+facet_grid(~position)
describeBy(ff_ranks$Auction,ff_ranks$position)


ggplot(ff_ranks,aes(x=Auction))+stat_ecdf()
ggplot(ff_ranks,aes(x=AuctionR))+stat_ecdf() #reverse values

ggplot(ff_ranks,aes(x=Rank, y= Auction))+geom_line() #reverse values
ggplot(ff_ranks,aes(x=Rank, y= Auction,,color=position))+geom_line()+facet_grid(~position) #reverse values
ggplot(ff_ranks,aes(x=Rank, y= Auction,,color=position))+geom_line()+geom_point()+facet_grid(~position) #reverse values

ff_ranks_Old <- ff_ranks


ff_ranks <- read.csv("~/projects/fantasyfootball/draft_2014/espnRanks.csv")
ff_ranks$position <- factor(gsub("\\d","",ff_ranks$Pos..Rank))
ff_ranks$Auction <- gsub("\\$","",ff_ranks$Auction)
ff_ranks$Auction <- gsub("--",0,ff_ranks$Auction)
ff_ranks$Auction <- as.numeric(ff_ranks$Auction)
ff_ranks$AuctionR <- max(ff_ranks$Auction) - ff_ranks$Auction

ff_ranks <- ff_ranks[!ff_ranks$position %in% c("DEF","K"),]

