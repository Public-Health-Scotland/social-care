#####################################################
## Home Care Data Preparation Script ##
#####################################################


# written and run on Rstudio server version 3.6.1
# written by: Jenny Armstrong
# 
# Script purpose: data cleaning
# This script picks up Home Care data files from SC analyst publication folder and 
# creates a new dataset to match the format required for the Home Care shiny app


###### load packages ######

library(tidyverse)  # tidyverse suite of packages for data wrangling and pipe operators (%>%)
library(janitor)    # clean_names function 
library(glue)       # used in file path set up
library(here)       # used in file path set up / to identify current working directory
library(haven)      # read in zsav files

###### specify file paths ######


data_type <- "3. Rounded Data"

# 1920 dashboard files saved at:
#\\Isdsf00d03\social-care\05-Analysts\Publication\Publication_1920_2021\homecare\3_Shiny_Data\2. Real Data

## File path for publication analysis data outputs 
publication_data_path <- glue("/conf/social-care/05-Analysts/Publication/Publication_1920_2021/Home_Care/3_Shiny_Data/", data_type, "/")

## File path for data to be saved to and picked up by shiny app 
# /conf/social-care/05-Analysts/Publication/Publication_1920_2021/Shiny Apps/home-care-shiny-app

shiny_app_data_path <- here("data/") 

###### Load in data #######


## load any .zsav files in publication data folder 

app_sav_file_names <- list.files(path = publication_data_path, pattern = "*zsav")

# apply the read.csv function to all files listed in the app_csv_file_name object,
# these data frames will then be held in the app_csv_data_files_list

app_sav_data_files_list <- lapply(paste0(publication_data_path, app_sav_file_names), haven::read_sav)

# assign names to data.frames (data frames should keep the original file name but remove ".zsav" from it)
# make_clean_names() function has also been used to make names lower case and replace blank spaces with "_"

names(app_sav_data_files_list) <- gsub(".zsav","", app_sav_file_names, fixed = TRUE) %>% 
  make_clean_names()

# create individual data file objects in the global environment, rather than keeping them as a list of data frames
# note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(app_sav_data_files_list), function(x) assign(x,app_sav_data_files_list[[x]],envir=.GlobalEnv)))




##############################################
##### Identify and remove any duplicates #####
##############################################
#### Trend data duplicates check ----
# data_homecare_trend
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_trend <- data_homecare_trend %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_trend") 

# remove duplicates from data - keep only unique rows 
data_homecare_trend <- unique(data_homecare_trend) 

# data_homecare_hscp ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_hscp <- data_homecare_hscp %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_hscp") 

# remove duplicates from data - keep only unique rows 
data_homecare_hscp <- unique(data_homecare_hscp) 

# data_homecare_locality -----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_locality <- data_homecare_locality %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_locality") 

# remove duplicates from data - keep only unique rows 
data_homecare_locality <- unique(data_homecare_locality) 

# data_homecare_client_group ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_client_group <- data_homecare_client_group %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_client_group") 

# remove duplicates from data - keep only unique rows 
data_homecare_client_group <- unique(data_homecare_client_group) 

# data_homecare_service_provider ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_service_provider <- data_homecare_service_provider %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_service_provider") 

# remove duplicates from data - keep only unique rows 
data_homecare_service_provider <- unique(data_homecare_service_provider) 

# data_homecare_hours_received -----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_hours_received <- data_homecare_hours_received %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_hours_received") 

# remove duplicates from data - keep only unique rows 
data_homecare_hours_received <- unique(data_homecare_hours_received) 

# data_homecare_hours_distribution ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_hours_distribution <- data_homecare_hours_distribution %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_hours_distribution") 

# remove duplicates from data - keep only unique rows 
data_homecare_hours_distribution <- unique(data_homecare_hours_distribution) 

# data_homecare_personal_care ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_personal_care <- data_homecare_personal_care %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_personal_care") 

# remove duplicates from data - keep only unique rows 
data_homecare_personal_care <- unique(data_homecare_personal_care) 

# data_homecare_alarms_telecare - renamed to data_homecare_tech_enabled_care ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_tech_enabled_care <- data_homecare_tech_enabled_care %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_tech_enabled_care") 

# remove duplicates from data - keep only unique rows 
data_homecare_tech_enabled_care <- unique(data_homecare_tech_enabled_care)

# data_homecare_hospital_adm # renamed data_homecare_emergency_care -----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_emergency_care <- data_homecare_emergency_care %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_emergency_care") 

# remove duplicates from data - keep only unique rows 
data_homecare_emergency_care <- unique(data_homecare_emergency_care) 

# data_homecare_simd  - renamed data_homecare_deprivation -----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_deprivation <- data_homecare_deprivation %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_deprivation") 

# remove duplicates from data - keep only unique rows 
data_homecare_deprivation <- unique(data_homecare_deprivation) 

# data_homecare_iorn ------
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_iorn <- data_homecare_iorn %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_iorn") 

# remove duplicates from data - keep only unique rows 
data_homecare_iorn <- unique(data_homecare_iorn) 

