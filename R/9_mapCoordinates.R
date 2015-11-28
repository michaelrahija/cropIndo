

library(ggmap)

mapCoordinates <- function(data = df, country = "Tanzania"){
  
  map <- get_map(location = country, zoom = 6)

  mapPoints <- ggmap(map) + geom_point(aes(x = long, y = lat, data = df, alpha = .5))




  mapgilbert <- get_map(location = c(lon = mean(df$lon), lat = mean(df$lat)), zoom = 7,
                      #maptype = "satellite", 
                      scale = 2)

  # plotting the map with some points on it
  map <- ggmap(mapgilbert) +
    geom_point(data = df, aes(x = lon, y = lat, fill = "red", alpha = 0.8), size = 2, shape = 21) +
    guides(fill=FALSE, alpha=FALSE, size=FALSE) +
    labs(x = "longitude", y = "latitude", main = "Map of Interviews") 
    #scale_colour_continuous(low = "red", high = "blue", space = "Lab", guide = "colorbar")
    #scale_fill_continuous(guide = guide_legend())
    #ggtitle("Map of interviews")+
    #theme(plot.title = element_text(color="#666666", face="bold", size=15))

map
}

