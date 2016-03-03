#cleaning and building SSU frame building

#---Import data
library(dplyr)
library(reshape)
library(xlsx)
library(ggplot2)
library(tidyr)


#Set working directory
sys <- Sys.info()
if(sys[5] == "x86_64"){
  wdir = "~/Dropbox/CROP/Indonesia/cropIndo" #Mac
  dd = "~/Dropbox/CROP/Indonesia/area_data"
} else {
  wdir = "C:/Users/rahija/Dropbox/CROP/Indonesia/cropIndo"
  dd = "C:/Users/rahija/Dropbox/CROP/Indonesia/area_data"
}

#set working directory
setwd(wdir)

dd.files <- list.files(dd, pattern = ".tab")

intActions <- grepl(dd.files, pattern = "interview_actions")
dd.files <- dd.files[!intActions]

###----Take first file ""Cat 3_QUES 3_Crop area by_inquiry_GPS_Indonesia_Iswadi.tab"

id <- grepl(dd.files, pattern = "GPS_Indonesia")

df <- read.table(paste0(dd,"/", dd.files[id]), 
                  sep="\t",
                  header = TRUE,
                  stringsAsFactors = FALSE)

##---Take parcel roster
id <- grepl(dd.files, pattern = "parcel_roster")

df.pr <- read.table(paste0(dd,"/", dd.files[id]), 
                 sep="\t",
                 header = TRUE,
                 stringsAsFactors = FALSE)

##GPS Analysis


gps <- select(df.pr, area_inquiry, area_gps1, area_gps2)
gps$parcelno <- 1:nrow(gps)
gps <- filter(gps, !is.na(area_gps1))

gps <- select(gps, parcelno, area_inquiry, area_gps1, area_gps2)
gps$avg_gps <- (gps$area_gps1 + gps$area_gps2)/2

gps <- gps %>% 
          gather(measure, accuracy, area_inquiry, area_gps1, area_gps2, avg_gps)

ggplot(gps,aes(x=accuracy)) + 
  geom_histogram(data=subset(gps,measure == 'area_inquiry'),fill = "red", alpha = 0.2) +
  geom_histogram(data=subset(gps,measure == 'avg_gps'),fill = "green", alpha = 0.2)



