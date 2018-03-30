library(here)
library(tigris)
library(sf)
library(stringr)

counties <- counties(cb = TRUE, resolution = "20m")
counties %>% 
  st_as_sf() %>%
  mutate(GEOID = str_c(STATEFP, COUNTYFP)) %>%
  select(GEOID, STATEFP, COUNTYFP, NAME, ALAND) -> countiesClean


