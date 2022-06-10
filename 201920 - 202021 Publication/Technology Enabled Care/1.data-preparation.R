#####################################################
## Technology Enabled Care Data Preparation Script ##
#####################################################

# This script picks up equipment data files from SC analyst publication folder and 
# creates a new dataset to match the format required for the equipment shiny app

###### load packages ######

library(tidyverse)  # tidyverse suite of packages for data wrangling and pipe operators (%>%)
library(haven)      # read in .sav or .zsav files
library(janitor)    # clean_names function 
library(glue)       # used in file path set up
library(here)

###### specify file paths ######

data_type <- "3. Rounded Data"

# 1920 dashboard files saved at:
#\\Isdsf00d03\social-care\05-Analysts\Publication\Publication_1920_2021\Technology_Enabled_Care\3_Shiny_Data\2. Real Data

## File path for publication analysis data outputs 
publication_data_path <- glue("/conf/social-care/05-Analysts/Publication/Publication_1920_2021/Technology_Enabled_Care/3_Shiny_Data/", data_type, "/")

## File path for data to be saved to and picked up by shiny app 
# /conf/social-care/05-Analysts/Publication/Publication_1920_2021/Shiny Apps/equipment-shiny-app

shiny_app_data_path <- here("data/") 


###### Load in data #######

## load any .sav / zsav file in publication dashboard data folder 
# list all files which include with a sav file extension (this will also capture .zsav extension files) 

dashboard_sav_file_names <- list.files(path = publication_data_path, pattern = "*sav")

# apply the read_sav function to all files listed in the dashboard_sav_file_name object,
# these data frames will then be held in the dashboard_sav_data_files_list

dashboard_sav_data_files_list <- lapply(paste0(publication_data_path, dashboard_sav_file_names), haven::read_sav)

#assign names to data.frames (data frames should keep the original file name but remove ".sav" from it)
# make_clean_names() function has also been used to make names lower case and replace blank spaces with "_"

names(dashboard_sav_data_files_list) <- gsub(".sav","", dashboard_sav_file_names, fixed = TRUE) %>% 
                                        make_clean_names()
                                        
# create individual data file objects in the global environment, rather than keeping them as a list of data frames
# note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(dashboard_sav_data_files_list), function(x) assign(x,dashboard_sav_data_files_list[[x]],envir=.GlobalEnv))) 



##### Identify and remove any duplicates #####

#### Trend data duplicates check ----

# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_tech_enabled_care_trend <- data_tech_enabled_care_trend %>% janitor::get_dupes() %>% 
                                             mutate(data_set = "data_tech_enabled_care_trend") 

# remove duplicates from data - keep only unique rows 
data_tech_enabled_care_trend <- unique(data_tech_enabled_care_trend) # 0 rows of data have been removed

#### Summary data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_tech_enabled_care_summary <- data_tech_enabled_care_summary %>% janitor::get_dupes() %>% 
                                              mutate(data_set = "data_tech_enabled_care_summary") 

# remove duplicates from data - keep only unique rows 
data_tech_enabled_care_summary <- unique(data_tech_enabled_care_summary) # 0 rows of data have been removed

#### Home Care data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_tech_enabled_care_home_care <- data_tech_enabled_care_home_care %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_home_care") 

# remove duplicates from data - keep only unique rows
data_tech_enabled_care_home_care <- unique(data_tech_enabled_care_home_care)

#### Living Alone data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_tech_enabled_care_living_alone <- data_tech_enabled_care_living_alone %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_living_alone") 

# remove duplicates from data - keep only unique rows
data_tech_enabled_care_living_alone <- unique(data_tech_enabled_care_living_alone)

#### Deprivation data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_tech_enabled_care_deprivation <- data_tech_enabled_care_deprivation %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_deprivation") 

# remove duplicates from data - keep only unique rows
data_tech_enabled_care_deprivation <- unique(data_tech_enabled_care_deprivation)

#### save out duplicates for reference ----

# create table with all duplicates
duplicates_data_tech_enabled_care <- rbind(duplicates_data_tech_enabled_care_trend,
                                           duplicates_data_tech_enabled_care_summary,
                                           duplicates_data_tech_enabled_care_home_care,
                                           duplicates_data_tech_enabled_care_living_alone,
                                           duplicates_data_tech_enabled_care_deprivation)

