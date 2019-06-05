############################################################
### UI Script
### Author: Ciaran Harvey
### Orignal Date: 05/06/19
### Written/run on R Studio Server
### R version 3.2.3
### This script creates the user interface of the dashboard
############################################################

#load required packages

library(plotly)
library(dplyr)
library(shinyjs)
library(tidyr)
library(readr)
library(DT)
library(packcircles)
library(tidyverse)
library(shinydashboard)
library(dplyr)
library(leaflet)


###User Interface ----

ui <- fluidPage(
  useShinyjs(),
  
  #Hide any red text errors
  tags$head(
    tags$style(
      type = "text/css",
      
      ".shiny-output-error { 
      visibility: hidden; 
      }",

      ".shiny-output-error:before { 
      visibility: 
      hidden; }"
    )
    ),
  
  #The following code does 3 things
  #1. Paints the ribbon that contains tab headers white.
  #2. Changes colour of navlist panel text
  #3. Highlights the header of the active tab in blue.
  tags$style(
    HTML(".tabbable > .nav > li > a { 
         color: #000000; 
      }
         
         .nav-pills > li > a {
         color: #000000;
         }
         
         .tabbable > .nav > li[class = active] > a {
         background-color: #0072B2;
         color: #FFFFFF;
         }
         ")
    ),
  
  #We are going to split our UI in to discrete sections, called tab panels
  #To do this we need the layout "tabsetPanel"
  
  tabsetPanel(
    
    #### Tab 1: Introduction ----
    
    
    tabPanel(
      "Introduction",
      fluidRow(
        column(6, h3("Welcome to the Social Care Information Dashboard")),
        column(2, tags$img(src = "https://i.postimg.cc/026PX5zX/ISD-NSS-logos.png", height = "70px"), offset = 4)
      ),
      p(tags$b("RESTRICTED STATISTICS: embargoed to 09:30 11/06/2019", style = "color:red")),
      p(tags$b("How To Use The Dashboard")),
      p("Topics within the dashboard are listed at the top of the screen. Please 
        click on the topic to select this.When you select the topic you will be 
        presented with an introduction to the topic.The different analyses for 
        the topic are listed on the left hand side of the screen.Please click on 
        the analysis to select this."),
      p(
        "As well as the dashboard an accompanying pdf report is available, please",
        tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Publications/2019-06-11/2019-06-11-Social-Care-Report.pdf", "click here"),
        "to access this."
      ),
      tags$b("Download Data"),
      p(
        "To view your data selection in a table, use the 'Show/hide table' 
        button at the bottom of the page. To download your data selection as a 
        CSV file, use the 'Download data' button. At the top-right corner of the 
        graph, you will see a toolbar with buttons:"
      ),
      tags$ul(
        tags$li(
          tags$b("Download plot as a png"),
          
          icon("camera"),
          
          " - click this button to save the graph as an image"
        )
      ),
      tags$b("Source Social Care Data Collection"),
      p("This dashboard is organised to show statistics covering the broad 
        topics:"),
      tags$ul(
        tags$li("Self-directed support (SDS)"),
        tags$li("Home care"),
        tags$li("Community alarms/telecare"),
        tags$li("Care home residents")
      ),
      p("In all cases the information relates to services and support where a 
        Health and Social Care Partnership has an involvement, such as providing 
        the care and support directly or by commissioning the care and support 
        from other service providers.  Data on care and support that is paid for 
        and organised entirely by the persons themselves (i.e. "self-funded") is 
        not generally available and are excluded from all the analyses."),
      p(
        "The Source data definitions and guidance document can be found ",
        tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/docs/Revised-Source-Dataset-Definitions-and-Recording-Guidance-March-2018.pdf", "here")
      ),
      tags$b("Data Completeness"),
      p("All data in this extract has been through detailed validation and 
        quality checking to ensure the accuracy of the data. The following 
        should be noted:"),
      tags$ul(
        tags$li("Some partnerships were unable to provide individual level 
                information for specific topics or data items.  Where possible 
                aggregated data has been provided and this will be highlighted 
                within the dashboard."),
        tags$li("Although data is available for Glasgow City only aggregated 
                data was available rather than individual level data and this 
                means that for some analyses they will be excluded. Where this 
                was the case this will be highlighted in both the text and in 
                the dashboard.")
        ),
      p("Attempts have been made to minimise the effects of these data issues.  
        In both the report and the dashboard, estimates have been provided for 
        top level trends to enable a Scotland figure to be calculated for 
        comparison purposes. Estimates have not been used for the more detailed 
        analysis."),
      p("Appendices within the report and a separate technical document 
        provide further details of data completeness for each health and social 
        care partnership within each topic."),
      p("Experimental statistics are official statistics which are published in 
        order to involve users and stakeholders in their development and as a 
        means to build in quality at an early stage. It is important that users 
        understand that limitations may apply to the interpretation of this data"),
      tags$b("Data Sources"),
      p("Source Social Care Data"),
      p("SMR01 hospital discharge records"),
      tags$b("Screen Resolution"),
      p("For optimum resolution we recommend a resolution of 1024x768 or greater. 
        This can be done via the control panel on your computer settings."),
      tags$b("Contact Us"),
      p("If you experience any problems using this dashbord or have further 
        questions relating to the data, please contact us at", 
        tags$a(href = "mailto:nss.source@nhs.net", "nss.source@nhs.net"))
      ),
    
    
    ### Tab 2: Self Directed Support (SDS) ----
    
    
    tabPanel(
      "Self-directed support (SDS)",
      mainPanel(
        width = 12,
        
        # Within this section we are going to have a sub tab column on the left
        # To do this we are going to use the layout "navlistPanel()"
        
        navlistPanel(
          id = "SDS_Tab_Box",
          widths = c(2, 10),
          
          
          ## Tab 2.1: SDS Introduction ----
          
          
          tabPanel(
            "Introduction",
            h3("Self-directed support (SDS) - Introduction"),
            p(
              "Self-directed support was introduced in Scotland on the 1 April 
              2014 following the Social Care Self-directed Support Scotland Act 
              2013. Its introduction means that people receiving social care 
              support in Scotland have the right to choice, control and 
              flexibility to meet their personal outcomes. Health and social 
              care partnerships are required to ensure that people are offered a 
              range of choices on how they receive their social care support. 
              The options available are:",
              tags$ul(
                tags$li("SDS Option 1: Taken as a Direct Payment."),
                tags$li("SDS Option 2: Allocated to an organisation  that the 
                        person chooses and the person is in charge of how it is 
                        spent."),
                tags$li("SDS Option 3: The person chooses to allow the council 
                        to arrange and determine their services."),
                tags$li("SDS Option 4: The person can choose a mix of these 
                        options for different types of support.")
                )),
            p("Further details about Self-directed support are available",
              tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/docs/Revised-Source-Dataset-Definitions-and-Recording-Guidance-March-2018.pdf", "here"),
              "."
            ),
            p("The information presented here are compiled from individual level 
              data for all people who received self-directed support during financial year 2017/18. 
              A trend analysis is also shown."),
            p(
              tags$b("Notes:"),
              tags$ul(
                tags$li("People are counted separately for each self-directed support option they 
                        receive so may appear in more than one option. Therefore, 
                        options cannot be added together to get the total number 
                        of people receiving self-directed support."),
                tags$li(
                  "Trend information in this section includes data previously 
                  published by the Scottish Government as part of the Social Care 
                  Survey publication. Data from 2007/08 to 2016/17 has been 
                  obtained from",
                  tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                         "the Scottish Government website")
                ),
                tags$li("Figures for Option 4 have been derived for people who 
                        have received more than one self-directed support option at any point 
                        during the financial year 2017/18.")
                )
                ),
            p(
              tags$b("Data completeness"),
              br(),
              "Fife HSCP was unable to provide self-directed support information 
              for 2017/18. Comhairle nan Eilean Siar HSCP could not provide 
              information of those receiving a service by way of Self-directed 
              support Option 3."
            ),
            p(
              tags$b("Disclosure Control"),
              br(),
              "* indicates values that have been suppressed due to the potential 
              risk of disclosure and to help maintain confidentiality. For 
              further guidance see ISD's ",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                     "Statistical Disclosure Control Protocol.")
            )
              ),
          
          
          ## Tab 2.2: SDS Trend in Direct Payments ----
          
          
          tabPanel(
            "Trend in Direct Payments (SDS Option 1)",
            h3("Trend in Direct Payments (SDS Option 1)"),
            p("The chart below presents the number of people choosing direct 
              payments (self-directed support Option 1) from 2007/08 to 2017/18."),
            p(
              "It should be noted that data prior to 2017/18 was sourced from the ",
              tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                     "Social Care Survey"),
              "published by the Scottish Government."
            ),
            tags$b("Data Completeness"),
            p(
              "Fife HSCP was unable to provide self-directed support information for 2017/18. In 
              order to present trend information at Scotland level Fife HSCP has 
              been assumed to have the same number of people choosing direct 
              payments in 2017/18 as were reported in the 2016/17",
              tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                     "Social Care Survey.")
            ),
            wellPanel(column(6, shinyWidgets::pickerInput("SDSPartnership2Input",
                                                          "Select Location:",
                                                          choices = unique(data_SDS_trend$sending_location),
                                                          selected = "Scotland"
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_SDS_trend",
                label = "Download data",
                class = "mySDStrendbutton"
              ),
              tags$head(
                tags$style(".mySDStrendbutton { background-color: #0072B2; } 
                           .mySDStrendbutton { color: #FFFFFF; }")
                ),
              plotlyOutput("SDSTrend"),
              br(),
              actionButton("SDSbutton3",
                           "Show/hide table",
                           style = "color: #fff; 
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "SDSTrendtable",
                  DT::dataTableOutput("table_SDS_trend")
                )
              )
            )
          ),
          
          
          ## Tab 2.2: SDS Direct Payments ----
          
          
          tabPanel(
            "SDS Direct Payments - Rate Per 1,000 Population",
            h3("SDS Direct Payments - Rate Per 1,000 Population"),
            p("This chart below presents information on the number of people 
              receiving direct payments (self-directed support option 1) 
              expressed as a rate per 1,000 population (2017 mid-year estimates)."),
            tags$b("Data Completeness"),
            p("Fife HSCP was unable to provide 2017/18 SDS information and 
              therefore the Fife 2016/17 Social Care Survey figure has been 
              used to obtain the Scotland rate."),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_SDS_directpayment",
                label = "Download data",
                class = "mySDSdirectpaymentbutton"
              ),
              tags$head(
                tags$style(".mySDSdirectpaymentbutton { 
                           background-color: #0072B2; 
                           } 
                           .mySDSdirectpaymentbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("SDSDirectPayments",
                           height = "500px"
              ),
              br(),
              br(),
              actionButton("SDSbutton2",
                           "Show/hide table",
                           style = "color: #fff; 
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "SDSDirectPaymentstable",
                  DT::dataTableOutput("table_SDS_directpayment")
                )
              )
                )
              ),
          
          
          ## Tab 2.3: SDS Options Chosen ----
          
          
          tabPanel(
            "SDS Options Chosen",
            h3("SDS Options Chosen"),
            p("This section presents information on the number of people 
              choosing each of the self-directed support options in financial 
              year 2017/18. The self-directed support options cannot be added 
              together to obtain the total number of people choosing self directed 
              support as people can choose more than one option."),
            tags$ul(
              tags$li("SDS Option 1: Taken as a Direct Payment."),
              tags$li("SDS Option 2: Allocated to an organisation  that the 
                      person chooses and the person is in charge of how it is 
                      spent."),
              tags$li("SDS Option 3: The person chooses to allow the council 
                      to arrange and determine their services."),
              tags$li("SDS Option 4: The person can choose a mix of these 
                      options for different types of support.")
              ),
            tags$b("Data Completeness"),
            p("Fife HSCP was unable to provide 2017/18 self-directed support information and is therefore 
              excluded from this analysis. Glasgow City HSCP were unable to 
              provide client level information therefore option 4 figures could 
              not be derived. Comhairle nan Eilean Siar HSCP could not provide 
              information of those receiving a service by way of SDS Option 3. 
              To reflect this an 'All Areas Submitted' total is provided rather 
              than a Scotland figure as it would be underestimated."),
            tags$b("Age Band"),
            p("Due to small numbers, and to minimise the risk of identification 
              of individuals, age band can only be selected when then the 
              'All Areas Submitted' total is selected."),
            wellPanel(
              column(6, shinyWidgets::pickerInput("SDSPartnership5Input",
                                                  "Select Location:",
                                                  choices = unique(data_SDS_options_chosen$sending_location),
                                                  selected = "Scotland"
              )),
              column(6, uiOutput("SDSAge2Input"))
            ),
            downloadButton(
              outputId = "download_SDSOptionLA_totals",
              label = "Download data",
              class = "mySDSOptionLAbutton"
            ),
            tags$head(
              tags$style(".mySDSOptionLAbutton { 
                         background-color: #0072B2; 
                         } 
                         .mySDSOptionLAbutton { 
                         color: #FFFFFF; 
                         }")
            ),
            br(),
            mainPanel(
              width = 12,
              plotlyOutput("SDSOptionLA")
            ),
            br(),
            actionButton("SDSoptionsbutton",
                         "Show/hide table",
                         style = "color: #fff; 
                         background-color:#2171b5; 
                         border-color: #636363"
            ),
            hidden(
              div(
                id = "SDSOptionstable",
                DT::dataTableOutput("table_SDS_options")
              )
            )
              ),
          
          
          ## Tab 2.4: SDS Client Group Profile ----
          
          
          tabPanel(
            "SDS - Client Group Profile",
            h3("SDS - Client Group Profile"),
            p("The chart below presents information on the number of people 
              receiving self-directed support (all options combined) by client 
              grouping. It is possible for people to be assigned to more than 
              one client group; therefore figures across client groups cannot 
              be added together to give an overall total (because there will 
              be double-counting)."),
            tags$b("Data Completeness"),
            p("Glasgow City and Fife HSCPs could not provide individual level 
              information for self-directed Support and are excluded from this 
              analysis. Comhairle nan Eilean Siar HSCP could not provide 
              information of those receiving a service by way of SDS Option 3. 
              To reflect this an 'All Areas Submitted ' total is provided rather 
              than a Scotland total as it would be underestimated."),
            tags$b("Age Band"),
            p("Due to small numbers, and to minimise the risk of identification 
              of individuals, age band can only be selected when then the 
              'All Areas Submitted' option is selected."),
            tags$b("Client Group"),
            p("The category 'Other' within client group includes Drugs, Alcohol, 
              Palliative Care, Carer, Neurological condition (excluding Dementia), 
              Autism and Other Vulnerable Groups."),
            wellPanel(
              column(6, shinyWidgets::pickerInput("SDSPartnership3Input",
                                                  "Select Location:",
                                                  choices = unique(data_SDS_client_group$sending_location),
                                                  selected = "Scotland"
              )),
              column(6, uiOutput("SDSAge3Input"))
            ),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_SDS_clienttype",
                label = "Download data",
                class = "mySDSclienttypebutton"
              ),
              tags$head(
                tags$style(".mySDSclienttypebutton { 
                           background-color:#0072B2; 
                           } 
                           .mySDSclienttypebutton { 
                           color: #FFFFFF; }")
                ),
              plotlyOutput("SDSClientType",
                           height = "500px"
              )
              ),
            br(),
            actionButton("SDSClientTypebutton",
                         "Show/hide table",
                         style = "color: #fff; 
                         background-color:#2171b5; 
                         border-color: #636363"
            ),
            hidden(
              div(
                id = "SDSClientTypetable",
                DT::dataTableOutput("table_SDS_clienttype")
              )
            )
            ),
          
          
          ## Tab 2.5: SDS Support/Services ----
          
          
          tabPanel(
            "SDS - Support/Services Needs Assessed",
            h3("SDS - Support/Services Needs Assessed"),
            p("This chart below presents information on the number of people 
              choosing self directed support (all options combined) by the type 
              of support that it was assessed that they need. The different types 
              of assessed support needs cannot be added together to create the 
              total number of people choosing support, as people can be assigned 
              to more than one type of support need."),
            tags$b("Data Completeness"),
            p("Glasgow City and Fife HSCPs could not provide individual level 
              information for self-directed support and are excluded from this 
              analysis. Comhairle nan Eilean Siar HSCP could not provide 
              information of those receiving a service by way of SDS Option 3. 
              To reflect this an 'All Areas Submitted'  total is provided rather 
              than a Scotland total as it would be underestimated."),
            wellPanel(column(6, shinyWidgets::pickerInput("SDSPartnership4Input",
                                                          "Select Location:",
                                                          choices = unique(data_SDS_support_services$sending_location),
                                                          selected = "Scotland"
            ))),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_SDS_supportneed",
                label = "Download data",
                class = "mySDSsupportneedbutton"
              ),
              tags$head(
                tags$style(".mySDSsupportneedbutton { 
                           background-color: #0072B2; 
                           } 
                           .mySDSsupportneedbutton { 
                           color: #FFFFFF; }")
                ),
              plotlyOutput("SDSSupport",
                           height = "500px"
              )
              ),
            br(),
            actionButton("SDSSupportNeedbutton",
                         "Show/hide table",
                         style = "color: #fff; 
                         background-color:#2171b5; 
                         border-color: #636363"
            ),
            hidden(
              div(
                id = "SDSSupportNeedtable",
                DT::dataTableOutput("table_SDS_supportneed")
              )
            )
            ),
          
          
          ## Tab 2.6: SDS Type of Organisation ----
          
          
          tabPanel(
            "SDS - Type Of Organisation Providing Support/Services",
            h3("SDS - Type Of Organisation Providing Support/Services"),
            p("This chart presents information on the number of people choosing 
              self-directed support (all options combined) by the type of 
              organisation providing the support. It is possible for people to 
              receive support from more than one organisation; therefore figures 
              across organisations cannot be added together to obtain an overall 
              total (because there will be double counting)."),
            tags$b("Data Completeness"),
            p("Glasgow City and Fife HSCPs could not provide individual level 
              information for self-directed support and are excluded from this 
              analysis. Comhairle nan Eilean Siar HSCP could not provide 
              information of those receiving a service by way of SDS Option 3. 
              To reflect this an 'All Areas Submitted' total is provided rather 
              than a Scotland total as it would be underestimated."),
            wellPanel(column(6, shinyWidgets::pickerInput("SDSPartnership6Input",
                                                          "Select Location:",
                                                          choices = unique(data_SDS_type_of_organisation$sending_location),
                                                          selected = "Scotland"
            ))),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_SDS_supportmechanism",
                label = "Download data",
                class = "mySDSsupportmechanismbutton"
              ),
              tags$head(
                tags$style(".mySDSsupportmechanismbutton { 
                           background-color: #0072B2; 
                           } 
                           .mySDSsupportmechanismbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("SDSMechanism")
                ),
            br(),
            actionButton("SDSSupportMechanismbutton",
                         "Show/hide table",
                         style = "color: #fff; 
                         background-color:#2171b5; 
                         border-color: #636363"
            ),
            hidden(
              div(
                id = "SDSSupportMechanismtable",
                DT::dataTableOutput("table_SDS_supportmechanism")
              )
            )
              )
              )
            )
    ),
    
    
    ### Tab 3: Home Care ----
    tabPanel(
      "Home Care",
      mainPanel(
        width = 12,
        
        # Within this section we are going to have a sub tab column on the left
        # To do this we are going to use the layout "navlistPanel()"
        
        navlistPanel(
          id = "HomeCare_Tab_Box",
          widths = c(2, 10),
          
          
          ## Tab 3.1: Home Care Introduction ----
          
          
          tabPanel(
            "Introduction",
            h3("Home Care"),
            p(
              "The information in this section is about people who have been 
              supported to meet their assessed social care needs within their 
              own home (includes sheltered housing and equivalent accommodation). 
              For statistical purposes the term 'Home Care' includes personal 
              care of the person and a wide range of practical services (termed 
              'non-personal care' in the charts) which assist a person to function 
              as independently as possible in their own home. Such tasks may involve 
              housework, shopping, laundry and/or paying bills. Not included here 
              are 'live in' and 24 hour services that are defined as Housing 
              Support services in this dashboard. Note: Although the term Home 
              Care is used in this publication a broadly equivalent widely used 
              term is 'Care at Home'. (For further information please see Home 
              Care section of",
              tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/docs/Revised-Source-Dataset-Definitions-and-Recording-Guidance-March-2018.pdf", 
                     "definitions and guidance document).")
              ),
            p("Due to the restrictions in the way that the data were collected 
              nationally for 2017/18 the home care figures are only available 
              for the period 1 January 2018 - 31 March 2018. In future years it 
              is expected that annual figures will be available."),
            tags$b("Notes"),
            tags$ul(
              tags$li("To allow comparison with figures previously published by 
                      the Scottish Government an estimated number of home care 
                      hours has been calculated for a "census week" (last week 
                      in March - 25 March 2018 to 31 March 2018). The home care
                      hours were estimated by calculating the average number 
                      of hours per day for each individual.  This was then 
                      multiplied by the number of days the person received home 
                      care in the "census week"."),
              tags$li(
                "Trend information in this section includes data previously 
                published by the Scottish Government as part of the Social Care 
                Survey publication. Data from 2009/10 to 2016/17 has been 
                obtained from",
                tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                       "Scottish Government website.")
              ),
              tags$li("Hours are based on planned hours unless otherwise 
                      stated."),
              tags$li("Information is shown by the Health and Social Care 
                      Partnership funding the package of care (fully or 
                      partially). The home care client could live outside the 
                      HSCP boundary.")
              ),
            p("This section also contains information on acute emergency 
              admissions to hospital for people who are receiving home care. 
              Notes on this analysis are provided below."),
            tags$b("Linkage of home care data to Health Care datasets notes:"),
            tags$ul(
              tags$li("This information has been linked via the CHI number of 
                      the patient/client. The CHI number was derived on 
                      submission of the social care data. Where it was not 
                      possible to obtain CHI information, these records were 
                      excluded from the linked health care measures in this 
                      section."),
              tags$li("Home care individual level information has been linked to 
                      acute hospital data (Data Source SMR01) to obtain 
                      information on emergency hospital admissions and bed day 
                      rates for people receiving home care."),
              tags$li("Glasgow City HSCP was unable to submit individual level 
                      data and has been excluded from the linked analyses."),
              tags$li("The health activity data (emergency admission to hospital) 
                      considered within this analysis relates to the time period 
                      each individual received home care between 1 January 2018 
                      and 31 March 2018. The emergency admissions could have been 
                      to any hospital in NHS Scotland."),
              tags$li("The denominator used in the calculation of emergency 
                      hospital admission and bed day rates is the number of 
                      people with an active home care service on the 31 March 
                      2018.")
              ),
            tags$b("Disclosure Control"),
            p(
              "* indicates values that have been suppressed due to the potential 
              risk of disclosure and to help maintain confidentiality. For further 
              guidance see ISD's",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                     "Statistical Disclosure Control Protocol", ".")
            ),
            tags$b("Data Sources"),
            p(
              "ISD Source Social Care Data",
              br(),
              "SMR01 hospital discharge records"
            )
              ),
          
          
          ## Tab 3.2: Trend in Home Care Numbers and Hours ----
          
          
          tabPanel(
            "Trend in Home Care Numbers and Hours",
            h3("Trend in Home Care Numbers and Hours"),
            wellPanel(
              style = "overflow-y:scroll; 
              max-height: 250px;
              padding: 0px",
              p("This section provides information on the number of people who 
                received home care during a "census week" for 2010 to 2018."),
              p(
                "Information prior to 2018 was obtained from the",
                tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                       "Social Care Survey"),
                "published by the Scottish Government. To allow comparison to be 
                made with figures from earlier years this analysis uses estimated 
                home care hours for a "census week" for 2018 (25 March 2018 to 
                31 March 2018) see the introduction for more information."
              ),
              tags$b("Home Care Hours"),
              p("In 2018 home care hours are based on planned hours except for: 
                East Lothian, Falkirk and North Lanarkshire HSCPs who provided 
                actual hours. This should be taken into consideration if 
                comparing the information for Health and Social Care 
                partnerships."),
              p("Figures prior to 2017/18 include a mixture of planned and 
                actual hours."),
              tags$b("Data Completeness"),
              p(
                "Midlothian, Moray and North Ayrshire HSCPs were unable to 
                provide home care hours data for the 2017/18. In order to present 
                trend information at Scotland level these areas have been assumed 
                to have the same level of home care as was reported in 2016/17",
                tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                       "Social Care Survey"),
                ". It should also be noted that Angus 2016/17 data is based on 
                2015/16 as this could not be provided to the Scottish Government 
                survey. This should be taken into account when interpreting the 
                trend information."
              ),
              tags$b("Note"),
              p("Within the table and chart the total number of hours has been 
                rounded to the nearest hour.")
              ),
            wellPanel(column(6, shinyWidgets::pickerInput("PartnershipHC1Input",
                                                          "Select Location:",
                                                          choices = unique(data_homecare_trend$sending_location),
                                                          selected = "Scotland"
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_trend",
                label = "Download data",
                class = "mytrendbutton"
              ),
              tags$head(
                tags$style(".mytrendbutton { 
                           background-color: #0072B2; 
                           } 
                           .mytrendbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              fluidRow(
                column(6, plotlyOutput("Trend",
                                       height = "450px"
                )),
                column(6, plotlyOutput("Trend2",
                                       height = "450px"
                ))
              ),
              br(),
              br(),
              actionButton("HCtrendbutton",
                           "Show/hide table",
                           style = "color: #fff; 
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCtrendtable",
                  DT::dataTableOutput("table_HC_trend")
                )
              )
                )
            ),
          
          
          ## Tab3.3: Home Care Numbers and Hours by Locality ----
          
          
          tabPanel(
            "Home Care Numbers and Hours by Locality",
            h3("Home Care Numbers and Hours by Locality"),
            p("The chart below presents information on the number of people 
              receiving home care and the number of hours home care received by 
              locality between January - March 2018."),
            tags$b("Home Care Hours and Data Completeness"),
            p("Home care hours are based on planned hours except for: East 
              Lothian, Falkirk and North Lanarkshire HSCPs who provided actual 
              hours. This should be taken into consideration if comparing the 
              information for Health and Social Care partnerships."),
            p("Midlothian, Moray and North Ayrshire HSCPs were unable to provide 
              home care hours data for the 2017/18 and are excluded from the 
              chart."),
            p("To reflect this an 'All Areas Submitted' total is provided rather 
              than a Scotland figure as it would be underestimated."),
            tags$b("Additional notes for chart:"),
            tags$ul(
              tags$li("Locality has been derived using 2011 data zones and the 
                      client postcode provided by HSCPs."),
              tags$li("Outside partnerships represents people with a permanent 
                      residence in localities outside the boundary of the funding 
                      partnership."),
              tags$li("A locality breakdown was not provided by Glasgow City HSCP 
                      therefore all people receiving home care will appear under 
                      'unknown'."),
              tags$li("For the 'All Areas Submitted' chart all people receiving 
                      home care will appear under 'unknown'.")
              ),
            wellPanel(
              column(6, shinyWidgets::pickerInput("PartnershipHC2Input",
                                                  "Select Location:",
                                                  choices = unique(data_homecare_locality$sending_location),
                                                  selected = "All Areas Submitted"
              )),
              column(6, selectInput("MeasureHCInput",
                                    "Select Measure",
                                    choices = unique(data_homecare_locality$Measure)
              ))
            ),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_locality",
                label = "Download data",
                class = "mylocalitybutton"
              ),
              tags$head(
                tags$style(".mylocalitybutton { 
                           background-color: #0072B2; 
                           } 
                           .mylocalitybutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("HCLocality"),
              br(),
              actionButton("HClocalitybutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HClocalitytable",
                  DT::dataTableOutput("table_HC_locality")
                )
              )
                )
              ),
          
          
          ## Tab 3.4: Client Groups Receiving Home Care ----
          
          
          tabPanel(
            "Client Groups Receiving Home Care",
            h3("Client Groups Receiving Home Care"),
            p("The chart below presents information on people receiving home 
              care during the estimated "census week" for 2018 (25 March 2018 to 
              31 March 2018) showing the different client groups. It is possible 
              for someone to be included in more than one client group; therefore 
              figures across client groups cannot be added to reach the total 
              number of people."),
            p("There is a difference in the level of information provided by 
              different areas. For example, some areas only recorded the main 
              client group, some areas did not have information for every client 
              group."),
            tags$b("Data Completeness"),
            p("Glasgow City HSCP could not provide individual level information 
              for home care and are excluded from this chart. To reflect this an 
              'All Areas Submitted' total is provided rather than a Scotland 
              total as it would be underestimated."),
            tags$b("Age Band"),
            p("Due to small numbers, and to minimise the risk of identification 
              of individuals, age band can only be selected when then the 'All 
              Areas Submitted' option is selected."),
            tags$b("Client Group"),
            p("The category 'Other' within client group includes Drugs, Alcohol, 
              Palliative Care, Carer, Neurological condition (excluding Dementia), 
              Autism and Other Vulnerable Groups."),
            wellPanel(
              column(6, shinyWidgets::pickerInput("PartnerhshipHC3Input",
                                                  "Select Location:",
                                                  choices = unique(data_homecare_client_group$sending_location),
                                                  selected = "Scotland"
              )),
              column(6, uiOutput("AgeHCInput"))
            ),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_clienttype",
                label = "Download data",
                class = "myclienttypebutton"
              ),
              br(),
              br(),
              tags$head(
                tags$style(".myclienttypebutton { 
                           background-color: #0072B2; 
                           } 
                           .myclienttypebutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("HCClients",
                           height = "500px"
              ),
              br(),
              actionButton("HCClientsbutton",
                           "Show/hide table",
                           style = "color: #fff; 
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCClientstable",
                  DT::dataTableOutput("table_HC_clients")
                )
              )
                )
            ),
          
          
          ## Tab 3.5: Service Providers of Home Care ----
          
          
          tabPanel(
            "Service Providers of Home Care",
            h3("Service Providers of Home Care"),
            p("The chart below presents information on people receiving home 
              care during the estimated "census week" for 2018 (25 March 2018 to 
              31 March 2018) by the organisation that provides the service for 
              the Health and Social Care Partnership. It is possible for an 
              individual to receive services from more than one type of 
              organisation and this is reflected in the categories shown in the 
              chart."),
            tags$b("Age Band"),
            p("Due to small numbers, and to minimise the risk of identification 
              of individuals, age band can only be selected when then the 
              Scotland option is selected."),
            wellPanel(
              column(6, shinyWidgets::pickerInput("PartnershipHC8Input",
                                                  "Select Location:",
                                                  choices = unique(data_homecare_service_providers$sending_location),
                                                  selected = "Scotland"
              )),
              column(6, uiOutput("AgeBandHCZInput"))
            ),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_serviceprovider",
                label = "Download data",
                class = "myhomecareserviceproviderbutton"
              ),
              br(),
              br(),
              tags$head(
                tags$style(".myhomecareserviceproviderbutton { 
                           background-color: #0072B2; } 
                           .myhomecareserviceproviderbutton { 
                           color: #FFFFFF; }")
                ),
              fluidRow(column(6, plotlyOutput("HCServiceProvider",
                                              height = "500px",
                                              width = "750px"
              ), offset = 1)),
              br(),
              actionButton("HCServiceProviderbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCServiceProvidertable",
                  DT::dataTableOutput("table_HC_serviceprovider")
                )
              )
              )
            ),
          
          
          ## Tab 3.6: Home Care Hours Received ----
          
          
          tabPanel(
            "Home Care Hours Received",
            h3("Home Care Hours Received"),
            p("This section provides information on the estimated number of home 
              care hours received by home care clients within the "census week" 
              for 2018 (25 March 2018 to 31 March 2018). The hours used in this 
              section are the groupings which widely used and reported in the 
              previous Scottish Government social care survey publication."),
            tags$b("Home Care Hours and Data Completeness"),
            p("Home care hours are based on planned hours except for: 
              East Lothian, Falkirk and North Lanarkshire HSCPs who provided 
              actual hours. This should be taken into consideration if comparing 
              the information for Health and Social Care Partnerships."),
            p("Midlothian, Moray and North Ayrshire HSCPs were unable to provide 
              home care hours data for the 2017/18 and are excluded from the 
              chart."),
            p("To reflect these issues an 'All Areas Submitted' total is provided 
              rather than a Scotland figure as it would be underestimated."),
            tags$b("Age Band"),
            p("Due to small numbers, and to minimise the risk of identification 
              of individuals, age band can only be selected when the 
              'All Areas Submitted' option is selected."),
            wellPanel(
              column(6, shinyWidgets::pickerInput("PartnerhshipHC3BInput",
                                                  "Select Location:",
                                                  choices = unique(data_homecare_hours_received$sending_location),
                                                  selected = "Scotland"
              )),
              column(6, uiOutput("AgeHCBInput"))
            ),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_levelofservice",
                label = "Download data",
                class = "mylevelofservicebutton"
              ),
              tags$head(
                tags$style(".mylevelofservicebutton { 
                           background-color: #0072B2; 
                           } 
                           .mylevelofservicebutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("HCLevelofservice",
                           height = "500px"
              ),
              br(),
              actionButton("HCLevelofservicebutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCLevelofservicetable",
                  DT::dataTableOutput("table_HC_levelofservice")
                )
              )
                )
            ),
          
          
          ## Tab 3.7: Home Care Hours Distribution ----
          
          
          tabPanel(
            "Home Care Hours Distribution",
            h3("Home Care Hours Distribution"),
            p("This section provides information on the estimated number of home 
              care hours received by home care clients within the "census week" 
              for 2018 (25 March 2018 to 31 March 2018)."),
            tags$b("Home Care Hours and Data Completeness"),
            p("Home care hours are based on planned hours except for: East 
              Lothian, Falkirk and North Lanarkshire HSCPs who provided actual 
              hours. This should be taken into consideration if comparing the 
              information for Health and Social Care Partnerships."),
            p("Midlothian, Moray and North Ayrshire HSCPs were unable to provide 
              home care hours data for the 2017/18 and are excluded from the 
              chart. Glasgow City could only provide aggregated data and are also 
              been excluded from this chart."),
            p("To reflect these issues an 'All Areas Submitted' total is provided 
              rather than a Scotland figure as it would be underestimated."),
            wellPanel(column(6, shinyWidgets::pickerInput("HCPartnership4Input",
                                                          "Select Location:",
                                                          choices = unique(data_homecare_hours_distribution$sending_location),
                                                          selected = "Scotland"
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_hoursdistribution",
                label = "Download data",
                class = "myhomecarehoursdistribution"
              ),
              tags$head(
                tags$style(".myhomecarehoursdistribution { 
                           background-color: #0072B2; 
                           } 
                           .myhomecarehoursdistribution { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("HCHoursDist"),
              br(),
              actionButton("HCHoursDistbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCHourdDistTable",
                  DT::dataTableOutput("table_HC_hoursdist")
                )
              )
                )
              ),
          
          
          ## Tab 3.8: Housing Support/Living Alone ----
          
          
          tabPanel(
            "Housing Support/Living Alone",
            h3("Housing Support/Living Alone"),
            wellPanel(
              style = "overflow-y:scroll; 
              max-height: 250px;
              padding: 0px",
              p("This section provides additional information on people who 
                received home care during the estimated "census week" for 2018 
                (25 March 2018 to 31 March 2018)."),
              p("There are two different analyses that can be selected:"),
              tags$ul(
                tags$li("Housing Support"),
                tags$li("Living Alone.")
              ),
              p("The housing support and living alone information is based on 
                the status of the person receiving home care at the end of the 
                reporting period."),
              p("Housing Support services help people to live as independently 
                as possible in the community. These services help people manage 
                their home in different ways. These include assistance to claim 
                welfare benefits, fill in forms, manage a household budget, keep 
                safe and secure, get help from other specialist services, obtain 
                furniture and furnishings and help with shopping and housework."),
              tags$b("Data Completeness"),
              p("The following areas could not provide housing support information:"),
              tags$ul(
                tags$li("North Lanarkshire HSCP"),
                tags$li("Orkney Islands HSCP"),
                tags$li("Shetland HSCP"),
                tags$li("West Dunbartonshire HSCP")
              ),
              p("The following areas could not provide living alone information:"),
              tags$ul(
                tags$li("Aberdeenshire HSCP"),
                tags$li("Midlothian HSCP")
              ),
              p("Please note that the denominator includes all home care clients. 
                These percentages are not comparable with the social care survey 
                as the 'not known'category is excluded."),
              tags$b("Disclosure Control"),
              p(
                "* indicates values that have been suppressed due to the potential 
                risk of disclosure and to help maintain confidentiality. For 
                further guidance see ISD's",
                tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                       "Statistical Disclosure Control Protocol",".")
              )
              ),
            wellPanel(column(6, shinyWidgets::pickerInput("MeasureHC3Input",
                                                          "Select Measure:",
                                                          choices = unique(data_homecare_hs_la$Measure)
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_housingsupport",
                label = "Download data",
                class = "myhousingsupportbutton"
              ),
              tags$head(
                tags$style(".myhousingsupportbutton { 
                           background-color: #0072B2; } 
                           .myhousingsupportbutton { 
                           color: #FFFFFF; }")
                ),
              DT::dataTableOutput("HousingSupport",
                                  height = "500px"
              )
              )
            ),
          
          
          ## Tab 3.9 Personal Care ----
          
          
          tabPanel(
            "Personal Care",
            h3("Personal Care"),
            p("This section provides information on people with home care that 
              received personal care during the estimated "census week" for 2018 
              (25 March 2018 to 31 March 2018)."),
            tags$b("Data Completeness"),
            p("Glasgow City HSCP could not provide individual level information 
              for home care and are excluded from this chart. To reflect this an 
              'All Areas Submitted' total is provided rather than a Scotland total 
              as it would be underestimated. This is shown as a red line in the 
              chart below."),
            tags$b("Disclosure Control"),
            p(
              "* indicates values that have been suppressed due to the potential 
              risk of disclosure and to help maintain confidentiality. For further 
              guidance see ISD's",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", "Statistical Disclosure Control Protocol", ".")
            ),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_personalcare",
                label = "Download data",
                class = "mypersonalcarebutton"
              ),
              tags$head(
                tags$style(".mypersonalcarebutton { 
                           background-color: #0072B2; 
                           } 
                           .mypersonalcarebutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("HCPersonalCare",
                           height = "500px"
              ),
              br(),
              actionButton("HCpersonalcarebutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCPersonalCareTable",
                  DT::dataTableOutput("table_HC_personalcare")
                )
              )
                )
            ),
          
          
          ## Tab 3.10 Alarms/Telecare ----
          
          
          tabPanel(
            "Alarms/Telecare",
            h3("Alarms/Telecare"),
            p("This section provides information on people who receive home care 
              with/without a community alarm/telecare service.  Both the home 
              care and the community alarm/telecare service relate to the period 
              January 2018 to March 2018."),
            tags$b("Data Completeness"),
            p("Glasgow City, Scottish Borders and South Lanarkshire HSCPs could 
              not provide community alarm/telecare data at individual level and 
              are excluded from this chart."),
            p("To reflect this an 'All Areas Submitted' total is provided rather 
              than a Scotland total as it would be underestimated."),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_alarms",
                label = "Download data",
                class = "myalarmsbutton"
              ),
              tags$head(
                tags$style(".myalarmsbutton { 
                           background-color: #0072B2; 
                           } 
                           .myalarmsbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("HCalarms",
                           height = "500px",
                           width = "90%"
              ),
              br(),
              actionButton("HCalarmsbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCalarmsTable",
                  DT::dataTableOutput("table_HC_alarms")
                )
              )
                )
            ), 
          
          
          ## Tab 3.11 Emergency Hospital Admissions ----
          
          
          tabPanel(
            "Emergency Hospital Admissions",
            h3("Emergency Hospital Admissions"),
            wellPanel(
              style = "overflow-y:scroll; 
              max-height: 250px;
              padding: 0px",
              p("The chart below presents information on emergency admissions to 
                hospital (acute) for people receiving home care between 1 January 
                2018 and 31 March 2018."),
              p("There are two different analyses that can be selected:"),
              tags$ul(
                tags$li("Emergency admissions"),
                tags$li("Emergency admission Bed days")
              ),
              tags$b("Data Completeness"),
              p("Glasgow City was unable to provide individual level information 
                and is excluded from this analysis. To reflect this an 'All Areas 
                Submitted' category is provided rather than Scotland as it would 
                be underestimated. This is shown as a red line in the chart below."),
              tags$b("Notes on the analysis:"),
              tags$ul(
                tags$li("Home care individual level information has been linked 
                        to acute hospital data (Data Source SMR01) to obtain 
                        information on emergency hospital admissions and bed day 
                        rates for people receiving home care."),
                tags$li("The health activity data (emergency admission to hospital) 
                        considered within this analysis relates to the time 
                        period each individual received home care between 1 
                        January 2018 and 31 March 2018. The emergency admissions 
                        could have been to any hospital in NHS Scotland."),
                tags$li("The denominator used in the calculation of emergency 
                        hospital admission and bed day rates is the number of 
                        people with an active home care service on the 31 March 
                        2018.")
                )
                ),
            wellPanel(column(6, shinyWidgets::pickerInput("HCAdmissionsInput",
                                                          "Select Measure:",
                                                          choices = unique(data_homecare_hospital_adm$Measure)
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_emergencyadmissions",
                label = "Download data",
                class = "myemergencyadmissionsbutton"
              ),
              tags$head(
                tags$style(".myemergencyadmissionsbutton { 
                           background-color: #0072B2; 
                           } 
                           .myemergencyadmissionsbutton { 
                           color: #FFFFFF; }")
                ),
              plotlyOutput("HCAdmissions",
                           height = "600px"
              ),
              br(),
              actionButton("HCadmissionsbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5;
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "HCAdmissionsTable",
                  DT::dataTableOutput("table_HC_admissions")
                )
              )
              )
            ),
          
          
          ## Tab 3.12: Level of Independence (ioRN) ----
          
          
          tabPanel(
            "Level of Independence (ioRN)",
            h3("Level of Independence (ioRN)"),
            wellPanel(
              style = "overflow-y:scroll; 
              max-height: 250px;
              padding: 0px",
              p("The Indicator of Relative Need (ioRN) is a widely available 
                tool for health and social care practitioners that may be used 
                to: inform individual decisions on the need for interventions to 
                support, care and reactivate people's independence and provide a 
                measure (stratification) of a population's functional and social 
                independence. The summary Group categories used here broadly 
                represent, going from left to right or A to I, higher levels of 
                need e.g. people in Group A are the most independent and people 
                in Group I are least independent (i.e. have higher needs for 
                support from others)."),
              p("The ioRN data is an Optional part of the source Social Care 
                dataset as it is not currently universally used."),
              p(
                "Note that the Group categories used here are based on the 
                original version of the community ioRN. Some of the Groups have 
                been combined due to small numbers. Where more than one Group 
                has been assigned to a person, the latest Group assigned is used. 
                Further information about the latest version of the community 
                ioRN (ioRN2) is available",
                tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/", 
                       "here")
              ),
              p("For people with an ioRN Group recorded during financial year 
                2017/18, the following chart shows the average weekly home care 
                hours received during the for which home care was provided 
                (January 2018 to March 2018)."),
              tags$b("Disclosure Control"),
              p(
                "* indicates values that have been suppressed due to the 
                potential risk of disclosure and to help maintain 
                confidentiality.  For further guidance see ISD's",
                tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                       "Statistical Disclosure Control Protocol", ".")
              )
              ),
            wellPanel(column(6, selectInput("lornPartnership2Input",
                                            "Select Location:",
                                            selected = "a",
                                            choices = data_homecare_IoRN$sending_location
            ))),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_homecare_ioRN",
                label = "Download data",
                class = "myhomecareioRNbutton"
              ),
              tags$head(
                tags$style(".myhomecareioRNbutton { 
                           background-color: #0072B2; 
                           } 
                           .myhomecareioRNbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              plotlyOutput("lornHCB"),
              br(),
              actionButton("IORNhomecarebutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "IORNhomecareTable",
                  DT::dataTableOutput("table_IORN_homecare")
                )
              )
                )
              )
            )
              )
      ),
    
    
    ### Tab 4: People Supported in Care Homes ----
    
    
    tabPanel(
      "People Supported In Care Homes",
      mainPanel(
        width = 12,
        
        # Within this section we are going to have a sub tab column on the left
        # To do this we are going to use the layout "navlistPanel()"
        
        navlistPanel(
          id = "Care_Home_Tab_Box",
          widths = c(2, 10),
          
          
          ##Tab 4.1: People Supported In Care Homes - Introduction ----
          
          
          tabPanel(
            "Introduction",
            h3("People Supported In Care Homes - Introduction"),
            p("The information in this section is about people who have been 
              supported to meet their assessed social care needs within a care 
              home. Information is presented on people who were resident (long 
              term, short term or for respite) in a care home at any point during 
              the period 1 January 2018 - 31 March 2018. The figures will include 
              anyone who is receiving Free Personal Care, or otherwise, where 
              some or all of the care home fee is paid by the Health and Social 
              Care Partnership. They do not include anyone who is living in a 
              care home on an entirely self-funded basis."),
            p(
              "More information on the definitions and guidance for people 
              supported in a care home is available",
              tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/docs/Revised-Source-Dataset-Definitions-and-Recording-Guidance-March-2018.pdf", 
                     "here.")
            ),
            tags$b("Notes:"),
            tags$ul(
              tags$li("Care homes residents aged under 18 are excluded from the 
                      analyses in this section."),
              tags$li("The number of admissions and discharges to and from care 
                      homes by month have been derived using the start and end 
                      dates provided."),
              tags$li("Residents admitted for respite care are included within 
                      these outputs."),
              tags$li("Rates are expressed as per 1,000 population (2017 midyear 
                      estimates population aged 18 and older)."),
              tags$li("Information is shown by the Health and Social Care 
                      Partnership (HSCP) funding the resident`s package of care. 
                      The care home placement could be outside the geographical 
                      boundary of the HSCP.")
              ),
            p("This section also contains information on acute emergency 
              admissions to hospital for people who are receiving home care. 
              Notes on this analysis are provided below."),
            tags$b("Linkage of care home data to health care datasets notes:"),
            tags$ul(
              tags$li("This information has been linked via the CHI number of 
                      the patient/client. The CHI number was derived on 
                      submission of the social care data. Where it was not 
                      possible to obtain CHI information, these records were 
                      excluded from the linked health care measures in this 
                      section."),
              tags$li("Care home individual level information has been linked to 
                      acute hospital data (Data Source SMR01) to measure emergency 
                      hospital admissions and bed day rates for people in a care 
                      home."),
              tags$li("The health activity data (emergency admission to hospital) 
                      in this analysis relates to the care home residents most 
                      recent care home admission between 1 January and 31 March 
                      2018 (or care home discharge date if this is earlier). 
                      The emergency admissions could have been to any hospital 
                      in NHS Scotland."),
              tags$li("The denominator used in the calculation of emergency 
                      hospital admission and bed day rates is the number of 
                      people resident a care home on the 31 March 2018."),
              tags$li("Glasgow City and Comhairle nan Eilean Siar HSCPs were 
                      unable to submit individual level data and have been 
                      excluded from the analysis.")
              ),
            tags$b("Disclosure Control"),
            p(
              "* indicates values that have been suppressed due to the potential 
              risk of disclosure and to help maintain confidentiality.  For 
              further guidance see ISD's",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                     "Statistical Disclosure Control Protocol", ".")
            ),
            tags$b("Data Sources"),
            p("Source Social Care Data"),
            p("SMR01 hospital discharge records")
              ),
          
          
          ## Tab 4.2: People Supported In Care Homes - Number and Rate ----
          
          
          tabPanel(
            "People Supported In Care Homes - Number and Rate",
            h3("People Supported In Care Homes - Number and Rate"),
            p("The chart below presents information on people aged 18 and over 
              supported in a care home at the end of January, February and March 
              2018 (please select the month from the drop down selection below). 
              The information is presented as the rate per 1,000 population aged 
              18 and over."),
            tags$b("Notes"),
            p("The figures include people where some or all of the care home fee 
              is paid by the Health and Social Care Partnership. They do not 
              include anyone who is living in a care home on an entirely 
              self-funded basis."),
            p("The table provides the number of residents as well as the rate 
              per 1,000 population aged 18 and over for each of the dates. 
              The Scotland rate is shown as a red line in the chart below."),
            wellPanel(column(6, shinyWidgets::pickerInput("MonthCHInput",
                                                          "Select Date:",
                                                          choices = unique(data_care_home_number_rate$Date),
                                                          selected = "Scotland"
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_residents",
                
                label = "Download data",
                
                class = "myresidentsbutton"
              ),
              tags$head(
                tags$style(".myresidentsbutton { 
                           background-color: #0072B2; 
              } 
                           .myresidentsbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("CH_Residents",
                           height = "500px"
              ),
              br(),
              actionButton("CHresidentsbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "CHResidentsTable",
                  DT::dataTableOutput("table_CH_residents")
                )
              )
                )
              ),
          
          
          ## Tab 4.3: Age and Sex of Care Home Residents ----
          
          
          tabPanel(
            "Age and Sex of Care Home Residents",
            h3("Age and Sex of Care Home Residents"),
            p("This section presents information on the people resident in a 
              care home at 31 March 2018 by age band and sex."),
            tags$b("Notes"),
            p("The figures include people where some or all of the care home fee 
              is paid by the Health and Social Care Partnership. They do not 
              include anyone who is living in a care home on an entirely 
              self-funded basis."),
            tags$b("Data Completeness"),
            p("There were a small number of records where the age or sex of the 
              care homes resident was not provided. In total 115 records relating 
              to care home residents have been excluded from this analysis. 
              Due to this some totals presented in this analysis may be slightly 
              lower than those presented in other analyses in this section."),
            wellPanel(
              tags$style(".well {
                         background-color: #ffffff;
                         border: 0px 
                         solid #336699;
                           }"),
              column(6, shinyWidgets::pickerInput("PartnershipCH1Input",
                                                  "Select Location:",
                                                  choices = unique(data_care_home_age_sex$Area),
                                                  selected = "Scotland"
              ))
            ),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_CH_agesex",
                
                label = "Download data",
                
                class = "myCHagesexbutton"
              ),
              tags$head(
                tags$style(".myCHagesexbutton { 
                           background-color: #0072B2; 
                           } 
                           .myCHagesexbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              fluidRow(column(12, plotlyOutput("CH_AgeSex"))),
              br(),
              br(),
              actionButton("CHagesexbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "CHAgeSexTable",
                  DT::dataTableOutput("table_CH_agesex")
                )
              )
                )
              ),
          
          
          ## Tab 4.4: Admissions and Discharges to/from Care Homes ----
          
          
          tabPanel(
            "Admissions and Discharges to/from Care Homes",
            h3("Admissions and Discharges to/from Care Homes"),
            p("The chart below presents information on the number of admissions 
              and discharges to/from a care home by the Health and Social Care 
              Partnership providing the funding by months January 2018 - March 
              2018."),
            tags$b("Notes"),
            p("The figures include people where some or all of the care home fee 
              is paid by the Health and Social Care Partnership. They do not 
              include anyone who is living in a care home on an entirely 
              self-funded basis."),
            tags$b("Data Completeness"),
            p("Glasgow City and Comhairle nan Eilean Siar HSCPs were unable to 
              provide the individual care home resident data required for this 
              analysis and are excluded from the chart and table.  To reflect 
              this an 'All Areas Submitted' total is provided rather than a 
              Scotland figure as it would be underestimated."),
            wellPanel(column(6, shinyWidgets::pickerInput("PartnerhsipCHAdmInput",
                                                          "Select Location:",
                                                          choices = unique(data_care_home_admissions_discharges$sending_location),
                                                          selected = "All Areas Submitted"
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_admdis",
                
                label = "Download data",
                
                class = "myadmdisbutton"
              ),
              tags$head(
                tags$style(".myadmdisbutton { 
                           background-color: #0072B2; 
                } 
                           .myadmdisbutton { 
                           color: #FFFFFF; }")
                ),
              fluidRow(column(7, plotlyOutput("CH_AdmDis",
                                              height = "500px"
              ), offset = 2)),
              actionButton("CHadmdisbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "CHadmdisTable",
                  DT::dataTableOutput("table_CH_admdis")
                )
              )
              )
            ),
          
          
          ## Tab 4.5: Median Length of Stay In Care Home ----
          
          
          tabPanel(
            "Median Length of Stay In Care Home",
            h3("Median Length of Stay In Care Home"),
            p("The chart below presents information on the median length of stay 
              of care home residents aged 18 and over as at 31 March 2018."),
            tags$b("Notes"),
            p("The figures include people where some or all of the care home fee 
              is paid by the Health and Social Care Partnership. They do not 
              include anyone who is living in a care home on an entirely 
              self-funded basis."),
            p("The `Median length of stay' is the middle value when all the 
              lengths of stay for care home residents are arranged in order of
              how long the person has been resident in the care home. The 
              Scotland rate is shown as a red line in thechart below."),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_CH_lengthofstay",
                
                label = "Download data",
                
                class = "myCHlengthofstaybutton"
              ),
              tags$head(
                tags$style(".myCHlengthofstaybutton { 
                           background-color: #0072B2; 
                } 
                           .myCHlengthofstaybutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("LengthofStay",
                           height = "500px"
              ),
              br(),
              actionButton("CHlengthofstaybutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "CHLengthofStayTable",
                  DT::dataTableOutput("table_CH_lengthofstay")
                )
              )
                )
              ),
          
          
          ## Tab 4.6: Need For Nursing Care ----
          tabPanel(
            "Need For Nursing Care",
            h3("Need For Nursing Care"),
            p("This chart below presents information on the number of care home 
              residents at 31 March 2018 who required nursing care."),
            tags$b("Notes"),
            p("The figures include people where some or all of the care home fee 
              is paid by the Health and Social Care Partnership. They do not 
              include anyone who is living in a care home on an entirely 
              self-funded basis."),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_CH_nursingcare",
                
                label = "Download data",
                
                class = "myCHnursingcarebutton"
              ),
              tags$head(
                tags$style(".myCHnursingcarebutton { 
                           background-color: #0072B2; 
                } 
                           .myCHnursingcarebutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("Nurse",
                           height = "560px"
              ),
              br(),
              actionButton("CHnursingbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "CHNurseTable",
                  DT::dataTableOutput("table_CH_nurse")
                )
              )
                )
              ),
          
          
          ## Tab 4.7: Emergency hospital admissions ----
          
          
          tabPanel(
            "Emergency Hospital Admissions For Care home Residents",
            h3("Emergency Hospital Admissions For Care Home Residents"),
            wellPanel(
              style = "overflow-y:scroll; 
              max-height: 250px;
              padding: 0px",
              p("The chart below presents information on emergency admissions to 
                hospital (acute) for care home residents between 1 January 2018 
                and 31 March 2018."),
              p("There are two different analyses that can be selected:"),
              tags$ul(
                tags$li("Emergency admissions"),
                tags$li("Emergency admission bed days")
              ),
              tags$b("Data Completeness"),
              p("Glasgow City and Comhairle nan Eilean Siar HSCPs were unable to 
                submit individual level data and have been excluded from the 
                analysis. To reflect this an 'All Areas Submitted' category is 
                provided rather than Scotland as it would be underestimated. 
                This is shown as a red line in the chart below."),
              tags$b("Notes on the Analysis:"),
              tags$ul(
                tags$li("Care Home individual level information has been linked 
                        to acute hospital data (Data Source SMR01) to measure 
                        emergency hospital admissions and bed day rates for 
                        people resident in a care home."),
                tags$li("The health activity data (emergency admission to 
                        hospital) in this analysis relates to the care home 
                        residents most recent care home admission between 1 
                        January and 31 March 2018. If the person is still in a 
                        care home on the 31 March 2018, the discharge date is 
                        defaulted to this. If a person has more than one care 
                        home record, the latest record has been used. The 
                        emergency admissions could have been to any hospital in 
                        NHS Scotland."),
                tags$li("The denominator used in the calculation of emergency 
                        hospital admission and bed day rates is the number of 
                        people resident a care home on the 31 March 2018.")
                )
                ),
            wellPanel(column(6, shinyWidgets::pickerInput("AdmissionsInput",
                                                          "Select Measure:",
                                                          choices = unique(data_care_home_hospital_adm$Measure)
            ))),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_CH_EAdm",
                
                label = "Download data",
                
                class = "myCHEAdmbutton"
              ),
              tags$head(
                tags$style(".myCHEAdmbutton { 
                           background-color: #0072B2; 
                         } 
                           .myCHEAdmbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("CHAdmissions",
                           height = "500px"
              ),
              br(),
              actionButton("CHadmissionsbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "CHAdmissionsTable",
                  DT::dataTableOutput("table_CH_admissions")
                )
              )
                )
              ),
          
          
          ## Tab 4.8: Level of Independence ioRN Care Home ----
          
          
          tabPanel(
            "Level of Independence ioRN Group Before Admission to Care Home",
            h3("Level of Independence ioRN Group Before Admission to Care Home"),
            wellPanel(
              style = "overflow-y:scroll; 
              max-height: 250px;
              padding: 0px",
              p("The Indicator of Relative Need (ioRN) is a widely available 
                tool for health and social care practitioners that may be used 
                to: inform individual decisions on the need for interventions to 
                support, care and reactivate people's independence and provide a 
                measure (stratification) of a population's functional and social 
                independence. The summary Group categories used here broadly 
                represent, going from left to right or A to I, higher levels of 
                need e.g. people in Group A are the most independent and people 
                in Group I are least independent (i.e. have higher needs for 
                support from others)."),
              p("The ioRN data is an Optional part of the Source Social Care 
                dataset as it not currently universally used."),
              p(
                "Note that the Group categories used here are based on the 
                original version of the community ioRN. Some of the Groups have 
                been combined due to small numbers. Where more than one Group 
                has been assigned to a person, the latest Group assigned is used. 
                Further information about the latest version of the community 
                ioRN (ioRN2) is available",
                tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Dependency-Relative-Needs/In-the-Community/", 
                       "here", ".")
              ),
              p("Of people with an ioRN Group recorded during financial year 
                2017/18, the following chart shows the percentage admitted to a 
                care home after being assigned an ioRN Group. Only care home 
                stays of length greater than 2 weeks have been included."),
              tags$b("Disclosure Control"),
              p(
                "* indicates values that have been suppressed due to the 
                potential risk of disclosure and to help maintain confidentiality. 
                For further guidance see ISD's",
                tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                       "Statistical Disclosure Control Protocol", ".")
              )
              ),
            wellPanel(column(6, selectInput("lorncarehomeInput",
                                            "Select Location:",
                                            choices = data_care_home_IoRN$sending_location,
                                            selected = "All Areas Sumitted"
            ))),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_CH_ioRN",
                
                label = "Download data",
                
                class = "myCHioRNbutton"
              ),
              tags$head(
                tags$style(".myCHioRNbutton { 
                           background-color: #0072B2; 
         } 
                           .myCHioRNbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("lorncarehomeA"),
              br(),
              actionButton("IORNcarehomebutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "IORNcarehomeTable",
                  DT::dataTableOutput("table_IORN_carehome")
                )
              )
                )
              )
            )
              )
          ),
    
    
    ### Tab 5: Community Alarms/Telecare ----
    
    
    tabPanel(
      "Community Alarms/Telecare",
      mainPanel(
        width = 12,
        
        # Within this section we are going to have a sub tab column on the left
        # To do this we are going to use the layout "navlistPanel()"
        
        navlistPanel(
          id = "Equipment_list",
          widths = c(2, 10),
          
          
          ## Tab 5.1: Community Alarms/Telecare - Introduction ----
          
          
          tabPanel(
            "Introduction",
            h3("Community Alarms/Telecare"),
            p("The information in this section is about people who have been 
              supported with community alarms or telecare."),
            p("Community Alarms refer to a communication hub (either individual 
              or part of a communal system), plus a button/pull cords/pendant 
              which transfers an alert/alarm/data to a monitoring centre or 
              individual responder."),
            p("Telecare refers to a technology package which goes over and above 
              the basic community alarm package, potentially including other 
              sensors or monitoring equipment such as linked pill dispensers and 
              linked smoke detectors."),
            p("Telecare is the remote or enhanced delivery of care services to 
              people in their own home by means of telecommunications and 
              computerised services. Telecare usually refers to sensors or alerts 
              which provide continuous, automatic and remote monitoring of care 
              needs emergencies and lifestyle using information and communication 
              technology (ICT) to trigger human responses or shut down equipment 
              to prevent hazards (Source: National Telecare Development Programme, 
              Scottish Government)."),
            tags$b("The following are included as part of the community 
                   alarms/telecare extract:"),
            tags$ul(
              tags$li("All active records for a person within the financial year 
                      2017/18."),
              tags$li("When there is more than one person living within a house 
                      who has been identified as eligible for and requiring a 
                      community alarms/telecare service, individual information 
                      for each person/service has been provided where possible."),
              tags$li("Information is included on community alarms/telecare 
                      services purchased by the HSCP from another provider e.g. 
                      Housing Association. This includes people living within 
                      amenity/sheltered/very sheltered/extra care housing where 
                      a community alarm (including a sheltered housing alarm) or 
                      telecare is included as part of the purchased or provided 
                      service."),
              tags$li("Telecare technologies installed in a person's home for a 
                      short period of time only to assist an assessment of need."),
              tags$li("Closed services and services for people who have died if 
                      active during financial year 2017/18.")
              ),
            tags$b("The following is excluded within the community alarms/telecare 
                   extract:"),
            tags$ul(
              tags$li("People living within properties which have had alarms 
                      installed historically but which are no longer used to 
                      meet care and support needs.")
              ),
            tags$b("Notes on the analysis:"),
            tags$ul(
              tags$li("People receiving a community alarm and/or telecare service 
                      are allocated to the following categories:"),
              tags$ul(
                tags$li("community alarms only"),
                tags$li("telecare only"),
                tags$li("receiving both a community alarm and telecare")
              ),
              tags$li("The total count of people receiving a community alarm 
                      and/or telecare is provided. A person will count only once 
                      regardless of how many services they have."),
              tags$li(
                "Trend information in this section includes data previously 
                published by the Scottish Government in the Social Care Survey. 
                Data ranging from 2015/16 to 2016/17 has been obtained from",
                tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                       "the Scottish Government Website.")
              )
              ),
            tags$b("Disclosure Control"),
            p(
              "* indicates values that have been suppressed due to the potential 
              risk of disclosure and to help maintain confidentiality.For further 
              guidance see ISD's",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                     "Statistical Disclosure Control Protocol.")
            ),
            tags$b("Data Sources"),
            p(
              "ISD source Social Care Data. More Information is available",
              tags$a(href = "https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Health-and-Social-Care-Integration/docs/Revised-Source-Dataset-Definitions-and-Recording-Guidance-March-2018.pdf", 
                     "here.")
            )
            ),
          
          
          ## Tab 5.2: Trend ----
          
          
          tabPanel(
            "Trend",
            h3("Trend"),
            p(
              "This section presents information on the number of clients 
              receiving community alarms/telecare from 2015/16 to 2017/18. 
              Information relates to all active community alarms/telecare 
              services and not just new installations. Data prior to 2017/18 was 
              sourced from the",
              tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                     "Social Care Survey"),
              "previously published by the Scottish Government. Prior to 2015/16, 
              the Scottish Government's Social Care Survey collected new 
              installations data only so data prior to time period is not 
              comparable."
            ),
            p("The following measures can be selected:"),
            tags$ul(
              tags$li("community alarms only"),
              tags$li("telecare only"),
              tags$li("receiving both a community alarm and telecare"),
              tags$li("total community alarms and/or telecare")
            ),
            tags$b("Data completeness"),
            p(
              "South Lanarkshire HSCP could not provide community alarms/telecare 
              data for 2017/18. In order to present trend information at Scotland 
              level this area has been assumed to have the same level of community 
              alarms/telecare as was reported in 2016/17 in the",
              tags$a(href = "https://www.gov.scot/publications/social-care-services-scotland-2017/", 
                     "Social Care Survey"),
              ". There has been improved recording of telecare in financial year 
              2017/18 in some Health & Social Care Partnerships. This should be 
              taken into account when interpreting the trend information."
            ),
            wellPanel(
              column(6, shinyWidgets::pickerInput("EquipmentPartnership2Input",
                                                  "Select Location:",
                                                  choices = unique(data_alarm_telecare_trend$sending_location),
                                                  selected = "Scotland"
              )),
              column(6, shinyWidgets::pickerInput("EquipmentType2Input",
                                                  "Select Measure:",
                                                  choices = unique(data_alarm_telecare_trend$type),
                                                  selected = "Total community alarms and/or telecare"
              ))
            ),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_equipment_trend",
                
                label = "Download data",
                
                class = "myequipmenttrendbutton"
              ),
              tags$head(
                tags$style(".myequipmenttrendbutton { 
                           background-color: #0072B2; 
                } 
                           .myequipmenttrendbutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              fluidRow(column(6, plotlyOutput("equipmenttrendoutput",
                                              width = "600px",
                                              height = "550px"
              ), offset = 1)),
              br(),
              br(),
              actionButton("equipmenttrendbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "EquipmentTrendTable",
                  DT::dataTableOutput("table_equipment_trend")
                )
              )
                )
              ),
          
          
          ## Tab 5.3: Community Alarms/Telecare ----
          tabPanel(
            "Community Alarms/Telecare",
            h3("Community Alarms/Telecare"),
            p("This section presents the number of people supported by community 
              alarms/telecare service at some time during the financial year 
              2017/18 by Health & Social Care Partnership."),
            p("The following different measures can be selected:"),
            tags$ul(
              tags$li("community alarms only"),
              tags$li("telecare only"),
              tags$li("receiving both a community alarm and telecare"),
              tags$li("total community alarms and/or telecare")
            ),
            p("Please note the data refers to all active installations as 
              opposed to just new installations."),
            tags$b("Data Completeness"),
            p("South Lanarkshire HSCP was unable to provide community 
              alarms/telecare data for 2017/18 and are excluded from this 
              analysis."),
            p("To reflect this an 'All Areas Submitted' total is provided rather 
              than a Scotland total as it would be underestimated."),
            tags$b("Disclosure Control"),
            p(
              "Within the table * indicates values that have been suppressed due 
              to the potential risk of disclosure and to help maintain 
              confidentiality. Within the chart if numbers have been suppressed 
              the data will not be presented. For further guidance see ISD's",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                     "Statistical Disclosure Control Protocol",".")
            ),
            wellPanel(column(6, shinyWidgets::pickerInput("EquipmentTypeInput",
                                                          "Select Measure:",
                                                          choices = unique(data_alarm_telecare_equipment$type),
                                                          selected = "a"
            ))),
            br(),
            mainPanel(
              width = 12,
              downloadButton(
                outputId = "download_equipment_alarmstelecare",
                
                label = "Download data",
                
                class = "myequipmentalarmstelecarebutton"
              ),
              tags$head(
                tags$style(".myequipmentalarmstelecarebutton { 
                           background-color: #0072B2; 
                } 
                           .myequipmentalarmstelecarebutton { 
                           color: #FFFFFF; 
                           }")
              ),
              br(),
              plotlyOutput("equipmentoutput",
                           height = "500px"
              ),
              br(),
              br(),
              actionButton("equipmentbutton",
                           "Show/hide table",
                           style = "color: #fff;
                           background-color:#2171b5; 
                           border-color: #636363"
              ),
              hidden(
                div(
                  id = "EquipmentTable",
                  DT::dataTableOutput("table_clients_equipment")
                )
              )
                )
              )
            )
        )
      ),
    
    
    ### Tab 6: People and Services Summary ----
    
    
    tabPanel(
      "People and Services Summary",
      mainPanel(
        width = 12,
        
        # Within this section we are going to have a sub tab column on the left
        # To do this we are going to use the layout "navlistPanel()"
        
        navlistPanel(
          id = "Clients_Tab_Box",
          widths = c(2, 10),
          
          
          ## Tab 6.1: People and Services Summary - Introduction ----
          
          
          tabPanel(
            "Introduction",
            h3("People and Services Summary - Introduction"),
            p("Social care is provided to people to meet a diverse range of 
              support needs and there are choices about how this support is 
              delivered. The information recorded about the people receiving 
              social care in its various forms contributes to understanding that 
              diversity. This section provides a summary of the number of people 
              receiving a variety of different social care support and service 
              types. Due to the restrictions in the way that the data were 
              collected nationally for 2017/18 the figures shown vary in terms 
              of the time periods to which they refer. In future years it is 
              expected that annual numbers will be available for all types of 
              service."),
            tags$b("Notes:"),
            tags$ul(
              tags$li("The services and support included in this section relate 
                      to two distinct time periods (full financial year 2017/18 
                      or quarter ending March 2018 (1 January to 31 March 2018)."),
              tags$li(
                "To enable comparison with data previously published in the 
                Scottish Government's Social Care Survey some figures are also 
                presented in an 'adjusted' form. The 'adjusted' figure has been 
                created by:",
                tags$ul(
                  tags$li("Excluding people where the only information available 
                          is that they are supported in a care home"),
                  tags$li("Excluding people who only receive day care"),
                  tags$li("Excluding people who did not receive home care in the 
                          final week of March or any other service/support")
                  )
                  ),
              tags$li("As some partnerships were unable to provide individual 
                      level information for specific topics 
                      and Glasgow data is only available at aggregated level, 
                      estimation has been used to create top level Scotland 
                      trends. Please see the",
                      tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Publications/2019-06-11/2019-06-11-Social-Care-Report.pdf",
                             "appendix of the report"),
                      "for the methodology of the estimation.")
              ),
            tags$b("Disclosure Control"),
            p(
              "* indicates values that have been suppressed due to the potential 
              risk of disclosure and to help maintain confidentiality. 
              For further guidance see ISD's",
              tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                     "Statistical Disclosure Control Protocol",".")
            ),
            tags$b("Data Source"),
            p("Source Social Care Data extract.")
      ),
      
      
      ## Tab 6.2: People Supported ----
      
      
      tabPanel(
        "People Supported",
        h3("People Supported"),
        wellPanel(
          style = "overflow-y:scroll; 
          max-height: 250px;
          padding: 0px",
          p("The chart below presents information on the total number of 
            people receiving social care services/support during 2017/18. 
            These services/supports include: home care, care home, meals, 
            community alarm/telecare, housing support, social worker and 
            day care. People involved in choosing and controlling their
            support through self-directed support options are also included."),
          p("There are two measures presented:"),
          tags$ul(
            tags$li("Number of people supported"),
            tags$li("Number of people supported - 'adjusted' (allows 
                    comparison with the Scottish Government social care 
                    census)")
          ),
          p("The 'adjusted' figure has been created by:"),
          tags$ul(
            tags$li("Excluding people where the only information available 
                    was that they were supported in a care home"),
            tags$li("Excluding people who only received day care"),
            tags$li("Excludes people who only received home care who did 
                    not receive home care in the 'census' week")
            ),
          tags$b("Data completeness"),
          p("Please note that some partnerships were unable to provide 
            information on all services/support included in the source 
            social care data collection. The following areas were unable to 
            provide individual level information for specific topics 
            (summarised below) and Glasgow City HSCP is only available at 
            aggregate level. Therefore, estimation has been used to create 
            top level Scotland trends. Please see the",
            tags$a(href="https://www.isdscotland.org/Health-Topics/Health-and-Social-Community-Care/Publications/2019-06-11/2019-06-11-Social-Care-Report.pdf",
                   "appendix of the report"),
            "for the methodology of the estimation."),
          tags$ul(
            tags$li("Fife HSCP Self Directed Support clients"),
            tags$li("South Lanarkshire HSCP community alarm/telecare clients"),
            tags$li("Housing support - North Lanarkshire, Orkney Islands, 
                    Shetland, West Dunbartonshire"),
            tags$li("Meals - North Lanarkshire"),
            tags$li("Day care - Argyll & Bute, Glasgow City, 
                    North Lanarkshire, Orkney Islands"),
            tags$li("Social worker - Renfrewshire, West Dunbartonshire")
            ),
          p("The following areas were only able to provide aggregated data 
            for some services/support included in the Source social care 
            data collection. The aggregated data has been incorporated into 
            the total number of people counts. There may be some duplication 
            if people in the aggregated data were also receiving another 
            service/support as they could be counted twice:"),
          tags$ul(
            tags$li("Comhairle nan Eilean Siar HSCP care home residents"),
            tags$li("Scottish Borders HSCP community alarm/telecare clients")
          ),
          p("To reflect these data completeness issues a Scotland estimate is
            provided for both measures.")
          ),
        wellPanel(column(6, shinyWidgets::pickerInput("Clientstype5Input",
                                                      "Select measure:",
                                                      choices = unique(data_clients_totals$type),
                                                      selected = "Aberdeen City"
        ))),
        mainPanel(
          width = 12,
          downloadButton(
            outputId = "download_clients_totals",
            label = "Download data",
            class = "myClientstotalsbutton"
          ),
          tags$head(
            tags$style(".myClientstotalsbutton { 
                       background-color: #0072B2; 
                           } 
                       .myClientstotalsbutton { 
                       color: #FFFFFF; 
                       }")
              ),
          plotlyOutput("ClientTotals",
                       height = "500px"
          ),
          br(),
          actionButton("Clientstotalsbutton",
                       "Show/hide table",
                       style = "color: #fff;
                       background-color:#2171b5; 
                       border-color: #636363"
          ),
          hidden(
            div(
              id = "ClientsTotalsTable",
              DT::dataTableOutput("table_clients_totals")
            )
          )
            )
        ),
      
      
      ## Tab 6.2: Age and Sex ----
      
      
      tabPanel(
        "Age and Sex",
        h3("Age and Sex"),
        wellPanel(
          style = "overflow-y:scroll; 
          max-height: 250px;
          padding: 0px",
          p("This section provides information on the number of people 
            receiving social care services/support by age band and sex."),
          p("Figures are based on all records where age and sex information 
            was provided. Therefore the total number of people split by age 
            and sex may not equal the total number of people receiving a 
            social care package in other analyses presented in the dashboard."),
          p("There are two measures presented:"),
          tags$ul(
            tags$li("Number of people supported"),
            tags$li("Number of people supported - 'adjusted' (allows 
                    comparison with the Scottish Government social care 
                    census)")
          ),
          tags$b("Data completeness"),
          p("The following areas were unable to provide individual level 
            information on all services/support included in the source 
            social care data collection:"),
          tags$ul(
            tags$li("Self-directed support - Fife HSCP"),
            tags$li("Self-directed support - Comhairle nan Eilean Siar 
                    HSCP Option 3 only"),
            tags$li("Community alarms/telecare - Scottish Borders HSCP"),
            tags$li("Community alarms/telecare -  South Lanarkshire HSCP"),
            tags$li("Community alarms/telecare East Lothian HSCP - clients 
                    only with services that began prior to 2017/18"),
            tags$li("Housing support - North Lanarkshire, Orkney Islands, 
                    Shetland, West Dunbartonshire HSCPs"),
            tags$li("Meals - North Lanarkshire HSCP"),
            tags$li("Day care - Argyll & Bute, North Lanarkshire, 
                    Orkney Islands HSCPs"),
            tags$li("Social worker - Renfrewshire, West Dunbartonshire 
                    HSCPs"),
            tags$li("Glasgow City HSCP (all services/support, 19,329 
                    clients)"),
            tags$li("847 people across Scotland whose sex is unavailable or 
                    given as 'Not Known' or 'Not Provided'")
            ),
          p("The following area was only able to provide aggregated data 
            which has been incorporated into the number of people counts. 
            There may be some duplication if people in the aggregated data 
            were also receiving another service/support as they would be 
            counted twice:"),
          tags$ul(
            tags$li("Comhairle nan Eilean Siar HSCP care home residents")
          ),
          p("To reflect these issues an 'All Areas Submitted' is provided 
            rather than a Scotland total.")
          ),
        wellPanel(
          column(6, shinyWidgets::pickerInput("ClientsPartnership1Input",
                                              "Select Location:",
                                              choices = unique(data_clients_age_sex$sending_location),
                                              selected = "Scotland"
          )),
          column(6, shinyWidgets::pickerInput("ClientsTypeInput",
                                              "Select Measure:",
                                              choices = unique(data_clients_age_sex$type)
          ))
        ),
        downloadButton(
          outputId = "download_clients_agesex",
          label = "Download data",
          class = "myClientsagesexbutton"
        ),
        tags$head(
          tags$style(".myClientsagesexbutton { 
                     background-color: #0072B2; 
                           } 
                     .myClientsagesexbutton { 
                     color: #FFFFFF; 
                     }")
            ),
        mainPanel(
          width = 12,
          plotlyOutput("Clientsagesex"),
          br(),
          br(),
          actionButton("Clientsagesexbutton",
                       "Show/hide table",
                       style = "color: #fff;
                       background-color:#2171b5; 
                       border-color: #636363"
          ),
          hidden(
            div(
              id = "ClientsAgeSexTable",
              DT::dataTableOutput("table_clients_agesex")
            )
          )
        )
          ),
      
      
      ## Tab 6.3: Deprivation Category (SIMD) ----
      
      
      tabPanel(
        "Deprivation Category (SIMD)",
        h3("Deprivation Category (SIMD)"),
        wellPanel(
          style = "overflow-y:scroll; 
          max-height: 250px;
          padding: 0px",
          p("In Scotland the Scottish Index of Multiple Deprivation (SIMD) 
            is used to measure deprivation. It combines information on 
            income, employment, education, housing, health, crime and 
            geographical access. For this analysis, the area of concern 
            (each HSCP or Scotland) were divided into five equal groups 
            based on population size.  Deprivation quintile 1 relates to the 
            most deprived areas and deprivation quintile 5 relates to the 
            least deprived areas. SIMD 2016 was used for the analysis."),
          tags$b("Data completeness"),
          p("The analysis presents the deprivation category for all people 
            accessing social care services. Some areas were not able to 
            provide individual level information for people accessing some 
            services and therefore a deprivation category was not able to be 
            assigned for these people."),
          p("The following health & social care partnerships were unable to 
            provide client level information for some support or services 
            and therefore the deprivation information presented will not 
            reflect all people accessing social care/services:"),
          tags$ul(
            tags$li("Self-directed support - Fife HSCP"),
            tags$li("Self-directed support - Comhairle nan Eilean Siar HSCP 
                    Option 3 only"),
            tags$li("Community alarms/telecare -  Scottish Borders and South 
                    Lanarkshire HSCP"),
            tags$li("Community alarms/telecare East Lothian HSCP - 
                    clients only with services that began prior to 2017/18 
                    (1,945 clients - some may be counted under other 
                    services)"),
            tags$li("Housing support - North Lanarkshire, Orkney Islands, 
                    Shetland, West Dunbartonshire HSCPs"),
            tags$li("Meals - North Lanarkshire HSCP"),
            tags$li("Day care - Argyll & Bute, North Lanarkshire, 
                    Orkney Islands HSCPs"),
            tags$li("Social worker - Renfrewshire, West Dunbartonshire 
                    HSCPs"),
            tags$li("Care home - Comhairle nan Eilean Siar HSCP (197 clients 
                    - some may be counted under other services)"),
            tags$li("Glasgow City HSCP (all services/support)")
            ),
          p("To reflect the data completeness issues an 'All Areas submitted' 
            total is provided rather than a Scotland total."),
          p("Please note that for care home residents the Deprivation quintile has
            been allocated to the postcode of the care home."),
          p("Individual records for people without a known postcode have been 
            recorded under `unknown` when the table option is selected.")
          ),
        wellPanel(column(6, shinyWidgets::pickerInput("ClientsPartnership5Input",
                                                      "Select Location:",
                                                      choices = unique(data_clients_deprivation$sending_location),
                                                      selected = "Scotland"
        ))),
        mainPanel(
          width = 12,
          downloadButton(
            outputId = "download_clients_deprivation",
            label = "Download data",
            class = "myClientsdeprivationbutton"
          ),
          tags$head(
            tags$style(".myClientsdeprivationbutton { 
                       background-color: #0072B2; 
                } 
                       .myClientsdeprivationbutton { 
                       color: #FFFFFF; 
                       }")
              ),
          br(),
          plotlyOutput("Clientsdeprivation"),
          br(),
          br(),
          actionButton("Clientsdeprivationbutton",
                       "Show/hide table",
                       style = "color: #fff;
                       background-color:#2171b5; 
                       border-color: #636363"
          ),
          hidden(
            div(
              id = "ClientsDeprivationTable",
              DT::dataTableOutput("table_clients_deprivation")
            )
          )
            )
          ),
      
      
      ## Tab 6.4: Ethnicity Group ----
      
      
      tabPanel(
        "Ethnicity Group",
        h3("Ethnicity Group"),
        wellPanel(
          style = "overflow-y:scroll; 
          max-height: 250px;
          padding: 0px",
          p("Information is presented on the ethnicity of people accessing 
            all social care services/support. Due to small numbers some 
            ethnicity groups have been grouped into a category 'Other'. 
            This category includes: Caribbean or Black, African, Asian and 
            Other Ethnic Groups."),
          p("There are two measures presented:"),
          tags$ul(
            tags$li("Number of people supported"),
            tags$li("Number of people supported - 'adjusted' (allows 
                    comparison with the Scottish Government social care 
                    census)")
          ),
          tags$b("Data completeness"),
          p("The following areas were unable to provide client level 
            information for some support or services and therefore the 
            ethnicity information presented will not reflect all people 
            accessing social care servicesand support:"),
          tags$ul(
            tags$li("Self-directed support - Fife HSCP"),
            tags$li("Self-directed support - Comhairle nan Eilean Siar HSCP 
                    Option 3 only"),
            tags$li("Community alarms/telecare -  Scottish Borders and South 
                    Lanarkshire HSCP"),
            tags$li("Community alarms/telecare East Lothian HSCP - 
                    clients only with services that began prior to 2017/18 
                    (1,945 clients - some may be counted under other 
                    services)"),
            tags$li("Housing support - North Lanarkshire, Orkney Islands, 
                    Shetland, West Dunbartonshire HSCPs"),
            tags$li("Meals - North Lanarkshire HSCP"),
            tags$li("Day care - Argyll & Bute, North Lanarkshire, 
                    Orkney Islands HSCPs"),
            tags$li("Social worker - Renfrewshire, West Dunbartonshire 
                    HSCPs"),
            tags$li("Care home - Comhairle nan Eilean Siar HSCP (197 clients 
                    - some may be counted under other services)"),
            tags$li("Glasgow City HSCP (all services/support)")
            ),
          p("To reflect the data completeness issues an 'All Areas submitted' 
            total is provided rather than a Scotland total.")
          ),
        wellPanel(
          column(6, shinyWidgets::pickerInput("ClientsPartnership3Input",
                                              "Select Location:",
                                              choices = unique(data_clients_ethnicity$sending_location),
                                              selected = "Scotland"
          )),
          column(6, shinyWidgets::pickerInput("ClientsType3Input",
                                              "Select Measure:",
                                              choices = unique(data_clients_ethnicity$Reason)
          ))
        ),
        downloadButton(
          outputId = "download_clients_ethnicity",
          label = "Download data",
          class = "myClientsethnicitybutton"
        ),
        tags$head(
          tags$style(".myClientsethnicitybutton { 
                     background-color: #0072B2; 
                } 
                     .myClientsethnicitybutton { 
                     color: #FFFFFF; 
                     }")
            ),
        mainPanel(
          width = 12,
          DT::dataTableOutput("table_clients_ethnicity")
        )
          ),
      
      
      ## Tab 6.4: Social Care Client Group ----
      
      
      tabPanel(
        "Social Care Client Group",
        h3("Social Care Client Group"),
        wellPanel(
          style = "overflow-y:scroll; 
          max-height: 250px;
          padding: 0px",
          p("The different client groups of people accessing social care 
            services/support are presented here. It is possible for people 
            to be in more than one client group; therefore figures across 
            client groups cannot be added together to give an overall total 
            (because there will be double-counting)."),
          p("There are two measures presented:"),
          tags$ul(
            tags$li("Number of people supported"),
            tags$li("Number of people supported - 'adjusted' (allows 
                    comparison with the Scottish Government social care 
                    census)")
          ),
          tags$b("Data completeness"),
          p("The following areas were unable to provide client level 
            information for some support or services and therefore the 
            client group information presented will not reflect all people 
            accessing social care servicesand support."),
          tags$ul(
            tags$li("Scottish Borders HSCP community alarm/telecare"),
            tags$li("South Lanarkshire HSCP community alarm/telecare"),
            tags$li("Fife HSCP self directed support"),
            tags$li("Glasgow City HSCP (all sections)"),
            tags$li("Comhairle nan Eilean Siar HSCP care home"),
            tags$li("East Lothian HSCP could only provide client group for 
                    community alarm/telecare clients with new services in 
                    financial year 2017/18")
            ),
          p("To reflect the data completeness issues an 'All Areas submitted' 
            total  is provided rather than a Scotland total."),
          tags$b("Age Band"),
          p("Due to small numbers, and to minimise the risk of 
            identification of individuals, age band can only be selected 
            when then the 'All Areas submitted' location is selected."),
          tags$b("Client Group"),
          p("The category 'Other' within client group includes Drugs, Alcohol, 
            Palliative Care, Carer, Neurological condition (excluding Dementia), 
            Autism and Other Vulnerable Groups.")
          ),
        wellPanel(
          column(6, shinyWidgets::pickerInput("ClientsPartnership2Input",
                                              "Select Location:",
                                              choices = unique(data_clients_client_group$sending_location),
                                              selected = "Scotland"
          )),
          column(6, uiOutput("ClientsAgeBandInput")),
          column(6, shinyWidgets::pickerInput("ClientsType2Input",
                                              "Select Measure:",
                                              choices = unique(data_clients_client_group$Measure)
          ))
        ),
        mainPanel(
          width = 12,
          downloadButton(
            outputId = "download_clients_clienttype",
            label = "Download data",
            class = "myClientsclienttypebutton"
          ),
          tags$head(
            tags$style(".myClientsclienttypebutton { 
                       background-color: #0072B2; 
                } 
                       .myClientsclienttypebutton { 
                       color: #FFFFFF; 
                       }")
              ),
          plotlyOutput("Clientsclienttype",
                       height = "600px"
          ),
          br(),
          actionButton("Clientsclienttypebutton",
                       "Show/hide table",
                       style = "color: #fff;
                       background-color:#2171b5; 
                       border-color: #636363"
          ),
          hidden(
            div(
              id = "ClientsClientTypeTable",
              DT::dataTableOutput("table_clients_clienttype")
            )
          )
            )
        ),
      
      
      ## Tab 6.5: Support and Services ----  
      
      
      tabPanel(
        "Support and Services",
        h3("Support and Services"),
        p("This section provides information on the number of people 
          receiving different types of service/support."),
        p("Data for Meals, Home Care and Care Homes were provided for the 
          period January to March 2018 (Quarter ending March 2018), and data 
          for Self Directed Support and Community Alarm/Telecare were 
          provided for the full financial year (April 2017 to March 2018). 
          Housing support, day care and social worker information were provided for a 
          mixture of the two time periods (full financial year or Quarter 
          ending March 2018). To aid interpretation of the different time 
          periods presented in the chart below, the colour of the columns 
          indicates the time period."),
        tags$b("Data completeness"),
        p("The table below highlights the areas which were not able to 
          provide information on all the different type of 
          services/support. If a specific service doesn't appear then the
          partnership has indiated that there was no active services within
          time period."),
        actionButton("supportservicesexpandbutton",
                     icon = icon("plus-square"),
                     "Show/hide table",
                     style = "border-color: #fff;
                     background-color:#fff"
        ),
        tags$head(
          tags$style(HTML(".fa-plus-square { color:#2171b5 }"))
        ),
        hidden(
          div(
            id = "ServiceSupportTable",
            tableOutput("Service_Support_Table")
          )
        ),
        p("To reflect data completeness issues an 'All Areas Submitted' 
          total is provided rather than a Scotland total."),
        wellPanel(column(6, shinyWidgets::pickerInput("ClientsPartnership4Input",
                                                      "Select Location:",
                                                      choices = unique(data_clients_support_services$sending_location),
                                                      selected = "Scotland"
        ))),
        mainPanel(
          width = 12,
          downloadButton(
            outputId = "download_clients_summary",
            label = "Download data",
            class = "myClientssummarybutton"
          ),
          tags$head(
            tags$style(".myClientssummarybutton { 
                       background-color: #2171b5; 
                       } 
                       .myClientssummarybutton { 
                       color: #FFFFFF; 
                       }")
              ),
          plotlyOutput("GroupA",
                       height = "500px",
                       width = "1000px"
          ),
          br(),
          actionButton("Clientssummarybutton",
                       "Show/hide table",
                       style = "color: #fff;
                       background-color:#0072B2; 
                       border-color: #636363"
          ),
          hidden(
            div(
              id = "ClientsSummaryTable",
              DT::dataTableOutput("table_clients_summary")
            )
          )
            )
        ),
      
      
      ## Tab 6.6 Meals ----
      
      
      tabPanel(
        "Meals",
        h3("Meals"),
        p("This section presents information on the number of people 
          receiving a meals service at any point between 1 January to 31 
          March 2018."),
        tags$b("Data completeness"),
        p("North Lanarkshire HSCP was unable to provide meals data and are 
          therefore not presented in the chart or table below. The following partnerships
          indicated there were no active clients (or was unknown) in this time 
          period: Argyll & Bute, Comhairle nan Eilean Siar, City of Edinburgh,
          East Renfrewshire, Perth & Kinross and South Ayrshire. To reflect 
          the data completeness issues an 'All Areas submitted' total is 
          provided rather than a Scotland total."),
        tags$b("Disclosure Control"),
        p(
          "* within the table indicates that values that have been suppressed 
          due to the potential risk of disclosure and to help maintain 
          confidentiality the chart will not be shown. For further guidance 
          see ISD's",
          tags$a(href = "https://www.isdscotland.org/About-ISD/Confidentiality/disclosure_protocol_v3.pdf", 
                 "Statistical Disclosure Control Protocol.")
        ),
        wellPanel(column(6, shinyWidgets::pickerInput("MealsPartnershipInput",
                                                      "Select Location:",
                                                      choices = unique(data_clients_meals$sending_location),
                                                      selected = "Scotland"
        ))),
        br(),
        mainPanel(
          width = 12,
          downloadButton(
            outputId = "download_clients_meals",
            label = "Download data",
            class = "myclientsmealsbutton"
          ),
          tags$head(
            tags$style(".myclientsmealsbutton { 
                       background-color: #2171b5; 
                } 
                       .myclientsmealsbutton { 
                       color: #FFFFFF; 
                       }")
              ),
          plotlyOutput("mealsoutput"),
          br(),
          br(),
          actionButton("mealsbutton",
                       "Show/hide table",
                       style = "color: #fff;
                       background-color:#2171b5; 
                       border-color: #636363"
          ),
          hidden(
            div(
              id = "ClientsMealsTable",
              DT::dataTableOutput("table_clients_meals")
            )
          )
            )
          )
        )
        )
      )
      )
  )