# Script looks at data used in previous publication shiny app 201718
# creates test data for using in the data prep script
# the data formats produced here should reflect the final SPSS outputs created in the syntax?? CHECK 
# creates data files as to be passed to data prep script for testing

## TO DO: check how to automate disclosure control - would need to go back to previous versions of files
## or add a column to identify which rows have had disclosure applied to final files held at data_extracts file path

#### 1: Script Setup/ Housekeeping ----

# Packages & functions 

library(tidyverse)  # data manipulation
library(janitor)    # cleaning variable names
library(openxlsx)   # read in & save out excel files
library(tidyselect) # manipulate variable names

# filepaths
# previous data location
# \\Isdsf00d03\social-care\05-Analysts\Publication\Shiny outputs\Final Publication Outputs

data_extracts <- "/05-Analysts/Publication/Shiny outputs/Final Publication Outputs/"
## TO DO : UPDATE LOOKUP FILE & LOCATION
lookups <- "/05-Analysts/SG-annual-sc-extract/data-lookups/"

# load in data & clean variable names

# check files created in the 201718 publication that were used for underlying shiny app

# list files available in data_extracts folder
list.files(data_extracts)

# load data files

# SDS data "SDS_All_Files_20190528.xlsx"

sds_data <- read.xlsx(glue(data_extracts, "SDS_All_Files_20190528.xlsx")) %>% 
              clean_names()

# "SDS TREND 20190415.xlsx"  
# sds_trend <- read.xlsx(glue(data_extracts, "SDS TREND 20190415.xlsx")) %>% 
#             clean_names()

# Care home files "CH_files_20190516.xlsx"  "CH_extratable_20190417.xlsx"     
carehome <- read.xlsx(glue(data_extracts, "CH_files_20190516.xlsx")) %>% 
            clean_names()
                                             
# client files "client_alltables20190524_notonly0s_totalsEstimated_withdisclosure.xlsx" - find non-disclosure version
clients <- read.xlsx(glue(data_extracts, "client_alltables20190524_notonly0s_totalsEstimated_withdisclosure.xlsx")) %>% 
  clean_names()

# equipment ("Equip_All_Files_20190429.xlsx"     "Equip_Table1_Trenddata_2015_2017.xlsx"                                 
equipment <- read.xlsx(glue(data_extracts, "Equip_All_Files_20190429.xlsx")) %>% 
  clean_names()

# home care files: "HC census week rate.xlsx"         "homecare_alltables201900516_latest.xlsx"                               
homecare <- read.xlsx(glue(data_extracts, "homecare_alltables201900516_latest.xlsx")) %>% 
  clean_names()

# iorn "IoRN_20190516.xlsx"                                                    
iorn <- read.xlsx(glue(data_extracts, "IoRN_20190516.xlsx")) %>% 
                  clean_names()

# meals? - check where this is in dashboard "Meals_All_Files_20190515.xlsx" 

# lookup file for sending locations / la names

la_lookup <- read.xlsx(glue(lookups, "SG-local-authority-code-lookup.xlsx")) %>% 
              clean_names() %>% 
              dplyr::rename(la_name = scottish_gov_la_name,
                            la_code = scottish_gov_la_code)
              
#### 2: data cleaning ----

# check variable names & types
# check percentage variable, all numeric not character?

## equipment data 

equipment %>% summarise_all(typeof) %>% 
             gather() 

# rename financial year to year to match other data sets "year" variable
# update variable formats for number of individuals from character to number
# some equipment totals appear as "*" character due to disclosure having been applied 
# these will become NA's

equipment <- equipment %>% 
             plyr::rename(c("fin_yr" = "year", "name" = "table_type")) %>% 
             mutate(total                 = as.numeric(total),
                    community_alarms_only = as.numeric(community_alarms_only),
                    telecare_only         = as.numeric(telecare_only),
                    both                  = as.numeric(both))

## IoRN Data 

iorn %>% summarise_all(typeof) %>% 
         gather() 
# denominator & percentage = double
# rename variables

iorn <- iorn %>% 
  plyr::rename(c("io_rn_group" = "iorn_group", "reason" = "table_type")) %>% 
  mutate(nclient = as.numeric(nclient))

## care home data
carehome %>% summarise_all(typeof) %>% 
             gather() 

# percentage denom & num = double
# care home doesn't include a time variable
# care home is in quarters? - jan - mar?
# change nclient var from char to numeric

carehome <- carehome %>% 
            mutate(nclient_qtr = as.numeric(nclient_qtr),
                   nclient_j = as.numeric(nclient_j),
                   nclient_f = as.numeric(nclient_f),
                   nclient_m = as.numeric(nclient_m)) %>% 
            plyr::rename(c("type" = "table_type"))

# remove variables related to census week for all data sets????
# census week data won't be refered to in 201819 publication data
# only carehome data refers to census week
# 
# carehome <- carehome %>% 
#             select(-c(nclient_j, nclient_f, nclient_m, mlos_m_cen)) %>% 
#             select(-(contains("census"))) # select only variables that dont include "census" in the variable name

## home care data