# save out duplicates for info in a csv file
write_csv(duplicates_data_tech_enabled_care, glue(shiny_app_data_path, "duplicates_data_tech_enabled_care.csv"))

##### Format data to be used in shiny app #####

### TREND DATA ----

# format data variables

data_tech_enabled_care_trend <- data_tech_enabled_care_trend %>% 
  clean_names() %>% 
  mutate(
    financial_year   = as.character(financial_year),
    sending_location = as.character(sending_location),
    location_order   = dplyr::recode(sending_location, 
                                     "All Areas Submitted"            = "A",
                                     "Scotland (All Areas Submitted)" = "A",
                                     "Scotland"                       = "A",
                                     "Scotland (Estimated)"           = "A"),
    sending_location = dplyr::recode(sending_location,
                                     "Scotland (All Areas Submitted)" = "Scotland (Estimated)"),
    age_group        = dplyr::recode(age_group, 
                                     'All ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_order   = ordered(dplyr::recode(age_group, 
                                              "All Ages" = 1, 
                                              "0-17 years" = 2,
                                              "18-64 years" = 3,
                                              "65-74 years" = 4,
                                              "75-84 years" = 5,
                                              "85+ years" = 6,
                                              "Unknown" = 7)),
    service          = as.character(service),
    service          = dplyr::recode(service, 
                                     "Community alarm only" = "Community Alarm Only",
                                     "Telecare only" = "Telecare Only",
                                     "Receiving both community alarm and telecare" = "Receiving both Community Alarm and Telecare",
                                     "Total community alarms and/or telecare" = "Total Community Alarms and/or Telecare"),
    service_order    = dplyr::recode(service, 
                                     "Community Alarm Only" = 1,
                                     "Telecare Only" = 2,
                                     "Receiving both Community Alarm and Telecare" = 3,
                                     "Total Community Alarms and/or Telecare" = 4),
    measure          = dplyr::recode(measure, 
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     'Rate per 1,000 people' = "Rate per 1,000 Population",
                                     'Rate per 1000 people'  = "Rate per 1,000 Population",
                                     'Rate per 1000 People'  = "Rate per 1,000 Population"),
    measure          = as.character(measure),
    measure_order    = dplyr::recode(measure, 
                                     "Rate per 1,000 Population" = 1,
                                     "Number of People" =2),
    value            = as.numeric(round(value,1))) %>% 
  dplyr::arrange(financial_year, location_order, sending_location, service_order, service, age_order, age_group, measure_order) %>%     # sort data
  select(financial_year, sending_location, service, age_group, measure, value)                                # remove order variables



### SUMMARY DATA ----

data_tech_enabled_care_summary <- 
  data_tech_enabled_care_summary_zsav %>%
  filter(financial_year != "2017/18") %>%
  clean_names() %>% 
mutate(
  financial_year   = as.character(financial_year),
  sending_location = as.character(sending_location),
  location_order   = dplyr::recode(sending_location, 
                                   "All Areas Submitted"            = "A",
                                   "Scotland (All Areas Submitted)" = "A",
                                   "Scotland"                       = "A",
                                   "Scotland (Estimated)"           = "A"),
  sending_location = dplyr::recode(sending_location,
                                   "Scotland" = "Scotland (All Areas Submitted)"),
  age_group        = dplyr::recode(age_group, 
                                   'All ages' = "All Ages",
                                   '0-17' = "0-17 years",
                                   '18-64' = "18-64 years",
                                   '65-74' = "65-74 years",
                                   '75-84' = "75-84 years",
                                   '85+' = "85+ years",
                                   '99999' = "Unknown"),
  age_group         = as.character(age_group),
  age_order   = ordered(dplyr::recode(age_group, 
                                      "All Ages" = 1, 
                                      "0-17 years" = 2,
                                      "18-64 years" = 3,
                                      "65-74 years" = 4,
                                      "75-84 years" = 5,
                                      "85+ years" = 6,
                                      "Unknown" = 7)),
  service          = as.character(service),
  service          = dplyr::recode(service, 
                                   "Community alarm only" = "Community Alarm Only",
                                   "Telecare only" = "Telecare Only",
                                   "Receiving both community alarm and telecare" = "Receiving both Community Alarm and Telecare",
                                   "Total community alarms and/or telecare" = "Total Community Alarms and/or Telecare"),
  service_order    = dplyr::recode(service, "Community Alarm Only" = 1,
                                   "Telecare Only" = 2,
                                   "Receiving both Community Alarm and Telecare" = 3,
                                   "Total Community Alarms and/or Telecare" = 4),
  measure          = as.character(measure),
  measure          = dplyr::recode(measure, "Rate per 1,000 People" = "Rate per 1,000 Population"),
  scotland_value       = as.numeric(scot_value),
  value             = as.numeric(round(value, 1))) %>%
  dplyr::arrange(financial_year, location_order, sending_location, service_order, service, age_order, age_group) %>%     # sort data
  select(financial_year, sending_location,  service, age_group, measure, value, scotland_value)                                # remove order variables