# data_referral_source -----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_homecare_referral_source <- data_homecare_referral_source %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_homecare_referral_source") 

# remove duplicates from data - keep only unique rows 
data_homecare_referral_source <- unique(data_homecare_referral_source)

#### save out duplicates for reference ----

# create table with all duplicates
duplicates_data_homecare <- rbind(duplicates_data_homecare_trend,
                                           duplicates_data_homecare_hscp,
                                           duplicates_data_homecare_locality,
                                           duplicates_data_homecare_client_group,
                                           duplicates_data_homecare_service_provider,
                                           duplicates_data_homecare_hours_received,
                                           duplicates_data_homecare_hours_distribution,
                                           duplicates_data_homecare_personal_care,
                                           duplicates_data_homecare_tech_enabled_care,
                                           duplicates_data_homecare_emergency_care,
                                           duplicates_data_homecare_deprivation,
                                           duplicates_data_homecare_iorn,
                                           duplicates_data_homecare_referral_source)

# save out duplicates for info in a csv file
write_csv(duplicates_data_homecare, glue(shiny_app_data_path, "duplicates_data_homecare.csv"))


##############################################
#### Format data to be used in shiny app #####
##############################################

### TREND DATA ----

data_homecare_trend <- data_homecare_trend %>%
  mutate(
    time_period       = as.character(time_period),
    time_period_order = dplyr::recode(time_period, 
                                      "Financial Quarter" = "A",
                                      "Financial Year" = "A",
                                      "Financial Year Quarter" = "A",
                                      "Census Week"       = "B"),
    financial_quarter = dplyr::recode(financial_quarter,
                                      "2010" = "2009/10",
                                      "2011" = "2010/11",
                                      "2012" = "2011/12",
                                      "2013" = "2012/13",
                                      "2014" = "2013/14",
                                      "2015" = "2014/15",
                                      "2016" = "2015/16",
                                      "2017" = "2016/17",
                                      "2018" = "2017/18",
                                      "2019" = "2018/19",
                                      "2020" = "2019/20",
                                      "2021" = "2020/21"),
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                     "All Areas Submitted"            = "A",
                                     "Scotland (All Areas Submitted)" = "A",
                                     "Scotland"                       = "A",
                                     "Scotland (Estimated)"           = "A"),
    age_group        = dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group        = as.character(age_group),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    measure          = dplyr::recode(measure, 
                                     'Number of hours' = "Number of Hours",
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     'Rate per 1,000 people' = "Rate per 1,000 Population",
                                     'Rate per 1000 people'  = "Rate per 1,000 Population",
                                     'Rate per 1000 People'  = "Rate per 1,000 Population",
                                     'Rate per 1,000 People' = "Rate per 1,000 Population"),
    measure          = as.character(measure),
    measure_order    = dplyr::recode(measure, 
                                     "Rate per 1,000 Population" = "A",
                                     "Number of People" = "B",
                                     "Number of Hours" = "C"),
    value            = as.numeric(round(value, 1))
    ) %>% 
  dplyr::arrange(time_period_order, time_period, financial_quarter, location_order, sending_location, age_order, age_group, measure_order) %>%     # sort data
  select(time_period, financial_quarter, sending_location, age_group, measure, value)                 # remove order variables

### HSCP DATA ----

data_homecare_hscp <- data_homecare_hscp %>%
  mutate(
    time_period       = as.character(time_period),
    time_period_order = dplyr::recode(time_period, 
                                      "Financial Quarter" = "A",
                                      "Financial Year" = "A",
                                      "Financial Year Quarter" = "A",
                                      "Census Week"       = "B"),
    financial_quarter = dplyr::recode(financial_quarter,
                                      "2010" = "2009/10",
                                      "2011" = "2010/11",
                                      "2012" = "2011/12",
                                      "2013" = "2012/13",
                                      "2014" = "2013/14",
                                      "2015" = "2014/15",
                                      "2016" = "2015/16",
                                      "2017" = "2016/17",
                                      "2018" = "2017/18",
                                      "2019" = "2018/19",
                                      "2020" = "2019/20",
                                      "2021" = "2020/21"),
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = 1,
                                      "Scotland (All Areas Submitted)" = 1,
                                      "Scotland"                       = 1,
                                      "Scotland (Estimated)"           = 1,
                                      "Aberdeen City"                  = 2,
                                      "Aberdeenshire"                  = 3,
                                      "Angus"                          = 4,
                                      "Argyll and Bute"                = 5,
                                      "City of Edinburgh"              = 6,
                                      "Clackmannanshire"               = 7,
                                      "Comhairle nan Eilean Siar"      = 8,
                                      "Dumfries and Galloway"          = 9,
                                      "Dundee City"                    = 10,
                                      "East Ayrshire"                  = 11,
                                      "East Dunbartonshire"            = 12,
                                      "East Lothian"                   = 13,
                                      "East Renfrewshire"              = 14,
                                      "Falkirk"                        = 15,
                                      "Fife"                           = 16,
                                      "Glasgow City"                   = 17,
                                      "Highland"                       = 18,
                                      "Inverclyde"                     = 19,
                                      "Midlothian"                     = 20,
                                      "Moray"                          = 21,
                                      "North Ayrshire"                 = 22,
                                      "North Lanarkshire"              = 23,
                                      "Orkney Islands"                 = 24,
                                      "Perth and Kinross"              = 25,
                                      "Renfrewshire"                   = 26,
                                      "Scottish Borders"               = 27,
                                      "Shetland"                       = 28,
                                      "South Ayrshire"                 = 29,
                                      "South Lanarkshire"              = 30,
                                      "Stirling"                       = 31,
                                      "West Dunbartonshire"            = 32,
                                      "West Lothian"                   = 33),
    age_group        = dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group        = as.character(age_group),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    measure          = dplyr::recode(measure, 
                                     'Number of hours' = "Number of Hours",
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     "Rate per 1,000 People" = "Rate per 1,000 Population",
                                     'Rate per 1,000 people' = "Rate per 1,000 Population",
                                     'Rate per 1000 people'  = "Rate per 1,000 Population",
                                     'Rate per 1000 People'  = "Rate per 1,000 Population"),
    measure = as.character(measure),
    measure_order    = dplyr::recode(measure, 
                                     "Rate per 1,000 Population" = "A",
                                     "Number of People" = "B",
                                     "Number of Hours" = "C"),
    value            = as.numeric(round(value,1)),
    scotland_value            = as.numeric(round(scot_value,1))) %>% 
  dplyr::arrange(time_period_order, time_period, financial_quarter, location_order, sending_location, age_order, age_group, measure_order) %>%     # sort data
  select(time_period, financial_quarter, sending_location, age_group, measure, value, scotland_value)                 # remove order variables