homecare %>% summarise_all(typeof) %>% 
              gather() 

# missing time variable - add year = 2017/18 variable

# percentage and nclient variable = char - UPDATE to = numeric
# percentage & nclient includes "*" as disclosure has been applied
# these will be changed to NA's 
# rename type variable

homecare <- homecare %>% 
            mutate(nclient = as.double(nclient),
                   percentage = as.double(percentage),
                   year       = "2017/18") %>% 
            plyr::rename(c("name" = "table_type"))

### clients data 

clients %>% summarise_all(typeof) %>% 
              gather() 

# rename age_band to age_group and reason variable
# change nclient from char to numeric variable

clients <- clients %>% 
           plyr::rename(c("age_band" = "age_group", "reason" = "table_type")) %>% 
           mutate(nclient = as.numeric(nclient))

## sds data 

sds_data %>% summarise_all(typeof) %>% 
              gather() 

# rename sds "name" variable to "table_type" to be consistent with other data sets
# change total_opts and all_opts variables from characters to numeric

sds_data <- sds_data %>% 
            mutate(total_option1 = as.numeric(total_option1),
                   total_option2 = as.numeric(total_option2),
                   total_option3 = as.numeric(total_option3),
                   total_option4 = as.numeric(total_option4),
                   all_options   = as.numeric(all_options)) %>% 
            plyr::rename(c("name" = "table_type"))


#### 3: data linkage ----
# merge data into one data file and look at all variables

socialcare <- bind_rows("Clients"   = clients,
                        "Care Home" = carehome,
                        "Home Care" = homecare,
                        "SDS"       = sds_data,
                        "Equipment" = equipment,
                        "IoRN"      = iorn,
                        .id = "sc_service") # create a variable identifying the original data source

# check social care service has been added correctly
unique(socialcare$sc_service)

# check table type variable
unique(socialcare$table_type)

# remove rows relating to census week

socialcare <- socialcare %>% 
                filter(!grepl('census', table_type, ignore.case = T))   # remove rows with any mention of census in the table_type (table name)

# look at the following in more detail
# "Table 1 All clients"
# NA                                                                 
# "Table 1 Number and percentage of clients by IoRN Group for table" 

# check table_types by social care service

service_table_types <- socialcare %>% 
                   select(year, sc_service, table_type, sending_location, nclient, nclient_qtr) %>% 
                   # mutate(nclient   = as.numeric(nclient),
                   #        nclient_q = as.numeric(nclient_qtr)) %>%
                   filter(sending_location == "Scotland") %>% 
                   filter(is.na(table_type) | table_type == "Table 1 All clients" | table_type == "Table 1 Number and percentage of clients by IoRN Group for table" ) #

unique(service_table_types$table_type)


# check locations included in data
unique(socialcare$sending_location)

# check age groups included
unique(socialcare$age_group)

#### 4: Data checks ----

# number of clients in scotland by sc_service and year

class(socialcare$nclient)

detach(package:plyr)  

scotland_clients <- socialcare %>% 
                    filter(sending_location == "Scotland" & age_group == "All ages" | is.na(age_group)) %>% 
                    filter(is.na(table_type) | table_type == "Table 1 All clients" | table_type == "Table 1 Number and percentage of clients by IoRN Group for table" ) %>% 
                    select(sc_service, age_group, table_type, nclient, nclient_qtr,
                             community_alarms_only, telecare_only, both,
                             total_option1, all_options) %>% 
                      mutate(nclient           = as.numeric(nclient),
                             nclient_qtr       = as.numeric(nclient_qtr),
                             alarms_only       = as.numeric(community_alarms_only),
                             telecare_only     = as.numeric(telecare_only),
                             alarms_tele_combo = as.numeric(both),
                             sds_all_opts      = as.numeric(all_options),
                             sds_opt1         = as.numeric(total_option1)) %>%
                      dplyr::group_by(sc_service) %>%                     
                      summarise(scotland_clients      = max(nclient, na.rm = TRUE),
                                ch_clients            = max(nclient_qtr, na.rm = TRUE),
                                alarms_clients        = max(alarms_only, na.rm = TRUE),
                                tele_clients          = max(telecare_only, na.rm = TRUE),
                                AT_clients            = max(alarms_tele_combo, na.rm = TRUE),
                                sds_all_opts_clients  = max(sds_all_opts, na.rm = TRUE),
                                sds_opt_1_clients     = max(sds_opt1, na.rm = TRUE)) %>% 
                      filter_if(is.numeric,
                                ~ !is.na(.))

# reshape data 
# want cols: sc_service, client_type, nclients

sc_scotland_reshape <- scotland_clients %>% 
                        gather(client_type, nclients, - sc_service, na.rm = TRUE) %>% 
                        filter(is.finite(nclients)) # remove rows containing "-Inf"

view(sc_scotland_reshape)

# check figures against published shiny app



## check data completeness?



#### 5: final formatting for files to be used as test data to pass to data prep script




#### 5: save file ----
# save files for use 1.Data prep.R script

sDS_data %>% write.xlsx("data/sds_data.xlsx")

#### End of Script #####