#####################################################-
## TECHNOLOGY ENABLED CARE UI SCRIPT ##----
#####################################################-

##########################-
## password protect PRA ##
# shinymanager::secure_app( # comment out if not required 
##########################-


################ UI #####################

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
             
#############################-                      
#### Tab 1: Introduction ----   
#############################-
    tabPanel("Introduction", 
             wellPanel(column(4, h3("Social Care Insights Dashboard - Technology Enabled Care")),
                       column(8,
                              tags$br(),
          p("For people with particular needs, including certain types of disability or impairment, 
            a recognised risk of falling or a risk of placing themselves at personal risk due perhaps 
            to advanced dementia or other mental health conditions, the use of equipment and 
            technology can help them live safely and independently at home - providing reassurance to 
            themselves and to carers and enhancing personal choices. 
            The information in this dashboard is about people who have been supported with 
            community alarms or telecare."),
                               
           p("A community alarm is a form of equipment for communication, especially useful 
            as an alert should the user have an incident where they require to call for help 
            quickly. Typically, it includes a button/pull cord/pendant which transfers an 
            alert/alarm/data to a monitoring centre or individual responder. It can be used 
            within an individual’s own home or part of a communal system."),
                               
           p("Telecare refers to a technology package which goes over and above the basic community 
            alarm. It is the remote or enhanced delivery of care services to people in their own home 
            by means of telecommunications and computerised services. Telecare usually refers to 
            sensors or alerts which provide continuous, automatic and remote monitoring of care needs, 
            emergencies and lifestyle using information and communication technology. It may trigger 
            a human response or shut down equipment to prevent hazards."),
                               
           p("Information presented relates to all active community alarms and/or telecare services 
            and not just new installations."),
                               
            p("Further information about the community alarms and telecare data extract and the analyses 
             in this dashboard can be found by selecting the “Information” tab from the five tabs 
             across the top of the screen."),
          
          br(),
          p("This Dashboard has four additional tabs which can be selected: “Information”, “Technology Enabled Care”, 
            “Data Completeness” and “Data Quality”. Please click on “Technology Enabled Care” tab to see the different analyses 
            available. “Data Completeness” provides notes on completeness for each data set, time period and Health and 
            Social Care Partnership (HSCP).  “Data Quality” provides notes on the quality of the data (including where 
            estimates have been used if data have not been submitted) for each data set, time period and Health and Social Care Partnership.  
            For more information on data definitions and guidance on the information presented in this dashboard please click the Information tab."),
          br(),

            p(strong("Effects of COVID-19 on figures"), "The measures put in place to respond to COVID-19 pandemic will have affected the 
                                  services that the Health and Social Care Partnerships (HSCPs) were able to provide over the period of the pandemic.  
                                  Differences in data from previous years are likely to be affected by the ability of 
                                  HSCPs to provide social care services while dealing with the impact of the pandemic."), 
                               
            p("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
              tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                     "Statistical Disclosure Control Protocol.",
                     target="_blank")),
            p("If you experience any problems using this dashboard or have further questions relating to the data, please contact us at:",
              tags$b(tags$a(href = "mailto:phs.source@phs.scot",
                            "phs.source@phs.scot")),
              ".")
                        ) # end of column
                      ) # end wellpanel
             ), # end intro tabpanel
             
##########################################.
#### Tab 2: Information tab ----
##########################################.
           
   tabPanel("Information",
            icon = icon("info-circle"),
            mainPanel(
              width = 12,
              # Within this section we are going to have a sub tab column on the left
              # To do this we are going to use the layout "navlistPanel()"
              navlistPanel(id = "Info_list",
                           widths = c(2, 10),
                          
### Accessibility -----
  # tabPanel("Accessibility",   
  #          h2("Accessibility Statement"),
  #          p("This website is run by", 
  #            tags$a(href = "https://www.publichealthscotland.scot/", "Public Health Scotland"),
  #            ". Scotland’s national organisation for public health.", 
  #            class="externallink",
  #            target="_blank"),
  #          
  #          p("As a new organisation formed on 1 April 2020, Public Health Scotland is reviewing 
  #                         its web estate - including this website - aligned to corporate strategic and transformation plans."),
  #           p(tags$a(href = "https://abilitynet.org.uk/", 
  #                    "AbilityNet",
  #                    target="_blank"),
  #             "has advice on making your device easier to use if you have a disability."),
  #          
  #          tags$b("How Accessible this website is"),
  #          p("This site has not yet been evaluated against WCAG 2.1 level AA."),
  #          tags$b("Reporting accesibility problems with this website"), 
  #          p("If you wish to contact us about any accessibility issues you encounter on this site, please contact:",
  #            tags$a(href = "mailto:phs.healthscotland-webmaster@phs.scot", 
  #                   "phs.healthscotland-webmaster@phs.scot"),
  #            " "),
  #          tags$b("Enforcement procedure"),
  #          p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the 
  #             Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018
  #             (the 'accessibility regulations'). If you’re not happy with how we respond to your enquiry,",
  #            tags$a(href = "https://www.equalityadvisoryservice.com/",
  #                   "contact the Equality Advisory and Support Service (EASS)",
  #                   target="_blank"),
  #            "."), 
  #          tags$b("Preparation of this accessibility statement"),
  #          p("This statement was prepared on 20 September 2020. It was last reviewed on 17 September 2020.")
  #          ), # end accessibility panel
                          
                          
### How to use tool ----
  tabPanel("How To",
           h2("How To"),
           tags$b("Contact Us"),
           p("If you experience any problems using this dashboard or have further questions relating to the data, please contact us at",
             tags$a(href = "mailto:phs.source@phs.scot",
                    "phs.source@phs.scot")),
           tags$b("Screen Resolution"),
           p("For optimum resolution we recommend a resolution of 1024x768 or greater.
             This can be done via the control panel on your computer settings."),
           p(tags$b("How to use the Dashboard")),

           
           p("The Dashboard has five tabs across the top which can be selected: Introduction,
             Topic Area (Technology Enabled Care), Data Completeness and Data Quality. Please click on the Topic Area tab to see the different
             analyses available. These analyses are listed on the left hand side of the screen.
             Please click on the analysis of interest to see more details. To find more information
             about these analyses please select the “Information” tab from the five tabs across the top of the screen."),
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
             graph, you will see a toolbar with buttons:"),
          
            tags$ul(
             tags$li(
               tags$b("Download plot as a png"),
               icon("camera"),
               " - click this button to save the graph as an",
               "image (please note that Internet Explorer does",
               "not support this function)."),
             tags$li(
               tags$b("Zoom"),
               icon("search"),
               " - zoom into the graph by clicking this button",
               "and then clicking and dragging your mouse over",
               "the area of the graph you are interested in."),
             tags$li(
               tags$b("Pan"),
               icon("move", lib = "glyphicon"),
               " - adjust the axes of the graph by clicking this",
               "button and then clicking and moving your mouse",
               "in any direction you want."),
             tags$li(
               tags$b("Reset axes"),
               icon("home"),
               " - click this button to return the axes to their",
               "default range.")
           ) # end of tags$ul
           ), # end How to pannel
                          
                          
####### About Page -----

  tabPanel(
    "About",
    h2("About"),
  p("For people with particular needs, including certain types of disability or impairment,
    a recognised risk of falling or a risk of placing themselves at personal risk due perhaps
    to advanced dementia or other mental health conditions, the use of equipment and technology
    can help them live safely and independently at home - providing reassurance to themselves
    and to carers and enhancing personal choices. The information in this dashboard is about
    people who have been supported with community alarms or telecare."),
  p("A community alarm is a form of equipment for communication, especially useful as an alert
    should the user have an incident where they require to call for help quickly. Typically, it
    includes a button/pull cord/pendant which transfers an alert/alarm/data to a monitoring
    centre or individual responder. It can be used within an individual’s own home or part of a
    communal system."),
  
  p("Telecare refers to a technology package which goes over and above the basic community
    alarm. It is the remote or enhanced delivery of care services to people in their own home
    by means of telecommunications and computerised services. Telecare usually refers to
    sensors or alerts which provide continuous, automatic and remote monitoring of care needs,
    emergencies and lifestyle using information and communication technology. It may trigger a
    human response or shut down equipment to prevent hazards."),
  br(),
  tags$b("Data Sources"),
  p(" ",
    tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/",
           "Source Social Care Data",
           target = "_blank"),
    " ")
  ), # end of info notes tab panel
              
            
############ Definitions ##############
tabPanel(
  "Definitions",
  h2("Data Definitions"),
  
  p("The Source data definitions and guidance document can be found",
    tags$a(
      href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
      "here",
      class = "externallink",
      ".",
      target = "_blank")),
  p("This provides detailed information on Data Definitions used across all of the Social Care
    Insights Dashboards. Data Definitions relating specifically to the data presented
    throughout the Community Alarms and Telecare Dashboard can be found below."),
  tags$b("Methodology"),
  p("The information provided below on the methods and definitions that have been used
    throughout this dashboard should be used to assist with interpretation of the results
    presented."),
  
  tags$b("Data Sources"),
  p(" ",
    tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/",
           "Source Social Care Data",
           target = "_blank"),
    " "),
  
  tags$b("Financial Year"),
  p("Data in this dashboard are available for financial years 2017/18 and 2021/22.
    A financial year covers the time period from the 1 April to the 31 March in the
    following year."),
  p("Where trend information is presented in this dashboard, this includes data previously
    published by the Scottish Government in the Social Care Survey. Data from
    2015/16 to 2016/17 have been obtained from",
    tags$a(
      href = "https://www.gov.scot/publications/social-care-services-scotland-2017/",
      "the Scottish Government Website.",
      target = "_blank")),
  
  tags$b("Age Group"),
  tags$ul(
    tags$li(
      "Where age information has been provided, age has been calculated
      at the midpoint of the financial year, for example in 2021/22, age is
      calculated at 30 September 2021."),
    tags$li(
      "Age group breakdowns are available for some analysis in this dashboard.
      Where available the options will include: 0-17, 18-64, 65-74, 75-84, 85+
      and All Ages.")),
  
  tags$b("Local Authorities and Health and Social Care Partnerships"),
  
  p("The information shown comes mainly from data gathered within Scotland’s 32 Local Authorities and is
    a by-product of many thousands of individual needs assessments carried out, personal choices made
    and care plans prepared and delivered."),
  
  p("Local authorities are one of the strategic partners in Health and Social Care along with NHS Boards
    and Integration Authorities. For presentational reasons the label Health and Social Care Partnership
    is used throughout this dashboard (rather than Local Authority)."),
  
  p("Note: Reflecting variation across Scotland in the way partnership working occurs,
    the Stirling and Clackmannanshire Council analyses are shown separately although
    there is a single partnership involving both Local Authorities."),
  
  tags$b("Health and Social Care Partnership"),
  tags$ul(
    tags$li(
      "If a person received services/support from more than one Health and Social Care
      Partnership during the reporting period, they will be counted for each partnership."),
    tags$li(
      "Information is included on community alarms / telecare services purchased by the
      Health and Social Care Partnership from another provider e.g. Housing Association.
      This includes people living within amenity/sheltered/very sheltered/extra care housing
      where a community alarm (including a sheltered housing alarm) or telecare is included
      as part of the purchased or provided service.")),
  
  tags$b("Scotland Terminology"),
  tags$ul(
    tags$li(
      " “Scotland” - Information was supplied by all partnerships in Scotland."),
    tags$li(
      " “Scotland (estimated)” - Estimates have been included for partnerships
      that have not supplied the required data. Areas that have been estimated
      will be highlighted."),
    tags$li(
      " “Scotland (All Areas Submitted)” - This is the total of all areas that
      provided the required information only. It will undercount the actual picture
      for Scotland as no estimation has been done to produce a Scotland estimate.")),
  
  tags$b("Community Alarm"),
  p("Community Alarms refer to a communication hub (either individual or part of a communal
    system), plus a button/pull cord/pendant which transfers an alert/alarm/data to a
    monitoring centre or individual responder."),
  
  tags$b("Telecare"),
  p("Telecare refers to a technology package which goes over and above the basic community
    alarm package. It is the remote or enhanced delivery of care services to people in their
    own home by means of telecommunications and computerised services. Telecare usually
    refers to sensors or alerts which provide continuous, automatic and remote monitoring of
    care needs emergencies and lifestyle using information and communication technology to
    trigger human responses or shut down equipment to prevent hazards (Source: National Telecare
    Development Programme, Scottish Government)."),
  
  tags$b("Community Alarms and Telecare Measure"),
  p("People receiving a community alarm and/or telecare service
    are allocated to the following categories:"),
  tags$ul(
    tags$li("Community alarms only"),
    tags$li("Telecare only"),
    tags$li("Receiving both a community alarm and telecare")),
  p("The total count of people receiving a community alarm and/or telecare is provided.
    A person will count only once regardless of how many services they have."),
  
  tags$b("Living Alone"),
  p("This indicates if the service user lives alone or not. These analyses looks at the
    number of people with a community alarm/telecare package that are also recorded as
    living alone during the reporting period."),
  
  tags$b("Care at Home"),
  p("Care at Home is defined as the practical services which assist the service user to
    function as independently as possible and/or continue to live in their own home.
    Care at Home can include routine household tasks such as basic housework, shopping,
    laundry, paying bills etc. This analysis looks at the number of people with a
    Community Alarm and/or Telecare package and out of those who also receive care at home during the reporting period."),
  
  tags$b(
    "The following are included as part of the community
    alarms / telecare data extract:"),
  
  tags$ul(
    tags$li(
      "All active records for a person within the selected financial year."),
    tags$li(
      "When there is more than one person living within a house
      who has been identified as eligible for and requiring a
      community alarms / telecare service, individual information
      for each person/service has been provided where possible."),
    tags$li(
      "Telecare technologies installed in a person's home for a
      short period of time only to assist an assessment of need."),
    tags$li(
      "Closed services and services for people who have died if
      active during the financial year.")),
  
  tags$b(
    "The following is excluded within the community alarms / telecare
    extract:"),
  
  tags$ul(
    tags$li(
      "People living within properties which have had alarms
      installed historically but which are no longer used to
      meet care and support needs.")),
  
  br(),
  tags$b("Estimates (Trend tab only)"),
  p("As some Health and Social Care Partnerships were unable to provide individual level information for specific 
                                   topics (noted in the Data Completeness section within the dashboard) estimates have been used 
                                   to create top level Scotland figures for trends. The percentages applied to create the 
                                   estimates have been calculated using Scotland level (all areas submitted) data. These 
                                   percentages represent the percentage of clients receiving these services only."),
  p("Please refer to the ",
    tags$a(href="https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx",
           "Technical Document", 
           class="externallink", 
           target="_blank"), 
    "for details."),
  
  br()
  
    ), # end of tab panel 

                          ### Data Completeness (COMMENTED OUT CH 29/9/22) ----
                          
                          #         tabPanel(
                          #           "Data Completeness",
                          #           h2("Data Completeness"),
                          #           
                          #           p("The information presented in this dashboard relates to services and support where a
                          #  Health and Social Care Partnership has an involvement, such as providing the care and
                          #  support directly or by commissioning the care and support from other service providers.
                          #  Data on care and support that is paid for and organised entirely by the persons themselves
                          #  (i.e. self-funded) is not generally available and are excluded from all the analyses."),
                          #           
                          #           p("The data completeness table below presents the completeness for each Health and Social Care Partnership for the latest years published
                          # (2019/2020 and 2020/21). For full data completeness please see the",
                          #             tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf",
                          #                    "Technical Document.")),
                          #           
                          #           
                          #           tags$b("Disclosure Control"),
                          #           p("Statistical disclosure control has been applied to protect patient confidentiality. 
                          #  Therefore, the figures presented here may not be additive and may differ from previous publications. 
                          #  For further guidance see Public Health Scotland's",
                          #             tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                          #                    "Statistical Disclosure Control Protocol.")
                          #           ),
                          #           
                          #           br(),
                          #           
                          #           tags$b("Data Sources"),
                          #           p(" ",
                          #             tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                          #                    "Source Social Care Data")," "),
                          #           
                          #           br(),
                          #           
                          #           tags$b("Community Alarms and Telecare Data Completeness Table"),
                          #           DT::dataTableOutput("data_completeness_table"),
                          #           
                          #           br()
                          #           
                          #           
                          #         ), # end info data completeness tab panel
                          
### Resources ----
tabPanel("Resources",
  h2("Resources"),
  
  tags$b("Technology Enabling Care Support Resources"),
  br(),
  
  p("Disclosure Control Information:",
    tags$a(
      href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
      "www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
      class = "externallink",
      target = "_blank")),
  
  p("Technology Enabled Care Information:",
    tags$a(
      href = "https://tec.scot/",
      "https://tec.scot/",
      class = "externallink",
      target = "_blank")),
  
  p("Scotland’s Digital Health Care Strategy:",
    tags$a(
      href = "https://www.gov.scot/publications/scotlands-digital-health-care-strategy/",
      "https://www.gov.scot/publications/scotlands-digital-health-care-strategy/",
      class = "externallink",
      target = "_blank")),
  
  p("Care at Home Background Information:",
    tags$a(
      href = "https://www.gov.scot/publications/national-care-standards-care-home/",
      "https://www.gov.scot/publications/national-care-standards-care-home/",
      class = "externallink",
      target = "_blank")),
  
  p("Personal Care Information:",
    tags$a(
      href = "https://www.gov.scot/policies/social-care/social-care-support/",
      "https://www.gov.scot/policies/social-care/social-care-support/",
      class = "externallink",
      target = "_blank")),
  
  p("Scottish Government Social Care Survey:",
    tags$a(
      href = "https://www.gov.scot/publications/social-care-services-scotland-2017/",
      "www.gov.scot/publications/social-care-services-scotland-2017/",
      class = "externallink",
      target = "_blank")),
  
  tags$b("Technology Enabling Care releases and supporting document"),
  
  br(),
  
  p("2021/22 Social Care Insights Publication: ",
    tags$a(href="https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-202021-to-202122/",
           "https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-202021-to-202122/",  
           class="externallink",
           target="_blank")),
  
  p("2021/22 Social Care Technical Document: ",
    tags$a(href="https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx",
           "https://publichealthscotland.scot/media/17898/2023-02-28-social-care-technical-document.docx",  
           class="externallink",
           target="_blank")),
  
  p("2021/22 Social Care Balance of Care: ",
    tags$a(href="https://publichealthscotland.scot/media/17825/2023-02-14-balance-of-care_updated.xlsm",
           "https://publichealthscotland.scot/media/17825/2023-02-14-balance-of-care_updated.xlsm",  
           class="externallink",
           target="_blank")),
  
  p("Disclosure Control Information:",
    tags$a(href="https://publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
           "www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
           class="externallink",
           target="_blank")),
  
  p("2019/20 & 2020/21 Social Care Insights Publication: ",
    tags$a(href="https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-201920-202021/",
           "https://publichealthscotland.scot/publications/insights-in-social-care-statistics-for-scotland/insights-in-social-care-statistics-for-scotland-support-provided-or-funded-by-health-and-social-care-partnerships-in-scotland-201920-202021/",  
           class="externallink",
           target="_blank")),
  
  p("2019/20 & 2020/21 Social Care Technical Document: ",
    tags$a(href="https://publichealthscotland.scot/media/13278/2022-04-26-social-care-technical-document.pdf",
           "https://publichealthscotland.scot/media/13278/2022-04-26-social-care-technical-document.pdf",  
           class="externallink",
           target="_blank")),
  
  p("2019/20 & 2020/21 Balance of Care:",
    tags$a(href="https://publichealthscotland.scot/media/12910/2022-04-26-balance-of-care.xlsm",
           "https://publichealthscotland.scot/media/12910/2022-04-26-balance-of-care.xlsm",  
           class="externallink",
           target="_blank")),
  
  p("2018/19 Social Care Insights Report:",
    tags$a(href="https://publichealthscotland.scot/media/4294/2020-09-29-social-care-report.pdf",
           "https://publichealthscotland.scot/media/4294/2020-09-29-social-care-report.pdf", 
           class="externallink", 
           target="_blank")),
  
  p("2018/19 Social Care Technical Document:",
    tags$a(href="https://publichealthscotland.scot/media/4296/2020-09-29-social-care-technical-document.pdf",
           "https://publichealthscotland.scot/media/4296/2020-09-29-social-care-technical-document.pdf", 
           class="externallink", 
           target="_blank")),
  
  p("2017/18 Social Care Insights Dashboard:",
    tags$a(href="https://scotland.shinyapps.io/nhs-social-care/",
           "www.scotland.shinyapps.io/nhs-social-care/",  
           class="externallink",
           target="_blank"))
  
  
  # p("Indicator of Relative Need (ioRN) Information:",
  #   tags$a(
  #     href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
  #     "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
  #     class = "externallink",
  #     target = "_blank"))
  )# end of tab panel

) # end info left navlistpanel
) # end info mainpanel
), # end info tab
             
####################################################-
#### Tab 3: Community Alarms / Telecare Summary ----
####################################################-
     tabPanel("Technology Enabled Care",
              navlistPanel(
                        id = "left_tabs_equipment",
                        widths = c(2, 10),
                        
#######################################################-                    
#### Tab 3.1: TREND ----
#######################################################-
        tabPanel("Trend",
                 mainPanel(
                   width = 12,
                   h3("Technology Enabled Care - Trend"),
    
### text ----
    p("This section presents information on the number of people/rate per 1,000 population in receipt of Technology Enabled Care (a community alarm and/or telecare package) from 2015/16 to 2021/22."),
    # p("The analysis can be presented for the following services:",
    #   tags$ul(
    #     tags$li("Community Alarms only"),
    #     tags$li("Telecare only"),
    #     tags$li("Receiving Community Alarm or Telecare"),
    #     tags$li("Receiving Community Alarm and Telecare"))
    #   ),
    br(),
    
### dropdown ----
    
    # first row dropdowns
    wellPanel(
      ## location dropdown
      
      column(6,
             shinyWidgets::pickerInput(
               "tec_trend_location_input",
               "Select Location:",
               choices = unique(data_tech_enabled_care_trend$sending_location),
               selected = "Scotland (Estimated)")),
      
      ## comparison location dropdown
      
      column(6,
             shinyWidgets::pickerInput(
               "tec_trend_location_comparison_input",
               "Select Comparison Location:",
               choices = unique(data_tech_enabled_care_trend$sending_location),
               selected = "Scotland (Estimated)"))
    ), # wellpanel 1 closing bracket
    
    # second row dropdowns
    wellPanel(
      ## service dropdown
      column(6,
             shinyWidgets::pickerInput(
               "tec_trend_service_input",
               "Select Service:",
               choices = unique(data_tech_enabled_care_trend$service),
               selected = "Total Receiving Community Alarms and/or Telecare")),
      
      ## Measure dropdown
      column(6,
             shinyWidgets::pickerInput(
               "tec_trend_measure_input",
               "Select Measure:",
               choices = unique(data_tech_enabled_care_trend$measure),
               selected = "Rate per 1,000 People"))
      
    ), # end dropdown wellpanel
    
### buttons ----
mainPanel(
  width = 12,
  
  ## show / hide table button
  actionButton("tec_trend_showhide",
               "Show/hide table",
               style = button_style_showhide),
  
  ## download data button
  
  downloadButton(outputId = "download_tec_trend_data",
                 label = "Download data",
                 class = "tech_enabled_care_trend_download_button"),
  tags$head(tags$style(
    paste0(
      ".tech_enabled_care_trend_download_button ",
      button_background_col,
      ".tech_enabled_care_trend_download_button ",
      button_text_col,
      ".tech_enabled_care_trend_download_button ",
      button_border_col)
  ) # end of tags$style
  ), # end tags$head
  
                                     
### data table ----
hidden(div(id = "tec_trend_table",
    DT::dataTableOutput("tec_trend_table_output"))),
                                     
### plot ----
                                     
plotlyOutput("tec_trend_plot",
             height = "550px"),

br(),
br(), 
                                     
### data notes ----
tags$b("Notes"),

tags$ul(
  tags$li(
    "Information relates to all active community alarms and/or telecare services and
    not just new installations."),
  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
  tags$li(
    "Technology enabled care data are collected on an annual basis therefore figures
    cannot be presented by quarter."),
  tags$li(
    "Data prior to 2017/18 were sourced from the",
    tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/",
           "Social Care Survey",
           target = "_blank"),
    "previously published by the Scottish Government. Prior to 2015/16,
    the Scottish Government's Social Care Survey collected new
    installations data only so data prior to time period are not
    comparable."),
  tags$li(
    "Some Health and Social Care Partnerships were unable to provide information for
    all the services and support reported on in this section; where possible an ‘estimated’
    figure has been reported. Details of the estimated figure calculations can be found in the Data Completeness tab."),
  
  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                 "Statistical Disclosure Control Protocol.",
                 target="_blank"))
  ), # end of tags$ul

br()

  ) # end mainpanel for buttons and plot

  ) # end mainpanel
  ), # end trend tab panel (left navigation)
                        
                        
#####################################-    
#### Tab 2.2: SUMMARY ----
#####################################-
tabPanel(
  "Technology Enabled Care Summary",
  
  
  mainPanel(
    width = 12,
    h3("Technology Enabled Care - Summary"),
    
    ### text ----
    p("This section presents the number of people/rate per 1,000 Scottish population in receipt of a
      community alarm and/or telecare package at some point during the selected financial
      year by Health and Social Care Partnership."),
    
    br(),
    
### dropdowns ----
    
    # well panel 1
    # financial year dropdown
    
    wellPanel(
      
      column(6,
             shinyWidgets::pickerInput(
               "tec_summary_year_input",
          "Select Financial Year:",
          choices = unique(data_tech_enabled_care_summary$financial_year),
          selected = "2021/22")),
      
      # age group dropdown
      
      column(6,
        shinyWidgets::pickerInput(
          "tec_summary_age_input",
          "Select Age Group:",
          #choices = unique(data_tech_enabled_care_summary$age_group),
          # remove unknown from dropdown
          choices = unique(data_tech_enabled_care_summary$age_group[data_tech_enabled_care_summary$age_group != "Unknown"]),
          selected = "All Ages"))
      
    ), # end of well panel 2
    
    wellPanel(
      # Service dropdown
      column(6,
        shinyWidgets::pickerInput(
          "tec_summary_service_input",
          "Select Service:",
          choices = unique(data_tech_enabled_care_summary$service),
          selected = "Total Receiving Community Alarms and/or Telecare")),
      
      # Measure dropdown
      column(6,
        shinyWidgets::pickerInput(
          "tec_summary_measure_input",
          "Select Measure:",
          choices = unique(data_tech_enabled_care_summary$measure),
          selected = "Rate per 1,000 Population"))
      
    ), # end wellpanel for dropdowns
    
    br(),
    
                                   
### buttons ----

mainPanel(
  width = 12,
  
  # row for download data button and show / hide table
  
  wellPanel(
    # show / hide table button
    
    actionButton("tec_summary_show_table",
                 "Show/hide table",
                 style = button_style_showhide),
    
    ## download data button
    downloadButton(
      outputId = "download_tech_enabled_care_alarmstelecare",
      label = "Download data",
      class = "my_tech_enabled_care_alarms_telecare_button"),
    
    tags$head(tags$style(
      paste0(
        ".my_tech_enabled_care_alarms_telecare_button ",
        button_background_col,
        ".my_tech_enabled_care_alarms_telecare_button ",
        button_text_col,
        ".my_tech_enabled_care_alarms_telecare_button ",
        button_border_col))),
    
### data table ----
                                       
hidden(div(id = "tec_summary_table",
           DT::dataTableOutput("tec_summary_table_output")))

  ), # end wellpanel for buttons
                                     
### plot ----

br(),

plotlyOutput("tec_summary_plot",
             height = "750px"),

br(),
br(), 
                                     
### data notes ----

tags$b("Notes"),
tags$ul(
  tags$li(
    "Information relates to all active community alarms and/or telecare services
    and not just new installations."),
  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
  tags$li(
    "Technology enabled care data are collected on an annual basis therefore figures
    cannot be presented by quarter."),
  tags$li(
    "Some Health and Social Care Partnerships were unable to provide information for
    all the services and support reported on in this section; where possible an ‘estimated’
    figure has been reported. Details of the estimated figure calculations can be found in the Data Completeness tab."),
    
  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                 "Statistical Disclosure Control Protocol.",
                 target="_blank"))
                                                                                                                               
  ), # end of $ul
br()

  ) # end mainpanel - plots and buttons section
  ) # end mainpanel
     ), # end equip summary  tab

                        
#########################################################-
#### Tab 2.3 LIVING ALONE -----
#########################################################-
tabPanel("Living Alone Summary",
      h3("Technology Enabled Care - Living Alone"),
         
### text ----

p("This section presents information on the proportion of people who were living alone whilst in receipt
  of a community alarm and/or telecare service by Health and Social Care Partnership for the
  financial years selected, 2017/18 - 2021/22."),

br(),

### dropdowns ----

wellPanel(
  
  column(6,
    shinyWidgets::pickerInput(
      "tec_living_alone_financial_year_input",
      "Select Financial Year:",
      choices = unique(data_tech_enabled_care_living_alone$financial_year),
      selected = "2021/22")), 
 
  # service dropdown
  column(6,
    shinyWidgets::pickerInput(
      "tec_living_alone_service_input",
      "Select Service:",
      choices = unique(data_tech_enabled_care_living_alone$service),
      selected = "Total Receiving Community Alarms and/or Telecare"))
  
     ), # end wellpanel 1
                                 
# wellpanel 2
wellPanel(# select age group
  column(6,
    shinyWidgets::pickerInput(
      "tec_living_alone_age_input",
      "Select Age Group:",
      choices = unique(data_tech_enabled_care_living_alone$age_group[data_tech_enabled_care_living_alone$age_group != "Unknown"]),
      selected = "All Ages"))
  ), # end wellpanel 2


### buttons ----

br(),
mainPanel(width = 12,
  
  ## fluid row for data download and show / hide table buttons
  fluidRow(
    
    ## show / hide table button
    actionButton("tec_living_alone_showhide",
                 "Show/hide table",
                 style = button_style_showhide),
    
    ## download button
    downloadButton(outputId = "download_tec_living_alone_data",
                   label = "Download data",
                   class = "living_alone_download_button"),
    tags$head(tags$style(
      paste0(
        ".living_alone_download_button ",
        button_background_col,
        ".living_alone_download_button ",
        button_text_col,
        ".living_alone_download_button ",
        button_border_col))),
    
                                     
### data table ----
                                     
hidden(div(id = "tec_living_alone_table",
           DT::dataTableOutput("tec_living_alone_table_output")))

  ), # end fluidrow

br(), 
                                   
### plot ----
                                   
plotlyOutput("tec_living_alone_plot",
             height = "800px"),
br(),
br(), 
                                   
### data notes ----
                                   
tags$b("Notes"),
tags$ul(
  tags$li(
    "Information relates to all active community alarms and/or telecare services
    and not just new installations."),
  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
  tags$li(
    "Technology enabled care data are collected on an annual basis therefore figures
    cannot be presented by quarter."),
  tags$li(
    "Some Health and Social Care Partnerships were unable to provide information for
    all the services and support reported on in this section. Therefore, to reflect data
    completeness, a Scotland ‘All Areas Submitted’ has been provided."),
  
  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                 "Statistical Disclosure Control Protocol.",
                 target="_blank"))
  ), # end tags$ul

br()

  ) # end mainpanel
  ), # end telecare/living_alone summary  tab

                        
#########################################################-
#### Tab 2.4: CARE AT HOME -----
#########################################################-
  tabPanel("Care at Home Summary by HSCP",
   h3("People with Technology Enabled Care and a Care at Home Service by Health and Social Care Partnership"),
                                 
 ### text ----

   p("This section presents the proportion of people supported by technology enabled care (community alarms and/or telecare) 
     services and a care at home service at the same time. Information is available for financial years, 2018/19 - 2021/22, 
     by Health and Social Care Partnership and age group."),
   
   br(), 
                                 
### dropdowns ----

wellPanel(# year drop down
  column(6,
    shinyWidgets::pickerInput(
      "tec_cah_financial_year_input",
      "Select Financial Year:",
      choices = unique(data_tech_enabled_care_cah$financial_year),
      selected = "2021/22")),
  
  column(6,
    shinyWidgets::pickerInput(
      "tec_cah_age_input",
      "Select Age Group:",
      choices = unique(data_tech_enabled_care_cah$age_group),
      selected = "All Ages"))
  ), # end of well panel

br(),


### buttons ----

mainPanel(
  width = 12,
  
  fluidRow(
    ## show / hide table button
    actionButton("tec_cah_showhide",
                 "Show/hide table",
                 style = button_style_showhide),
    
    ## download button
    downloadButton(outputId = "download_tec_cah_data",
                   label = "Download data",
                   class = "cah_telecare_download_button"),
    tags$head(tags$style(
      paste0(
        ".cah_telecare_download_button ",
        button_background_col,
        ".cah_telecare_download_button ",
        button_text_col,
        ".cah_telecare_download_button ",
        button_border_col))),
    
### data table ----
    
    hidden(div(
      id = "tec_cah_table",
      DT::dataTableOutput("tec_cah_table_output")))
    
  ),  # end fruidrow
  
  ### plot ----
  
  plotlyOutput("tec_cah_plot",
               height = "800px"),
  br(),
  br(),
  
                                   
### data notes ----

tags$b("Notes"),
tags$ul(
  tags$li(
    "Comparison data for 2017/18 data are not provided as time periods reported differ.
    For further information on support and services data in 2017/18 please see the",
    tags$a(href = "https://scotland.shinyapps.io/nhs-social-care/",
           "2017/18 Social Care Dashboard",
           target = "_blank"),
    "."),
  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
  tags$li(
    "Information relates to all active community alarms and/or telecare services and
    not just new installations."),
  tags$li(
    "Technology enabled care data are collected on an annual basis therefore figures cannot
    be presented by quarter."),
  tags$li(
    "Some Health and Social Care Partnerships were unable to provide information for all
    the services and support reported on in this section. Therefore, to reflect data
    completeness, a Scotland ‘All Areas Submitted’ has been provided."),
  
  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                 "Statistical Disclosure Control Protocol.",
                 target="_blank"))
  
  ), # end tags$ul

br()

  ) # end mainpanel
        ), # end telecare/cah summary  tab

                        
#########################################################-
#### Tab 2.5: CARE AT HOME BY AGE -----
#########################################################-
tabPanel("Care at Home Summary by Age",
         
         h3("People with Technology Enabled Care and a Care at Home Service by Age Group"),
         
### text ----

p(
  "This section presents the proportion of people supported by technology enabled care (community alarms and/or telecare) services 
  and a care at home service at the same time. Information is available for financial years, 2018/19 - 2021/22, by age group 
  and Health and Social Care Partnership."
),

br(),

### dropdowns ----

wellPanel(# year drop down
  column(6,
         shinyWidgets::pickerInput(
           "tec_cah_age_financial_year_input",
           "Select Financial Year:",
           choices = unique(data_tech_enabled_care_cah$financial_year),
      selected = "2021/22")),
  
  column(6,
         shinyWidgets::pickerInput(
           "tec_cah_age_location_input",
           "Select Location:",
           choices = unique(data_tech_enabled_care_cah$sending_location),
           selected = "Scotland (All Areas Submitted)"))
  ), # end of well panel

br(), 

### buttons ----

mainPanel(
  width = 12,
  
  
  fluidRow(
    ## show / hide table button
    actionButton("tec_cah_age_showhide",
                 "Show/hide table",
                 style = button_style_showhide),
    
    ## download button
    downloadButton(outputId = "download_tec_cah_age_data",
                   label = "Download data",
                   class = "cah_age_telecare_download_button"),
    
    tags$head(tags$style(
      paste0(
        ".cah_age_telecare_download_button ",
        button_background_col,
        ".cah_age_telecare_download_button ",
        button_text_col,
        ".cah_age_telecare_download_button ",
        button_border_col))),
    
### data table ----

hidden(div(id = "tec_cah_age_table",
           DT::dataTableOutput("tec_cah_age_table_output")))

  ), # end fruidrow

### plot ----

plotlyOutput("tec_cah_age_plot",
             height = "500px"),
br(),
br(),

### data notes ----
                                   
tags$b("Notes"),
tags$ul(
  tags$li(
    "Comparison data for 2017/18 data are not provided as time periods reported differ.
    For further information on support and services data in 2017/18 please see the",
    tags$a(
      href = "https://scotland.shinyapps.io/nhs-social-care/",
      "2017/18 Social Care Dashboard",
      target = "_blank"),
    "."),
  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
  tags$li(
    "Information relates to all active community alarms and/or telecare services and
    not just new installations."),
  
  tags$li(
    "Technology enabled care data are collected on an annual basis therefore figures
    cannot be presented by quarter."),
  
  tags$li(
    "Some Health and Social Care Partnerships were unable to provide information for
    all the services and support reported on in this section. Therefore, to reflect data
    completeness, a Scotland ‘All Areas Submitted’ has been provided."),
  
  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                 "Statistical Disclosure Control Protocol.",
                 target="_blank"))
  ), # end tags$ul
br()

  ) # end mainpanel
), # end telecare/cah age  tab
                        
                        
#########################################################-
#### Tab 2.6: DEPRIVATION -----
#########################################################-
     tabPanel("Deprivation Summary",
              
              h3("Technology Enabled Care - Deprivation"),
                                 
                                 
### text ----

p("This section presents the number of people supported by technology enabled care (community alarms and/or telecare) 
  services according to deprivation category (Scottish Index of Multiple Deprivation) of the person in receipt of the care. 
  The information is available by Health and Social Care Parnership for financial years, 2018/19 - 2021/22."),

br(), 
                                 
### dropdowns ----

# well panel 1

wellPanel(# year drop down
  column(
    6,
    shinyWidgets::pickerInput(
      "tec_simd_financial_year_input",
      "Select Financial Year:",
      choices = unique(data_tech_enabled_care_deprivation$financial_year),
      selected = "2021/22"
    )
  ),
  
  column(
    6,
    shinyWidgets::pickerInput(
      "tec_simd_location_input",
      "Select Location:",
      choices = unique(data_tech_enabled_care_deprivation$sending_location),
      selected = "Scotland (All Areas Submitted)"
    )
  )),

# well panel 2

wellPanel(# age group dropdown
  
  column(6,
    shinyWidgets::pickerInput(
      "tec_simd_age_input",
      "Select Age Group:",
      #choices = unique(data_tech_enabled_care_deprivation$age_group),
      # remove unknown from dropdown
      choices = unique(data_tech_enabled_care_deprivation$age_group[data_tech_enabled_care_deprivation$age_group != "Unknown"]),
      selected = "All Ages")),

  # measure dropdown
  column(6,
    shinyWidgets::pickerInput(
      "tec_simd_measure_input",
      "Select Measure:",
      choices = unique(data_tech_enabled_care_deprivation$measure),
      selected = "SIMD Quintile Proportion"))
  
  ), # end wellpanel 2

br(),

### buttons ----

mainPanel(
  width = 12,
  
  
  fluidRow(
    ## show / hide table button
    
    actionButton("tec_simd_showhide",
                 "Show/hide table",
                 style = button_style_showhide),
    
    ## download button
    
    downloadButton(outputId = "download_tec_simd_data",
                   label = "Download data",
                   class = "simd_telecare_download_button"),
    tags$head(tags$style(
      paste0(
        ".simd_telecare_download_button ",
        button_background_col,
        ".simd_telecare_download_button ",
        button_text_col,
        ".simd_telecare_download_button ",
        button_border_col))),
    
### data table ----

hidden(div(id = "tec_simd_table",
           DT::dataTableOutput("tec_simd_table_output")))

  ), # end fruidrow

### plot ----

plotlyOutput("tec_simd_plot",
             height = "500px"),
br(),
br(),

### data notes ----

tags$b("Notes"),
tags$ul(
  tags$li(
    "Information relates to all active community alarms and/or telecare services and
    not just new installations."),
  tags$li("The 2021/22 figures are labelled as provisional and are subject to change following future submissions of data."),
  tags$li("The 2020/21 figures reported in the graph are now revised and may differ to previously reported figures. This is due to additional or amended records being included in the 2021/22 returns."),
  tags$li(
    "Technology enabled care data are collected on an annual basis therefore figures
    cannot be presented by quarter."),
  
  tags$li(
    "Some Health and Social Care Partnerships were unable to provide information for
    all the services and support reported on in this section. Therefore, to reflect data
    completeness, a Scotland ‘All Areas Submitted’ has been provided."),
  
  tags$li("Statistical disclosure control has been applied to protect patient confidentiality. 
             Therefore, the figures presented here may not be additive and may differ from previous 
             publications. For further guidance see Public Health Scotland's ",
          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                 "Statistical Disclosure Control Protocol.",
                 target="_blank"))
  ), # tags$ul end

br()

  ) # end mainpanel
  ) # end telecare/simd  tab
                        
                        
                        
###### Closing brackets #######
                        
          ) # end Tab 2 tech_enabled_care Summary left side navlistPanel
                      
     ), # end of tabPanel 2 tech_enabled_care Summary

#########################################################-
#### DATA COMPLETENESS TAB -----
#########################################################-
tabPanel(
  "Data Completeness",
  mainPanel(width = 12,
    
    h2("Data Completeness"),
    
    p("The data completeness table below presents the completeness for each Health and Social Care Partnership and time period presented.  
      Data can be sorted based on the headings of each column in the table below.  Please click on the column headings to sort the data either 
      alphabetically (a-z / z-a) or numberically (ascending / descending)."),
    
    tags$b("Disclosure Control"),
    p("Statistical disclosure control has been applied to protect patient confidentiality.
      Therefore, the figures presented here may not be additive and may differ from previous publications.
      For further guidance see Public Health Scotland's",
      tags$a(
        href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
        "Statistical Disclosure Control Protocol.",
        target = "_blank")),
    
    br(),
    
    tags$b("Data Sources"),
    p(" ",
      tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/",
             "Source Social Care Data",
             target = "_blank")," "),
    
    br(),
    
    wellPanel(
    
    column(6,
           pickerInput("data_completeness_hscp",
                       "Select Health and Social Care Partnership:",
                       choices = c("All HSCPs",
                                   unique(data_completeness_table$`Health and Social Care Partnership`)))),
    
    column(6,
           pickerInput("data_completeness_year",
                       "Select Financial Year:",
                       choices = c("All Financial Years",
                                   unique(sort(data_completeness_table$`Financial Year`)))))
    
    ),
    
    
    br(),
    br(),
    
    column(12,
           tags$b("Community Alarms and Telecare Data Completeness Table")),
    
    br(),
    br(),
    
    
    DT::dataTableOutput("data_completeness_table"),
    
    br()
    
    
)
), # close data completeness tab
             
#########################################################-
#### DATA QUALITY TAB -----
#########################################################-
tabPanel("Data Quality",
         mainPanel(width = 12,
                   
                   h2("Data Quality"),
           
           p("The Data Quality table below provides high level data quality information to aid interpretation of the data presented in the Technology Enabled Care tab 
             for each Health and Social Care Partnership and time period presented.  Data can be sorted based on the headings of each column in the table below. 
             Please click on the column headings to sort the data either alphabetically (a-z / z-a) or numberically (ascending / descending)."),
           
           br(),
           
           wellPanel(
           
           column(6,
                  pickerInput("data_quality_hscp",
                              "Select Health and Social Care Partnership:",
                              choices = c("All HSCPs", unique(data_quality_table$`Health and Social Care Partnership`)))),
           
           column(6,
                  pickerInput("data_quality_year",
                              "Select Financial Year:",
                              choices = c("All Financial Years",
                                          sort(unique(data_completeness_table$`Financial Year`)))))
           
           ),
           
           
           br(),
           br(),
           
           column(12,
                  tags$b("Community Alarms and Telecare Data Quality Table")),
           
           br(),
           br(),
           
           
           DT::dataTableOutput("data_quality_table"),
           
           br()
           
           
         ))  # close data quality tab

#######################################-
##### closing brackets -----
#######################################-

  ) # end navlist across top
) # end fluid page

#) # end secure_app function for password protect PRA
# comment out if not password protecting for PRA

