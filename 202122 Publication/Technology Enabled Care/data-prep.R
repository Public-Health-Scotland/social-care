##############################################
## TECHNOLOGY ENABLED CARE DATA PREP SCRIPT ##
##############################################


## PACKAGES ----

library(tidyverse) 
library(haven)      
library(janitor)   
library(glue)       
library(here)


Sys.umask("002")


## FILE PATHS ----


# DATA SAVED:
# \\Isdsf00d03\social-care\05-Analysts\Publication\Publication_2122\TEC\Data\Rounded Data\Final\ 


# DATA OUTPUTS PATH
publication_data_path <- "/conf/social-care/05-Analysts/Publication/Publication_2122/TEC/Rounded Data/"


# SAVE OUTPUT PATH
# /conf/social-care/05-Analysts/Publication/Publication_2122/Shiny Apps/tec_app


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
duplicates_data_tech_enabled_care_trend <- data_tech_enabled_care_trend %>%
  get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_trend") 

data_tech_enabled_care_trend <- unique(data_tech_enabled_care_trend) # 0 rows of data have been removed


# SUMMARY ----
duplicates_data_tech_enabled_care_summary <- data_tech_enabled_care_summary %>% 
  get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_summary") 

data_tech_enabled_care_summary <- unique(data_tech_enabled_care_summary) # 0 rows of data have been removed


# CARE AT HOME ----
duplicates_data_tech_enabled_care_cah <- data_tech_enabled_care_cah %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_cah") 

data_tech_enabled_care_cah <- unique(data_tech_enabled_care_cah)


# LIVING ALONE ----
duplicates_data_tech_enabled_care_living_alone <- data_tech_enabled_care_living_alone %>% 
  get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_living_alone") 

data_tech_enabled_care_living_alone <- unique(data_tech_enabled_care_living_alone)


# DEPRIVATION ----
duplicates_data_tech_enabled_care_deprivation <- data_tech_enabled_care_deprivation %>% janitor::get_dupes() %>% 
  mutate(data_set = "data_tech_enabled_care_deprivation") 

data_tech_enabled_care_deprivation <- unique(data_tech_enabled_care_deprivation)


## SAVE OUT DUPLICATES ----

# COMBINE DUPLICATES
duplicates_data_tech_enabled_care <- rbind(duplicates_data_tech_enabled_care_trend,
                                           duplicates_data_tech_enabled_care_summary,
                                           duplicates_data_tech_enabled_care_cah,
                                           duplicates_data_tech_enabled_care_living_alone,
                                           duplicates_data_tech_enabled_care_deprivation)

# SAVE
write_csv(duplicates_data_tech_enabled_care, glue(shiny_app_data_path, "duplicates_data_tech_enabled_care.csv"))



## FORMAT DATA ----

### TREND ----

data_tech_enabled_care_trend <- data_tech_enabled_care_trend %>% 
  clean_names() %>% 
  mutate(
    financial_year   = as.character(financial_year),
    sending_location = as.character(sending_location),
    sending_location = recode(sending_location,
                              "Na h-Eileanan Siar" = "Comhairle nan Eilean Siar"),
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
    sending_location = recode(sending_location,
                                     "Scotland (All Areas Submitted)" = "Scotland (Estimated)"),
    age_group        = recode(age_group, 
                                     'All ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_order         = ordered(recode(age_group, 
                                        "All Ages" = 1, 
                                        "0-17 years" = 2,
                                        "18-64 years" = 3,
                                        "65-74 years" = 4,
                                        "75-84 years" = 5,
                                        "85+ years" = 6,
                                        "Unknown" = 7)),
    service          = as.character(service),
    service          = recode(service, 
                                     "Community alarm only" = "Community Alarm Only",
                                     "Telecare only" = "Telecare Only",
                                     "Receiving both community alarm and telecare" = "Receiving both Community Alarm and Telecare",
                                     "Total community alarms and/or telecare" = "Total Receiving Community Alarms and/or Telecare"),
    service_order    = recode(service, 
                                     "Community Alarm Only" = 1,
                                     "Telecare Only" = 2,
                                     "Receiving both Community Alarm and Telecare" = 3,
                                     "Total Receiving Community Alarms and/or Telecare" = 4),
    measure          = recode(measure, 
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     'Rate per 1,000 people' = "Rate per 1,000 Population",
                                     'Rate per 1000 people'  = "Rate per 1,000 Population",
                                     'Rate per 1000 People'  = "Rate per 1,000 Population"),
    measure          = as.character(measure),
    measure_order    = recode(measure, 
                                     "Rate per 1,000 Population" = 1,
                                     "Number of People" =2),
    value            = as.numeric(round(value,1))) %>% 
  arrange(financial_year, location_order, sending_location, service_order, service, age_order, age_group, measure_order) %>%     
  select(financial_year, sending_location, service, age_group, measure, value)                                



