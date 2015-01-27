library('XML')
library('jsonlite')

###
n.weeks <- 12



## get game key
ff.url <- "http://fantasysports.yahooapis.com/fantasy/v2/game/nfl?format=json"
game.key.json <- GET(ff.url, config(token = token))
game.key.list <- fromJSON(as.character(game.key.json))
game.key <- game.key.list$fantasy_content$game$game_key 


# setup league id
league.id <- scan("~/projects/fantasyfootball/gunson2014key.txt",what = 'character')
league.key <- paste0(game.key, ".l.", league.id)
league.url <- "http://fantasysports.yahooapis.com/fantasy/v2/league/"

## organize team (meta)data
league.teams <- GET(paste0(league.url,league.key, "/teams?format=json"), 
                          config(token = token))
teams.return <- fromJSON(as.character(league.teams))
n.teams <- teams.return$fantasy_content$league$num_teams[1]
str(teams.return$fantasy_content$league$teams)
teams.obj <- teams.return$fantasy_content$league$teams

team.names <- NULL
team.ids <- NULL
team.managers <- NULL
for(t in 1:(dim(teams.obj)[2]-1)){ # -1 b/c last is null (0 based)
  unlisted.info <- unlist(teams.obj[2,t])
  print(unlisted.info['team.name'])
  team.managers <- c(team.managers,unlisted.info['team.managers.manager.nickname'])
  team.names <- c(team.names,unlisted.info['team.name'])
  team.ids <- c(team.ids,unlisted.info['team.team_id'])
}

team.info.df <- data.frame(names = team.names, ids = team.ids, manager = team.managers)

### weekly score data

score.df <- data.frame(team.id = rep(team.info.df$ids,n.weeks),manager= rep(team.info.df$manager,n.weeks),
                       week = rep(1:n.weeks,each=n.teams))
#new vars
score.df$opponent.id <- 0
score.df$opponent.score<- 0
score.df$opponent.projection<- 0
score.df$own.score <- 0
score.df$own.projection<- 0
score.df$yahoo.win <- NULL

### team data ?
for(own.id in 1:n.teams){
#   own.id <- 4
#   own.id <- "4"
  my.team.key <- paste0(league.key, ".t.", own.id)
  team.url <- "http://fantasysports.yahooapis.com/fantasy/v2/team/"
  my.team.matchups.json <- GET(paste0(team.url, my.team.key, 
                                      "/matchups?format=json"), config(token = token))
  
  jsonlite.matchup.list <- fromJSON(as.character(my.team.matchups.json))
  matchup.obj <- jsonlite.matchup.list$fantasy_content$team[[2]]$matchups #retrieve smaller piece of data
  names(matchup.obj)<- paste0("matchup.",names(matchup.obj)) #rename so can reference programatically
  
  for(m in setdiff(names(matchup.obj),"matchup.count")){ #don't want last 'count' member of list, it's a NULL
    #fetch info about each weeks matchup
  #   m = "matchup.0"
    the.week <- matchup.obj[[m]]$matchup$week
    if( the.week > n.weeks) break #don't want to get data for ongoing or future events
    print(the.week)
    
    #get data
    did.win <- matchup.obj[[m]]$matchup$winner_team_key == my.team.key
    own.score <- matchup.obj[[m]]$matchup$`0`$teams$`0`$team[[2]]$team_points$total
    own.projection <- matchup.obj[[m]]$matchup$`0`$teams$`0`$team[[2]]$team_projected_points$total
    opponent.id <- matchup.obj[[m]]$matchup$`0`$teams$`1`$team[[1]][[2]]$team_id
    opponent.score <- matchup.obj[[m]]$matchup$`0`$teams$`1`$team[[2]]$team_points$total
    opponent.projection <- matchup.obj[[m]]$matchup$`0`$teams$`0`$team[[2]]$team_projected_points$total
    
    # update df
    score.df[score.df$team.id == own.id & score.df$week == the.week,'own.score'] <- own.score
    score.df[score.df$team.id == own.id & score.df$week == the.week,'own.projection'] <- own.projection
    score.df[score.df$team.id == own.id & score.df$week == the.week,'yahoo.win'] <- did.win
    score.df[score.df$team.id == own.id & score.df$week == the.week,'opponent.id'] <- opponent.id
    score.df[score.df$team.id == own.id & score.df$week == the.week,'opponent.score'] <- opponent.score
    score.df[score.df$team.id == own.id & score.df$week == the.week,'opponent.projection'] <- opponent.projection 
  }
}

### NEW SIMULATIONS

# I think we need to do this by making new schedules.

write.csv(score.df,"~/projects/fantasyfootball/fantasyresults2014_thruwk12.csv")
