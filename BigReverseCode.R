library(revgeo)

setwd("D:/Programming/R/StepikАнализДанныхR/")
main = read.csv("D:/Programming/R/StepikАнализДанныхR/coordinates.csv")
main_sub <- main[0:100000,]
rm(main)
gc()

# Step 1: Create a blank dataframe to store results.
data_all = data.frame()
start <- Sys.time()
# Step 2: Create a while loop to have the function running until the # dataframe with 100,000 rows is empty.
while (nrow(main_sub)>0) {
  # Step 3: Subset the data even further so that you are sending only # a small portion of requests to the Photon server.
  main_sub_t <-  main_sub[1:200,]
  # Step 4: Extracting the lat/longs from the subsetted data from
  # the previous step (Step 3).
  latlong <- main_sub_t %>% 
    select(latitude, longitude) %>% 
    unique() %>% 
    mutate(index=row_number())
  
  
  # Step 5: Incorporate the revgeo package here. I left_joined the 
  # output with the latlong dataframe from the previous step to add 
  # the latitude/longitude information with the reverse geocoded data.
  cities <- revgeo(latlong$longitude, latlong$latitude, provider =  'photon', output = 'frame') %>% 
  mutate(index = row_number(),country = as.character(country)) %>%
  filter(country == 'Russian Federation') %>% 
  mutate(location = paste(city, state, sep = ", ")) %>% 
  select(index, location) %>% 
  left_join(latlong, by="index") %>% 
  select(-index)

# Removing the latlong dataframe because I no longer need it. This 
# helps with reducing memory in my global environment.
#rm(latlong)


# Step 6: Adding the information from the cities dataframe to 
# main_sub_t dataframe (from Step 3).

data_new <- main_sub_t %>% 
  left_join(cities, by=c("latitude","longitude")) %>% 
  select(X, text, location, latitude, longitude)


# Step 7: Adding data_new into the empty data_all dataframe where 
# all subsetted reverse geocoded data will be combined.

data_all <- rbind(data_all,data_new) %>% 
  na.omit()


# Step 8: Remove the rows that were used in the first loop from the # main_sub frame so the next 200 rows can be read into the while # loop.

main_sub <- anti_join(main_sub, main_sub_t, by=c("X"))
print(nrow(main_sub))

# Remove dataframes that are not needed before the while loop closes # to free up space.
#rm(data_sub_t)
#rm(data_new)
#rm(latlong_1)
#rm(cities)

#print('Sleeping for 10 seconds')
#Sys.sleep(10)


#end <- Sys.time()