#####################################################
## Self-directed Support Data Preparation Script ##
#####################################################


# This script picks up .sav files from SC publication analysis folder
# and prepares them to be used in the Rshiny app

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
#\\Isdsf00d03\social-care\05-Analysts\Publication\Publication_1920_2021\SDS\3_Shiny_Data\2. Real Data

## File path for publication analysis data outputs 
publication_data_path <- glue("/conf/social-care/05-Analysts/Publication/Publication_1920_2021/SDS/3_Shiny_Data/", data_type, "/")

## File path for data to be saved to and picked up by shiny app 
#/conf/social-care/05-Analysts/Publication/Publication_1920_2021/Shiny Apps/self-directed-support-shiny-app

shiny_app_data_path <- here("data/") 

###### Load in data #######

## load any .sav / zsav file in publication dashboard data folder 
# list all files which include with a sav file extension (this will also capture .zsav extension files) 

dashboard_sav_file_names <- list.files(path = publication_data_path, pattern = "*sav")

# apply the read_sav function to all files listed in the dashboard_sav_file_name object,
# these data frames will then be held in the dashboard_sav_data_files_list

dashboard_sav_data_files_list <- lapply(paste0(publication_data_path, dashboard_sav_file_names), haven::read_sav)

names(dashboard_sav_data_files_list) <- gsub(".zsav","", dashboard_sav_file_names, fixed = TRUE) %>% 
  make_clean_names()

# create individual data file objects in the global environment, rather than keeping them as a list of data frames
# note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(dashboard_sav_data_files_list), function(x) assign(x,dashboard_sav_data_files_list[[x]],envir=.GlobalEnv)))


# rename file names with sav

data_sds_client_group <- data_sds_client_group_sav
rm(data_sds_client_group_sav)
data_sds_implementation_rate <- data_sds_implementation_rate_sav
rm(data_sds_implementation_rate_sav)
data_sds_options_chosen <- data_sds_options_chosen_sav
rm(data_sds_options_chosen_sav)
data_sds_options_proportion <- data_sds_options_proportion_sav
rm(data_sds_options_proportion_sav)
data_sds_type_of_organisation <- data_sds_type_of_organisation_sav
rm(data_sds_type_of_organisation_sav)


##############################################
##### Identify and remove any duplicates #####
##############################################
#### Trend data duplicates check ----

# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_sds_trend <- data_sds_trend %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_trend") 
# remove duplicates from data - keep only unique rows 
data_sds_trend <- unique(data_sds_trend) 

#### Implementation rate data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable to this data frame to identify which tec data set the duplicates are from
duplicates_data_sds_implementation_rate <- data_sds_implementation_rate %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_implementation_rate") 

# remove duplicates from data - keep only unique rows 
data_sds_implementation_rate <- unique(data_sds_implementation_rate) # 4 rows of data have been removed

#### Options Chosen data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_sds_options_chosen <- data_sds_options_chosen %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_options_chosen") 

# remove duplicates from data - keep only unique rows 
data_sds_options_chosen <- unique(data_sds_options_chosen) 

#### Client Group data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_sds_client_group <- data_sds_client_group %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_client_group") 
# remove duplicates from data - keep only unique rows
data_sds_client_group <- unique(data_sds_client_group)

#### Support / Service Needs Assessed data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from
duplicates_data_sds_support_needs <- data_sds_support_needs %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_support_needs") 

# remove duplicates from data - keep only unique rows
data_sds_support_needs <- unique(data_sds_support_needs)

#### Type of Organisation Providing Support/Services data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_sds_type_of_organisation <- data_sds_type_of_organisation %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_type_of_organisation") 

# remove duplicates from data - keep only unique rows
data_sds_type_of_organisation <- unique(data_sds_type_of_organisation)

#### SDS Options by Proportion data duplicates check ----
# identify duplicates create a new data table to store them
# add a variable that identifies which file duplicates have come from

duplicates_data_sds_options_proportion <- data_sds_options_proportion %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_options_proportion")  

