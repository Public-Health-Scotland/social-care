#####################################################.
## SDS GLOBAL SCRIPT ##
#####################################################.

############################.
## PACKAGES ----
############################.


if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('dplyr')) install.packages('dplyr'); library('dplyr')
if (!require('tidyr')) install.packages('tidyr'); library('tidyr')
if (!require('readr')) install.packages('readr'); library('readr')
if (!require('here')) install.packages('here'); library('here')
if (!require('shiny')) remotes::install_version("shiny", version = "1.7.1"); library('shiny')
if (!require('shinydashboard')) remotes::install_version("shinydashboard", version = "0.7.1"); library('shinydashboard')
if (!require('shinyjs')) remotes::install_version("shinyjs", version = "1.1"); library('shinyjs')
if (!require('shinyWidgets')) remotes::install_version("shinyWidgets", version = "0.5.3"); library('shinyWidgets')
if (!require('DT')) install.packages('DT'); library('DT')
if (!require('plotly')) remotes::install_version("plotly", version = "4.9.2.1"); library('plotly')
if (!require('vctrs')) install.packages('vctrs'); library('vctrs')
if (!require('packcircles')) install.packages('packcircles'); library('packcircles')
if (!require('shinymanager')) install.packages('shinymanager'); library('shinymanager')


############################.
## FILE PATHS ----
############################.   


data_filepath <- here("data/")

data_table_filepath <- "data_tables/"


# READ IN RDS FILES #
rds_file_names <- list.files(path = data_filepath, pattern = "*.rds") 

rds_data_files_list <- lapply(paste0(data_filepath, rds_file_names), read_rds)

names(rds_data_files_list) <- gsub(".rds","", rds_file_names, fixed = TRUE)

invisible(lapply(names(rds_data_files_list), function(x) assign(x, rds_data_files_list[[x]], envir=.GlobalEnv)))



############################.
## DATA  ----
############################.


## DATA COMPLETENESS TABLE ----

data_completeness_table <- readxl::read_excel(paste0(data_table_filepath, "SDS_data_completeness_quality.xlsx"), col_names = TRUE, sheet = "Data Completeness") %>% 
  mutate(year_order = recode(`Financial Year`,
                             "2021/22" = 1,
                             "2020/21" = 2,
                             "2019/20" = 3,
                             "2018/19" = 4,
                             "2017/18" = 5,
                             "All" = 6),
         location_order = recode(`Health and Social Care Partnership`,
                                 "Aberdeen City"                  = 1,
                                 "Aberdeenshire"                  = 2,
                                 "Angus"                          = 3,
                                 "Argyll and Bute"                = 4,
                                 "City of Edinburgh"              = 5,
                                 "Clackmannanshire"               = 6,
                                 "Comhairle nan Eilean Siar"      = 7,
                                 "Dumfries and Galloway"          = 8,
                                 "Dundee City"                    = 9,
                                 "East Ayrshire"                  = 10,
                                 "East Dunbartonshire"            = 11,
                                 "East Lothian"                   = 12,
                                 "East Renfrewshire"              = 13,
                                 "Falkirk"                        = 14,
                                 "Fife"                           = 15,
                                 "Glasgow City"                   = 16,
                                 "Highland"                       = 17,
                                 "Inverclyde"                     = 18,
                                 "Midlothian"                     = 19,
                                 "Moray"                          = 20,
                                 "North Ayrshire"                 = 21,
                                 "North Lanarkshire"              = 22,
                                 "Orkney Islands"                 = 23,
                                 "Perth and Kinross"              = 24,
                                 "Renfrewshire"                   = 25,
                                 "Scottish Borders"               = 26,
                                 "Shetland Islands"               = 27,
                                 "South Ayrshire"                 = 28,
                                 "South Lanarkshire"              = 29,
                                 "Stirling"                       = 30,
                                 "West Dunbartonshire"            = 31,
                                 "West Lothian"                   = 32
         )) %>% 
  arrange(year_order,location_order,`Data Set`, desc(`Financial Year`), `Health and Social Care Partnership`) %>% 
  select(-year_order, -location_order)

## DATA QUALITY TABLE ----

