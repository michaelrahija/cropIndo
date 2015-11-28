# Extract last five characters from a string

# Taken from this thread: http://stackoverflow.com/questions/7963898/extracting-the-last-n-characters-from-a-string-in-r

extractRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}