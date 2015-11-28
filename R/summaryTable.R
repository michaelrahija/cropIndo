# This function will tabulate the interview_table dataset, 
# and group interviews by teams

library(dplyr)

summaryTable <- function(x){

    
    #Add team column
    config <- read.csv("config/config_team.csv")
    
    temp.list <- x$Names
    teams <- c()
    
    for(i in 1:length(temp.list)){
      teams.temp <- as.character(config[temp.list[i] == config$name,2])
      teams <- append(teams,teams.temp)
    }
    
    x <- mutate(x,Team = teams)
  
    x <- x[,c(1,7,2,3,4,5,6)]
  
    #Create table for graph
    tab <- x %>%
              group_by(Team,Names) %>%
              summarize(Interviews = length(Interviewer))
    
    
#     tab <- tab %>%
#             group_by(Team) %>%
#             summarize(Total = sum(Interviews))
tab    
}