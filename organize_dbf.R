library(dplyr)
wd = "/Users/michaelrahija/Dropbox/CROP/Indonesia/cropIndo"
setwd(wd)

list.files()
db <- read.dbf("sampel_mixed_crop_OK_2015.DBF")

#create for Gunung Kidul
db.gk <- filter(db, NMKAB == "GUNUNG KIDUL")

colnames(db.gk)
db.gk <- db.gk[,1:13]


temp <- select(db.gk,NMKEC,KEC,NKS_ALL,NBS)

temp <- arrange(temp,NMKEC)
write.csv(temp, file = "listing_info/cascading.csv", row.names = FALSE)

write.csv(temp, file = "config/hh_to_poly.csv", row.names = FALSE)
list.files()
