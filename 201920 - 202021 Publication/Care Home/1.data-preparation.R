#####################################################
## Care Home Data Preparation Script ##
#####################################################


# written and run on Rstudio server version 3.6.1
# written by: Jenny Armstrong
# latest update: 03/02/2022
# Script purpose: data cleaning
# This script picks up Care Home data files from SC analyst publication folder and 
# creates a new dataset to match the format required for the Care Home shiny app



###### load packages ######

library(tidyverse)  # tidyverse suite of packages for data wrangling and pipe operators (%>%)
library(janitor)    # clean_names function 
library(glue)       # used in file path set up
library(here)       # used in file path set up / to identify current working directory
library(haven)      # read in .zsav and .sav files

###### specify file paths ######


data_type <- "3. Rounded Data"

# 1920 dashboard files saved at:
#\\Isdsf00d03\social-care\05-Analysts\Publication\Publication_1920_2021\Care_Home\3_Shiny_Data\2. Real Data

## File path for publication analysis data outputs 
publication_data_path <- glue("/conf/social-care/05-Analysts/Publication/Publication_1920_2021/Care_Home/3_Shiny_Data/", data_type, "/")

## File path for data to be saved to and picked up by shiny app 
# /conf/social-care/05-Analysts/Publication/Publication_1920_2021/Shiny Apps/care-home-shiny-app

shiny_app_data_path <- here("data/") 

###### Load in data #######

## load any .csv file in publication dashboard data folder 
# list all files which include with a csv file extension (this will also capture .zsav extension files) 

dashboard_sav_file_names <- list.files(path = publication_data_path, pattern = "*sav")

# apply the read_sav function to all files listed in the dashboard_sav_file_name object,
# these data frames will then be held in the dashboard_sav_data_files_list

dashboard_sav_data_files_list <- lapply(paste0(publication_data_path, dashboard_sav_file_names), read_sav)

#assign names to data.frames (data frames should keep the original file name but remove ".sav" from it)
# make_clean_names() function has also been used to make names lower case and replace blank spaces with "_"

names(dashboard_sav_data_files_list) <- gsub(".sav","", dashboard_sav_file_names, fixed = TRUE) %>% 
  make_clean_names()

# create individual data file objects in the global environment, rather than keeping them as a list of data frames
# note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(dashboard_sav_data_files_list), function(x) assign(x,dashboard_sav_data_files_list[[x]],envir=.GlobalEnv)))


## rename some files

data_care_home_resident_type <- data_care_home_short_long_stay 
rm(data_care_home_short_long_stay)

data_care_home_emergency_care <- data_care_home_emergency_care_zsav
rm(data_care_home_emergency_care_zsav)

data_care_home_iorn <- data_care_home_iorn_zsav
rm(data_care_home_iorn_zsav)

data_care_home_referral_source <- data_care_home_referral_source_zsav
rm(data_care_home_referral_source_zsav)

##############################################
##### Identify and remove any duplicates #####
##############################################
#### Resident Type duplicates checks ----
# data_care_home_resident_type
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_resident_type <- data_care_home_resident_type %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_care_home_resident_type") 

# remove duplicates from data - keep only unique rows 
data_care_home_resident_type <- unique(data_care_home_resident_type) 

#### Trend data duplicates check ----
# data_homecare_trend
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_trend <- data_care_home_trend %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_care_home_trend") 

# remove duplicates from data - keep only unique rows 
data_care_home_trend <- unique(data_care_home_trend) 

#### Age & Sex duplicates check ----
# data_care_home_age_sex
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_age_sex <- data_care_home_age_sex %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_care_home_age_sex") 

# remove duplicates from data - keep only unique rows 
data_care_home_age_sex <- unique(data_care_home_age_sex) 

#### Length of Stay duplicates check ----
# data_care_home_length_of_stay
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_length_of_stay <- data_care_home_length_of_stay %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_care_home_length_of_stay") 

# remove duplicates from data - keep only unique rows 
data_care_home_length_of_stay <- unique(data_care_home_length_of_stay) # 0 rows of data have been removed

#### Nursing Care duplicates check ----
# data_care_home_nursing_care
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_nursing_care <- data_care_home_nursing_care %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_care_home_nursing_care") 

# remove duplicates from data - keep only unique rows 
data_care_home_nursing_care <- unique(data_care_home_nursing_care) 

#### Emergency Care duplicates check ----
# data_care_home_emergency_care
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_emergency_care <- data_care_home_emergency_care %>% janitor::get_dupes() %>%
  mutate(data_set = "data_care_home_emergency_care")

