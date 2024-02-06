# Copyright Assoc.Prof M Campbell 2024. 
# All rights reserved.
# This work is licensed under CC BY-NC-SA 4.0 
# This license requires that reusers give credit to the creator. 
# It allows reusers to distribute, remix, adapt, and build upon the material in 
# any medium or format, for noncommercial purposes only. If others modify or adapt 
# the material, they must license the modified material under identical terms. 

# testing the GREENR package {greenR} 

# you'll need 3 libraries installed.
# library(devtools)
# devtools::install_github("sachit27/greenR", dependencies = TRUE)
# source: https://github.com/sachit27/greenR
# OR 
# remotes::install_github("sachit27/greenR", dependencies = TRUE)
# AND
# install.packages("tmaptools", "htmlwidgets")
 
# greenR library - for visualising, accessibility, clustering greenspace, etc
library(greenR)
# for geocoding - see ?geocode_OSM
library(tmaptools)
# for saving maps - see ?saveWidget
library(htmlwidgets)

# get the OSM data for the City we want *(pick one)*
place <- ("put name here")
# get the OSM data for the County we want *(pick one)*
country <- (", New Zealand")

#######################################################################
# BELFAST, UNITED KINGDOM
######################################################################
place <- ("Belfast")
country <- (", United Kingdom")
data <- get_osm_data ( paste0 ( place, country) )
green_areas_data <- data$green_areas
# Create an interactive plot using Leaflet
map <- visualize_green_spaces(green_areas_data)
print(map)
#save it
saveWidget(map, file = paste0("green_spaces_", place, ".html"))

# This function then defines distance decay functions for green areas and 
# trees using the parameter D
# Arguments
# osm_data	- The OpenStreetMap data. This should be a list with three components: 
# highways, green_areas, and trees. Each component should be a spatial data frame. 
# You can use the osmdata package to get the required data.
# crs_code	- The EPSG code for the Coordinate Reference System (CRS).
# D -  #The decay parameter in the decay function, default is 100.

# 50m greenspace
green_index <- calculate_green_index(data, 4326, 50)
map <- plot_green_index(green_index, base_map = "CartoDB.DarkMatter", interactive = TRUE)
print(map)
saveWidget(map, file = paste0("green_index_", place, ".html"))

# percentage of place Greenspace
percentage <- calculate_percentage(green_index)

# accessibility to greenspace
#########################################################################
# use the geocode_OSM function from tmaptools to find lat/long for a city/town centre
# useful for accessibility 
centre_place <- geocode_OSM ( place, details = TRUE, as.data.frame = TRUE)
centre_place$lat
centre_place$lon

# 15 minutes but can be adjusted using the 'max_walk_time' parameter.
accessibility_greenspace(green_areas_data, 
                         centre_place$lat, centre_place$lon, 
                         max_walk_time=15)
# 30 minutes but can be adjusted using the 'max_walk_time' parameter.
accessibility_greenspace(green_areas_data, 
                         centre_place$lat, centre_place$lon, 
                         max_walk_time=30)

# clean up
rm(list=ls())

# END