### HOME CARE DATA ----

data_tech_enabled_care_home_care <- data_tech_enabled_care_home_care %>% 
  clean_names() %>% 
  filter(sending_location != "Scotland",
         financial_year != "2017/18") %>%
                                            mutate(
                                              financial_year   = as.character(financial_year),
                                              sending_location = as.character(sending_location),
                                              location_order   = dplyr::recode(sending_location, 
                                                                               "All Areas Submitted"            = "A",
                                                                               "Scotland (All Areas Submitted)" = "A",
                                                                               "Scotland"                       = "A",
                                                                               "Scotland (Estimated)"           = "A"),
                                              age_group        = dplyr::recode(age_group, 
                                                                               'All ages' = "All Ages",
                                                                               '0-17' = "0-17 years",
                                                                               '18-64' = "18-64 years",
                                                                               '65-74' = "65-74 years",
                                                                               '75-84' = "75-84 years",
                                                                               '85+' = "85+ years",
                                                                               '99999' = "Unknown"),
                                              age_group         = as.character(age_group),
                                              age_order   = ordered(dplyr::recode(age_group, 
                                                                                  "All Ages" = 1, 
                                                                                  "0-17 years" = 2,
                                                                                  "18-64 years" = 3,
                                                                                  "65-74 years" = 4,
                                                                                  "75-84 years" = 5,
                                                                                  "85+ years" = 6,
                                                                                  "Unknown" = 7)),
                                              hc_status               = as.character(hc_status),
                                              hc_status_nclient       = as.numeric(round(hc_status_nclient,0)),
                                              prop_hc_status_nclient = round(prop_hc_status_nclient, 1)
                                                                                          ) %>% 
                                            arrange(financial_year, location_order, sending_location, 
                                                    age_order, age_group, hc_status) %>% 
                                            select(financial_year, sending_location, age_group, hc_status, hc_status_nclient, 
                                                   prop_hc_status_nclient)



### LIVING ALONE DATA ----

data_tech_enabled_care_living_alone <- data_tech_enabled_care_living_alone %>% 
  filter(financial_year != "2017/18") %>%
  clean_names() %>% 
                                        mutate(
                                          financial_year   = as.character(financial_year),
                                          sending_location = as.character(sending_location),
                                          sending_location = dplyr::recode(sending_location,
                                                                          "Na h-Eileanan Siar" = "Comhairle nan Eilean Siar"),
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
                                                                           '0-17' = "0-17 years",
                                                                           '18-64' = "18-64 years",
                                                                           '65-74' = "65-74 years",
                                                                           '75-84' = "75-84 years",
                                                                           '85+' = "85+ years",
                                                                           '99999' = "Unknown"),
                                          age_group         = as.character(age_group),
                                          age_order   = ordered(dplyr::recode(age_group, 
                                                                              "All Ages" = 1, 
                                                                              "0-17 years" = 2,
                                                                              "18-64 years" = 3,
                                                                              "65-74 years" = 4,
                                                                              "75-84 years" = 5,
                                                                              "85+ years" = 6,
                                                                              "Unknown" = 7)),
                                          service          = as.character(service),
                                          service_order    = dplyr::recode(service, "Community alarm only" = 1,
                                                                          "Telecare only" = 2,
                                                                          "Receiving both community alarm and telecare" = 3,
                                                                          "Total community alarms and/or telecare" = 4),
                                          living_alone_status = dplyr::recode(living_alone_status, 
                                                                              'Yes' = "Living Alone",
                                                                              'No' = "Not Living Alone",
                                                                              "not known" = "Not Known"),
                                          living_alone_status = as.character(living_alone_status),
                                          living_alone_order  = dplyr::recode(living_alone_status, 
                                                                              "Living Alone" = 1,
                                                                              "Not Living Alone" = 2,
                                                                              "Not Known" = 3,
                                                                              "Not Recorded" = 3,
                                                                              "Unknown" = 3),
                                          la_status_nclient   = as.numeric(round(la_status_nclient,0)),
                                          propn_la_status_nclient = as.numeric(round(propn_la_status_nclient,1))
                                          ) %>% 
  dplyr::arrange(location_order, sending_location, financial_year, service_order, service, 
                 age_order, age_group) %>%     # sort data
  select(financial_year, sending_location, service, 
         age_group, living_alone_status, la_status_nclient, propn_la_status_nclient)    
                                        

