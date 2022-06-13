setwd("D:/Programming/R/")
main = read.csv("coordinates.csv")
view(main)

library(tidygeocoder)

library(tibble)
library(dplyr, warn.conflicts = FALSE)

tibble(
  latitude = c(main$latitude),
  longitude = c(main$longitude)
) %>%
  reverse_geocode(
    lat = latitude,
    long = longitude,
    method = 'osm',
    full_results = TRUE
  )

#louisville %>% head(3) %>% 
#  reverse_geocode(lat = latitude, long = longitude, 
#                  method = 'arcgis')
#
#louisville %>% head(2) %>% 
#  reverse_geocode(lat = latitude, long = longitude,  
#                  method = 'osm',
#                  limit = 2, return_input = FALSE)
