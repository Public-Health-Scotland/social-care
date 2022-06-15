##############################################
## People Supported Data Preparation Script ##
##############################################


## data preparation
## picks up files from SC analysts and prepares them to be used in global.R script and read in to shiny app

# This script picks up client data files from SC analyst publication folder and 
# creates a new dataset to match the format required for the people supported shiny app

###### load packages ######

library(tidyverse)  # tidyverse suite of packages for data wrangling and pipe operators (%>%)
library(haven)      # read in .sav or .zsav files
library(janitor)    # clean_names function 
library(glue)       # used in file path set up
library(here)



publication_year <- "1920_2021"



###### specify file paths ######

data_type <- "3. Rounded Data"


# 1920 dashboard files saved at:
#\\Isdsf00d03\social-care\05-Analysts\Publication\Publication_1920_2021\Client\3_Shiny_Data\

## File path for publication analysis data outputs 
publication_data_path <- glue("/conf/social-care/05-Analysts/Publication/Publication_1920_2021/Client/3_Shiny_Data/", data_type, "/")

## File path for data to be saved to and picked up by shiny app 
#/conf/social-care/05-Analysts/Publication/Publication_1920_2021/Shiny Apps/people-supported-shiny-app

shiny_app_data_path <- here("data/") 


###### Load in data #######

## load any .sav / zsav file in publication dashboard data folder 
# list all files which include with a sav file extension (this will also capture .zsav extension files) 

dashboard_sav_file_names <- list.files(path = publication_data_path, pattern = "*sav")

# apply the read_sav function to all files listed in the dashboard_sav_file_name object,
# these data frames will then be held in the dashboard_sav_data_files_list

dashboard_sav_data_files_list <- lapply(paste0(publication_data_path, dashboard_sav_file_names), haven::read_sav)

#assign names to data.frames (data frames should keep the original file name but remove ".zsav" from it)
# make_clean_names() function has also been used to make names lower case and replace blank spaces with "_"

names(dashboard_sav_data_files_list) <- gsub(".sav","", dashboard_sav_file_names, fixed = TRUE) %>% 
  make_clean_names()

# create individual data file objects in the global environment, rather than keeping them as a list of data frames
# note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(dashboard_sav_data_files_list), function(x) assign(x,dashboard_sav_data_files_list[[x]],envir=.GlobalEnv)))



##############################################
##### Identify and remove any duplicates #####
##############################################.

#### Trend data duplicates check ----
# identify duplicates create a new data table to store them
duplicates_data_people_supported_trend <- data_people_supported_trend %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_people_supported_trend") 
# remove duplicates from data - keep only unique rows 
data_people_supported_trend <- unique(data_people_supported_trend) 


#### Client Group data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_people_supported_client_group <- data_people_supported_client_group %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_people_supported_client_group") 
# remove duplicates from data - keep only unique rows
data_people_supported_client_group <- unique(data_people_supported_client_group)


#### Age & Sex data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_people_supported_age_sex <- data_people_supported_age_sex %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_people_supported_age_sex") 
# remove duplicates from data - keep only unique rows
data_people_supported_age_sex <- unique(data_people_supported_age_sex)


#### Ethnicity data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_people_supported_ethnicity <- data_people_supported_ethnicity %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_people_supported_ethnicity") 
# remove duplicates from data - keep only unique rows
data_people_supported_ethnicity <- unique(data_people_supported_ethnicity)


#### Living Alone data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_people_supported_living_alone <- data_people_supported_living_alone %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_people_supported_living_alone") 
# remove duplicates from data - keep only unique rows
data_people_supported_living_alone <- unique(data_people_supported_living_alone)


#### Meals data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_people_supported_meals <- data_people_supported_meals %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_people_supported_meals")  
# remove duplicates from data - keep only unique rows
data_people_supported_meals <- unique(data_people_supported_meals)


#### save out duplicates for reference ----

# create table with all duplicates
duplicates_data_people_supported <- rbind(duplicates_data_people_supported_trend,
                                         # duplicates_data_people_supported_summary,
                                         duplicates_data_people_supported_client_group,
                                         duplicates_data_people_supported_age_sex,
                                         duplicates_data_people_supported_ethnicity,
                                         duplicates_data_people_supported_living_alone,
                                         duplicates_data_people_supported_meals)

