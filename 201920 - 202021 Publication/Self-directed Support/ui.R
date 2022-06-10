############################################################
### UI 
### Self- directed Support Script
### Original Author: Ciaran Harvey
### Orignal Date: 05/06/19
### Adapted by Jenny Armstrong June 2020
### Written/run on R Studio Server
### R version 3.5.1
### This script creates the user interface of the dashboard
############################################################

########################
### User Interface ----
########################
 

##########################
## password protect PRA ##
#shinymanager::secure_app( # comment out if not required 
  ##########################
  

ui <- fluidPage(
  useShinyjs(),
  
  # The following code allows the shiny app to be viewed on mobile devices  
  HTML('<meta name="viewport" content="width=1200">'),
  style = "width: 100%; height: 100%; max-width: 1200px;", 

  navbarPage(id = "tabs_across_top", 
             
             title = div(tags$a(img(src="phs_logo.png", height=40), href= "https://www.publichealthscotland.scot/"),
                         style = "position: relative; top: -10px;"), 
             
             windowTitle = "Social Care Insights", #title for browser tab
             header = tags$head(includeCSS("www/styles.css")), # CSS styles
             
    #############################         
    #### Tab 1: Introduction ----
    #############################
  
      tabPanel(
      "Introduction",
      
      wellPanel(
        column(4, h3("Social Care Insights Dashboard - Self-directed Support (SDS)")),
        column(8,
              p("Self-directed support was introduced in Scotland on the 1 April 2014 following the Social Care 
                Self-directed Support Scotland Act 2013. Its introduction means that people receiving social care 
                support in Scotland have the right of choice, control and flexibility to meet their personal outcomes. 
                Health and Social Care Partnerships are required to ensure that people are offered a range of choices 
                on how they receive their social care support. The self-directed support options available are:",
        tags$ul(
          tags$li("Option 1: Taken as a Direct Payment."),
          tags$li("Option 2: Allocated to an organisation  that the 
                        person chooses and the person is in charge of how it is 
                        spent."),
          tags$li("Option 3: The person chooses to allow the council 
                        to arrange and determine their services."),
          tags$li("Option 4: The person can choose a mix of these 
                        options for different types of support.")
        )),

      p("It is important to note that all four options are available for people and individual 
        choice is key. Some options may be more popular within different sections of the 
        population. "),

      p("Further details about self-directed support are available",
        tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf", 
               "here")),
      
      p(strong("Effects of COVID-19 on figures"),
        "The measures put in place to respond to COVID-19 pandemic will have affected the 
                                  services that the HSCPs were able to provide over the period of the pandemic.  
                                  Differences in data from previous years are likely to be affected by ability of 
                                  HSCPs to provide social care services while dealing with the impact of the pandemic."),

      p("Statistical disclosure control has been applied to protect patient confidentiality. 
        Therefore, the figures presented here may not be additive and may differ from previous 
        publications. For further guidance see Public Health Scotland's ",
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
      tags$br()
      )
      ) # end wellpanel
      
      ), # end intro tabpanel
    ############################################
    #### Tab 2: Information tab -----
    ############################################
    
    tabPanel("Information",
             icon = icon("info-circle"),
             
             navlistPanel(
               id = "info_tabs_left",
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
               
               
               #### How to ----
               
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
                          about these analyses please select the “Information” tab from the three tabs across the 
                          top of the screen."),
                        
                        tags$b("Interact with the Dashboard"),
                        p("Dropdown menus are available for many of the analyses presented in the Social Care
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
               
               
               
               #### About ------
               tabPanel("About",
                        h2("About Self-directed Support"),

                        p("Self-directed support (SDS) is the mainstream approach to social care in Scotland. 
                          It gives people control over an individual budget and allows them to choose how that 
                          money is spent on the support and services they need to meet their agreed health and 
                          social care outcomes. A guide to the Self-directed Support strategy 2010-2020 can be 
                          found ",
                          tags$a(href = "https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/",
                          "here.", class="externallink"), " "
                          ),
                        
                        p("People are counted separately for each self-directed support option they receive so may appear 
                          in more than one option. Therefore, options cannot be added together to get the total number of 
                          people receiving self-directed support. An Any SDS option has been provided for a total count of 
                          people going through SDS regardless of option."),
                        
                        p("In all cases the information relates to services and support where a Health and Social Care 
                          Partnership has an involvement, such as providing the care and support directly or by 
                          commissioning the care and support from other service providers. Data on care and support 
                          that is paid for and organised entirely by the persons themselves (i.e. 'self-funded') is 
                          not generally available and are excluded from all the analyses.")
                        
                        
               #### Data Definitions ----
               
               tabPanel("Definitions", 
                        
                        h2("Data Definitions"),
                        
                        p("The Source data definitions and guidance document can be found",
                          tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                 "here", class="externallink",
                                 ".")), 
                        p("This provides detailed information on Data Definitions used across all of the Social Care 
                          Insights Dashboards. Data Definitions relating specifically to the data presented throughout 
                          the Self-directed Support Dashboard can be found below."),
                        
                        tags$b("Methodology"),
                        p("The information provided below on the methods and definitions that have been used throughout 
                          this dashboard should be used to assist with interpretation of the results presented."),     
                        
                        tags$b("Data Sources"),
                        p(" ",
                          tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                 "Source Social Care Data")," "),
                        
                        tags$b("Financial Year"),
                        p("Data in this dashboard is available for financial years 2017/18 to 2020/21. A financial year 
                          covers the time period from the 1 April to the 31 March in the following year."),
                        p(
                          "Where trend information is presented in this dashboard, this includes data previously 
                          published by the Scottish Government in the Social Care Survey. 
                          Data ranging from 2014/15 to 2016/17 has been obtained from",
                          tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                                 "the Scottish Government Website.")
                        ),
                        
                        tags$b("Age Group"),
                        tags$ul(
                          tags$li("Where age information has been provided, age has been calculated at the midpoint of 
                                  the financial year, for example in 2020/21, age is calculated at 30 September 2020."),
                          tags$li("Age group breakdowns are available for some analysis in this dashboard. Where available 
                                  the options will include: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages. "),
                          tags$li("For a small number of people receiving support through self-directed support 
                                  it was not possible to calculate their age from the information provided. ‘All Ages’ 
                                  will therefore not equal the total of the individual age breakdowns.")
                          ),
                        
                        tags$b("Local Authorities and Health and Social Care Partnerships"),
                        
                        p("The information shown comes mainly from data gathered within Scotland’s 32 local authorities 
                          and is a by-product of many thousands of individual needs assessments carried out, personal 
                          choices made and care plans prepared and delivered."),
                        
                        p("Local authorities are one of the strategic partners in Health and Social Care along with Health 
                          Boards and Integration Authorities. For presentational reasons the label Health and Social Care 
                          Partnership is used throughout this dashboard (rather than local authority). Note: Reflecting 
                          variation across Scotland in the way partnership working occurs, the Stirling and Clackmannanshire 
                          Council analyses are shown separately although there is a single partnership involving both local 
                          authorities."),
                        
                        tags$b("Health and Social Care Partnership"),
                        tags$ul(
                          tags$li("Information is shown by the Health and Social Care Partnership (HSCP) funding the individual's 
                                  self-directed support package."),
                          tags$li("If a person received services/support from more than one Health and Social Care Partnership 
                                  during the reporting period, they will be counted for each partnership.")
                          ),
                        
                        tags$b("Scotland Terminology"),
                        tags$ul(
                          tags$li(" “Scotland” - Information was supplied by all partnerships in Scotland."),
                          tags$li(" “Scotland (Estimated)” - 	Estimates have been included for partnerships that have not 
                                  supplied the required data. "),
                          tags$li(" “Scotland (All Areas Submitted)” - This is the total of all areas that provided the 
                                  required information only. It will undercount the actual picture for Scotland as no 
                                  estimation has been done to produce a Scotland estimate.")
                        ),
                        
                         
                        tags$b("Self-directed Support Options"),
                        p("Self-directed support is the mainstream approach to social care in Scotland. It gives people 
                          control over an individual budget and allows them to choose how that money is spent on the 
                          support and services they need to meet their agreed health and social care outcomes.
                          "),
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
                        
                        tags$b("Self-directed support: Option 4"),
                        p("Figures for self-directed support Option 4 have been derived and apply to people who have chosen 
                          to receive their assessed support needs through more than one self-directed support option at any 
                          point during the financial years 2017/18 to 2020/21."),
                        
                        
                        tags$b("Self-directed support Need and Organisation"),
                        p("People may have more than one ‘support need’ assessed and/or receive this from more than one 
                          ‘support organisation’. As a result, a person could be included in more than one category."),
                        
                        tags$b("Assessed Support Needs"),              
                        p("This is where the type of support required is determined through
                          an outcomes based assessment. This includes any of the following:"),
                        tags$li("personal care"), 
                        tags$li("health care"), 
                        tags$li("domestic care"),
                        tags$li("housing support"),
                        tags$li("social, educational or recreational"),
                        tags$li("equipment and temporary adaptations"),
                        tags$li("respite"), 
                        tags$li("meals"), 
                        tags$li("and others"),
                        
                        br()

                        
                        ),
               
               
               #### Data Completeness ----
               
               tabPanel("Data Completeness",
                        h2("Data Completeness"),

                        tags$b("Disclosure Control"),
                        p("Statistical disclosure control has been applied to protect patient confidentiality. Therefore, the figures presented here may not be additive and may differ from previous publications. For further 
                 guidance see Public Health Scotland's",
                          tags$a(href = "https://www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf", 
                                 "Statistical Disclosure Control Protocol.")
                        ),
                        br(),
                        tags$b("Data Sources"),
                        p(" ",
                          tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/", 
                                 "Source Social Care Data")," "),
                        br(),
                        
                        tags$b("Self-directed Support Data Completeness Table"),
                        DT::dataTableOutput("data_completeness_table")
                        
                        
                        ), # end data completeness
               
               #### Resources ----
               
               tabPanel("Resources",
                        h2("Resources"),
                        
                        tags$b("Previous Self-directed Support releases and supporting documents"),
                        br(),
                        
                        p("2018/19 Social Care Insights Report:",
                          tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                 "2020-09-29-Social-Care-Report.pdf", class="externallink")),
                        
                        p("2018/19 Social Care Technical Document:",
                          tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                 "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/", class="externallink")),
                        
                        p("Social Care Definitions and Recording Guidance:",
                          tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",
                                 "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/Dataset/_docs/V1-4-Recording-guidance.pdf",  class="externallink")),
                        
                        p("2017/18 Social Care Insights Dashboard:",
                          tags$a(href="https://scotland.shinyapps.io/nhs-social-care/",
                                 "www.scotland.shinyapps.io/nhs-social-care/",  class="externallink")),
                        
                        p("Social Care Balance of Care:",
                          tags$a(href="https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",
                                 "https://beta.isdscotland.org/find-publications-and-data/health-and-social-care/social-and-community-care/insights-in-social-care-statistics-for-scotland/29-september-2020/",  class="externallink")),
                        
                        p("Disclosure Control Information:",
                          tags$a(href="https://publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",
                                 "www.publichealthscotland.scot/media/2707/public-health-scotland-statistical-disclosure-control-protocol.pdf",class="externallink")),
                        
                        p("Self-directed Support Strategy:",
                          tags$a(href="https://www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/",
                                 "www.gov.scot/publications/self-directed-support-strategy-2010-2020-implementation-plan-2019-21/", class="externallink")),
                        
                        
                        tags$b("Self-directed Support Resources"), 
                        br(),
                        
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
                        
                        p("Indicator of Relative Need (ioRN) Information:",
                          tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",
                                 "www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/",    class="externallink"))
                        
                        
                    

                        
                        )
               
               
               
               #### closing brackets -----
               
               ) # end info navlist panel left
             
                          ), # end info tab panel
    
    ############################################
    #### Tab 2: Self-directed support (SDS) ----
    ############################################
    
    tabPanel(
      "Self-directed support (SDS)",
      mainPanel(
        width = 12,
        
        # Within this section we are going to have a sub tab column on the left
        # To do this we are going to use the layout "navlistPanel()"
        
        navlistPanel(
          id = "sds_tabs_left",
          widths = c(2, 10),

        ############################################
        ## Tab 2.1: SDS Trend ----
        ##########################
          tabPanel(
            "Trend",
            h3("Trend in Self-directed Support Options"),
            
            p("The chart below shows the trend in the rate per 1,000 population 
              choosing self-directed support options from 2014/15 to 2020/21."),
            
          p("Two location dropdown menus have been provided to allow direct comparisons between 
            Health and Social Care Partnerships or against national figures."),
            
          p("Please use the 'Select Option Type' dropdown menu to change the self-directed support 
            option presented in the chart. The self-directed support options available are:"),
          tags$ul(
            tags$li("Option 1: Taken as a Direct Payment."),
            tags$li("Option 2: Allocated to an organisation that the 
                    person chooses and the person is in charge of how it is 
                    spent."),
            tags$li("Option 3: The person chooses to allow the council 
                    to arrange and determine their services."),
            tags$li("Option 4: The person can choose a mix of these 
                    options for different types of support.")
          ),
         
           
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Data prior to 2017/18 was sourced from the",
              tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                     "Social Care Survey"),
              "published by the Scottish Government."
            ),
            tags$li("Some Health and Social Care Partnerships were unable to provide SDS data,
                    therefore previous figures have been used to provide an estimated figure where possible.
                    Details of the estimated figure calculations can be found in the Information tab and 
                    in the", 
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf",
                           "Technical Document.")),
            tags$li("Please consider data completeness when interpreting data. Full details on 
                    data quality and completeness can be found in the Information tab under Data 
                    Completeness.")
          ),
          br(),

        ### dropdowns 
          
        wellPanel(
          
                column(6, shinyWidgets::pickerInput("sds_trend_location_input",
                                                          "Select Location:",
                                                          choices = unique(data_sds_trend$sending_location),
                                                          selected = "Scotland (Estimated)")),
                # comparison location dropdown  
                  
                column(6, shinyWidgets::pickerInput("sds_trend_location_comparator_input",
                                                      "Select Comparison Location:",
                                                      choices = unique(data_sds_trend$sending_location),
                                                      selected = "Scotland (Estimated)"))
                ), # end dropdown wellpanel 1
        
        wellPanel(          
                  # SDS Option dropdown
                  
                 column(6, shinyWidgets::pickerInput("sds_trend_option_input",
                                            "Select Option Type:",
                                            choices = unique(data_sds_trend$option_type),
                                            selected = "Option 1"))
                  
                  ), # end dropdown wellpanel 2
       
         br(),
        
            mainPanel(
              width = 12,
              
              ## show / hide table button and download data button
              
              # show / hide data button
              
              actionButton("sds_trend_showhide",
                           "Show/hide table",
                           style = button_style_showhide 
              ),
              
             
              # download data button
              
              downloadButton(
                outputId = "download_sds_trend_data",
                label = "Download data",
                class = "my_sds_trend_button"),
              
              tags$head(
                tags$style(paste0(".my_sds_trend_button ", button_background_col,
                                  ".my_sds_trend_button ", button_text_col, 
                                  ".my_sds_trend_button ", button_border_col))
                ),
              
              # data table to be shown / hidden
              
              hidden(
                div(
                  id = "sds_trend_table",
                  DT::dataTableOutput("sds_trend_table_output")
                )
              ),
              
             
              # insert space below buttons and before plot
              br(),
              br(),
              # insert trend plot 
              plotlyOutput("sds_trend_plot",
                           height = "550px")
              
            ) # end mainpanel
          ), # end tabpanel
      
        ###################################
        ## Tab 2.2: SDS Options Chosen ----
        ###################################
        
        tabPanel(
          "Options Chosen",
          h3("Self-directed Support - Options Chosen"),
          p("The chart below presents the rate per 1,000 people who chose each of the self-directed 
            support options within a selected financial year. The self-directed support options cannot be 
            added together to obtain the total number of people choosing self-directed support as people 
            can choose more than one option."),
          p("The self-directed support options available are:"),
          tags$ul(
            tags$li("Option 1: Taken as a Direct Payment."),
            tags$li("Option 2: Allocated to an organisation that the 
                    person chooses and the person is in charge of how it is 
                    spent."),
            tags$li("Option 3: The person chooses to allow the council 
                    to arrange and determine their services."),
            tags$li("Option 4: The person can choose a mix of these 
                    options for different types of support.")
            ),
          tags$b("Financial Year"),
          p("Financial year 2017/18 to 2020/21 can be selected from the dropdown menu below to show 
            data for the time period of interest."),
         
           tags$b("Age Group"),
          p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages."),
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("As the data prior to 2017/18 was sourced from the",
                    tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                           "Social Care Survey"),
                    "published by the Scottish Government, age breakdowns for this period are not avaliable.
                    To view the data for this period please select All Ages options"
            ),
            tags$li("Additionally, Any SDS was not reported prior to 2017/18 and therefore this data is not available."),
            tags$li("Some Health and Social Care Partnerships were unable to provide self-directed 
                    support information therefore Scotland (All Areas Submitted) has been provided. 
                    This is the sum of Health and Social Care Partnerships where data was provided."),
            tags$li("For more information on data completeness please refer to Data Completeness 
                    section of the Information tab and in the",
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf",
                                   "Technical Document.")),
            tags$li("Please consider data definitions and completeness when interpreting the data 
                    presented in this dashboard. Full details on data completeness and guidance can be 
                    found in the Information tab.")
            ),
          br(),
          
          #### drop down options
          
          wellPanel(
            
            column(6, shinyWidgets::pickerInput("sds_options_chosen_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_sds_options_chosen$financial_year),
                                                selected = "2020/21")),
            
            column(6, shinyWidgets::pickerInput("sds_options_chosen_location_input",
                                                "Select Location:",
                                                choices = unique(data_sds_options_chosen$sending_location),
                                                selected = "Scotland (All Areas Submitted)")),
            
            column(6, shinyWidgets::pickerInput("sds_options_chosen_age_group",
                                                "Age Group:",
                                                choices = unique(data_sds_options_chosen$age_group[data_sds_options_chosen$age_group != "Unknown"]),
                                                selected = "All Ages"))
            
            ), # end wellpanel 1
          
      
          br(),
          mainPanel(
            width = 12,
            
            ### show / hide data table and download button
            
            # show hide button
            
            actionButton("sds_options_chosen_showhide",
                         "Show/hide table",
                         style = button_style_showhide 
            ),
            
            # download data button
            
            downloadButton(
              outputId = "download_sds_options_chosen_data",
              label = "Download data",
              class = "my_sds_option_chosen_button"
            ),
            tags$head(
              tags$style(paste0(".my_sds_option_chosen_button ", button_background_col,
                                ".my_sds_option_chosen_button ", button_text_col, 
                                ".my_sds_option_chosen_button ", button_border_col))
            ),
            
            # data table to be shown / hidden
            
            hidden(
              div(
                id = "sds_options_chosen_table",
                DT::dataTableOutput("sds_options_chosen_table_output")
              )
            ),
            
            # space before plot output
            
            br(),
            br(),
            
              # insert plot
              
              plotlyOutput("sds_options_chosen_plot",
                           height = "500px")

                        ) # end mainpanel 

              ), # end tabpanel
          
        ###################################
        ## SDS Implementation by HSCP 
        ###################################
        
        tabPanel(
          
          "Implementation by HSCP",
          
          h3("Self-directed Support Implementation by Health and Social Care Partnership"),
          
          p("The graph below presents the percentage of people that received social care services 
            or support through self-directed support."),
          
          p("The implementation percentage provides an indicative value across the different areas 
            and this may vary depending on when the health and social care partnership started offering 
            self-directed support and on the speed of implementation. The methodology assumes certain 
            exclusions which are stated within the methodology section of the Technical Document."),
          
          
          tags$b("Financial Year"),
          p("Financial year 2017/18 to 2020/21 can be selected from the 
            dropdown menu below to show data for the time period of interest."),
          
          
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide SDS data,
                    therefore previous figures have been used to provide an estimated figure where possible.
                    Details of the estimated figure calculations can be found in the Information tab and 
                    in the", 
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf",
                                    "Technical Document.")),
            tags$li("Please consider data completeness when interpreting data. Full details on data 
                    quality and completeness can be found here.")
            ),
          br(),
          
          #### drop down options
          
          wellPanel(
            
            column(6, shinyWidgets::pickerInput("sds_implementation_hscp_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_sds_implementation_rate$financial_year),
                                                selected = "2020/21"))
            
          ), # end wellpanel 1
          

          br(),
          mainPanel(
            width = 12,
            
            ### show / hide data table and download button
            
            # show hide button

            actionButton("sds_implementation_hscp_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),

            # download data button
            
            downloadButton(
              outputId = "download_sds_implementation_hscp_data",
              label = "Download data",
              class = "my_sds_option_chosen_button_hscp"
            ),
            tags$head(
              tags$style(paste0(".my_sds_implementation_hscp_button", button_background_col,
                                ".my_sds_implementation_hscp_button", button_text_col, 
                                ".my_sds_implementation_hscp_button", button_border_col))
            ),
            
          #  data table to be shown / hidden

            hidden(
              div(
                id = "sds_implementation_hscp_table",
                DT::dataTableOutput("sds_implementation_hscp_table_output")
              )
            ),

          #  space before plot output
            
            br(),
            br(),
            
            # insert plot
            
            plotlyOutput("sds_implementation_hscp_plot",
                         height = "750px")
            
          ) # end mainpanel 
          
            ), # end tabpanel
        
        ###################################
        ## Implementation Trend
        ###################################
       
        tabPanel(
          "Implementation Trend",
          
          h3("Self-directed Support - Implementation Trend"),
          
          p("The graph below presents the percentage of people that received social care 
            services or support through self-directed support by year. "),

          p("The implementation percentage provides an indicative value across the different 
            areas and this may vary depending on when the health and social care partnership 
            started offering self-directed support and on the speed of implementation. The 
            methodology assumes certain exclusions which are stated within the methodology 
            section of the Technical Document."),
          
          tags$b("Health and Social Care Partnership"),
          p("Health and Social Care Partnership can be selected from the drop down provided 
            to view progression of implementation rate over time."),

          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide SDS data,
                    therefore previous figures have been used to provide an estimated figure where possible.
                    Details of the estimated figure calculations can be found in the Information tab and 
                    in the", 
                    tags$a(href = "https://publichealthscotland.scot/media/12845/2022-04-26-social-care-technical-document.pdf",
                           "Technical Document."))
            ),
          br(),

          ### dropdowns

          wellPanel(

            column(6, shinyWidgets::pickerInput("sds_implementation_location_input",
                                                "Select Location:",
                                                choices = unique(data_sds_implementation_rate$sending_location),
                                                selected = "Scotland (Estimated)")),
            # comparison location dropdown

            column(6, shinyWidgets::pickerInput("sds_implementation_comparator_location_input",
                                                "Select Comparison Location:",
                                                choices = unique(data_sds_implementation_rate$sending_location),
                                                selected = "Scotland (Estimated)"))
          ), # end dropdown wellpanel 1

          br(),

          mainPanel(
            width = 12,

            ## show / hide table button and download data button

            # show / hide data button

            actionButton("sds_implementation_showhide",
                         "Show/hide table",
                         style = button_style_showhide
            ),

            # # download data button

            downloadButton(
              outputId = "download_sds_implementation_data",
              label = "Download data",
              class = "my_sds_implementation_button"),

            tags$head(
              tags$style(paste0(".my_sds_implementation_button ", button_background_col,
                                ".my_sds_implementation_button ", button_text_col,
                                ".my_sds_implementation_button ", button_border_col))
            ),

            # # data table to be shown / hidden
            # 
            hidden(
              div(
                id = "sds_implementation_table",
                DT::dataTableOutput("sds_implementation_table_output")
              )
            ),

            # insert space below buttons and before plot
            br(),
            br(),
            # insert trend plot
            plotlyOutput("sds_implementation_plot",
                         height = "550px")

          ) # end mainpanel
            ), # end tabpanel
        ###################################################
        ## Tab 2.3: SDS Options Proportion by Age Group ----
        ####################################################
        
        tabPanel(
          
          "Options Only by Age Group",
          h3("Self-directed Support - Options Only by Age Group"),
          
          p("The chart below presents the percentage of people choosing the different self-directed support 
            options by age group. This helps illustrate the variation in option choices across different 
            age groups. "), 
          strong("Note in this analysis people are included under one option only."),
          
          p("Therefore, if someone chooses more than one self-directed support option to meet their needs 
            they would only be counted under option 4 (the person can choose a mix of these options for 
            different types of support). This is different to other analyses in this dashboard."),
          
          p("Every individual within an age group, for example all 18-64 year olds, who received self-directed 
            support during a financial year are assigned to only one self-directed support option type e.g. 
            Option 1 only. This means that the total of all the proportions within an age group will add to 
            100%."),
         
          p("The self-directed support options available are:"),
          tags$ul(
            tags$li("Option 1: Taken as a Direct Payment."),
            tags$li("Option 2: Allocated to an organisation that the 
                    person chooses and the person is in charge of how it is 
                    spent."),
            tags$li("Option 3: The person chooses to allow the council 
                    to arrange and determine their services."),
            tags$li("Option 4: The person can choose a mix of these 
                    options for different types of support.")
          ),
          
          tags$b("Financial Year"),
          p("Financial year 2017/18 to 2020/21 can be selected from the drop down below to show data for the 
            time period of interest."),
         
          tags$b("Data Completeness"),
          tags$ul(
            tags$li("Some Health and Social Care Partnerships were unable to provide self-directed support 
                    information therefore Scotland (All Areas Submitted) has been provided. This is the sum 
                    of Health and Social Care Partnerships where data was provided. For more information on 
                    data completeness please refer to Data Completeness section of the Information tab and 
                    in the Technical Document provided."),
            tags$li("Please consider data completeness when interpreting data. Full details on data 
                    quality and completeness can be in the Information tab under Data Completeness.")
          ),
          
          br(),

          ### drop down options
          
          wellPanel(
            
            column(6, shinyWidgets::pickerInput("sds_options_age_year_input",
                                                "Select Financial Year:",
                                                choices = unique(data_sds_options_proportion$financial_year),
                                                selected = "2020/21")),
            
            
             column(6, shinyWidgets::pickerInput("sds_options_age_location_input",
                                                "Select Location:",
                                                choices = unique(data_sds_options_proportion$sending_location),
                                                selected = "Scotland (All Areas Submitted)"))
          ),
          
          
          mainPanel(
            width = 12,
            
            ### show / hide data table and download button
            
            # show hide button
            
            actionButton("sds_options_age_showhide",
                         "Show/hide table",
                         style = button_style_showhide 
            ),
            
            # download data button
            
            downloadButton(
              outputId = "download_sds_options_age_data",
              label = "Download data",
              class = "sds_options_propn_button"
            ),
            tags$head(
              tags$style(paste0(".sds_options_propn_button ", button_background_col,
                                ".sds_options_propn_button ", button_text_col, 
                                ".sds_options_propn_button ", button_border_col))
            ),
            
            # data table to be shown / hidden
            
            hidden(
              div(
                id = "sds_options_age_table",
                DT::dataTableOutput("sds_options_age_table_output")
              )
            ),
            
            # space before plot output
            
            br(),
            br(),
            
            # insert plot
            
            plotlyOutput("sds_options_age_plot",
                         height = "500px")
            
              ) # end mainpanel 
          
            ), # end tabpanel
        
        ############################################
        ## Tab 2.4: SDS Client Group Profile ----
        ############################################
          
          tabPanel(
            "Social Care Client Group",
            h3("Self-directed Support - Social Care Client Group"),
            
            p("The chart below presents information on the rate per 1,000 self-directed support clients 
              (all options combined) by client grouping. It is possible for an individual to 
              be assigned to more than one client group, therefore figures across client groups cannot 
              be added together to give an overall total (because there will be double-counting)."),
            
            tags$b("Financial Year"),
            p("Financial year 2017/18 to 2020/21 can be selected from the dropdown menu below to show 
              data for the time period of interest."),
            
            tags$b("Age Group"),
            p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages."),
            
            tags$b("Client Group"),
            p("The category ‘Other’ within client group includes Drugs, Alcohol,
              Palliative Care, Carer, Neurological condition (excluding Dementia),
              Autism and Other Vulnerable Groups."),
            
            tags$b("Data Completeness"),
            tags$ul(
              tags$li("Some Health and Social Care Partnerships were unable to provide self-directed support 
                      information therefore Scotland (All Areas Submitted) has been provided. This is the sum 
                      of Health and Social Care Partnerships where data was provided. For more information on 
                      data completeness please refer to Data Completeness section of the Information tab and 
                      in the Technical Document provided."),
              tags$li("Please consider data completeness when interpreting data. Full details on data quality 
                      and completeness can be found in the Information tab under Data Completeness. ")
            ),
            
            ### drop downs
            
            ## wellpanel 1
            
            wellPanel(
              
              ## financial year dropdown
              
              column(6, shinyWidgets::pickerInput("sds_client_year_input",
                                                  "Select Financial Year:",
                                                  choices = unique(data_sds_client_group$financial_year),
                                                  selected = "2020/21")), 

              ## location dropdown
              
              column(6, shinyWidgets::pickerInput("sds_client_location_input",
                                                  "Select Location:",
                                                  choices = unique(data_sds_client_group$sending_location),
                                                  selected = "Scotland (All Areas Submitted)"
              ))
              
              ), # end wellpanel 1
              
            # wellpanel 2
            
              wellPanel(
              
              ## age dropdown
              
              
              
                column(6, shinyWidgets::pickerInput("sds_client_age_input",
                                                    "Select Age Group:",
                                                    unique(data_sds_client_group$age_group[data_sds_client_group$age_group != "Unknown"]),
                                                    selected = "All Ages")
                )
                
            ), # end wellpanel 2
            
            # insert space 
            
            br(),
            
            # create main panel to include buttons and plot
            
            mainPanel(
              width = 12,
              
              # show / hide data table button
              
              actionButton("sds_client_showhide",
                           "Show/hide table",
                           style = button_style_showhide 
              ),
              
              # download data button
              
              downloadButton(
                outputId = "download_sds_client_data",
                label = "Download data",
                class = "my_sds_client_type_button"
              ),
              tags$head(
                tags$style(paste0(".my_sds_client_type_button ", button_background_col,
                                  ".my_sds_client_type_button ", button_text_col, 
                                  ".my_sds_client_type_button ", button_border_col))
                ),
              
              # hidden data table 
              
              hidden(
                div(
                  id = "sds_client_table",
                  DT::dataTableOutput("sds_client_table_output")
                )
              ),
              
              # add empty space
              br(),
              br(),
              # insert plot 
              
              plotlyOutput("sds_client_plot",
                           height = "550px")
              
        
                        )  # end mainpanel
            ), # end tabpanel
          
        ############################################
        ## Tab 2.5: SDS Support/Service Needs ----
        ############################################
        
          
          tabPanel(
            "Support and Services Needs",
            h3("Self-directed Support - Social Care Support and Service Needs"),
            
            p("The chart below presents the rate per 1,000 self-directed support clients
              (all options combined) by the type of support that they have been assessed to need. The 
              different types of assessed support needs cannot be added together to create the total number 
              of people choosing support, as people can be assigned to more than one type of support need."),
            
            tags$b("Financial Year"),
            p("Financial year 2017/18 to 2020/21 can be selected from the dropdown menu below to show data for 
              the time period of interest."),
            
            tags$b("Age Group"),
            p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages."),
            
            tags$b("Data Completeness"),
            tags$ul(
              tags$li("Some Health and Social Care Partnerships were unable to provide self-directed support 
                      information therefore Scotland (All Areas Submitted) has been provided. This is the sum 
                      of Health and Social Care Partnerships where data was provided. For more information on 
                      data completeness please refer to Data Completeness section of the Information tab and 
                      in the Technical Document provided."),
              tags$li("Please consider data completeness when interpreting data. Full details on data quality 
                      and completeness can be found in the Information tab under Data Completeness.")
            ),
            br(),
            
            #### drop down options
           
            ## dropdown wellpanel 1
            
            wellPanel(
              
              
              column(6, shinyWidgets::pickerInput("sds_support_service_year_input",
                                                  "Select Financial Year:",
                                                  choices = unique(data_sds_support_needs$financial_year),
                                                  selected = "2020/21")),
              
              column(6, shinyWidgets::pickerInput("sds_support_service_location_input",
                                                          "Select Location:",
                                                          choices = unique(data_sds_support_needs$sending_location),
                                                          selected = "Scotland (All Areas Submitted)"))
              
              ), # end wellpanel 1
              
              ### dropdown wellpanel 2
              
            wellPanel(
            
              ### Age dropdown
              
               column(6, shinyWidgets::pickerInput("sds_support_service_age_input",
                                                   "Select Age Group:",
                                                   choices = unique(data_sds_support_needs$age_group[data_sds_support_needs$age_group != "Unknown"]),
                                                   selected = "All Ages"))

                      ), # end dropdown wellpanel 2
            
            # add space before buttons 
            
            br(),
            
            ## main panel containing buttons
            
            mainPanel(
              width = 12,
              
              # show / hide data table and download data buttone
              
              # show / hide table button
              
              actionButton("sds_support_service_showhide",
                           "Show/hide table",
                           style = button_style_showhide 
              ),
              
              
              # download button
              
              downloadButton(
                outputId = "download_sds_support_service_data",
                label = "Download data",
                class = "my_sds_support_need_button"
              ),
              tags$head(
                tags$style(paste0(".my_sds_support_need_button ", button_background_col,
                                  ".my_sds_support_need_button ", button_text_col, 
                                  ".my_sds_support_need_button ", button_border_col))
                ),
             
              #  data table to show / hide

              hidden(
                div(
                  id = "sds_support_service_table",
                  DT::dataTableOutput("sds_support_service_table_output")
                )
              ),
              
              # add space between buttons and plot
              
              br(),
              br(),
              # insert plot
              
               plotlyOutput("sds_support_service_plot",
                           height = "600px" )
              
              
              ) # end mainpanel

            ), # end tabpanel
          
        ############################################
        ## Tab 2.6: SDS Type of Organisation ----
        ############################################
        
          tabPanel(
            "Organisation Providing Support and Services",
            h3("Self-directed Support - Type of Organisation Providing Support and Services"),
            p("The chart below presents the rate per 1,000 self-directed support clients 
              (all options combined) by the type of organisation that provide 
              their support. It is possible for an individual to receive support from more than 
              one organisation, therefore figures across organisations cannot be added together 
              to obtain an overall total (because there will be double counting)."),
            
            tags$b("Financial Year"),
            p("Financial year 2017/18 to 2020/21can be selected from the dropdown menu below to 
              show data for the time period of interest."),
            
            tags$b("Age Group"),
            p("The data is available by age groups: 0-17, 18-64, 65-74, 75-84, 85+ and All Ages."),
            
            tags$b("Data Completeness"),
            tags$ul(
              tags$li("Some Health and Social Care Partnerships were unable to provide self-directed 
                    support information therefore Scotland (All Areas Submitted) has been provided. 
                    This is the sum of Health and Social Care Partnerships where data was provided. 
                    For more information on data completeness please refer to Data Completeness 
                    section of the Information tab."),
              tags$li("Please consider data definitions and completeness when interpreting the data 
                      presented in this dashboard. Full details on data completeness and guidance 
                      can be found in the Information tab and in the Technical Document provided.")
            ),
            br(),
            
            #### drop down options
            
           ### dropdown wellpanel 1
           
            wellPanel(
              
              
              column(6, shinyWidgets::pickerInput("sds_organisation_year_input",
                                                  "Select Financial Year:",
                                                  choices = unique(data_sds_type_of_organisation$financial_year),
                                                  selected = "2020/21")),
              
              column(6, shinyWidgets::pickerInput("sds_organisation_location_input",
                                                          "Select Location:",
                                                          choices = unique(data_sds_type_of_organisation$sending_location),
                                                          selected = "Scotland (All Areas Submitted)"))
              
              ), # end dropdown wellpanel 1
              
           # dropdown wellpanel 2
           
           wellPanel(
           
             
             column(6, shinyWidgets::pickerInput("sds_organisation_age_input",
                                                 "Select Age Group:",
                                                 choices = unique(data_sds_type_of_organisation$age_group[data_sds_type_of_organisation$age_group != "Unknown"]),
                                                 selected = "All Ages"))
          
               
                              ), # end wellpanel
                
           ## add space before buttons
           
            br(),

            # button & plot main panel
           
            mainPanel(
              width = 12,
              
              # show / hide data table and download buttons
              
              # show / hide table button
              
              actionButton("sds_organisation_showhide",
                           "Show/hide table",
                           style = button_style_showhide 
              ),

              # download buttons
              
              downloadButton(
                outputId = "download_sds_organisation_data",
                label = "Download data",
                class = "my_sds_organisation_button"
              ),
              tags$head(
                tags$style(paste0(".my_sds_organisation_button ", button_background_col,
                                  ".my_sds_organisation_button ", button_text_col, 
                                  ".my_sds_organisation_button ", button_border_col)
                           )
              ),
              
              
              # table to show / hide
              hidden(
                div(
                  id = "sds_organisation_table",
                  DT::dataTableOutput("sds_organisation_table_output")
                )
              ),
              
              # insert space between buttons and plot
              
              br(),
              br(),
              
              # insert plot
              
              plotlyOutput("sds_organisation_plot",
                           height = "500px")
            )
           

            ) # end tab panel 
          ) # end left navlist panel (sds summary tab)
      ) # end main panel
      ) # end SDS top panel
    
    
### ending brackets -----
      
  ) # end tabset panel across top
  
) # end fluidpage


#) # end secure_app function for password protect PRA
# comment out if not password protecting for PRA
