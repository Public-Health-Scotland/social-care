# shiny app development of social care dashboard
# Jenny Armstrong 
# 
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
###########################################.
# TO DO: add this link to resources tab 
# https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/

# load packages
source("packages.R")
source("global.R")    # load required data items 

###################################.
#### User Interface (UI) Setup ----
###################################.

ui <- fluidPage(
  
  ###############################################.
  ## Header ---- 
  ###############################################.

  titlePanel(fluidRow((tags$img(src = "https://i.postimg.cc/026PX5zX/ISD-NSS-logos.png", height = "60px")),
                      h1("Welcome to the Social Care Information Dashboard"))),
  
  # set up tabs for navigating between app pages
  tabsetPanel(
  
     #################################.
     ### Home Tab (landing page) ----
     #################################.
     
     tabPanel(title = "Home", icon = icon("home"), value = "home",
              h2("Insert Social Care Dashboard Introduction Text"),
              
              # set up icons to navigate around dashboard
              
              flowLayout(
                style = "border: 1px solid silver;",
                cellWidths = 600,
                cellArgs = list(style = "padding: 6px"),
                
                # Summary Box
                tags$img(src = "landing_button_summary.png", height="100%", width="100%", align="left"),

                # Trend Box
                tags$img(src = "landing_button_time_trend.png", height="100%", width="100%", align="left"),
                
                # Rank/Comparisons Box
                tags$img(src = "landing_button_rank.png", height="100%", width="100%", align="left"),

                # Data Table box
                tags$img(src = "landing_button_data_table.png", height="100%", width="100%", align="left"))),
                
     ##########################.
     ### Summary Tab ----
     ##########################.
     
     tabPanel(title = "Summary", icon = icon("list-alt"), value = "summary",
              h2("Social Care Data Summary")), 
     
     ##########################.
     ### Trend Tab ----
     ##########################.
     
     tabPanel(title = "Trend", icon = icon("area-chart"), value = "trend",
              h2("Social Care Data Trends"),
  
        # create a panel containing dropdowns, download data and help buttons
        # the following code was adapted from scotpho profiles            
         splitLayout(column(1,
                         verticalLayout(
               # create buttons for help and definitions info 
                
                tags$button("Help", label = "help", icon= icon('question-circle'), class ="down", align = "centre"),
                tags$button("Definitions", label="definitions", icon= icon('info'), class ="down", align = "centre"),
               
               # add download data and save chart buttons
                downloadButton("download_trend", label = "Download data", class = "down", align = "centre"),
                downloadButton("download_trendplot", label = "Download Chart - Coming Soon", class = "down", align = "centre"))
               ), # end col 1 fluid row bracket
     
     column(6, h3("dropdowns will go here"))
            
        # savechart_button('download_trendplot', 'Save chart',  class = "down"),             
               # 
               # # create dropdown options  
               # # local authority of interest - default = all areas submitted
               # column(2,
               #        shiny::hr(),
               #        div(title="Select a location of interest. Click in this box, hit backspace and start to type if you want to quickly find an indicator.",
               #        selectInput("la_name", 
               #        choices= la_name_list, selected = "Aberdeen City"))),
               # 
               # # select data set of interest
               # column(3,
               #         selectInput(inputId = "data_select", label = "data source", 
               #                        choices =  sc_data_list, selected = "SDS"))
              
                ), # fluidRow() closing bracket 
                                     
               # set up main panel where data will be presented
              
        mainPanel(width = 12, value = "main_panel",
                  h4("Main panel starts here"))

       ), # tab panel bracket (end of Trend tab specifications)
     
     ##########################.
     ### Rank Tab ----
     ##########################.
     
     tabPanel(title = "Rank", icon = icon("chart-bar"), value = "rank", 
              h2("Social Care Comparisons")),
     
     ##########################.
     ### Data Tab ----
     ##########################.
     
     tabPanel(title = "Data", icon = icon("table"), value = "data", 
              h2("Social Care Data Tables")),
 
     ##############################################.
     ### Additional Information Dropdown Tab ----
     ##############################################.  
        
     navbarMenu(title = "Information", "Social Care Data Resources",
                
     ### About dropdown tab ----
     
           tabPanel("About", value = "about", h1("About"),
                    h3("Source Social Care Data Collection"),
                    p("This dashboard is organised to show statistics covering the broad topics:"),
                    h5("Self-directed support (SDS)"),
                    h5("Home care"),
                    h5("Community alarms/telecare"),
                    h5("Care home residents"),
                    br(),
                    p("In all cases the information relates to services and support where 
                      a Health and Social Care Partnership has an involvement, such as providing 
                      the care and support directly or by commissioning the care and support from 
                      other service providers. Data on care and support that is paid for and 
                      organised entirely by the persons themselves (i.e. “self-funded”) is not 
                      generally available and are excluded from all the analyses."),
                    h3("Data Sources"),
                    h5("Source Social Care Data"),
                    h5("SMR01 hospital discharge records"),
                    br() # create space at bottom of page
                    ),
     
     ### How to use tool ----
     
     tabPanel("Using this tool", value = "how_to",
              h1("How to Use this Dashboard"),
              br(),
              p("Topics within the dashboard are listed at the top of the screen. Please click on the topic to select this.When you select the topic you will be presented with an introduction to the topic.The different analyses for the topic are listed on the left hand side of the screen.Please click on the analysis to select this."),
              br(),
              h2("Downloading Data & Charts"),
              p("To view your data selection in a table, use the 'Show/hide table' button at the bottom of the page. To download your data selection as a CSV file, use the 'Download data' button."),
              p("At the top-right corner of the graph, you will see a toolbar with buttons: Download plot as a png - click this button to save the graph as an image"),
              h2("Screen Resolution"),
              br(),
              p("For optimum resolution we recommend a resolution of 1024x768 or greater. 
                This can be done via the control panel on your computer settings.")),
              
     ### Definitions ----      

     tabPanel("Definitions", value = "definitions", h2("Data Definitions"),
              p("The Source data definitions and guidance document can be found"),
              tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/docs/Revised-Source-Dataset-Definitions-and-Recording-Guidance-June-2018.pdf",
                     "here", class="externallink",".")),
           
     ### Data Completeness dropdown tab  ----     
           
           tabPanel("Data Completeness", value = "completeness", h2("Data Completeness"),
                    p("All data in this extract has been through detailed validation and quality checking to ensure the accuracy of the data. The following should be noted:"),
                      br(),
                      p("Some partnerships were unable to provide individual level information for specific topics or data items. Where possible aggregated data has been provided and this will be highlighted within the dashboard.
                      Although data is available for Glasgow City only aggregated data was available rather than individual level data and this means that for some analyses they will be excluded. Where this was the case this will be highlighted in both the text and in the dashboard."),
                      br(),
                      p("Attempts have been made to minimise the effects of these data issues. In both the report and the dashboard, estimates have been provided for top level trends to enable a Scotland figure to be calculated for comparison purposes. Estimates have not been used for the more detailed analysis."),
                      br(),
                      p("Appendices within the report and a separate technical document provide further details of data
                        completeness for each health and social care partnership within each topic. Experimental 
                        statistics are official statistics which are published in order to involve users and 
                        stakeholders in their development and as a means to build in quality at an early stage. 
                        It is important that users understand that limitations may apply to the interpretation of this data")),
                    
     ### Resources dropdown tab  ----     
           
           tabPanel("Resources", value = "resources",
                    h2("Resources"),
                    p("This dashboard is accompanyed by a pdf report:",
                    tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Publications/2019-06-11/2019-06-11-Social-Care-Report.pdf",
                           "Insights into Social Care in Scotland Publication", class="externallink")))
    
    ) # NavbarMenu closing bracket
   ), # tabset panel closing bracket

  ###################.         
  ## Footer ----    
  ###################.
  
      ### add space between content and footer
      div(style = "margin-bottom: 30px;",
  
      # Social Care Contact link
      tags$footer(
            column(2, tags$a(href="mailto:nss.source@nhs.net", tags$b("Contact us"), 
                       class="externallink", style = "color: white; text-decoration: none")), 
            style = "
            position:fixed;
            text-align:center;
            left: 0;
            bottom:0;
            width:100%;
            z-index:1000;  
            height:30px; /* Height of the footer */
            color: white;
            padding: 10px;
            font-weight: bold;
            background-color: #1995dc"))
  
  ) # fluidpage closing bracket

  


# End of UI specifications

#####################.
##### Server ----
#####################.

server <- function(input, output, session) {
  

###############################################.
## Landing page ----
###############################################.
  # Creating events that take you to different tabs
  # activated when pressing buttons from the landing page
  # observeEvent() triggers a command within an action button
  
  # observeEvent(input$jump_to_summary, {
  #   updateTabsetPanel(session, "intabset", selected = "summary")
  # })
  # 
  # observeEvent(input$jump_to_trend, {
  #   updateTabsetPanel(session,"intabset", selected = "trend")
  # })
  # 

  # observeEvent(input$jump_to_data, {
  #   updateTabsetPanel("intabset", selected = "data")
  # })
  # 
  # 
  # 
  # observeEvent(input$jump_to_definitions, {
  #   updateTabsetPanel("intabset", selected = "definitions")
  # })
  # 
  # 
  # observeEvent(input$jump_to_resources, {
  #   updateTabsetPanel("intabset", selected = "resources")
  # })
  # 
  
}

#############################.
#### Run the application ----
#############################.


shinyApp(ui = ui, server = server)


