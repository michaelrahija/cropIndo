#extract polygons
library(maptools)
library(XML)
library(plyr)

#get data
data.dir  = "~/Dropbox/CROP/Indonesia/cropIndo/shape_files/"
kml <- paste0(data.dir,list.files(data.dir)[1])

wd = "~/Dropbox/CROP/Indonesia/cropIndo"
setwd(wd)

#read kml file as text 
kml.text <- readLines(kml)

#read polygons into list
coords <- getKMLcoordinates(kml, ignoreAltitude=T)

#Get census block numbers
test <- grep(pattern = "SimpleData name=\"BS_NO_ST13\"",
              kml.text)
cb <- kml.text[test]
cb <- gsub("<SimpleData name=","",cb)
cb <- gsub(" ","",cb)
cb <- gsub("\\\"BS_NO_ST13","",cb)
cb <- gsub("\\\"><!\\[CDATA\\[","",cb)
cb <- gsub("\\]]></SimpleData>","",cb)
cb <- paste0("Census block ",cb)


#Get KODE_ST13, BS_ID_ST13
test <- grep(pattern = "SimpleData name=\"KODE_ST13\"",
             kml.text)
kode <- kml.text[test]
kode <- gsub("<SimpleData name=","",kode)
kode <- gsub(" ","",kode)
kode <- gsub("\\\"KODE_ST13","",kode)
kode <- gsub("\\\"><!\\[CDATA\\[","",kode)
kode <- gsub("\\]]></SimpleData>","",kode)
kode <- paste0("KODE_ST13 ",kode)

# test <- duplicated(kode) #12,13 on maps, and 
# kode[test]


#Get BS_ID_ST13
test <- grep(pattern = "SimpleData name=\"BS_ID_ST13\"",
             kml.text)
id <- kml.text[test]
id <- gsub("<SimpleData name=","",id)
id <- gsub(" ","",id)
id <- gsub("\\\"BS_ID_ST13","",id)
id <- gsub("\\\"><!\\[CDATA\\[","",id)
id <- gsub("\\]]></SimpleData>","",id)
id <- paste0("BS_ID_ST13 ",id)

#Get KECAMATAN
test <- grep(pattern = "SimpleData name=\"KECAMATAN\"",
             kml.text)
subdistrict <- kml.text[test]
subdistrict <- gsub("<SimpleData name=","",subdistrict)
subdistrict <- gsub(" ","",subdistrict)
subdistrict <- gsub("\\\"KECAMATAN","",subdistrict)
subdistrict <- gsub("\\\"><!\\[CDATA\\[","",subdistrict)
subdistrict <- gsub("\\]]></SimpleData>","",subdistrict)
subdistrict <- paste0("subdistrict ",subdistrict)

#if any duplicates, create add # to of code
names <- paste(subdistrict,id)
test <- duplicated(names)
names[test] <- paste0(names[test],"_1")


#assign census blocks as names to coordinates in list
names(coords) <- names

#write polygon coordinates to csv files
for(i in 1:length(names)){
  write.csv(coords[i], file = paste0(wd,"/shape_files/",names[i],".csv"), row.names = FALSE)
}
  
  
