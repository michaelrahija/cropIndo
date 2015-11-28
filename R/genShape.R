#generate kml file for indonesia

genShape <- function(bs.id  = "3403150002003B"){
  
  #get data
  shape.file = read.csv(paste0("shape_files/",bs.id,".csv"))
  coord.file = read.csv(paste0("hh_coordinates/","3403150002003B.csv"))
  name = "test"  
####################
##create polygon  ##
####################
#required information
BS_ID_ST13CODE <- bs.id
colnames(shape.file) <- c("latitude","longitude")
source("R/convert_poly.R")
polygon <- convert_poly(shape.file)  

  x <- readLines("template_shape/fake_template_header.txt")
  x <- gsub("\\t","",x)
  x <- gsub("BS_ID_ST13CODE",BS_ID_ST13CODE,x)
  x<-gsub("POLYGONCOORDINATES",polygon,x)

#############################
## INSERT POINTS OF HHs    ##
#############################

y <- readLines("template_shape/fake_template_2.txt")
y <- gsub("\\t","",y)

##create points
coord.list <- list()

for(i in 1:nrow(coord.file)){
  temp <- gsub(pattern = "FARMER_NAME",coord.file$farmer_name[i],y)
  temp <- gsub(pattern = "HH_COORDINATES",
               paste0(coord.file$longitude[i],",",coord.file$latitude[i]),
               temp)
  coord.list[[i]] <- temp
  
}

y<- unlist(coord.list)

##add ending
z <- readLines("template_shape/fake_template_3.txt")
z <- gsub("\\t","",z)

writeLines(c(x,y,z),paste("integrated_shape/",bs.id,".kml"), sep="")

}
