#This function returns a data frame that have lat, long, and data set for each interviwe
library(dplyr)
library(tidyr)

getGeoPoints <- function(df){
  
  ######################
  # VILLAGE           ##
  ######################
  files = list.files(path = paste0(mdir,"Metadata_reporting/data/"), pattern = "villv")
  
  
  data.list <- list()
  
  #Accumulate village data in a list
  for (i in 1:length(files)){
    data.temp <- read.delim(paste0(mdir,"Metadata_reporting/data/",files[i]), header = TRUE,
                            stringsAsFactors = FALSE)
    colnames(data.temp)[1] <- "Id"
    data.temp <- select(data.temp, Id, sid_name, sid_gps)
    data.list[[i]] <- data.temp 
  }
  
  data.v <- do.call("rbind", data.list)
  
  
  #keep only unique rows, and add dataset column
  data.v <- unique(data.v)
  
  source("R/filterDataset.R")
  data.v <- filterDataset(df = data.v, dataset = "Village")
  colnames(data.v) <- c("Id", "name", "location")
  
  #############################################
  ## GET INFORMATION FOR DISTRICT SURVEY     ##
  #############################################
  
  
  ##Create data frame with all Id's and respondent names
  files = list.files(path = paste0(mdir,"Metadata_reporting/data/"), pattern = "dist.tab")
  
  data.dist <- read.delim(paste0(mdir,"Metadata_reporting/data/",files[1]), header = TRUE,
                          stringsAsFactors = FALSE)
  
  colnames(data.dist)[1] <- "Id"
  data.dist <- select(data.dist, Id, sid_name, sid_location)
  source("R/filterDataset.R")
  data.dist <- filterDataset(df = data.dist, dataset = "District")
  colnames(data.dist) <- c("Id", "name", "location")
  
  ####################
  ## MERGE DATASETS ##
  ####################
  
  master <- rbind(data.v, data.dist)

  ####################
  ## CLEAN UP GPS   ##
  ## and create lat ##
  ## and long colums##
  ####################
  master$location <- gsub("\\[.*\\].*","",master$location) 
  
  
  master <- tidyr::separate(master,location, into = c("lat","lon"), sep = ",")
  master$lat <- as.numeric(master$lat)
  master$lon <- as.numeric(master$lon)




master
  
  
}