### SUMMARY ----

data_tech_enabled_care_summary <- 
  data_tech_enabled_care_summary %>%
 # filter(financial_year != "2017/18") %>%
  clean_names() %>% 
  mutate(
    financial_year   = as.character(financial_year),
    sending_location = as.character(sending_location),
    sending_location = recode(sending_location,
                              "Na h-Eileanan Siar" = "Comhairle nan Eilean Siar"),
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
    sending_location = recode(sending_location,
                                     "Scotland" = "Scotland (All Areas Submitted)"),
    age_group        = recode(age_group, 
                                     'All ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_order         = ordered(recode(age_group, 
                                        "All Ages" = 1, 
                                        "0-17 years" = 2,
                                        "18-64 years" = 3,
                                        "65-74 years" = 4,
                                        "75-84 years" = 5,
                                        "85+ years" = 6,
                                        "Unknown" = 7)),
    service          = as.character(service),
    service          = recode(service, 
                                     "Community alarm only" = "Community Alarm Only",
                                     "Telecare only" = "Telecare Only",
                                     "Receiving both community alarm and telecare" = "Receiving both Community Alarm and Telecare",
                                     "Total community alarms and/or telecare" = "Total Receiving Community Alarms and/or Telecare"),
    service_order    = recode(service, "Community Alarm Only" = 1,
                                     "Telecare Only" = 2,
                                     "Receiving both Community Alarm and Telecare" = 3,
                                     "Total Receiving Community Alarms and/or Telecare" = 4),
    measure          = as.character(measure),
    measure          = recode(measure, "Rate per 1,000 People" = "Rate per 1,000 Population"),
    scotland_value   = as.numeric(scotland_value),
    value            = as.numeric(round(value, 1))) %>%
  arrange(financial_year, location_order, sending_location, service_order, service, age_order, age_group) %>%    
  select(financial_year, sending_location,  service, age_group, measure, value, scotland_value)                                # remove order variables


### CARE AT HOME ----

data_tech_enabled_care_cah <- data_tech_enabled_care_cah %>% 
  clean_names() %>% 
  filter(sending_location != "Scotland",
         financial_year != "2017/18") %>%
  mutate(
    financial_year   = as.character(financial_year),
    sending_location = as.character(sending_location),
    sending_location = recode(sending_location,
                              "Na h-Eileanan Siar" = "Comhairle nan Eilean Siar"),
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
    age_group        = recode(age_group, 
                                     'All ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_order         = ordered(recode(age_group, 
                                        "All Ages" = 1, 
                                        "0-17 years" = 2,
                                        "18-64 years" = 3,
                                        "65-74 years" = 4,
                                        "75-84 years" = 5,
                                        "85+ years" = 6,
                                        "Unknown" = 7)),
    cah_status        = as.character(cah_status),
    nclient           = as.numeric(round(nclient,0)),
    percentage        = round(percentage, 1)
  ) %>% 
  arrange(location_order, financial_year, sending_location, 
          age_order, age_group, cah_status) %>% 
  select(financial_year, sending_location, age_group, cah_status, percentage, nclient)



### LIVING ALONE ----

