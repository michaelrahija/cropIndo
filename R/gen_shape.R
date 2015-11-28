# This function will take two parameters
# 1. Two vectors of latitude and longitude that form a polygon stored in df
# 2. Two vectors where each row contains latitude and 
#       longitudal coordinates to plot points stored in df
# 
# This function will build the .kml file by pasting bits of xml code together. 
# It will then save the .kml
# 
# Future parameterization: add color for polygon lines, directory where to save file

gen_shape = function(polygon = read.csv("data_files/polygon.csv"), 
                      coordinates = read.csv("data_files/coordinates.csv"),
                      polygonfoldertitle = "EA boundaries155",
                      name = "155",
                      hhfoldertitle = "Households 155"){
  
  #First defene header
  header = paste(readLines("pieces/header.txt"), collapse = " ")  
  

  #Add Title
  title = paste("<Folder><name>",polygonfoldertitle,"</name>", sep="")
  
  #Add placemark
  placemark1 = "<Placemark>"
  
  #Add name and description
  name.temp = paste("<name>",name,"</name>", sep="")
  description =  paste("<description>",name,"</description>", sep="")
  
  #import style of polygon
  stylepolystart = paste(readLines("pieces/stylepolygon.txt"), collapse= " ")
  
  #import coordinates and create long string
  source("R/convert_poly.R")
  polyshape = convert_poly(polygon)
  
  #import end of style polygon
  stylepolyend = paste(readLines("pieces/endpolygon.txt"), collapse= " ")
  
  #Add placemark
  placemark2 = "</Placemark>"
  closefolder = "</Folder>"
  
  master.xml = paste(header,title,placemark1,name.temp,description,stylepolystart,
                  polyshape,stylepolyend,placemark2, closefolder, sep="")
  
  ############################
  ##  BUILD HH COORDINATES  ##
  ############################
  
  #open folder and label coordinates file
  startcoordinates = paste("<Folder><name>",hhfoldertitle, "</name>", sep="")

    #Loop to create line of xml for each hh
    index = 1:length(coordinates[,1])
    
    coordinates.xml = c()
    
    for (i in index){
      
      hh.open.xml = "<Placemark><styleUrl>#icon-503-DB4436</styleUrl>"
    
      hh.name.xml = paste("<name>",
                            coordinates[i,1],'</name>', sep="")
      
      hh.address.xml = paste("<description><![CDATA[address:",
                              coordinates[i,2], "]]></description>",sep="")
      
      hh.coordinates.xml = paste("<Point><coordinates>",coordinates[i,3],",",
                                  coordinates[i,4],",0.0</coordinates></Point>",
                                  sep="")
      
      hh.end.xml = "</Placemark>"
      
      hh.all = paste(hh.open.xml, hh.name.xml, hh.address.xml, hh.coordinates.xml, hh.end.xml,
                      sep="")
      
      coordinates.xml = paste(coordinates.xml, hh.all, sep="")        
    
    }
  
  #close folder, and put all hh coordinates together
  closecoordinates<- "</Folder>"  
  
  hh.xml = paste(startcoordinates,coordinates.xml,closecoordinates, sep="")
  
  ###############################################
  ## Insert Style at end and paste together    ##
  ###############################################  
  footer = paste(readLines("pieces/style_end.txt"), collapse = " ")
  
  final.xml = paste(master.xml, hh.xml, footer, sep= '')
  
  
  ########################
  ## write .kml file    ##
  ########################
  
  writeLines(final.xml,paste(name,".kml"), sep="")
}