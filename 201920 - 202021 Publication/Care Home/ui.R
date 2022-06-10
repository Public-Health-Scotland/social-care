#####################################################
## Care Home UI Script ##
#####################################################


### Script creates care home shiny app user interface 
### this script builds the part of the app users will see and interact with i.e. user interface
### App format / structure is set here, along with commentary text
### Adapted from https://github.com/Health-SocialCare-Scotland/social-care 1718 
### Jenny Armstrong
### most recent update: 06/08/2020
##################################################



##########################
## password protect PRA ##
#shinymanager::secure_app( # comment out if not required 
  ##########################
  

### User Interface (UI) #####

ui <- fluidPage(
  useShinyjs(),
  
  # The following code allows the shiny app to be viewed on mobile devices  
  HTML('<meta name="viewport" content="width=1200">'),
  style = "width: 100%; height: 100%; max-width: 1200px;", 
  
  # create navigation bar across top of app
  
  navbarPage(id = "tabs_across_top", # id used for jumping between tabs
             
             title = div(tags$a(img(src="phs_logo.png", height=40), href= "https://www.publichealthscotland.scot/"),
                         style = "position: relative; top: -10px;"), 
             
             windowTitle = "Social Care Insights", #title for browser tab
             header = tags$head(includeCSS("www/styles.css")), # CSS styles
             
    ################################         
    #### Tab 1: Introduction ----   
    ################################         
             tabPanel("Introduction", 
                      
                      wellPanel(
                        column(4, h3("Social Care Insights Dashboard - People Supported in Care Homes")),
                        column(8,
                               p("The information in this section is about people who have been supported to meet their 
                                 assessed social care needs within a care home. Information is presented on people who were 
                                 resident (long term, short term or for respite) in a care home at any point during the 
                                 period January 2018 (2017/18 Q4) to 31 March 2021."),
                               
                               p("The figures presented throughout this dashboard will include anyone who is receiving Free 
                                 Personal Care, or otherwise, where some or all of the care home fee is paid by a Health and 
                                 Social Care Partnership. They do not include anyone who is living in a care home on an 
                                 entirely self-funded basis."),
                               
                               p(
                                 "Further information on data definitions and guidance on the information
                                 presented within this dashboard can be found within the Data Definitions and Guidance",
                                 tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                        "Document"),"."),
                               
                               p(strong("Effects of COVID-19 on figures"),
                                 "The measures put in place to respond to COVID-19 pandemic will have affected the 
                                  services that the HSCPs were able to provide over the period of the pandemic.  
                                  Differences in data from previous years are likely to be affected by ability of 
                                  HSCPs to provide social care services while dealing with the impact of the pandemic."),
                               
                              p("Statistical disclosure control has been applied to protect patient confidentiality. Therefore, the figures presented here may not be additive and may differ from previous publications. For further 
                                guidance see Public Health Scotland's",
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
                              
                              p("Revised 16th May 2022. Two errors have been discovered within two dashboards of the Care Home app respectively. The numbers and rates of Short stay and All stay Care home residents had been overcounted within the Trend dashboard.
These figures have been revised. The numbers and percentages of Long-stay residents by Nursing care need within the Nursing Care tab had been presented erroneously. These figures have also been revised.
                                Notes have been added to the relevant analysis impacted by these revisions.", style = "color:red")
                              
                        )
                        ) # end wellpanel
                    
             ), # end intro tabpanel
             
    ####################################
    #### Tab 2: Information tab ----
    ####################################
    
    tabPanel("Information",
             icon = icon("info-circle"),
             mainPanel(
               width = 12,
               
               # Within this section we are going to have a sub tab column on the left
               # To do this we are going to use the layout "navlistPanel()"
               
               navlistPanel(
                 id = "Info_list",
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
                            tags$a(href = "mailto:phs.webmaster@phs.scot", 
                                   "phs.webmaster@phs.scot"),
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
                          
                          p(tags$b("How to use the Dashboard")),
                          p("The Dashboard has three tabs across the top which can be selected: Introduction,
                          Topic Area and Information. Please click on the Topic Area tab to see the different
                          analyses available. These analyses are listed on the left hand side of the screen.
                          Please click on the analysis of interest to see more details. To find more information 
                          about these analyses please select the “Information” tab from the three tabs across the top of the screen."),
                          
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
                          p("To view your data selection in a table, please use the 'Show/hide table' 
                          button. To download your data selection as a CSV file,
                          please use the 'Download data' button. At the top-right corner of the 
                          graph, you will see a toolbar with buttons:"
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
                          
                          
                          
                          
                          ), # end How to pannel
                 
                 
                 ### About Page ----
                 
                 tabPanel("About", 
                          h2("About"),
                          
                          p("Detailed below is additional information on the methods and definitions that have 
                            been implemented. These should be used to assist with interpretation of the results. "),
                          
                          p("Information on emergency hospital admissions, emergency bed days and A&E attendances 
                            from Care Home residents is also provided. Notes on this analysis are provided below."),
                          
                          tags$b("Notes on the Analysis:"),
                          p("Annual rates are calculated based on the number of care home residents on the 31 March each year. 
                            Quarterly rates are based on the number of care home residents at the end of each quarter."),
                          
                          tags$b("Linkage of Care Home data to Health Care datasets notes:"),
                          tags$ul(
                            tags$li("This information has been linked via the CHI number of the patient/client. The 
                                    CHI number was derived on submission of the social care data. Where it was not 
                                    possible to obtain CHI information, these records were excluded from the linked 
                                    health care measures in this section."),
                            tags$li("Individual level care home  information has been linked to acute hospital data 
                                    (Data Source SMR01) and A&E data."),
                            tags$li("The health activity data in this analysis relates to the individual’s most recent 
                                    care home admission between 1 April 2020 and 31 March 2021 (or care home discharge 
                                    date if this is earlier). The emergency admissions, bed days or A&E attendances 
                                    could have been to any hospital in NHS Scotland.")
                          ),
                          
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
                                   "Accident and Emergency attendance data")," ")
                 ),
                 
                 
                 ### Data Definitions -----
                 
                 tabPanel("Definitions", 
                          h2("Data Definitions"),
                          
                          p("The Source data definitions and guidance document can be found",
                            tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                   "here", class="externallink",".")), 
                          p("This provides detailed information on Data Definitions used across all of the Social Care Insights Dashboards.
                            Data Definitions relating specifically to the data presented throughout the People Supported in Care Homes Dashboard can be found below."),
                          
                          tags$b("Methodology"),
                          p("The information provided below on the methods and definitions that have been used throughout this dashboard should
                            be used to assist with interpretation of the results presented."),         
                          
                          tags$b("Data Sources"),
                          p(" ",
                            tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                   "Source Social Care Data")," "),
                          p(" ",
                            tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?ID=1&SubID=5", 
                                   "SMR01 hospital discharge records"),"- SMR01 hospital discharge records. SMR01 is an episode based patient
                            record relating to all inpatient and day cases discharged from specialties
                            other than mental health, maternity, neonatal and geriatric long stay in NHS Scotland."),
                          p(" ",
                            tags$a(href = "https://www.ndc.scot.nhs.uk/National-Datasets/data.asp?SubID=3", 
                                   "Accident and Emergency attendance data")," "),
                          
                          tags$b("Financial Year"),
                          p("Data in this dashboard is available for financial years 2017/18 - 2020/21. 
                            A financial year covers the time period from the 1 April to the 31 March in the following year."),
                          p("For the trend analysis by quarter information is also available for January to March 2018."),
                          
                          tags$b("Age Group"),
                          tags$ul(
                            tags$li("Where age information has been provided, age has been calculated
                                    at the midpoint of the financial year, for example in 2020/21, age is
                                    calculated at 30 September 2020."),
                            tags$li("Age groups available in this analysis include: The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages.")
                            ),
                          
                          tags$b("Local Authorities and Health and Social Care Partnerships"),
                          
                          p("The information shown comes mainly from data gathered within Scotland’s 32 Local Authorities and is 
                            a by-product of many thousands of individual needs assessments carried out, personal choices made
                            and care plans prepared and delivered."),
                          
                          p("Local authorities are one of the strategic partners in Health and Social Care along with Health Boards
                            and Integration Authorities. For presentational reasons the label Health and Social Care Partnership
                            is used throughout this dashboard (rather than Local Authority)."),
                          
                          p("Note: Reflecting variation across Scotland in the way partnership working occurs, the Stirling and Clackmannanshire Council analyses are shown separately
                            although there is a single partnership involving both Local Authorities."),
                          
                          tags$b("Health and Social Care Partnership"),
                          tags$ul(
                            tags$li("If a person received services/support from more than one 
                                    Health and Social Care Partnership during the reporting period, 
                                    they will be counted for each partnership."),
                            tags$li("Information is shown by the Health and Social Care 
                                    Partnership (HSCP) funding the resident`s package of care."),
                            tags$li("The care home placement could be outside the geographical 
                                    boundary of the HSCP.")
                            ),
                          
                          tags$b("Scotland Terminology"),
                          tags$ul(
                            tags$li(" “Scotland” - Information was supplied by all partnerships in Scotland."),
                            tags$li(" “Scotland (Estimated)” - 	Estimates have been included for partnerships that have not supplied the required data.  Areas that have been estimated will be highlighted."),
                            tags$li(" “Scotland (All Areas Submitted)” - This is the total of all areas that provided the required information only. It will undercount the actual picture for Scotland as no estimation has been done to produce a Scotland estimate.")
                          ),
                          
                          tags$b("Resident Type"),
                          tags$ul(
                            tags$li("Long stay residents are defined as anyone funded for a period of over 6 weeks (42 days) by the Local Authority."),
                            tags$li("Anyone funded by the Local Authority for less than 6 weeks is considered a short stay."),
                            tags$li("Residents admitted for respite care are included within these outputs."),
                            tags$li("Due to the constraints of the available information it is not possible to determine
                                    in every case the appropriate category of long or short stay. This relates to people who
                                    have been admitted six weeks or less before the end of March 2021 who are still in 
                                    a care home on 31 March. For statistical purposes such residents have been assumed 
                                    to be long stay and thus there is likely to be a slight over count of long stay 
                                    residents and a slight undercount of short stay."),
                            tags$li("The analysis in the dashboard will highlight what resident type(s) the information is for.")
                            ),
                          
                          tags$b("IoRN Group"),
                          p("The Indicator of Relative Need (ioRN) is a widely available 
                            tool for health and social care practitioners that may be used 
                            to:"), 
                          tags$ul(
                            tags$li("inform individual decisions on the need for interventions to 
                                    support, care and reactivate an individual's independence"), 
                            tags$li("provide a measure (stratification) of a population's functional and social 
                                    independence.")
                            ),
                          
                          p("The summary ioRN Group categories used here broadly 
                            represent, going from left to right or A to I, higher levels of 
                            need e.g. people in Group A are the most independent and people 
                            in Group I are least independent (i.e. have higher needs for 
                            support from others)."),
                          
                          p(
                            "Note that the ioRN Group categories used here are based on the 
                            original version of the community ioRN. Some of the ioRN Groups have 
                            been combined due to small numbers.
                            Further information about the latest version of the community 
                            ioRN (ioRN2) is available",
                            tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/", 
                                   "here", ".")
                          ),
                          
                          tags$ul(
                            tags$li("The ioRN data is an optional part of the Source Social Care 
                                    dataset as it not currently universally used."),
                            tags$li("Where more than one ioRN Group has been assigned to a person, the latest IoRN Group assigned is used.")
                            ),
                          
                          tags$b("Median Length of Stay"),
                          p("This is based on  completed stays only (i.e. those where the resident has been discharged)
                            and does not include stays in a care home which are still ongoing."),
                          p("The `Median length of stay' is the middle value when all the lengths of stay for care home residents are
                            arranged in order of how long the person has been resident in the care home. "),
                          
                          tags$b("Rates per 1,000 Population"),
                          tags$ul(
                            tags$li("Some sections of the dashboard present rates expressed as per 1,000 population."),
                            tags$li("Where rates are based on the general population, the populations used
                                    are based on the mid-year population estimates for the appropriate population 
                                    year and age group, for example the 2020/21 population figures are based on September 2021."),
                            tags$li("When appropriate the rates may be based on the number of care home residents rather than the general population.")
                            ),
                          
                          tags$b("Linkage of care home data to health care datasets
                                 (Accident & Emergency attendances and emergency admissions to hospital):"),
                          tags$ul(
                            tags$li("Care home information has been linked to health data, specifically
                                    Accident & Emergency attendances and emergency admissions to hospital.
                                    This linkage of data permits a broader perspective on the services used by
                                    people in order to meet their health and social care needs."),
                            tags$li("This information has been linked via the Community Health Index (CHI) number  
                                    for an individual. The CHI number was derived on 
                                    submission of the social care data. Where it was not 
                                    possible to obtain CHI information, these records were 
                                    excluded from the linked health care analysis in this 
                                    section."),
                            tags$li("Care home individual level information has been linked to 
                                    acute hospital data (Data Source SMR01) to measure emergency hospital 
                                    admissions and Accident & Emergency (A&E) data to measure the number of 
                                    attendances at A&E by care home residents."),
                            tags$li("The health activity data in this analysis relates to the individual’s most recent 
                                    care home admission between 1 January 2018 and 31 March 2021 (or care home 
                                    discharge date if this is earlier). The emergency admission or A&E attendance could 
                                    have been to any hospital in NHS Scotland."),
                            tags$li("The denominator used in the calculation of emergency 
                                    hospital admission and A&E attendance rates is the number of 
                                    people resident in a care home at the end of the quarter chosen."),
                            tags$li("Please see the",
                                    tags$a(href = "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", 
                                           "accompanying report"), "for more information on the linkage and the completeness of the CHI linkage.")
                            ),
                          
                          tags$b("Disclosure Control"),
                          p("Statistical disclosure control has been applied to protect patient confidentiality. Therefore, the figures presented here may not be additive and may differ from previous publications. For further 
                 guidance see Public Health Scotland's",
                            tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                   "Statistical Disclosure Control Protocol.")
                          )
                          
                            ), # end of data definitions tab panel
                 
                 ### Data Completeness ----
                 
                 tabPanel(
                   "Data Completeness",
                   
                   h2("Data Completeness"),
                   
                   p("The data completeness table below presents the completeness for each Health and Social Care Partnership for the latest years published 
                                     (2019/2020 and 2020/21).  For full data completeness please see the", 
                     tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                            "Technical Document.")),
                   
                   tags$b("Disclosure Control"),
                   p("Statistical disclosure control has been applied to protect patient confidentiality. Therefore, the figures presented here may not be additive and may differ from previous publications. For further 
                 guidance see Public Health Scotland's",
                     tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                            "Statistical Disclosure Control Protocol.")
                   ),
                   
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
                   
                   tags$b("Care Home Data Completeness Table"),
                   DT::dataTableOutput("data_completeness_table"),
                   
                   br()
                   
                   ),
                 
                 
                 
                 ### Resources ----
                 
                 tabPanel("Resources", 
                          h2("Resources"),
                          
                          p("2018/19 Social Care Insights Report:",
                            tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                   "2020-09-29-Social-Care-Report.pdf", class="externallink")),
                          
                          p("2018/19 Social Care Technical Document:",
                            tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                   "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", class="externallink")),
                          
                          p("Social Care Definitions and Recording Guidance:",
                            tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf", 
                                   "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf", class="externallink")),
                          
                          p("Social Care Balance of Care:",
                            tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                   "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",  class="externallink")),
                          
                          p("Disclosure Control Information:",
                            tags$a(href="https://publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
                                   "www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",class="externallink")),
                          
                          p("2017/18 Social Care Insights Dashboard:",
                            tags$a(href="https://scotland.shinyapps.io/nhs-social-care/",
                                   "www.scotland.shinyapps.io/nhs-social-care/",  class="externallink")),
                          
                          p("Care Home Background Information:",
                            tags$a(href="https://www.gov.scot/policies/social-care/social-care-support/#care%20homes ",
                                   "https://www.gov.scot/policies/social-care/social-care-support/carehomes ", class="externallink")),
                          
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
                            tags$a(href=" https://www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",
                                   "www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",   class="externallink")),
                          
                          
                          p("Indicator of Relative Need (IoRN) Information:",
                            tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
                                   "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",    class="externallink"))
                          
                 )
                 
                          ) # end info left navlistpanel
               
               
                          ) # end info mainpanel
             
                            ), # end info tab
    
    ###############################################
    #### Tab 3: People Supported in Care Homes ----
    ###############################################
  
  tabPanel(
    "People Supported in Care Homes",
    mainPanel(
      width = 12,
      
      # Within this section we are going to have a sub tab column on the left
      # To do this we are going to use the layout "navlistPanel()"
      
      navlistPanel(
        id = "Care_Home_Tab_Box",
        widths = c(2, 10),
        
        #######################################################
        ## Tab 3.2: People Supported In Care Homes - Trend (switched order)----
        ########################################################
        
        tabPanel(
          "Trend",
          h3("People Supported in Care Homes - Trend in Long Stay Residents"),

          p("The chart below presents information on care home residents supported in care homes from 
            January 2018 to the end of March 2021. This information is presented as the rate per 1,000 
            long stay residents for the selected age group and locations. "),
          
          p("Two location dropdown menus have been provided to allow direct comparisons between Health 
            and Social Care Partnership’s or against national figures."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide care home 
                    information therefore previous year's data were used where possible to provide 
                    an estimate."),
            tags$li("Please note, that as Comhairle nan Eilean Siar has never submitted care home data 
                    a Scotland Estimated figure cannot be computed, therefore Scotland is presented as an 
                    All Areas Submitted figure."),
            tags$li("In 2017/18 Glasgow City provided an aggregated count of care home residents during 
                    the census week (last week in March) therefore a quarterly figure cannot be 
                    plotted on the chart below. "),
            tags$li("The figures include people where some or all of the care home fee is paid 
                    by the Health and Social Care Partnership. They do not include anyone who 
                    is living in a care home on an entirely self funded basis."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details on data completeness and guidance can 
                    be found in the Information tab.")
          ),
          
          p("Revised 16th May 2022. An error was discovered in the trend data presented for all Health and Social care 
            Partnerships and Scotland (All areas submitted) figures. Upon revising the methodology, it was noted that
            the number of Short stay residents and total number of All stays within a Care home had been overcounted.
            Upon revision of the methodology the figures originally reported have decreased. The biggest impact of 
            the change has been found within the Short stay figures, whereas the changes within the All stay figures 
            has been minimal. For example in Q4 2019/20 number of All stays has reduced by 3.7% and Short stays have
            reduced by 22.9%, and in Q4 2020/21 total of All stays reduced by 1.1% and number of Short stays reduced by 9.8%.
            The Long stay totals were not affected.", style = "color:red"),

          ### dropdown options ----
          
          ## dropdown wellpanel 1
          
          wellPanel(
            
          ## select main location of interest  
            
            column(6, shinyWidgets::pickerInput("ch_trend_location_input",
                                                        "Select Location:",
                                                        choices = unique(data_care_home_trend$sending_location),
                                                        selected = "Scotland (All Areas Submitted)"
          )),
          
          ## select comparison location
          
          column(6, shinyWidgets::pickerInput("ch_trend_location_comparison_input",
                                              "Select Comparison Location:",
                                              choices = unique(data_care_home_trend$sending_location),
                                              selected = "Scotland (All Areas Submitted)"
          ))
          
          ), # end wellpanel 1
          
          ## dorpdown wellpanel 2
          
          wellPanel(
          
          # select age group
          
          column(6, shinyWidgets::pickerInput("ch_trend_age_input",
                                              "Select Age Group:",
                                              choices = unique(data_care_home_trend$age_group[data_care_home_trend$age_group != "Unknown"]),
                                              selected = "All Ages"
          )),
          
          # select measure  
          column(6, shinyWidgets::pickerInput("ch_trend_measure_input",
                                              "Select Measure:",
                                              choices = unique(data_care_home_trend$measure),
                                              selected = "Rate per 1,000 People"
          )),
          
          # select stay type
          
          column(6, shinyWidgets::pickerInput("ch_trend_stay_input",
                                              "Select Stay Type:",
                                              choices = unique(data_care_home_trend$stay_type),
                                              selected = "All Stays"
          ))
          
          ), # end dropdown wellpanel 2
          
          
          ### mainpanel for buttons and plot
          
          mainPanel(
            width = 12,
            
            # show / hide table and download data buttons
            
            actionButton("ch_trend_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            downloadButton(
              outputId = "download_ch_trend_data",
              label = "Download data",
              class = "my_ch_trend_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_trend_button ", button_background_col,
                                ".my_ch_trend_button ", button_text_col, 
                                ".my_ch_trend_button ", button_border_col)
                         )
            ),
            
            hidden(
              div(
                id = "ch_trend_table",
                DT::dataTableOutput("ch_trend_table_output")
              )
            ),
            
            # add line breaks to create space between buttons and plot
            
            br(),
            br(),
            
            # plot output
            
            plotlyOutput("ch_trend_plot",
                         height = "550px")
            
            )
        ),  # end people supported CH trend tab
        
        #####################################################################
        ## Tab 3.1: People Supported In Care Homes - Resident Type (Long / Short Stay)  (switched order) ----
        #####################################################################
        
        tabPanel(
          "Resident Type",
          h3("People Supported in Care Homes - Resident Type"),
          
          p("Care home information was gathered on people who were supported in a care home at 
            any point during the financial years 2017/18 – 2020/21."),
          
          p("The chart below presents the rate per 1,000 population of care home residents who were 
            supported in a care home during the financial years 2017/18 - 2020/21, by Health and 
            Social Care Partnership. The total number of residents is available in the data table 
            which can be viewed by selecting the “Show/hide table” button. "),
          
          p("Care home places are available to meet different needs. Dropdown menus have been 
            provided so data can be presented by stay types: long stay; short stay; and all residents, 
            and age groups."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
          
          p("Please note, anyone funded for a period of over six weeks by the Local Authority is 
            classified here as long stay and all funding shorter than 6 weeks is classified as a 
            short stay. Due to the constraints of the available information it is not possible to 
            determine in every case the appropriate category of long or short stay. This relates 
            to people who have been admitted six weeks or less before the end of March 2021 who 
            are still funded on 31 March. For statistical purposes such residents have been 
            assumed to be long stay and thus there is likely to be a slight over-count of long 
            stay residents and a slight undercount of short stay figures."),
          
          p("The figures include people where some or all of the care home fee is paid by the Health 
            and Social Care Partnership. They do not include anyone who is living in a care home on 
            an entirely self-funded basis."),
          
          p("Scotland (All Areas Submitted) data is presented on the plot as a black reference line. 
            Please hover over the reference line to show data relating to Scotland (All Areas Submitted)."),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide information for all 
                    the services and support reported on in this section therefore to reflect data 
                    completeness a Scotland ‘All Areas Submitted’ has been provided."),
            tags$li("Please consider data definitions and completeness when interpreting the data presented 
                    in this dashboard. Full details on data completeness and guidance can be found in the 
                    Information tab.")
            ),
          
          # br(),
          
          ### dropdown options
          
          wellPanel(
            
           
            
            # select financial year
            column(6, shinyWidgets::pickerInput("ch_resident_type_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_care_home_resident_type$financial_year),
                                                selected = "2020/21"
            )),  
            
            
            # select length of stay
            column(6, shinyWidgets::pickerInput("ch_resident_type_stay_input",
                                                "Select Stay Type:",
                                                choices = unique(data_care_home_resident_type$stay_type),
                                                selected = "All Stays"
            )),
            
            
            # select age group  
            column(6, shinyWidgets::pickerInput("ch_resident_type_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_care_home_resident_type$age_group[data_care_home_resident_type$age_group != "Unknown"]),
                                                selected = "All Ages"
            )),
            
            
            # select measure  
            column(6, shinyWidgets::pickerInput("ch_resident_type_measure_input",
                                                "Select Measure:",
                                                choices = unique(data_care_home_resident_type$measure),
                                                selected = "Rate per 1,000 People"
            ))
            
            
            
            
          ), # end of wellpanel containing filters
          
          # buttons and plot
          
          mainPanel(
            width = 12,
            
            # # show / hide table button 
            
            actionButton("ch_resident_type_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download data
            
            downloadButton(
              outputId = "download_ch_resident_type_data",
              label = "Download data",
              class = "my_ch_resident_type_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_resident_type_button", button_background_col,
                                ".my_ch_resident_type_button", button_text_col, 
                                ".my_ch_resident_type_button", button_border_col)
              )
            ),
            
            # data table to be shown / hidden
            hidden(
              div(
                id = "ch_resident_type_table",
                DT::dataTableOutput("ch_resident_type_table_output")
              )
            ),
            # page break
            
            br(),
            
            # plot output 
            
            plotlyOutput("ch_resident_type_plot",
                         height = "800px"
            )
            
            
          ) # end mainpanel
          
          
            ), # end tabpanel
        
        
        ###################################################
        ## Tab 3.3: Age and Sex of Care Home Residents ----
        ###################################################
        
        tabPanel(
          "Age and Sex",
          h3("People Supported in Care Homes - Age and Sex Summary"),
          
          p("The chart below presents information on care home residents supported in care homes from 
            financial year 2017/18 to 2020/21.  This information is presented as the rate per 1,000 
            long stay care home resident by age group and sex by a selected location. "),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
          
          tags$b("Notes and Data Completeness"),
          tags$ul(
            tags$li("Age has been calculated at midpoint of financial year."),
            tags$li("These figures only include people where both age and sex were recorded."),
            tags$li("Some Health and Social Care Partnerships were unable to provide information for all the services and 
                 support reported on in this section therefore to reflect data completeness a Scotland ‘All Areas Submitted’ 
                 has been provided."),
            tags$li("Please consider data definitions and completeness when interpreting the data presented in this dashboard.
                 Full details on data completeness and guidance can be found in the Information tab.")
            ),
          #br(),

          #### dropdowns
          
          ## wellpanel 1
          
          wellPanel(
            
            # select financial year
            
            column(6, shinyWidgets::pickerInput("ch_age_sex_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_care_home_age_sex$financial_year),
                                                selected = "2020/21"
            )),
            
            
            # select location

            column(6, shinyWidgets::pickerInput("ch_age_sex_location_input",
                                                "Select Location:",
                                                choices = unique(data_care_home_age_sex$sending_location),
                                                selected = "Scotland (All Areas Submitted)"
            ))
          ),
          
          # Well panel 2
          
          wellPanel(
          
          # select stay type
          
          column(6, shinyWidgets::pickerInput("ch_age_sex_stay_input",
                                              "Select Stay Type:",
                                              choices = unique(data_care_home_age_sex$stay_type),
                                              selected = "All Stays"
          ))
          
        ), # end wellpanel 2
          
          
          
          # show hide and dropdown buttons
          
          mainPanel(
            width = 12,
            
            # show / hide table
            
            actionButton("ch_age_sex_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),

            # download data
            
            downloadButton(
              outputId = "download_ch_age_sex_data",
              
              label = "Download data",
              
              class = "my_ch_age_sex_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_age_sex_button ", button_background_col,
                                ".my_ch_age_sex_button ", button_text_col, 
                                ".my_ch_age_sex_button ", button_border_col)
                         )
            ),
            
            # data table to be shown / hidden
            hidden(
              div(
                id = "ch_age_sex_table",
                DT::dataTableOutput("ch_age_sex_table_output")
              )
            ),
            
            # add line of space
            br(),
            
            # plot
            
            mainPanel(
              width = 12,
              plotlyOutput("ch_age_sex_plot",
                           height = "550px"),
                        br()
              
                     )
        
          ) # end mainpanel
        ), # end tabpanel
        

        #####################################################
        ## Tab 3.6: Median Length of Stay In Care Home ----
        #####################################################
        
        tabPanel(
          "Median Length of Stay",
          h3("People Supported in Care Homes - Median Length of Stay"),
          
          p("The chart below presents the median length of stay for people who were long stay care 
            home residents at some point during the selected financial year, whose stay has come to 
            an end. Information is presented by Health and Social Care Partnership and age group. 
            The median length of stay for Scotland (All Areas Submitted) is presented as a black 
            line across the chart."),
          
          p("Please note, anyone funded for a period of over six weeks by the Local Authority is 
            classified here as long stay. The figures include people where some or all of the care 
            home fee is paid by the Health and Social Care Partnership. They do not include anyone 
            who is living in a care home on an entirely self-funded basis."),
          
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
          
          tags$b("Notes and Data Completeness"),
          tags$ul(
            tags$li("Data is based on completed stays only (i.e. those where the resident
                    has been discharged) and does not include stays in a care home which are 
                    still ongoing."),
            tags$li("The `Median length of stay' is the middle value when all the lengths of stay 
                    for care home residents are arranged in order of how long the person has been 
                    resident in the care home."),
            tags$li("Some Health and Social Care Partnerships were unable to provide information 
                    for all the services and support reported on in this section therefore to 
                    reflect data completeness a Scotland ‘All Areas Submitted’ has been provided."),
            tags$li("The figures include people where some or all of the care home fee is paid by 
                    the Health and Social Care Partnership. They do not include anyone who is living 
                    in a care home on an entirely self-funded basis."),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details on data completeness and guidance can be found in the Information tab.")
            ),
          br(),
          
          ### dropdown options
          
          wellPanel(
          
          
          
            # select financial year
            
            column(6, shinyWidgets::pickerInput("ch_los_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_care_home_length_of_stay$financial_year),
                                                selected = "2020/21"
            )),
            
              
          # select age group
          
          column(6, shinyWidgets::pickerInput("ch_los_age_input",
                                              "Select Age Group:",
                                              choices = unique(data_care_home_length_of_stay$age_group[
                                                                    data_care_home_length_of_stay$age_group != "Unknown"]),
                                              selected = "All Ages"
          ))
          
          ), # end dropdown wellpanel
          
          
          mainPanel(
            width = 12,
            
            
            # show / hide table button 
            
            actionButton("ch_los_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download data button
            
            downloadButton(
              outputId = "download_ch_los_data",
              
              label = "Download data",
              
              class = "my_ch_length_of_stay_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_length_of_stay_button ", button_background_col,
                                ".my_ch_length_of_stay_button ", button_text_col, 
                                ".my_ch_length_of_stay_button ", button_border_col)
                         )
            ),
            
            # data table to show / hide
            
            hidden(
              div(
                id = "ch_los_table",
                DT::dataTableOutput("ch_los_table_output")
              )
            ),
            
            # page break
            
            br(),
            
            # plot output
            
            plotlyOutput("ch_los_plot",  height = "750px")


          ) # end mainpanel
        ), # end tabpanel
        
        ##############################################
        ## Tab 3.7: Need For Nursing Care ----
        ##############################################
        
         tabPanel(
          "Nursing Care",
          h3("People Supported in Care Homes - Need For Nursing Care"),
          
          p("The chart below presents the percentage of long stay care home residents during 
            the selected financial year who required nursing care."),
         
          p("Please note, anyone funded for a period of over six weeks by the Local Authority is 
            classified here as long stay. The figures include people where some or all of the 
            care home fee is paid by the Health and Social Care Partnership. They do not include 
            anyone who is living in a care home on an entirely self-funded basis."),
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
          
         tags$b("Notes and Data Completeness"),
         tags$ul(
           tags$li("The figures include people where some or all of the care home fee is paid by the 
                   Health and Social Care Partnership. They do not include anyone who is living in a 
                   care home on an entirely self-funded basis."),
           tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                   all the services and support reported on in this section therefore to reflect data 
                   completeness a Scotland ‘All Areas Submitted’ has been provided."),
           tags$li("Please consider data definitions and completeness when interpreting the data 
                   presented in this dashboard. Full details on data completeness and guidance can 
                   be found in the Information tab or in the ",
                   tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                          "Technical Document provided."))
         ),
         br(),
         
         p("Revised 9th May 2022. An error was discovered in the nursing provision data presented for all Health and Social care Partnerships and 
           Scotland (All areas submitted) figures.  It was noted that due to a formatting error, the figures of Long-stay residents by Nursing 
           care need in the graph had been reversed within the presentation of the graph.  For example, Scotland (All areas submitted) had shown 
           62.6% of Long-stay residents as receiving Nursing provision, whereas the revised figures show that 62.6% of Long-stay residents 
           resided in a Care home with no nursing provision. The affected figures have been revised and highlighted within the dashboard.", 
           style = "color:red"),
         
         br(),
         
          ### dropdown options
          

          
          wellPanel(
            
            # select financial year 
            
            column(6, shinyWidgets::pickerInput("ch_nursing_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_care_home_nursing_care$financial_year),
                                                selected = "2020/21"
            )),
            
            
            # select age group
            
            column(6, shinyWidgets::pickerInput("ch_nursing_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_care_home_nursing_care$age_group[data_care_home_nursing_care$age_group != "Unknown"]),
                                                selected = "All Ages"
            ))
            
          ),
          
          
          mainPanel(
            width = 12,
            
            # show / hide table button 
            
            actionButton("ch_nursing_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download button
            downloadButton(
              outputId = "download_ch_nursing_data",
              
              label = "Download data",
              
              class = "my_ch_nursing_care_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_nursing_care_button ", button_background_col,
                                ".my_ch_nursing_care_button ", button_text_col, 
                                ".my_ch_nursing_care_button ", button_border_col)
                         )
            ),
            
            # table to show / hide 
            
            hidden(
              div(
                id = "ch_nursing_table",
                DT::dataTableOutput("ch_nursing_table_output")
              )
            ),
            
            # page break
            
            br(),
            
            # plot output 
            
            plotlyOutput("ch_nursing_plot",
                         height = "750px"
            )
            
            
          ) # end mainpanel
        ), # end tabpanel
        
        ##################################
        ## Tab 3.8: Emergency Care ----
        ##################################
        
        tabPanel(
          "Emergency Care",
          h3("People Supported in Care Homes - Emergency Care"),
          
         p("The chart below presents information on emergency admissions to hospital (acute), accident 
              and emergency (A&E) attendances to hospital and emergency admission bed days for care home 
              residents during each financial quarter, by Health and Social Care Partnership. 
              Data are shown as a rate per 1,000 care home residents at the end of the selected quarter 
              and for the selected age group."),
          
          
          tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
          
          tags$b("Measures"),
            p("There are three different analyses that can be selected:"),
            tags$ul(
              tags$li("Emergency Admissions"),
              tags$li("A&E Attendances"),
              tags$li("Emergency Admission Bed Days")
            ),
          
          tags$b("Notes and Data Completeness"),
          tags$ul(
          tags$li("Some Health and Social Care Partnerships were unable to provide information 
                  for all the services and support reported on in this section therefore to 
                  reflect data completeness a Scotland ‘All Areas Submitted’ has been provided."),
          tags$li("Please consider data definitions and completeness when interpreting the data 
                  presented in this dashboard. Full details on data completeness and guidance can 
                  be found in the Information tab or the",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided."))
          ),
          br(),
         # ), end of text wellpanel
          
          
          ### dropdown options
          
          ## wellpanel 1
         
          wellPanel(
            
            # select financial quarter
            column(6, shinyWidgets::pickerInput("ch_emergency_year_input",
                                                "Select Financial Quarter:",
                                                choices = unique(data_care_home_emergency_care$financial_quarter),
                                                selected = "2020/21 Q4"
            )),
            
            # select age group
            column(6, shinyWidgets::pickerInput("ch_emergency_age_input",
                                                "Select Age Group:",
                                                choices = unique(data_care_home_emergency_care$age_group[
                                                  data_care_home_emergency_care$age_group != "Unknown" & 
                                                    data_care_home_emergency_care$age_group != "0-17 years"]),
                                                selected = "All Ages"
            ))
            
            ), # end wellpanel 1
         
         ## dropdown wellpanel 2
            
         wellPanel(
         
            # select measure
            column(6, shinyWidgets::pickerInput("ch_emergency_measure_input",
                                                        "Select Measure:",
                                                        choices = unique(data_care_home_emergency_care$measure),
                                                selected = "Emergency Admissions"
          ))
          
          ), # end wellpanel
          
          # buttons and plot
          
          mainPanel(
            width = 12,
            
            # show / hide table button 
            
            actionButton("ch_emergency_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download button 
            
            downloadButton(
              outputId = "download_ch_emergency_data",
              label = "Download data",
              class = "my_ch_emergeny_adm_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_emergeny_adm_button ", button_background_col,
                                ".my_ch_emergeny_adm_button ", button_text_col, 
                                ".my_ch_emergeny_adm_button ", button_border_col)
                         )
            ),
            
            # table to show / hide
            hidden(
              div(
                id = "ch_emergency_table",
                DT::dataTableOutput("ch_emergency_table_output")
              )
            ),
            
            # page break
            
            br(),
            
            # plot output 
            plotlyOutput("ch_emergency_plot",
                         height = "750px"
            )

            
          ) # end mainpanel
        ), # end tab panel
        
        ###################################################
        ## Tab 3.4: Referral Source ---- moved
        ###################################################

        tabPanel(
          "Care Home Referrals to Hospital",
          h3("People Supported in Care Homes - Referrals to Hospital"),
          
          p("The chart below presents information on the type of referral to hospital for Long Stay 
            Care home residents by health and Social Care Partnership. "),
  
         tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages from 2017/18 onwards."),
          
          tags$b("Data Completeness"),
          tags$ul(
          tags$li("Some Health and Social Care Partnerships were unable to provide care home information 
                  therefore a Scotland ‘All Areas Submitted’ total has been provided."),
          tags$li("Data completeness issues may affect interpretation of the data in some instances."),
          tags$li("Please consider data definitions and completeness when interpreting the data 
                  presented in this dashboard. Full details can be found within the", 
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided"), "or the information tab within the dashboard.")
          ),
          br(),
  
        #### dropdowns
  
        ## wellpanel 1
  
        wellPanel(
    
        # select financial year
    
        column(6, shinyWidgets::pickerInput("ch_referral_year_input",
                                        "Select Financial Quarter:",
                                        choices = unique(data_care_home_referral_source$financial_quarter),
                                        selected = "2020/21 Q4"
        )),
    
          
          # select age group
          
          column(6, shinyWidgets::pickerInput("ch_referral_age_input",
                                                "Select Age Group:",
                                                 choices = unique(data_care_home_referral_source$age_group[data_care_home_referral_source$age_group != "Unknown"]),
                                                 selected = "All Ages"
                                                  )) 
          
       
        ), # end wellpanel 2
       
        
        ### mainpanel for buttons and plot
        
        
        mainPanel(
           width = 12,
           
           ### show / hide table
           
           actionButton("ch_referral_showhide",
                        "Show/hide table",
                        style = button_style_showhide
           ),
          
           ### download data
          
           downloadButton(
              outputId = "download_ch_referral_data",
             
              label = "Download data",
             
             class = "my_ch_referral_source_button"
        ),
           tags$head(
            tags$style(paste0(".my_ch_referral_source_button ", button_background_col,
                               ".my_ch_referral_source_button ", button_text_col, 
                               ".my_ch_referral_source_button ", button_border_col)
             )
           ),
           
            ### data table to be shown / hidden
           hidden(
               div(
                 id = "ch_referral_table",
                 DT::dataTableOutput("ch_referral_table_output")
             )
           ),
             
           ### add line of space
            br(),
           
          ### plot
          
         mainPanel(
             width = 12,
             plotlyOutput("ch_referral_plot",
                           height = "850px"),
             br()
             
              )
          
        ) # end mainpanel
        ), # end tabpanel


        #####################################################
        ## Tab 3.9: Level of Independence IoRN Care Home ----
        #####################################################
        
        tabPanel(
          "Level of Independence (IoRN Group)",
          h3("People Supported in Care Homes - Level of Independence (IoRN Group) Before Admission"),
          
         p("The", tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/", 
                                "Indicator of Relative Need (IoRN)"), " is a widely available 
                tool for health and social care practitioners that may be used 
                to:"
                   ), 
          tags$ul(
          tags$li("inform individual decisions on the need for interventions to 
                support, care and reactivate an individual's independence"), 
          tags$li("provide a measure (stratification) of a population's functional and social 
                independence.")
          ),
                
        p("Of people with an IoRN Group recorded during financial year 2020/21,
          the following chart shows the percentage admitted to a care home after being 
          assigned an IoRN Group."),  
        
         p("The summary IoRN Group categories used here broadly represent, going from left to 
           right or A to I, higher levels of need e.g. people in Group A are the most independent 
           and people in Group I are least independent (i.e. have higher needs for support from 
           others)."),
            
             tags$b("Data Completeness and Notes"),
        tags$ul(
          tags$li("Only individuals aged 65 or older at 30 September 2020 have been included in the 
                  analysis."),
          tags$li("The IoRN data is an optional part of the Source Social Care dataset as it not 
                  currently universally used. In 2020/21 only seven areas submitted this information 
                  in time to be included in this analysis."),
          tags$li("Where more than one IoRN Group has been assigned to a person, the latest IoRN Group 
                  assigned is used."),
          tags$li("Additional details on the IoRN Group can be found in the Information - 
                  Data Definitions section of the dashboard."),
          tags$li("Please consider data definitions and completeness when interpreting the data presented 
                  in this dashboard. Full details on data completeness and guidance can be found in the 
                  Information tab or the",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided."))
          ),
          
         # ), end well panel
         
         # br(),
          
        
          
        ### dropdowns
           
           wellPanel(

            # select year
            column(6, selectInput("ch_iorn_year_input",
                                  "Select Financial Year:",
                                  choices = unique(data_care_home_iorn$financial_year),
                                  selected = "2020/21"
            )),
            
           
          
            # select location

            column(6, selectInput("ch_iorn_location_input",
                                          "Select Location:",
                                          choices = unique(data_care_home_iorn$sending_location)
                                 
          ))
          ),
        
       
        # buttons and plot output
          
          mainPanel(
            width = 12,
            
            # show / hide table button 
            actionButton("ch_iorn_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),
            
            # download data 
            downloadButton(
              outputId = "download_ch_iorn_data",
              
              label = "Download data",
              
              class = "my_ch_iorn_button"
            ),
            tags$head(
              tags$style(paste0(".my_ch_iorn_button ", button_background_col,
                                ".my_ch_iorn_button ", button_text_col, 
                                ".my_ch_iorn_button ", button_border_col)
                         )
            ),
            
            # table to show / hide
            hidden(
              div(
                id = "ch_iorn_table",
                DT::dataTableOutput("ch_iorn_table_output")
              )
            ),
            # page break
            
            br(),
            
            # plot output
            
            plotlyOutput("ch_iorn_plot",  height = "500px")
            
          ) # end mainpanel
        ) # end tabpanel

        #########################
        #### ending brackets ----        
        
      ) # end navlist panel
    ) # end people supported panel
  ) # end people supported tabpanel
  
#################################
##### closing brackets ------
#################################

) # end nav bar across top

) # fluidPage bracket


#) # end secure_app function for password protect PRA
# comment out if not password protecting for PRA


## END OF SCRIPT
