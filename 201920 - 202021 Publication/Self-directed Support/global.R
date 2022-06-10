#####################################################
## Self-directed Support Global Script ##
#####################################################


# Description - Describe what the app does (e.g. visualizes births data)
# this section includes the non-reactive elements and everything used by both the
# UI and Server sides: functions, packages, data, etc.

############################.
## Packages ----
############################.

### install / load packages
### the following packages are required for this R script
### the code below will load packages and check if a required packages needs to be installed 
### and will install it if necessary.

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


###############################################.
## Data ----
###############################################.    

##### FILE PATHS

# filepath to data folder in sds app r project file
data_filepath <- here("data/")

#### READ IN .rds FILES #####

# loading in rds files (this should mean all variables have kept their formatting)
# read all .rds files from \\Isdsf00d03\social-care\05-Analysts\Publication\Publication_1920\Shiny Apps\equipment-shiny-app\data

# list all files ending in extension ".rds"
rds_file_names <- list.files(path = data_filepath, pattern = "*.rds") 

# apply the read_rds function to all files listed in the rds_file_name object,
# these data frames will then be held in the rds_data_files_list

rds_data_files_list <- lapply(paste0(data_filepath, rds_file_names), read_rds)

#assign names to data.frames (data frames should keep the original file name but remove ".rds" from it)
names(rds_data_files_list) <- gsub(".rds","", rds_file_names, fixed = TRUE)

# create individual data file objects in the global environment, rather than keeping them as a list of data frames
#note the invisible function keeps lapply from spitting out the data.frames to the console

invisible(lapply(names(rds_data_files_list), function(x) assign(x, rds_data_files_list[[x]], envir=.GlobalEnv)))

#### FORMAT DATA ----

## SDS data completeness table -----

data_completeness_table <- readxl::read_excel(paste0(data_filepath, "data_completeness_table_self_directed_support.xlsx"), col_names = TRUE) %>% 
                               arrange(`Data Set`, desc(`Financial Year`))


################################################
## Palettes ----
###############################################   
# PHS colour HEX	   80%	    50%	    30%     10%
# Purple  	#3F3685	#655E9D	#9F9BC2	#C5C3DA	#ECEBF3
# Magenta  	#9B4393	#AF69A9	#CDA1C9	#E1C7DF	#F5ECF4
# Blue	    #0078D4	#3393DD	#80BCEA	#B3D7F2	#E6F2FB
# Green	    #83BB26	#9CC951	#C1DD93	#DAEBBE	#F3F8E9
# Graphite	#948DA3	#A9A4B5	#CAC6D1	#DFDDE3	#F4F4F6
# Teal	    #1E7F84	#4B999D	#8FBFC2	#BCD9DA	#E9F2F3
# Liberty 	#6B5C85	#897D9D	#B5AEC2	#D3CEDA	#F0EFF3
# Rust	    #C73918	#D26146	#E39C8C	#EEC4BA	#F9EBE8

# colour for bar chart markers
phs_bar_col <- list(color = "#3F3685")

## palette for stacked bar chart with two colours
stacked_bar_pal <-  c("#3F3685", "#9F9BC2") 

# two colour pallete for age / sex back to back bar plot (pyramid chart)
palette_agesex_plot <- c('#9ebcda','#8856a7')      # PHS palette

# full colour palette (dark to light, left to right)
two_col_pal <-  c("#3F3685", "#9F9BC2") 
three_col_pal <-  c("#3F3685",	"#655E9D",	"#9F9BC2")
four_col_pal <- c("#3F3685",	"#655E9D",	"#9F9BC2",	"#C5C3DA")
five_col_pal <- c("#3F3685",	"#655E9D",	"#9F9BC2",	"#C5C3DA",	"#ECEBF3")    
six_col_pal <- c("#3F3685",	"#655E9D",	"#9F9BC2",	"#C5C3DA",	"#ECEBF3", "#FFFFFF")

#### TREND LINE STYLE SETTINGS #####
# main location line

trend_line_setting <- list(color = "#3F3685")
trend_marker_setting <- list(color = "#3F3685")

# comparison location line

comparison_trend_line_setting <- list(color = '#AF69A9', dash = 'dash')
comparison_trend_marker_setting <-  list(color = '#AF69A9')

#### SCOTLAND REFERENCE LINE SETTING (bar plot, Scotland reference line) ##### 
reference_line_style <- I("black") # colour pre pubs team advice

##############################
## Style settings ----
##############################

axis_font <- list(family = "Neue Helvetica",
                  size = 14)

########################
### button settings ----
########################

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

# high contrast in line with accessibility requirements

button_style_showhide <- "color: #000000; background-color:#fff; border-color: #000000"

# individual button colour settings - used to specify download data button settings

button_background_col <- "{ background-color: #fff; } "          # white
button_text_col       <- "{ color: #000000; } "                  # black
button_border_col     <- "{ border-color: #000000; } "           # black           



## END OF SCRIPT 