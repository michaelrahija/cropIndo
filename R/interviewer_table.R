# interviewer_table: organize_interviews: outputs table with id, interviewer, supervisor, HQApproved, 
#         Timesrejected, Starttime, Endtime, and Duration  
library(stringr)

interviewer_table <- function(data){
    
    #organize dataframe for subsetting
    source("R/interview_table.R")
    interviewtable <- interview_table(data)
    interviewtable <- interviewtable[!is.na(interviewtable$Interviewer),] # remove NAs
    
    #Load configuration file
    config.df <- read.csv(file="configuration.csv",head=TRUE,sep=",")
    
    #convert Supervisor to character
    interviewtable$Supervisor <- as.character(interviewtable$Supervisor)
    
    
    #create Supervisor,Interviews, HQApproved, and Superapproved columns
    start = interviewtable %>%
                          group_by(Interviewer) %>%
                          summarize(
                            Supervisor = paste(unique(Supervisor),collapse = ","), #If there is > 1 Super, we collapse
                            Interviews = length(unique(id)),
                            HQApproved = sum(HQApproved),
                            SuperApproved = sum(SuperApproved))
    
    start$Supervisor = gsub("^,","",start$Supervisor)
    
    #################################################################
    ## SET WARNINGS: IF SOME INTERVIEWS HAVE > 1 INTERVIEWER, THEN  #
    ## TELL USER THOSE INTERVIEWS ARE EXCLUDED.                     #
    #################################################################
    #remove rows where > 1 interviewer
    test <- str_detect(start$Interviewer,pattern=",")  # T/F vector finding rows w/ > 1 Int
    morethanone <- sum(test)                      # # of rows w/ > 1 int
    
    #
    if(morethanone > 0){
      warning("Some interviews were assigned to > 1 interviewer. These interviews have been removed
              from mean and median time calculations")
      interviewers <- start$Interviewer[!test]
      
    }
      
    if(morethanone == 0){  
    interviewers <- unique(start$Interviewer)  
    }
    
    ##############################################################
    # TRIM INTERVIEW TABLE AND REMOVE INTERVIEWS THAT ARE EITHER #
    # NOT STARTED OR NOT FINISHED                                #
    ##############################################################
    interviewtable = interviewtable[!is.na(interviewtable$Starttime),]
    interviewtable = interviewtable[!is.na(interviewtable$Endtime),]
    
    #Populate averageinterviewtime and medianinterviewtime 
    index <- 1:length(interviewers)
    averageinterviewtime <- c()
    medianinterviewtime <- c()
    for (i in index){
      
      #subset interviewtabale for interviewer[i]
      duration.df <- interviewtable[interviewtable$Interviewer == interviewers[i],] ##sub 2 w/ i

      diffinseconds <- difftime(duration.df$Endtime,duration.df$Starttime, units = "secs")
      
      source('R/converttime.R')
      
      average <- converttime(mean(diffinseconds))
      median <- converttime(median(diffinseconds))
      
      
      averageinterviewtime <- append(averageinterviewtime, average)
      medianinterviewtime <- append(medianinterviewtime, median)   
      
    }
    
    master <- as.data.frame(cbind(start[!test,], 
              averageinterviewtime, medianinterviewtime)) ##HAVE TO FIGURE OUT THE NA'S IN THE TIMES FOR OPM DATA
master
}