# save out duplicates for info in a csv file
write_csv(duplicates_data_people_supported, glue(shiny_app_data_path, "duplicates_data_people_supported.csv"))


###############################################
##### Format data to be used in shiny app #####
###############################################.


#### TREND DATA -----

data_people_supported_trend <- data_people_supported_trend %>% 
  clean_names() %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = dplyr::recode(sending_location, 
                                          "Scotland Estimated" = "Scotland (Estimated)",
                                          'Western Isles' = "Comhairle nan Eilean Siar",
                                          "Argyll & Bute" = "Argyll and Bute",
                                          "Dumfries & Galloway" = "Dumfries and Galloway",
                                          "Perth & Kinross" = "Perth and Kinross"),
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
                                           "Shetland Islands"               = 28,
                                           "South Ayrshire"                 = 29,
                                           "South Lanarkshire"              = 30,
                                           "Stirling"                       = 31,
                                           "West Dunbartonshire"            = 32,
                                           "West Lothian"                   = 33),
         measure          = dplyr::recode(measure,
                                          "Rate per 1,000 population" = "Rate per 1,000 Population",
                                          "Rate per 1,000 population adjusted" = "Rate per 1,000 Population (adjusted)"),
         measure          = as.character(measure),
         nclient          = as.numeric(nclient),
         rate             = as.numeric(round(rate,1)),
         scotland_nclient = as.numeric(scotland_nclient),
         scotland_rate    = as.numeric(round(scotland_rate, 1))
         ) %>% 
  arrange(financial_year, location_order,  sending_location, measure)  %>% 
  select(financial_year, sending_location, measure, nclient, rate, scotland_rate, scotland_nclient)
  


#### SUMMARY DATA  -----

 data_people_supported_summary <- data_people_supported_summary %>% 
   clean_names() %>% 
   mutate(financial_year   = as.character(financial_year),
          sending_location = dplyr::recode(sending_location, 
                                           "Scotland Estimated" = "Scotland (Estimated)",
                                           'Western Isles' = "Comhairle nan Eilean Siar",
                                           "Argyll & Bute" = "Argyll and Bute",
                                           "Dumfries & Galloway" = "Dumfries and Galloway",
                                           "Perth & Kinross" = "Perth and Kinross"),
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
                                            "Shetland Islands"               = 28,
                                            "South Ayrshire"                 = 29,
                                            "South Lanarkshire"              = 30,
                                            "Stirling"                       = 31,
                                            "West Dunbartonshire"            = 32,
                                            "West Lothian"                   = 33),
          measure          = dplyr::recode(measure,
                                           "Rate per 1,000 population" = "Rate per 1,000 Population",
                                           "Rate per 1,000 population adjusted" = "Rate per 1,000 Population (adjusted)"),
          measure          = as.character(measure),
          rate             = as.numeric(round(rate, 1)),
          nclient          = as.numeric(nclient),
          scotland_rate    = as.numeric(round(scotland_rate, 1)),
          scotland_nclient     = as.numeric(scotland_nclient)) %>% 
   arrange(financial_year, location_order,  sending_location, measure)  %>% 
   select(financial_year, sending_location, measure, rate, nclient, scotland_rate, scotland_nclient)


#### AGE & SEX  ----

