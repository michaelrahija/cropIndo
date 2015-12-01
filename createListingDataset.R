# Script for cleaning listing data
library(foreign)
library(dplyr)

wd <- "~/Dropbox/CROP/Indonesia/CropIndo"
dd <- "~/Dropbox/CROP/Indonesia/"
setwd(wd)

##---GET DATA FILES
data.files <- list.files(pattern = ".tab", 
                       paste0(dd,"/listing_data","/"))

data.files <- paste0(dd,"/listing_data","/",data.files)


##-----PARTICULARS  
id <- grep(pattern = "Agricultural Household",
           ignore.case = TRUE,
           data.files)

if(length(id) > 1) "id.level files > 1!"

id.df <- read.table(data.files[id], 
                    sep="\t",
                    header = TRUE,
                    stringsAsFactors = FALSE)

id.df <- rename(id.df, physicalBuildingId = Id)


##------CENSUS BUILDINGS
id.census <- grep(pattern = "census",
                  ignore.case = TRUE,
                  data.files)

if(length(id.census) > 1) "id.census files > 1!"

census.df <- read.table(data.files[id.census], 
                        sep ="\t",
                        header = TRUE,
                        stringsAsFactors = FALSE)                                             

census.df = rename(census.df, censusBuildingId = Id)
census.df = rename(census.df, physicalBuildingId = ParentId1 )
if("num_hh_census" %in% colnames(census.df)){
  census.df <- rename(census.df, num_hh = num_hh_census)
}


master <- merge(x = id.df,y = census.df, by = "physicalBuildingId")


##----- HOUSEHOLDS ROSTER  
id.hh <- grep(pattern = "hh",
                  ignore.case = TRUE,
                  data.files)

if(length(id.hh) > 1) "id.census files > 1!"

hh.df <- read.table(data.files[id.hh], 
                        sep ="\t",
                        header = TRUE,
                        stringsAsFactors = FALSE) 

hh.df <- rename(hh.df,physicalBuildingId = ParentId2)


hh.df <- rename(hh.df,censusBuildingId = ParentId1)
hh.df <- rename(hh.df, houseHoldId = Id)
master <- merge(master,hh.df, by = c("physicalBuildingId","censusBuildingId"))

##----Put columns in order: phyiscalBuildingId,censusBuildingId, HouseholdId
colnames(master)
master <- cbind(master[,1:2],master[,15],master[,3:length(master)])
head(master)

##---
colnames(master)
nrow(master)
temp <- master %>%
          group_by(num_hh) %>%
          summarize(n())

master %>%
  group_by(dist_name2) %>%
  summarize(hh = length(unique(physicalBuildingId)))

##----MERGE IN POLYGON CODES

#merge polygon codes w/ datasetA
# codes <- read.csv("config/hh_to_poly.csv")
# codes <- select(codes, sub_dist_name2,census_block,polygon_code)
# master$temp <- paste0(master$sub_dist_name2,master$census_block)
# codes$temp <- paste0(codes$sub_dist_name2,codes$census_block)
# 
# master <- merge(master, codes, by = "temp")
# head(master[,-c("sub_dist_name2.y")])




#clean-up colnames
