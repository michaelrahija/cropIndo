#checks and SSU frame building

#---Import data
library(dplyr)
library(reshape)
library(xlsx)
library(ggplot2)


#Set working directory
sys <- Sys.info()
if(sys[5] == "x86_64"){
  wdir = "~/Dropbox/CROP/Indonesia/cropIndo" #Mac
  dd = "~/Dropbox/CROP/Indonesia/listing_data/"
  hhdir = "~/Dropbox/CROP/Indonesia/hh_coordinates"
  sdir = "~/Dropbox/CROP/Indonesia/shape_files"
} else {
  wdir = "C:/Users/rahija/Dropbox/Tanzania_Vet_Services_Project/Live_data_collection/Metadata_reporting/program"
  mdir = "C:/Users/rahija/Dropbox/Tanzania_Vet_Services_Project/Live_data_collection/"
}

#set working directory
setwd(wdir)

#grab data and merge to one df
source("R/mergeListing.R")
data <- mergeListing(dd = "~/Dropbox/CROP/Indonesia/")

##-- apply factor labels
source("R/labelFactors.R")
data <- labelFactors(df = data, 
                     vars = c("sub_dist_name2","census_block"))

data <- select(data, -c(sub_dist_name2,census_block))


##--only keep most accurate GPS
if(data$gps1_Accuracy > data$gps2_Accuracy){
  data$lat <- data$gps2_Latitude
  data$lon <- data$gps2_Longitude
  data$accuracy <- data$gps2_Accuracy
  data$altitude <- data$gps2_Altitude
  data$ts <- data$gps2_Timestamp
 } else {
  data$lat <- data$gps1_Latitude
  data$lon <- data$gps1_Longitude
  data$accuracy <- data$gps1_Accuracy
  data$altitude <- data$gps1_Altitude
  data$ts <- data$gps1_Timestamp
 }


data <- select(data, -c(gps2_Latitude,gps2_Longitude,gps2_Accuracy,
                        gps2_Altitude,gps2_Timestamp,
                        gps1_Latitude,gps1_Longitude,gps1_Accuracy,
                        gps1_Altitude,gps1_Timestamp))

##--clean-up hh_crop
if(sum(!is.na(data$hh_crop_5)) == 0) data <- select(data,-hh_crop_5)
if(sum(!is.na(data$hh_crop_6)) == 0) data <- select(data,-hh_crop_6)
if(sum(!is.na(data$hh_crop_7)) == 0) data <- select(data,-hh_crop_7)

#create labels 

labels <- c("weltlandPaddy","drylandPaddy","Maize",
            "soybean","groundnut","mungbean","cassava",
            "sweatPotato")

#id crop columns
cropCols <- grep("hh_crop",colnames(data))


#outer loop for crop columns
for(col in cropCols){
  
  #inner loops for to replace values w/ labels for crops
  for(i in 1:length(labels)){
    data[,col] <- replace(data[,col], #the vector 
                          grepl(i,data[,col]), #find the rows w/ specific value
                          labels[i]) #replace the value w/ label using index
  
    }  
  
}

