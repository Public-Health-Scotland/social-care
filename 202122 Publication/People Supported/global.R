#####################################################.
## CLIENT GLOBAL SCRIPT ##
#####################################################.

############################.
## PACKAGES ----
############################.


if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('dplyr')) install.packages('dplyr'); library('dplyr')
if (!require('tidyr')) install.packages('tidyr'); library('tidyr')
if (!require('readr')) install.packages('readr'); library('readr')
if (!require('remotes')) install.packages('remotes'); library('remotes')
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
## TIME PERIOD ---- 
###########################.


data_time_period_start <- "2017/18"
data_time_period_end <- "2021/22"
first_quarter <- "2017/18 Q4"
last_quarter <- "2021/22 Q4"
first_census_week <- "2010"
last_census_week <- "2022"          




############################.
## FILE PATHS ----
############################.


data_filepath <- "data/"

data_table_filepath <- "data_tables/"


# READ IN RDS FILES #

rds_file_names <- list.files(path = data_filepath, pattern = "*.rds")

rds_data_files_list <- lapply(paste0(data_filepath, rds_file_names), read_rds)

names(rds_data_files_list) <- gsub(".rds","", rds_file_names, fixed = TRUE)

invisible(lapply(names(rds_data_files_list), function(x) assign(x, rds_data_files_list[[x]], envir=.GlobalEnv)))



############################.
## DATA  ----
############################.   

#### DATA COMPLETENESS TABLE ----

data_completeness_table <- readxl::read_excel(paste0(data_table_filepath, "data_completeness_table_people_supported.xlsx"), col_names = TRUE) %>% 
  mutate(year_order = recode(`Financial Year`,
                             "2021/22" = 1,
                             "2020/21" = 2,
                             "2019/20" = 3,
                             "2018/19" = 4,
                             "2017/18" = 5,
                             "All" = 6)) %>% 
  arrange(year_order, `Data Set`, desc(`Financial Year`), `Health and Social Care Partnership`) %>% 
  select(-year_order)


#### DATA QUALITY TABLE ----

data_quality_table <- readxl::read_excel(paste0(data_table_filepath, "data_quality_table_people_supported.xlsx"), col_names = TRUE) %>% 
  mutate(year_order = recode(`Financial Year`,
                             "2021/22" = 1,
                             "2020/21" = 2,
                             "2019/20" = 3,
                             "2018/19" = 4,
                             "2017/18" = 5,
                             "All" = 6)) %>% 
  arrange(year_order,`Financial Year`, `Data Set`) %>% 
  select(-year_order)



## APPENDIX TABLE

appendix_table <- readxl::read_excel(paste0(data_table_filepath, "partnership_estimated_table_people_supported.xlsx"), col_names = TRUE)



############################.
## STYLES ---
############################.

# previously "f1"
plot_title_font <-  list(
  family = "Neue Helvetica",
  size = 14,
  color = '#ffffff')

# previously "f2"
plot_axis_font <- list(
  family = "Neue Helvetica",
  size = 14,
  color = '#ffffff')



############################.
## COLOUR PALETTES ----
############################ .
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



# SHOW/HIDE
button_style_showhide <- "color: #000000; background-color:#fff; border-color: #000000"


# DOWNLOAD DATA 
button_background_col <- "{ background-color: #fff; } "          # white
button_text_col       <- "{ color: #000000; } "                  # black
button_border_col     <- "{ border-color: #000000; } "           # black           


############################.
## END OF SCRIPT ----
############################ .