### LOCALITY DATA ----

data_homecare_locality <- data_homecare_locality %>%
  mutate(
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    locality = as.character(locality),
    age_group        = dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group        = as.character(age_group),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    measure          = dplyr::recode(measure, 
                                     'Number of hours' = "Number of Hours",
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     'Rate per 1,000 people' = "Rate per 1,000 People",
                                     'Rate per 1000 people'  = "Rate per 1,000 People",
                                     'Rate per 1000 People'  = "Rate per 1,000 People",
                                     "Rate per 1000 Population" = "Rate per 1,000 Population"),
    measure = as.character(measure),
    measure_order    = dplyr::recode(measure, 
                                     "Rate per 1,000 Population" = "A",
                                     "Number of People" = "B",
                                     "Number of Hours" = "C"),
    value            = as.numeric(round(value,1))) %>% 
  filter(!(locality == "Outside Partnership" & measure == "Rate per 1,000 Population")) %>%
  dplyr::arrange(financial_quarter, location_order, sending_location, locality, age_order, age_group, measure_order, measure) %>%     # sort data
  select(financial_quarter, sending_location, locality, age_group, measure, value)                 # remove order variables

### DEPRIVATION ----

data_homecare_deprivation <- data_homecare_deprivation %>% 
  mutate(
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = 1,
                                      "Scotland (All Areas Submitted)" = 1,
                                      "Scotland"                       = 1,
                                      "Scotland (Estimated)"           = 1,
                                      "Aberdeen City"                  = 2,
                                      "Aberdeenshire"                  = 3,
                                      "Angus"                          = 4,
                                      "Argyll and Bute"                = 5,
                                      "City of Edinburgh"              = 6,
                                      "Clackmannanshire"               = 7,
                                      "Comhairle nan Eilean Siar"      = 8,
                                      "Dumfries and Galloway"          = 9,
                                      "Dundee City"                    = 10,
                                      "East Ayrshire"                  = 11,
                                      "East Dunbartonshire"            = 12,
                                      "East Lothian"                   = 13,
                                      "East Renfrewshire"              = 14,
                                      "Falkirk"                        = 15,
                                      "Fife"                           = 16,
                                      "Glasgow City"                   = 17,
                                      "Highland"                       = 18,
                                      "Inverclyde"                     = 19,
                                      "Midlothian"                     = 20,
                                      "Moray"                          = 21,
                                      "North Ayrshire"                 = 22,
                                      "North Lanarkshire"              = 23,
                                      "Orkney Islands"                 = 24,
                                      "Perth and Kinross"              = 25,
                                      "Renfrewshire"                   = 26,
                                      "Scottish Borders"               = 27,
                                      "Shetland"                       = 28,
                                      "South Ayrshire"                 = 29,
                                      "South Lanarkshire"              = 30,
                                      "Stirling"                       = 31,
                                      "West Dunbartonshire"            = 32,
                                      "West Lothian"                   = 33),
    age_group        = as.character(dplyr::recode(age_group, 
                                                  'All ages' = "All Ages",
                                                  'all ages' = "All Ages",
                                                  '0-17' = "0-17 years",
                                                  '18-64' = "18-64 years",
                                                  '65-74' = "65-74 years",
                                                  '75-84' = "75-84 years",
                                                  '85+' = "85+ years",
                                                  '99999' = "Unknown")),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    deprivation  =  as.character(dplyr::recode(#simd,
                                              simd2020v2_ca2019_quintile,
                                              "1" = "1 (Most Deprived)",
                                              "2" = "2",
                                              "3" = "3",
                                              "4" = "4",
                                              "5" = "5 (Least Deprived)",
                                              "9" = "Unknown")),
    nclient            = as.numeric(round(nclient,0)),
    simd_percentage    = as.numeric(round(simd_percentage,1))) %>% 
  dplyr::arrange(financial_quarter, location_order, sending_location, age_order, age_group, deprivation) %>%     # sort data
  select(financial_quarter, sending_location, age_group, deprivation, simd_percentage, nclient)                 # remove order variables

