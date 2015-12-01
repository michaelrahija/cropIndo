##' Merge datasets
##' 
##' This grabs the datafiles out of a directory, and merges them. 
##' The result should be the SSU sampling frame. 
##' 
##' @param dd directory containing data files exported from server
##'   
##' @return A data frame that has merged properly all of the different data files
##'
##' @export

mergeListing <- function(dd = "~/Dropbox/CROP/Indonesia/"){
  
  
  ##---GET DATA FILES
  data.files <- list.files(pattern = ".tab", 
                           paste0(dd,"listing_data/"))
  
  data.files <- paste0(dd,"listing_data/",data.files)
  
  
  ##-----PARTICULARS  
  id <- grep(pattern = "Agricultural Household",
             ignore.case = TRUE,
             data.files)
  
  if(length(id) > 1) "id.level files > 1!"
  
  id.df <- read.table(data.files[id], 
                      sep="\t",
                      header = TRUE,
                      stringsAsFactors = FALSE)
  
  
  names(id.df)[names(id.df)=="Id"] <- "physicalBuildingId"
  
  ##------CENSUS BUILDINGS
  id.census <- grep(pattern = "census",
                    ignore.case = TRUE,
                    data.files)
  
  if(length(id.census) > 1) "id.census files > 1!"
  
  census.df <- read.table(data.files[id.census], 
                          sep ="\t",
                          header = TRUE,
                          stringsAsFactors = FALSE)                                             
  
  #census.df = rename(census.df, censusBuildingId = Id)
  names(census.df)[names(census.df)=="Id"] <- "censusBuildingId"
  #census.df = rename(census.df, physicalBuildingId = ParentId1 )
  names(census.df)[names(census.df)=="ParentId1"] <- "physicalBuildingId"
  
  
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
  
#   hh.df <- rename(hh.df,physicalBuildingId = ParentId2)
#   hh.df <- rename(hh.df,censusBuildingId = ParentId1)
#   hh.df <- rename(hh.df, houseHoldId = Id)
    names(hh.df)[names(hh.df)=="ParentId2"] <- "physicalBuildingId"
    names(hh.df)[names(hh.df)=="ParentId1"] <- "censusBuildingId"
    names(hh.df)[names(hh.df)=="Id"] <- "houseHoldId"
  
  
  
  
  master <- merge(master,hh.df, by = c("physicalBuildingId","censusBuildingId"))

master                    
}