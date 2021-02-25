#####################################
## What: NEON API: BART Remote Sensing Data Download 
## Who: Jack Hastings
## When: 2/24/2022
## https://www.neonscience.org/resources/learning-hub/tutorials/neon-api-usage
#####################################


library(httr)
library(jsonlite)
library(dplyr, quietly = T)
library(downloader)


# Request lidar data availability info: DP1.30003.001
req.aop.lidar <- GET("http://data.neonscience.org/api/v0/products/DP1.30003.001")

# make this JSON readable
avail.aop.lidar <-jsonlite::fromJSON(content(req.aop.lidar, as = 'text'),
                               simplifyDataFrame = T, flatten = T)

# get availability list for the product
lidar.urls <- unlist(avail.aop.lidar$data$siteCodes$availableDataUrls)

# get data availability from location/date of interest
lidar.BART.2019 <- GET(lidar.urls[intersect(grep('BART', lidar.urls),
                                            grep('2019', lidar.urls))])
lidar.files <- jsonlite::fromJSON(content(lidar.BART.2019, as = 'text'))

# this list of files is very long, just look at the first ten
head(lidar.files$data$files$name, 10)
  
#download

download(lidar.files$data$files$url[grep('320000_4880000', 
                                         lidar.files$data$files$name)],
         paste(getwd(), '/BART_pointcloud.laz', sep = ''), mode = 'wb')

#test lidar plot to see if it worked
library(lidR)
xx <- lidR::readLAS('BART_pointcloud.laz')
lidR::plot(xx)
