# global R script
# Script defines items required in both server and ui scripts to prevent duplictaion
# sc publication data docs
# \\Isdsf00d03\social-care\05-Analysts\Publication\Shiny outputs\Final Publication Outputs

# datasets and anything that will be used both by UI and server
# packages and functions have been saved in seperate .R script files but will be loaded here

################################.
## Load Packages & Functions----
################################.

source("packages.R")
#source("functions.R")

###############################################.
## Data ----
###############################################.    

# load main dataset 
sc_data <- read_rds("data/sc_data.rds")

# techdoc <- readRDS("data/techdoc.rds") #technical documents data including definitions

###############################################.
## Names ----
###############################################.   
#Geographies names
#area_list <- sort(geo_lookup$areaname)
#comparator_list <- sort(geo_lookup$areaname[geo_lookup$areatype %in% 
#                                              c("Council area", "Scotland")]) 
#code_list <- unique(sc_data$code)
# parent_geo_list <- c("Show all", sort(as.character((unique(sc_data$parent_area))[-1])))
# parent_iz_list <- geo_lookup %>% filter(areatype=="Intermediate zone") %>% select(areaname,parent_area)
# parent_hscl_list <- geo_lookup %>% filter(areatype=="HSC locality") %>% select(areaname,parent_area)
#la_name <- sort(geo_lookup$areaname[geo_lookup$areatype=="Council area"]) 


# time period (year)
min_year <- min(sc_data$year)
max_year <- max(sc_data$year)

#Area type names
#areatype_list <- c("Council area", "Scotland")

# local authority names

la_name_list <- sort(unique(sc_data$la_name))


# Data Source Names 

sc_data_list <- sort(unique(sc_data$sc_data_source))

#indicator_map_list <- sort(unique(sc_data$indicator[sc_data$interpret != 'O']))
#sc_data_sources_updated <- techdoc %>% filter(days_since_update<60) %>% pull(sc_data_source_name)