# remove duplicates from data - keep only unique rows
data_care_home_emergency_care <- unique(data_care_home_emergency_care) 

#### Iorn duplicates check ----
# data_care_home_iorn
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_iorn <- data_care_home_iorn %>% janitor::get_dupes() %>%
  mutate(data_set = "data_care_home_iorn")

# remove duplicates from data - keep only unique rows 
data_care_home_iorn <- unique(data_care_home_iorn) # 0 rows of data have been removed

#### Referral Source duplicates check ----
# data_care_home_referral_source

# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_care_home_referral_source <- data_care_home_referral_source %>% janitor::get_dupes() %>%
  mutate(data_set = "data_care_home_referral_source")

# remove duplicates from data - keep only unique rows 
data_care_home_referral_source <- unique(data_care_home_referral_source) 


#### Create a duplicates file & save out for reference ----

# create table with all duplicates
duplicates_data_care_home <- rbind(
                                  duplicates_data_care_home_resident_type,
                                  duplicates_data_care_home_trend,
                                  duplicates_data_care_home_age_sex,
                                  duplicates_data_care_home_length_of_stay,
                                  duplicates_data_care_home_nursing_care,
                                  duplicates_data_care_home_emergency_care,
                                  duplicates_data_care_home_iorn,
                                  duplicates_data_care_home_referral_source)

# save out duplicates for info in a csv file
write_csv(duplicates_data_care_home, glue(shiny_app_data_path, "duplicates_data_care_home.csv"))


###############################################
##### Format data to be used in shiny app #####
###############################################
#### RESIDENT TYPE DATA -----

data_care_home_resident_type <- data_care_home_resident_type %>% 
  mutate( 
    financial_year    = as.character(financial_year),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group         = dplyr::recode(age_group, 
                                      'All ages' = "All Ages",
                                      'all ages' = "All Ages",
                                      '0-17' = "0-17 years",
                                      '18-64' = "18-64 years",
                                      "18plus" = "18+ years",
                                      '65-74' = "65-74 years",
                                      "65plus" = "65+ years",
                                      '75-84' = "75-84 years",
                                      '85plus' = "85+ years",
                                      '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_group_order   = ordered(dplyr::recode(age_group, 
                                              "All Ages" = 1, 
                                              "0-17 years" = 2,
                                              "18-64 years" = 3,
                                              "65-74 years" = 4,
                                              "75-84 years" = 5,
                                              "85+ years" = 6,
                                              "Unknown" = 7)),
    stay_type         = dplyr::recode(stay_type,
                                      "All Stay Types" = "All Stays",
                                      "all stays" = "All Stays",
                                      "Long Stays" = "Long Stay",
                                      "Short Stay" = "Short Stay / Respite"),
    stay_type         = as.character(stay_type),
    stay_type_order  = dplyr::recode(stay_type, 
                                             "All Stays" = 1,
                                             "Short Stay / Respite" = 2,
                                             "Long Stay" = 3),
    measure          = dplyr::recode(measure, 
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     'Rate per 1,000 people' = "Rate per 1,000 People",
                                     'Rate per 1000 people'  = "Rate per 1,000 People",
                                     'Rate per 1000 People'  = "Rate per 1,000 People"),
    measure           = as.character(measure),
    measure_order        = dplyr::recode(measure,
                                         "Rate per 1,000 People" = 1,
                                         "Number of People" = 2),
    value           = as.numeric(round(value,1)),
    value_scotland  = as.numeric(round(value_scotland, 1))) %>% 
  dplyr::arrange(financial_year, location_order, sending_location, age_group_order, age_group, stay_type_order, stay_type, measure_order, measure) %>% 
  select(financial_year, sending_location, age_group, stay_type, measure, value, value_scotland) 

#### TREND DATA  ---- 

