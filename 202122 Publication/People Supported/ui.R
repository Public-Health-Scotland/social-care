####################################-
## CLIENT UI SCRIPT ##
####################################-


##########################-
## password protect PRA ##
# shinymanager::secure_app( # comment out if not required 
##########################-


##### UI -----


ui <- fluidPage(
  useShinyjs(),
  
  # Set the language of the page - important for accessibility
  tags$html(lang = "en"),
  
  # The following code allows the shiny app to be viewed on mobile devices  
  HTML('<meta name="viewport" content="width=1200">'),
  style = "width: 100%; height: 100%; max-width: 1200px;", 
  
  navbarPage(id = "tabs_across_top", 
             
             title = div(tags$a(img(src="phs_logo.png", height=40), href= "https://www.publichealthscotland.scot/"),
                         style = "position: relative; top: -10px;"), 
             
             windowTitle = "Social Care Insights", #title for browser tab
             header = tags$head(includeCSS("www/styles.css")), # CSS styles
             
             ###############################-
             #### Tab 1: Introduction ----   
             ###############################-
             
             tabPanel("Introduction", 
                      
                      wellPanel(
                        column(4, h3("Social Care Data Insights Dashboard - People and Services")),
                        column(8,
                               tags$br(),
                               p("Social care is provided to people to meet a diverse range of support needs and there 
                                 are choices about how this support is delivered. The information recorded about the 
                                 people receiving social care in its various forms contributes to understanding this 
                                 diversity. This section provides a summary or numbers and rates of people receiving 
                                 a variety of difference social care support and service types."),
                               br(),
                               p("This Dashboard has four additional tabs which can be selected: “Information”, “People Supported”, 
                                 “Data Completeness” and “Data Quality”. Please click on “People Supported” tab to see the different analyses available. 
                                 “Data Completeness” provides notes on completeness for each data set, time period and Health and Social Care Partnership (HSCP).  
                                 “Data quality” provides notes on the quality of the data (including where estimates have been used if data have not been submitted) 
                                 for each data set, time period and Health and Social Care Partnership.  For more information on data definitions and guidance on the 
                                 information presented in this dashboard please click the Information tab."),
                               br(),
                               p(strong("Effects of COVID-19 on figures"),
                                 "The measures put in place to respond to COVID-19 pandemic will have affected the 
                                  services that the Health and Social Care Partnerships (HSCPs) were able to provide over the period of the pandemic.  
                                  Differences in data from previous years are likely to be affected by ability of 
                                  HSCPs to provide social care services while dealing with the impact of the pandemic."),
                               br(),
                               p("Statistical disclosure control has been applied to protect patient confidentiality. 
                                  Therefore, the figures presented here may not be additive and may differ from previous 
                                  publications. For further guidance see Public Health Scotland's",
                                 tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                        "Statistical Disclosure Control Protocol.",
                                        target="_blank"),
                                 br(),
                                 p("If you experience any problems using this dashboard or have",
                                   "further questions relating to the data, please contact", 
                                   "us at: ",
                                   tags$b(tags$a(
                                     href = "mailto:phs.source@phs.scot",
                                     "phs.source@phs.scot")),
                                   "."),
                                 
                                 br(),
                                 br(),
                                 
                                 p(strong("Proposed change to future publications for 2022/23 data onwards")),
                                 p("Public Health Scotland (PHS) are proposing a change to the information 
                                   presented in the People Supported tab in future publications and would 
                                   welcome your feedback on this."),
                                 p("Due to the differences in the Scottish Government’s Social Care Survey 
                                   and the PHS Source social care data collection an ‘adjusted’ figure is 
                                   included in the dashboard for the rate and the number people. This was 
                                   to enable a trend comparison with the Scottish Government Social Care Survey."),
                                 p("There are five years of data available from the PHS social care data collection 
                                   for trend information and as a result PHS propose to no longer update the adjusted 
                                   figures. This will enable the publication to focus on the wider range of social care 
                                   data that are collected though the PHS Source social care data collection."),
                                 p("We would be grateful if you could contact us at: ",
                                   tags$b(tags$a(
                                     href = "mailto:phs.source@phs.scot",
                                     "phs.source@phs.scot")), 
                                   "to provide feedback on this proposed change to future publications."),
                                 
                                 br()
                                 
                               )
                        )
                      ) # end wellPanel
             ), # end intro tabpanel
             ############################-
             #### Tab 2: Information ----
             ############################-
             
             tabPanel("Information", 
                      icon = icon("info-circle"),
                      mainPanel(
                        width = 12,
                        
                        
                        navlistPanel(
                          id = "left_tabs_info",
                          widths = c(2, 10),
                          
                          
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
                                   p("The Dashboard has five tabs across the top which can be selected: Introduction,
                                    Information, People Supported, Data Completeness and Data Quality. Please click on the Topic Area tab to see the different
                                    analyses available. These analyses are listed on the left hand side of the screen.
                                    Please click on the analysis of interest to see more details. To find more information 
                                    about these analyses, please select the “Information” tab from the five tabs across the top of the screen."),
                                   
                                   
                                   p("Commentary and further background information on the analyses presented in this dashboard can be found in the accompanying",
                                     tags$a(href = "https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx", 
                                            "Technical Document.",
                                            target="_blank")),
                                   
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
                          
                          
                          
                          ### About ----
                          
                          tabPanel("About", 
                                   h2("About"),
                                   
                                   p("Social care embraces many different types of support and services. 
                                     The national Source social care dataset that provides the basis of most
                                     of the analyses includes data on remote monitoring, care at home and care homes.
                                     It also provides summary data on allocated social workers or support workers,
                                     day care and meals. This dashboard provides a summary of 
                                     all people receiving social care from any of the above services. Note, people 
                                     involved in choosing and controlling their support through self-directed support
                                     options who do not receive any of these services from the Local Authority are also 
                                     included in the social care count."),
                                   
                                   p("The information shown comes mainly from data gathered within Scotland’s 32 Local Authorities.
                                     The underlying data are by-products of many thousands of individual needs assessments
                                     carried out, personal choices made and care plans prepared and delivered."),
                                   
                                   p("For service types all information shown relates to services and support where a local 
                                     authority has an involvement, such as providing the care and support directly or
                                     by commissioning the care and support from other service providers.  
                                     Data on care and support that are paid for and organised entirely by people themselves
                                     (i.e. “self-funded”) are not available and are excluded from all the analyses."),
                                   
                                   p(
                                     "Due to the differences in the data collected for the",
                                     tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                                            "Social Care Survey",
                                            target="_blank"),
                                     "and the Source Social Care Data collection an ‘adjusted’ figure is also provided in the dashboard 
                                     for the number of people to allow trend information to be presented and a reliable
                                     comparison to be made between the two different data collections. The ‘adjusted’ 
                                     figure has been created by:"),
                                   tags$ul(
                                     tags$li("Excluding people where the only information available was that they were supported in a care home "),
                                     tags$li("Excluding people who only received day care"),
                                     tags$li("Excluding people who only received care at home who did not receive care at home in the ‘census week’")
                                   ),
                                   
                                   p("Please see note on the Introduction tab regarding future publications and the proposal to no longer update the 'adjusted' figures."),
                                   
                                   tags$b("Data Sources"),
                                   p(" ",
                                     tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                            "Source Social Care Data",
                                            target="_blank")," ")
                          ),
                          
                          ### Definitions ----
                          
                          tabPanel("Definitions", 
                                   h2("Data Definitions"),
                                   
                                   p("The Source data definitions and guidance document can be found",
                                     tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                            "here.", 
                                            class="externallink",
                                            target="_blank")), 
                                   p("This provides detailed information on Data Definitions used across all of the Social Care Insights Dashboards. 
                                     Data Definitions relating specifically to the data presented throughout the People and Services Dashboard can be found below."),
                                   
                                   tags$b("Methodology"),
                                   p("The information provided below on the methods and definitions that have been used throughout this dashboard should be used to 
                                     assist with interpretation of the results presented."),  
                                   
                                   tags$b("Data Sources"),
                                   p(" ",
                                     tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                            "Source Social Care Data",
                                            target="_blank")," "),
                                   
                                   tags$b("Financial Year"),
                                   p("Data in this dashboard are available for financial years 2017/18 and 2021/22. 
                                      A financial year covers the time period from the 1 April to the 31 March in the following year."),
                                   p(
                                     "Where trend information is presented in this dashboard, this includes data previously 
                                      published by the Scottish Government in the Social Care Survey. 
                                      Data ranging from 2015/16 to 2016/17 have been obtained from",
                                     tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                                            "the Scottish Government Website.",
                                            target="_blank")
                                   ),
                                   
                                   tags$b("People Supported by Social Care Services and Support"),
                                   p("If a person received services/support from more than one Health and Social Care Partnership during the reporting period, they will be counted for each partnership. 
                                      For trend analyses, missing information has been estimated by using figures from last submission where possible or 2016/17 figures from the Social Care Survey published by the Scottish Government.
                                     "),
                                   
                                   p("If someone received more than one social care support service in a selected financial year, they are only counted once in the total number of people receiving social care services/support. 
                                     In order to create a national figure, where data are missing an estimated figure has been calculated (see section on estimations and calculations below)."),
                                   
                                   tags$b("Demographic Information"),
                                   p("Demographic information presented here includes details on an individual's age, sex and ethnic group. 
                                     When demographic information is matched to service data the latest record is selected. 
                                     As a result, some outputs here may differ from previously published figures."),
                                   
                                   tags$b("Client Group"),
                                   p("The client/service user group(s) is determined by a social worker or other health and social care professional. People may be recorded in more than one client group therefore the 
                                     individual client group categories cannot be added together to obtain a total number of people."),
                                   
                                   tags$b("Care at Home"),
                                   p("Care at home is defined as the practical services which assist the service user to function as independently as possible and/or continue to live in their own home. 
                                     Care at home can include routine household tasks such as basic housework, shopping, laundry, paying bills etc."),
                                   
                                   tags$b("Self-directed support (SDS)"),
                                   p("Self-directed Support is the mainstream approach to social care in Scotland. It gives 
                                     people control over an individual budget and allows them to choose how that money is 
                                     spent on the support and services they need to meet their agreed health and social care outcomes.
                                     The self-directed support options available are:"),
                                   tags$ul(
                                     tags$li("Option 1: Taken as a Direct Payment."),
                                     tags$li("Option 2: Allocated to an organisation  that the 
                                  person chooses and the person is in charge of how it is 
                                  spent."),
                                     tags$li("Option 3: The person chooses to allow the council 
                                  to arrange and determine their services."),
                                     tags$li("Option 4: The person can choose a mix of these 
                                  options for different types of support.")
                                   ),
                                   
                                   tags$b("Care Home"),
                                   p("Location for long stay, short term and respite care. The figures include people where some
                                     or all of the care home fee is paid by the Health and Social Care Partnership. They do not
                                     include anyone who is living in a care home on an entirely self-funded basis."),
                                   
                                   tags$b("Community Alarm"),
                                   p("A community alarm is a form of equipment for communication, especially useful as an alert should the user have an incident where they require to call for help quickly. 
                                     Typically, it includes a button/pull cord/pendant which transfers an alert/alarm/data to a monitoring centre or individual responder.
                                     It can be used within an individual’s own home or part of a communal system."),
                                   
                                   tags$b("Telecare"),
                                   p("Telecare refers to a technology package which goes over and above the basic community alarm package. 
                                     It is the remote or enhanced delivery of care services to people in their own home by means of telecommunications and computerised services. 
                                     Telecare usually refers to sensors or alerts which provide continuous, automatic and remote monitoring of care needs emergencies and lifestyle using information 
                                     and communication technology to trigger human responses or shut down equipment to prevent hazards (Source:",
                                     tags$a(href = "https://www.tec.scot/", 
                                            "National Telecare Development Programme, Scottish Government",
                                            target="_blank"),")."
                                   ),
                                   
                                   tags$b("Day Care"),
                                   p("Day care involves attendance at a location other than the
                                     client or service user's own home for personal, social, therapeutic, training or leisure purposes."),
                                   
                                   tags$b("Housing Support (2017/18-2019/20)"),
                                   p("Housing Support services help people to live as independently as possible in the community. 
                                     These services help people manage their home in different ways. These include assistance to claim welfare benefits, 
                                     fill in forms, manage a household budget, keep safe and secure, get help from other specialist services, 
                                     obtain furniture and furnishings and help with shopping and housework. The type of support that is provided will aim to 
                                     meet the specific needs of the client/service user. From April 2020 this item was no longer part of the social care collection 
                                     however some partnerships chose to still submit this information. If provided such people have been included in the total client
                                     count but not shown under the service breakdown. The housing support data item was no longer collected as a separate data item post April 2020.  
                                     Housing support is included under non-personal care tasks in the Care at home section."),
                                   
                                   tags$b("Meals"),
                                   p("Includes both hot meals such as Meals on Wheels or a frozen
                                     meal where the client/service user is provided with frozen meals during reporting period."),
                                   
                                   tags$b("Ethnic Group"),
                                   p("A statement made by the client/service user about their ethnic group."),
                                   
                                   tags$b("Local Authorities and Health and Social Care Partnerships"),
                                   
                                   p("The information shown comes mainly from data gathered within Scotland’s 32 Local Authorities and is 
                                     a by-product of many thousands of individual needs assessments carried out, personal choices made
                                     and care plans prepared and delivered."),
                                   
                                   p("Local Authorities are one of the strategic partners in Health and Social Care along with Health Boards
                                     and Integration Authorities. For presentational reasons the label Health and Social Care Partnership
                                     is used throughout this dashboard (rather than Local Authority). 
                                     Note: Reflecting variation across Scotland in the way partnership working occurs, the Stirling and Clackmannanshire Council analyses are shown separately
                                     although there is a single partnership involving both Local Authorities."),
                                   
                                   tags$b("Health and Social Care Partnership"),
                                   tags$ul(
                                     tags$li("Information is shown by the Health and Social Care 
                                             Partnership (HSCP) funding the individual's support package."),
                                     tags$li("If a person received services/support from more than one 
                                             Health and Social Care Partnership during the reporting period, 
                                             they will be counted for each partnership.")
                                   ),
                                   
                                   tags$b("Scotland Terminology"),
                                   tags$ul(
                                     tags$li(" “Scotland” - Information was supplied by all partnerships in Scotland."),
                                     tags$li(" “Scotland (estimated)” - 	Estimates have been included for partnerships that have not supplied the required data.  Areas that have been estimated will be highlighted."),
                                     tags$li(" “Scotland (All Areas Submitted)” - This is the total of all areas that provided the required information only. It will undercount the actual picture for Scotland as no estimation has been done to produce a Scotland estimate.")
                                   ),
                                   
                                   tags$b("Age Group"),
                                   tags$ul(
                                     tags$li("Where age information has been provided, age has been calculated
                                  at the midpoint of the financial year, for example in 2021/22, age is
                                  calculated at 30 September 2021."),
                                     tags$li("Age group breakdowns are available for some analysis in this dashboard.
                                  Where available the options will include: 0-17, 18-64, 65-74, 75-84, 85+, Unknown and All Ages.
                                  Please note, not all analyses will include the age group '0-17 years' due to small numbers.")
                                   ),
                                   
                                   tags$b("Number of People Measure"),
                                   p("The number of people supported in Scotland during each financial year is a unique count of 
                                      the total number of people for all social care services and support collected by Public Health 
                                      Scotland (care at home, care home, community alarms/telecare, meals, day care, social worker and housing support). 
                                      People involved in choosing and controlling their support through self-direct support options are also included."),
                                   
                                   tags$b("Rate per 1,000 Population Measure"),
                                   p("The rate per 1,000 population is rate of people who receive social care support and/or services in Scotland during 
                                     each financial year against the Scottish population, i.e. numerator is the total count of peole who receive support and 
                                     services through social care. The denominator is the Scottish population."),
                                   
                                   tags$b("Rate per 1,000 People Measure"),
                                   p("The rate per 1,000 people is rate of people who receive a specific type of social care support and/or service in 
                                          Scotland during each financial year against total number of social care clients, i.e. numerator is total number of 
                                          people receiving a specific social care service, such as care at home.  The denominator is the total count of people 
                                          receiving any type of social care service / support."),
                                   
                                   tags$b("Adjusted Figures"),
                                   p("Due to the differences in the Social Care Survey and the source 
                                     social care data collection an ‘adjusted’ figure is provided in the
                                     dashboard for the number of people to allow trend information to be
                                     presented and a reliable comparison to be made with the social care survey."),
                                   p("The ‘adjusted’ figure has been created by:"),
                                   tags$ul(
                                     tags$li("Excluding people where the only information available was that they were supported in a care home."),
                                     tags$li("Excluding people who only received day care."),     
                                     tags$li("Excluding people who only received care at home who did not receive care at home in the ‘census week’.")
                                   ),
                                   
                                   tags$b("Estimates (People Supported and Trend Tabs only)"),
                                   
                                   p("As some partnerships were unable to provide individual level information for specific topics (noted in the Data completeness section within the app) estimates have been used to create top level Scotland figures for trends. The percentages applied to create the estimates have been calculated using Scotland level (all areas submitted) data. These percentages represent the percentage of clients receiving these services only."),
                                   
                                   p("The percentages applied to create the estimates have been calculated using Scotland level (all areas submitted) data. These percentages represent the percentage of clients receiving these services only."),
                                   
                                   p("Please refer to the ",
                                     tags$a(href = "https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx", 
                                            "Technical Document.",
                                            target="_blank"), "for details."),
                                   
                                   br(),
                                   br()
                                   
                          ),
                          
                          
                          
                          ### Resources  ----
                          
                          tabPanel("Resources", 
                                   h2("Resources"),
                                   
                                   p(strong("People Supported Resources")),
                                   
                                   p("Care at home Background Information:",
                                     tags$a(href="https://www.gov.scot/publications/national-care-standards-care-home/pages/1/",
                                            "National Care Standards - Care at Home", 
                                            class="externallink",
                                            target="_blank")),
                                   
                                   
                                   p("Personal Care Information:",
                                     tags$a(href="https://www.gov.scot/policies/social-care/social-care-support/#free%20care",
                                            "www.gov.scot/policies/social-care/social-care-support/freecare",  
                                            class="externallink",
                                            target="_blank")),
                                   
                                   p("Community Alarms and Telecare Information:",
                                     tags$a(href="https://www.tec.scot",
                                            "www.tec.scot",   
                                            class="externallink",
                                            target="_blank")),
                                   
                                   p("Scotland’s Digital Health Care Strategy:",
                                     tags$a(href=" https://www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",
                                            "www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",   
                                            class="externallink",
                                            target="_blank")),
                                   
                                   p("Self-directed Support Strategy:",
                                     tags$a(href="https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/",
                                            "www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/", 
                                            class="externallink",
                                            target="_blank")),
                                   
                                   p("Indicator of Relative Need (ioRN) Information:",
                                     tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
                                            "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",    
                                            class="externallink",
                                            target="_blank")),
                                   
                                   
                                   p(strong("People Supported Releases and Supporting Documents")),
                                   
                                   
                                   p("2021/22 Social Care Insights Publication:",
                                     tags$a(href="https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-202021-to-202122/",
                                            "https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-202021-to-202122/", 
                                            class="externallink", target="_blank")),
                                   
                                   p("2021/22 Social Care Technical Document:",
                                     tags$a(href="https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx",
                                            "https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx", 
                                            class="externallink", target="_blank")),
                                   
                                   p("2021/22 Social Care Definitions and Recording Guidance:",
                                     tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                            "Revised-Source-Dataset-Definitions-and-Recording-Guidance.pdf", 
                                            class="externallink", target="_blank")),                     
                                   
                                   p("2021/22 Social Care Balance of Care:",
                                     tags$a(href="https://publichealthscotland.scot/media/17825/2023-02-14-balance-of-care_updated.xlsm",
                                            "https://publichealthscotland.scot/media/17825/2023-02-14-balance-of-care_updated.xlsm", 
                                            class="externallink", target="_blank")),  
                                   
                                   p("Disclosure Control Information:",
                                     tags$a(href="https://publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
                                            "Statistical-Disclosure-Control-Protocol.pdf", 
                                            class="externallink", target="_blank")),
                                   
                                   ####
                                   
                                   p("2019/20 & 2020/21 Social Care Insights Publication:",
                                     tags$a(href="https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-201920-202021/",
                                            "https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-201920-202021/",
                                            class="externallink", target="_blank")),
                                   
                                   
                                   p("2019/20 & 2020/21 Social Care Technical Document:",
                                     tags$a(href="https://publichealthscotland.scot/media/13278/2022-04-26-social-care-technical-document.pdf",
                                            "Insights-in-Social-Care:Statistics-for-Scotland-2019/20-&-2020/21-Publication-Technical-Document.pdf",  
                                            class="externallink", target="_blank")),
                                   
                                   
                                   p("2019/20 & 2020/21 Social Care Balance of Care:",
                                     tags$a(href="https://publichealthscotland.scot/media/12910/2022-04-26-balance-of-care.xlsm",
                                            "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",  
                                            class="externallink", target="_blank")),
                                   
                                   p("2018/19 Social Care Insights Report:",
                                     tags$a(href="https://www.publichealthscotland.scot/media/4294/2020-09-29-social-care-report.pdf",
                                            "2020-09-29-Social-Care-Report.pdf", 
                                            class="externallink", target="_blank")),                                  
                                   
                                   p("2017/18 Social Care Insights Dashboard:",
                                     tags$a(href="https://scotland.shinyapps.io/nhs-social-care/",
                                            "www.scotland.shinyapps.io/nhs-social-care/",  
                                            class="externallink", target="_blank"))
                                   
                                   
                                   
                                   
                          ) # end resources tab
                          
                          ### closing brackets -----
                          
                        ) # info tab navlist panel left side of info close bracket
                        
                      ) # end info mainpanel 
             ), # end info tab across the top
             
             ##############################################-         
             #### Tab 3: People and Services Summary ----
             ##############################################-         
             tabPanel("People Supported",
                      
                      mainPanel(
                        width = 12,
                        
                        # Within this section we are going to have a sub tab column on the left
                        # To do this we are going to use the layout "navlistPanel()"
                        
                        navlistPanel(
                          id = "left_tabs_people_supp",
                          widths = c(2, 10),
                          
                          
                          ###################################-
                          #### Tab 3.1: PEOPLE SUPPORTED  ----
                          ###################################-
                          
                          tabPanel(
                            "People Supported",
                            h3("People Supported by Social Care Services"),
                            
                            
                            ### text ----
                            
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on people who receive social care services or support in Scotland as a rate per 1,000 Scottish Population, 
                              for a selected financial year. Information is presented by the Health and Social Care Partnership providing the services or support. These 
                              services and support include: care at home, care home, meals, community alarm/telecare, 
                              housing support, social worker and day care. People involved in choosing and 
                              controlling their support through",
                              tags$a(href = "https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/","self-directed support",
                                     target="_blank"),
                              "options are also included."),
                            
                            
                            # Measures
                            
                            tags$b("Measures"),
                            
                            p("The following measures can be selected:"),
                            
                            tags$ul(
                              tags$li("Rate per 1,000 Population"),
                              tags$li("Rate per 1,000 Population - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            
                            br(),
                            
                            ### dropdown ---- 
                            
                            wellPanel(
                              
                              ## select financial year
                              
                              column(6, shinyWidgets::pickerInput("client_summary_year_input",
                                                                  "Select Financial Year:",
                                                                  choices = unique(data_people_supported_summary$financial_year),
                                                                  selected = "2021/22"
                              )),
                              
                              ## select measure dropdown  - number of people / number of people (adjusted)
                              
                              column(6, shinyWidgets::pickerInput("client_summary_measure_input",
                                                                  "Select Measure:",
                                                                  choices = unique(data_people_supported_summary$measure),
                                                                  selected = "Rate per 1,000 Population" 
                              ))
                              
                            ), # end dropdown wellpanel
                            
                            ### buttons ----
                            
                            # panel including buttons and plot
                            
                            mainPanel(
                              width = 12,
                              
                              # show / hide data table 
                              
                              actionButton("Clients_button_1",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              downloadButton(
                                outputId = "download_clients_totals",
                                label = "Download data",
                                class = "my_clients_totals_button"
                              ),
                              tags$head(
                                tags$style(paste0(".my_clients_totals_button ", button_background_col,
                                                  ".my_clients_totals_button ", button_text_col, 
                                                  ".my_clients_totals_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              hidden(
                                div(
                                  id = "ClientsTotalsTable",
                                  DT::dataTableOutput("table_clients_totals")
                                )
                              ),
                              
                              ### plot ----
                              
                              plotlyOutput("ClientTotals",
                                           height = "800px", width = "auto"
                              ),
                              
                              br(),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              tags$ul(
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                                all the services and support reported on in this section; where possible an 
                                ‘estimated’ figure has been reported. Details of the estimated figure calculations can be found in the data quality tab." ),
                                tags$li("Financial year 2017/18 information was only available for the final quarter of the financial year for some services. 
                                        Please see data completeness tab for more details."),
                                tags$li("Please note that data completeness issues may affect interpretation of the data in some 
                                instances. Total figures presented here with estimates included will not match total count 
                                of submitted figures in other tabs."),
                                tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                support has not been included in the collection from April 2020. Therefore, the total count may 
                                not be directly comparable to previous years when both were considered mandatory data items."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank"))
                                
                              ),
                              
                              br()
                              
                            ) # end mainpanel
                          ), # end people supported tabpanel
                          
                          ##########################################-
                          #### Tab 3.2: TREND ----
                          ##########################################-
                          
                          tabPanel(
                            "Trend",
                            h3("People Supported by Social Care Services Trend"),
                            
                            ### text ----
                            
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on people who receive social care services or support in Scotland as a 
                              rate per 1,000 Scottish Population, during a selected financial year. Information is presented by the Health and Social Care Partnership providing the services or support. These 
                              services and support include: care at home, care home, meals, community alarm/telecare, 
                              housing support, social worker and day care. People involved in choosing and controlling 
                              their support through",
                              tags$a(href = "https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/","self-directed support",
                                     target="_blank"),
                              "options are also included."),
                            
                            # Measure
                            
                            tags$b("Measures"),
                            p("The following measures can be selected: "),
                            tags$ul(
                              tags$li("Rate per 1,000 Population"),
                              tags$li("Rate per 1,000 Population - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            
                            br(),
                            
                            ### dropdown ----
                            
                            ## dropdown wellpanel 1
                            
                            wellPanel(
                              
                              ## select main location of interest  
                              
                              column(6, shinyWidgets::pickerInput("client_trend_location_input",
                                                                  "Select Location:",
                                                                  #choices = unique(data_people_supported_summary$sending_location),
                                                                  choices = unique(data_people_supported_trend$sending_location),
                                                                  selected = "Scotland (All Areas Submitted)"
                              )),
                              
                              ## select comparison location
                              
                              column(6, shinyWidgets::pickerInput("client_trend_location_comparison_input",
                                                                  "Select Comparison Location:",
                                                                  #choices = unique(data_people_supported_summary$sending_location),
                                                                  choices = unique(data_people_supported_trend$sending_location),
                                                                  selected = "Scotland (All Areas Submitted)"
                              ))
                              
                            ), # end wellpanel 1
                            
                            ## dropdown wellpanel 2
                            
                            wellPanel(
                              
                              ## select measure dropdown  - number of people / number of people (adjusted)
                              
                              column(6, shinyWidgets::pickerInput("client_trend_measure_input",
                                                                  "Select Measure:",
                                                                  #choices = unique(data_people_supported_summary$measure),
                                                                  choices = unique(data_people_supported_trend$measure),
                                                                  selected = "Rate per 1,000 Population"
                              ))
                              
                            ), # end dropdown wellpanel 2
                            
                            
                            ### buttons ----
                            
                            
                            mainPanel(
                              width = 12,
                              
                              # show / hide data table 
                              
                              actionButton("Clients_trend_button_1",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              downloadButton(
                                outputId = "download_clients_trend",
                                label = "Download data",
                                class = "my_clients_trend_button"
                              ),
                              tags$head(
                                tags$style(paste0(".my_clients_trend_button ", button_background_col,
                                                  ".my_clients_trend_button ", button_text_col, 
                                                  ".my_clients_trend_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              
                              hidden(
                                div(
                                  id = "ClientsTrendTable",
                                  DT::dataTableOutput("table_clients_trend")
                                )
                              ),
                              
                              ### plot ----
                              
                              plotlyOutput("client_trend_plot_output",
                                           height = "550px"
                              ),
                              
                              br(),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              tags$ul(
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                
                                tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                                all the services and support reported on in this section; where possible an ‘estimated’ 
                                figure has been reported. Details of the estimated figure calculations can be found in the data quality tab."),
                                
                                tags$li("Financial year 2017/18 information was only available for the final quarter of the financial year for some services. 
                                        Please see data completeness tab for more details."),
                                tags$li("Please note that data completeness issues may affect interpretation of the data in 
                                some instances. Total figures presented here with estimates included will not match 
                                total count of submitted figures in other tabs."),
                                tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                support has not been in the collection from April 2020. Therefore, the total count may 
                                not be directly comparable to previous years when both were considered mandatory data items."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank"))
                              )
                            ), # end of main panel
                            
                            br()
                            
                            
                          ), # end people supported tabpanel
                          
                          ######################################-  
                          #### Tab 3.3: AGE & SEX ----
                          ######################################-  
                          tabPanel(
                            "Age and Sex",
                            h3("Age and Sex Summary"),
                            
                            ### text ----
                            
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on age group and sex of people who received social care services or support in Scotland. Information is presented as a rate per 1,000 social care clients."),
                            
                            # Measures
                            
                            tags$b("Measures"),
                            p("The following measures can be selected:"),
                            tags$ul(
                              tags$li("Rate per 1,000 Social Care Clients"),
                              tags$li("Rate per 1,000 Social Care Clients - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            
                            br(),
                            
                            
                            ### dropdown ---- 
                            
                            ### wellpanel 1
                            
                            wellPanel(
                              
                              ## select financial year
                              
                              column(6, shinyWidgets::pickerInput("clients_age_sex_year_input",
                                                                  "Select Financial Year:",
                                                                  choices = unique(data_people_supported_age_sex$financial_year),
                                                                  selected = "2021/22"
                              )),
                              
                              # select location dropdown
                              
                              column(6, shinyWidgets::pickerInput("clients_age_sex_location_input",
                                                                  "Select Location:",
                                                                  choices = unique(data_people_supported_age_sex$sending_location),
                                                                  selected = "Scotland (All Areas Submitted)"
                              ))
                              
                              
                            ), # end wellpanel 1
                            
                            ### welpanel 2
                            
                            wellPanel(
                              
                              # select measure dropdown 
                              
                              column(6, shinyWidgets::pickerInput("clients_age_sex_measure_input",
                                                                  "Select Measure:",
                                                                  choices = unique(data_people_supported_age_sex$measure),
                                                                  selected = "Rate per 1,000 People"
                              ))
                              
                            ), # end dropdown wellpanel 2
                            
                            
                            br(),
                            
                            ### buttons ----
                            
                            mainPanel(
                              width = 12,
                              
                              actionButton("Clients_button_2",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              # download data button
                              downloadButton(
                                outputId = "download_clients_agesex",
                                label = "Download data",
                                class = "my_clients_age_sex_button"
                              ),
                              
                              # style for download button
                              tags$head(
                                tags$style(paste0(".my_clients_age_sex_button ", button_background_col,
                                                  ".my_clients_age_sex_button ", button_text_col, 
                                                  ".my_clients_age_sex_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              hidden(
                                div(
                                  id = "ClientsAgeSexTable",
                                  DT::dataTableOutput("table_clients_agesex")
                                )
                              )
                              
                            ), # end button wellpanel
                            
                            ## add space before plot
                            
                            br(),
                            
                            ### plot ----
                            mainPanel(
                              width = 12,
                              plotlyOutput("Clientsagesex",
                                           height = "500px"),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              tags$ul(
                                
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                
                                tags$li("Due to missing age and sex records, the total number of individuals presented 
                                in this section may appear to be less than other totals presented throughout the 
                                dashboard."),
                                
                                tags$li("To reflect data completeness issues an 'All Areas Submitted' total is provided 
                                rather than a Scotland total. Please see data completeness tab for more details."),
                                
                                tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                support has not been included in the collection from April 2020. Therefore, the total count may 
                                not be directly comparable to previous years when both were considered mandatory data items."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank"))
                              )
                            ),
                            
                            br()
                            
                          ), # end age & sex tabpanel
                          
                          
                          
                          ##########################################-
                          #### Tab 6.4: ETHNICITY ----
                          ##########################################-
                          
                          tabPanel(
                            "Ethnic Group",
                            h3("Ethnic Group"),
                            
                            ### text ----
                            
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on the ethnicity of people who received social care services or support in Scotland. Information is presented as a rate per 1,000 social care clients."),
                            
                            # Measure
                            
                            tags$b("Measures"),
                            p("The following measures can be selected: "),
                            tags$ul(
                              tags$li("Rate per 1,000 Social Care Clients"),
                              tags$li("Rate per 1,000 Social Care Clients - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            br(),
                            
                            
                            mainPanel(
                              width = 12,
                              
                              ### dropdown ----
                              
                              # well panel 1
                              
                              wellPanel(
                                
                                # select year
                                column(6, shinyWidgets::pickerInput("client_ethnicity_year_input",
                                                                    "Select Financial Year:",
                                                                    choices = unique(data_people_supported_ethnicity$financial_year),
                                                                    selected = "2021/22"
                                )),
                                
                                # select location
                                column(6, shinyWidgets::pickerInput("client_ethnicity_location_input",
                                                                    "Select Location:",
                                                                    choices = unique(data_people_supported_ethnicity$sending_location),
                                                                    selected = "Scotland (All Areas Submitted)"
                                ))
                                
                              ), # end wellpanel 1
                              
                              # well panel 2       
                              
                              wellPanel(
                                
                                # age group dropdown
                                
                                column(6, shinyWidgets::pickerInput("client_ethnicity_age_input",
                                                                    "Select Age Group:",
                                                                    choices = unique(data_people_supported_ethnicity$age_group[
                                                                      data_people_supported_ethnicity$age_group != "Unknown"]),
                                                                    selected = "All Ages"
                                )),
                                
                                
                                
                                # select measure 
                                column(6, shinyWidgets::pickerInput("client_ethnicity_measure_input",
                                                                    "Select Measure:",
                                                                    choices = unique(data_people_supported_ethnicity$measure),
                                                                    selected = "Rate per 1,000 People"
                                ))
                                
                                
                              ), # end dropdown wellpanel 2
                              
                              
                              br(),
                              
                              
                              ### buttons ----
                              
                              mainPanel(
                                width = 12,
                                
                                actionButton("Clients_button_ethnicity",
                                             "Show/hide table",
                                             style = button_style_showhide
                                ),
                                
                                
                                downloadButton(
                                  outputId = "download_clients_ethnicity",
                                  label = "Download data",
                                  class = "my_clients_ethnicity_button"
                                ),
                                tags$head(
                                  tags$style(paste0(".my_clients_ethnicity_button ", button_background_col,
                                                    ".my_clients_ethnicity_button ", button_text_col, 
                                                    ".my_clients_ethnicity_button ", button_border_col)
                                  )
                                ),
                                
                                
                                ### data table -----
                                
                                hidden(
                                  div(
                                    id = "ClientsEthnicityTable",
                                    DT::dataTableOutput("table_clients_ethnicity")
                                  )
                                ),
                                
                                
                                ### plot ----
                                
                                plotlyOutput("Clients_ethnicity_plot",
                                             height = "600px"),
                                
                                br(),
                                br(),
                                
                                ### data notes -----
                                
                                tags$b("Notes"),
                                tags$ul(
                                  
                                  
                                  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                  
                                  tags$li("Figures presented here are based on all records where ethnicity information was provided (67.11% of records for 2021/22)."),
                                  
                                  tags$li("To reflect data completeness issues a Scotland ‘All Areas Submitted’ is 
                                          provided. Please see the data completeness tab for more details."),
                                  
                                  tags$li("Please note in previous publications some ethnic groups were combined under the category “Other”. 
                                          These ethnic groups are no longer combined therefore figures presented here may not be directly comparable 
                                          with previously published figures."),
                                  
                                  tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                          support has not been included in the collection from April 2020. Therefore, the total count may 
                                          not be directly comparable to previous years when both were considered mandatory data items."),
                                  
                                  tags$li("It should be noted that for financial year 2017/18 information was only 
                                          available for the final quarter of the financial year for some services. Please 
                                          see the information tab for more details."),
                                  
                                  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                                 "Statistical Disclosure Control Protocol.", 
                                                 target="_blank"))
                                  
                                ),
                                
                                br()
                                
                              )
                              
                            )
                          ), # end ethnicity tabpanel
                          
                          ############################################-
                          #### Tab 6.5: CLIENT GROUP ----
                          ############################################-
                          
                          tabPanel(
                            "Social Care Client Group",
                            h3("Social Care Client Group"),
                            
                            ### text ---- 
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on people who received social care services or support in Scotland 
                              as a rate per 1,000 social care clients by Client Group.  Information is presented by the Health and Social Care Partnership providing the services or support."),
                            
                            
                            p("The Client Group or Service User Group an individual is assigned to is determined 
                              by a Social Worker or Social Care Professional and is used as a means of grouping individuals 
                              with similar care needs. An individual can be assigned to more than one Client Group.  
                              The category 'Other' within Client Group includes Drugs, Alcohol, Palliative Care, Carer, 
                              Neurological condition (excluding Dementia), Autism and Other Vulnerable Groups."),
                            
                            # Measure
                            
                            tags$b("Measures"),
                            p("The following measures can be selected: "),
                            tags$ul(
                              tags$li("Rate per 1,000 Social Care Clients"),
                              tags$li("Rate per 1,000 Social Care Clients - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            #p("There is a proposal for future publications not to include an update of the adjusted figures. Please see the introduction for more information and how to provide feedback."),
                            
                            br(),
                            
                            ### dropdown ----
                            
                            # well panel 1
                            wellPanel(
                              
                              # year dropdown
                              
                              column(6, shinyWidgets::pickerInput("client_group_year_input",
                                                                  "Select Financial Year:",
                                                                  choices = unique(data_people_supported_client_group$financial_year),
                                                                  selected = "2021/22")),
                              
                              # location dropdown
                              
                              column(6, shinyWidgets::pickerInput("client_group_location_input",
                                                                  "Select Location:",
                                                                  choices = unique(data_people_supported_client_group$sending_location),
                                                                  selected = "Scotland (All Areas Submitted)"
                              ))
                              
                            ),
                            
                            # well panel 2       
                            
                            wellPanel(     
                              # age dropdown 
                              column(6, shinyWidgets::pickerInput("client_group_age_input",
                                                                  "Select Age Group:",
                                                                  choices = unique(data_people_supported_client_group$age_group[
                                                                    data_people_supported_client_group$age_group != "Unknown"]),
                                                                  selected = "All Ages")),
                              
                              # measure dropdown
                              column(6, shinyWidgets::pickerInput("client_group_measure_input",
                                                                  "Select Measure:",
                                                                  choices = unique(data_people_supported_client_group$measure),
                                                                  selected = "Rate per 1,000 People"
                              ))
                            ), # end dropdown wellpanel
                            
                            
                            ### buttons ----
                            
                            mainPanel(
                              width = 12,
                              
                              ## show / hide table & download data buttons
                              
                              actionButton("Client_group_button",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              downloadButton(
                                outputId = "download_clients_client_group",
                                label = "Download data",
                                class = "my_clients_client_type_button"
                              ),
                              
                              tags$head(
                                tags$style(paste0(".my_clients_client_type_button ", button_background_col,
                                                  ".my_clients_client_type_button ", button_text_col, 
                                                  ".my_clients_client_type_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              
                              hidden(
                                div(
                                  id = "ClientsClientTypeTable",
                                  DT::dataTableOutput("table_clients_client_type")
                                )
                              ),
                              
                              
                              ### plot ----
                              
                              plotlyOutput("Clientsclienttype",
                                           height = "600px"),
                              br(),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              tags$ul(
                                
                                
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                
                                
                                tags$li("Figures across client groups cannot be added together to give an overall total as the 
                                        same individual can appear in multiple client groups."),
                                
                                tags$li("HSCPs have advised of the variation in recording client group. Some are able to record numerous 
                                        groups for each individual, however other areas are only able to record one primary client group for each individual."),
                                
                                tags$li("Where a client did not have a client group assigned this is included in the group “Not Recorded”.  
                                        This accounts for 24.2% of all client group, all ages records for 2021/22."),
                                
                                tags$li("To reflect data completeness issues an 'All Areas Submitted' total is provided rather than a Scotland total.  
                                        Please see data completeness tab for more details."),
                                
                                tags$li("It should be noted that for financial year 2017/18 information was only available for the final quarter of the 
                                        financial year for some services. Please see the information tab for more details."),
                                
                                tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                  support has not been included in the collection from April 2020, therefore the total count may 
                                  not be directly comparable to previous years when both were considered mandatory data items."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank")
                                )
                              ),
                              br()
                              
                            ) # end buttons and plot mainpanel
                          ), # end client group tabpanel
                          
                          #######################################-
                          #### Tab 6.5: SUPPORT & SERVICES ----
                          #######################################-
                          tabPanel(
                            "Support and Services",
                            h3("Social Care Support and Services"),
                            
                            ### text ----
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on people who received a meals service at any point 
                              during the reporting period in Scotland as a rate per 1,000 social care clients."),
                            
                            br(),
                            
                            ### dropdowns ----
                            
                            ## wellpanel 1
                            
                            wellPanel(
                              
                              # select year 
                              column(6, shinyWidgets::pickerInput("client_service_year_input",
                                                                  "Select Financial Year:",
                                                                  choices = unique(data_people_supported_services$financial_year),
                                                                  selected = "2021/22"
                              )),
                              
                              column(6, shinyWidgets::pickerInput("client_service_location_input",
                                                                  "Select Location:",
                                                                  choices = unique(data_people_supported_services$sending_location),
                                                                  selected = "Scotland (All Areas Submitted)"
                              ))),
                            
                            ## WellPanel 2
                            
                            wellPanel(
                              
                              # age group
                              column(6, shinyWidgets::pickerInput("client_service_age_input",
                                                                  "Select Age Group:",
                                                                  choices = unique(data_people_supported_services$age_group),
                                                                  selected = "All Ages"
                              ))),
                            
                            
                            
                            
                            ### buttons ----
                            
                            mainPanel(
                              width = 12,
                              
                              
                              actionButton("Clients_services_action_button",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              downloadButton(
                                outputId = "download_clients_services",
                                label = "Download data",
                                class = "my_clients_summary_button"
                              ),
                              tags$head(
                                tags$style(paste0(".my_clients_summary_button ", button_background_col,
                                                  ".my_clients_summary_button ", button_text_col, 
                                                  ".my_clients_summary_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              
                              hidden(
                                div(
                                  id = "ClientsServicesTable",
                                  DT::dataTableOutput("table_clients_services")
                                )
                              ),
                              
                              
                              ### plot ---- 
                              
                              plotlyOutput("client_support_services",
                                           height = "600px"),
                              
                              br(),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              
                              tags$ul(
                                
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                
                                tags$li("To reflect data completeness issues an 'All Areas Submitted' total is provided rather than a Scotland total.  
                                        Please see data completeness tab for more details."),
                                
                                tags$li("It should be noted that for financial year 2017/18 information was only available for the final quarter 
                                        of the financial year for some services. Please see the information tab for more details."),
                                
                                tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                  support has not been included in the collection from April 2020, therefore the total count may 
                                  not be directly comparable to previous years when both were considered mandatory data items."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank"))
                              ),
                              
                              br()
                              
                              
                              
                            ) # end mainpanel
                            
                          ), # end tabpanel
                          
                          ###############################-
                          ## Tab 6.6 MEALS  ----
                          ###############################-
                          
                          tabPanel(
                            "Meals",
                            h3("Meals"),
                            
                            ### text -----
                            
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("The chart below presents information on people who receive a meals service at any point during the reporting period in Scotland as a rate per 1,000 social care clients. "),
                            
                            # Measure
                            
                            tags$b("Measures"),
                            p("The following measures can be selected: "),
                            tags$ul(
                              tags$li("Rate per 1,000 Social Care Clients"),
                              tags$li("Rate per 1,000 Social Care Clients - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            #p("There is a proposal for future publications not to include an update of the adjusted figures. Please see the introduction for more information and how to provide feedback."),
                            
                            br(),
                            
                            ### dropdowns ----
                            
                            wellPanel(
                              
                              # year 
                              column(6, shinyWidgets::pickerInput("client_meals_year_input",
                                                                  "Select Financial Year:",
                                                                  choices = unique(data_people_supported_meals$financial_year),
                                                                  selected = "2021/22"
                              )),
                              
                              
                              # location
                              column(6, shinyWidgets::pickerInput("client_meals_location_input",
                                                                  "Select Location:",
                                                                  choices = unique(data_people_supported_meals$sending_location),
                                                                  selected = "Scotland (All Areas Submitted)"            
                              )),
                              
                              
                              # measure
                              column(6, shinyWidgets::pickerInput("client_meals_measure_input",
                                                                  "Select Measure:",
                                                                  choices = unique(data_people_supported_meals$measure),
                                                                  selected = "Rate per 1,000 People"           
                              ))
                              
                              
                            ),
                            br(),
                            
                            ### buttons ----
                            
                            mainPanel(
                              width = 12,
                              
                              actionButton("client_meals_table_button",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              downloadButton(
                                outputId = "download_clients_meals",
                                label = "Download data",
                                class = "my_clients_meals_button"
                              ),
                              tags$head(
                                tags$style(paste0(".my_clients_meals_button ", button_background_col,
                                                  ".my_clients_meals_button ", button_text_col, 
                                                  ".my_clients_meals_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              
                              hidden(
                                div(
                                  id = "ClientsMealsTable",
                                  DT::dataTableOutput("table_client_meals"))
                              ),
                              
                              ### plot ---- 
                              plotlyOutput("meals_plot_output",
                                           height = "500px"),
                              
                              br(),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              tags$ul(
                                
                                
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                
                                tags$li("To reflect data completeness issues an 'All Areas Submitted' total is provided rather than a Scotland total.
                                        Please see data completeness tab for more details."),
                                
                                tags$li("It should be noted that for financial year 2017/18 information was only available for the final quarter 
                                        of the financial year for some services. Please see the information tab for more details."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank"))
                              ),
                              
                              br()
                              
                            ) # end mainpanel
                          ), # end meals tabpanel
                          
                          ###############################-
                          ## Tab 6.7 LIVING ALONE ----
                          ###############################-
                          
                          tabPanel(
                            "Living Alone",
                            h3("Living Alone"),
                            
                            ### text ----
                            
                            p("PHS have proposed changes to the analysis in this section, please see the Introduction tab for further details."),
                            
                            p("This chart presents the percentage of social care clients that live alone. Data can be 
                              viewed for financial years 2017/18 – 2021/22."),
                            
                            # Measure
                            
                            tags$b("Measures"),
                            p("The following measures can be selected: "),
                            tags$ul(
                              tags$li("Percentage of Social Care Clients"),
                              tags$li("Percentage of Social Care Clients - adjusted (allows comparison with the ", 
                                      tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", "Scottish Government Social Care Survey"),
                                      ").")
                            ),
                            
                            p("Number of people is also provided within the table and download data function."),
                            
                            p("Please note, when adjusted is selected the services included in the count differ from above in that it only includes home care census, 
                              meals, community alarm/telecare, housing support and social worker. 
                              People involved in choosing and controlling their support through self-directed support options are also included."),
                            
                            
                            br(),
                            
                            ### dropdowns ----
                            
                            wellPanel(
                              
                              # year 
                              column(6, shinyWidgets::pickerInput("client_living_alone_year_input",
                                                                  "Select Financial Year:",
                                                                  choices = unique(data_people_supported_living_alone$financial_year),
                                                                  selected = "2021/22"
                              )),
                              
                              # age 
                              column(6, shinyWidgets::pickerInput("client_living_alone_age_input",
                                                                  "Select Age Group:",
                                                                  choices = unique(data_people_supported_living_alone$age_group[
                                                                    data_people_supported_living_alone$age_group != "Unknown"]),
                                                                  selected = "All Ages"           
                              )) ,
                              
                              # measure
                              column(6, shinyWidgets::pickerInput("client_living_alone_measure_input",
                                                                  "Select Measure:",
                                                                  choices = unique(data_people_supported_living_alone$measure),
                                                                  selected = "Rate per 1,000 Population"           
                              ))
                              
                              
                            ),
                            br(),
                            
                            ### buttons ----
                            
                            mainPanel(
                              width = 12,
                              
                              actionButton("client_living_alone_table_button",
                                           "Show/hide table",
                                           style = button_style_showhide
                              ),
                              
                              downloadButton(
                                outputId = "download_clients_living_alone",
                                label = "Download data",
                                class = "my_clients_living_alone_button"
                              ),
                              tags$head(
                                tags$style(paste0(".my_clients_living_alone_button ", button_background_col,
                                                  ".my_clients_living_alone_button ", button_text_col, 
                                                  ".my_clients_living_alone_button ", button_border_col)
                                )
                              ),
                              
                              ### data table ----
                              hidden(
                                div(
                                  id = "client_living_alone_table",
                                  DT::dataTableOutput("table_client_living_alone"))
                              ),
                              
                              ### plot ---- 
                              plotlyOutput("living_alone_plot",
                                           height = "800px"),
                              
                              br(),
                              br(),
                              
                              ### data notes ----
                              
                              tags$b("Notes"),
                              tags$ul(
                                
                                
                                tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
                                tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
                                
                                tags$li("To reflect data completeness issues an 'All Areas Submitted' total is provided rather than a Scotland total.  
                                        Please see data completeness tab for more details."),
                                
                                tags$li("It should be noted that for financial year 2017/18 information was only available for the final quarter of the financial year 
                                        for some services. Please see the information tab for more details."),
                                
                                tags$li("Please note Social Worker became an optional data item in 2019/20, in addition housing 
                                  support has not been included in the collection from April 2020. Therefore, the total count may 
                                  not be directly comparable to previous years when both were considered mandatory data items."),
                                
                                tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
                                        Therefore, the figures presented here may not be additive and may differ from previous 
                                        publications. For further guidance see Public Health Scotland's",
                                        tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                               "Statistical Disclosure Control Protocol.", 
                                               target="_blank"))
                                
                              ),
                              br()
                              
                            ) # end mainpanel
                          ) # end living alone tabpanel
                        )
                      )
             ),
             
             
             ###############################-
             ## DATA COMPLETENESS TAB ----
             ###############################-
             
             
             tabPanel("Data Completeness",
                      mainPanel(width = 12,
                                h2("Data Completeness"),
                                
                                p("The data completeness table below presents the completeness for each Health and Social Care Partnership and time period presented.  Data can be sorted based on the headings of each column in the table below.  
                                  Please click on the column headings to sort the data either alphabetically (a-z / z-a) or numberically (ascending / descending)"),
                                
                                tags$b("Disclosure Control"),
                                p("Statistical disclosure control has been applied to protect patient confidentiality. Therefore, the figures presented here may not be additive and may differ from previous publications. For further 
                                     guidance see Public Health Scotland's",
                                  tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                         "Statistical Disclosure Control Protocol.",
                                         target="_blank")),
                                
                                tags$b("Data Sources"),
                                p(" ",
                                  tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                         "Source Social Care Data",
                                         target="_blank")," "),
                                
                                p("Within trend analysis missing data are populated using previous years data however all other breakdowns will show submitted data only."),
                                
                                br(),
                                
                                wellPanel(
                                  column(6,
                                         pickerInput("data_completeness_hscp",
                                                     "Select Health and Social Care Partnership:",
                                                     choices = c("All HSCPs",
                                                                 sort(unique(data_completeness_table$`Health and Social Care Partnership`))))),
                                  
                                  column(6,
                                         pickerInput("data_completeness_year",
                                                     "Select Financial Year:",
                                                     choices = c("All Financial Years",
                                                                 unique(data_completeness_table$`Financial Year`))))),
                                
                                br(),
                                
                                column(12,
                                       tags$b("People Supported by Social Care Services Data Completeness Table")),
                                
                                DT::dataTableOutput("data_completeness_table"),
                                
                                br()
                                
                                
                      )
                      
             ), # close data completeness tab
             
             
             ###############################-
             ## DATA QUALITY TAB ----
             ###############################-
             
             
             tabPanel("Data Quality",
                      mainPanel(width = 12,
                                h2("Data Quality"),
                                
                                p("The Data Quality table below provides high level data quality information 
                                  to aid interpretation of the data presented in the People supported tab for 
                                  each Health and Social Care Partnership and time period presented.  
                                  Data can be sorted based on the headings of each column in the table below.  
                                  Please click on the column headings to sort the data either alphabetically (a-z / z-a) or numberically (ascending / descending)."),
                                
                                br(),
                                
                                wellPanel(
                                  column(6, 
                                         shinyWidgets::pickerInput("client_data_quality_location_input",
                                                                   "Select HSCP:",
                                                                   choices = c("All HSCPs",
                                                                               sort(unique(data_quality_table$`Health and Social Care Partnership`))),
                                                                   selected = "All HSCPs"           
                                         )),
                                  
                                  column(6,
                                         shinyWidgets::pickerInput("client_data_quality_financial_year_input",
                                                                   "Select Year: ",
                                                                   choices = c("All Financial Years",unique(data_quality_table$`Financial Year`)),
                                                                   selected = "All Financial Years"))
                                ),
                                
                                column(12,
                                       tags$b("People Supported by Social Care Services Data Quality Table")),
                                DT::dataTableOutput("data_quality_table"),
                                
                                br()
                                
                      )
                      
             ) # close data quality tab
             
             ####################################################-
             ### closing brackets people and services summary
             ####################################################-
             
             
             
             ##### app closing brackets ----
             
  ) # end tabsetpanel list (Tabs across top of dashboard  (Intro, People & Support, Info))
  
  
  
) # end fluidpage

#) # end secure_app function for password protect PRA
# comment out if not password protecting for PRA

####################################################