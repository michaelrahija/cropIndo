##' Add factor levels for different variables
##' 
##' This function will add factors and labels
##' 
##' @param var The variables for which you want to add levels
##' @param df A dataframe where the variables are located that you want to label
##'   
##' @return A data frame that has the labels properly added
##'
##' @export

labelFactors <- function(df = data, vars = "sub_dist_name2"){
  
  if("sub_dist_name2" %in% vars){
    
    subDistrictNames <- c("Purwosari",
                          "Sapto_sari",
                          "Tanjungsari",
                          "Rongkop",
                          "Girisubo",
                          "Semanu",
                          "Ponjong",
                          "Karangmojo",
                          "Playen",
                          "Gedang_sari",
                          "Semin")
    nums <- c(11,
              30,
              41,
              50,
              51,
              60,
              70,
              80,
              100,
              120,
              150)
    
    district.df <- data.frame(subDistrictNames = subDistrictNames, 
                              sub_dist_name2 = as.integer(nums))
    
    temp <- merge(district.df,df, by = "sub_dist_name2", all = TRUE)
    
    
    #print("label added for sub_dist_name2")
  }
  
  if("census_block" %in% vars){
    labels <- c("015B",
                "008B",
                "011B",
                "014B",
                "001B",
                "008B",
                "007B",
                "015B",
                "007B",
                "003B",
                "008B",
                "049B",
                "005B",
                "018B",
                "009B",
                "030B",
                "003B",
                "004B",
                "008B",
                "001B")
    
    values <- 1:20
    
    temp.cb <- data.frame(censusBlockLabels = labels, census_block = as.integer(values))
  
    temp <- merge(temp,temp.cb, by = "census_block", all = TRUE) #will need to adjust this code! b/c temp might not exist!
    
    #print("label added for census_block")
  }
  
  
temp  
  
  
}