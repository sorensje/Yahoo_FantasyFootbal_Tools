# Yahoo_FantasyFootbal_Tools
tools for scraping fantasy football data from yahoo sources: static html and API


getYahooData is a script the uses the tools in getYahooStatsHelper to scrape player performance data from yahoo
- right now, script organizes data by creating .csvs for each position for each year.
* player data is pulled for each week of each season
- player data is historical extends back to 2000
- cleanRB data, loadAllposition, playingWithRBdata are examples of working with resulting data

getYahooStatsHelper
- uses makeURL to generate static URL locations of data
* generates URLs for given season/positon
* not robust, url system could change
- scrapeYahooDF retireves data from URL, cleans it up into orderly df

retrieve\_matchup\_data\_YahooAPI.R is an example of pulling data on the performance of a particular fantasy football league
right now, it is just set up to retrieve and organize the results of fantasy football matchups
- could be tweaked to do much more
- json that results from API calls is messy - munging could be improved, or maybe switch to PYthon to make use of beautiful soup?