data_people_supported_age_sex <- data_people_supported_age_sex %>% 
  clean_names() %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = dplyr::recode(sending_location, 
                                          "Scotland Estimated" = "Scotland (Estimated)",
                                          "Scotland (All areas submitted)" = "Scotland (All Areas Submitted)",
                                          'Western Isles' = "Comhairle nan Eilean Siar",
                                          "Argyll & Bute" = "Argyll and Bute",
                                          "Dumfries & Galloway" = "Dumfries and Galloway",
                                          "Perth & Kinross" = "Perth and Kinross",
                                          "Shetland" = "Shetland Islands",
                                          "Orkney" = "Orkney Islands",
                                          "Edinburgh City" = "City of Edinburgh",
                                          "Borders" = "Scottish Borders"),
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
                                           "Shetland Islands"               = 28,
                                           "South Ayrshire"                 = 29,
                                           "South Lanarkshire"              = 30,
                                           "Stirling"                       = 31,
                                           "West Dunbartonshire"            = 32,
                                           "West Lothian"                   = 33),
         age_group        = dplyr::recode(age_group, '0-17' = "0-17 years",
                                                     '18-64' = "18-64 years",
                                                     '65-74' = "65-74 years",
                                                     '75-84' = "75-84 years",
                                                     '85+'   = "85+ years",
                                                     'All ages' = "All Ages"),
         age_group   = as.character(age_group),
         age_order   = ordered(dplyr::recode(age_group, 
                                             "All Ages" = 1, 
                                             "0-17 years" = 2,
                                             "18-64 years" = 3,
                                             "65-74 years" = 4,
                                             "75-84 years" = 5,
                                             "85+ years" = 6,
                                             "Unknown" = 7)),
         sex              = dplyr::recode(sex, "female" = "Female",
                                               "male" = "Male",
                                               "Unknown/N" = "Not Known / Unspecified"),
         sex              = as.character(sex),
         sex_order        = dplyr::recode(sex, 
                                          "Female" = 1,
                                          "Male" = 2,
                                          "Unknown/Not Specified" = 3),
         measure          = dplyr::recode(measure,
                                          "Rate per 1,000" = "Rate per 1,000 Social Care Clients",
                                          "Rate per 1,000 adjusted" = "Rate per 1,000 Social Care Clients (adjusted)"),
         measure          = as.character(measure),
         nclient          = as.numeric(round(nclient,0)),
         rate             = as.numeric(round(rate,1))) %>% 
  arrange(location_order, sending_location, financial_year, age_order, age_group, sex_order, sex, measure) %>% 
  select(financial_year, sending_location, age_group, sex, measure, rate, nclient)



#### ETHNIC GROUP  ----                         

data_people_supported_ethnicity <- 
  data_people_supported_ethnicity %>%
  clean_names() %>% 
         mutate(financial_year   = as.character(financial_year),
                sending_location = dplyr::recode(sending_location, 
                                                 "Scotland Estimated" = "Scotland (Estimated)",
                                                 "Scotland (All areas submitted)" = "Scotland (All Areas Submitted)",
                                                 'Western Isles' = "Comhairle nan Eilean Siar",
                                                 "Argyll & Bute" = "Argyll and Bute",
                                                 "Dumfries & Galloway" = "Dumfries and Galloway",
                                                 "Perth & Kinross" = "Perth and Kinross",
                                                 "Borders" = "Scottish Borders",
                                                 "Edinburgh City" = "City of Edinburgh",
                                                 "Shetland" = "Shetland Islands",
                                                 "Orkney" = "Orkney Islands"),
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
                                                  "Shetland Islands"               = 28,
                                                  "South Ayrshire"                 = 29,
                                                  "South Lanarkshire"              = 30,
                                                  "Stirling"                       = 31,
                                                  "West Dunbartonshire"            = 32,
                                                  "West Lothian"                   = 33),
                age_group        = dplyr::recode(age_group, '0-17' = "0-17 years",
                                                 '18-64' = "18-64 years",
                                                 '65-74' = "65-74 years",
                                                 '75-84' = "75-84 years",
                                                 '85+'   = "85+ years",
                                                 'All ages' = "All Ages"),
                age_group   = as.character(age_group),
                age_order   = ordered(dplyr::recode(age_group, 
                                                    "All Ages" = 1, 
                                                    "0-17 years" = 2,
                                                    "18-64 years" = 3,
                                                    "65-74 years" = 4,
                                                    "75-84 years" = 5,
                                                    "85+ years" = 6,
                                                    "Unknown" = 7)),
                ethnicity    = dplyr::recode(ethnicity, "Not Provided/Not Known" = "Not Provided / Not Known"),
                ethnicity = as.character(ethnicity),
                ethnicity_order  = dplyr::recode(ethnicity, 
                                                 "White"                               = 1,
                                                 "African"                             = 1,
                                                 "Asian"                               = 1,
                                                 "Caribbean or Black"                  = 1,
                                                 "Any mixed or multiple ethnic groups" = 1,
                                                 "Other Ethnic Group"                  = 2,
                                                 "Not Provided / Not Known"            = 3),
                measure          = dplyr::recode(measure,
                                                 "Rate per 1,000" = "Rate per 1,000 Social Care Clients",
                                                 "Rate per 1,000 adjusted" = "Rate per 1,000 Social Care Clients (adjusted)"),
         measure          = as.character(measure),
         nclient          = as.numeric(nclient),
         rate             = as.numeric(round(rate,1))) %>% 
  arrange(location_order, sending_location, financial_year, age_order, age_group, ethnicity_order, ethnicity,  measure) %>% 
  select(financial_year, sending_location, age_group, ethnicity, measure, rate, nclient)


