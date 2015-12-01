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
    
    
    print("label added for sub_dist_name2")
  }
  
temp  
  
  
}