#This function will take one data.df which is the coordinates of the polygon
#and generate one long character vector. 

convert_poly <- function(df = polygon){
  test <- paste(df$longitude,df$latitude,rep(0.0,length(test)), sep = ",")
  
  vec <- c()
  
  for (i in 1:length(test)){
    vec <- paste(test[i], vec)
    
    
  }
  vec
}