data_care_home_trend <- data_care_home_trend %>% 
mutate( 
  financial_quarter = as.character(financial_quarter),
  sending_location  = as.character(sending_location),
  sending_location = recode(sending_location, 
                            # all areas submitted as WI have never submitted CH so cannot estimate scotland
                            "Scotland Estimated" = "Scotland (All Areas Submitted)"),
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
  age_group         = dplyr::recode(age_group, 
                                    'All ages' = "All Ages",
                                    'all ages' = "All Ages",
                                    '0-17' = "0-17 years",
                                    '18-64' = "18-64 years",
                                    "18plus" = "18+ years",
                                    '65-74' = "65-74 years",
                                    "65plus" = "65+ years",
                                    '75-84' = "75-84 years",
                                    '85plus' = "85+ years",
                                    '99999' = "Unknown"),
  age_group         = as.character(age_group),
  age_group_order   = ordered(dplyr::recode(age_group, 
                                            "All Ages" = 1, 
                                            "0-17 years" = 2,
                                            "18-64 years" = 3,
                                            "65-74 years" = 4,
                                            "75-84 years" = 5,
                                            "85+ years" = 6,
                                            "Unknown" = 7)),
  stay_type         = dplyr::recode(stay_type,
                                    "All Stay Types" = "All Stays",
                                    "all stays" = "All Stays",
                                    "Long Stays" = "Long Stay",
                                    "Short Stay" = "Short Stay / Respite"),
  stay_type         = as.character(stay_type),
  stay_type_order  = dplyr::recode(stay_type, 
                                   "All Stays" = 1,
                                   "Short Stay / Respite" = 2,
                                   "Long Stay" = 3),
  measure          = dplyr::recode(measure, 
                                   'Number of people' = "Number of People",
                                   'number of people' = "Number of People",
                                   'Rate per 1,000 people' = "Rate per 1,000 People",
                                   'Rate per 1000 people'  = "Rate per 1,000 People",
                                   'Rate per 1000 People'  = "Rate per 1,000 People"),
  measure           = as.character(measure),
  measure_order        = dplyr::recode(measure,
                                       "Rate per 1,000 People" = 1,
                                       "Number of People" = 2),
  value           = as.numeric(round(value,1)),
  pop             = as.numeric(round(pop, 0))
    ) %>% 
  dplyr::arrange(location_order, sending_location, financial_quarter, age_group_order, age_group, stay_type_order, stay_type, measure_order, measure) %>% 
  select(financial_quarter, sending_location, age_group, stay_type, measure, value) %>%
  # GC submitted census week aggregated data in 2017/18 therefore unable to provide a quarterly count in the graph for Q4 17/18 
  # remove 0 values as does not make sense to have 0 people in CH
  filter(!(financial_quarter == "2017/18 Q4" & sending_location == "Glasgow City"))

#### AGE & SEX DATA ----

data_care_home_age_sex <- data_care_home_age_sex %>% 
  mutate( 
    financial_year    = as.character(financial_year),
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
    sex               = dplyr::recode(sex,
                                      "FEMALE" = "Female",
                                      "female" = "Female",
                                      "MALE"   = "Male",
                                      "male"   = "Male",
                                      "NOT KNOWN / UNSPECIFIED" = "Not Known / Unspecified"),
    sex               = as.character(sex),
    sex_order         = dplyr::recode(sex,
                                      "Female" = 1,
                                      "Male"   = 2,
                                      "Not Known / Unspecified" = 3),
    age_group         = dplyr::recode(age_group, 
                                      'All ages' = "All Ages",
                                      'all ages' = "All Ages",
                                      '0-17' = "0-17 years",
                                      '18-64' = "18-64 years",
                                      "18plus" = "18+ years",
                                      '65-74' = "65-74 years",
                                      "65plus" = "65+ years",
                                      '75-84' = "75-84 years",
                                      '85plus' = "85+ years",
                                      '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_group_order   = ordered(dplyr::recode(age_group, 
                                              "All Ages" = 1, 
                                              "0-17 years" = 2,
                                              "18-64 years" = 3,
                                              "65-74 years" = 4,
                                              "75-84 years" = 5,
                                              "85+ years" = 6,
                                              "Unknown" = 7)),
    stay_type         = dplyr::recode(stay_type,
                                      "All Stay Types" = "All Stays",
                                      "all stays" = "All Stays",
                                      "Long Stays" = "Long Stay",
                                      "Short Stay" = "Short Stay / Respite"),
    stay_type         = as.character(stay_type),
    stay_type_order  = dplyr::recode(stay_type, 
                                     "All Stays" = 1,
                                     "Short Stay / Respite" = 2,
                                     "Long Stay" = 3),
    nclient         = as.numeric(round(nclient, 0)),
    rate            = as.numeric(round(rate, 1))) %>% 
  dplyr::arrange(location_order, sending_location, financial_year, stay_type_order, stay_type, age_group_order, age_group, sex_order, sex) %>% 
  select(financial_year, sending_location, stay_type, age_group, sex, rate, nclient) 

#### LENGTH OF STAY -----