### CLIENT GROUP DATA ----

data_homecare_client_group <- data_homecare_client_group %>%
  clean_names() %>% 
  mutate(
    time_period       = as.character(time_period),
    time_period_order = dplyr::recode(time_period, 
                                      "Financial Quarter" = "A",
                                      "Financial Year" = "A",
                                      "Financial Year Quarter" = "A",
                                      "Census Week"       = "B"),
    financial_quarter = dplyr::recode(financial_quarter,
                                      "2010" = "2009/10",
                                      "2011" = "2010/11",
                                      "2012" = "2011/12",
                                      "2013" = "2012/13",
                                      "2014" = "2013/14",
                                      "2015" = "2014/15",
                                      "2016" = "2015/16",
                                      "2017" = "2016/17",
                                      "2018" = "2017/18",
                                      "2019" = "2018/19",
                                      "2020" = "2019/20",
                                      "2021" = "2020/21"),
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group        = dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group        = as.character(age_group),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    client_group  = dplyr::recode(client_group, 
                                  "Elderly/Frail" = "Elderly / Frail",
                                  "Physical/Sensory Disability" = "Physical / Sensory Disability"),
    client_group = as.character(client_group),
    client_group_order = dplyr::recode(client_group, 
                                       "Dementia" = 1,
                                       "Elderly / Frail" = 2,
                                       "Learning Disability" = 3,
                                       "Mental Health" = 4,
                                       "Physical / Sensory Disability" =5,
                                       "Other" = 6,
                                       "Not Recorded" = 7),
    measure          = as.character(measure),
    measure_order    = dplyr::recode(measure, 
                                     "Rate per 1,000 People" = "A",
                                     "Number of People" = "B"),
    value            = as.numeric(round(value, 1))
    )%>% 
  filter(!(financial_quarter == "2021Q2")) %>%
  dplyr::arrange(time_period_order, time_period, financial_quarter, location_order, sending_location, age_order, age_group, client_group_order, client_group) %>%     # sort data
  select(time_period, financial_quarter, sending_location, age_group, client_group, measure, value)                 # remove order variables 
  

### SERVICE PROVIDER DATA ----

data_homecare_service_provider <- data_homecare_service_provider %>% 
  mutate(
    time_period       = as.character(time_period),
    time_period_order = dplyr::recode(time_period, 
                                      "Financial Quarter" = "A",
                                      "Financial Year" = "A",
                                      "Financial Year Quarter" = "A",
                                      "Census Week"       = "B"),
    financial_quarter = dplyr::recode(financial_quarter,
                                      "2010" = "2009/10",
                                      "2011" = "2010/11",
                                      "2012" = "2011/12",
                                      "2013" = "2012/13",
                                      "2014" = "2013/14",
                                      "2015" = "2014/15",
                                      "2016" = "2015/16",
                                      "2017" = "2016/17",
                                      "2018" = "2017/18",
                                      "2019" = "2018/19",
                                      "2020" = "2019/20",
                                      "2021" = "2020/21"),
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = 1,
                                      "Scotland (All Areas Submitted)" = 1,
                                      "Scotland"                       = 1,
                                      "Scotland (Estimated)"           = 1,
                                      "Aberdeen City"                  = 2,
                                      "Aberdeenshire"                  = 3,
                                      "Angus"                          = 4,
                                      "Argyll and Bute"                = 5,
                                      "City of Edinburgh"              = 6,
                                      "Clackmannanshire"               = 7,
                                      "Comhairle nan Eilean Siar"      = 8,
                                      "Dumfries and Galloway"          = 9,
                                      "Dundee City"                    = 10,
                                      "East Ayrshire"                  = 11,
                                      "East Dunbartonshire"            = 12,
                                      "East Lothian"                   = 13,
                                      "East Renfrewshire"              = 14,
                                      "Falkirk"                        = 15,
                                      "Fife"                           = 16,
                                      "Glasgow City"                   = 17,
                                      "Highland"                       = 18,
                                      "Inverclyde"                     = 19,
                                      "Midlothian"                     = 20,
                                      "Moray"                          = 21,
                                      "North Ayrshire"                 = 22,
                                      "North Lanarkshire"              = 23,
                                      "Orkney Islands"                 = 24,
                                      "Perth and Kinross"              = 25,
                                      "Renfrewshire"                   = 26,
                                      "Scottish Borders"               = 27,
                                      "Shetland"                       = 28,
                                      "South Ayrshire"                 = 29,
                                      "South Lanarkshire"              = 30,
                                      "Stirling"                       = 31,
                                      "West Dunbartonshire"            = 32,
                                      "West Lothian"                   = 33),
    age_group        = dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group        = as.character(age_group),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    hc_service_provider = as.character(hc_service_provider),
    nclient            = as.numeric(nclient),
    percentage         = as.numeric(round(percentage,1))) %>% 
  dplyr::arrange(location_order, sending_location, time_period_order, time_period, financial_quarter, age_order, age_group, hc_service_provider) %>%     # sort data
  select(time_period, financial_quarter, sending_location, age_group, hc_service_provider, nclient, percentage)                 # remove order variables


