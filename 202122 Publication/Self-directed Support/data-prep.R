#####################################################
## SDS DATA PREP SCRIPT ##
#####################################################


## PACKAGES ----

library(tidyverse)  
library(haven)     
library(janitor)   
library(glue)       
library(here)


Sys.umask("002")



publication_year <- "2122"


## FILE PATHS ----


# DATA SAVED:
# \\Isdsf00d03\social-care\05-Analysts\Publication\Publication_2122\SDS\Data\Rounded Data\Final\ 

# DATA OUTPUTS PATH
publication_data_path <- "/conf/social-care/05-Analysts/Publication/Publication_2122/SDS/Data/Rounded Data/Final/"


# SAVE OUTPUT PATH
# /conf/social-care/05-Analysts/Publication/Publication_2122/Shiny Apps/sds_app

shiny_app_data_path <- here("data/") 



## LOAD DATA ----


# .RDS FILES
app_rds_file_names <- list.files(path = publication_data_path, pattern = "*rds")

app_rds_data_files_list <- lapply(paste0(publication_data_path, app_rds_file_names), readr::read_rds)


# ASSIGN NAMES

names(app_rds_data_files_list) <- gsub(".rds","", app_rds_file_names, fixed = TRUE) %>% 
  make_clean_names()


invisible(lapply(names(app_rds_data_files_list), function(x) assign(x,app_rds_data_files_list[[x]],envir=.GlobalEnv)))


## DUPLICATES ----

# IDENTIFY DUPLICATES AND STORE IN NEW DATA FRAME
# ADD VARIABLE TO IDENITFY WHICH DATA SET FROM 

# ONLY KEEP UNIQUE ROWS IN DATA


# TREND ----
duplicates_data_sds_trend <- data_sds_trend %>% 
  get_dupes() %>% 
  mutate(data_set = "data_sds_trend") 

data_sds_trend <- unique(data_sds_trend) 


# IMPLEMENTATION RATE ----
duplicates_data_sds_implementation_hscp <- data_sds_implementation_hscp %>% 
  get_dupes() %>% 
  mutate(data_set = "data_sds_implementation_hscp") 

data_sds_implementation_hscp <- unique(data_sds_implementation_hscp) 


# OPTIONS CHOSEN ----
duplicates_data_sds_options_chosen <- data_sds_options_chosen %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_options_chosen") 


data_sds_options_chosen <- unique(data_sds_options_chosen) 


# CLIENT GROUP ----
duplicates_data_sds_client_group <- data_sds_client_group %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_client_group") 

data_sds_client_group <- unique(data_sds_client_group)


# SUPPORT & SERVICES NEEDS ----
duplicates_data_sds_support_needs <- data_sds_support_needs %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_support_needs") 


data_sds_support_needs <- unique(data_sds_support_needs)


# TYPE OF ORGANISATION ----
duplicates_data_sds_type_of_organisation <- data_sds_type_of_organisation %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_type_of_organisation") 

data_sds_type_of_organisation <- unique(data_sds_type_of_organisation)


# OPTIONS BY AGE ----
duplicates_data_sds_options_proportion <- data_sds_options_proportion %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_sds_options_proportion")  


data_sds_options_proportion <- unique(data_sds_options_proportion)



## SAVE OUT DUPLICATES ----

# COMBINE DUPLICATES
duplicates_data_sds <- rbind(duplicates_data_sds_trend,
                             duplicates_data_sds_implementation_hscp,
                             duplicates_data_sds_options_chosen,
                             duplicates_data_sds_client_group,
                             duplicates_data_sds_support_needs,
                             duplicates_data_sds_type_of_organisation,
                             duplicates_data_sds_options_proportion)

# SAVE
write_csv(duplicates_data_sds, glue(shiny_app_data_path, "duplicates_data_sds.csv"))



## FORMAT DATA ----

# TREND ----