# remove duplicates from data - keep only unique rows
data_sds_options_proportion <- unique(data_sds_options_proportion)


#### save out duplicates for reference ----

# create table with all duplicates
duplicates_data_sds <- rbind(duplicates_data_sds_trend,
                                           duplicates_data_sds_implementation_rate,
                                           duplicates_data_sds_options_chosen,
                                           duplicates_data_sds_client_group,
                                           duplicates_data_sds_support_needs,
                                           duplicates_data_sds_type_of_organisation,
                                           duplicates_data_sds_options_proportion)

# save out duplicates for info in a csv file
write_csv(duplicates_data_sds, glue(shiny_app_data_path, "duplicates_data_sds.csv"))

###############################################
##### Format data to be used in shiny app - UPDATE when SDS data is available #####
###############################################
#### SDS Trend ---------

data_sds_trend  <- data_sds_trend %>% 
    # rename variables and set variable types to character 
                    mutate(financial_year   = as.character(financial_year),
                           sending_location = dplyr::recode(sending_location, 
                                                            'Scotland - All Areas Submitted' = "Scotland (Estimated)"),
                           location_order   = dplyr::recode(sending_location, 
                                                            "All Areas Submitted"            = "A",
                                                            "Scotland (All Areas Submitted)" = "A",
                                                            "Scotland"                       = "A",
                                                            "Scotland (Estimated)"           = "A"),
                           option_type      = as.character(option_type),
                           option_order     = dplyr::recode(option_type, 
                                                            "Any SDS"  = 1,
                                                            "Option 1" = 2,
                                                            "Option 2" = 3,
                                                            "Option 3" = 4,
                                                            "Option 4" = 5),
                           nclient          = as.numeric(nclient),
                           rate             = as.numeric(round(rate,1))
                           ) %>% 
     arrange(financial_year, location_order, sending_location, option_order, option_type) %>% 
     select(financial_year, sending_location, option_type, nclient, rate)

#### SDS Implementation Rate -----

data_sds_implementation_rate <- data_sds_implementation_rate %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = as.character(sending_location),
         location_order   = dplyr::recode(sending_location, 
                                         "All Areas Submitted"            = "A",
                                         "Scotland (All Areas Submitted)" = "A",
                                         "Scotland"                       = "A",
                                         "Scotland (Estimated)"           = "A"),
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
         nclient             = as.numeric(nclient),
         sdsclient           = as.numeric(SDSclient),
         implementation_rate = as.numeric(round(Implementation_Rate, 1))
  ) %>%
  arrange(location_order, sending_location, financial_year) %>% 
  select(financial_year, sending_location, implementation_rate, nclient, sdsclient) 


# for scotland reference line
implementation_scotland <- 
  data_sds_implementation_rate %>%
  filter(sending_location == "Scotland (Estimated)") %>%
  distinct(financial_year, implementation_rate, nclient, .keep_all = FALSE) %>%
  rename(scotland_rate = "implementation_rate",
         scotland_nclient = "nclient")

data_sds_implementation_rate <-
  data_sds_implementation_rate %>%
  left_join(implementation_scotland, by = "financial_year") 


#### SDS Options Chosen ------

