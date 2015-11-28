# Script for cleaning listing data
library(foreign)
library(dplyr)

wd <- "~/Dropbox/CROP/Indonesia/CropIndo"
setwd(wd)

#create list of data.files
# data.dir = "~/Dropbox/CROP/cropIndo/simulated_data"

data.files <- list.files(pattern = ".tab", 
                       paste0(wd,"/simulated_data","/"))

data.files <- paste0(wd,"/simulated_data","/",data.files)

##################
## PARTICULARS  ##
##################
id <- grep(pattern = "Agricultural Household",
           ignore.case = TRUE,
           data.files)

if(length(id) > 1) "id.level files > 1!"

id.df <- read.table(data.files[id], 
                    sep="\t",
                    header = TRUE,
                    stringsAsFactors = FALSE)

id.df <- rename(id.df, physicalBuildingId = Id)

###########################
##    CENSUS BUILDINGS   ##
###########################

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

##########################
## HOUSEHOLDS ROSTER    ##
##########################
id.hh <- grep(pattern = "hh",
                  ignore.case = TRUE,
                  data.files)

if(length(id.hh) > 1) "id.census files > 1!"

hh.df <- read.table(data.files[id.hh], 
                        sep ="\t",
                        header = TRUE,
                        stringsAsFactors = FALSE) 

hh.df <- rename(hh.df,physicalBuildingId = ParentId2)


# temp <- select(master,physicalBuildingId,nu_census_buildings2,censusBuildingId, num_hh)
# temp2 <- select(hh.df,physicalBuildingId,Id, ParentId1)
# 
# temp
# temp2

hh.df <- rename(hh.df,censusBuildingId = ParentId1)
hh.df <- rename(hh.df, houseHoldId = Id)
master <- merge(master,hh.df, by = c("physicalBuildingId","censusBuildingId"))
head(master)


#################################
## ADD POLYGON CODE TO DATASET ##
#################################
#######################################################################################
###### GENERATE SOME RANDOM CODES
#x <- as.character(codes$census_block)
#master$census_block <- sample(x,nrow(master), replace = TRUE)

#merge polygon codes w/ dataset
codes <- read.csv("config/hh_to_poly.csv")
codes <- select(codes, sub_dist_name2,census_block,polygon_code)
master$temp <- paste0(master$sub_dist_name2,master$census_block)
codes$temp <- paste0(codes$sub_dist_name2,codes$census_block)

master <- merge(master, codes, by = "temp")
head(master[,-c("sub_dist_name2.y")])




#clean-up colnames
