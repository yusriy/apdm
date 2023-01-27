

library(akima) # To generate grid for contour plots
library(ggmap)
library(rgdal) # To use the functions to convert UTM to latlon

# Register google maps api key
register_google(key = "YOU NEED TO USE YOUR OWN GOOGLE KEY")
#### NOTE: DELETE '*' FROM ORIGINAL AERSCREEN RESULT DATA FILE BEFORE IMPORT

#### Import data
### Names of columns
names.df <- c('Concentration', 'Distance', 'Elevation', 'Flow', 'Season_month',
              'Zo_sector', 'Date', 'H0', 'U*', 'W*', 'DT_DZ', 'ZICNV', 'ZIMCH',
              'M_O_LEN', 'Z0', 'BOWEN', 'ALBEDO', 'REF_WS', 'HT', 'REF_TA', 'HT')
### Import data
df <- read.table('qualitest/data_results/qualitest_co_crp_max_conc_distance.txt',
                 sep = '', skip = 1, header = FALSE,
                 colClasses = c(rep('numeric',4),rep('character',3),rep('numeric',14)))
### Rename columns
names(df) <- names.df


#### Change distance and direction to coordinates
# QUALITEST Note for crp coordinates, 327662 EASTING, 475386 NORTHING
# boiler 327718 and 475330
# furnace 327830 and 475408

utm_center_x <- 327662  #### CHANGE FOR EACH STACK
utm_center_y <- 475386  #### CHANGE FOR EACH STACK
utm_x <- (df$Distance * sin(df$Flow * pi/180)/100) + utm_center_x
utm_y <- (df$Distance * cos(df$Flow * pi/180)/100) + utm_center_y
df_coord <- data.frame(utm_x,utm_y)

### Convert to Lat Lon
sputm <- SpatialPoints(df_coord, proj4string=CRS("+proj=utm +zone=48 +datum=WGS84"))  
spgeo <- spTransform(sputm, CRS("+proj=longlat +datum=WGS84"))
x <- spgeo@coords[,1]
y <- spgeo@coords[,2]
c <- df$Concentration
df_contour <- data.frame(x,y,c)


#### Plot map with contour overlap
### Download map
sitemap <- get_googlemap(center = c(lon = 103.4476,lat = 4.2988), sensor=TRUE,
                         size = c(640,640), scale = 2, zoom = 18, maptype = "satellite")
#### Plot contour plots
map <- ggmap(sitemap) + 
  geom_density2d(data = df_contour, aes(x = x, y = y)) +
  stat_density2d(data = df_contour, aes(x = x, y = y, fill =..level.., alpha = ..level..),
                 size = 0.01, bins = 16, geom = 'polygon')

### To extract color scale data
gb_map <- ggplot_build(map)

map <- map + scale_fill_gradient(low = 'green', high = 'red', 
                                 breaks = c(range(gb_map$data[[4]][[1]])[2],
                                            mean(range(gb_map$data[[4]][[1]])),
                                            range(gb_map$data[[4]][[1]])[1]), 
                                 labels = c(round(range(df_contour$c)[2],2),
                                            round(mean(df_contour$c),2),
                                            round(range(df_contour$c)[1],2))) +
  scale_alpha(range = c(0.00, 0.5), guide = FALSE) +
  xlab('Longitude') + ylab('Latitude') +
  theme(text = element_text(size = 6),
        legend.position = 'right') +
  guides(fill = guide_legend(title = expression(paste('Concentration, ', mu, 'g m'^'\u22123'))))



#### CREATE THE FIGURE
jpeg(filename = "qualitest/figs/results/qualitest_crp_co.jpeg",height=8,width=12,
     bg = "white",units='cm', res = 600, family = "Arial")
map
dev.off()  