data_sds_trend  <- data_sds_trend %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = recode(sending_location, 
                                          'Scotland - All Areas Submitted' = "Scotland (Estimated)"),
         location_order   = recode(sending_location, 
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
         option_order     = recode(option_type, 
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


# IMPLEMENTATION RATE ----

data_sds_implementation_hscp <- data_sds_implementation_hscp %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = as.character(sending_location),
         location_order   = recode(sending_location, 
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
         sdsclient           = as.numeric(sds_client),
         implementation_rate = as.numeric(round(implementation_rate, 1)),
         scotland_rate       = as.numeric(round(scotland_rate, 1)),
         scotland_nclient    = as.numeric(scotland_nclient)
  ) %>%
  arrange(location_order, sending_location, financial_year) %>% 
  select(financial_year, sending_location, implementation_rate, nclient, sdsclient, scotland_rate, scotland_nclient) 



# OPTIONS CHOSEN ----

data_sds_options_chosen <- data_sds_options_chosen %>% 
  mutate(financial_year   = as.character(financial_year),
         sending_location = recode(sending_location, 
                                     'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
         location_order   = recode(sending_location, 
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
    option_order     = recode(option_type, 
                                     "Any SDS"  = 1,
                                     "Option 1" = 2,
                                     "Option 2" = 3,
                                     "Option 3" = 4,
                                     "Option 4" = 5),
    age_group  = recode(age_group, 'All' = "All Ages",
                               '0-17' = "0-17 years",
                               '18-64' = "18-64 years",
                               '65-74' = "65-74 years",
                               '75-84' = "75-84 years",
                               '85+' = "85+ years"),
    age_order  = recode(age_group, 
                              "All Ages"    = 1,
                              "0-17 years"  = 2,
                              "18-64 years" = 3,
                              "65-74 years" = 4,
                              "75-84 years" = 5,
                              "85+ years"   = 6,
                              "Unknown"     = 7),
    nclient    = as.numeric(nclient),
    rate       = as.numeric(round(rate, 1))
  ) %>% 
  arrange(location_order, sending_location, financial_year, option_order, option_type, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, option_type, nclient, rate)



# OPTIONS BY AGE ----

data_sds_options_proportion <- data_sds_options_proportion %>% 
  mutate(financial_year = as.character(financial_year),
         sending_location = recode(sending_location, 
                                     'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
         location_order   = recode(sending_location, 
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
    sds_option      = as.character(option_type),
    option_order    = recode(sds_option, 
                                     "Option 1 Only" = 1,
                                     "Option 2 Only" = 2,
                                     "Option 3 Only" = 3,
                                     "Option 4 Only" = 4),
    age_group       = recode(age_group, 'All' = "All Ages",
                               '0-17' = "0-17 years",
                               '18-64' = "18-64 years",
                               '65-74' = "65-74 years",
                               '75-84' = "75-84 years",
                               '85+' = "85+ years"),
    age_order       = recode(age_group, 
                              "All Ages"    = 1,
                              "0-17 years"  = 2,
                              "18-64 years" = 3,
                              "65-74 years" = 4,
                              "75-84 years" = 5,
                              "85+ years"   = 6,
                              "Unknown"     = 7),
    percentage    = as.numeric(round(percentage),1),
    nclient = as.numeric(nclient)
  ) %>% 
  arrange(location_order, sending_location, financial_year, option_order, sds_option, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, sds_option, nclient, percentage)



# CLIENT GROUP ----

data_sds_client_group <- data_sds_client_group %>% 
  mutate(financial_year     = as.character(financial_year),
         sending_location   = recode(sending_location, 
                                       'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
         location_order     = recode(sending_location, 
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
    client_group       = recode(client_group,
                                       "Elderly Frail" = "Elderly / Frail"),
    client_group_order = recode(client_group, 
                                       "Dementia" = "A",
                                       "Mental Health" = "A",
                                       "Learning Disability" = "A",            
                                       "Physical and Sensory Disability" = "A",
                                       "Elderly / Frail" = "A",
                                       "Other" = "B"),
    age_group          = recode(age_group, 
                                       'All' = "All Ages",
                                       '0-17' = "0-17 years",
                                       '18-64' = "18-64 years",
                                       '65-74' = "65-74 years",
                                       '75-84' = "75-84 years",
                                       '85+' = "85+ years"),
    age_order          = recode(age_group, 
                                       "All Ages"    = 1,
                                       "0-17 years"  = 2,
                                       "18-64 years" = 3,
                                       "65-74 years" = 4,
                                       "75-84 years" = 5,
                                       "85+ years"   = 6,
                                       "Unknown"     = 7),
    nclient            = as.numeric(nclient),
    rate               = as.numeric(round(rate, 1))
  ) %>% 
  arrange(location_order, sending_location, financial_year, client_group_order, client_group, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, client_group, nclient, rate) 



# SUPPORT & SERVICES NEEDS ----

data_sds_support_needs <- data_sds_support_needs %>% 
  mutate(financial_year     = as.character(financial_year),
         sending_location   = recode(sending_location, 
                                       'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
         location_order     = recode(sending_location, 
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
    support_need       = as.character(support_need),
    support_need_order = recode(support_need, 
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
    age_order          = recode(age_group, 
                                       "All Ages"    = 1,
                                       "0-17 years"  = 2,
                                       "18-64 years" = 3,
                                       "65-74 years" = 4,
                                       "75-84 years" = 5,
                                       "85+ years"   = 6,
                                       "Unknown"     = 7),
    nclient            = as.numeric(nclient),
    rate               = as.numeric(round(rate, 1))
  ) %>% 
  arrange(location_order, sending_location, financial_year, support_need_order, support_need, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, support_need, nclient, rate)



# TYPE OF ORGANISATION ----

data_sds_type_of_organisation <- data_sds_type_of_organisation %>% 
  mutate(financial_year     = as.character(financial_year),
         sending_location   = recode(sending_location, 
                                       'Scotland - All Areas Submitted' = "Scotland (All Areas Submitted)"),
         location_order    = recode(sending_location, 
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
    support_services       = as.character(support_services),
    support_services_order = recode(support_services, 
                                           "Personal Assistance Contract" = "A",
                                           "Local Authority"              = "A",
                                           "Private"                      = "A",  
                                           "Voluntary"                    = "A", 
                                           "Other"                        = "B",
                                           "Not Known"                    = "C"),
    age_group          = as.character(age_group),
    age_order          = recode(age_group, 
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
  arrange(location_order, sending_location, financial_year, support_services_order, support_services, age_order, age_group) %>% 
  select(financial_year, sending_location, age_group, support_services, nclient, rate)



## SAVE ----

# .RDS FILES 

write_rds(data_sds_trend, paste0(shiny_app_data_path, "data_sds_trend.rds"))
write_rds(data_sds_implementation_hscp, paste0(shiny_app_data_path, "data_sds_implementation_hscp.rds"))
write_rds(data_sds_options_chosen, paste0(shiny_app_data_path, "data_sds_options_chosen.rds"))
write_rds(data_sds_client_group, paste0(shiny_app_data_path, "data_sds_client_group.rds"))
write_rds(data_sds_support_needs, paste0(shiny_app_data_path, "data_sds_support_needs.rds"))
write_rds(data_sds_type_of_organisation, paste0(shiny_app_data_path, "data_sds_type_of_organisation.rds"))
write_rds(data_sds_options_proportion, paste0(shiny_app_data_path, "data_sds_options_proportion.rds"))


# .CSV FILES

write_csv(data_sds_trend, paste0(shiny_app_data_path, "data_sds_trend.csv"))
write_csv(data_sds_implementation_hscp, paste0(shiny_app_data_path, "data_sds_implementation_hscp.csv"))
write_csv(data_sds_options_chosen, paste0(shiny_app_data_path, "data_sds_options_chosen.csv"))
write_csv(data_sds_client_group, paste0(shiny_app_data_path, "data_sds_client_group.csv"))
write_csv(data_sds_support_needs, paste0(shiny_app_data_path, "data_sds_support_needs.csv"))
write_csv(data_sds_type_of_organisation, paste0(shiny_app_data_path, "data_sds_type_of_organisation.csv"))
write_csv(data_sds_options_proportion, paste0(shiny_app_data_path, "data_sds_options_proportion.csv"))


## END OF SCRIPT ##