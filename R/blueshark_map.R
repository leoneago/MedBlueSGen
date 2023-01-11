rm(list=ls())
library(rworldmap)
library(ggmap)
library(maps)
library(sp)
library(mapplots)
library(maptools)
library(rgdal)
library(RgoogleMaps)
library(ggOceanMaps)
library(RgoogleMaps)
library(dplyr)

#load the csv with all samples organized in a file called blu.csv

dataset <-read.csv(file = "blu.csv", sep = ",")
NATL <- dataset %>% filter(
  area %in% c("NATL" )
)

EATL <- dataset %>% filter(
  area %in% c("EATL" )
)


WMED <- dataset %>% filter(
  area %in% c("WMED" )
)

EMED <- dataset %>% filter(
  area %in% c("EMED" )
)

#Then attach the datasets
attach(NATL)
attach(EATL)
attach(WMED)
attach(EMED)

dt <- data.frame(lon = c(-20, -20, 30, 30), lat = c(30, 52, 30, 52))

basemap(data = dt, bathymetry = TRUE) + annotation_scale(location = "br") + 
  annotation_north_arrow(location = "tr", which_north = "true") + 
  geom_point(data = NATL, mapping = aes(x = lon, y = lat), color = "green") + 
  geom_point(data = EATL, mapping = aes(x = lon, y = lat), color = "red") +
  geom_point(data = WMED, mapping = aes(x = lon, y = lat), color = "purple") +
  geom_point(data = EMED, mapping = aes(x = lon, y = lat), color = "blue")