#######################################
### HOURS RECEIVED  ----

data_homecare_hours_received <- data_homecare_hours_received %>% 
  mutate(
         time_period       = as.character(time_period),
         time_period_order = dplyr::recode(time_period, "Financial Quarter" = "A",
                                                        "Financial Year Quarter" = "A",
                                                        "Financial Year" = "A",
                                                        "Census Week" = "B"),
         financial_quarter = dplyr::recode(financial_quarter,
                                           "2018" = "2017/18",
                                           "2019" = "2018/19",
                                           "2020" = "2019/20",
                                           "2021" = "2020/21"),
         financial_quarter = as.character(financial_quarter),
         sending_location  = dplyr::recode(sending_location, 
                                           "Argyll & Bute" = "Argyll and Bute",
                                           "Shetland" = "Shetland Islands"),
         sending_location  = as.character(sending_location),
         location_order    = dplyr::recode(sending_location, 
                                          "All Areas Submitted"            = 1,
                                          "Scotland (All Areas Submitted)" = 1,
                                          "Scotland"                       = 1,
                                          "Scotland (Estimated)"           = 1,
                                          "Aberdeen City"                  = 2,
                                          "Aberdeenshire"                  = 3,
                                          "Angus"                          = 4,
                                          "Argyll and Bute"                = 5,
                                          "City of Edinburgh"              = 6,
                                          "Clackmannanshire"               = 7,
                                          "Comhairle nan Eilean Siar"      = 8,
                                          "Dumfries and Galloway"          = 9,
                                          "Dundee City"                    = 10,
                                          "East Ayrshire"                  = 11,
                                          "East Dunbartonshire"            = 12,
                                          "East Lothian"                   = 13,
                                          "East Renfrewshire"              = 14,
                                          "Falkirk"                        = 15,
                                          "Fife"                           = 16,
                                          "Glasgow City"                   = 17,
                                          "Highland"                       = 18,
                                          "Inverclyde"                     = 19,
                                          "Midlothian"                     = 20,
                                          "Moray"                          = 21,
                                          "North Ayrshire"                 = 22,
                                          "North Lanarkshire"              = 23,
                                          "Orkney Islands"                 = 24,
                                          "Perth and Kinross"              = 25,
                                          "Renfrewshire"                   = 26,
                                          "Scottish Borders"               = 27,
                                          "Shetland Islands"               = 28,
                                          "South Ayrshire"                 = 29,
                                          "South Lanarkshire"              = 30,
                                          "Stirling"                       = 31,
                                          "West Dunbartonshire"            = 32,
                                          "West Lothian"                   = 33),
         age_group        = dplyr::recode(age_group, 
                                          'All ages' = "All Ages",
                                          'all ages' = "All Ages",
                                          '0-17' = "0-17 years",
                                          '18-64' = "18-64 years",
                                          '65-74' = "65-74 years",
                                          '75-84' = "75-84 years",
                                          '85+' = "85+ years",
                                          '99999' = "Unknown"),
         age_group        = as.character(age_group),
         age_order               = dplyr::recode(age_group, 
                                                 "All Ages" = 1,
                                                 "0-17 years"  = 2,
                                                 "18-64 years" = 3,
                                                 "65-74 years" = 4,
                                                 "75-84 years" = 5,
                                                 "85+ years"   = 6,
                                                 "Unknown"     = 7),
         level_of_service = dplyr::recode(level_of_service, 
                                          "0 - <2"  = "0 - <2 hours",
                                          "2 - <4"  = "2 - <4 hours",
                                          "4 - <10" = "4 - <10 hours",
                                          "10+"     = "10+ hours"),
         level_of_service = as.character(level_of_service),
         hours_order = dplyr::recode(level_of_service, 
                                     "0 - <2 hours"  = 1,
                                     "2 - <4 hours"  = 2,
                                     "4 - <10 hours" = 3,
                                     "10+ hours"     = 4,
                                     "Unknown"       = 5),
         nclient = as.numeric(nclient),
         percentage = as.numeric(round(percentage,1))) %>% 
  arrange(location_order, sending_location, time_period_order, time_period, financial_quarter, age_order, age_group, hours_order, level_of_service) %>% 
  select(time_period, financial_quarter, sending_location, age_group, level_of_service, hours_order, nclient, percentage)


################################
### HOURS DISTRIBUTION  ----

