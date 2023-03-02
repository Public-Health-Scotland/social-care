# Insights in Social Care: Statistics for Scotland Publication 2021/22

In this folder you can find the code used to produce: 2021/22 Publication](https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-202122/).

The code for the 5 dashboards is avaliable, within each folder the following can be found:
- `data-prep.R` - this takes the data from within our folders and formats it to be used within the R Shiny App. This formatted data has been provided within the data folder. This file is not intended to be run just avaliable for transparency for the steps the data goes through before the app is run,
- `global.R`,
- `ui.R`,
- `server.R`,
- `___app.Rproj` - the R project that can be run that once opened contains all the correct filepaths for the app to run,
- `data` folder - contains the final data for the app to run,
- `data_tables` - contains the data completeness and data quality tables used in the apps,
- `www` folder - contains app static content.


Please note, all code provided has been run on the POSIT R Server, R version 4.1.2. 


The folder for each app can be downloaded and the shiny app can be produced.

