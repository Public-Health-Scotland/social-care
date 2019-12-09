# Script looks at data used in previous publication shiny app 201718
# creates test data for using in the data prep script
# the data formats produced here should reflect the final SPSS outputs created in the syntax?? CHECK 
# creates data files as to be passed to data prep script for testing

#### 1: Script Setup/ Housekeeping ----

# Packages & functions 

library(tidyverse)  # data manipulation
library(janitor)    # cleaning variable names
library(openxlsx)   # read in & save out excel files


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
sds_trend <- read.xlsx(glue(data_extracts, "SDS TREND 20190415.xlsx")) %>% 
             clean_names()

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
              
#### 2: data linkage ----


#### 3: data cleaning ----

# care home - remove 



#### 4: final formatting for files to be used as test data to pass to data prep script





#### 5: save file ----
# save files for use 1.Data prep.R script

sDS_data %>% write.xlsx("data/sds_data.xlsx")

#### End of Script #####