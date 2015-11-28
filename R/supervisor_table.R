#supervisor_table: outputs table with supervisor, interviewers, approved interviews
#         rejectedinterviews, averagetimetoassign
supervisor_table <- function(data){
  
    #organize dataframe for subsetting
    source("R/interview_table.R")
    interviewtable <- interview_table(data)
    interviewtable <- interviewtable[!is.na(interviewtable$Interviewer),] # remove NAs
  
    #Load configuration file
    config.df <- read.csv(file="configuration.csv",head=TRUE,sep=",")
  
    #convert Supervisor to character
    interviewtable$Supervisor <- as.character(interviewtable$Supervisor)
    
    
    ##create Supervisor, HQApp, and SuperApprov
    start = interviewtable %>%
      group_by(Supervisor) %>%
      summarize(
        Interviews = length(unique(id)),
        HQApproved = sum(HQApproved),
        SuperApproved = sum(SuperApproved))
    
    ##create Interviewers
    test <- str_detect(interviewtable$Interviewer,pattern=",") #find interviews w/ > 1 interviewer
    interv.temp <- interviewtable[!test,]                      #remove
    
    interviewers = interv.temp %>%
          group_by(Supervisor) %>%
          summarize(
            Interviewers = paste(unique(Interviewer),collapse = ","))
    
    master <- merge(start,interviewers)

master[,c(1,5,2,3,4)]    
######################################################################################
    
#     #Compute average time to ass for each supervisor
#     for (i in index){
#         
#         avgass.df <- master_avg[master_avg$supervisor_temp == supervisors[i],]  #subset for supervisor
# 
#         diffinseconds <- difftime(avgass.df$finishtime,avgass.df$starttime,   #compute diffinseconds
#                                   units = "secs")
#         
#         source('R/converttime.R')
#         average <- converttime(mean(diffinseconds))                             #compute avg
#         
#         avgtimetoassign <- append(avgtimetoassign, average)
#     }
#     master <- as.data.frame(cbind(master,avgtimetoassign))
# 
# master
}