#### CLIENT GROUP ---- 

data_people_supported_client_group <- data_people_supported_client_group %>% 
  clean_names() %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = dplyr::recode(sending_location, 
                                          "Scotland Estimated" = "Scotland (Estimated)",
                                          "Scotland (All areas submitted)" = "Scotland (All Areas Submitted)",
                                          'Western Isles' = "Comhairle nan Eilean Siar",
                                          "Argyll & Bute" = "Argyll and Bute",
                                          "Dumfries & Galloway" = "Dumfries and Galloway",
                                          "Perth & Kinross" = "Perth and Kinross",
                                          "Borders" = "Scottish Borders",
                                          "Edinburgh City" = "City of Edinburgh",
                                          "Shetland" = "Shetland Islands",
                                          "Orkney" = "Orkney Islands"),
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
                                          "Shetland Islands"               = 28,
                                          "South Ayrshire"                 = 29,
                                          "South Lanarkshire"              = 30,
                                          "Stirling"                       = 31,
                                          "West Dunbartonshire"            = 32,
                                          "West Lothian"                   = 33),
         age_group        = dplyr::recode(age_group, '0-17' = "0-17 years",
                                          '18-64' = "18-64 years",
                                          '65-74' = "65-74 years",
                                          '75-84' = "75-84 years",
                                          '85+'   = "85+ years",
                                          'All ages' = "All Ages"),
         age_order               = dplyr::recode(age_group, "All Ages" = 1,
                                                 "0-17 years"  = 2,
                                                 "18-64 years" = 3,
                                                 "<65 years"   = 4,
                                                 "65-74 years" = 5,
                                                 "75-84 years" = 6,
                                                 "85+ years"   = 7,
                                                 "Unknown"     = 8),
         client_group     = dplyr::recode(type,  
                                          'Physical & Sensory Disability' = "Physical and Sensory Disability",
                                          'Elderly/frail'              = "Elderly / Frail"),
         client_group     = as.character(client_group),
         client_group_order = dplyr::recode(client_group, 
                                            "Dementia" = 1,
                                            "Elderly / Frail" = 2,
                                            "Learning Disability" = 3,
                                            "Mental Health" = 4,
                                            "Physical and Sensory Disability" = 5,
                                            "Other" = 6,
                                            "Not Recorded" = 7),
         measure          = dplyr::recode(measure,
                                          "Rate per 1,000" = "Rate per 1,000 Social Care Clients",
                                          "Rate per 1,000 adjusted" = "Rate per 1,000 Social Care Clients (adjusted)"),
         measure          = as.character(measure),
         denominator      = as.numeric(denominator), 
         nclient          = as.numeric(nclient),
         rate             = as.numeric(round(rate, 1))) %>% 
  arrange(location_order, sending_location, financial_year, age_order, age_group, client_group_order, client_group, measure) %>% 
  select(financial_year, sending_location, age_group, client_group, measure, rate, nclient)



#### SUPPORT & SERVICES  ---- 

