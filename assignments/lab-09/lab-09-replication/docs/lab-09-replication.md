Lab 09 Replication Notebook
================
Christopher Prener, Ph.D.
(March 22, 2018)

Introduction
------------

This is the replication notebook for Lab 09 from the course SOC 4650/5650: Introduction to GISc.

Load Dependencies
-----------------

The following code loads the package dependencies for our analysis:

``` r
# tidyverse packages
library(dplyr)   # data
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(readr)   # work with csv files

# other packages
library(here)    # manage file paths
```

    ## here() starts at /Users/chris/GitHub/SOC5650/LectureRepos/lecture-10/assignments/lab-09

``` r
library(leaflet) # interactive mapping
library(sf)      # spatial data tools
```

    ## Linking to GEOS 3.6.1, GDAL 2.1.3, proj.4 4.9.3

Load Data
---------

We'll use data distributed with the `lecture-10` repository:

``` r
capitals <- read_csv(here("data", "stateCapitals.csv"))
```

    ## Parsed with column specification:
    ## cols(
    ##   name = col_character(),
    ##   description = col_character(),
    ##   latitude = col_double(),
    ##   longitude = col_double()
    ## )

Projecting State Capitals
-------------------------

The state capitals data contain four variables and a row for each of the 50 U.S. states:

``` r
glimpse(capitals)
```

    ## Observations: 50
    ## Variables: 4
    ## $ name        <chr> "Alabama", "Alaska", "Arizona", "Arkansas", "Calif...
    ## $ description <chr> "Montgomery", "Juneau", "Phoenix", "Little Rock", ...
    ## $ latitude    <dbl> 32.37772, 58.30160, 33.44814, 34.74661, 38.57667, ...
    ## $ longitude   <dbl> -86.30057, -134.42021, -112.09696, -92.28899, -121...

The `longitude` data is always the `x` variable and the `latitude` data is always the `y` variable. To project based on these two variables, we'll use the `st_as_sf()` function and assign the output to a new object:

``` r
capitals_sf <- st_as_sf(capitals, coords = c(x = "longitude", y = "latitude"), crs = 4326)
```

Note that we used the `WGS 1984` coordinate system initially so that we don't get errors from `leaflet`. We'll use `leaflet` to test our projected point data and make sure that the markers appear over state capitals:

``` r
leaflet() %>%
  addTiles() %>%
  addMarkers(data = capitals)
```

    ## Assuming 'longitude' and 'latitude' are longitude and latitude, respectively

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-b0c2a95c236846393b59">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addMarkers","args":[[32.377716,58.301598,33.448143,34.746613,38.576668,39.739227,41.764046,39.157307,21.307442,30.438118,33.749027,43.617775,39.798363,39.768623,41.591087,39.048191,38.186722,30.457069,44.307167,38.978764,42.358162,42.733635,44.955097,32.303848,38.579201,46.585709,40.808075,39.163914,43.206898,40.220596,35.68224,35.78043,46.82085,42.652843,39.961346,35.492207,44.938461,40.264378,41.830914,34.000343,44.367031,36.16581,30.27467,40.777477,44.262436,37.538857,47.035805,38.336246,43.074684,41.140259],[-86.300568,-134.420212,-112.096962,-92.288986,-121.493629,-104.984856,-72.682198,-75.519722,-157.857376,-84.281296,-84.388229,-116.199722,-89.654961,-86.162643,-93.603729,-95.677956,-84.875374,-91.187393,-69.781693,-76.490936,-71.063698,-84.555328,-93.102211,-90.182106,-92.172935,-112.018417,-96.699654,-119.766121,-71.537994,-74.769913,-105.939728,-78.639099,-100.783318,-73.757874,-82.999069,-97.503342,-123.030403,-76.883598,-71.414963,-81.033211,-100.346405,-86.784241,-97.740349,-111.888237,-72.580536,-77.43364,-122.905014,-81.612328,-89.384445,-104.820236],null,null,null,{"clickable":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,null,null,null]}],"limits":{"lat":[21.307442,58.301598],"lng":[-157.857376,-69.781693]}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
With our data visually verified, we can go ahead and (1) re-project them from `WGS 1984` to `NAD 1983` and then (2) export them to our project's `data/` directory.

``` r
capitals_sf %>%
  st_transform(crs = 4269) %>%
  st_write(here("data", "US_CAPITALS", "US_CAPITALS.shp"), delete_dsn = TRUE)
```

    ## Warning in abbreviate_shapefile_names(obj): Field names abbreviated for
    ## ESRI Shapefile driver

    ## Deleting source `/Users/chris/GitHub/SOC5650/LectureRepos/lecture-10/assignments/lab-09/data/US_CAPITALS/US_CAPITALS.shp' using driver `ESRI Shapefile'
    ## Writing layer `US_CAPITALS' to data source `/Users/chris/GitHub/SOC5650/LectureRepos/lecture-10/assignments/lab-09/data/US_CAPITALS/US_CAPITALS.shp' using driver `ESRI Shapefile'
    ## features:       50
    ## fields:         2
    ## geometry type:  Point

Notice how we can pipe these functions - the `sf` package allows us to use `%>%` to pass `sf` object names through functions. Since we are using a function that writes to our hard disk, we do not need to include an outgoing assignment to an object at the end of the pipe.