data_care_home_length_of_stay <- data_care_home_length_of_stay %>% 
  mutate( 
    financial_year    = as.character(financial_year),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group         = dplyr::recode(age_group, 
                                      'All ages' = "All Ages",
                                      'all ages' = "All Ages",
                                      '0-17' = "0-17 years",
                                      '18-64' = "18-64 years",
                                      "18plus" = "18+ years",
                                      '65-74' = "65-74 years",
                                      "65plus" = "65+ years",
                                      '75-84' = "75-84 years",
                                      '85plus' = "85+ years",
                                      '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_group_order   = ordered(dplyr::recode(age_group, 
                                              "All Ages" = 1, 
                                              "0-17 years" = 2,
                                              "18-64 years" = 3,
                                              "65-74 years" = 4,
                                              "75-84 years" = 5,
                                              "85+ years" = 6,
                                              "Unknown" = 7)),
    stay_type         = as.character(stay_type),
    stay_type_order  = dplyr::recode(stay_type, 
                                     "All Stays" = 1,
                                     "Short Stay / Respite" = 2,
                                     "Long Stay" = 3),
    median_los = as.numeric(round(median_los, 1)),
    scotland_median_los = as.numeric(round(scotland_median_los,1))
    ) %>%  
  dplyr::arrange(financial_year, location_order, sending_location, age_group_order, age_group, stay_type_order, stay_type) %>% 
  select(financial_year, sending_location, age_group, stay_type, median_los, scotland_median_los) 

#### NURSING CARE DATA ----

data_care_home_nursing_care <- data_care_home_nursing_care %>% 
  mutate( 
    financial_year    = as.character(financial_year),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group         = dplyr::recode(age_group, 
                                      'All ages' = "All Ages",
                                      'all ages' = "All Ages",
                                      '0-17' = "0-17 years",
                                      '18-64' = "18-64 years",
                                      "18plus" = "18+ years",
                                      '65-74' = "65-74 years",
                                      "65plus" = "65+ years",
                                      '75-84' = "75-84 years",
                                      '85plus' = "85+ years",
                                      '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_group_order   = ordered(dplyr::recode(age_group, 
                                              "All Ages" = 1, 
                                              "0-17 years" = 2,
                                              "18-64 years" = 3,
                                              "65-74 years" = 4,
                                              "75-84 years" = 5,
                                              "85+ years" = 6,
                                              "Unknown" = 7)),
    nursing_care_provision = as.character(nursing_care_provision),
    nursing_care_order     = dplyr::recode(nursing_care_provision,
                                           "Stays with Nursing Provision" = 1, 
                                           "Stays with no Nursing Provision" = 2),
    number_nc_provision = as.numeric(round(number_nc_provision,0)),
    propn_nc_provision  = as.numeric(round(propn_nc_provision,1))) %>%  
  dplyr::arrange(financial_year, location_order, sending_location, age_group_order, age_group, nursing_care_order) %>% 
  select(financial_year, sending_location, age_group, nursing_care_provision, number_nc_provision, propn_nc_provision) 


#### EMERGENCY ADMISSIONS DATA  -----


data_care_home_emergency_care <- data_care_home_emergency_care %>% 
  mutate( 
    financial_quarter = as.character(financial_quarter),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"            = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    age_group         = dplyr::recode(age_group, 
                                      'All ages' = "All Ages",
                                      'all ages' = "All Ages",
                                      '0-17' = "0-17 years",
                                      '18-64' = "18-64 years",
                                      "18plus" = "18+ years",
                                      '65-74' = "65-74 years",
                                      "65plus" = "65+ years",
                                      '75-84' = "75-84 years",
                                      '85plus' = "85+ years",
                                      '85+' = "85+ years",
                                      '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_group_order   = ordered(dplyr::recode(age_group, 
                                              "All Ages" = 1, 
                                              "0-17 years" = 2,
                                              "18-64 years" = 3,
                                              "65-74 years" = 4,
                                              "75-84 years" = 5,
                                              "85+ years" = 6,
                                              "Unknown" = 7)),
    measure             = as.character(dplyr::recode(measure, 
                                                     "A+E attendances" = "A&E Attendances",
                                                     "A+E Attendances" = "A&E Attendances",
                                                     "Emergency admissions" = "Emergency Admissions",
                                                     "Emergency Admissions Bed Days" = "Emergency Admissions Bed Days")),
    measure           = as.character(measure),
    measure_order        = dplyr::recode(measure,
                                         "A&E Attendances" = 1,
                                         "Emergency Admissions" = 2,
                                         "Emergency Admissions Bed Days" = 3),
    value           = as.numeric(round(value,0)),
    scotland_value  = as.numeric(round(scot_value,0)),
    rate            = as.numeric(round(rate_per_1000,1)),
    scotland_rate   = as.numeric(round(scotland_rate,1))) %>%  
  dplyr::arrange(financial_quarter, location_order, sending_location, age_group_order, age_group, measure_order, measure) %>% 
  select(financial_quarter, sending_location, age_group, measure, value, scotland_value, rate, scotland_rate) 

