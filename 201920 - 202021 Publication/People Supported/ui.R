################################################################
### UI
### Social Care Insights: People & Services Shiny app
###
### Original Author: Jenny Armstrong
### Original Date: June 2020
###
### Written to be run on RStudio Server
###
### This script creates the user interface of the
### People & Services Shiny app
###
###############################################.


##########################
## password protect PRA ##
#shinymanager::secure_app( # comment out if not required 
##########################
 
###############################
# Define UI for application
###############################

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
             
             ###############################
             #### Tab 1: Introduction ----   
             ###############################
             
             tabPanel("Introduction", 
                      
                wellPanel(
                        column(4, h3("Social Care Data Insights Dashboard - People and Services")),
                        column(8,
                               tags$br(),
                               p("Social care is provided to people to meet a diverse range of support needs and there 
                                 are choices about how this support is delivered. The information recorded about the 
                                 people receiving social care in its various forms contributes to understanding that 
                                 diversity. This section provides a summary or numbers and rates of people receiving 
                                 a variety of difference social care support and service types."),
                               br(),
                               p("This Dashboard has two additional tabs which can be selected: “Information” and 
                                 “People Supported”. Please click on “People Supported” tab to see the different 
                                 analyses available. For more information on data definitions and guidance on the 
                                 information presented in this dashboard please click the Information tab."),
                               br(),
                               p(strong("Effects of COVID-19 on figures"),
                                 "The measures put in place to respond to COVID-19 pandemic will have affected the 
                                  services that the HSCPs were able to provide over the period of the pandemic.  
                                  Differences in data from previous years are likely to be affected by ability of 
                                  HSCPs to provide social care services while dealing with the impact of the pandemic."),
                               br(),
                               p("Statistical disclosure control has been applied to protect patient confidentiality. 
                                  Therefore, the figures presented here may not be additive and may differ from previous 
                                  publications. For further guidance see Public Health Scotland's",
                                 tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                        "Statistical Disclosure Control Protocol."),
                                 br(),
                             p("If you experience any problems using this dashboard or have",
                                   "further questions relating to the data, please contact", 
                                   "us at: ",
                                   tags$b(tags$a(
                                     href = "mailto:phs.source@phs.scot",
                                     "phs.source@phs.scot")),
                                   ".")
                               )
                        )
                      ) # end wellPanel
             ), # end intro tabpanel
             ############################
             #### Tab 2: Information ----
             ############################
             
             tabPanel("Information", 
                      icon = icon("info-circle"),
                      mainPanel(
                        width = 12,
                        
                        
                        navlistPanel(
                          id = "left_tabs_info",
                          widths = c(2, 10),
                          
                          
                          ### Accessibility -----
                          
                          tabPanel("Accessibility",    
                                   h2("Accessibility Statement"),
                                   
                                   p("This website is run by", 
                                     tags$a(href = "https://www.publichealthscotland.scot/", "Public Health Scotland"),
                                     ". Scotland’s national organisation for public health."),
                                   
                                   p("As a new organisation formed on 1 April 2020, Public Health Scotland is reviewing 
                                     its web estate - including this website - aligned to corporate strategic and transformation plans."),
                                   
                                   p(tags$a(href = "https://abilitynet.org.uk/", "AbilityNet"),"has advice on making your device easier
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
                                   
                                   
                                   p("Commentary and further background information on the analyses presented in this dashboard can be found in the accompanying",
                                     tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                                            "Technical Document.")),
                                   
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
                                     of the analyses includes data on remote monitoring, home care and care homes.
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
                                     Data on care and support that is paid for and organised entirely by people themselves
                                     (i.e. “self-funded”) are not available and are excluded from all the analyses."),
                                   
                                     p(
                                       "Due to the differences in the data collected for the",
                                       tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                                              "Social Care Survey"),
                                    "and the Source Social Care Data collection an ‘adjusted’ figure is also provided in the dashboard 
                                     for the number of people to allow trend information to be presented and a reliable
                                     comparison to be made between the two different data collections. The ‘adjusted’ 
                                     figure has been created by:"),
                                   tags$ul(
                                     tags$li("Excluding people where the only information available was that they were supported in a care home "),
                                     tags$li("Excluding people who only received day care"),
                                     tags$li("Excluding people who only received home care who did not receive home care in the ‘census week’")
                                   ),
                                   
                                   tags$b("Data Sources"),
                                   p(" ",
                                     tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                            "Source Social Care Data")," ")
                                   ),
                          
                          ### Definitions ----
                          
                          tabPanel("Definitions", 
                                   h2("Data Definitions"),
                                   
                                   p("The Source data definitions and guidance document can be found",
                                     tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                            "here.", class="externallink")), 
                                   p("This provides detailed information on Data Definitions used across all of the Social Care Insights Dashboards.
                                     Data Definitions relating specifically to the data presented throughout the People and Services Dashboard can be found below."),
                                   
                                   tags$b("Methodology"),
                                   p("The information provided below on the methods and definitions that have been used throughout this dashboard should
                                     be used to assist with interpretation of the results presented."),  
                                   
                                   tags$b("Data Sources"),
                                   p(" ",
                                     tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                            "Source Social Care Data")," "),
                                   
                                   tags$b("Financial Year"),
                                   p("Data in this dashboard is available for financial years 2017/18 and 2020/21. 
                                      A financial year covers the time period from the 1 April to the 31 March in the following year."),
                                   p(
                                     "Where trend information is presented in this dashboard, this includes data previously 
                          published by the Scottish Government in the Social Care Survey. 
                          Data ranging from 2015/16 to 2016/17 has been obtained from",
                                     tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                                            "the Scottish Government Website.")
                                   ),
                                   
                                   tags$b("People Supported by Social Care Services and Support"),
                                    p("If a person received services/support from more than one Health and Social Care Partnership during the reporting period, they will be counted for each partnership.
                                     For trend analyses, missing information has been estimated by using figures from previous year where possible or 2016/17 figures from the Social Care Survey published by the Scottish Government.
                                     "),
                                   
                                   p("If someone received more than one social care support service in a selected financial year,
                                     they are only counted once in the total number of people receiving social care services/support.
                                     In order to create a national figure, where data is missing an estimated figure has been calculated (see section on estimations and calculations below)."),
                                   
                                   tags$b("Demographic Information"),
                                   p("Demographic information presented here includes details on an individual's age, sex and ethnic group.
                                     When demographic information is matched to service data the latest record is selected. 
                                     As a result, some outputs here may differ from previously published figures."),
                                   
                                   tags$b("Client Group"),
                                   p("The client/service user group(s) is determined by a social worker or other health and social
                                     care professional. People may be recorded in more than one client group
                                     therefore the individual client group categories cannot be added together to obtain a total number of people."),
                                   
                                   tags$b("Home Care"),
                                   p("Home care is defined as the practical services which assist the service user to function as
                                     independently as possible and/or continue to live in their own home. 
                                     Home care can include routine household tasks such as basic housework, shopping, laundry, paying bills etc."),
                             
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
                                   p("A community alarm is a form of equipment for communication, especially useful as an alert should the user have an incident where they require to call for help quickly. Typically, it includes a button/pull cord/pendant which transfers an alert/alarm/data to a monitoring centre or individual responder.
                                     It can be used within an individual’s own home or part of a communal system."),
                            
                                   tags$b("Telecare"),
                                   p("Telecare refers to a technology package which goes over and above 
                                     the basic community alarm package. It is the remote or enhanced delivery of care services
                                     to people in their own home by means of telecommunications and computerised services.
                                     Telecare usually refers to sensors or alerts which provide continuous, automatic and
                                     remote monitoring of care needs emergencies and lifestyle using information and communication
                                     technology to trigger human responses or shut down equipment to prevent
                                     hazards (Source:",
                                     tags$a(href = "https://www.tec.scot/", 
                                            "National Telecare Development Programme, Scottish Government"),")."
                                   ),
                           
                                   tags$b("Day Care"),
                                   p("Day care involves attendance at a location other than the
                                     client or service user's own home for personal, social, therapeutic, training or leisure purposes."),
                         
                                   tags$b("Housing Support"),
                                   p("Housing Support services help people to live as independently as possible in the community. These services 
                                     help people manage their home in different ways. These include assistance to claim welfare benefits, fill in 
                                     forms, manage a household budget, keep safe and secure, get help from other specialist services, obtain 
                                     furniture and furnishings and help with shopping and housework. The type of support that is provided will 
                                     aim to meet the specific needs of the client/service user. From April 2020 this item was no longer part of 
                                     the social care collection however some partnerships chose to still submit this information. If provided 
                                     such people have been included in the total client count but not shown under the service breakdown."),
                         
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
                                  at the midpoint of the financial year, for example in 2020/21, age is
                                  calculated at 30 September 2020."),
                                     tags$li("Age group breakdowns are available for some analysis in this dashboard.
                                  Where available the options will include: 0-17, 18-64, 65-74, 75-84, 85+, Unknown and All Ages.
                                  Please note, not all analyses will include the age group '0-17 years' due to small numbers.")
                                   ),
                                   
                                   tags$b("Number of People Measure"),
                                   p("The number of people supported in Scotland during each financial year is a unique count of 
                                      the total number of people for all social care services and support collected by Public Health 
                                      Scotland (home care, care home, community alarms/telecare, meals, day care, social worker and housing support). 
                                      People involved in choosing and controlling their support through self-direct support options are also included."),
                                   
                                   tags$b("Rate per 1,000 Population Measure"),
                                   p("The rate per 1,000 population is rate of people who receive social care support and / or services in Scotland during 
                                     each financial year against the Scottish population. E.g. Numerator is the total count of peole who receive support and 
                                     services through social care. The denominator is the Scottish population."),
                                   
                                   tags$b("Rate per 1,000 People Measure"),
                                   p("The rate per 1,000 people is rate of people who receive a specific type of social care support and / or service in 
                                          Scotland during each financial year against total number of social care clients. E.g. Numerator is total number of 
                                          people receiving a specific social care service, such as home care.  The denominator is the total count of people 
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
                                     tags$li("Excluding people who only received home care who did not receive home care in the ‘census week’.")
                                   ),
                                   
                                   tags$b("Estimates (People Supported and Trend Tabs only)"),
                                   p("As some partnerships were unable to provide individual level information for specific topics
                                     (summarised below) estimates have been used to create top level Scotland figures for trends."),
                                   p("The percentages applied to create the estimates have been calculated using
                                     Scotland level (all areas submitted) data. These percentages represent the percentage
                                     of clients receiving these services only."),

                                   
                                   p("To account for the missing data for partnerships, 
                                      the counts of the total number of people supported (where information was available) 
                                     were adjusted by the percentage indicated in the table (source social care column) 
                                     to produce an estimated total number of people supported.
                                     For example, South Lanarkshire was estimated to be missing 18.2% of the number people supported due to community alarms / telecare information not being provided. The estimated calculation (where 8,730 represents the number of people supported minus community alarms/telecare) is:
                                     number of people supported  (8,730) / (100-17.4)*100 = 10,569.
                                     The calculation was repeated for each combination in the table. The figures were then summed to create a Scotland figure.
                                     "),
                                   
                                   p("A similar process was undertaken to create an adjusted figure for 
                                     comparison with the Social Care Survey. For more information, please refer to the accompanying",
                                     tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                                            "Technical Document."))
                                   
                                   ),
                          
                          
                          ### Data Completeness dropdown tab  ----
                          
                          tabPanel("Data Completeness",
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
                                   
                                   p("Within trend analysis missing data is populated using previous years data however all other breakdowns will show submitted data only.”"),

                                   tags$b("People Supported by Social Care Services Data Completeness Table"),
                                    DT::dataTableOutput("data_completeness_table"),
                                   
                                   br()

                                   ),
                          
                          ### Resources dropdown tab  ----
                          
                          tabPanel("Resources", 
                                   h2("Resources"),
                                   
                                   p("2018/19 Social Care Insights Report:",
                                     tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                            "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", class="externallink")),
                                   
                                   p("2018/19 Social Care Technical Document:",
                                     tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                            "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", class="externallink")),
                                   
                                   p("Social Care Definitions and Recording Guidance:",
                                     tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                            "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",  class="externallink")),
                                   
                                   p("Scottish Government Social Care Survey:",
                                     tags$a(href="https://www.gov.scot/publications/social-care-services-scotland-2017/",
                                            "www.gov.scot/publications/social-care-services-scotland-2017/", class="externallink")),
                                   
                                   p("Social Care Balance of Care:",
                                     tags$a(href= "https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-201920-202021/",
                                            "https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-201920-202021/",  class="externallink")),

                                   p("Disclosure Control Information:",
                                     tags$a(href="https://publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
                                            "www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",class="externallink")),
                                   
                                   p("2017/18 Social Care Insights Dashboard:",
                                     tags$a(href="https://scotland.shinyapps.io/nhs-social-care/",
                                            "www.scotland.shinyapps.io/nhs-social-care/",  class="externallink")),
                                   
                                   p("Home Care Background Information:",
                                     tags$a(href="https://www.gov.scot/publications/national-care-standards-care-home/pages/1/",
                                            "National Care Standards - Care at Home", class="externallink")),
                                   
                      
                                   p("Personal Care Information:",
                                     tags$a(href="https://www.gov.scot/policies/social-care/social-care-support/#free%20care",
                                            "www.gov.scot/policies/social-care/social-care-support/freecare",  class="externallink")),
                                   
                                   p("Community Alarms and Telecare Information:",
                                     tags$a(href="https://www.tec.scot",
                                            "www.tec.scot",   class="externallink")),
                                   
                                   p("Scotland’s Digital Health Care Strategy:",
                                     tags$a(href=" https://www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",
                                            "www.gov.scot/publications/scotlands-digital-health-care-strategy-enabling-connecting-empowering/",   class="externallink")),
                                   
                                   p("Self-directed Support Strategy:",
                                     tags$a(href="https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/",
                                            "www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/", class="externallink")),
                                   
                                   p("Indicator of Relative Need (ioRN) Information:",
                                     tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
                                            "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",    class="externallink"))

                                   
                                   
                          ) # end resources tab
                          
                  ### closing brackets -----
                          
                                   ) # info tab navlist panel left side of info close bracket
                        
                                   ) # end info mainpanel 
             ), # end info tab across the top
                      
    ##############################################         
    #### Tab 3: People and Services Summary ----
    ##############################################         
             tabPanel("People Supported",
                      
                      mainPanel(
                        width = 12,
                        
              # Within this section we are going to have a sub tab column on the left
              # To do this we are going to use the layout "navlistPanel()"
                        
               navlistPanel(
                          id = "left_tabs_people_supp",
                          widths = c(2, 10),
                      
                        
    ###################################
    #### Tab 3.1: People Supported  ----
    ###################################
    
      tabPanel(
        "People Supported",
        h3("People Supported by Social Care Services"),
        
        
        ### Text ----
        
        p("The chart below presents information on the Rate per 1,000 Population of people 
          who received social care services or support in Scotland, during a selected financial 
          year and by the Health and Social Care Partnership providing this support. These 
          services and support include: home care, care home, meals, community alarm/telecare, 
          housing support, social worker and day care. People involved in choosing and 
          controlling their support through",
          tags$a(href = "https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/","self-directed support"),
          "options are also included."),

        tags$b("Measures"),
        p("The following measures can be selected:"),
        tags$ul(
          tags$li("Rate per 1,000 Population"),
          tags$li("Rate per 1,000 Population – adjusted (allows comparison with the",
                  tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                         "Scottish Government Social Care Survey"),").")
        ),
        p("Number of people is also provided within the table and download data function."),
        
        p("Please note, when adjusted is selected the services included in the count differ 
          from above in that it  only includes home care census, meals, community alarm/telecare, 
          housing support and social worker. People involved in choosing and controlling their 
          support through self-directed support options are also included."),
        
        tags$b("Data Completeness"),
        tags$ul(
          tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                  all the services and support reported on in this section; where possible an 
                  ‘estimated’ figure has been reported. Details of the estimated figure calculations 
                  can be found in the Information tab and the methodology section of the",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document.")),
          tags$li("It should be noted that for financial year 2017/18 information was only available 
                  for the final quarter of the financial year for some services. Please see the 
                  Information tab for more details."),
          tags$li("Please note that data completeness issues may affect interpretation of the data in some 
                  instances. Total figures presented here with estimates included will not match total count 
                  of submitted figures in other tabs."),
          tags$li("Please note Social Worker became an optional data item in 2019/20, in additional housing 
                  support was no longer included in the collection from April 2020 therefore total count may 
                  not be directly comparable to previous years when both were considered mandatory data items."),
          tags$li("Please consider data definitions and completeness when interpreting the data 
                  presented in this dashboard. Full details can be found  within the information 
                  tab and",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided."))
          ),
        
        ### Dropdown options ----
        
        wellPanel(
          
          ## select financial year
          
          column(6, shinyWidgets::pickerInput("client_summary_year_input",
                                              "Select Financial Year:",
                                              choices = unique(data_people_supported_summary$financial_year),
                                              selected = "2020/21"
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
          
          hidden(
            div(
              id = "ClientsTotalsTable",
              DT::dataTableOutput("table_clients_totals")
            )
          ),
          
        ### plot output ----
          
          plotlyOutput("ClientTotals",
                       height = "800px"
          )

            ) # end mainpanel
        ), # end people supported tabpanel
      
    ##########################################
    #### Tab 3.2: People Supported Trend ----
    ##########################################
    
    tabPanel(
      "Trend",
      h3("People Supported by Social Care Services Trend"),
      
      
      ### Text ----
      
      p("The chart below presents information on the Rate per 1,000 Population of people 
        who received social care services or support in Scotland, during a selected financial 
        year and by the Health and Social Care Partnership providing this support. These 
        services and support include: home care, care home, meals, community alarm/telecare, 
        housing support, social worker and day care. People involved in choosing and controlling 
        their support through",
        tags$a(href = "https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/","self-directed support"),
        "options are also included."),
      
      tags$b("Measures"),
      p("The following measures can be selected:"),
      tags$ul(
        tags$li("Rate per 1,000 Population"),
        tags$li("Rate per 1,000 Population – adjusted (allows comparison with the",
                tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                       "Scottish Government Social Care Survey"),").")
      ),
      
      p("Number of people is also provided within the table and download data function."),
      p("Please note, when adjusted is selected the services included in the count differ from 
        above in that it  only includes home care census, meals, community alarm/telecare, housing 
        support and social worker. People involved in choosing and controlling their support through 
        self-directed support options are also included."),
      
      tags$b("Data Completeness"),
      tags$ul(
        tags$li("Some Health and Social Care Partnerships were unable to provide information for 
              all the services and support reported on in this section; where possible an ‘estimated’ 
              figure has been reported. Details of the estimated figure calculations can be found in 
              the Information tab and the methodology section of the",
                tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                       "Technical Document.")),
        tags$li("It should be noted that for financial year 2017/18 information was only available 
                for the final quarter of the financial year for some services. Please see the 
                Information tab for more details."),
        tags$li("Please note that data completeness issues may affect interpretation of the data in 
                some instances. Total figures presented here with estimates included will not match 
                total count of submitted figures in other tabs."),
        tags$li("Please note Social Worker became an optional data item in 2019/20, in additional housing 
                support was no longer included in the collection from April 2020 therefore total count may 
                not be directly comparable to previous years when both were considered mandatory data items."),
        tags$li("Please consider data definitions and completeness when interpreting the data presented 
                in this dashboard. Full details can be found  within the information tab and",
                tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                       "Technical Document provided."))
       ),
      

      ### dropdown options ----
      
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
      # panel including buttons and plot
      
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
        
        hidden(
          div(
            id = "ClientsTrendTable",
            DT::dataTableOutput("table_clients_trend")
          )
        ),
        
      ### plot output ----
        
        plotlyOutput("client_trend_plot_output",
                     height = "550px"
        )
        
      ) # end mainpanel
        ), # end people supported tabpanel
    
    ######################################  
    #### Tab 3.3: Age and Sex ----
    ######################################  
      tabPanel(
        "Age and Sex",
        h3("Age and Sex Summary"),
        
        ## Text ----
        
        p("The chart below presents information on the Rate per 1,000 Social Care Clients who 
          received social care services or support in Scotland, by age group and sex. This data 
          is available for selected financial years (2017/18 - 2020/21) and by the Health and 
          Social Care Partnership providing support."),

        tags$b("Measures"),
        p("The following measures can be selected:"),
        tags$ul(
          tags$li("Rate per 1,000 People"),
          tags$li("Rate per 1,000 People – adjusted (allows comparison with the",
                  tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                         "Scottish Government Social Care Survey"),").")
        ),
        p("Number of people is also provided within the table and download data function. "),
        
        tags$b("Data Completeness"),
        tags$ul(
          tags$li("Figures presented here are based on all records where age and sex information 
                  was provided (98% of records)."),
          tags$li("Due to missing age and sex records, the total number of individuals presented 
                  in this section may appear to be less than other totals presented throughout the 
                  dashboard."),
          tags$li("To reflect data completeness issues an 'All Areas Submitted' total is provided 
                  rather than a Scotland total."),
          tags$li("It should be noted that for financial year 2017/18 information was only available 
                  for the final quarter of the financial year for some services. Please see the 
                  information tab for more details."),
          tags$li("Please note Social Worker became an optional data item in 2019/20, in additional 
                  housing support was no longer included in the collection from April 2020 therefore 
                  total count may not be directly comparable to previous years when both were 
                  considered mandatory data items."),
          tags$li("Please consider data definitions and completeness when interpreting the data 
                  presented in this dashboard. Full details can be found  within the information 
                  tab and",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided."))
        ),
        
        ## Dropdown options ----
        
        ### wellpanel 1
        
        wellPanel(
          
          ## select financial year
          
          column(6, shinyWidgets::pickerInput("clients_age_sex_year_input",
                                              "Select Financial Year:",
                                              choices = unique(data_people_supported_age_sex$financial_year),
                                              selected = "2020/21"
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
        
        ## ad space before buttons
        
        br(),
        
        ## Buttons ----
        
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
        
        # data table to show / hide
        hidden(
          div(
            id = "ClientsAgeSexTable",
            DT::dataTableOutput("table_clients_agesex")
          )
        )
        
        ), # end button wellpanel
        
        ## add space before plot
        
        br(),
        
        ## Plot -----
        mainPanel(
          width = 12,
          plotlyOutput("Clientsagesex",
                       height = "500px"),
          br()
          #,
          
          #p("Please note that the negative values presented on the left hand side of the x-axis in the plot above should be read as positive values. This will be reflected in future updates.")

        )
          ), # end age & sex tabpanel
      
    

    ##########################################
    #### Tab 6.4: Ethnic Group ----
    ##########################################

      tabPanel(
        "Ethnic Group",
        h3("Ethnic Group"),

        ## Text ----
        
        p("The chart below presents information on the Rate per 1,000 Social Care clients who 
          received social care services or support in Scotland by ethnicity group. This data 
          is available for selected financial years (2017/18 - 2020/21) and by the Health and 
          Social Care Partnership providing support."),

        tags$b("Measures"),
        p("The following measures can be selected:"),
        tags$ul(
          tags$li("Rate per 1,000 People"),
          tags$li("Rate per 1,000 People – adjusted (allows comparison with the",
                  tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                         "Scottish Government Social Care Survey"),").")
        ),
        p("Number of people is also provided within the table and download data function."),
        
        tags$b("Age Group"),
        p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
        
        tags$b("Data Completeness"),
        tags$ul(
          tags$li("To reflect data completeness issues a Scotland ‘All Areas Submitted’ is 
                  provided."),
          tags$li("It should be noted that for financial year 2017/18 information was only 
                  available for the final quarter of the financial year for some services. Please 
                  see the information tab for more details."),
          tags$li("Please note Social Worker became an optional data item in 2019/20, in additional 
                  housing support was no longer included in the collection from April 2020 therefore 
                  total count may not be directly comparable to previous years when both were 
                  considered mandatory data items."),
          tags$li("Please note in previous publications some ethnic groups were grouped together under 
                  “Other” due to small numbers. This has been removed from the current dashboard therefore 
                  may not  be directly comparable with previously published figures."),
          tags$li("Please consider data definitions and completeness when interpreting the data presented in 
                  this dashboard. Full details can be found  within the information tab and",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided."))
        ),
        
        ### -----
        
        mainPanel(
          width = 12,
        
        ## dropdown options ----
        
        # well panel 1
        
        wellPanel(
          
          # select year
          column(6, shinyWidgets::pickerInput("client_ethnicity_year_input",
                                              "Select Financial Year:",
                                              choices = unique(data_people_supported_ethnicity$financial_year),
                                              selected = "2020/21"
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
        
       
        ## buttons ----
        
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
        
        
        # data table to show / hide
        hidden(
          div(
            id = "ClientsEthnicityTable",
            DT::dataTableOutput("table_clients_ethnicity")
          )
        ),
      
        
        ## plot ----
        
        plotlyOutput("Clients_ethnicity_plot",
                     height = "600px")

        )
        
        )
          ), # end ethnicity tabpanel

      ############################################
      #### Tab 6.4: Social Care Client Group ----
      ############################################

      tabPanel(
        "Social Care Client Group",
        h3("Social Care Client Group"),
       
        ## text -----
        
        p("The chart below presents information on the rate per 1,000 Social Care clients who 
          received social care services or support in Scotland by Client Group. This data is 
          available for selected financial years (2017/18- 2020/21), age groups and by the Health 
          and Social Care Partnership providing support."),
        

        p("The Client Group or Service User Group an individual is assigned to is determined by a 
          Social Worker or Social Care Professional and is used as a means of grouping individuals 
          with similar care needs. An individual can be assigned to more than one Client Group."),
        
        p("The category 'Other' within Client Group includes Drugs, Alcohol, Palliative Care, Carer, 
          Neurological condition (excluding Dementia), Autism and Other Vulnerable Groups"),

        tags$b("Measures"),
        p("The following measures can be selected:"),
        tags$ul(
          tags$li("Rate per 1,000 People"),
          tags$li("Rate per 1,000 People – adjusted (allows comparison with the",
                  tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                         "Scottish Government Social Care Survey"),").")
        ),
        p("Number of people is also provided within the table and download data function."),
        
        tags$b("Age Group"),
        p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
        
        
        tags$b("Data Completeness"),
        tags$ul(
          tags$li("Figures across client groups cannot be added together to give an overall 
                  total as the same individual can appear in multiple client groups."),
          tags$li("Where a client did not have a client group assigned this is included in the group 
                  “Not Recorded”.To reflect data completeness issues an 'All Areas Submitted' total has 
                  been provided."),
          tags$li("It should be noted that for financial year 2017/18 information was only available for 
                  the final quarter of the financial year for some services. Please see the information tab 
                  for more details."),
          tags$li("Please note Social Worker became an optional data item in 2019/20, in additional housing 
                  support was no longer included in the collection from April 2020 therefore total count may 
                  not be directly comparable to previous years when both were considered mandatory data items."),
          tags$li("Please consider data definitions and completeness when interpreting the data presented 
                  in this dashboard. Full details can be found  within the information tab and",
                  tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                         "Technical Document provided."))
        ),

        ## Dropdown options ----
        
        # well panel 1
        wellPanel(
          # year dropdown
          
          column(6, shinyWidgets::pickerInput("client_group_year_input",
                                              "Select Financial Year:",
                                              choices = unique(data_people_supported_client_group$financial_year),
                                              selected = "2020/21")),
          
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
        
        
        ## Buttons ----
        
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
          hidden(
            div(
              id = "ClientsClientTypeTable",
              DT::dataTableOutput("table_clients_client_type")
            )
          ),
          
          
        ## plot output ----
          
          plotlyOutput("Clientsclienttype",
                       height = "600px")
         
                      ) # end buttons and plot mainpanel
        ), # end client group tabpanel

    #######################################
    #### Tab 6.5: Support and Services ----
    #######################################
      tabPanel(
        "Support and Services",
        h3("Social Care Support and Services"),

        ## Text ----

        p("The chart below presents information on the total number of people who received 
          social care services or support in Scotland by the different types of services 
          they received. This data is available for selected financial years (2017/18 - 2020/21) 
          and by the Health and Social Care Partnership providing support."),

        p("These services and support include: home care, care home, meals, community alarm/telecare, 
          housing support, social worker and day care."),
        
        p("Please note from 2019/20 Social Worker data was made optional from previously being mandatory 
          therefore not directly comparable with years prior to this."),
        
        tags$b("Age Group"),
        p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),

tags$b("Data Completeness"),
tags$ul(
  tags$li("Comparison data for 2017/18 data is not provided as time periods reported differ. 
          For further information on support and services data in 2017/18 please see the",
          tags$a(href = "https://scotland.shinyapps.io/nhs-social-care/", 
          "2017/18 Social Care Dashboard"),"."),
  tags$li("Some Health and Social Care Partnerships were unable to provide information for all 
          the services and support reported on in this section therefore to reflect data 
          completeness a Scotland ‘All Areas Submitted’ has been provided."),
  tags$li("Please note Social Worker became an optional data item in 2019/20, in additional 
          housing support was no longer included in the collection from April 2020 therefore 
          total count may not be directly comparable to previous years when both were 
          considered mandatory data items."),
  tags$li("Please consider data definitions and completeness when interpreting the data 
          presented in this dashboard. Full details can be found in the Information tab 
          or",
          tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf", 
                 "Technical Document provided."))
  ),


        ## dropdowns -----

## wellpanel 1

        wellPanel(
          
          # select year 
          column(6, shinyWidgets::pickerInput("client_service_year_input",
                                              "Select Financial Year:",
                                              choices = unique(data_people_supported_services$financial_year),
                                              selected = "2020/21"
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
          

  

        ## Buttons ----

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

          hidden(
            div(
              id = "ClientsServicesTable",
              DT::dataTableOutput("table_clients_services")
            )
          ),


        ## Plot ----

          plotlyOutput("GroupA",
                       height = "600px")

            ) # end mainpanel

        ), # end tabpanel

      ###############################
      ## Tab 6.6 Meals - (added back in CH 11/3/22) ----
      ###############################

       tabPanel(
         "Meals",
         h3("Meals"),
 
         p("This section presents information on the rate per 1,000 social care clients 
           receiving a meals service at any point during the reporting period."),
         
         tags$b("Measures"),
         p("The following measures can be selected:"),
         tags$ul(
           tags$li("Rate per 1,000 People"),
           tags$li("Rate per 1,000 People – adjusted (allows comparison with the",
                   tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                          "Scottish Government Social Care Survey."),").")
         ),
         p("Number of People is also provided within the table and download data function."),
         
         tags$b("Age Group"),
         p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
         
         tags$b("Data Completeness"),
         tags$ul(
           tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                   all the services and support reported on in this section therefore to reflect data 
                   completeness a Scotland ‘All Areas Submitted’ has been provided."),
           tags$li("Please note Social Worker became an optional data item in 2019/20, in additional housing support was no 
                   longer included in the collection from April 2020 therefore total count may not be directly comparable to 
                   previous years when both were considered mandatory data items."),
           tags$li("Please consider data definitions and completeness when interpreting the data presented in this dashboard.
                  Full details can be found in the Information tab.")
         ),
         
         
 
           ### Dropdowns
 
         wellPanel(
           
           # year 
           column(6, shinyWidgets::pickerInput("client_meals_year_input",
                                               "Select Financial Year:",
                                               choices = unique(data_people_supported_meals$financial_year),
                                               selected = "2020/21"
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
 
           ### Buttons
 
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
 
           hidden(
             div(
               id = "ClientsMealsTable",
               DT::dataTableOutput("table_client_meals"))
           ),
 
           ### Plot 
           plotlyOutput("meals_plot_output",
                        height = "500px")
 
 ) # end mainpanel
), # end meals tabpanel

###############################
## Tab 6.7 Living Alone - (added in CH 11/3/22) ----
###############################
# 
tabPanel(
  "Living Alone",
  h3("Living Alone"),
  
  
  p("This chart presents the percentage of social care clients that live alone. Data can be 
    viewed for financial years 2017/18 – 2020/21."),
  
  
  tags$b("Measures"),
  p("The following measures can be selected:"),
  tags$ul(
    tags$li("Percentage of People living alone/not living alone"),
    tags$li("Percentage of People living alone/not living alone – adjusted (allows comparison with the",
            tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                   "Scottish Government Social Care Survey."),").")
  ),
  p("Number of People is also provided within the table and download data function."),
  
  tags$b("Age Group"),
  p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+, and All Ages."),
  
  tags$b("Data Completeness"),
  tags$ul(
    tags$li("Some Health and Social Care Partnerships were unable to provide information for 
                   all the services and support reported on in this section therefore to reflect data 
                   completeness a Scotland ‘All Areas Submitted’ has been provided."),
    tags$li("Please note Social Worker became an optional data item in 2019/20, in additional housing 
            support was no longer included in the collection from April 2020 therefore total count 
            may not be directly comparable to previous years when both were considered mandatory data items."),
    tags$li("Please consider data definitions and completeness when interpreting the data presented in this dashboard.
                  Full details can be found in the Information tab.")
  ),
  
  
  ### Dropdowns
  
  wellPanel(
    
    # year 
    column(6, shinyWidgets::pickerInput("client_living_alone_year_input",
                                        "Select Financial Year:",
                                        choices = unique(data_people_supported_living_alone$financial_year),
                                        selected = "2020/21"
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
  
  ### Buttons
  
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
    
    hidden(
      div(
        id = "client_living_alone_table",
        DT::dataTableOutput("table_client_living_alone"))
    ),
    
    ### Plot 
    plotlyOutput("living_alone_plot",
                 height = "800px")
    
  ) # end mainpanel
  ) # end living alone tabpanel


####################################################
### closing brackets people and services summary
####################################################

       ) # end Tab 2 People & Services Summary left side navlistPanel
) # end mainpanel
      ) # end of tabPanel 2 People and Services Summary


##### app closing brackets ----

    ) # end tabsetpanel list (Tabs across top of dashboard  (Intro, People & Support, Info))


                      
) # end fluidpage



#) # end secure_app function for password protect PRA
# comment out if not password protecting for PRA
