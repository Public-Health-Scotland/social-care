#####################################################
## Home Care UI Script ##
#####################################################


### Script creates care home shiny app user interface 
### this script builds the part of the app users will see and interact with i.e. user interface
### App format / structure is set here, along with commentary text
### Adapted from https://github.com/Health-SocialCare-Scotland/social-care 1718 
##################################################



##########################
## password protect PRA ##
#shinymanager::secure_app( # comment out if not required 
  ##########################
  

### User Interface ----

ui <- fluidPage(
  useShinyjs(),
  
  
  # The following code allows the shiny app to be viewed on mobile devices  
  HTML('<meta name="viewport" content="width=1200">'),
  style = "width: 100%; height: 100%; max-width: 1200px;", 
  
  # set up navigation tabs across top of screen
  
  navbarPage(id = "tabs_across_top", # id used for jumping between tabs
             
             title = div(tags$a(img(src="phs_logo.png", height=40), href= "https://www.publichealthscotland.scot/"),
                         style = "position: relative; top: -10px;"), 
             
             windowTitle = "Social Care Insights", #title for browser tab
             header = tags$head(includeCSS("www/styles.css")), # CSS styles
  #############################
  #### Tab 1: Introduction ----
  ##############################
  
  tabPanel("Introduction", 

           wellPanel(
             column(4, h3("Social Care Insights Dashboard - Home Care")),
             column(8,
                    tags$br(),
                    p(
                      "Home Care (or its broadly equivalent term ‘Care at Home’) are a variety of support types 
                      intended to help people with assessed support needs to live at home, including in sheltered 
                      housing or equivalent accommodation. For reporting purposes the term ‘Home Care’ includes 
                      personal care and a wide range of practical support to enable a person to function as 
                      independently as possible in the community. Tasks involved may include housework, shopping, 
                      laundry and/or paying bills. Not included in this section are ‘live in’ and 24 hour services, 
                      which are defined as ‘Housing Support’. For further information please see Home Care section 
                      of the",
                      tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf", 
                             "definitions and guidance document.")),
                    
                    p("This Dashboard has two additional tabs which can be selected: “Information” and “Home Care”. 
                      Please click on “Home Care” tab to see the different analyses available. For more information 
                      on data definitions and guidance on the information presented in the Home Care Dashboard 
                      please click the “Information” tab."),
                    
                    p(strong("Effects of COVID-19 on figures"),
                      "The measures put in place to respond to COVID-19 pandemic will have affected the 
                                  services that the HSCPs were able to provide over the period of the pandemic.  
                                  Differences in data from previous years are likely to be affected by ability of 
                                  HSCPs to provide social care services while dealing with the impact of the pandemic."),
                  
                    p("Statistical disclosure control has been applied to protect patient confidentiality. 
                      Therefore, the figures presented here may not be additive and may differ from previous 
                      publications. For further guidance see Public Health Scotland's",
                    tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                           "Statistical Disclosure Control Protocol.")
                  ),
                  p("If you experience any problems using this dashboard or have",
                    "further questions relating to the data, please contact", 
                    "us at: ",
                    tags$b(tags$a(
                      href = "mailto:phs.source@phs.scot",
                      "phs.source@phs.scot")),
                    "."),
                  
                  p("Revised 09 May 2022. Following a data quality assurance review, it was discovered that the number of people 
                    receiving home care in North Ayrshire in census week (25th March - 31st March) 2017/18 were missing. As a result, 
                    the 2017/18 census week number of people receiving home care for North Ayrshire and Scotland have been revised. 
                    A note has been added to the home care dashboard analyses impacted by this revision.", style = "color:red")
                  
             ) # end column
           ) # end wellpanel
  ), # end intro tabpanel
  
  #####################################
  #### Tab 2: Information tab ----
  #####################################
  
  tabPanel("Information",
           icon = icon("info-circle"),
           mainPanel(
             width = 12,
             
             # Within this section we are going to have a sub tab column on the left
             # To do this we are going to use the layout "navlistPanel()"
             
             navlistPanel(
               id = "info_left_tabs",
               widths = c(2, 10),
               
               ### Accessibility -----
               
               tabPanel("Accessibility",    
                        h2("Accessibility Statement"),
                        
                        p("This website is run by", 
                          tags$a(href = "https://www.publichealthscotland.scot/", "Public Health Scotland"),
                          ". Scotland’s national organisation for public health."),
                        
                        p("As a new organisation formed on 1 April 2020, Public Health Scotland is reviewing 
                          its web estate - including this website - aligned to corporate strategic and transformation plans."),
                        
                        p(tags$a(href = "https://mcmw.abilitynet.org.uk/", "AbilityNet"),"has advice on making your device easier
                          to use if you have a disability."),
                          
                          tags$b("How Accessible this website is"),
                          p("This site has not yet been evaluated against WCAG 2.1 level AA."),
                          
                          tags$b("Reporting accesibility problems with this website"),
                          p("If you wish to contact us about any accessibility issues you encounter on this site, please contact:",
                            tags$a(href = "mailto:phs.healthscotland-webmaster@nhs.net", 
                                   "phs.healthscotland-webmaster@nhs.net"),
                            " "),
                          
                          tags$b("Enforcement procedure"),
                          p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the 
                            Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018
                            (the 'accessibility regulations'). If you’re not happy with how we respond to your enquiry,",
                            tags$a(href = "https://www.equalityadvisoryservice.com/",
                                   "contact the Equality Advisory and Support Service (EASS)"),
                            "."), 
                          
                          tags$b("Preparation of this accessibility statement"),
                          p("This statement was prepared on 20 September 2020. It was last reviewed on 17 September 2020.")
                          
                          
                          
                          ), # end accessibility panel
                 
                 
               ### How to use tool ----
               
               tabPanel("How To",             
                        h2("How To"),
                        
                        tags$b("Contact Us"),
                        p("If you experience any problems using this dashboard or have further 
                          questions relating to the data, please contact us at", 
                          tags$a(href = "mailto:phs.source@phs.scot", "phs.source@phs.scot")),
                        
                        tags$b("Screen Resolution"),
                        p("For optimum resolution we recommend a resolution of 1024x768 or greater. 
                          This can be done via the control panel on your computer settings."),
                        
                        tags$b("How to use the Dashboard"),
                        p("Each Dashboard has three tabs across the top which can be selected: Introduction, 
                          Topic Area and Information. Please click on the Topic Area tab to see the different 
                          analyses available for the topic area. These analyses are listed on the left hand 
                          side of the screen. Please click on the analysis of interest to see more details. 
                          To find more information about these analyses please select the “Information” tab 
                          from the three tabs across the top of the screen."),
                        
                        p("Commentary and further background information on the analyses presented in this dashboard can be found in the accompanying PDF report, please",
                          tags$a(href = "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", "click here"),
                          "to access the 2018/19 Social Care Insights Report."),
                        
                        tags$b("Interact with the Dashboard"),
                        p("Drop down menus are available for many of the analyses presented in the Social Care
                          Insights dashboard. Where these drop downs are available, the user can interact
                          with the data available and present plots for a variable of interest such as a 
                          specific age group or Health and Social Care Partnership of interest. The data presented
                          in the dashboard will update in response to the selections in the drop down menus."), 
                        
                        tags$b("Download Data"),
                        p("To view your data selection in a table, use the 'Show/hide table' button at the bottom 
                          of the page. To download your data selection as a CSV file, use the 'Download data' 
                          button. At the top-right corner of the graph, you will see a toolbar with buttons:"
                        ),
                        tags$ul(tags$li(tags$b("Download plot as a png"),  
                                        icon("camera"),  
                                        " - click this button to save the graph as an", 
                                        "image (please note that Internet Explorer does", 
                                        "not support this function)."),
                                tags$li(tags$b("Zoom"),  
                                        icon("search"),  
                                        " - zoom into the graph by clicking this button", 
                                        "and then clicking and dragging your mouse over", 
                                        "the area of the graph you are interested in."),   
                                tags$li(tags$b("Pan"),  
                                        icon("move", lib = "glyphicon"),  
                                        " - adjust the axes of the graph by clicking this", 
                                        "button and then clicking and moving your mouse", 
                                        "in any direction you want."),   
                                tags$li(tags$b("Reset axes"),  
                                        icon("home"),  
                                        " - click this button to return the axes to their",   
                                        "default range.") 
                        )
                        
                        
                        
                        ), # end How to panel
               
               
               ### About Page ----
               
               tabPanel("About", 
                        h2("About"),
                      p("This dashboard presents statistics on Home Care support received in Scotland."),
                      
                      p("Home care is defined as the practical services which assist the service user to 
                        function as independently as possible and/or continue to live in their own home. "),
                        
                        p("In the Source Data Collection Home Care services are defined as:"),
                      tags$ul(
                        tags$li("Practical services which assist the client/service user to function as independently as possible and/or continue to live in their own home."),
                        tags$li("Routine household tasks within or outside the home (basic housework, shopping, laundry, paying bills)."),
                        tags$li("Personal care of the client/service user as defined in Schedule 1 of the Community Care & Health Act 2002."),
                        tags$li("Respite care in support of the client/service users regular carers e.g. Crossroads Care Attendance Schemes funded by the Local Authority."),
                        tags$li("Reablement services."),
                        tags$li("Home Care provided to client/service user living in sheltered housing or supported accommodation.")
                        ),
                        p("It excludes:"),
                        tags$ul(
                          tags$li("Live-in and 24 hour services.")
                        ),
                        p("Multiple records for a service user may exist. Where a home care service is delivered 
                          by multiple providers, information relating to each provider is included."),
                      
                      p("The information presented relates to services and support where a Health and Social 
                        Care Partnership has an involvement, such as providing the care and support directly 
                        or by commissioning the care and support from other service providers. Data on care 
                        and support that is paid for and organised entirely by the persons themselves (i.e. 
                        self-funded) is not generally available and are excluded from all the analyses."),
                      
                      tags$b("Data Sources"),
                      p(" ",
                        tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                               "Source Social Care Data")," "),
                      p(" ",
                        tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?ID=1&SubID=5", 
                               "SMR01 hospital discharge records")," "),
                      p(" ",
                        tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?SubID=3", 
                               "Accident and Emergency attendance data")," ")
                        
                        ),
               
               
               ### Definitions ----
               
               tabPanel("Definitions", 
                        h2("Data Definitions"),
                        
                        p("The Source data definitions and guidance document can be found",
                          tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                 "here", class="externallink",".")), 
                        p("This provides detailed information on Data Definitions used across all of the Social Care Insights Dashboards.
                          Data Definitions relating specifically to the data presented throughout the Home Care Dashboard can be found below."),
                        
                        tags$b("Methodology"),
                        p("The information provided below on the methods and definitions that have been used 
                          throughout this dashboard should be used to assist with interpretation of the results 
                          presented."),     
                        
                        tags$b("Census Week"),
                        p("To allow comparison with figures previously published by the Scottish Government an 
                          estimated number of people receiving home care as well as home care hours has been 
                          calculated for a 'census week' (last week in March, 25 March to 31 March). The home 
                          care hours were estimated by calculating the average number of hours per day for each 
                          individual. This was then multiplied by the number of days the person received home 
                          care in the 'census week'."),
                        
                        tags$b("Financial Quarter"),
                        p("Data in this dashboard is available for financial year quarters 2017/18 Q4 to 2020/21 Q4."),
                        p("Due to the restrictions in the way that the data were collected nationally for 2017/18 the 
                          home care figures are only available for the period 1 January 2018 - 31 March 2018."),
                        
                        tags$b("Age Group"),
                        tags$ul(
                          tags$li("Where age information has been provided, age has been calculated
                                  at the midpoint of the financial year e.g. for 2020/21, age is
                                  calculated at 30 September 2020.")
                          ),
                        
                        tags$b("Local Authorities and Health and Social Care Partnerships"),
                        p("The information shown comes mainly from data gathered within Scotland’s 32 local 
                          authorities and is a by-product of many thousands of individual needs assessments 
                          carried out, personal choices made and care plans prepared and delivered."),
                        
                        p("Local authorities are one of the strategic partners in Health and Social Care along 
                          with Health Boards and Integration Authorities. For presentational reasons the label 
                          Health and Social Care Partnership is used throughout this dashboard (rather than local 
                          authority). Note: Reflecting variation across Scotland in the way partnership working 
                          occurs, the Stirling and Clackmannanshire Council analyses are shown separately although 
                          there is a single partnership involving both local authorities."),
                        
                        tags$b("Health and Social Care Partnership"),
                        tags$ul(
                          tags$li("Information is shown by the Health and Social Care Partnership funding the package 
                                  of care (fully or partially). The home care client could live outside the HSCP boundary."),
                          tags$li("If a person received services/support from more than one Health and Social Care 
                                  Partnership during the reporting period, they will be counted for each partnership.")
                          ),
                        
                        tags$b("Locality"),
                        p("Locality has been derived using the postcode for each person provided by the partnership. 
                          Outside partnership represents people with a permanent residence in localities outside the 
                          boundary of the funding partnership."),
                        p("More information on the Geographies used in this dashboard can be found", 
                          tags$a(href= "https://www.isdscotland.org/Products-and-Services/GPD-Support/Geography/","here"),"."),
                        
                        tags$b("Scotland Terminology"),
                        tags$ul(
                          tags$li(" “Scotland” - Information was supplied by all partnerships in Scotland."),
                          tags$li(" “Scotland (estimated)” - 	Estimates have been included for partnerships 
                                  that have not supplied the required data.  Areas that have been estimated 
                                  will be highlighted."),
                          tags$li(" “Scotland (All Areas Submitted)” - This is the total of all areas that 
                                  provided the required information only. It will undercount the actual picture 
                                  for Scotland as no estimation has been done to produce a Scotland estimate.")
                        ),
                        
                        tags$b("Home Care"),
                        p("Home care is defined as the practical services which assist the service user to 
                          function as independently as possible and/or continue to live in their own home. 
                          Home care can include routine household tasks for example basic housework, shopping, 
                          laundry, paying bills etc."),
                        
                        tags$b("IoRN Group"),
                        p("The Indicator of Relative Need (ioRN) is a widely available tool for health and 
                          social care practitioners that may be used to: inform individual decisions on the 
                          need for interventions to support, care and reactivate people's independence and 
                          provide a measure (stratification) of a population's functional and social independence. 
                          The summary Group categories used here broadly represent, going from left to right or 
                          A to I, higher levels of need e.g. people in Group A are the most independent and people 
                          in Group I are least independent (i.e. have higher needs for support from others)."),
                        p("This section also contains information on acute emergency admissions to hospital and 
                          accident and emergency attendances at hospital for people who are receiving home care. 
                          Notes on this analysis are provided below."),
                        p("The ioRN data is an Optional part of the source Social Care dataset as it is not 
                          currently universally used."),
                        p(
                            "Note that the ioRN Group categories used here are based on the 
                            original version of the community ioRN. Some of the ioRN Groups have 
                            been combined due to small numbers. Where more than one ioRN Group 
                            has been assigned to a person, the latest ioRN Group assigned is used. 
                            Further information about the latest version of the community 
                            ioRN (ioRN2) is available",
                            tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/", 
                                   "here", ".")
                          ),
                          
                        
                        tags$b("Number of Hours Measure"),
                        p("The collection of the number of hours has changed over the reporting periods therefore 
                          caution should be taken when interpreting the data."),
                        p("From April 2020 the recording guidance was developed to allow PHS to collect and report 
                          on both actual and planned home care hours.  For detail on hours submitted by Health and 
                          Social care partnership please see the",
                          tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                                 "Technical Document.")),
                        p("Due to difference in hours bandings, 2017/18 data is not comparable with 28/19-20/21 due to the changes in hour bandings. 
                          In the 2017/18 Social Care Dashboard, the hour bands 
                          labelled '0-<2', '2-<4', '4-<10' and '10+' hours actually showed data for hour bands '0-2', 
                          '>2-4', '>4-10' and '>10' hours respectively. This has been rectified for this publication. 
                          The impact of this change is minimal."),
                        

                      tags$b("Linkage of home care data to Health Care datasets notes:"),
                       tags$ul(
                          tags$li("This information has been linked via the Community Health Index (CHI) 
                                  number for an individual. The CHI number was derived on submission of the social care data. Where it was not possible to obtain CHI information, 
                                  these records were excluded from the linked health care analysis in this section."),
                          tags$li("Home care individual level information has been linked to acute hospital data 
                                  (Data Source SMR01) to obtain information on emergency hospital admissions, 
                                  emergency bed days and accident and emergency attendances for people receiving 
                                  home care."),
                          tags$li("The health activity data (emergency admission to hospital or A&E attendances) considered 
                                  within this analysis relates to the time period each individual received home care during the reporting period. 
                                  The emergency admission or A&E attendance could have been to any hospital in NHS Scotland."),
                          tags$li("The denominator used in the calculation of emergency hospital admission and accident and emergency attendances is the
                                  number of people with an active home care service during the selected time period."),
                          tags$li("For home care hour analyses shown by financial year quarter, a weekly average number 
                                  of home care hours was calculated. This was done by taking the total number of hours 
                                  a person received during the financial year quarter, dividing that figure by the total 
                                  number of days the person received home care during the quarter, and then multiplying 
                                  by 7.")
                          ),

                      tags$b("Data Sources"),
                      p(" ",
                        tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                               "Source Social Care Data")," "),
                      p(" ",
                        tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?ID=1&SubID=5", 
                               "SMR01 hospital discharge records")," - SMR01 is an episode based patient record relating to all inpatient and day cases discharged from specialties other than mental health, maternity, neonatal and geriatric long stay in NHS Scotland."),
                      p(" ",
                        tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?SubID=3", 
                               "Accident and Emergency attendance data")," ")
                          ),
                        
                        
               ### Data Completeness ----
                        
                        tabPanel(
                          "Data Completeness",
                          h2("Data Completeness"),
                          
                          tags$b("Disclosure Control"),
                          p("Statistical disclosure control has been applied to protect patient confidentiality. Therefore, the figures presented here may not be additive and may differ from previous publications. For further 
                              guidance see Public Health Scotland's",
                            tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                   "Statistical Disclosure Control Protocol.")
                          ),
                          
                          p("Statistical disclosure has been applied to small numbers less than 5.  Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
                          
                          br(),
                          
                          tags$b("Data Sources"),
                          p(" ",
                            tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                   "Source Social Care Data")," "),
                          p(" ",
                            tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?ID=1&SubID=5", 
                                   "SMR01 hospital discharge records")," "),
                          p(" ",
                            tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?SubID=3", 
                                   "Accident and Emergency attendance data")," "),
                          
                          br(),
                          
                          tags$b("Home Care Data Completeness Table"),
                          DT::dataTableOutput("data_completeness_table"),
                          
                       br()

                         ), # end info data completeness tab panel
                        
               ### Resources ----
                        
                        tabPanel("Resources", 
                                 h2("Resources"),
                                 
                                tags$b("Home Care Resources"),
                                 
                                 p("Scottish Government Social Care Survey:",
                                   tags$a(href="https://www.gov.scot/publications/social-care-services-scotland-2017/",
                                          "www.gov.scot/publications/social-care-services-scotland-2017/", class="externallink")),
                                 
                                 p("Personal Care Information:",
                                   tags$a(href="https://www.gov.scot/policies/social-care/social-care-support/#free%20care",
                                          "www.gov.scot/policies/social-care/social-care-support/freecare",  class="externallink")),
                                 
                                 p("Community Alarms and Telecare Information:",
                                   tags$a(href="https://www.tec.scot",
                                          "www.tec.scot",   class="externallink")),
                                 
                                 p("Scotland’s Digital Health Care Strategy:",
                                   tags$a(href="https://www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",
                                          "www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",   class="externallink")),
                                 
                                 p("Indicator of Relative Need (ioRN) Information:",
                                   tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
                                          "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",    class="externallink")),
                                
                                tags$b("Previous Home Care releases and supporting documents"),
                                
                                p("2018/19 Social Care Insights Report:",
                                  tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                         "2020-09-29-Social-Care-Report.pdf", class="externallink")),
                                
                                p("2018/19 Social Care Technical Document:",
                                  tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                         "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", class="externallink")),
                                
                                p("Social Care Definitions and Recording Guidance:",
                                  tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                         "Revised-Source-Dataset-Definitions-and-Recording-Guidance.pdf",  class="externallink")),
                                
                                p("2017/18 Social Care Insights Dashboard:",
                                  tags$a(href="https://scotland.shinyapps.io/nhs-social-care/",
                                         "www.scotland.shinyapps.io/nhs-social-care/",  class="externallink")),
                                
                                p("Social Care Balance of Care:",
                                  tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                         "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",  class="externallink")),
                                
                                p("Disclosure Control Information:",
                                  tags$a(href="https://publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
                                         "www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",class="externallink"))
                                 
         
                                 )
                        
      ### info tab end brackets ----
                          ) # end info navlist panel 
                          ) # end info mainpanel
                          ),   # end info tab panel
  
  #############################################           
  ### Tab 3: Home Care Tab (across top) ----
  #############################################
  
  tabPanel(
    "Home Care",
      mainPanel(
      width = 12,
      
      # Within this section we are going to have a sub tab column on the left
      # To do this we are going to use the layout "navlistPanel()"
      
      navlistPanel(
        id = "homecare_tabs_left",
        widths = c(2, 10),
        
        #####################################################
        ## Tab 3.1: Trend in Home Care Numbers and Hours ----
        #####################################################
        
        tabPanel(
          "Trend",
          h3("Trend in Home Care People and Hours"),

            p("The chart below presents information on the rate per 1,000 population,
              number of people receiving home care and the number of hours of home care received.
              This data can be viewed by ‘census week’ (25th March - 31st March) from 2009/10 to 2020/21 or by 
              financial quarter, from quarter 4 January – March 2017/18 to January – March 2020/21.
              Please select a time period from the dropdown option proivded below."),
          
            p(
              "For the census week, information prior to 2018 was obtained from the",
              tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                     "Social Care Survey"),
              "published by the Scottish Government."
            ),
          
          p("Two location dropdown menus have been provided to allow direct comparisons between 
            Health and Social Care Partnerships or against national figures."),
          
          tags$b("Measures"),
          p("There are three different analyses that can be selected:"),
          tags$ul(
            tags$li("Rate per 1,000 Population"),
            tags$li("Number of People"),
            tags$li("Number of Hours")
          ),
         

          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home 
                    care information therefore previous year's data were used where possible 
                    to provide an estimate."),
            tags$li("Home care hours collected are actual hours from 2019/20 onwards 
                    (where submitted) which may not be directly comparable to planned 
                    hours previously collected prior to 2019/20."),
            tags$li("Please consider data definitions and completeness when interpreting the 
                    data presented in this dashboard. Full details can be found in the Information tab."),
            tags$li("Methodology demonstrating how estimates were calculated can also be found within 
                    Section 2 of the", 
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                                              "Technical Document."))
          ),
          
          br(),
          
          p("Revised 09 May 2022. Following a data quality assurance review, it was discovered that the number of people receiving home care in 
            North Ayrshire in census week (25th March - 31st March) 2017/18 were missing. As a result, the 2017/18 number of people receiving 
            home care during census week in North Ayrshire was excluded from the Scotland total so this figure has been revised in the Trend 
            analysis. The number of people receiving home care in Scotland during census week 2017/18 has increased by 3.7%. Additionally, 
            North Ayrshire figures were missing from the HSCP analysis, these figures are now included as part of this revision.", style = "color:red"),
   
          br(),
          
          ### user dropdowns
          
          ### dropdown wellpanel 1
          
          wellPanel(
            
            # dropdown to select time period: census week or financial quarter
            column(6, shinyWidgets::pickerInput("hc_trend_time_period_input",
                                                "Select Time Period:",
                                                choices = unique(data_homecare_trend$time_period),
                                                selected = "Financial Quarter"
            )),
            

            column(6, shinyWidgets::pickerInput("hc_trend_location_input",
                                                        "Select Location:",
                                                        choices = unique(data_homecare_trend$sending_location),
                                                        selected = "Scotland (Estimated)"
          ))
          
          
          ), # end wellpanel 1
          
          ## dropdown wellpanel 2
          
          wellPanel(
          
          column(6, shinyWidgets::pickerInput("hc_trend_comparator_location_input",
                                              "Comparator Location:",
                                              choices = unique(data_homecare_trend$sending_location),
                                              selected = "Scotland (Estimated)"
          )),
          
          # select measure dropdown (Number of People or Number of Hours)

          column(6, shinyWidgets::pickerInput("hc_trend_measure_input",
                                              "Select Measure:",
                                              choices = unique(data_homecare_trend$measure),
                                              # remove Number of People from dropdown
                                              #choices = unique(data_homecare_hscp$measure[data_homecare_hscp$measure != "Number of People"]),
                                              selected = "Rate per 1,000 Population"
          ))
          
          ),
          
         # add space before mainpanel containing plot 
          
          mainPanel(
            width = 12,
            
           
            ## show / hide table button
            
            actionButton("hc_trend_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            
            ### download data button
            
            downloadButton(
              outputId = "download_homecare_trend_data",
              label = "Download data",
              class = "my_trend_button"
            ),
            tags$head(
              tags$style(paste0(".my_trend_button ", button_background_col,
                                ".my_trend_button ", button_text_col,
                                ".my_trend_button ", button_border_col)
                         )
            ),
            
            
          # hidden table
            
            hidden(
              div(
                id = "hc_trend_table",
                DT::dataTableOutput("hc_trend_table_output")
              )
            ),
            
            
            ### trend plot

             plotlyOutput("hc_trend_plot", 
                          height = "550px")


             ) # end main panel

        
          ), # end home care trend tab panel 

        #####################################################
        ## Tab 3.2: Home Care Numbers and Hours by HSCP ----
        #####################################################
        
        tabPanel(
          "Health and Social Care Partnership",
          
          h3("Health and Social Care Partnerships - People and Hours"),
          
          p("The chart below presents information on the rate per 1,000 population,
            number of people receiving home care and the number of hours of home care received. 
            This data can be viewed by ‘census week’ (25th March - 31st March) from from 2009/10 to 2020/21 by financial quarter, from quarter 4 January – March 2017/18 to January – March 2020/21.
            Please select a time period from the dropdown option provided below."),
          
          tags$b("Measures"),
          p("There are four different analyses that can be selected:"),
          tags$ul(
            tags$li("Number of People"),
            tags$li("Number of Hours"),
            tags$li("Rate per 1,000 Population") 
          ),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ 
            and All Ages from 2017/18 onwards. "),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home care information therefore previous year's data 
                    were used where possible to provide an estimate."),
            tags$li("Home care hours collected are actual hours from 2019/20 onwards (where submitted) 
                    which may not be directly comparable to planned hours previously collected prior 
                    to 2019/20."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),
          
          br(),
          
          p("Revised 09 May 2022. Following a data quality assurance review, it was discovered that the number of people receiving home care in 
            North Ayrshire in census week (25th March - 31st March) 2017/18 were missing. As a result, the 2017/18 number of people receiving 
            home care during census week in North Ayrshire was excluded from the Scotland total so this figure has been revised in the Trend 
            analysis. The number of people receiving home care in Scotland during census week 2017/18 has increased by 3.7%. Additionally, 
            North Ayrshire figures were missing from the HSCP analysis, these figures are now included as part of this revision.", style = "color:red"),
          
          br(),
          
          ## user inputs / dropdowns
          
          wellPanel(

            # select time period of interest
            
            column(6, shinyWidgets::pickerInput("hc_hscp_time_period_input_1",
                                                "Select Time Period:",
                                                choices = unique(data_homecare_hscp$time_period),
                                                selected = "Financial Quarter"
            )),
                        
            # select Financial Quarter of interest

        
            column(6, uiOutput("hc_financial_year_1"))
            
                  ), # end wellpanel 1
            
            # wellpanel 2
            
            wellPanel(
            
              ## select age group

              column(6, selectInput("hc_hscp_age_group",
                                    "Select Age Group",
                                    choices = unique(data_homecare_hscp$age_group[data_homecare_hscp$age_group != "Unknown"]),
                                    selected = "All Ages"
              )),
              
              
              
            ## select measure of interest
            
            column(6, selectInput("hc_hscp_measure_input",
                                  "Select Measure",
                                  choices = unique(data_homecare_hscp$measure),
                                  selected = "Rate per 1,000 Population"
            ))
            
          ), # end dropdown wellpanel 2
          
          
          mainPanel(
            width = 12,
            
            # show / hide table and download data buttons
            
            # show / hide data table button  
            
            actionButton("hc_hscp_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download data button
            
            downloadButton(
              outputId = "download_hc_hscp_data",
              label = "Download data",
              class = "my_hscp_button"
            ),
            tags$head(
              tags$style(paste0(".my_hscp_button ", button_background_col,
                                ".my_hscp_button ", button_text_col,
                                ".my_hscp_button ", button_border_col)
                         )
            ),
            
            ## data table to show / hide
            
            hidden(
              div(
                id = "hc_hscp_table",
                DT::dataTableOutput("hc_hscp_table_output")
              )
            ),
            

            
            br() ,
            
            # HSCP  plot
            
            plotlyOutput("hc_hscp_plot",
                         height = "750px")
            
          ) # end mainpanel
            ), # end tabpanel
        
        #########################################################
        ## Tab 3.3: Home Care Numbers and Hours by Locality ----
        #########################################################
        
        tabPanel(
          
          "Health and Social Care Partnership Locality",
          h3("Health and Social Care Partnerships Locality – People and Hours"),
          
          p("The chart below presents information on the rate per 1,000 population receiving 
            home care and the number of hours of home care received by the Health and Social 
            Care Partnership Locality, during a selected financial year quarter."),
          
          tags$b("Measures"),
          p("There are two different analyses that can be selected:"),
          tags$ul(
            tags$li("Rate per 1000 Population"),
            tags$li("Number of People"),
            tags$li("Number of Hours") #,
          ),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ 
            and All Ages from 2017/18 onwards. "),
          
          tags$b("Health and Social Care Partnership Locality"),
          tags$ul(
            tags$li("Locality has been derived using 2011 data zones and the client postcode 
                    provided by Health and Social Care Partnerships."),
            tags$li("Where Health and Social Care Partnership locality is shown as 
                    “Outside Partnership”, this represents people whose residence in a locality 
                    is outside of the boundary of the Health and Social Care Partnership funding 
                    their Home Care support."),
            tags$li("Please see the Data Definitions section of the Information Tab for full details 
                    on Locality.")
          ),

          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                    all the services and support reported on in this section therefore to reflect data 
                    completeness a Scotland ‘All Areas Submitted’ has been provided. As a result, a 
                    small number of charts will be blank for a selected time period if the Health and 
                    Social Care Partnership did not provide data for that time period."),
            tags$li("Home care hours collected are actual hours from 2019/20 onwards (where submitted) 
                    which may not be directly comparable to planned hours previously collected prior to 
                    2019/20"),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data presented 
                    in this dashboard. Full details can be found within the Information Tab or in the", 
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),
          
          br(),
          
          p("Revised 09 June 2022.
            Following a data quality assurance review, 
            it was discovered that all people receiving home care in City of Edinburgh HSCP were erroneously recorded as living outside of the HSCP boundary across all time periods. 
            As a result, no other locality information was available for Edinburgh City HSCP and the rate per 1,000 population was missing. 
            This issue has now been resolved and locality figures for City of Edinburgh HSCP are now included as part of this revision.", style = "color:red"),
          
          br(),
          
          ## user inputs / dropdowns
          
          # dropdown wellpanel 1
          
          wellPanel(
            
            column(6, shinyWidgets::pickerInput("hc_locality_year_quarter_input",
                                                "Select Year / Quarter:",
                                                choices = unique(data_homecare_locality$financial_quarter),
                                                selected = "2020/21 Q4"
            )),
            
            
            column(6, shinyWidgets::pickerInput("hc_locality_location_input",
                                                "Select Location:",
                                                choices = sort(unique(data_homecare_locality$sending_location)),
                                                selected = "Scotland (All Areas Submitted)"
            ))
            
            ), # end dropdown wellpanel 1
            
            # wellpanel 2
            
            wellPanel(
              
              column(6, shinyWidgets::pickerInput("hc_locality_age_input",
                                                  "Select Age Group:",
                                                  choices = unique(data_homecare_locality$age_group),
                                                  selected = "All Ages"
              )),
              
              
              
            column(6, selectInput("hc_locality_measure_input",
                                  "Select Measure",
                                  choices = unique(data_homecare_locality$measure),
                                  selected = "Rate per 1,000 Population"
            ))
          ), # end dropdown wellpanel 2
          
          
          mainPanel(
            width = 12,
            
            # show / hide table and download data buttons
            
            # show / hide data table button  
            
            actionButton("hc_locality_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),

            
            # download data button
            
            downloadButton(
              outputId = "download_hc_locality_data",
              label = "Download data",
              class = "my_locality_button"
            ),
            tags$head(
              tags$style(paste0(".my_locality_button ", button_background_col,
                                ".my_locality_button ", button_text_col,
                                ".my_locality_button ", button_border_col)
                         )
            ),
            
            hidden(
              div(
                id = "hc_locality_table",
                DT::dataTableOutput("hc_locality_table_output")
              )
            ),
          
          br() ,
          
          # HSCP locality plot
          
            plotlyOutput("hc_locality_plot",
                         height = "500px")
          
          ) # end mainpanel
        ), # end tabpanel
        
        ###############################################  
        #### Tab 2.12: Deprivation Category (SIMD) ----
        ###############################################
        
        tabPanel(
          "Deprivation Category (SIMD)",
          h3("Deprivation Category (SIMD)"),
          
          ## Text ----
          
          p("In Scotland the Scottish Index of Multiple Deprivation (SIMD) is used to 
            measure deprivation. It combines information on income, employment, 
            education, housing, health, crime and geographical access. For this analysis, 
            the area of concern (each HSCP or Scotland) were divided into five equal groups 
            based on population size. Deprivation quintile 1 relates to the most deprived 
            areas and deprivation quintile 5 relates to the least deprived areas. SIMD 2016 
            was used for the analysis. "),
          
          p("The chart below presents information on the percentage of people receiving home care
            services / support by deprivation quintile, age group and Health and Social Care
            Partnership for each financial quarter between 2017/18 - 2020/21."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages 
            from 2017/18 onwards. "),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide information 
                    for all the services and support reported on in this section therefore to 
                    reflect data completeness a Scotland ‘All Areas Submitted’ has been provided. 
                    As a result, a small number of charts will be blank for a selected time period 
                    if the Health and Social Care Partnership did not provide data for that time period."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data presented 
                    in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),
          
          ## Dropdown Options -----
          
          wellPanel(
            
            # financial year dropdown
            
            column(6, shinyWidgets::pickerInput("hc_simd_year_input",
                                                "Select Financial Quarter:",
                                                choices = unique(data_homecare_deprivation$financial_quarter),
                                                selected = "2020/21 Q4"
            )),
            
            # location dropdown
            
            column(6, shinyWidgets::pickerInput("hc_simd_location_input",
                                                "Select Location:",
                                                choices = unique(data_homecare_deprivation$sending_location),
                                                selected = "Scotland (All Areas Submitted)"
            ))
            
          ),# end wellpanel 1
          
          # wellpanel 2 
          
          wellPanel(
            
            # age group 
            
            column(6, shinyWidgets::pickerInput("hc_simd_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_homecare_deprivation$age_group),
                                                selected = "All Ages"
            ))
            
            
          ), # end dropdown wellpanel
          
          ## Buttons ----
          
          mainPanel(
            width = 12,
            
            actionButton("hc_simd_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            downloadButton(
              outputId = "download_hc_simd_data",
              label = "Download data",
              class = "my_hc_deprivation_button"
            ),
            tags$head(
              tags$style(paste0(".my_hc_deprivation_button ", button_background_col,
                                ".my_hc_deprivation_button ", button_text_col,
                                ".my_hc_deprivation_button ", button_border_col)
              )
            ),
            
            hidden(
              div(
                id = "hc_simd_table",
                DT::dataTableOutput("hc_simd_table_output")
              )
            ),
            
            # add space
            
            br(),
            
            ## Plot -----
            
            plotlyOutput("hc_simd_plot",
                         height = "500px")
            
            
          ) # end buttons and plot mainpanel
          ), # end deprivation tabpanel

        #########################################################
        ## Tab 3.4: Client Groups Receiving Home Care ----
        #########################################################
        
        tabPanel(
          "Social Care Client Group",
          h3("Social Care Client Groups Receiving Home Care"),
          
          ### text ----
          
          p("The chart below presents information on the rate per 1,000 people
            who received home care support during a selected time period by Client Group.
            This data is available for selected financial year quarters (2017/18 Q4 - 2020/21 Q4)
            or an estimate “census week” (25th March – 31st March) in 2017/18-2020/21.
            Data is also provided by age groups and by the Health and Social Care Partnership providing support."),
          
          tags$b("Client Group"),
          p("The Client Group or Service User Group an individual is assigned to is 
            determined by a Social Worker or Social Care Professional and is used as 
            a means of grouping individuals with similar care needs. An individual 
            can be assigned to more than one Client Group."),
          p("The category 'Other' within client group includes Drugs, Alcohol, Palliative 
            Care, Carer, Neurological condition (excluding Dementia), Autism and 
            Other Vulnerable Groups."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ 
            and All Ages from 2017/18 onwards"),

          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home 
                    care information therefore a Scotland ‘All Areas Submitted’ total has 
                    been provided."),
            tags$li("Figures across client groups cannot be added together to give an 
                    overall total as the same individual can appear in multiple client groups."),
            tags$li("There is a difference in the level of information provided by different areas. 
                    For example, some areas only recorded the main client group, some areas did not 
                    have information for every client group."),
            tags$li("Please note, data completeness issues may affect interpretation of the 
                    data in some instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the 
                    data presented in this dashboard. Full details can be found within the 
                    Information Tab or in the", 
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),

          ## user inputs / dropdown menus
          
          # wellpanel 1 
          
          wellPanel(
            
            # time period drop down, select from census week or financial quarter

            column(6, shinyWidgets::pickerInput("hc_client_time_period_input",
                                                "Select Time Period:",
                                                choices = unique(data_homecare_client_group$time_period),
                                                selected = "Financial Quarter"
            )),
            
            # select financial year quarter of interest
           
            
            column(6, uiOutput("hc_client_year_quarter_input"))
            
            
            ), # end wellpanel 1
            
          # wellpanel 2
          
          wellPanel(
          
            #location dropdown
            
            column(6, shinyWidgets::pickerInput("hc_client_location_input",
                                                "Select Location:",
                                                choices = unique(data_homecare_client_group$sending_location),
                                                selected = "Scotland (All Areas Submitted)"
            )),
            
            ### Age dropdown
            
            column(6, shinyWidgets::pickerInput("hc_client_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_homecare_client_group$age_group),
                                                selected = "All Ages"
            )),
            
            # measure dropdown
            column(6, shinyWidgets::pickerInput("hc_client_measure_input",
                                                "Select Measure:",
                                                choices = unique(data_homecare_client_group$measure),
                                                selected = "Rate per 1,000 People"
            ))
            
          ), # end dropdown wellpanel 2
          
          ### add space between dropdowns and buttons
          
          br(),
          
          ## mainpanel for buttons and plot
          
          mainPanel(
            width = 12,
            
            ## download and show/hide buttons
            
            # show / hide table button
            
            actionButton("hc_client_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),

            
            ## download data button
            
            downloadButton(
              outputId = "download_hc_client_data",
              label = "Download data",
              class = "my_client_type_button"
            ),
            
            tags$head(
              tags$style(paste0(".my_client_type_button ", button_background_col,
                                ".my_client_type_button ", button_text_col,
                                ".my_client_type_button ", button_border_col)
                         )
            ),
            
            # table to be shown/hidden
            
            hidden(
              div(
                id = "hc_client_table",
                DT::dataTableOutput("hc_client_table_output")
              )
            ),
            
            # add space before plot
             br(),
             br(),

            # plot outputs
            
            plotlyOutput("hc_client_plot", 
                         height = "600px")
          )
        ),   # end client group tab

        ##############################################
        ## Tab 3.5: Service Providers of Home Care ----
        ##############################################

        tabPanel(
          "Service Provider",
          h3("Service Providers of Home Care"),
          p("The chart below presents information on the proportion of people receiving home care 
            by the organisation that provides the service for the Health and Social Care 
            Partnership. "),
          
          p("This data can be viewed by ‘census week’ (25th March – 31st March) from 2017/18 to 2020/21 
            or financial year quarter from 2017/18 Q4 to 2020/21 Q4 (please select a time period 
            below). "),
          
          p("Note, provider codes/values used to distinguish between different providers has changed 
            within the data definition and guidance from 2019/20. Further information can be found 
            within the",
            tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                   "Technical Document.")),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages 
            from 2017/18 onwards. "),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                    information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
            tags$li("It is possible for an individual to receive services from more than one type of 
                    organisation."),
            tags$li("Data completeness issues may affect interpretation of the data in some instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data presented 
                    in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),
          
          
          
          ### user inputs / dropdowns
          
          wellPanel(
            
            # time period drop down, select from census week or financial quarter
            column(6, shinyWidgets::pickerInput("hc_service_provider_time_period_input",
                                                "Select Time Period:",
                                                choices = unique(data_homecare_service_provider$time_period),
                                                selected = "Financial Quarter"
            )),
            
           
            column(6, uiOutput("hc_service_provider_year_quarter_input"))
            
          ), # end dropdown wellpanel 1
            
            ### dropdown wellpanel 2
            
            wellPanel(
            
            # location dropdown
            
            column(6, shinyWidgets::pickerInput("hc_service_provider_location_input",
                                                "Select Location:",
                                                choices = unique(data_homecare_service_provider$sending_location),
                                                selected = "Scotland (All Areas Submitted)"
            ))
            ,
            
            column(6, shinyWidgets::pickerInput("hc_service_provider_input",
                                                "Select Service Provider:",
                                                choices = unique(data_homecare_service_provider$hc_service_provider),
                                                selected = "Local Authority/Health & Social Care Partnership/NHS Board only"
                                  
            ))
           
            
          ),
          
          
          
          
          br(),
          
          mainPanel(
            width = 12,
            
            ### data buttons (download and show / hide table buttons)
            
            # show / hide table button
            
            actionButton("hc_service_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download button
            
            downloadButton(
              outputId = "download_hc_service_data",
              label = "Download data",
              class = "my_hc_service_provider_button"
            ),

            tags$head(
              tags$style(paste0(".my_hc_service_provider_button ", button_background_col,
                                ".my_hc_service_provider_button ", button_text_col,
                                ".my_hc_service_provider_button ", button_border_col)
                         )
            ),
            
            # hidden service provider data table
            
            hidden(
              div(
                id = "hc_service_table",
                DT::dataTableOutput("hc_service_table_output")
              )
            ),
            
            br(), # add a space below buttons
            
            ### hc service provider plot output
            
            plotlyOutput("hc_service_plot",
                         height = "600px" )#,
                         #width = "750px")
            
          )
        ), # end a service provider tabpanel

        ###########################################
        ## Tab 3.6: Home Care Hours Received ----
        ###########################################
        
        tabPanel(
          "Home Care Hours Received",
          h3("Home Care Hours Received"),
          
          p("The chart below presents the percentage of people receiving home care by level of service received (average weekly hours).
            The number of hours have been grouped into the following four categories: 
            0 to less than 2 hours, 2 hours to less than 4 hours, 4 to less than 10 hours, 10 hours 
            or more. These categories were selected to allow for comparison to data previously 
            reported in the 2017 Scottish Government social care survey publication",
            tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                   "2017 Scottish Government Social Care Survey publication."),
            "This data can be viewed for selected ‘census week’ (25th March – 31st March) from 2017/18 
            to 2020/21 or financial year quarter from 2017/18 Q4 to 2020/21 Q4 (please select a time 
            period below). For financial year quarter data, a weekly average number of home care hours 
            received was calculated."),


          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages from 
            2017/18 onwards."),
          
          tags$b("Data Completeness"),
          tags$ul(
          tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                  information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
          tags$li("Home care hours collected are actual hours from 2019/20 onwards (where submitted) 
                  which may not be directly comparable to planned hours previously collected prior to 
                  2019/20"),
          tags$li("Data completeness issues may affect interpretation of the data in some instances."),
          tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
          tags$li("Please consider data definitions and completeness when interpreting the data 
                  presented in this dashboard. Full details can be found within the Information Tab or in the",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document."))
          ),
          
          ### user inputs / dropdowns
          
          ### wellpanel 1
          
          wellPanel(
            
            # time period drop down, select from census week or financial quarter

            column(6, shinyWidgets::pickerInput("hc_hours_received_time_period_input",
                                                "Select Time Period:",
                                                choices = unique(data_homecare_hours_received$time_period),
                                                selected = "Financial Quarter"
            )),
            
            # select year/date of interest
            
            
            column(6, selectInput("hc_hours_received_year_quarter_input",
                                                "Select Year / Quarter:",
                                                choices = unique(data_homecare_hours_received$financial_quarter)
            
            ))
            
            
        
          ), # end wellpanel 1 
          
          # dropdown wellpanel 2
          
          wellPanel(
            
            # location dropdown
            
            column(6, shinyWidgets::pickerInput("hc_hours_received_location_input",
                                                "Select Location:",
                                                choices = unique(data_homecare_hours_received$sending_location),
                                                selected = "Scotland (All Areas Submitted)"
            )),
            
            # Age Group Dropdown 
            
            column(6, shinyWidgets::pickerInput("hc_hours_received_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_homecare_hours_received$age_group[data_homecare_hours_received$age_group != "Unknown"]),
                                                selected = "All Ages"
            ))
            
          ),   # end dropdown wellpanel 2
          
          
          #### mainpanel for buttons and plot
          
          mainPanel(
            width = 12,
            
            ## show / hide table and download data buttons
            
            # show / hide button
            
            actionButton("hc_hours_recieved_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            

            # download data button
            
            downloadButton(
              outputId = "download_hc_hours_recieved_data",
              label = "Download data",
              class = "my_level_of_service_button"
            ),
            tags$head(
              tags$style(paste0(".my_level_of_service_button ", button_background_col,
                                ".my_level_of_service_button ", button_text_col,
                                ".my_level_of_service_button ", button_border_col)
                         )
            ),
            
            # data table (to be hidden)
            
            hidden(
              div(
                id = "hc_hours_recieved_table",
                DT::dataTableOutput("hc_hours_recieved_table_output")
              )
            ),
            
            
            # add space between buttons and plot
            
            br(),
            
            ## level of service (hours received) plot 
            
            plotlyOutput("hc_hours_recieved_plot",
                         height = "500px")
            
          )
          
        ) ,

        ##############################################
        ## Tab 3.7: Home Care Hours Distribution ----
        ##############################################
        
        tabPanel(
          "Home Care Hours Distribution",
          h3("Home Care Hours Distribution"),
          
          p("The chart below presents the percentage of people receiving home care hours. 
            The number of hours have been grouped into 20 categories to show the 
            distribution of home care hours received."),
          
          p("This data can be viewed for selected ‘census week’ (25th March – 31st March) from 2017/18 
            to 2020/21 or financial year quarter from 2017/18 Q4 to 2020/21 Q4 (please select a time 
            period below). For financial year quarter data, a weekly average number of home care 
            hours received was calculated."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages 
            from 2017/18 onwards. "),
          
          
        tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                    information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
            tags$li("Home care hours collected are actual hours from 2019/20 onwards (where submitted) 
                    which may not be directly comparable to planned hours previously collected prior to 
                    2019/20."),
            tags$li("Data completeness issues may affect interpretation of the data in some instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))),
          
          
          # user input / dropdowns
        
          # dropdown wellpanel 1
          wellPanel(
            
            # time period drop down, select from census week or financial quarter

            column(6, shinyWidgets::pickerInput("hc_hours_distribution_time_period_input",
                                                "Select Time Period:",
                                                choices = unique(data_homecare_hours_distribution$time_period),
                                                selected = "Financial Quarter"
            )),
            
           
            # select year/date of interest
           
            column(6, selectInput("hc_hours_distribution_year_quarter_input",
                                  "Select Year / Quarter:",
                                  choices = unique(data_homecare_hours_distribution$financial_quarter)
                                  
            ))
            
          ), # end dropdown wellpanel 1
        
        # dropdown wellpanel 2
        
        wellPanel(
            
            # location dropdown
            
            column(6, shinyWidgets::pickerInput("hc_hours_distribution_location_input",
                                                        "Select Location:",
                                                        choices = unique(data_homecare_hours_distribution$sending_location),
                                                        selected = "Scotland (All Areas Submitted)"
          )),
          
          column(6, shinyWidgets::pickerInput("hc_hours_distribution_age_input",
                                              "Select Age Group:",
                                              choices = unique(data_homecare_hours_distribution$age_group[data_homecare_hours_distribution$age_group != "Unknown"]),
                                              selected = "All Ages"
          ))
          
          ),  # end dropdown wellpanel 2
          
        ### mainpanel for buttons and plot
        
          mainPanel(
            width = 12,
            
            ## show / hide table and download data buttons
            
            # show / hide button
            
            actionButton("hc_hours_distribution_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
           # download data button
            
            downloadButton(
              outputId = "download_hc_hours_distribution_data",
              label = "Download data",
              class = "my_hc_hours_distribution_button"
            ),
            
            # specify download button style
            
            tags$head(
              tags$style(paste0(".my_hc_hours_distribution_button ", button_background_col,
                                ".my_hc_hours_distribution_button ", button_text_col,
                                ".my_hc_hours_distribution_button ", button_border_col)
                         )
            ),
            
           # data table to show/hide 
           
           hidden(
             div(
               id = "hc_hours_distribution_table",
               DT::dataTableOutput("hc_hours_distribution_table_output")
             )
           ),
           
            # insert line of space 
            
            br(),
            br(),
            ## plot hours distribution
            
            plotlyOutput("hc_hours_distribution_plot", 
                         height = "500px")
         
          )
          
        ),

        ##############################################
        ## Tab 3.9 Personal Care ----
        ##############################################
        
        tabPanel(
          "Personal Care",
          h3("Personal Care"),
          p("The chart below presents the percentage of people supported by Home Care who also 
            receive Personal Care. This information is presented by Health and Social Care 
            Partnership and age group for a selected financial year quarter. "),
        
          p("Scotland (All Areas Submitted) data is presented on the plot as a black reference line. 
            Please hover over the reference line to show data relating to Scotland (All Areas Submitted)."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages 
            from 2017/18 onwards."),
          
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                    information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
            tags$li("Please note, only Financial Quarter data is avaliable to be plotted. For Census 
                    Week data, it can be located in data download."),
            tags$li("Data completeness issues may affect interpretation of the data in some instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
            ),
          
          
          # user input / dropdowns
          # dropdown wellpanel 1
          
          wellPanel(
            
            # time period drop down, select from census week or financial quarter

            
            column(6, selectInput("hc_personal_care_year_quarter_input",
                                   "Select Year / Quarter:",
                                   choices = unique(data_homecare_personal_care$financial_quarter)[1:13],
                                   selected = "2020/21 Q4"
                                   
            )),
            
            

            # select age group of interest 
            
            column(6, shinyWidgets::pickerInput("hc_personal_care_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_homecare_personal_care$age_group[data_homecare_personal_care$age_group != "Unknown"]),
                                                selected = "All Ages"
            )) 
            
            ), # end wellpanel
            
          ##### mainpanel containing buttons and plot
          
          mainPanel(
            width = 12,
            
            # show / hide and download buttons
            
            actionButton("hc_personal_care_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),

            
            # download data table button
            
            downloadButton(
              outputId = "download_personal_care",
              label = "Download data",
              class = "my_personal_care_button"
            ),
            
            # specify button style
            
            tags$head(
              tags$style(paste0(".my_personal_care_button ", button_background_col,
                                ".my_personal_care_button ", button_text_col,
                                ".my_personal_care_button ", button_border_col)
                         )
            ),
            
            hidden(
              div(
                id = "hc_personal_care_table",
                DT::dataTableOutput("hc_personal_care_table_output")
              )
            ),
            
            # add line of space
            
            br(),
            
            # plot output
            
            plotlyOutput("hc_personal_care_plot",
                         height = "800px"
            )
           

          )
        ),
        
        ##############################################        
        ## Tab 3.10 Technology Enabled Care (Previously alarms/Telecare) ----
        ##############################################

        tabPanel(
          "Technology Enabled Care",
          h3("Technology Enabled Care"),
          p("The chart below shows the percentage of people who receive home care at the same time 
            as having an active community alarm/telecare service.  This information is presented by 
            Health and Social Care Partnership who provide the home care support and for a selected 
            financial year and age group. "),
          
          p("Scotland (All Areas Submitted) data is presented on the plot as a black reference line. 
            Please hover over the reference line to show data relating to Scotland (All Areas Submitted)."),
         
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages 
            from 2017/18 onwards."),
          
          tags$b("Notes & Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                    information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
            tags$li("Data completeness issues may affect interpretation of the data in some instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),
          
          # user input / dropdowns
          # dropdown wellpanel 1

          wellPanel(
            
          
          # select year/date of interest
          column(6, shinyWidgets::pickerInput("hc_tec_year_input",
                                              "Select Year:",
                                              choices = unique(data_homecare_tech_enabled_care$financial_year),
                                              selected = "2020/21"
          )),
          
          column(6, shinyWidgets::pickerInput("hc_tec_age_input",
                                              "Select Age Group:",
                                              choices = unique(data_homecare_tech_enabled_care$age_group),
                                              selected = "All Ages"
          ))
          
          
          ), # end dropdown wellpanel 1
          
         
  
          
           
         #### mainpanel containing buttons and plot

          mainPanel(
            width = 12,
            
            # show / hide and download buttons
            
            actionButton("hc_tec_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            downloadButton(
              outputId = "download_hc_tec_data",
              label = "Download data",
              class = "my_alarms_button"
            ),
            tags$head(
              tags$style(paste0(".my_alarms_button ", button_background_col,
                                ".my_alarms_button ", button_text_col,
                                ".my_alarms_button ", button_border_col)
              )
            ),
            
            
            hidden(
              div(
                id = "hc_tec_table",
                DT::dataTableOutput("hc_tec_table_output")
              )
            ),
            

            
            # add space between buttons and plot
            br(),
            
            # plot output 
            
            plotlyOutput("hc_tec_plot",
                         height = "700px" 
            )
        

          ) # end mainpanel
        ),  # end alarms and telecare tabpanel

        ##############################################
        ## Tab 3.11 Emergency Care ----
        ##############################################

        tabPanel(
          "Emergency Care",
          h3("People Supported with Home Care - Emergency Care"),
          
          p("The chart below presents information on accident and emergency (A&E) attendances, 
            emergency admissions to hospital (acute) and emergency admissions bed days for 
            individuals supported by home care, during a selected financial year quarter, by 
            Health and Social Care Partnership."),
        
          p("Scotland (All Areas Submitted) data is presented on the plot as a black reference line. 
            Please hover over the reference line to show data relating to Scotland (All Areas Submitted)."),

          tags$b("Measures"),
          p("There are three different analyses that can be selected:"),
          tags$ul(
            tags$li("Emergency Admissions"),
            tags$li("A&E Attendances"),
            tags$li("Emergency Admission Bed Days")
          ),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and 
            All Ages from 2017/18 onwards. "),
          
          p("Note that methodology has changed to previously published emergency care figures 
            for people receiving home care therefore figures may not match previously published 
            information. Details of change in methodology can be found within the",
            tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                   "Technical Document.")),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                    information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
            tags$li("Data completeness issues may affect interpretation of the data in some instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
            ),
          
          ### user input / dropdown options
          
          # dropdown wellpanel 1
          
          wellPanel(
            
           # select year/date of interest
            column(6, shinyWidgets::pickerInput("hc_emergency_year_quarter_input",
                                                "Select Year / Quarter:",
                                                choices = unique(data_homecare_emergency_care$financial_quarter),
                                                selected = "2020/21 Q4"
            )),
            
            # select measure (emergency admissions / emergency adm bed days)
            
            column(6, shinyWidgets::pickerInput("hc_emergency_measure_input",
                                                        "Select Measure:",
                                                        choices = unique(data_homecare_emergency_care$measure),
                                                selected = "Number of People"
                    ))
          
          ), # end dropdown wellpanel 1
          
          # wellpanel 2
          
          wellPanel(
          
          # age group  
          
          column(6, shinyWidgets::pickerInput("hc_emergency_age_input",
                                              "Select Age Group:",
                                              choices = unique(data_homecare_emergency_care$age_group[data_homecare_emergency_care$age_group != "Unknown"]),
                                              selected = "All Ages"
          ))
          
          ), # end wellpanel 2
          
          
          
          ### mainpanel containing buttons and plot 
          
          
          mainPanel(
            width = 12,
            
            # show / hide and download data buttons
            
            actionButton("hc_emergency_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            downloadButton(
              outputId = "download_hc_emergency_data",
              label = "Download data",
              class = "my_emergency_adms_button"
            ),
            tags$head(
              tags$style(paste0(".my_emergency_adms_button ", button_background_col,
                                ".my_emergency_adms_button ", button_text_col,
                                ".my_emergency_adms_button ", button_border_col)
                         )
            ),
            
            
            # hidden data table
            
            hidden(
              div(
                id = "hc_emergency_table",
                DT::dataTableOutput("hc_emergency_table_output")
              )
            ),
            
            # space before plot
            
            br(),
            
            # plot output
            
            plotlyOutput("hc_emergency_plot",
                         height = "700px"
            )
           

          )
        ),


        ##############################################
        ## Tab 3.14: Referral Source  ----
        ##############################################

        tabPanel(
          "Referrals to Hospital",
          h3("Referrals to Hospital"),
  
          p("The chart below presents information on the type of referral to hospital for people 
            receiving home care by Health and Social Care Partnership."),  
  
  
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and 
            All Ages from 2017/18 onwards. "),
  
          tags$b("Data Completeness"),
          tags$ul(
          tags$li("Some Health and Social Care Partnerships were unable to provide home care 
                  information therefore a Scotland ‘All Areas Submitted’ total has been provided."),
          tags$li("Data completeness issues may affect interpretation of the data in some 
                  instances."),
          tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
          tags$li("Please consider data definitions and completeness when interpreting the 
                  data presented in this dashboard. Full details can be found within the 
                  Information Tab or in the",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document."))
          ),
  
          br(),
  
          ### Dropdowns
  
          wellPanel(
    
          ### user inputs / dropdown selections 
    
          # select year/date of interest
          column(6, shinyWidgets::pickerInput("hc_referral_source_year_quarter_input",
                                        "Select Year / Quarter:",
                                        choices = unique(as.character(data_homecare_referral_source$financial_quarter)),
                                        selected = "2020/21 Q4"
          )),
    
          
          
          # age group  
    
          column(6, shinyWidgets::pickerInput("hc_referral_source_age_input",
                                        "Select Age Group:",
                                        choices = unique(data_homecare_referral_source$age_group[data_homecare_referral_source$age_group != "Unknown"]),
                                        selected = "All Ages"
          ))
    
          ), # end wellpanel 2
  
  
          #br(),
  
          ### mainpanel for buttons and plot
          
          mainPanel(
            width = 12,
    
          # show / hide and download data button and data table
    
          actionButton("hc_referral_showhide",
                       "Show/hide table",
                        style = button_style_showhide
          ),
    
          # donwload data button
          downloadButton(
              outputId = "download_hc_referral_data",
              label = "Download data",
              class = "my_hc_referral_source_button"
          ),
          tags$head(
          tags$style(paste0(".my_hc_referral_source_button ", button_background_col,
                        ".my_hc_referral_source_button ", button_text_col,
                        ".my_hc_referral_source_button ", button_border_col)
          )
        ),
    
        # data table hidden by show / hide button
    
        hidden(
          div(
          id = "hc_referral_table",
          DT::dataTableOutput("hc_referral_table_output")
          )
        ),
    
        # add space between buttons and plot
    
        br(),
    
        ## plot output
      
        mainPanel(
          width = 12,
          plotlyOutput("hc_referral_plot",
                     height = "800px"),
          br()
        
        )
    
      ) # end mainpanel
  
    ),  # end tabpanel         

        ##############################################
        ## Tab 3.13: Level of Independence (IoRN) ----
        ##############################################

        tabPanel(
          "Level of Independence (IoRN)",
          h3("Level of Independence (IoRN)"),

          p("The chart below presents the cumulative percentage of individuals supported by home care for each 
            IoRN Group and by the following categories of average weekly home care hours:"),
            tags$ul(
              tags$li("No Home Care record,"),
              tags$li("0 to less than 2 hours Home Care,"),
              tags$li("2 hours to less than 4 hours,"),
              tags$li("4 to less than 10 hours, and"),
              tags$li("10 hours or more of Home Care.")),
          p("This information is available for 
            selected financial year quarters (2017/18 Q4 - 2020/21 Q4) and Health and Social Care 
            Partnerships."),  
          
          
          p("The", tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/", 
                          "Indicator of Relative Need (IoRN)"), " is a widely available 
            tool for health and social care practitioners that may be used 
            to:"
          ), 
          tags$ul(
            tags$li("Inform individual decisions on the need for interventions to 
                    support, care and reactivate an individual's independence."), 
            tags$li("Provide a measure (stratification) of a population's functional and social 
                independence.")
            ),
          

          p("The summary IoRN Group categories used here broadly 
                represent, going from left to right or A to I, higher levels of 
                need e.g. people in Group A are the most independent and people 
                in Group I are least independent (i.e. have higher needs for 
                support from others)."),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("The IoRN data is an optional part of the Source Social Care dataset as it not 
                    currently universally used."),
            tags$li("Information has been provided for Health and Social Care Partnerships that 
                    returned IoRN data."),
            tags$li("Where more than one IoRN Group has been assigned to a person, the latest 
                    IoRN Group assigned is used."),
            tags$li("Additional details on the IoRN Group can be found in the Information - 
                    Data Definitions section of the dashboard."),
            tags$li("Data completeness issues may affect interpretation of the data in some 
                    instances."),
            tags$li("Statistical disclosure has been applied to small numbers less than 5. Therefore, where an HSCP is present in the graph but 
                            there is no bar in the graph, this is because rounding has been applied."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details can be found within the Information Tab or in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                           "Technical Document."))
          ),
          
            
           

          
          wellPanel(
            
            ### user inputs / dropdown selections 
            
            # select year/date of interest
            column(6, shinyWidgets::pickerInput("hc_iorn_year_input",
                                                "Select Year:",
                                                choices = unique(as.character(data_homecare_iorn$financial_year)),
                                                selected = "2020/21"
            )),
            
            
            ## select location of interest

            column(6, selectInput("hc_iorn_location",
                                          "Select Location:",
                                          selected = "All Areas Submitted",
                                          choices = sort(unique(data_homecare_iorn$sending_location))
          ))
          
          ), # end wellpanel
          
          
          br(),
          
          
          mainPanel(
            width = 12,

       # show / hide and download data button and data table
       
            actionButton("hc_iorn_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # donwload data button
            downloadButton(
              outputId = "download_hc_iorn_data",
              label = "Download data",
              class = "my_hc_iorn_button"
            ),
            tags$head(
              tags$style(paste0(".my_hc_iorn_button ", button_background_col,
                                ".my_hc_iorn_button ", button_text_col,
                                ".my_hc_iorn_button ", button_border_col)
                         )
            ),
            
            # data table hidden by show / hide button
            
            hidden(
              div(
                id = "hc_iorn_table",
                DT::dataTableOutput("hc_iorn_table_output")
              )
              ),
              
              # add space between buttons and plot
              
              br(),
              
              ## plot output
              
              plotlyOutput("hc_iorn_plot",
                           height = "600px")
              
            ) # end mainpanel
              
            )      # end of iorn tab      
  
 ### end navlist panel and home care summary tab ---
  
      ) # end navlist left homecare tabs
      
      ) #end homecare mainpanel
    
  ) # end home care tab
  
  

    ###############################################################       
    #### end dashboard navigation panel and fluidpage brackets ----
        
) # end navlist panel (tabs across top)


) # fluidPage bracket

#) # end secure_app function for password protect PRA
# comment out if not password protecting for PRA