data_quality_table <- readxl::read_excel(paste0(data_table_filepath, "SDS_data_completeness_quality.xlsx"), col_names = TRUE, sheet = "Data Quality") %>% 
  mutate(year_order = recode(`Financial Year`,
                             "2021/22" = 1,
                             "2020/21" = 2,
                             "2019/20" = 3,
                             "2018/19" = 4,
                             "2017/18" = 5,
                             "All" = 6),
         
         location_order = recode(`Health and Social Care Partnership`,
                                 "Aberdeen City"                  = 1,
                                 "Aberdeenshire"                  = 2,
                                 "Angus"                          = 3,
                                 "Argyll and Bute"                = 4,
                                 "City of Edinburgh"              = 5,
                                 "Clackmannanshire"               = 6,
                                 "Comhairle nan Eilean Siar"      = 7,
                                 "Dumfries and Galloway"          = 8,
                                 "Dundee City"                    = 9,
                                 "East Ayrshire"                  = 10,
                                 "East Dunbartonshire"            = 11,
                                 "East Lothian"                   = 12,
                                 "East Renfrewshire"              = 13,
                                 "Falkirk"                        = 14,
                                 "Fife"                           = 15,
                                 "Glasgow City"                   = 16,
                                 "Highland"                       = 17,
                                 "Inverclyde"                     = 18,
                                 "Midlothian"                     = 19,
                                 "Moray"                          = 20,
                                 "North Ayrshire"                 = 21,
                                 "North Lanarkshire"              = 22,
                                 "Orkney Islands"                 = 23,
                                 "Perth and Kinross"              = 24,
                                 "Renfrewshire"                   = 25,
                                 "Scottish Borders"               = 26,
                                 "Shetland Islands"               = 27,
                                 "South Ayrshire"                 = 28,
                                 "South Lanarkshire"              = 29,
                                 "Stirling"                       = 30,
                                 "West Dunbartonshire"            = 31,
                                 "West Lothian"                   = 32)) %>% 
  arrange(year_order, location_order, `Data Set`, desc(`Financial Year`), `Health and Social Care Partnership`) %>% 
  select(-year_order, -location_order)


############################.
## STYLES ---
############################.

axis_font <- list(family = "Neue Helvetica",
                  size = 14)


############################.
## COLOUR PALETTES ----
############################.   
# PHS colour HEX	   80%	    50%	    30%     10%
# Purple  	#3F3685	#655E9D	#9F9BC2	#C5C3DA	#ECEBF3
# Magenta  	#9B4393	#AF69A9	#CDA1C9	#E1C7DF	#F5ECF4
# Blue	    #0078D4	#3393DD	#80BCEA	#B3D7F2	#E6F2FB
# Green	    #83BB26	#9CC951	#C1DD93	#DAEBBE	#F3F8E9
# Graphite	#948DA3	#A9A4B5	#CAC6D1	#DFDDE3	#F4F4F6
# Teal	    #1E7F84	#4B999D	#8FBFC2	#BCD9DA	#E9F2F3
# Liberty 	#6B5C85	#897D9D	#B5AEC2	#D3CEDA	#F0EFF3
# Rust	    #C73918	#D26146	#E39C8C	#EEC4BA	#F9EBE8



# BAR CHART
phs_bar_col <- list(color = "#3F3685")

# STACKED BAR CHARTS
stacked_bar_pal <-  c("#3F3685", "#9F9BC2") 

# AGE / SEX
palette_agesex_plot <- c('#9ebcda','#8856a7')      # PHS palette

# full colour palette (dark to light, left to right)
two_col_pal <-  c("#3F3685", "#9F9BC2") 
three_col_pal <-  c("#3F3685",	"#655E9D",	"#9F9BC2")
four_col_pal <- c("#3F3685",	"#655E9D",	"#9F9BC2",	"#C5C3DA")
five_col_pal <- c("#3F3685",	"#655E9D",	"#9F9BC2",	"#C5C3DA",	"#ECEBF3")    
six_col_pal <- c("#3F3685",	"#655E9D",	"#9F9BC2",	"#C5C3DA",	"#ECEBF3", "#FFFFFF")



# TREND LINE
trend_line_setting <- list(color = "#3F3685")
trend_marker_setting <- list(color = "#3F3685")


# COMAPRISON LINE
comparison_trend_line_setting <- list(color = '#AF69A9', dash = 'dash')
comparison_trend_marker_setting <-  list(color = '#AF69A9')


# SCOTLAND REFERENCE LINE
reference_line_style <- I("black") # colour pre pubs team advice



############################.
## BUTTONS ----
############################. 


# ONLY KEEP PNG AND ICON BUTTONS
buttons_to_remove <- list(
  "select2d",
  "lasso2d",
  "zoomIn2d",
  "zoomOut2d",
  "autoScale2d",
  "toggleSpikelines",
  "hoverCompareCartesian",
  "hoverClosestCartesian")


purple_button_style <- "color: #fff; background-color:#7c6ec4; border-color: #636363"
blue_button_style <- "color: #fff; background-color:#2171b5; border-color: #636363"


# SHOW/HIDE
button_style_showhide <- "color: #000000; background-color:#fff; border-color: #000000"


# DOWNLOAD DATA 
button_background_col <- "{ background-color: #fff; } "          # white
button_text_col       <- "{ color: #000000; } "                  # black
button_border_col     <- "{ border-color: #000000; } "           # black           



############################.
## END OF SCRIPT ----
############################. 