#### REFERRAL SOURCE DATA - NEW DATA SET 2022 -----

data_care_home_referral_source <- data_care_home_referral_source %>%
  janitor::clean_names() %>% 
  mutate(
    financial_quarter = as.character(financial_quarter),
    sending_location = as.character(sending_location),
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
                                     '85plus' = "85+ years",
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
    referrals = as.numeric(round(value,0)),
    percentage = as.numeric(round(percentage,1)),
    scotland_referrals = as.numeric(round(scot_value,1)),
    scotland_percentage = as.numeric(round(scot_percentage,0))
  ) %>%
  dplyr::arrange(financial_quarter, location_order, sending_location, age_group_order, age_group, referral_source_order, referral_source) %>%     
  select(financial_quarter, sending_location, age_group, referral_source, referrals, percentage, scotland_referrals, scotland_percentage)


#### IORN DATA -----


data_care_home_iorn <- data_care_home_iorn %>% 
  mutate(
    financial_year    = as.character(financial_year),
    sending_location  = as.character(sending_location),
    location_order    = dplyr::recode(sending_location, 
                                      "All Areas Submitted"           = "A",
                                      "Scotland (All Areas Submitted)" = "A",
                                      "Scotland"                       = "A",
                                      "Scotland (Estimated)"           = "A"),
    iorn_group        = dplyr::recode(iorn_group, 
                                      'A' = "A (Most Independent)",
                                      'I' = "I (Least Independent)"),
    iorn_group = as.character(iorn_group),
    nclient           = as.numeric(round(nclient, 0)),
    propn_iorn        = as.numeric(round(prop_iorn, 1))
  ) %>% 
  dplyr::arrange(financial_year, location_order, 
                 sending_location, 
                 iorn_group) %>% 
  select(financial_year, sending_location, iorn_group, nclient, propn_iorn)

#############################################
##### Save out data files for shiny app #####
#############################################

# .rds files to be used in the global.R scripts

write_rds(data_care_home_resident_type, paste0(shiny_app_data_path, "data_care_home_resident_type.rds"))
write_rds(data_care_home_trend, paste0(shiny_app_data_path, "data_care_home_trend.rds"))
write_rds(data_care_home_age_sex, paste0(shiny_app_data_path, "data_care_home_age_sex.rds"))
write_rds(data_care_home_length_of_stay, paste0(shiny_app_data_path, "data_care_home_length_of_stay.rds"))
write_rds(data_care_home_nursing_care, paste0(shiny_app_data_path, "data_care_home_nursing_care.rds"))
write_rds(data_care_home_emergency_care, paste0(shiny_app_data_path, "data_care_home_emergency_care.rds"))
write_rds(data_care_home_iorn, paste0(shiny_app_data_path, "data_care_home_iorn.rds"))
write_rds(data_care_home_referral_source, paste0(shiny_app_data_path, "data_care_home_referral_source.rds"))

### csv files for reference

write_csv(data_care_home_resident_type, paste0(shiny_app_data_path, "data_care_home_resident_type.csv"))
write_csv(data_care_home_trend, paste0(shiny_app_data_path, "data_care_home_trend.csv"))
write_csv(data_care_home_age_sex, paste0(shiny_app_data_path, "data_care_home_age_sex.csv"))
write_csv(data_care_home_length_of_stay, paste0(shiny_app_data_path, "data_care_home_length_of_stay.csv"))
write_csv(data_care_home_nursing_care, paste0(shiny_app_data_path, "data_care_home_nursing_care.csv"))
write_csv(data_care_home_emergency_care, paste0(shiny_app_data_path, "data_care_home_emergency_care.csv"))
write_csv(data_care_home_iorn, paste0(shiny_app_data_path, "data_care_home_iorn.csv"))
write_csv(data_care_home_referral_source, paste0(shiny_app_data_path, "data_care_home_referral_source.csv"))

