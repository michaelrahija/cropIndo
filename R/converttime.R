#' Convert time from seconds into readable format
#'
#'@param number is a value in seconds
#'@return The vale in Day:Hours:Minutes:Seconds format
#'@example
#'converttime(60)
#'converttime(86400)

converttime <- function(number){
    
    days <- c()
    hours <- c()
    minutes <- c()
    seconds <- c()
    
        
        days <- append(days, floor((number/86400)))
        hours <- append(hours, floor((number - (days[1] * 86400))/3600))
        minutes <- append(minutes,floor((number - 
                                             (days[1] * 86400)-
                                             (hours[1]*3600))/60))
        seconds <- append(seconds, floor((number - 
                                              (days[1] * 86400)-
                                              (hours[1]*3600)-
                                              (minutes[1]*60))))
                          
        value <- paste(days, hours, minutes, seconds, sep=":")

    return(value)
}