data_people_supported_services <- data_people_supported_services %>% 
   mutate(financial_year = as.character(financial_year),
          sending_location = dplyr::recode(sending_location, 
                                           "Scotland Estimated" = "Scotland (Estimated)",
                                           "Scotland (All areas submitted)" = "Scotland (All Areas Submitted)",
                                           'Western Isles' = "Comhairle nan Eilean Siar",
                                           "Argyll & Bute" = "Argyll and Bute",
                                           "Dumfries & Galloway" = "Dumfries and Galloway",
                                           "Perth & Kinross" = "Perth and Kinross",
                                           "Borders" = "Scottish Borders",
                                           "Edinburgh City" = "City of Edinburgh",
                                           "Shetland" = "Shetland Islands",
                                           "Orkney" = "Orkney Islands"),
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
                                            "Shetland Islands"               = 28,
                                            "South Ayrshire"                 = 29,
                                            "South Lanarkshire"              = 30,
                                            "Stirling"                       = 31,
                                            "West Dunbartonshire"            = 32,
                                            "West Lothian"                   = 33),
         service_group    = dplyr::recode(service, 
                                          'HC' = "Home Care",
                                          'HS' = "Housing Support",
                                          'CH' = "Care Home",
                                          'SW' = "Social Worker",
                                          'EQ' = "Community Alarms / Telecare",
                                          'DC' = "Day Care",
                                          'MEALS' = "Meals"),
         age_group        = dplyr::recode(age_group, 
                                          '0-17' = "0-17 years",
                                          '18-64' = "18-64 years",
                                          '65-74' = "65-74 years",
                                          '75-84' = "75-84 years",
                                          '85+'   = "85+ years",
                                          'All ages' = "All Ages"),
         age_order               = dplyr::recode(age_group, 
                                                 "All Ages" = 1,
                                                 "0-17 years"  = 2,
                                                 "18-64 years" = 3,
                                                 "65-74 years" = 5,
                                                 "75-84 years" = 6,
                                                 "85+ years"   = 7,
                                                 "Unknown"     = 8),
          nclient          = as.numeric(nclient))  %>% 
   arrange(location_order, sending_location, financial_year, service_group, age_order, age_group) %>% 
   select(financial_year, sending_location, age_group, service_group, nclient)


#### MEALS -----

data_people_supported_meals <- data_people_supported_meals %>% 
  clean_names() %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = dplyr::recode(sending_location, 
                                          "Scotland Estimated" = "Scotland (Estimated)",
                                          "Scotland (All areas submitted)" = "Scotland (All Areas Submitted)",
                                          'Western Isles' = "Comhairle nan Eilean Siar",
                                          "Argyll & Bute" = "Argyll and Bute",
                                          "Dumfries & Galloway" = "Dumfries and Galloway",
                                          "Perth & Kinross" = "Perth and Kinross",
                                          "Borders" = "Scottish Borders",
                                          "Shetland" = "Shetland Islands",
                                          "Orkney" = "Orkney Islands",
                                          "Edinburgh City" = "City of Edinburgh"),
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
                                          "Shetland Islands"               = 28,
                                          "South Ayrshire"                 = 29,
                                          "South Lanarkshire"              = 30,
                                          "Stirling"                       = 31,
                                          "West Dunbartonshire"            = 32,
                                          "West Lothian"                   = 33),
         age_group        = dplyr::recode(age_group, '0-17' = "0-17 years",
                                          '18-64' = "18-64 years",
                                          '65-74' = "65-74 years",
                                          '75-84' = "75-84 years",
                                          '85+'   = "85+ years",
                                          'All ages' = "All Ages"),
         age_group   = as.character(age_group),
         age_order   = ordered(dplyr::recode(age_group, 
                                             "All Ages" = 1, 
                                             "0-17 years" = 2,
                                             "18-64 years" = 3,
                                             "65-74 years" = 4,
                                             "75-84 years" = 5,
                                             "85+ years" = 6,
                                             "Unknown" = 7)),
         measure          = dplyr::recode(measure,
                                          "Rate per 1,000" = "Rate per 1,000 People",
                                          "Rate per 1,000 adjusted" = "Rate per 1,000 People (adjusted)"),
         measure          = as.character(measure),
         nclient          = as.numeric(nclient),
         rate           = as.numeric(round(rate,1))) %>% 
   arrange(location_order, sending_location, financial_year, age_order, age_group, measure) %>% 
   select(financial_year, sending_location, age_group, measure, rate, nclient)

#### LIVING ALONE  ------