data_homecare_hours_distribution <-  data_homecare_hours_distribution %>% 
  mutate(
    time_period       = as.character(time_period),
    time_period_order = dplyr::recode(time_period, "Financial Quarter" = "A",
                                      "Financial Year Quarter" = "A",
                                      "Financial Year" = "A",
                                      "Census Week" = "B"),
    financial_quarter = dplyr::recode(financial_quarter,
                                      "2018" = "2017/18",
                                      "2019" = "2018/19",
                                      "2020" = "2019/20",
                                      "2021" = "2020/21"),
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute",
                                      "Shetland" = "Shetland Islands"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                     "All Areas Submitted"            = 1,
                                      "Scotland (All Areas Submitted)" = 1,
                                      "Scotland"                       = 1,
                                      "Scotland (Estimated)"           = 1,
                                      "Aberdeen City"                  = 2,
                                      "Aberdeenshire"                  = 3,
                                      "Angus"                          = 4,
                                      "Argyll and Bute"                = 5,
                                      "City of Edinburgh"              = 6,
                                      "Clackmannanshire"               = 7,
                                      "Comhairle nan Eilean Siar"      = 8,
                                      "Dumfries and Galloway"          = 9,
                                      "Dundee City"                    = 10,
                                      "East Ayrshire"                  = 11,
                                      "East Dunbartonshire"            = 12,
                                      "East Lothian"                   = 13,
                                      "East Renfrewshire"              = 14,
                                      "Falkirk"                        = 15,
                                      "Fife"                           = 16,
                                      "Glasgow City"                   = 17,
                                      "Highland"                       = 18,
                                      "Inverclyde"                     = 19,
                                      "Midlothian"                     = 20,
                                      "Moray"                          = 21,
                                      "North Ayrshire"                 = 22,
                                      "North Lanarkshire"              = 23,
                                      "Orkney Islands"                 = 24,
                                      "Perth and Kinross"              = 25,
                                      "Renfrewshire"                   = 26,
                                      "Scottish Borders"               = 27,
                                      "Shetland Islands"               = 28,
                                      "South Ayrshire"                 = 29,
                                      "South Lanarkshire"              = 30,
                                      "Stirling"                       = 31,
                                      "West Dunbartonshire"            = 32,
                                      "West Lothian"                   = 33),
    age_group        = as.character(dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown")),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
         hc_hours_category = as.character(dplyr::recode(hc_hours_category, '0 - <1' = "< 1 hour",
                                           '1 - <2' = "1 - <2 hours",
                                           '2 - <3' = "2 - <3 hours",
                                           '3 - <4' = "3 - <4 hours",
                                           '4 - <5' = "4 - <5 hours",
                                           '5 - <6' = "5 - <6 hours",
                                           '6 - <7' = "6 - <7 hours",
                                           '7 - <8' = "7 - <8 hours",
                                           '8 - <9' = "8 - <9 hours",
                                           '9 - <10' = "9 - <10 hours",
                                           '10 - <12'  = "10 - <12 hours",
                                           '12 - <14'  = "12 - <14 hours",
                                           '14 - <16'  = "14 - <16 hours",
                                           '16 - < 18' = "16 - <18 hours",
                                           '18 - < 20' = "18 - <20 hours",
                                           '20 - < 30' = "20 - <30 hours",
                                           '30 - < 40' = "30 - <40 hours",
                                           '40 - < 50' = "40 - <50 hours",
                                           '50 - < 60' = "50 - <60 hours",
                                           '60 - < 70' = "60 - <70 hours",
                                           '70 - < 80' = "70 - <80 hours",
                                           '80+'    = "80+ hours",
                                           'Unknown'= "Unknown")),
    hours_order = dplyr::recode(hc_hours_category, 
                                      "< 1 hour"     = 1,
                                      "1 - <2 hours" = 2,
                                      "2 - <3 hours" = 3,
                                      "3 - <4 hours" = 4,
                                      "4 - <5 hours" = 5,
                                      "5 - <6 hours" = 6,
                                      "6 - <7 hours" = 7,
                                      "7 - <8 hours" = 8,
                                      "8 - <9 hours" = 9,
                                      "9 - <10 hours" = 10,
                                      "10 - <12 hours" = 11,
                                      "12 - <14 hours" = 12,
                                      "14 - <16 hours" = 13,
                                      "16 - <18 hours" = 14,
                                      "18 - <20 hours" = 15,
                                      "20 - <30 hours" = 16,
                                      "30 - <40 hours" = 17,
                                      "40 - <50 hours" = 18,
                                      "50 - <60 hours" = 19,
                                      "60 - <70 hours" = 20,
                                      "70 - <80 hours" = 21,
                                      "80+ hours"      = 22,
                                      "Unknown"        = 23),
    nclient = as.numeric(nclient),
    percentage = as.numeric(round(percentage,1))) %>% 
  arrange(location_order, sending_location, time_period_order, time_period, financial_quarter, age_order, age_group, hours_order, hc_hours_category) %>% 
  select(time_period, financial_quarter, sending_location, age_group, hc_hours_category, hours_order, nclient, percentage)

############################
### PERSONAL CARE  ----

