#calculates time b/t two events by interview

calctime <- function(data , start = "SupervisorAssigned", finish = "InterviewerAssigned"){
    
    #Load configuration file
    config.df <- read.csv(file="configuration.csv",head=TRUE,sep=",")
    
    #make sure first column is properly named
    x <- data[1,1]
    if (nchar(as.character(x[[1]])) == 32){
      colnames(data)[1] <- "InterviewId"
    }
  
    # reformat time in data.frame
    data <- transform(data, DateTime = paste(data$Date,data$Time))
    x <- strptime(data$DateTime,format='%m/%d/%Y %H:%M:%S')
    data <- transform(data, DateTime = x)
  
    #Filter data for parameters
    calc.df <- data[data$Action == as.character(config.df[config.df$actions == start,2]) 
                  | data$Action == as.character(config.df[config.df$actions == finish,2]),]
  
  
    #generate interview vector
    interviews <- as.character(unique(calc.df$InterviewId))
  
    #generate index for loops
    index <- 1:length(interviews)
  
    #create empty vectors
    starttime <- c()
    finishtime <- c()
    differencetime <- c()
  
    # Populate start time
    for (i in index){
      start.df <- calc.df[calc.df$InterviewId == interviews[i] & 
                            calc.df$Action == start,]
      starttime <- append(starttime,as.character(start.df$DateTime[1]))
      
    }
  
    # Populate finish time
    for (i in index){
        finish.df <- calc.df[calc.df$InterviewId == interviews[i] & 
                                calc.df$Action == finish,]
        finishtime <- append(finishtime,as.character(finish.df$DateTime[1]))
        
    }
    
    #create master, and populate differencetime
    master <- as.data.frame(cbind(interviews, starttime, finishtime))
    source('R/converttime.R')
    master <- transform(master, differencetime = sapply(difftime(master$finishtime, master$starttime, 
                                                                 units = 'secs'),converttime))


master
}