### DEPRIVATION DATA ----

data_tech_enabled_care_deprivation <- data_tech_enabled_care_deprivation %>% 
                                         clean_names() %>% 
                                          mutate(
                                            financial_year   = as.character(financial_year),
                                            sending_location = as.character(sending_location),
                                            location_order   = dplyr::recode(sending_location, 
                                                                             "All Areas Submitted"            = "A",
                                                                             "Scotland (All Areas Submitted)" = "A",
                                                                             "Scotland"                       = "A",
                                                                             "Scotland (Estimated)"           = "A"),
                                            age_group        = dplyr::recode(age_group, 
                                                                             'All ages' = "All Ages",
                                                                             '0-17' = "0-17 years",
                                                                             '18-64' = "18-64 years",
                                                                             '65-74' = "65-74 years",
                                                                             '75-84' = "75-84 years",
                                                                             '85+'   = "85+ years",
                                                                             '99999' = "Unknown"),
                                            age_group         = as.character(age_group),
                                            age_order   = ordered(dplyr::recode(age_group, 
                                                                                "All Ages" = 1, 
                                                                                "0-17 years" = 2,
                                                                                "18-64 years" = 3,
                                                                                "65-74 years" = 4,
                                                                                "75-84 years" = 5,
                                                                                "85+ years" = 6,
                                                                                "Unknown" = 7)),
                                            simd             = as.character(simd),
                                            simd_order   = ordered(dplyr::recode(simd,
                                                                               "1 (Most Deprived)" = 1,
                                                                               "2" = 2,
                                                                               "3" = 3,
                                                                               "4" = 4,
                                                                               "5 (Least Deprived)" = 5,
                                                                               "Unknown" = 6)),
                                            measure          = dplyr::recode(measure, 
                                                                             'Number of people' = "Number of People",
                                                                             'number of people' = "Number of People",
                                                                             'SIMD quintile proportion' = "SIMD Quintile Proportion",
                                                                             'simd quintile proportion'  = "SIMD Quintile Proportion"),
                                            measure           = as.character(measure),
                                            value            = as.numeric(round(value,1))
                                            ) %>%
                                            arrange(financial_year, location_order, sending_location, 
                                                    age_order, age_group,  simd_order
                                                    ) %>% 
                                            select(financial_year, sending_location, #service, 
                                                   age_group, simd, 
                                                   measure, value)


##### Save out data files for shiny app #####

# csv files

write_csv(data_tech_enabled_care_trend, glue(shiny_app_data_path, "data_tech_enabled_care_trend.csv"))
write_csv(data_tech_enabled_care_summary, glue(shiny_app_data_path, "data_tech_enabled_care_summary.csv"))
write_csv(data_tech_enabled_care_home_care, glue(shiny_app_data_path, "data_tech_enabled_care_home_care.csv"))
write_csv(data_tech_enabled_care_living_alone, glue(shiny_app_data_path, "data_tech_enabled_care_living_alone.csv"))
write_csv(data_tech_enabled_care_deprivation, glue(shiny_app_data_path, "data_tech_enabled_care_deprivation.csv"))

# .rds files

write_rds(data_tech_enabled_care_trend, glue(shiny_app_data_path, "data_tech_enabled_care_trend.rds"))
write_rds(data_tech_enabled_care_summary, glue(shiny_app_data_path, "data_tech_enabled_care_summary.rds"))
write_rds(data_tech_enabled_care_home_care, glue(shiny_app_data_path, "data_tech_enabled_care_home_care.rds"))
write_rds(data_tech_enabled_care_living_alone, glue(shiny_app_data_path, "data_tech_enabled_care_living_alone.rds"))
write_rds(data_tech_enabled_care_deprivation, glue(shiny_app_data_path, "data_tech_enabled_care_deprivation.rds"))

#### end of data prep script, please open global.R script to run app ####