data_homecare_personal_care <- data_homecare_personal_care %>% 
  mutate(
    time_period       = as.character(time_period),
    time_period_order = dplyr::recode(time_period, "Financial Quarter" = "A",
                                      "Financial Year Quarter" = "A",
                                      "Financial Year" = "A",
                                      "Census Week" = "B"),
    financial_quarter = dplyr::recode(financial_quarter,
                                      "2018" = "2017/18",
                                      "2019" = "2018/19",
                                      "2020" = "2019/20",
                                      "2021" = "2020/21"),
    financial_quarter = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group        = as.character(dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown")),
    age_group       = as.character(age_group),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    nclient             = as.numeric(nclient),    
    percentage          = as.numeric(round(percentage, 1)),
    scotland_percentage = as.numeric(round(scot_percentage,1))
    ) %>% 
  arrange(time_period_order, time_period, financial_quarter, location_order, sending_location, age_order, age_group) %>% 
  select(time_period, financial_quarter, sending_location, age_group, nclient, percentage, scotland_percentage)


### TECHNOLOGY ENABLED CARE (previously named ALARMS & TELECARE/ EQUIPMENT)  ----

data_homecare_tech_enabled_care <- data_homecare_tech_enabled_care %>% 
  mutate(
    financial_year   = as.character(financial_year),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group        = as.character(dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown")),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    nclient             = as.numeric(nclient),     
    percentage          = as.numeric(round(percentage, 1)),
         scotland_percentage = round(scotland_percentage,1)
    ) %>% 
  arrange( financial_year, location_order, sending_location, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, nclient, percentage, scotland_percentage) 

### EMERGENCY CARE  ----

data_homecare_emergency_care <- data_homecare_emergency_care  %>% 
  mutate(
    financial_quarter   = as.character(financial_quarter),
    sending_location  = dplyr::recode(sending_location, 
                                      "Argyll & Bute" = "Argyll and Bute"),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group        =as.character(dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     'all ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown")),
    age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7),
    measure             = as.character(dplyr::recode(measure, 
                                        "A+E attendances" = "A&E Attendances",
                                        "A+E Attendances" = "A&E Attendances",
                                        "Emergency admissions" = "Emergency Admissions")),
    numerator             = as.numeric(round(numerator,0)),     
    rate          = as.numeric(round(rate, 1)),
    scotland_rate = as.numeric(round(scotland_rate, 1))
   ) %>% 
     arrange(financial_quarter, location_order, sending_location, age_order, age_group, measure) %>%    
  select(financial_quarter, sending_location, age_group, measure, numerator, rate, scotland_rate)

### REFERRAL SOURCE  ----

data_homecare_referral_source <- data_homecare_referral_source %>%
  janitor::clean_names() %>% 
  mutate(
    financial_quarter = as.character(financial_quarter),
    sending_location = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = 1,
                                      "Scotland (All Areas Submitted)" = 1,
                                      "Scotland"                       = 1,
                                      "Scotland (Estimated)"           = 1,
                                      "Aberdeen City"                  = 2,
                                      "Aberdeenshire"                  = 3,
                                      "Angus"                          = 4,
                                      "Argyll and Bute"                = 5,
                                      "City of Edinburgh"              = 6,
                                      "Clackmannanshire"               = 7,
                                      "Comhairle nan Eilean Siar"      = 8,
                                      "Dumfries and Galloway"          = 9,
                                      "Dundee City"                    = 10,
                                      "East Ayrshire"                  = 11,
                                      "East Dunbartonshire"            = 12,
                                      "East Lothian"                   = 13,
                                      "East Renfrewshire"              = 14,
                                      "Falkirk"                        = 15,
                                      "Fife"                           = 16,
                                      "Glasgow City"                   = 17,
                                      "Highland"                       = 18,
                                      "Inverclyde"                     = 19,
                                      "Midlothian"                     = 20,
                                      "Moray"                          = 21,
                                      "North Ayrshire"                 = 22,
                                      "North Lanarkshire"              = 23,
                                      "Orkney Islands"                 = 24,
                                      "Perth and Kinross"              = 25,
                                      "Renfrewshire"                   = 26,
                                      "Scottish Borders"               = 27,
                                      "Shetland"                       = 28,
                                      "South Ayrshire"                 = 29,
                                      "South Lanarkshire"              = 30,
                                      "Stirling"                       = 31,
                                      "West Dunbartonshire"            = 32,
                                      "West Lothian"                   = 33),
    age_group        = dplyr::recode(age_group, 
                                                  'All ages' = "All Ages",
                                                  'all ages' = "All Ages",
                                                  '0-17' = "0-17 years",
                                                  '18-64' = "18-64 years",
                                                  '65-74' = "65-74 years",
                                                  '75-84' = "75-84 years",
                                                  '85+' = "85+ years",
                                                  '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_group_order   = ordered(dplyr::recode(age_group, 
                                            "All Ages" = 1,
                                            "0-17 years"  = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years"   = 6,
                                            "Unknown"     = 7)),
    referral_source = as.character(referral_source),
    referral_source_order = dplyr::recode(referral_source,
                                          "999 Emergency Services" = 1,
                                          "GP" = 2,
                                          "Care Home" = 3,
                                          "Self Referral" = 4,
                                          "Other/Unknown" = 5),
    numerator = as.numeric(round(numerator,0)),
    percentage = as.numeric(round(percentage,1)),
    scotland_percentage = as.numeric(round(scotland_percentage,1))
  ) %>%
  dplyr::arrange(financial_quarter, location_order, sending_location, age_group_order, age_group, referral_source_order, 
                 referral_source) %>%     # sort data
  select(financial_quarter, sending_location, age_group, referral_source, percentage, numerator, scotland_percentage
         )                 # remove order variables
  