data_tech_enabled_care_living_alone <- data_tech_enabled_care_living_alone %>% 
  filter(financial_year != "2017/18") %>%
  clean_names() %>% 
  mutate(
    financial_year   = as.character(financial_year),
    sending_location = as.character(sending_location),
    sending_location = recode(sending_location,
                                     "Na h-Eileanan Siar" = "Comhairle nan Eilean Siar"),
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
    age_group        = recode(age_group, 
                                     'All ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+' = "85+ years",
                                     '99999' = "Unknown"),
    age_group        = as.character(age_group),
    age_order        = ordered(recode(age_group, 
                                        "All Ages" = 1, 
                                        "0-17 years" = 2,
                                        "18-64 years" = 3,
                                        "65-74 years" = 4,
                                        "75-84 years" = 5,
                                        "85+ years" = 6,
                                        "Unknown" = 7)),
    service          = as.character(service),
    service          = recode(service, 
                              "Community alarm only" = "Community Alarm Only",
                              "Telecare only" = "Telecare Only",
                              "Receiving both community alarm and telecare" = "Receiving both Community Alarm and Telecare",
                              "Total community alarms and/or telecare" = "Total Receiving Community Alarms and/or Telecare"),
    service_order    = recode(service, "Community alarm only" = 1,
                                     "Telecare only" = 2,
                                     "Receiving both Community alarm and Telecare" = 3,
                                     "Total Receiving community Alarms and/or Telecare" = 4),
    living_alone_status = recode(living_alone_status, 
                                        'Yes' = "Living Alone",
                                        'No' = "Not Living Alone",
                                        "not known" = "Not Known"),
    living_alone_status = as.character(living_alone_status),
    living_alone_order  = recode(living_alone_status, 
                                        "Living Alone" = 1,
                                        "Not Living Alone" = 2,
                                        "Not Known" = 3,
                                        "Not Recorded" = 3,
                                        "Unknown" = 3),
    nclient   = as.numeric(round(nclient,0)),
    percentage = as.numeric(round(percentage,1))
  ) %>% 
  arrange(location_order, sending_location, financial_year, service_order, service, 
                 age_order, age_group) %>%    
  select(financial_year, sending_location, service, 
         age_group, living_alone_status, percentage, nclient)    



### DEPRIVATION ----

data_tech_enabled_care_deprivation <- data_tech_enabled_care_deprivation %>% 
  clean_names() %>%
  mutate(
    sending_location = recode(sending_location,
                              "Na h-Eileanan Siar" = "Comhairle nan Eilean Siar"),
    financial_year   = as.character(financial_year),
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
    age_group        = recode(age_group, 
                                     'All ages' = "All Ages",
                                     '0-17' = "0-17 years",
                                     '18-64' = "18-64 years",
                                     '65-74' = "65-74 years",
                                     '75-84' = "75-84 years",
                                     '85+'   = "85+ years",
                                     '99999' = "Unknown"),
    age_group         = as.character(age_group),
    age_order         = ordered(recode(age_group, 
                                        "All Ages" = 1, 
                                        "0-17 years" = 2,
                                        "18-64 years" = 3,
                                        "65-74 years" = 4,
                                        "75-84 years" = 5,
                                        "85+ years" = 6,
                                        "Unknown" = 7)),
    simd             = as.character(simd),
    simd_order       = ordered(recode(simd,
                                         "1 (Most Deprived)" = 1,
                                         "2" = 2,
                                         "3" = 3,
                                         "4" = 4,
                                         "5 (Least Deprived)" = 5,
                                         "Unknown" = 6)),
    measure          = recode(measure, 
                                     'Number of people' = "Number of People",
                                     'number of people' = "Number of People",
                                     'SIMD quintile proportion' = "SIMD Quintile Proportion",
                                     'simd quintile proportion'  = "SIMD Quintile Proportion"),
    measure          = as.character(measure),
    value            = as.numeric(round(value,1))
  ) %>%
  arrange(location_order, financial_year, sending_location, 
          age_order, age_group,  simd_order
  ) %>% 
  select(financial_year, sending_location, #service, 
         age_group, simd, 
         measure, value)



## SAVE ----

# .RDS FILES

write_rds(data_tech_enabled_care_trend, glue(shiny_app_data_path, "data_tech_enabled_care_trend.rds"))
write_rds(data_tech_enabled_care_summary, glue(shiny_app_data_path, "data_tech_enabled_care_summary.rds"))
write_rds(data_tech_enabled_care_cah, glue(shiny_app_data_path, "data_tech_enabled_care_cah.rds"))
write_rds(data_tech_enabled_care_living_alone, glue(shiny_app_data_path, "data_tech_enabled_care_living_alone.rds"))
write_rds(data_tech_enabled_care_deprivation, glue(shiny_app_data_path, "data_tech_enabled_care_deprivation.rds"))


# .CSV FILES

write_csv(data_tech_enabled_care_trend, glue(shiny_app_data_path, "data_tech_enabled_care_trend.csv"))
write_csv(data_tech_enabled_care_summary, glue(shiny_app_data_path, "data_tech_enabled_care_summary.csv"))
write_csv(data_tech_enabled_care_cah, glue(shiny_app_data_path, "data_tech_enabled_care_cah.csv"))
write_csv(data_tech_enabled_care_living_alone, glue(shiny_app_data_path, "data_tech_enabled_care_living_alone.csv"))
write_csv(data_tech_enabled_care_deprivation, glue(shiny_app_data_path, "data_tech_enabled_care_deprivation.csv"))


## END OF SCRIPT ##