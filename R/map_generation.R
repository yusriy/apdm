########################################################
# TITLE: To plot the site map
# AUTHOR: Yusri Yusup, PhD
# DATE: 2017-07-07
# VERSION: 1.0
# NOTE: This script downloads and plots the map using
# ggmap and google map
########################################################

####### * Installing and loading required packages ###################################################

#install.packages("ggmap")
#install.packages("gridExtra")
#install.packages("maptools")
#install.packages("rgdal")
#install.packages("raster")

#loading libraries
library(ggmap)
library(mapproj)
library(ggplot2)
library(gridExtra)
library(maptools)
library(rgdal)
library(raster)
library(grid)

#load map tools
source('tools/tool_map_createscale.R') # Script to source functions of scales

##### * Zoomed in map of location #####
sitemap <- get_googlemap(center = c(lon = 101.108771, lat = 4.511399), sensor=TRUE,
                         size = c(640,640), scale = 2, zoom = 16, maptype = "satellite")

map_plot1 <- ggmap(sitemap) +
  geom_point(aes_string(x = "101.109",y = "4.511"),size = 2,shape = 16,colour = "white") +
  geom_text(aes_string(x="101.109",y="4.511"),label="Pyrolysis Tower",colour="white",size=2,
            fontface="bold",hjust=0,vjust=-1.00, family = 'Arial') +
  # 
  # geom_point(aes_string(x = "103.4476",y = "4.2988"),size = 2,shape = 16,colour = "white") +
  # geom_text(aes_string(x="103.4476",y="4.2980"),label="Boiler",colour="white",size=2,
  #           fontface="bold",hjust=0,vjust=-1.00, family = 'Arial') +
  # 
  # geom_point(aes_string(x = "103.4486",y = "4.2995"),size = 2,shape = 16,colour = "white") +
  # geom_text(aes_string(x="103.4486",y="4.2995"),label="Furnace",colour="white",size=2,
  #           fontface="bold",hjust=0,vjust=-1.00, family = 'Arial') +
  # 
  xlab("") + ylab("") +
  
  theme(plot.title = element_text(lineheight=1, face="bold",size = 25, colour = "grey20"),
        axis.line=element_blank(),
        panel.border = element_rect(colour="grey20",fill=NA,size=0.5),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        plot.margin = unit(c(0.1,0.1,-0.4,-0.4),'cm')) +
  
  scaleBar(lon = 101.105, lat = 4.506, distanceLon = 0.5, distanceLat = 0.03, distanceLegend = 0.07,
           dist.unit = "km", orientation = TRUE, legend.colour = 'white', legend.size = 3)
 
#Plot site map
jpeg(filename = "maps/evergreen_stack.jpg",height=8,width=8,
     bg = "white",units='cm', res = 300, family = "Arial")
map_plot1
dev.off()

#rm(sitemap,map_plot)


##### * Zoomed out map of location #####
sitemap <- get_googlemap(center = c(lon = 101.108771, lat = 4.511399), sensor=TRUE,
                         size = c(640,640), scale = 2, zoom = 15, maptype = "terrain")

map_plot2 <- ggmap(sitemap) +
  geom_point(aes_string(x = "101.109",y = "4.511"),size = 2,shape = 16,colour = "red") +

  xlab("") + ylab("") +
  
  theme(plot.title = element_text(lineheight=1, face="bold",size = 25, colour = "grey20"),
        axis.line=element_blank(),
        panel.border = element_rect(colour="grey20",fill=NA,size=0.5),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        plot.margin = unit(c(0.1,0.1,-0.4,-0.4),'cm')) + 
  
  scaleBar(lon = 101.102, lat = 4.502, distanceLon = 1, distanceLat = 0.06, distanceLegend = 0.15,
           dist.unit = "km", orientation = TRUE, legend.colour = 'black', legend.size = 3)

#Plot site map
jpeg(filename = "maps/evergreen_terrain.jpg",height=8,width=8,
     bg = "white",units='cm', res = 300, family = "Arial")
map_plot2
dev.off()

rm(sitemap,map_plot)