data_people_supported_living_alone <- 
  data_people_supported_living_alone %>% 
                                      clean_names() %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = dplyr::recode(sending_location, 
                                          "Scotland Estimated" = "Scotland (Estimated)",
                                          "Scotland (All areas submitted)" = "Scotland (All Areas Submitted)",
                                          'Western Isles' = "Comhairle nan Eilean Siar",
                                          "Argyll & Bute" = "Argyll and Bute",
                                          "Edinburgh City" = "City of Edinburgh",
                                          "Shetland" = "Shetland Islands",
                                          "Dumfries & Galloway" = "Dumfries and Galloway",
                                          "Borders" = "Scottish Borders",
                                          "Perth & Kinross" = "Perth and Kinross",
                                          "Orkney" = "Orkney Islands"),
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
                                           "Shetland Islands"                       = 28,
                                           "South Ayrshire"                 = 29,
                                           "South Lanarkshire"              = 30,
                                           "Stirling"                       = 31,
                                           "West Dunbartonshire"            = 32,
                                           "West Lothian"                   = 33),
         age_group        = dplyr::recode(age_group, '0-17' = "0-17 years",
                                          '18-64' = "18-64 years",
                                          '65-74' = "65-74 years",
                                          '75-84' = "75-84 years",
                                          '85+'   = "85+ years",
                                          'All ages' = "All Ages"),
         age_group   = as.character(age_group),
         age_order   = ordered(dplyr::recode(age_group, 
                                             "All Ages" = 1, 
                                             "0-17 years" = 2,
                                             "18-64 years" = 3,
                                             "65-74 years" = 4,
                                             "75-84 years" = 5,
                                             "85+ years" = 6,
                                             "Unknown" = 7)),
         living_alone     = dplyr::recode(living_alone,
                                          "1" = "Living Alone",
                                          "0" = "Not Living Alone",
                                          "9" = "Unknown"),
         living_alone     = as.character(living_alone),
         living_alone_order = dplyr::recode(living_alone,
                                            "Living Alone" = 1,
                                            "Not Living Alone" = 2,
                                            "Unknown" = 3),
         measure          = dplyr::recode(measure,
                                          "Rate per 1,000" = "Percentage of Social Care Clients",
                                          "Rate per 1,000 adjusted" = "Percentage of Social Care Clients (adjusted)"),
         measure          = as.character(measure),
         nclient          = as.numeric(nclient),
         percentage       = round(percentage, 1)) %>% 
  filter(
    nclient != "0" & percentage != "0") %>%
  arrange(financial_year, location_order, sending_location, age_order, age_group, living_alone_order, measure) %>% 
  select(financial_year, sending_location, age_group, living_alone, measure, percentage, nclient)


#############################################
#### Save Data to Shiny App Data Folder -----
#############################################
# save out data sets so they can be picked up by the global.R script and used by the shiny app

# save out .rds file to the shiny app data file 

write_rds(data_people_supported_summary, paste0(shiny_app_data_path, "data_people_supported_summary.rds"))
write_rds(data_people_supported_trend, paste0(shiny_app_data_path, "data_people_supported_trend.rds"))
write_rds(data_people_supported_age_sex, paste0(shiny_app_data_path, "data_people_supported_age_sex.rds"))
write_rds(data_people_supported_ethnicity, paste0(shiny_app_data_path, "data_people_supported_ethnicity.rds"))
write_rds(data_people_supported_client_group, paste0(shiny_app_data_path, "data_people_supported_client_group.rds"))
write_rds(data_people_supported_services, paste0(shiny_app_data_path, "data_people_supported_services.rds"))
write_rds(data_people_supported_meals, paste0(shiny_app_data_path, "data_people_supported_meals.rds"))
write_rds(data_people_supported_living_alone, paste0(shiny_app_data_path, "data_people_supported_living_alone.rds"))

## save out csv version of files for reference

write_csv(data_people_supported_trend, paste0(shiny_app_data_path, "data_people_supported_trend.csv"))
write_csv(data_people_supported_summary, paste0(shiny_app_data_path, "data_people_supported_summary.csv"))
write_csv(data_people_supported_age_sex, paste0(shiny_app_data_path, "data_people_supported_age_sex.csv"))
write_csv(data_people_supported_ethnicity, paste0(shiny_app_data_path, "data_people_supported_ethnicity.csv"))
write_csv(data_people_supported_client_group, paste0(shiny_app_data_path, "data_people_supported_client_group.csv"))
write_csv(data_people_supported_services, paste0(shiny_app_data_path, "data_people_supported_services.csv"))
write_csv(data_people_supported_meals, paste0(shiny_app_data_path, "data_people_supported_meals.csv"))
write_csv(data_people_supported_living_alone, paste0(shiny_app_data_path, "data_people_supported_living_alone.csv"))

#### end of data prep script, please open global.R script to create app ####
