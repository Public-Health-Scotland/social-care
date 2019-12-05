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

data_extracts <- "/conf/social-care/05-Analysts/Publication/Shiny outputs/Final Publication Outputs/"
## TO DO : UPDATE LOOKUP FILE & LOCATION
lookups <- "/conf/social-care/05-Analysts/SG-annual-sc-extract/data-lookups/"

# load in data & cleane variable names
# SDS data to be used as test "SDS_All_Files_20190528.xlsx"

sds_data <- read_xlsx(glue(data_extracts, "SDS_All_Files_20190528.xlsx")) %>% 
              clean_names()
# might need the following too: "SDS TREND 20190415.xlsx"  
sds_trend <- read_xlsx(glue(data_extracts, "SDS TREND 20190415.xlsx")) %>% 
             clean_names()

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