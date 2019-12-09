# Data prep script 
# creates main data file to be used in shiny app
# i.e.  underlying shiny app data

#### 1: Script Setup/ Housekeeping ----

# Packages & functions 

source("packages.R")
#source("functions.R")


# filepaths
# previous data location
# \\Isdsf00d03\social-care\05-Analysts\Publication\Shiny outputs\Final Publication Outputs

data_extracts <- "/05-Analysts/Publication/Shiny outputs/Final Publication Outputs/"
## TO DO : UPDATE LOOKUP FILE & LOCATION
lookups <- "/05-Analysts/SG-annual-sc-extract/data-lookups/"

# load in data & cleane variable names
# SDS data to be used as test "SDS_All_Files_20190528.xlsx"

sds_data <- read_xlsx(glue(data_extracts, "SDS_All_Files_20190528.xlsx")) %>% 
              clean_names()

# might need the following too: "SDS TREND 20190415.xlsx"  
sds_trend <- read_xlsx(glue(data_extracts, "SDS TREND 20190415.xlsx")) %>% 
             clean_names()

# list files available in data_extracts folder

list.files(data_extracts)

# Care home files "CH_files_20190516.xlsx"  "CH_extratable_20190417.xlsx"     
carehome <- read_xlsx(glue(data_extracts, "CH_files_20190516.xlsx")) %>% 
            clean_names()
                                             
# client files "client_alltables20190524_notonly0s_totalsEstimated_withdisclosure.xlsx" - find non-disclosure version
clients <- read_xlsx(glue(data_extracts, "client_alltables20190524_notonly0s_totalsEstimated_withdisclosure.xlsx")) %>% 
  clean_names()

# equipment ("Equip_All_Files_20190429.xlsx"     "Equip_Table1_Trenddata_2015_2017.xlsx"                                 
equipment <- read_xlsx(glue(data_extracts, "Equip_All_Files_20190429.xlsx")) %>% 
  clean_names()

# home care files: "HC census week rate.xlsx"         "homecare_alltables201900516_latest.xlsx"                               
homecare <- read_xlsx(glue(data_extracts, "homecare_alltables201900516_latest.xlsx")) %>% 
  clean_names()

# iorn "IoRN_20190516.xlsx"                                                    
iorn <- read_xlsx(glue(data_extracts, "IoRN_20190516.xlsx")) %>% 
  clean_names()

# meals? - check where this is in dashboard "Meals_All_Files_20190515.xlsx" 

# sds data will be used as a test initially before other data sources are pulled in

la_lookup <- read_xlsx(glue(lookups, "SG-local-authority-code-lookup.xlsx")) %>% 
              clean_names() %>% 
              dplyr::rename(la_name = scottish_gov_la_name,
                            la_code = scottish_gov_la_code)
              
#### 2: data linkage ----


#### 3: data cleaning ----



#### 4: final formatting for file to be used to build shiny app



# create a dummy data set for now to test global.R script

sc_data <- la_lookup %>% 
              mutate(sc_data_source = "SDS",
                     year = 2017)


#### 5: save file ----
# save file for use in global.R script

sc_data %>% write_rds("data/sc_data.rds")

#### End of Script #####