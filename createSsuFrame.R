#cleaning and building SSU frame building

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

source("R/mergeListing.R")
data <- mergeListing(dd = "~/Dropbox/CROP/Indonesia/")

##-- merge names of census blocks and subdistricts
source("R/labelFactors.R")
data <- labelFactors(df = data, 
                     vars = c("sub_dist_name2","census_block"))

data <- select(data, -c(sub_dist_name2,census_block))

##-- remove columns that have all NA values
# test <- sapply(data, function(x)  sum(!is.na(x)) == 0)
# data <- data[,!test]


##--ONLY KEEP MOST ACCURATE gps
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

##---- CLEAN UP hh_crop
if(sum(!is.na(data$hh_crop_5)) == 0) data <- select(data,-hh_crop_5)
if(sum(!is.na(data$hh_crop_6)) == 0) data <- select(data,-hh_crop_6)
if(sum(!is.na(data$hh_crop_7)) == 0) data <- select(data,-hh_crop_7)

#replace values w/ labels
labels <- c("weltlandPaddy","drylandPaddy","Maize",
            "soybean","groundnut","mungbean","cassava",
            "sweatPotato")

cropCols <- grep("hh_crop",colnames(data)) #grab indices of crop columns


#outer loop for crop columns
for(col in cropCols){
  
  #inner loop to replace values w/ labels for crops
  for(i in 1:length(labels)){
    data[,col] <- replace(data[,col], #the vector 
                          grepl(i,data[,col]), #find the rows w/ specific value
                          labels[i]) #replace the value w/ label using index
  
    }  
}

##--clean wetlandpaddy variables, triggers indicate which types of 
##--wetland paddy were selected. there are 8 columns (counting _0)
##-- b/c there are 8 options
labels <- c('wetland paddy on irrigated land, pure crop, and hybrid',
            'wetland paddy on irrigated land, pure crop, and NOT hybrid',
            'wetland paddy on irrigated land, mixed crop, and hybrid',
            'wetland paddy on irrigated land, mixed crop, and NOT hybrid',
            'wetland paddy on NOT irrigated land, pure crop, and hybrid',
            'wetland paddy on NOT irrigated land, pure crop, and NOT hybrid',
            'wetland paddy on NOT irrigated land, mixed crop, and hybrid',
            'wetland paddy on NOT irrigated land, mixed crop, and NOT hybrid')

wetlCols <- grep("wetlandpaddy_trigger",colnames(data)) #grab indices of crop columns

for(col in wetlCols){
  
  #inner loop to replace values w/ labels for crops
  for(i in 1:length(labels)){
    data[,col] <- replace(data[,col], #the vector 
                          grepl(i,data[,col]), #find the rows w/ specific value
                          labels[i]) #replace the value w/ label using index
    
  }  
}

#label month variables
labels_months <- c("January",
            "February",
            "March",
            "April",
            "December")

wetlCols <- grep("wetlandpaddy_month",colnames(data))
wetlCols <- append(grep("wetland_month",colnames(data)), #naming mistake in first var
                   wetlCols)

for(cols in wetlCols){
  data[,cols] <- factor(data[,cols],
                        levels = c(1,2,3,4,12),
                        labels = labels_months)
}


##--CLEAN UP DRYLAND PADDY
drylCols <- grep("drylandpaddy_trigger",colnames(data))
labels <- c("pure dryland paddy","mixed dryland paddy")

for(cols in drylCols){
  data[,cols] <- factor(data[,cols],
                        levels = 1:2,
                        labels = labels)
}

#label months
drylCols <- grep("drylandpaddy_[0-9]",colnames(data))
for(cols in drylCols){
  data[,cols] <- factor(data[,cols],
                        levels = c(1,2,3,4,12),
                        labels = labels_months)
}

##--CLEAN UP MAIZE
maizeCols <- grep("maize_trigger", colnames(data))
labels = c('maize pure crop, hybrid',
           'maize pure crop, composite',
           'maize pure crop, local',
           'maize mixed crop, hybrid',
           'maize mixed crop, composite',
           'maize mixed crop, local')

levels <- 1:6

for(cols in maizeCols){
  data[,cols] <- factor(data[,cols],
                        levels = levels,
                        labels = labels)
}

#label months
maizeCols <- grep("maize_[0-9]",colnames(data))
for(cols in maizeCols){
  data[,cols] <- factor(data[,cols],
                        levels = c(1,2,3,4,12),
                        labels = labels_months)
}

##-- CLEAN UP SOYBEAN
soyCols <- grep("soybean_trigger", colnames(data))
labels = c('soybean pure crop',
           'soybean mixed crop')

levels <- 1:2

for(cols in soyCols){
  data[,cols] <- factor(data[,cols],
                        levels = levels,
                        labels = labels)
}

#label months
soyCols <- grep("soybean_[0-9]",colnames(data))
for(cols in soyCols){
  data[,cols] <- factor(data[,cols],
                        levels = c(1,2,3,4,12),
                        labels = labels_months)
}

#--CLEAN UP GROUNDNUT, MUNGBEAN,CASSAVA, SWEETPOTATO
multCols <- c("groundnut_month", "mungbean_month", "cassava_month", 
          "sweetpotato_month")
multCols <- colnames(data) %in% multCols
multCols <- grep("TRUE",multCols)

for(cols in multCols){
  data[,cols] <- factor(data[,cols],
                        levels = c(1,2,3,4,12),
                        labels = labels_months)
}

##--arrange columns
data.temp <- select(data,
               dist_name2,
               subDistrictNames,
               censusBlockLabels,
               sample_code,
               physicalBuildingId,
               censusBuildingId,
               houseHoldId,
               lat,
               lon,
               altitude,
               accuracy,
               ts,
               hh_head_name,
               hh_food_crop,
               hh_harvest)


#add crop columns on the end
colsAdd <- colnames(data) %in% colnames(data.temp)               
colsAdd <- grep("FALSE", colsAdd)

master <- cbind(data.temp, data[,colsAdd])

#remove random number column
master <- select(master, - ssSys_IRnd)

write.csv(master,
          file = paste0(dd, "/ssu_frame.csv"), 
          row.names = FALSE)