data_sds_options_chosen <- data_sds_options_chosen %>% 
                            mutate(
                              financial_year = as.character(financial_year),
                              sending_location = dplyr::recode(sending_location, 
                                                               'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
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
                              option_type      = as.character(option_type),
                              option_order     = dplyr::recode(option_type, 
                                                               "Any SDS"  = 1,
                                                               "Option 1" = 2,
                                                               "Option 2" = 3,
                                                               "Option 3" = 4,
                                                               "Option 4" = 5),
                              age_group  = dplyr::recode(age_group, 'All' = "All Ages",
                                                              '0-17' = "0-17 years",
                                                              '18-64' = "18-64 years",
                                                              '65-74' = "65-74 years",
                                                              '75-84' = "75-84 years",
                                                              '85+' = "85+ years"),
                              age_order = dplyr::recode(age_group, 
                                                        "All Ages"    = 1,
                                                        "0-17 years"  = 2,
                                                        "18-64 years" = 3,
                                                        "65-74 years" = 4,
                                                        "75-84 years" = 5,
                                                        "85+ years"   = 6,
                                                        "Unknown"     = 7),
                              nclient    = as.numeric(nclient)
                            ) %>% 
                            arrange(location_order, sending_location, financial_year, option_order, option_type, age_order, age_group) %>% 
                            select(financial_year, sending_location, age_group, option_type, nclient, rate)
                            

#### SDS Options Proportion -----

data_sds_options_proportion <- data_sds_options_proportion %>% 
                                    mutate(
    financial_year = as.character(financial_year),
    sending_location = dplyr::recode(sending_location, 
                                     'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
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
    sds_option      = as.character(option),
    option_order     = dplyr::recode(sds_option, 
                                     "Option 1 Only" = 1,
                                     "Option 2 Only" = 2,
                                     "Option 3 Only" = 3,
                                     "Option 4 Only" = 4),
    age_group  = dplyr::recode(age_group, 'All' = "All Ages",
                               '0-17' = "0-17 years",
                               '18-64' = "18-64 years",
                               '65-74' = "65-74 years",
                               '75-84' = "75-84 years",
                               '85+' = "85+ years"),
    age_order = dplyr::recode(age_group, 
                              "All Ages"    = 1,
                              "0-17 years"  = 2,
                              "18-64 years" = 3,
                              "65-74 years" = 4,
                              "75-84 years" = 5,
                              "85+ years"   = 6,
                              "Unknown"     = 7),
    percentage    = as.numeric(round(prop),1),
    nclients = as.numeric(nclients)
  ) %>% 
  arrange(location_order, sending_location, financial_year, option_order, sds_option, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, sds_option, nclients, percentage)

#### SDS Client Group  -----

data_sds_client_group <- data_sds_client_group %>% 
                              mutate(
                                financial_year     = as.character(financial_year),
                                sending_location   = dplyr::recode(sending_location, 
                                                                 'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
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
                                client_group       = as.character(client_group),
                                client_group       = dplyr::recode(client_group,
                                                                  "Elderly Frail" = "Elderly / Frail"),
                                client_group_order = dplyr::recode(client_group, 
                                                                          "Dementia" = "A",
                                                                          "Mental Health" = "A",
                                                                          "Learning Disability" = "A",            
                                                                          "Physical and Sensory Disability" = "A",
                                                                          "Elderly / Frail" = "A",
                                                                          "Other" = "B"),
                                age_group          = dplyr::recode(age_group, 'All' = "All Ages",
                                                           '0-17' = "0-17 years",
                                                           '18-64' = "18-64 years",
                                                           '65-74' = "65-74 years",
                                                           '75-84' = "75-84 years",
                                                           '85+' = "85+ years"),
                                age_order          = dplyr::recode(age_group, 
                                                          "All Ages"    = 1,
                                                          "0-17 years"  = 2,
                                                          "18-64 years" = 3,
                                                          "65-74 years" = 4,
                                                          "75-84 years" = 5,
                                                          "85+ years"   = 6,
                                                          "Unknown"     = 7),
                                nclient            = as.numeric(nclient)
                              ) %>% 
                                arrange(location_order, sending_location, financial_year, client_group_order, client_group, age_order, age_group) %>% 
                                select(financial_year, sending_location, age_group, client_group, nclient, rate)


#### SDS Support / Service Needs Assessed -----

data_sds_support_needs <- data_sds_support_needs %>% 
                                      mutate(
                                        financial_year     = as.character(financial_year),
                                        sending_location   = dplyr::recode(sending_location, 
                                                                'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
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
                                        sds_support_need   = as.character(sds_support_need),
                                        support_need_order = dplyr::recode(sds_support_need, 
                                                                "Personal Care"                       = "A",
                                                                "Health Care"                         = "A",
                                                                "Domestic Care"                       = "A",  
                                                                "Housing Support"                     = "A", 
                                                                "Social Educational Recreational"     = "A", 
                                                                "Equipment and Temporary Adaptations" = "A", 
                                                                "Respite"                             = "A",
                                                                "Meals"                               = "A",
                                                                "Other"                               = "B",
                                                                "Not Known"                           = "C"),
                                        age_group          = as.character(age_group),
                                        age_order          = dplyr::recode(age_group, 
                                                                "All Ages"    = 1,
                                                                "0-17 years"  = 2,
                                                                "18-64 years" = 3,
                                                                "65-74 years" = 4,
                                                                "75-84 years" = 5,
                                                                "85+ years"   = 6,
                                                                "Unknown"     = 7),
                                        nclient            = as.numeric(nclient)
                                        ) %>% 
  arrange(location_order, sending_location, financial_year, support_need_order, sds_support_need, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, sds_support_need, nclient, rate)
  

#### SDS Type of Organisation Providing Support/Services -----

data_sds_type_of_organisation <- data_sds_type_of_organisation %>% 
                                        mutate(
                                          financial_year     = as.character(financial_year),
                                          sending_location   = dplyr::recode(sending_location, 
                                                                             'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
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
                                          sds_support_services   = as.character(sds_support_services),
                                          support_services_order = dplyr::recode(sds_support_services, 
                                                                             "Personal Assistance Contract" = "A",
                                                                             "Local Authority"              = "A",
                                                                             "Private"                      = "A",  
                                                                             "Voluntary"                    = "A", 
                                                                             "Other"                        = "B",
                                                                             "Not Known"                    = "C"),
                                          age_group          = as.character(age_group),
                                          age_order          = dplyr::recode(age_group, 
                                                                             "All Ages"    = 1,
                                                                             "0-17 years"  = 2,
                                                                             "18-64 years" = 3,
                                                                             "65-74 years" = 4,
                                                                             "75-84 years" = 5,
                                                                             "85+ years"   = 6,
                                                                             "Unknown"     = 7),
                                          nclient            = as.numeric(nclient),
                                          rate               = as.numeric(rate)
                                        ) %>% 
  arrange(location_order, sending_location, financial_year, support_services_order, sds_support_services, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, sds_support_services, nclient, rate)

#############################################
#### Save Data to Shiny App Data Folder -----
#############################################
# save out data sets so they can be picked up by the global.R script and used by the shiny app

# save out .rds file to the shiny app data file 

write_rds(data_sds_trend, paste0(shiny_app_data_path, "data_sds_trend.rds"))
write_rds(data_sds_implementation_rate, paste0(shiny_app_data_path, "data_sds_implementation_rate.rds"))
write_rds(data_sds_options_chosen, paste0(shiny_app_data_path, "data_sds_options_chosen.rds"))
write_rds(data_sds_client_group, paste0(shiny_app_data_path, "data_sds_client_group.rds"))
write_rds(data_sds_support_needs, paste0(shiny_app_data_path, "data_sds_support_needs.rds"))
write_rds(data_sds_type_of_organisation, paste0(shiny_app_data_path, "data_sds_type_of_organisation.rds"))
write_rds(data_sds_options_proportion, paste0(shiny_app_data_path, "data_sds_options_proportion.rds"))

## save out csv version of files for reference

write_csv(data_sds_trend, paste0(shiny_app_data_path, "data_sds_trend.csv"))
write_csv(data_sds_implementation_rate, paste0(shiny_app_data_path, "data_sds_implementation_rate.csv"))
write_csv(data_sds_options_chosen, paste0(shiny_app_data_path, "data_sds_options_chosen.csv"))
write_csv(data_sds_client_group, paste0(shiny_app_data_path, "data_sds_client_group.csv"))
write_csv(data_sds_support_needs, paste0(shiny_app_data_path, "data_sds_support_needs.csv"))
write_csv(data_sds_type_of_organisation, paste0(shiny_app_data_path, "data_sds_type_of_organisation.csv"))
write_csv(data_sds_options_proportion, paste0(shiny_app_data_path, "data_sds_options_proportion.csv"))

#### end of data prep script, please open global.R script to create app ####