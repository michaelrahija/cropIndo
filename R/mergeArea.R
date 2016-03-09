##' Merge datasets
##' 
##' This grabs the datafiles out of a directory, and merges them. 
##' The result should be a consolidated dataset from the area data
##' 
##' @param dd directory containing data files exported from server
##'   
##' @return A data frame that has merged properly all of the different data files
##'
##' @export

#Levels:
# Household Characteristics called "Cat 3_QUES 3_Crop a..."
# Parcel: "parcel_roster.tab" - these are parcels that belong to HH (merge to HH)
# Crop roster: "crop_roster.tab" - these are crops in each parcel (merge to PARCEL)
# Forth-coming season roster: "forthcoming_Seasons.tab" - These are forthcoming seasons
# in which the parcel is cultivated (merge to PARCEL)
# Crop roster for forthcoming: "crop_roster_forth.tab" - These are crops cultivated in
# forthcoming season. (merge to FORTHCOMING)


mergeArea <- function(dd = "~/Dropbox/CROP/Indonesia/"){
  
  
  ##---GET DATA FILES
  data.files <- list.files(pattern = ".tab", 
                           paste0(dd,"area_data/"))
  
  data.files <- paste0(dd,"area_data/",data.files)
  
  #Levels:
  # Household Characteristics called "Cat 3_QUES 3_Crop a..."
  id.df <- grep(pattern = "Cat 3_QUES",
             ignore.case = TRUE,
             data.files)
  
  if(length(id.df) > 1) "id.level files > 1!"
  
  id.df <- read.table(data.files[id.df], 
                      sep="\t",
                      header = TRUE,
                      stringsAsFactors = FALSE)
  
  names(id.df)[names(id.df)=="Id"] <- "qId"
  # Parcel: "parcel_roster.tab" - these are parcels that belong to HH (merge to HH)
  id.parcel <- grep(pattern = "parcel",
                 ignore.case = TRUE,
                 data.files)
  
  if(length(id.parcel) > 1) "id.level files > 1!"
  
  id.parcel <- read.table(data.files[id.parcel], 
                      sep="\t",
                      header = TRUE,
                      stringsAsFactors = FALSE)
  
  names(id.parcel)[names(id.parcel)=="ParentId1"] <- "qId"
  names(id.parcel)[names(id.parcel) == "Id"] <- "parcelId"
  
  #########################
  #    FIRST MERGER       #
  # each row is a parcel  #
  #########################
  master <- merge(id.df, id.parcel, by = "qId", all = TRUE)
  
  
  # Crop roster: "crop_roster.tab" - these are crops in each parcel (merge to PARCEL)
  id.crop <- grep(pattern = "crop_roster.tab",
                ignore.case = TRUE,
                data.files)
  
  if(length(id.crop) > 1) stop("id.level files > 1!")
  
  id.crop <- read.table(data.files[id.crop], 
                      sep="\t",
                      header = TRUE,
                      stringsAsFactors = FALSE)
  
  #in this case, Id indicates the crop. The Id indicates whether it is 
  #crop_name_current1, crop_name_current2, etc. 
  names(id.crop)[names(id.crop)=="Id"] <- "cropId"
  
  #ParentId1 is actually the parcel id
  names(id.crop)[names(id.crop)=="ParentId1"] <- "parcelId"
  names(id.crop)[names(id.crop)=="ParentId2"] <- "qId"
  
  #########################
  #    SECOND MERGER      #
  # each row is a crop    #
  #########################
  master <- merge(id.crop,master,  by = c("parcelId","qId"), all = TRUE)
  
  # Forth-coming season roster: "forthcoming_Seasons.tab" - These are forthcoming seasons
  # in which the parcel is cultivated (merge to PARCEL)
  # Crop roster for forthcoming: "crop_roster_forth.tab" - These are crops cultivated in
  # forthcoming season. (merge to FORTHCOMING)  
  
master                    
}