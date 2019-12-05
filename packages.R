############################.
# required packages
############################.

### Data Prep functions

library(glue)     # more useful version of base R paste()
library(readxl)   # read excel files
library(readr)    # open and save .rds files
library(janitor)  # cleans variable names
library(dplyr)    # data manipulation
 
### Shiny app functions

library(shiny)
library(rintrojs) # for help intros (js = javascript)


# from scotpho example - check if all are needed
# 
# library(shinyBS) #modals
# library(shinythemes) # layouts for shiny
# library(ggplot2) #data visualization
 library(DT) # for data tables
# library(leaflet) #javascript maps
# library(plotly) #interactive graphs
 library(shinyWidgets) # for extra widgets
# library(tibble) # rownames to column in techdoc
# library(shinyjs)
# library(shinydashboard) #for valuebox on techdoc tab
# library(sp)
# library(lubridate) #for automated list of dates in welcome modal
# library(shinycssloaders) #for loading icons, see line below
# library(rmarkdown)
# library(flextable) #for tech document table
# library(webshot) #to download plotly charts
# # As well as webshot phantomjs is needed l to download Plotly charts
# # https://github.com/rstudio/shinyapps-package-dependencies/pull/180
# if (is.null(suppressMessages(webshot:::find_phantom()))) {
#   webshot::install_phantomjs()
# }