### Level of Independence (IoRN)  ----

data_homecare_iorn <- data_homecare_iorn %>% 
                      mutate(
                        financial_year    = as.character(financial_year),
                        sending_location  = dplyr::recode(sending_location, 
                                                          "Argyll & Bute" = "Argyll and Bute"),
                        sending_location = as.character(sending_location),
                        iorn_group        = as.character(dplyr::recode(iorn_group, "A" = "A (Most Independent)",
                                                                      "I" = "I (Least Independent)")),
                        hours_order       = as.numeric(dplyr::recode(level_of_service, '0 - <2 hours' = 1,
                                                                             '2 - <4 hours' = 2,
                                                                             '4 - <10 hours'= 3,
                                                                             '10+ hours'    = 4,
                                                                             'No home care record'= 5,
                                                          "Unknown" =6)),
                        level_of_service = as.character(dplyr::recode(level_of_service, '0 - <2' = '0 - <2 hours',
                                                                                  '2 - <4' = '2 - <4 hours',
                                                                                  '4 - <10'= '4 - <10 hours',
                                                                                  '10+'    = '10+ hours')),
                        nclient = as.numeric(nclient),
                        propn_iorn        = as.numeric(round(propn_iorn,1))) %>% 
  dplyr::arrange(financial_year, sending_location, hours_order, level_of_service) %>%     # sort data
                      select(financial_year, sending_location, iorn_group, hours_order, level_of_service, nclient, propn_iorn)


#############################################
##### Save out data files for shiny app #####
#############################################

# .rds files to be used in the global.R scripts

write_rds(data_homecare_trend, paste0(shiny_app_data_path, "data_homecare_trend.rds"))
write_rds(data_homecare_hscp, paste0(shiny_app_data_path, "data_homecare_hscp.rds"))
write_rds(data_homecare_tech_enabled_care, paste0(shiny_app_data_path, "data_homecare_tech_enabled_care.rds"))
write_rds(data_homecare_client_group, paste0(shiny_app_data_path, "data_homecare_client_group.rds"))
write_rds(data_homecare_emergency_care, paste0(shiny_app_data_path, "data_homecare_emergency_care.rds"))
write_rds(data_homecare_hours_distribution, paste0(shiny_app_data_path, "data_homecare_hours_distribution.rds"))
write_rds(data_homecare_hours_received, paste0(shiny_app_data_path, "data_homecare_hours_received.rds"))
write_rds(data_homecare_locality, paste0(shiny_app_data_path, "data_homecare_locality.rds"))
write_rds(data_homecare_personal_care, paste0(shiny_app_data_path, "data_homecare_personal_care.rds"))
write_rds(data_homecare_service_provider, paste0(shiny_app_data_path, "data_homecare_service_provider.rds"))
write_rds(data_homecare_deprivation, paste0(shiny_app_data_path, "data_homecare_deprivation.rds"))
write_rds(data_homecare_iorn, paste0(shiny_app_data_path, "data_homecare_iorn.rds"))
write_rds(data_homecare_referral_source, paste0(shiny_app_data_path, "data_homecare_referral_source.rds"))

### csv files for reference

write_csv(data_homecare_trend, paste0(shiny_app_data_path, "data_homecare_trend.csv"))
write_csv(data_homecare_hscp, paste0(shiny_app_data_path, "data_homecare_hscp.csv"))
write_csv(data_homecare_tech_enabled_care, paste0(shiny_app_data_path, "data_homecare_tech_enabled_care.csv"))
write_csv(data_homecare_client_group, paste0(shiny_app_data_path, "data_homecare_client_group.csv"))
write_csv(data_homecare_emergency_care, paste0(shiny_app_data_path, "data_homecare_emergency_care.csv"))
write_csv(data_homecare_hours_distribution, paste0(shiny_app_data_path, "data_homecare_hours_distribution.csv"))
write_csv(data_homecare_hours_received, paste0(shiny_app_data_path, "data_homecare_hours_received.csv"))
write_csv(data_homecare_locality, paste0(shiny_app_data_path, "data_homecare_locality.csv"))
write_csv(data_homecare_personal_care, paste0(shiny_app_data_path, "data_homecare_personal_care.csv"))
write_csv(data_homecare_service_provider, paste0(shiny_app_data_path, "data_homecare_service_provider.csv"))
write_csv(data_homecare_deprivation, paste0(shiny_app_data_path, "data_homecare_deprivation.csv"))
write_csv(data_homecare_iorn, paste0(shiny_app_data_path, "data_homecare_iorn.csv"))
write_csv(data_homecare_referral_source, paste0(shiny_app_data_path, "data_homecare_referral_source.csv"))
