############################################################
### UI Script
### Author: Ciaran Harvey
### Orignal Date: 05/06/19
### Written/run on R Studio Server
### R version 3.2.3
### Server script for dashbaord
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


### Server ----

server <- function(input, output, session) {
  
  
  ########################
  ### Self Directed Support (SDS) ----
  ########################
  
  
  ## X.1.1 SDS Trend in Direct Payments ----
  
  SDSTrendD <- reactive({
    data_SDS_trend %>%
      filter(sending_location == input$SDSPartnership2Input)
  })
  
  
  output$SDSTrend <- renderPlotly({
    plot_ly(SDSTrendD(),
            x = ~year,
            y = ~Total_Option1,
            type = "scatter",
            mode = "lines+markers",
            name = "Number of People",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Financial Year:", year,
              "<br>",
              "Number of People:", formatC(Total_Option1, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        yaxis = list(
          rangemode = "tozero",
          title = "Number of People",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        xaxis = list(
          title = "Financial Year",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse(input$SDSPartnership2Input == "Scotland",
                       paste("<b>Number of people in", input$SDSPartnership2Input, "choosing direct payments (SDS Option 1)<br>2007/08 - 2017/18<b>"),
                       paste("<b>Number of people in", input$SDSPartnership2Input, "HSCP choosing<br>direct payments (SDS Option 1) 2007/08 - 2017/18<b>")
        ),
        margin = list(l = 10, r = 10, b = 70, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  
  observeEvent(input$SDSbutton3, {
    toggle("SDSTrendtable")
    output$table_SDS_trend <- DT::renderDataTable(DT::datatable(SDSTrendD() %>%
                                                                  select(sending_location, year, Total_Option1) %>%
                                                                  mutate(Total_Option1 = formatC(Total_Option1, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                style = "bootstrap",
                                                                class = "table-bordered table-condensed",
                                                                rownames = FALSE,
                                                                colnames = c(
                                                                  "Location",
                                                                  "Financial Year",
                                                                  "Number of People"
                                                                ),
                                                                options = list(
                                                                  pageLength = 16,
                                                                  autoWidth = TRUE,
                                                                  dom = "tip",
                                                                  columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                  bPaginate = FALSE,
                                                                  bInfo = FALSE
                                                                )
    ))
  })
  
  
  
  output$download_SDS_trend <- downloadHandler(
    filename = "sds_trend.csv",
    content = function(file) {
      write.table(data_SDS_trend %>%
                    select(sending_location, year, Total_Option1) %>%
                    mutate(Total_Option1 = formatC(Total_Option1, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Financial Year",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.1.2 SDS Direct Payments ----
  
  
  output$SDSDirectPayments <- renderPlotly({
    plot_ly(data_SDS_direct_payments %>%
              filter(!(sending_location == "Scotland (estimated)")),
            x = ~sending_location,
            y = ~Option1_Pop_per_thous,
            hoverinfo = "text",
            text = ~ paste(
              "HSCP:", sending_location,
              "<br>",
              "Rate per 1,000 population of people receiving direct payments:", Option1_Pop_per_thous
            ),
            type = "bar",
            showlegend = FALSE
    ) %>%
      add_trace(
        color = I("red"),
        name = "Scotland (estimated)",
        y = ~Rate2,
        x = ~sending_location,
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "Scotland (estimated)",
          "<br>",
          "Rate per 1,000 population of people receiving direct payments:", Rate2
        ),
        inherit = FALSE,
        showlegend = TRUE
      ) %>%
      layout(
        xaxis = list(
          tickangle = -90,
          showline = TRUE,
          ticks = "outside",
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health & Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2
        ),
        yaxis = list(
          title = "Rate per 1,000 population",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        title = paste("<b>People receiving direct payments (Option 1); rate per 1,000 population: 2017/18<b>"),
        margin = list(l = 10, r = 10, b = 90, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$SDSbutton2, {
    toggle("SDSDirectPaymentstable")
    output$table_SDS_directpayment <- DT::renderDataTable(DT::datatable(data_SDS_direct_payments %>%
                                                                          select(-AgeGroup, -Rate2) %>%
                                                                          arrange(factor(sending_location, levels = InputSort)) %>%
                                                                          mutate(Total_Option1 = formatC(Total_Option1, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                        style = "bootstrap",
                                                                        class = "table-bordered table-condensed",
                                                                        rownames = FALSE,
                                                                        colnames = c(
                                                                          "Location",
                                                                          "Number of people receiving direct payments",
                                                                          "Rate per 1,000 population"
                                                                        ),
                                                                        options = list(
                                                                          pageLength = 16,
                                                                          autoWidth = TRUE,
                                                                          columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                          dom = "tip",
                                                                          bPaginate = FALSE,
                                                                          bInfo = FALSE
                                                                        )
    ))
  })
  
  output$download_SDS_directpayment <- downloadHandler(
    filename = "sds_directpayment.csv",
    content = function(file) {
      write.table(data_SDS_direct_payments %>%
                    select(-AgeGroup, -Rate2) %>%
                    arrange(factor(sending_location, levels = InputSort)) %>%
                    mutate(Total_Option1 = formatC(Total_Option1, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Number of people receiving direct payments",
                    "Rate per 1,000 population"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.1.3 SDS Options Chosen ----
  
  SDSOptionLAD <- reactive({
    data_SDS_options_chosen %>%
      filter(sending_location == input$SDSPartnership5Input)
  })
  
  output$SDSAge2Input <- renderUI({
    shinyWidgets::pickerInput("SDSAgeXInput",
                              "Select Age Band:",
                              choices = unique(SDSOptionLAD()$AgeGroup),
                              selected = "All ages"
    )
  })
  
  SDSOptionX <- reactive({
    SDSOptionLA %>%
      filter(
        sending_location == input$SDSPartnership5Input,
        AgeGroup == input$SDSAgeXInput
      )
  })
  
  output$SDSOptionLA <- renderPlotly({
    plot_ly(SDSOptionX(),
            x = ~Option,
            y = ~ as.numeric(nclient),
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Age Band:", AgeGroup,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        barmode = "stack",
        margin = list(l = 10, r = 10, b = 70, t = 90),
        titlefont = f1,
        title = ifelse(input$SDSPartnership5Input == "All Areas Submitted",
                       paste("<b>Number of people in", input$SDSPartnership5Input, "receiving self directed support<br>by option chosen for age group", input$SDSAgeXInput, ", 2017/18"),
                       paste("<b>Number of people in", input$SDSPartnership5Input, "HSCP receiving self directed support<br>by option chosen for age group", input$SDSAgeXInput, ", 2017/18")
        ),
        xaxis = list(
          showline = TRUE,
          titlefont = f2,
          ticks = "outside",
          title = "SDS Option"
        ),
        yaxis = list(
          showline = TRUE,
          titlefont = f2,
          title = "Number of People",
          exponentformat = "none",
          ticks = "outside"
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  
  
  observeEvent(input$SDSoptionsbutton, {
    toggle("SDSOptionstable")
    output$table_SDS_options <- DT::renderDataTable(DT::datatable(SDSOptionX() %>%
                                                                    mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                  style = "bootstrap",
                                                                  class = "table-bordered table-condensed",
                                                                  rownames = FALSE,
                                                                  colnames = c(
                                                                    "Location",
                                                                    "Age Band",
                                                                    "SDS Option",
                                                                    "Number of People"
                                                                  ),
                                                                  options = list(
                                                                    pageLength = 16,
                                                                    autoWidth = TRUE,
                                                                    dom = "tip",
                                                                    columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                    bPaginate = FALSE,
                                                                    bInfo = FALSE
                                                                  )
    ))
  })
  
  output$download_SDSOptionLA_totals <- downloadHandler(
    filename = "sds_options_chosen.csv",
    content = function(file) {
      write.table(data_SDS_options_chosen %>%
                    mutate(nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Age Band",
                    "SDS Option",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.1.4 SDS Client Group Profile ----
  
  SDSClientTypeD <- reactive({
    data_SDS_client_group %>%
      filter(sending_location == input$SDSPartnership3Input)
  })
  
  output$SDSAge3Input <- renderUI({
    shinyWidgets::pickerInput("SDSAge3XInput",
                              "Select Age Band:",
                              choices = unique(SDSClientTypeD()$AgeGroup),
                              selected = "All ages"
    )
  })
  
  SDSClientTypeX <- reactive({
    SDSClientType %>%
      filter(
        sending_location == input$SDSPartnership3Input,
        AgeGroup == input$SDSAge3XInput
      )
  })
  
  output$SDSClientType <- renderPlotly({
    plot_ly(SDSClientTypeX() %>%
              mutate(AllOptions = ifelse(AllOptions < 5, "NA", AllOptions)),
            x = ~Client_Group,
            y = ~ as.numeric(AllOptions),
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Client Group:", Client_Group,
              "<br>",
              "Number of People:", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          showline = TRUE,
          ticks = "outside",
          categoryorder = "category array",
          categoryarray = ~ as.numeric(AllOptions),
          tickangle = -90,
          title = paste0(c(
            rep("&nbsp;", 10),
            "Client Group",
            rep("&nbsp;", 10),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2
        ),
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none"
        ),
        title = ifelse(input$SDSPartnership3Input == "All Areas Submitted",
                       paste("<b>People receiving Self-Directed Support (all Options) in", input$SDSPartnership3Input, ":<br>by Client Group category for age group", input$SDSAge3XInput, ", 2017/18"),
                       paste("<b>People receiving Self-Directed Support (all Options) in", input$SDSPartnership3Input, "HSCP:<br>by Client Group category for age group", input$SDSAge3XInput, ", 2017/18")
        ),
        margin = list(l = 10, r = 10, b = 90, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$SDSClientTypebutton, {
    toggle("SDSClientTypetable")
    output$table_SDS_clienttype <- DT::renderDataTable(DT::datatable(SDSClientTypeX() %>%
                                                                       select(-order) %>%
                                                                       mutate(AllOptions = ifelse(is.na(AllOptions) | AllOptions < 5, "*", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                     style = "bootstrap",
                                                                     class = "table-bordered table-condensed",
                                                                     rownames = FALSE,
                                                                     colnames = c(
                                                                       "Loation",
                                                                       "Age Band",
                                                                       "Client Group",
                                                                       "Number of People"
                                                                     ),
                                                                     options = list(
                                                                       pageLength = 16,
                                                                       autoWidth = TRUE,
                                                                       columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                       dom = "tip",
                                                                       bPaginate = FALSE,
                                                                       bInfo = FALSE
                                                                     )
    ))
  })
  
  output$download_SDS_clienttype <- downloadHandler(
    filename = "sds_client_group.csv",
    content = function(file) {
      write.table(data_SDS_client_group %>%
                    select(-order) %>%
                    mutate(AllOptions = ifelse(is.na(AllOptions), "*", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Loation",
                    "Age Band",
                    "Client Group",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.1.5 SDS Support/Services ----
  
  SDSSupportNeedD <- reactive({
    data_SDS_support_services %>%
      filter(sending_location == input$SDSPartnership4Input)
  })
  
  output$SDSSupport <- renderPlotly({
    plot_ly(SDSSupportNeedD() %>%
              mutate(
                SDSSupport = ifelse(SDSSupport == "Equipment and Temporary Adaptations", "Equipment and Temp...",
                                    ifelse(SDSSupport == "Social Educational Recreational", "Social Educational...", SDSSupport)
                ),
                AllOptions = ifelse(is.na(AllOptions) | AllOptions < 5, "*", AllOptions)
              ),
            x = ~SDSSupport,
            y = ~ as.numeric(AllOptions),
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "SDS Support:", ifelse(SDSSupport == "Equipment and Temp...", "Equipment and Temporary Adaptations",
                                     ifelse(SDSSupport == "Social Educational...", "Social Educational Recreational", SDSSupport)
              ),
              "<br>",
              "Number of People:", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          title = paste0(c(
            rep("&nbsp;", 40),
            "Support Need",
            rep("&nbsp;", 40),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          categoryorder = "category array",
          categoryarray = ~AllOptions,
          ticks = "outside",
          tickangle = -90
        ),
        yaxis = list(
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse(input$SDSPartnership4Input == "All Areas Submitted",
                       paste("<b>People receiving Self-Directed Support (all Options) in", input$SDSPartnership4Input, ":<br>by assessed support need, 2017/18<b>"),
                       paste("<b>People receiving Self-Directed Support (all Options) in", input$SDSPartnership4Input, "HSCP:<br>by assessed support need, 2017/18<b>")
        ),
        margin = list(l = 10, r = 10, b = 190, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$SDSSupportNeedbutton, {
    toggle("SDSSupportNeedtable")
    output$table_SDS_supportneed <- DT::renderDataTable(DT::datatable(SDSSupportNeedD() %>%
                                                                        select(-order) %>%
                                                                        mutate(AllOptions = ifelse(is.na(AllOptions) | AllOptions < 5, "*", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                      style = "bootstrap",
                                                                      class = "table-bordered table-condensed",
                                                                      rownames = FALSE,
                                                                      colnames = c(
                                                                        "Location",
                                                                        "SDS Support",
                                                                        "Number of People"
                                                                      ),
                                                                      options = list(
                                                                        pageLength = 16,
                                                                        autoWidth = TRUE,
                                                                        columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                        dom = "tip",
                                                                        bPaginate = FALSE,
                                                                        bInfo = FALSE
                                                                      )
    ))
  })
  
  output$download_SDS_supportneed <- downloadHandler(
    filename = "sds_support_services_need.csv",
    content = function(file) {
      write.table(data_SDS_support_services %>%
                    select(-order) %>%
                    mutate(AllOptions = ifelse(is.na(AllOptions), "*", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "SDS Support",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.1.6 SDS Type of Organisation ----
  
  SDSMechanismD <- reactive({
    data_SDS_type_of_organisation %>%
      filter(sending_location == input$SDSPartnership6Input)
  })
  
  output$SDSMechanism <- renderPlotly({
    plot_ly(SDSMechanismD() %>%
              mutate(AllOptions = ifelse(is.na(AllOptions) | AllOptions < 5, "NA", AllOptions)),
            x = ~SDSSupport,
            y = ~ as.numeric(AllOptions),
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Support Organisation Type:", SDSSupport,
              "<br>",
              "Number of People:", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        title = ifelse(input$SDSPartnership6Input == "All Areas Submitted",
                       paste("<b>People receiving Self-Directed Support (all Options) in", input$SDSPartnership6Input, ":<br>by support organisation type: 2017/18<b>"),
                       paste("<b>People receiving Self-Directed Support (all Options) in", input$SDSPartnership6Input, "HSCP:<br>by support organisation type: 2017/18<b>")
        ),
        xaxis = list(
          showline = TRUE,
          ticks = "outside",
          title = "Support Organisation Type",
          titlefont = f2,
          categoryorder = "category array",
          categoryarray = ~AllOptions
        ),
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none"
        ),
        margin = list(l = 10, r = 10, b = 90, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$SDSSupportMechanismbutton, {
    toggle("SDSSupportMechanismtable")
    output$table_SDS_supportmechanism <- DT::renderDataTable(DT::datatable(SDSMechanismD() %>%
                                                                             select(-order) %>%
                                                                             mutate(AllOptions = ifelse(is.na(AllOptions) | AllOptions < 5, "*", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                           style = "bootstrap",
                                                                           class = "table-bordered table-condensed",
                                                                           rownames = FALSE,
                                                                           colnames = c(
                                                                             "Loation",
                                                                             "SDS Mechanism",
                                                                             "Number of People"
                                                                           ),
                                                                           options = list(
                                                                             pageLength = 16,
                                                                             autoWidth = TRUE,
                                                                             columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                             dom = "tip",
                                                                             bPaginate = FALSE,
                                                                             bInfo = FALSE
                                                                           )
    ))
  })
  
  output$download_SDS_supportmechanism <- downloadHandler(
    filename = "sds_support_mechanism.csv",
    content = function(file) {
      write.table(data_SDS_type_of_organisation %>%
                    select(-order) %>%
                    mutate(AllOptions = ifelse(is.na(AllOptions), "*", formatC(AllOptions, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Loation",
                    "SDS Mechanism",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  ### HOME CARE SECTION ----
  
  # X.2.1 Trend in Home Care Numbers and Hours ----
  
  # Trend Data
  
  TrendD <- reactive({
    data_homecare_trend %>%
      filter(sending_location == input$PartnershipHC1Input)
  })
  
  # Trend number client chart
  output$Trend <- renderPlotly({
    plot_ly(TrendD(),
            x = ~Year,
            y = ~ncleint,
            type = "scatter",
            mode = "lines+markers",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Census Week Year:", Year,
              "<br>",
              "Number of People:", formatC(ncleint, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            name = "Number of Clients"
    ) %>%
      layout(
        yaxis = list(
          rangemode = "tozero",
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        xaxis = list(
          title = "Census Week in March",
          titlefont = f2,
          tickangle = -90,
          showline = TRUE,
          type = "category",
          ticks = "outside"
        ),
        title = ifelse(input$PartnershipHC1Input == "Scotland",
                       paste("<b>Number of people in", input$PartnershipHC1Input, "<br>receiving home care during census week<br>in March 2010 to 2018<b>"),
                       paste("<b>Number of people in", input$PartnershipHC1Input, "HSCP<br>receiving home care during census week<br>in March 2010 to 2018<b>")
        ),
        margin = list(l = 80, r = 10, b = 10, t = 80),
        titlefont = list(size = 14)
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Trend number hours chart
  output$Trend2 <- renderPlotly({
    plot_ly(TrendD(),
            x = ~Year,
            y = ~nhours,
            type = "scatter",
            mode = "lines+markers",
            color = "orange",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Census Week Year:", Year,
              "<br>",
              "Number of Hours:", formatC(nhours, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            name = "Number of Clients"
    ) %>%
      layout(
        yaxis = list(
          rangemode = "tozero",
          title = "Number of Hours",
          titlefont = f2,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        xaxis = list(
          title = "Census Week in March",
          titlefont = f2,
          tickangle = -90,
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse(input$PartnershipHC1Input == "Scotland",
                       paste("<b>Number of home care hours in<br>", input$PartnershipHC1Input, "during census week<br>in March 2010 to 2018<b>"),
                       paste("<b>Number of home care hours in<br>", input$PartnershipHC1Input, "HSCP during census week<br>in March 2010 to 2018<b>")
        ),
        margin = list(l = 80, r = 10, b = 10, t = 80),
        titlefont = list(size = 14)
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  
  # Trend table show/hide
  
  observeEvent(input$HCtrendbutton, {
    toggle("HCtrendtable")
    output$table_HC_trend <- DT::renderDataTable(DT::datatable(TrendD() %>%
                                                                 select(sending_location, Year, ncleint, nhours) %>%
                                                                 mutate(
                                                                   ncleint = formatC(ncleint, format = "f", big.mark = ",", drop0trailing = TRUE),
                                                                   nhours = formatC(nhours, format = "f", big.mark = ",", drop0trailing = TRUE)
                                                                 ),
                                                               style = "bootstrap",
                                                               class = "table-bordered table-condensed",
                                                               rownames = FALSE,
                                                               colnames = c(
                                                                 "Location",
                                                                 "Census Week Year",
                                                                 "Number of People",
                                                                 "Number of Hours"
                                                               ),
                                                               options = list(
                                                                 pageLength = 16,
                                                                 autoWidth = TRUE,
                                                                 columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                 dom = "tip",
                                                                 bPaginate = FALSE,
                                                                 bInfo = FALSE
                                                               )
    ))
  })
  
  output$download_homecare_trend <- downloadHandler(
    filename = "homecare_trend.csv",
    content = function(file) {
      write.table(data_homecare_trend %>%
                    select(sending_location, Year, ncleint, nhours) %>%
                    mutate(
                      ncleint = formatC(ncleint, format = "f", big.mark = ",", drop0trailing = TRUE),
                      nhours = formatC(nhours, format = "f", big.mark = ",", drop0trailing = TRUE)
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Census week year",
                    "Number of People",
                    "Number of Hours"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.2 Home Care Numbers and Hours by Locality ----
  
  # Locality Data
  
  LocalityD <- reactive({
    data_homecare_locality %>%
      filter(
        sending_location == input$PartnershipHC2Input,
        Measure == input$MeasureHCInput
      )
  })
  
  
  
  
  output$HCLocality <- renderPlotly({
    if (input$PartnershipHC2Input %in% c("Midlothian", "Moray", "North Ayrshire") & input$MeasureHCInput == "Number of Hours") {
      text_locality_homecare <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$PartnershipHC2Input, "HSCP were unable to provide home care hours data for 2017/18 and are excluded from the chart."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      plot_ly() %>%
        layout(
          annotations = text_locality_homecare,
          
          yaxis = list(
            showline = FALSE,
            
            showticklabels = FALSE,
            
            showgrid = FALSE
          ),
          
          xaxis = list(
            showline = FALSE,
            
            showticklabels = FALSE,
            
            showgrid = FALSE
          )
        ) %>%
        config(
          displayModeBar = FALSE,
          
          displaylogo = F, collaborate = F, editable = F
        )
    }
    
    else {
      plot_ly(LocalityD() %>%
                mutate(
                  Locality = recode(Locality,
                                    "Skye, Lochalsh and West Ross" = "Skye, Loachalsh...",
                                    "Badenoch and Strathspey" = "Badenoch & Stra...",
                                    "Ayr North and Former Coalfield Communities" = "Ayr North and Former...",
                                    "Maybole and North Carrick Communities" = "Maybole and North...",
                                    "Girvan and South Carrick Villages" = "Girvan and South..."
                  ),
                  value = ifelse(is.na(value) | value < 5, "NA", value)
                ),
              x = ~Locality,
              y = ~ as.numeric(value),
              type = "bar",
              hoverinfo = "text",
              text = ~ paste(
                "HSCP Locality:", ifelse(Locality == "Badenoch & Stra...", "Badenoch and Strathspey",
                                         ifelse(Locality == "Skye, Loachalsh...", "Skye, Lochalsh and West Ross",
                                                ifelse(Locality == "Ayr North and Former...", "Ayr North and Former Coalfield Communities",
                                                       ifelse(Locality == "Maybole and North...", "Maybole and North Carrick Communities",
                                                              ifelse(Locality == "Girvan and South...", "Girvan and South Carrick Villages", Locality)
                                                       )
                                                )
                                         )
                ),
                "<br>",
                input$MeasureHCInput, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        layout(
          xaxis =
            list(
              title = "Health & Social Care Partnership Locality",
              titlefont = f2,
              showline = TRUE,
              ticks = "outside",
              categoryorder = "array",
              categoryarray = ~value,
              tickangle = ifelse(LocalityD()$sending_location %in% c("Argyll & Bute", "Dundee City", "Shetland", "Highland", "South Ayrshire"),
                                 -90, 0
              )
            ),
          yaxis =
            list(
              title = paste(input$MeasureHCInput),
              titlefont = f2,
              showline = TRUE,
              ticks = "outside",
              exponentformat = "none"
            ),
          title = ifelse(input$PartnershipHC2Input == "All Areas Submitted" & input$MeasureHCInput == "Number of People",
                         paste("<b>Number of people in<b>", input$PartnershipHC2Input, "<b>receiving home care by<br>Locality: January - March 2018"),
                         ifelse(input$PartnershipHC2Input == "All Areas Submitted" & input$MeasureHCInput == "Number of Hours",
                                paste("<b>Number of home care hours in<b>", input$PartnershipHC2Input, "<b>by<br>Locality: January - March 2018"),
                                ifelse(input$PartnershipHC2Input != "All Areas Submitted" & input$MeasureHCInput == "Number of People",
                                       paste("<b>Number of people in<b>", input$PartnershipHC2Input, "<b>HSCP receiving home care by<br>Locality: January - March 2018"),
                                       paste("<b>Number of home care hours in<b>", input$PartnershipHC2Input, "<b>HSCP by<br>Locality: January - March 2018")
                                )
                         )
          ),
          margin = list(l = 10, r = 10, b = 50, t = 40),
          titlefont = f1
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = list(
            "select2d", "lasso2d",
            "zoomIn2d", "zoomOut2d",
            "autoScale2d",
            "resetScale2d",
            "zoom2d",
            "pan2d",
            "toggleSpikelines",
            "hoverCompareCartesian",
            "hoverClosestCartesian"
          ),
          displaylogo = F, collaborate = F, editable = F
        )
    }
  })
  
  
  
  # Locality table show/hide
  
  observeEvent(input$HClocalitybutton, {
    toggle("HClocalitytable")
    output$table_HC_locality <- DT::renderDataTable(DT::datatable(LocalityD() %>%
                                                                    select(sending_location, Locality, Measure, value) %>%
                                                                    mutate(value = ifelse(is.na(value) | value < 5, "*", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                  style = "bootstrap",
                                                                  class = "table-bordered table-condensed",
                                                                  rownames = FALSE,
                                                                  colnames = c(
                                                                    "Location",
                                                                    "Locality",
                                                                    "Measure",
                                                                    paste(input$MeasureHCInput)
                                                                  ),
                                                                  options = list(
                                                                    pageLength = 16,
                                                                    autoWidth = TRUE,
                                                                    columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                    dom = "tip",
                                                                    bPaginate = FALSE,
                                                                    bInfo = FALSE
                                                                  )
    ))
  })
  
  output$download_homecare_locality <- downloadHandler(
    filename = "homecare_locality.csv",
    content = function(file) {
      write.table(data_homecare_locality %>%
                    select(sending_location, Locality, Measure, value) %>%
                    mutate(value = ifelse(is.na(value) | value < 5, "*", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Locality",
                    "Measure",
                    paste(input$MeasureHCInput)
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  # X.2.3 Client Groups Receiving Home Care ----
  
  
  output$AgeHCInput <- renderUI({
    shinyWidgets::pickerInput("AgeHCXInput",
                              "Select Age Band:",
                              choices = unique(HCClientsDataE$Age_Band[HCClientsDataE == input$PartnerhshipHC3Input]),
                              selected = "All ages"
    )
  })
  
  HCClientsX <- reactive({
    data_homecare_client_group %>%
      filter(
        sending_location == input$PartnerhshipHC3Input,
        Age_Band == input$AgeHCXInput
      )
  })
  
  output$HCClients <- renderPlotly({
    if (is.null(input$AgeHCXInput)) {
      return()
    }
    plot_ly(HCClientsX() %>%
              mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "NA", nclient)) %>%
              na.omit(),
            x = ~type,
            y = ~ as.numeric(nclient),
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Client Type:", type,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            type = "bar"
    ) %>%
      layout(
        xaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Client Group",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          categoryorder = "array",
          categoryarray = ~nclient,
          showline = TRUE,
          ticks = "outside",
          tickangle = -90
        ),
        yaxis = list(
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        titlefont = f1,
        margin = list(l = 10, r = 10, b = 150, t = 70),
        title = ifelse(input$PartnerhshipHC3Input == "All Areas Submitted",
                       paste("<b>Number of people in<b>", input$PartnerhshipHC3Input, "<b>receiving home care:<br>by client group category for age band", input$AgeHCXInput, ";Census week March 2018"),
                       paste("<b>Number of people in<b>", input$PartnerhshipHC3Input, "<b>HSCP receiving home care:<br>by client group category for age band", input$AgeHCXInput, ";Census week March 2018")
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$HCClientsbutton, {
    toggle("HCClientstable")
    output$table_HC_clients <- DT::renderDataTable(DT::datatable(HCClientsX() %>%
                                                                   mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))) %>%
                                                                   select(sending_location, Age_Band, type, nclient),
                                                                 style = "bootstrap",
                                                                 class = "table-bordered table-condensed",
                                                                 rownames = FALSE,
                                                                 colnames = c(
                                                                   "Location",
                                                                   "Age Band",
                                                                   "Client Group",
                                                                   "Number of People"
                                                                 ),
                                                                 options = list(
                                                                   pageLength = 16,
                                                                   autoWidth = TRUE,
                                                                   columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                   dom = "tip",
                                                                   bPaginate = FALSE,
                                                                   bInfo = FALSE
                                                                 )
    ))
  })
  
  output$download_clienttype <- downloadHandler(
    filename = "homecare_clienttype.csv",
    content = function(file) {
      write.table(data_homecare_client_group %>%
                    mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))) %>%
                    select(sending_location, Age_Band, type, nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Age Band",
                    "Client Group",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.4 Service Providers of Home Care ----
  
  HCServiceProviderD <- reactive({
    data_homecare_service_providers %>%
      filter(
        sending_location == input$PartnershipHC8Input,
        Age_Band == input$AgeBandHCZXInput
      )
  })
  
  output$AgeBandHCZInput <- renderUI({
    shinyWidgets::pickerInput("AgeBandHCZXInput",
                              "Select Age Band:",
                              choices = unique(Table5Data$Age_Band[Table5Data == input$PartnershipHC8Input]),
                              selected = "All ages"
    )
  })
  
  output$HCServiceProvider <- renderPlotly({
    plot_ly(HCServiceProviderD() %>%
              mutate(percentage = ifelse(nclient < 5, "*", percentage)),
            labels = ~type,
            values = ~ as.numeric(percentage),
            textinfo = "value",
            type = "pie",
            marker = list(
              colors = c("#08519c", "#2171b5", "#4292c6", "#9ecae1", "#c6dbef", "#eff3ff"),
              line = list(color = "white")
            ),
            sort = FALSE,
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Service Provider:", type,
              "<br>",
              "Number of People:", ifelse(nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
              "<br>",
              "Percentage:", percentage, "%"
            )
    ) %>%
      layout(
        title = ifelse(input$PartnershipHC8Input == "Scotland",
                       paste("<b>Number of people receiving home care in", input$PartnershipHC8Input, "by service provider; <br>age band", input$AgeBandHCZXInput, "during the census week 2017/18"),
                       paste("<b>Number of people receiving home care in", input$PartnershipHC8Input, "HSCP by<br>service provider; age band", input$AgeBandHCZXInput, "during the census week 2017/18")
        ),
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        margin = list(l = 5, r = 5, b = 90, t = 90),
        titlefont = f1,
        legend = list(x = 100, y = 0.5)
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian",
          "hoverClosestPie"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$HCServiceProviderbutton, {
    toggle("HCServiceProvidertable")
    output$table_HC_serviceprovider <- DT::renderDataTable(DT::datatable(HCServiceProviderD() %>%
                                                                           select(-percentageL) %>%
                                                                           mutate(
                                                                             percentage = ifelse(nclient < 5, "*", as.character(percentage)),
                                                                             nclient = ifelse(nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))
                                                                           ) %>%
                                                                           arrange(factor(sending_location, levels = InputSort), factor(type, levels = ServiceProviderOrder)),
                                                                         style = "bootstrap",
                                                                         class = "table-bordered table-condensed",
                                                                         rownames = FALSE,
                                                                         colnames = c(
                                                                           "Location",
                                                                           "Age Band",
                                                                           "Service Provider",
                                                                           "Number of People",
                                                                           "Percentage of People"
                                                                         ),
                                                                         options = list(
                                                                           pageLength = 16,
                                                                           autoWidth = TRUE,
                                                                           columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                           dom = "tip",
                                                                           bPaginate = FALSE,
                                                                           bInfo = FALSE
                                                                         )
    ))
  })
  
  output$download_homecare_serviceprovider <- downloadHandler(
    filename = "homecare_serviceprovider.csv",
    content = function(file) {
      write.table(download_data_homecare_service_providers %>%
                    select(-percentageL),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Age Band",
                    "Service Provider",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.5 Home Care Hours Received ----
  
  output$AgeHCBInput <- renderUI({
    shinyWidgets::pickerInput("AgeHCBXInput",
                              "Select Age Band:",
                              choices = unique(Table8Data$Age_Band[Table8Data == input$PartnerhshipHC3BInput]),
                              selected = "All ages"
    )
  })
  
  HCLevelofserviceD <- reactive({
    data_homecare_hours_received %>%
      filter(
        Age_Band == input$AgeHCBXInput,
        sending_location == input$PartnerhshipHC3BInput
      )
  })
  
  output$HCLevelofservice <- renderPlotly({
    plot_ly(HCLevelofserviceD() %>%
              filter(!(level_of_service == "Unknown")),
            x = ~level_of_service,
            y = ~nclient,
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Level of Service:", level_of_service,
              "<br>",
              "Number of People", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            type = "bar"
    ) %>%
      layout(
        xaxis = list(
          title = "Number of hours Home Care",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside",
          categoryorder = "category array",
          categoryarray = c("< 2 hours", "2 to < 4 hours", "4 to < 10 hours", "10+ hours")
        ),
        yaxis = list(
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse(input$PartnerhshipHC3BInput == "All Areas Submitted",
                       paste("<b>Number of people in", input$PartnerhshipHC3BInput, "receiving home care:<br>by number of home care hours for age band", input$AgeHCBXInput, ", Census week March 2018"),
                       paste("<b>Number of people in", input$PartnerhshipHC3BInput, "HSCP receiving home care:<br>by number of home care hours for age band", input$AgeHCBXInput, ", Census week March 2018")
        ),
        margin = list(l = 10, r = 10, b = 90, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$HCLevelofservicebutton, {
    toggle("HCLevelofservicetable")
    output$table_HC_levelofservice <- DT::renderDataTable(DT::datatable(HCLevelofserviceD() %>%
                                                                          mutate(nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                        style = "bootstrap",
                                                                        class = "table-bordered table-condensed",
                                                                        rownames = FALSE,
                                                                        colnames = c(
                                                                          "Location",
                                                                          "Age Band",
                                                                          "Number of hours Home Care",
                                                                          "Number of People"
                                                                        ),
                                                                        options = list(
                                                                          pageLength = 16,
                                                                          autoWidth = TRUE,
                                                                          columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                          dom = "tip",
                                                                          bPaginate = FALSE,
                                                                          bInfo = FALSE
                                                                        )
    ))
  })
  
  output$download_homecare_levelofservice <- downloadHandler(
    filename = "homecare_levelofservice.csv",
    content = function(file) {
      write.table(data_homecare_hours_received %>%
                    mutate(nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Age Band",
                    "Number of hours Home Care",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.6 Home Care Hours Distribution ----
  
  HCHoursD <- reactive({
    data_homecare_hours_distribution %>%
      filter(sending_location == input$HCPartnership4Input)
  })
  
  output$HCHoursDist <- renderPlotly({
    plot_ly(HCHoursD() %>%
              filter(!(is.na(nclient))),
            x = ~type,
            y = ~nclient,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", input$HCPartnership4Input,
              "<br>",
              "Home Care Hours:", type,
              "<br>",
              "Number of People", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          categoryorder = "array",
          categoryarray = c(
            "< 1 hour", "1 - <2 hours", "2 - <3 hours", "3 - <4 hours", "4 - <5 hours", "5 - <6 hours", "6 - <7 hours", "7 - <8 hours",
            "8 - <9 hours", "9 - <10 hours", "10 - <11 hours", "11 - <12 hours", "12 - <13 hours", "13 - <14 hours", "14 - <15 hours",
            "15 - <16 hours", "16 - <24 hours", "24+ hours"
          ),
          showline = TRUE,
          tickangle = -90,
          ticks = "outside",
          title = "Number of home care hours",
          titlefont = f2
        ),
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          rangemode = "tozero",
          title = "Number of People",
          titlefont = f2
        ),
        title = ifelse(input$HCPartnership4Input == "All Areas Submitted",
                       paste("<b>Number of People who received home care in", input$HCPartnership4Input, ";<br>by number of home care hours during census week 2018<b>"),
                       paste("<b>Number of People who received home care in", input$HCPartnership4Input, "HSCP;<br>by number of home care hours during census week 2018<b>")
        ),
        margin = list(l = 10, r = 10, b = 70, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$HCHoursDistbutton, {
    toggle("HCHourdDistTable")
    output$table_HC_hoursdist <- DT::renderDataTable(DT::datatable(HCHoursD() %>%
                                                                     select(sending_location, type, nclient) %>%
                                                                     mutate(nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))) %>%
                                                                     arrange(factor(type, levels = c(
                                                                       "< 1 hour", "1 - <2 hours", "2 - <3 hours", "3 - <4 hours", "4 - <5 hours", "5 - <6 hours", "6 - <7 hours", "7 - <8 hours",
                                                                       "8 - <9 hours", "9 - <10 hours", "10 - <11 hours", "11 - <12 hours", "12 - <13 hours", "13 - <14 hours", "14 - <15 hours",
                                                                       "15 - <16 hours", "16 - <24 hours", "24+ hours"
                                                                     ))),
                                                                   style = "bootstrap",
                                                                   class = "table-bordered table-condensed",
                                                                   rownames = FALSE,
                                                                   colnames = c(
                                                                     "Location",
                                                                     "Home Care Hours",
                                                                     "Number of People"
                                                                   ),
                                                                   options = list(
                                                                     pageLength = 16,
                                                                     autoWidth = TRUE,
                                                                     columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                     dom = "tip",
                                                                     bPaginate = FALSE,
                                                                     bInfo = FALSE
                                                                   )
    ))
  })
  
  output$download_homecare_hoursdistribution <- downloadHandler(
    filename = "homecare_hoursdistribution.csv",
    content = function(file) {
      write.table(data_homecare_hours_distribution %>%
                    select(sending_location, type, nclient) %>%
                    mutate(nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))) %>%
                    arrange(factor(type, levels = c(
                      "< 1 hour", "1 - 2 hours", "2 - 3 hours", "3 - 4 hours", "4 - 5 hours", "5 - 6 hours", "6 - 7 hours", "7 - 8 hours",
                      "8 - 9 hours", "9 - 10 hours", "10 - 11 hours", "11 - 12 hours", "12 - 13 hours", "13 - 14 hours", "14 - 15 hours",
                      "15 - 16 hours", "16 - 24 hours", "24 hours +"
                    ))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Home Care Hours",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.7 Housing Support/Living Alone ----
  
  HousingSupportLivingAloneD <- reactive({
    data_homecare_hs_la %>%
      filter(Measure == input$MeasureHC3Input)
  })
  
  
  output$HousingSupport <- DT::renderDataTable({
    DT::datatable(HousingSupportLivingAloneD() %>%
                    filter((type %in% c("Receiving Housing Support", "Living Alone"))) %>%
                    select(-Measure) %>%
                    mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  style = "bootstrap",
                  class = "table-bordered table-condensed",
                  rownames = FALSE,
                  colnames = c(
                    "Location",
                    "Type",
                    "Number of People",
                    "Percentage"
                  ),
                  options = list(
                    pageLength = 16,
                    autoWidth = TRUE,
                    dom = "tip",
                    bInfo = FALSE
                  )
    )
  })
  
  output$download_housingsupport <- downloadHandler(
    filename = "homecare_housingsupport.csv",
    content = function(file) {
      write.table(data_homecare_hs_la %>%
                    select(-Measure) %>%
                    mutate(
                      nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                      percentage = ifelse(is.na(percentage), "*", percentage)
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Type",
                    "Number of People",
                    "Percentage"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.8 Personal Care ----
  
  output$HCPersonalCare <- renderPlotly({
    plot_ly(data_homecare_personal_care %>%
              filter(sending_location != "All Areas Submitted"),
            x = ~sending_location,
            y = ~percentage,
            hoverinfo = "text",
            text = ~ paste(
              "Measure:", type,
              "<br>",
              "Percentage of People:", percentage, "%",
              "<br>",
              "Number of People", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            type = "bar"
    ) %>%
      add_trace(
        color = I("red"),
        name = "Scotland",
        y = ~percentage2,
        x = ~sending_location,
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "All Areas Submitted",
          "<br>",
          "Percentage of People:", percentage2, "%",
          "<br>",
          "Number of People", 50, 625
        ),
        inherit = TRUE,
        showlegend = FALSE
      ) %>%
      layout(
        xaxis = list(
          tickangle = -90,
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 25),
            "Health & Social Care Partnership",
            rep("&nbsp;", 25),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        legend = list(
          orientation = "h",
          x = 0,
          y = -1
        ),
        yaxis = list(
          title = "Percentage",
          titlefont = f2,
          rangemode = "tozero",
          showline = TRUE,
          ticks = "outside"
        ),
        title = ~ paste("<b>Percentage of people receiving home care services with Personal Care<br>during census week March 2018<b>"),
        margin = list(l = 60, r = 0, b = 70, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$HCpersonalcarebutton, {
    toggle("HCPersonalCareTable")
    output$table_HC_personalcare <- DT::renderDataTable(DT::datatable(data_homecare_personal_care %>%
                                                                        select(-percentage2) %>%
                                                                        mutate(nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                      style = "bootstrap",
                                                                      class = "table-bordered table-condensed",
                                                                      rownames = FALSE,
                                                                      colnames = c(
                                                                        "Location",
                                                                        "Measure",
                                                                        "Number of Clients",
                                                                        "Percentage"
                                                                      ),
                                                                      options = list(
                                                                        pageLength = 16,
                                                                        autoWidth = TRUE,
                                                                        columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                        dom = "tip",
                                                                        bPaginate = FALSE,
                                                                        bInfo = FALSE
                                                                      )
    ))
  })
  
  output$download_personalcare <- downloadHandler(
    filename = "homecare_personalcare.csv",
    content = function(file) {
      write.table(data_homecare_personal_care %>%
                    select(-percentage2) %>%
                    mutate(nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Measure",
                    "Number of Clients",
                    "Percentage"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.2.9 Alarms/Telecare ----
  
  output$HCalarms <- renderPlotly({
    plot_ly(data_homecare_alarms,
            x = ~sending_location,
            y = ~percentage,
            type = "bar",
            split = ~Equipment,
            color = ~Equipment,
            colors = c("#084594", "#9ecae1"),
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Percentage of People:", percentage, "%",
              "<br>",
              "Equipment:", Equipment
            )
    ) %>%
      layout(
        barmode = "stack",
        xaxis = list(
          tickangle = -90,
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 25),
            "Location",
            rep("&nbsp;", 25),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        legend = list(
          x = 0,
          y = -1
        ),
        yaxis = list(
          title = "Percentage of people with<br>communuity alarm/telecare",
          titlefont = f2,
          rangemode = "tozero",
          showline = TRUE,
          ticks = "outside",
          ticksuffix = "%"
        ),
        title = "<b>Percentage of people receiving home care with community alarm/telecare<br>between January 2018 - March 2018<b>",
        margin = list(l = 80, r = 0, b = 70, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$HCalarmsbutton, {
    toggle("HCalarmsTable")
    output$table_HC_alarms <- DT::renderDataTable(DT::datatable(data_homecare_alarms,
                                                                style = "bootstrap",
                                                                class = "table-bordered table-condensed",
                                                                rownames = FALSE,
                                                                colnames = c(
                                                                  "Location",
                                                                  "Alarms/Telecare",
                                                                  "Percentage"
                                                                ),
                                                                options = list(
                                                                  pageLength = 16,
                                                                  autoWidth = TRUE,
                                                                  columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                  dom = "tip",
                                                                  bPaginate = FALSE,
                                                                  bInfo = FALSE
                                                                )
    ))
  })
  
  output$download_alarms <- downloadHandler(
    filename = "homecare_alarms_telecare.csv",
    content = function(file) {
      write.table(data_homecare_alarms,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Alarms/Telecare",
                    "Percentage"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # 2.10 Emergency Hospital Admissions ----
  
  HCAdmissionsD <- reactive({
    data_homecare_hospital_adm %>%
      filter(Measure == input$HCAdmissionsInput)
  })
  
  # Admissions Chart
  
  output$HCAdmissions <- renderPlotly({
    plot_ly(HCAdmissionsD() %>%
              filter(sending_location != "All Areas Submitted"),
            x = ~sending_location,
            y = ~Rate,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "HSCP:", sending_location,
              "<br>",
              "Number of", input$HCAdmissionsInput, ":", formatC(Numerator, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Rate:", Rate
            ),
            showlegend = FALSE
    ) %>%
      add_trace(
        color = I("red"),
        name = "Scotland",
        y = ~Rate2,
        x = ~sending_location,
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "All Areas Submitted",
          "<br>",
          input$HCAdmissionsInput, "Rate:", Rate2
        ),
        inherit = FALSE,
        showlegend = FALSE
      ) %>%
      layout(
        xaxis = list(
          tickangle = -90,
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health & Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          showline = TRUE,
          titlefont = f2,
          ticks = "outside"
        ),
        yaxis = list(
          title = ~ paste(input$HCAdmissionsInput, "Rate"),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        title = ~ paste("<b>People receiving home care in quarter ending March 2018 who have an<br>emergency (acute) hospital admission during the quarter;<br>", input$HCAdmissionsInput, "rate per 1,000 receiving home care"),
        margin = list(l = 10, r = 10, b = 70, t = 80),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Admissions Table - show/hide
  
  observeEvent(input$HCadmissionsbutton, {
    toggle("HCAdmissionsTable")
    output$table_HC_admissions <- DT::renderDataTable(DT::datatable(HCAdmissionsD() %>%
                                                                      select(sending_location, Measure, Numerator, Rate) %>%
                                                                      mutate(Numerator = formatC(Numerator, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Location",
                                                                      "Measure",
                                                                      paste("Number of", input$HCAdmissionsInput),
                                                                      "Rate per 1,000 people receiving home care"
                                                                    ),
                                                                    options = list(
                                                                      pageLength = 16,
                                                                      autoWidth = TRUE,
                                                                      columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                      dom = "tip",
                                                                      bPaginate = FALSE,
                                                                      bInfo = FALSE
                                                                    )
    ))
  })
  
  output$download_homecare_emergencyadmissions <- downloadHandler(
    filename = "homecare_emergencyadmissions.csv",
    content = function(file) {
      write.table(data_homecare_hospital_adm %>%
                    select(sending_location, Measure, Numerator, Rate) %>%
                    mutate(Numerator = formatC(Numerator, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Measure",
                    paste("Number of", input$HCAdmissionsInput),
                    "Rate per 1,000 people receiving home care"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.2.11 Level of Independence (ioRN) ----
  
  lornHCD <- reactive({
    data_homecare_IoRN %>%
      filter(sending_location == input$lornPartnership2Input)
  })
  
  output$lornHCB <- renderPlotly({
    plot_ly(
      lornHCD(),
      x = ~IoRNGroup,
      y = ~Percentage,
      type = "bar",
      color = ~type,
      colors = colour_map,
      hoverinfo = "text",
      text = ~ paste(
        "Location:", sending_location,
        "<br>",
        "Level of Service:", type,
        "<br>",
        "Number of People:", nclient,
        "<br>",
        "Percentage of People:", Percentage
      )
    ) %>%
      layout(
        title = ~ paste("<b>", input$lornPartnership2Input, "HSCP average home care hours received per week by ioRN group"),
        barmode = "stack",
        margin = list(l = 10, r = 10, b = 70, t = 90),
        titlefont = f1,
        xaxis = list(
          showline = TRUE,
          ticks = "outside",
          titlefont = f2,
          title = "IORN Group"
        ),
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          categoryorder = "array",
          categoryarray = c("<2 hours", "2 - <4 hours", "4 - <10 hours", "10+ hours", "no home care record", "unknown home care hours"),
          titlefont = f2,
          title = "Cumulative Percentage by ioRN Group"
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$IORNhomecarebutton, {
    toggle("IORNhomecareTable")
    output$table_IORN_homecare <- DT::renderDataTable(DT::datatable(lornHCD() %>%
                                                                      select(sending_location, IoRNGroup, type, nclient, Percentage) %>%
                                                                      mutate(
                                                                        nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                        Percentage = ifelse(is.na(Percentage), "*", Percentage)
                                                                      ),
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Location",
                                                                      "ioRN Group",
                                                                      "Home Care Hours",
                                                                      "Number of People",
                                                                      "Percentage of People"
                                                                    ),
                                                                    options = list(
                                                                      pageLength = 16,
                                                                      autoWidth = TRUE,
                                                                      dom = "tip",
                                                                      bPaginate = FALSE,
                                                                      bInfo = FALSE
                                                                    )
    ))
  })
  
  output$download_homecare_ioRN <- downloadHandler(
    filename = "homecare_ioRN.csv",
    content = function(file) {
      write.table(data_homecare_IoRN %>%
                    select(sending_location, IoRNGroup, type, nclient, Percentage) %>%
                    mutate(
                      nclient = ifelse(is.na(nclient), "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                      Percentage = ifelse(is.na(Percentage), "*", Percentage)
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "ioRN Group",
                    "Home Care Hours",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  #################################
  ### People Supported in Care Homes ----
  #################################
  
  # X.3.1 People Supported In Care Homes - Number and Rate ----
  
  # Residents Data
  ResidentsD <- reactive({
    data_care_home_number_rate %>%
      filter(Date == input$MonthCHInput)
  })
  
  # Residents Chart
  
  output$CH_Residents <- renderPlotly({
    plot_ly(ResidentsD() %>%
              filter(!(sending_location == "Scotland")),
            x = ~sending_location,
            y = ~Rate,
            type = "bar",
            hoverinfo = "text",
            showlegend = FALSE,
            text = ~ paste(
              "Date:", Date,
              "<br>",
              "Number of Residents", ":", formatC(nclients, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Rate per 1,000 population (18 and older):", Rate
            )
    ) %>%
      add_trace(
        color = I("red"),
        name = "Scotland",
        y = ~Rate2,
        x = ~sending_location,
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "Scotland",
          "<br>",
          "Number of Residents:", ifelse(
            input$MonthCHInput == "31 January 2018", "33,355",
            ifelse(input$MonthCHInput == "28 February 2018",
                   "33,668", "33,972"
            )
          ),
          "<br>",
          "Rate per 1,000 population (18 and older):", Rate2
        ),
        inherit = FALSE,
        showlegend = TRUE
      ) %>%
      layout(
        yaxis = list(
          title = "Rate per 1,000 population (18 and older)",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside",
          tickmode = "array"
        ),
        xaxis = list(
          type = "category",
          title = "Health & Social Care Partnership",
          tickangle = -90,
          tickmode = "array",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        title = paste("<b>People supported in Care Homes (residents aged 18+): rate per 1000 population<br>aged 18+; as at", input$MonthCHInput),
        margin = list(l = 10, r = 10, b = 40, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Residents table - show/hide
  
  observeEvent(input$CHresidentsbutton, {
    toggle("CHResidentsTable")
    output$table_CH_residents <- DT::renderDataTable(DT::datatable(ResidentsD() %>%
                                                                     select(-Rate2) %>%
                                                                     mutate(nclients = formatC(nclients, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                   style = "bootstrap",
                                                                   class = "table-bordered table-condensed",
                                                                   rownames = FALSE,
                                                                   colnames = c(
                                                                     "Location",
                                                                     "Date",
                                                                     "Number of Care Home Residents",
                                                                     "Rate per 1,000 population"
                                                                   ),
                                                                   options = list(
                                                                     pageLength = 16,
                                                                     autoWidth = TRUE,
                                                                     dom = "tip",
                                                                     columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                     bPaginate = FALSE,
                                                                     bInfo = FALSE
                                                                   )
    ))
  })
  
  output$download_residents <- downloadHandler(
    filename = "carehome_residents.csv",
    content = function(file) {
      write.table(data_care_home_number_rate %>%
                    select(-Rate2) %>%
                    mutate(nclients = formatC(nclients, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Date",
                    "Number of Care Home Residents",
                    "Rate per 1,000 population"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.3.2 Age and Sex of Care Home Residents ----
  
  
  # Age/Sex Tab
  
  # Create Reactive Dataset for Age/Sex
  AgeSexD <- reactive({
    data_care_home_age_sex %>%
      filter(Area == input$PartnershipCH1Input)
  })
  
  # Age/Sex Chart
  output$CH_AgeSex <- renderPlotly({
    plot_ly(AgeSexD(),
            x = ~Pop, y = ~AgeGroup, color = ~ as.factor(Gender),
            colors = c("#9ecae1", "#2171b5"),
            type = "bar",
            orientation = "h",
            hoverinfo = "text",
            text = ~ paste(
              "Sex:", Gender,
              "<br>",
              "Age Band:", AgeGroup,
              "<br>",
              "Number of Clients:", formatC(abs(Pop), format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        bargap = 0.2, barmode = "overlay",
        legend = list(x = 100, y = 0.5, font = list(size = 15)),
        margin = list(l = 10, r = 10, b = 70, t = 40),
        titlefont = f1,
        title = ifelse(input$PartnershipCH1Input == "Scotland",
                       paste("<b>Age and Sex of Care Home Residents (aged 18+):", input$PartnershipCH1Input, "as at 31 March 2018<b>"),
                       paste("<b>Age and Sex of Care Home Residents (aged 18+):", input$PartnershipCH1Input, "HSCP<br>as at 31 March 2018<b>")
        ),
        yaxis = list(
          showline = TRUE,
          title = "Age Band",
          titlefont = f2,
          ticks = "outside"
        ),
        xaxis = list(
          exponentformat = "none",
          separatethousands = TRUE,
          tickmode = "array",
          showline = TRUE,
          ticks = "outside",
          title = "Number of Residents",
          titlefont = f2,
          range = c(
            -round(max(abs(AgeSexD()$Pop)
                       * 110 / 100)),
            round(max(abs(AgeSexD()$Pop)
                      * 110 / 100))
          ),
          tickangle = 0,
          tickvals = c(
            -round(max(abs(AgeSexD()$Pop))),
            -round(max(abs(AgeSexD()$Pop))
                   * 66 / 100),
            -round(max(abs(AgeSexD()$Pop))
                   * 33 / 100),
            0,
            round(max(abs(AgeSexD()$Pop))
                  * 33 / 100),
            round(max(abs(AgeSexD()$Pop))
                  * 66 / 100),
            round(max(abs(AgeSexD()$Pop)))
          ),
          ticktext = paste0(
            as.character(c(
              round(max(abs(AgeSexD()$Pop))),
              round(max(abs(AgeSexD()$Pop))
                    * 66 / 100),
              round(max(abs(AgeSexD()$Pop))
                    * 33 / 100),
              0,
              round(max(abs(AgeSexD()$Pop))
                    * 33 / 100),
              round(max(abs(AgeSexD()$Pop))
                    * 66 / 100),
              round(max(abs(AgeSexD()$Pop)))
            ))
          )
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Age/Sex Table - hide/show button
  
  observeEvent(input$CHagesexbutton, {
    toggle("CHAgeSexTable")
    output$table_CH_agesex <- DT::renderDataTable(DT::datatable(AgeSexD() %>%
                                                                  mutate(
                                                                    Pop = abs(Pop),
                                                                    Pop = ifelse(is.na(Pop), "*", formatC(Pop, format = "f", big.mark = ",", drop0trailing = TRUE))
                                                                  ),
                                                                style = "bootstrap",
                                                                class = "table-bordered table-condensed",
                                                                rownames = FALSE,
                                                                colnames = c(
                                                                  "Location",
                                                                  "Age Band",
                                                                  "Sex",
                                                                  "Number of Residents"
                                                                ),
                                                                options = list(
                                                                  pageLength = 16,
                                                                  autoWidth = TRUE,
                                                                  columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                  dom = "tip",
                                                                  bPaginate = FALSE,
                                                                  bInfo = FALSE
                                                                )
    ))
  })
  
  output$download_CH_agesex <- downloadHandler(
    filename = "carehome_agesex.csv",
    content = function(file) {
      write.table(data_care_home_age_sex %>%
                    mutate(
                      Pop = abs(Pop),
                      Pop = ifelse(is.na(Pop), "*", formatC(Pop, format = "f", big.mark = ",", drop0trailing = TRUE))
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Age Band",
                    "Sex",
                    "Number of Residents"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.3.3 Admissions and Discharges to/from Care Homes ----
  
  AdmDisD <- reactive({
    data_care_home_admissions_discharges %>%
      filter(sending_location == input$PartnerhsipCHAdmInput)
  })
  
  output$CH_AdmDis <- renderPlotly({
    plot_ly(AdmDisD(),
            x = ~Month,
            y = ~admissions,
            name = "Care Home Admissions",
            type = "scatter",
            mode = "line",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Month:", Month,
              "<br>",
              "Number of Admissions:", formatC(admissions, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      add_trace(
        x = ~Month,
        y = ~discharges,
        name = "Care Home Discharges",
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "Location:", sending_location,
          "<br>",
          "Month:", Month,
          "<br>",
          "Number of Discharges:", formatC(discharges, format = "f", big.mark = ",", drop0trailing = TRUE)
        )
      ) %>%
      layout(
        xaxis = list(
          categoryorder = "array",
          categoryarray = c("January", "February", "March"),
          titlefont = f2,
          showline = TRUE,
          title = "Month",
          ticks = "outside"
        ),
        yaxis = list(
          titlefont = f2,
          title = "Number of Admissions/Discharges",
          rangemode = "tozero",
          showline = TRUE,
          ticks = "outside"
        ),
        xaxis2 = list(
          categoryorder = "array",
          categoryarray = c("January", "February", "March")
        ),
        title = ifelse(input$PartnerhsipCHAdmInput == "All Areas Submitted",
                       paste("<b>People admitted to and discharged from Care<br>Homes during month:", input$PartnerhsipCHAdmInput, ";<br>Quarter Ending March 2018"),
                       paste("<b>People admitted to and discharged from Care<br>Homes during month:", input$PartnerhsipCHAdmInput, "HSCP;<br>Quarter Ending March 2018")
        ),
        margin = list(l = 10, r = 15, b = 50, t = 140),
        legend = list(
          orientation = "h",
          x = 0,
          y = -0.2
        ),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$CHadmdisbutton, {
    toggle("CHadmdisTable")
    output$table_CH_admdis <- DT::renderDataTable(DT::datatable(AdmDisD() %>%
                                                                  mutate(
                                                                    admissions = formatC(admissions, format = "f", big.mark = ",", drop0trailing = TRUE),
                                                                    discharges = formatC(discharges, format = "f", big.mark = ",", drop0trailing = TRUE)
                                                                  ),
                                                                style = "bootstrap",
                                                                class = "table-bordered table-condensed",
                                                                rownames = FALSE,
                                                                colnames = c(
                                                                  "Location",
                                                                  "Month",
                                                                  "Number of Admissions",
                                                                  "Number of Discharges"
                                                                ),
                                                                options = list(
                                                                  pageLength = 16,
                                                                  autoWidth = TRUE,
                                                                  dom = "tip",
                                                                  columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                  bPaginate = FALSE,
                                                                  bInfo = FALSE
                                                                )
    ))
  })
  
  output$download_admdis <- downloadHandler(
    filename = "carehome_admissiondischarges_data.csv",
    content = function(file) {
      write.table(data_care_home_admissions_discharges %>%
                    mutate(
                      admissions = formatC(admissions, format = "f", big.mark = ",", drop0trailing = TRUE),
                      discharges = formatC(discharges, format = "f", big.mark = ",", drop0trailing = TRUE)
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Month",
                    "Number of Admissions",
                    "Number of Discharges"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.3.4 Median Length of Stay In Care Home ----
  
  # Length of Stay Chart
  output$LengthofStay <- renderPlotly({
    plot_ly(data_care_home_length_of_stay %>%
              filter(sending_location != "Scotland"),
            x = ~sending_location,
            y = ~mlos_M_cen,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "HSCP:", sending_location,
              "<br>",
              "Median Length of Stay (days):", mlos_M_cen
            ),
            showlegend = FALSE
    ) %>%
      add_lines(
        y = 472,
        color = I("red"),
        name = "Scotland",
        hoverinfo = "text",
        text = ~ paste(
          "Scotland",
          "<br>",
          "Median Length of Stay (days): 472"
        )
      ) %>%
      layout(
        xaxis = list(
          tickangle = -90,
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health & Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          showline = TRUE,
          titlefont = f2,
          ticks = "outside"
        ),
        yaxis = list(
          title = "Median Length of Stay (days)",
          showline = TRUE,
          titlefont = f2,
          ticks = "outside"
        ),
        title = "<b>Median length of stay (days) for residents in care home as at 31 March 2018<b>",
        margin = list(l = 10, r = 10, b = 70, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Lenght of Stay - show/hide
  
  observeEvent(input$CHlengthofstaybutton, {
    toggle("CHLengthofStayTable")
    output$table_CH_lengthofstay <- DT::renderDataTable(DT::datatable(data_care_home_length_of_stay,
                                                                      style = "bootstrap",
                                                                      class = "table-bordered table-condensed",
                                                                      rownames = FALSE,
                                                                      colnames = c(
                                                                        "Location",
                                                                        "Median Length of Stay (days)"
                                                                      ),
                                                                      options = list(
                                                                        pageLength = 16,
                                                                        autoWidth = TRUE,
                                                                        dom = "tip",
                                                                        columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                        bPaginate = FALSE,
                                                                        bInfo = FALSE
                                                                      )
    ))
  })
  
  output$download_CH_lengthofstay <- downloadHandler(
    filename = "carehome_length_of_stay.csv",
    content = function(file) {
      write.table(data_care_home_length_of_stay,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Median Length of Stay (days)"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.3.5 Need For Nursing Care ----
  
  # Nursing Care Chart
  output$Nurse <- renderPlotly({
    plot_ly(data_care_home_nursing_care,
            x = ~sending_location,
            y = ~NPrate_mar_census_point,
            type = "bar",
            color = ~NursingCareProvision,
            colors = colour_map2,
            hoverinfo = "text",
            text = ~ paste(
              "Percentage of Residents:", NPrate_mar_census_point,
              "<br>",
              "Need For Nursing Care:", NursingCareProvision
            )
    ) %>%
      layout(
        barmode = "stack",
        xaxis = list(
          tickangle = -90,
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Location",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        legend = list(
          x = 0, y = -0.9,
          font = list(size = 14)
        ),
        yaxis = list(
          title = "Percentage of Care Home Residents",
          titlefont = f2,
          rangemode = "tozero",
          showline = TRUE,
          ticks = "outside"
        ),
        title = "<b>Percentage of care home residents receiving nursing care by Partnership:<br>as at 31 March 2018<b>",
        margin = list(l = 10, r = 1, b = 30, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Nursing Care Table
  observeEvent(input$CHnursingbutton, {
    toggle("CHNurseTable")
    output$table_CH_nurse <- DT::renderDataTable(DT::datatable(data_care_home_nursing_care,
                                                               style = "bootstrap",
                                                               class = "table-bordered table-condensed",
                                                               rownames = FALSE,
                                                               colnames = c(
                                                                 "Location",
                                                                 "Need For Nursing Care",
                                                                 "Percentage of Care Home Residents"
                                                               ),
                                                               options = list(
                                                                 pageLength = 16,
                                                                 autoWidth = TRUE,
                                                                 dom = "tip",
                                                                 columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                 bPaginate = FALSE,
                                                                 bInfo = FALSE
                                                               )
    ))
  })
  
  output$download_CH_nursingcare <- downloadHandler(
    filename = "carehome_nursing_care.csv",
    content = function(file) {
      write.table(data_care_home_nursing_care,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Need For Nursing Care",
                    "Percentage of Care Home Residents"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  
  
  # X.3.6 Emergency hospital admissions ----
  
  # Admissions Data
  
  AdmissionsD <- reactive({
    data_care_home_hospital_adm %>%
      filter(Measure == input$AdmissionsInput)
  })
  
  output$CHAdmissions <- renderPlotly({
    plot_ly() %>%
      add_bars(
        data = AdmissionsD() %>%
          filter(sending_location != "All Areas Submitted"),
        x = ~sending_location,
        y = ~Rate,
        type = "bar",
        hoverinfo = "text",
        text = ~ paste(
          "HSCP:", sending_location,
          "<br>",
          "Number of", input$AdmissionsInput, ":", formatC(Numerator, format = "f", big.mark = ",", drop0trailing = TRUE),
          "<br>",
          "Rate per 1,000 residents:", Rate
        ),
        showlegend = FALSE
      ) %>%
      add_trace(
        color = I("red"),
        name = "Scotland",
        y = ~Rate2,
        x = ~sending_location,
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "All Areas Submitted",
          "<br>",
          input$AdmissionsInput, "Rate per 1,000 residents:", Rate2
        ),
        inherit = FALSE,
        showlegend = TRUE
      ) %>%
      layout(
        xaxis = list(
          tickangle = -90,
          type = "category",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health & Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        yaxis = list(
          title = ~ paste(input$AdmissionsInput, "Rate (per 1,000)"),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse(input$AdmissionsInput == "Emergency Admissions",
                       "<b>Care Home Residents in quarter ending 31 March 2018 who have an emergency (acute)<br>hospital admission during the quarter; Emergency Admissions Rate per 1,000 Residents",
                       "<b>Care Home Residents in quarter ending 31 March 2018 who have an emergency (acute)<br>hospital admission during the quarter; Emergency Admission Bed Days Rate per 1,000 Residents"
        ),
        margin = list(l = 10, r = 10, b = 70, t = 70),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Admissions Table - show/hide
  
  observeEvent(input$CHadmissionsbutton, {
    toggle("CHAdmissionsTable")
    output$table_CH_admissions <- DT::renderDataTable(DT::datatable(AdmissionsD() %>%
                                                                      select(sending_location, Measure, Numerator, Rate, -Rate2) %>%
                                                                      mutate(Numerator = formatC(Numerator, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Location",
                                                                      "Measure",
                                                                      paste("Number of", input$AdmissionsInput),
                                                                      "Rate per 1,000 residents"
                                                                    ),
                                                                    options = list(
                                                                      pageLength = 16,
                                                                      autoWidth = TRUE,
                                                                      dom = "tip",
                                                                      columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                      bPaginate = FALSE,
                                                                      bInfo = FALSE
                                                                    )
    ))
  })
  
  output$download_CH_EAdm <- downloadHandler(
    filename = "carehome_emergency_admissions.csv",
    content = function(file) {
      write.table(data_care_home_hospital_adm %>%
                    select(sending_location, Measure, Numerator, Rate, -Rate2) %>%
                    mutate(Numerator = formatC(Numerator, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Measure",
                    paste("Number of", input$AdmissionsInput),
                    "Rate per 1,000 residents"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.3.7Level of Independence ioRN Care Home ----
  
  lorncarehomeAD <- reactive({
    data_care_home_IoRN %>%
      filter(sending_location == input$lorncarehomeInput)
  })
  
  
  output$lorncarehomeA <- renderPlotly({
    plot_ly(lorncarehomeAD(),
            x = ~IoRNGroup,
            y = ~Percentage,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Number of Care Home Admissions:", ifelse(is.na(nclient), "*", nclient),
              "<br>",
              "% of Care Home Admissions:", Percentage
            )
    ) %>%
      layout(
        title = ifelse(input$lorncarehomeInput == "All Areas Submitted",
                       paste("<b>Percentage of people who were admitted to a Care Home<br>by ioRN Group (where recorded);", input$lorncarehomeInput, "; quarter ending 31 March 2018"),
                       paste("<b>Percentage of people who were admitted to a Care Home<br>by ioRN Group (where recorded);", input$lorncarehomeInput, "HSCP; quarter ending 31 March 2018")
        ),
        margin = list(l = 10, r = 10, b = 70, t = 90),
        titlefont = f1,
        xaxis = list(
          showline = TRUE,
          ticks = "outside",
          titlefont = f2,
          title = "ioRN Group"
        ),
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          titlefont = f2,
          title = "Percentage by ioRN group"
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$IORNcarehomebutton, {
    toggle("IORNcarehomeTable")
    output$table_IORN_carehome <- DT::renderDataTable(DT::datatable(lorncarehomeAD() %>%
                                                                      select(sending_location, IoRNGroup, nclient, Percentage) %>%
                                                                      mutate(
                                                                        nclient = ifelse(is.na(nclient), "*", nclient),
                                                                        Percentage = ifelse(is.na(Percentage), "*", Percentage)
                                                                      ),
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Location",
                                                                      "ioRN Group",
                                                                      "Number of Care Home Admissions",
                                                                      "Percentage of People with Care Home Admissions"
                                                                    ),
                                                                    options = list(
                                                                      pageLength = 16,
                                                                      autoWidth = TRUE,
                                                                      columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                      dom = "tip",
                                                                      bPaginate = FALSE,
                                                                      bInfo = FALSE
                                                                    )
    ))
  })
  
  output$download_CH_ioRN <- downloadHandler(
    filename = "carehome_ioRN.csv",
    content = function(file) {
      write.table(data_care_home_IoRN %>%
                    select(sending_location, IoRNGroup, nclient, Percentage) %>%
                    mutate(
                      nclient = ifelse(is.na(nclient), "*", nclient),
                      Percentage = ifelse(is.na(Percentage), "*", Percentage)
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "ioRN Group",
                    "Number of Care Home Admissions",
                    "Percentage of People with Care Home Admissions"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  ############################
  ### Community Alarms/Telecare ----
  ############################
  
  # X.4.1 Trend ----
  
  equipmenttrendD <- reactive({
    data_alarm_telecare_trend %>%
      filter(
        sending_location == input$EquipmentPartnership2Input,
        type == input$EquipmentType2Input
      )
  })
  
  
  output$equipmenttrendoutput <- renderPlotly({
    plot_ly(equipmenttrendD(),
            x = ~FinYr,
            y = ~clients,
            type = "scatter",
            mode = "lines+markers",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Service received during all or part of the year:", FinYr,
              "<br>",
              "Number of People:", formatC(clients, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        yaxis = list(
          rangemode = "tozero",
          title = "Number of People",
          titlefont = f2,
          showline = TRUE,
          exponentformat = "none",
          ticks = "outside"
        ),
        xaxis = list(
          title = "Service received during all or part of the year",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside",
          tickangle = -90
        ),
        margin = list(l = 10, r = 10, b = 70, t = 120),
        titlefont = f1,
        title = ifelse(input$EquipmentPartnership2Input == "All Areas Submitted" & input$EquipmentType2Input == "Community alarm only",
                       paste("<b>Number of people provided with<br>Community Alarms only;<br>", input$EquipmentPartnership2Input, ":2015/16 to 2017/18<b>"),
                       ifelse(input$EquipmentPartnership2Input == "All Areas Submitted" & input$EquipmentType2Input == "Telecare only",
                              paste("<b>Number of people provided with<br>Telecare only;<br>", input$EquipmentPartnership2Input, ":2015/16 to 2017/18<b>"),
                              ifelse(input$EquipmentPartnership2Input == "All Areas Submitted" & input$EquipmentType2Input == "Receiving both community alarm and telecare",
                                     paste("<b>Number of people provided with both<br>Community Alarm and Telecare;<br>", input$EquipmentPartnership2Input, ":2015/16 to 2017/18<b>"),
                                     ifelse(input$EquipmentPartnership2Input == "All Areas Submitted" & input$EquipmentType2Input == "Total community alarms and/or telecare",
                                            paste("<b>Total number of people provided with<br>Community Alarms and/or Telecare;<br>", input$EquipmentPartnership2Input, ":2015/16 to 2017/18<b>"),
                                            ifelse((input$EquipmentPartnership2Input != "All Areas Submitted" & input$EquipmentType2Input == "Community alarm only"),
                                                   paste("<b>Number of people provided with<br>Community Alarms only;<br>", input$EquipmentPartnership2Input, "HSCP:2015/16 to 2017/18<b>"),
                                                   ifelse((input$EquipmentPartnership2Input != "All Areas Submitted" & input$EquipmentType2Input == "Telecare only"),
                                                          paste("<b>Number of people provided with<br>Telecare only", input$EquipmentPartnership2Input, "HSCP:2015/16 to 2017/18"),
                                                          ifelse((input$EquipmentPartnership2Input != "All Areas Submitted" & input$EquipmentType2Input == "Receiving both community alarm and telecare"),
                                                                 paste("<b>Number of people provided with <br>both Community Alarm and Telecare;<br>", input$EquipmentPartnership2Input, "HSCP:2015/16 to 2017/18<b>"),
                                                                 paste("<b>Total number of people provided with<br>Community Alarms and/or Telecare;<br>", input$EquipmentPartnership2Input, "HSCP:2015/16 to 2017/18<b>")
                                                          )
                                                   )
                                            )
                                     )
                              )
                       )
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$equipmenttrendbutton, {
    toggle("EquipmentTrendTable")
    output$table_equipment_trend <- DT::renderDataTable(DT::datatable(equipmenttrendD() %>%
                                                                        mutate(clients = ifelse(is.na(clients), "*", formatC(clients, format = "f", big.mark = ",", drop0trailing = TRUE))) %>%
                                                                        select(-AgeGroup),
                                                                      style = "bootstrap",
                                                                      class = "table-bordered table-condensed",
                                                                      rownames = FALSE,
                                                                      colnames = c(
                                                                        "Financial Year",
                                                                        "Location",
                                                                        "Measure",
                                                                        "Number of People"
                                                                      ),
                                                                      options = list(
                                                                        pageLength = 16,
                                                                        autoWidth = TRUE,
                                                                        dom = "tip",
                                                                        bPaginate = FALSE,
                                                                        bInfo = FALSE
                                                                      )
    ))
  })
  
  output$download_equipment_trend <- downloadHandler(
    filename = "community_alarm_telecare_trend.csv",
    content = function(file) {
      write.table(data_alarm_telecare_trend %>%
                    mutate(clients = ifelse(is.na(clients), "*", formatC(clients, format = "f", big.mark = ",", drop0trailing = TRUE))) %>%
                    select(-AgeGroup),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Measure",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.4.2 Community Alarms/Telecare ----
  
  
  equipmentD <- reactive({
    data_alarm_telecare_equipment %>%
      filter(
        type == input$EquipmentTypeInput,
        sending_location != "South Lanarkshire",
        clients != 0
      )
  })
  
  output$equipmentoutput <- renderPlotly({
    plot_ly(equipmentD() %>%
              filter(sending_location != "All Areas Submitted"),
            x = ~sending_location,
            y = ~clients,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "HSCP:", sending_location,
              "<br>",
              "Number of People:", formatC(clients, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        title = ifelse(input$EquipmentTypeInput == "Community alarm only",
                       paste("<b>Number of people provided with Community Alarms only;<br>by Health & Social Care Partnership: 2017/18"),
                       ifelse(input$EquipmentTypeInput == "Telecare only",
                              paste("<b>Number of people provided with Telecare only;<br>byHealth & Social Care Partnership: 2017/18"),
                              ifelse(input$EquipmentTypeInput == "Receiving both community alarm and telecare",
                                     paste("<b>Number of people provided with both Community Alarm and Telecare;<br>by Health & Social Care Partnership: 2017/18"),
                                     paste("<b>Total number of people provided with Community Alarms and/or Telecare<br>by Health & Social Care Partnership: 2017/18")
                              )
                       )
        ),
        yaxis = list(
          title = "Number of People",
          exponentformat = "none",
          titlefont = f2,
          showline = TRUE,
          ticks = "outsde"
        ),
        xaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health & Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside",
          tickangle = -90
        ),
        margin = list(l = 10, r = 10, b = 90, t = 40),
        font = list(size = 13),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$equipmentbutton, {
    toggle("EquipmentTable")
    output$table_clients_equipment <- DT::renderDataTable(DT::datatable(equipmentD() %>%
                                                                          mutate(clients = ifelse(is.na(clients), "*", formatC(clients, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                        style = "bootstrap",
                                                                        class = "table-bordered table-condensed",
                                                                        rownames = FALSE,
                                                                        colnames = c(
                                                                          "Location",
                                                                          "Measure",
                                                                          "Number of People"
                                                                        ),
                                                                        options = list(
                                                                          pageLength = 16,
                                                                          autoWidth = TRUE,
                                                                          dom = "tip",
                                                                          bPaginate = FALSE,
                                                                          bInfo = FALSE
                                                                        )
    ))
  })
  
  output$download_equipment_alarmstelecare <- downloadHandler(
    filename = "community_alarm_telecare.csv",
    content = function(file) {
      write.table(data_alarm_telecare_equipment %>%
                    mutate(clients = ifelse(is.na(clients), "*", formatC(clients, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Measure",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  ##############################
  ### People and Services Summary ----
  ##############################
  
  # X.5.1 People Supported ----
  
  ClientDemogTotalsD <- reactive({
    data_clients_totals %>%
      filter(type == input$Clientstype5Input)
  })
  
  output$ClientTotals <- renderPlotly({
    plot_ly(ClientDemogTotalsD() %>%
              filter(sending_location != "Scotland (estimated)"),
            x = ~sending_location,
            y = ~nclient,
            hoverinfo = "text",
            text = ~ paste(
              "HSCP:", sending_location,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        title = ~ paste("<b>", input$Clientstype5Input, "<br>with social care services/support during financial year 2017/18"),
        xaxis = list(
          tickangle = -90,
          title = paste0(c(
            rep("&nbsp;", 40),
            "Health & Social Care Partnership",
            rep("&nbsp;", 40),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        yaxis = list(
          title = "Number of People",
          exponentformat = "none",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        margin = list(l = 10, r = 10, b = 70, t = 60),
        titlefont = f1,
        legend = list(x = 100, y = 0.5)
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$Clientstotalsbutton, {
    toggle("ClientsTotalsTable")
    output$table_clients_totals <- DT::renderDataTable(DT::datatable(ClientDemogTotalsD() %>%
                                                                       select(sending_location, type, nclient) %>%
                                                                       mutate(nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                     style = "bootstrap",
                                                                     class = "table-bordered table-condensed",
                                                                     rownames = FALSE,
                                                                     colnames = c(
                                                                       "Location",
                                                                       "Measure",
                                                                       "Number of People"
                                                                     ),
                                                                     options = list(
                                                                       pageLength = 16,
                                                                       autoWidth = TRUE,
                                                                       columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                       dom = "tip",
                                                                       bPaginate = FALSE,
                                                                       bInfo = FALSE
                                                                     )
    ))
  })
  
  output$download_clients_totals <- downloadHandler(
    filename = "client_totals.csv",
    content = function(file) {
      write.table(data_clients_totals %>%
                    select(sending_location, type, nclient) %>%
                    mutate(nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Measure",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.5.2 Age and Sex ----
  
  ClientsagesexD <- reactive({
    data_clients_age_sex %>%
      filter(
        type == input$ClientsTypeInput,
        sending_location == input$ClientsPartnership1Input
      )
  })
  
  ClientsagesexDD2 <- reactive({
    Clientsagesex %>%
      filter(
        type == input$ClientsTypeInput,
        sending_location == input$ClientsPartnership1Input,
        !Age_Band %in% c("Unknown", "All ages")
      )
  })
  
  # Clients Age/Sex Chart
  
  output$Clientsagesex <- renderPlotly({
    plot_ly(ClientsagesexD() %>%
              filter(!Age_Band %in% c("Unknown", "All ages")) %>%
              mutate(nclient = ifelse(is.na(nclient), 0, nclient)),
            x = ~nclient, y = ~Age_Band, color = ~ as.factor(Sex),
            colors = c("#9ecae1", "#2171b5"),
            type = "bar", orientation = "h",
            width = 1000, height = 400,
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Gender:", Sex,
              "<br>",
              "Age Band:", Age_Band,
              "<br>",
              "Number of People:", formatC(abs(nclient), format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        bargap = 0.2, barmode = "overlay",
        legend = list(x = 100, y = 0.5, font = list(size = 15)),
        title = ifelse((input$ClientsPartnership1Input == "All Areas Submitted" &
                          input$ClientsTypeInput == "Number of people supported - adjusted"),
                       paste("<b>", input$ClientsTypeInput, "in", input$ClientsPartnership1Input, "<br>receiving social care services/support; by age and sex, 2017/18<b>"),
                       ifelse((input$ClientsPartnership1Input == "All Areas Submitted" & input$ClientsTypeInput == "Number of people supported"),
                              paste("<b>", input$ClientsTypeInput, "in", input$ClientsPartnership1Input, "<br>receiving social care services/support; by age and sex, 2017/18<b>"),
                              ifelse((input$ClientsPartnership1Input != "All Areas Submitted" &
                                        input$ClientsTypeInput == "Number of people supported - adjusted"),
                                     paste("<b>", input$ClientsTypeInput, "in<br>", input$ClientsPartnership1Input, "HSCP<br>receiving social care services/support, by age and sex, 2017/18<b>"),
                                     paste("<b>", input$ClientsTypeInput, "in", input$ClientsPartnership1Input, "HSCP<br>receiving social care services/support; by age and sex, 2017/18<b>")
                              )
                       )
        ),
        margin = list(l = 10, r = 20, b = 30, t = 90),
        titlefont = f1,
        yaxis = list(
          title = "Age Band",
          showline = TRUE,
          ticks = "outside",
          titlefont = f2
        ),
        xaxis = list(
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          separatethousands = TRUE,
          tickmode = "array",
          showline = TRUE,
          ticks = "outside",
          range = c(
            -round(max(abs(ClientsagesexDD2()$nclient)
                       * 110 / 100)),
            round(max(abs(ClientsagesexDD2()$nclient)
                      * 110 / 100))
          ),
          tickangle = 0,
          tickvals = c(
            -round(max(abs(ClientsagesexDD2()$nclient))),
            -round(max(abs(ClientsagesexDD2()$nclient))
                   * 66 / 100),
            -round(max(abs(ClientsagesexDD2()$nclient))
                   * 33 / 100),
            0,
            round(max(abs(ClientsagesexDD2()$nclient))
                  * 33 / 100),
            round(max(abs(ClientsagesexDD2()$nclient))
                  * 66 / 100),
            round(max(abs(ClientsagesexDD2()$nclient)))
          ),
          ticktext = paste0(
            as.character(c(
              round(max(abs(ClientsagesexDD2()$nclient))),
              round(max(abs(ClientsagesexDD2()$nclient))
                    * 66 / 100),
              round(max(abs(ClientsagesexDD2()$nclient))
                    * 33 / 100),
              0,
              round(max(abs(ClientsagesexDD2()$nclient))
                    * 33 / 100),
              round(max(abs(ClientsagesexDD2()$nclient))
                    * 66 / 100),
              round(max(abs(ClientsagesexDD2()$nclient)))
            ))
          )
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  # Clients age/sex Table - show/hide
  
  observeEvent(input$Clientsagesexbutton, {
    toggle("ClientsAgeSexTable")
    output$table_clients_agesex <- DT::renderDataTable(DT::datatable(ClientsagesexD() %>%
                                                                       select(sending_location, type, Sex, Age_Band, nclient) %>%
                                                                       mutate(nclient = ifelse(abs(nclient) < 5, "*", formatC(abs(nclient), format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                     style = "bootstrap",
                                                                     class = "table-bordered table-condensed",
                                                                     rownames = FALSE,
                                                                     colnames = c(
                                                                       "Location",
                                                                       "Measure",
                                                                       "Sex",
                                                                       "Age Band",
                                                                       "Number of People"
                                                                     ),
                                                                     options = list(
                                                                       pageLength = 16,
                                                                       autoWidth = TRUE,
                                                                       dom = "tip",
                                                                       bPaginate = FALSE,
                                                                       bInfo = FALSE
                                                                     )
    ))
  })
  
  output$download_clients_agesex <- downloadHandler(
    filename = "age_sex_data.csv",
    content = function(file) {
      write.table(data_clients_age_sex %>%
                    select(sending_location, type, Sex, Age_Band, nclient) %>%
                    mutate(nclient = ifelse(abs(nclient) < 5, "*", formatC(abs(nclient), format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Measure",
                    "Sex",
                    "Age Band",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.5.3 Deprivation Category (SIMD) ----
  
  DeprivationD <- reactive({
    data_clients_deprivation %>%
      filter(sending_location == input$ClientsPartnership5Input)
  })
  
  output$Clientsdeprivation <- renderPlotly({
    plot_ly(DeprivationD() %>%
              filter(
                simd2016_CA2011_quintile != "Unknown",
                type == "Number of people supported"
              ),
            x = ~simd2016_CA2011_quintile,
            y = ~nclient,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Deprivation Quintile:", simd2016_CA2011_quintile,
              "<br>",
              "Number of People", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          title = "Deprivation Quintile",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        yaxis = list(
          title = "Number of People",
          exponentformat = "none",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse(input$ClientsPartnership5Input == "All Areas Submitted",
                       paste("<b>Number of people in", input$ClientsPartnership5Input, "receiving social care services/support<br>by Deprivation Quintile Financial year 2017/18<b>"),
                       paste("<b>Number of people in", input$ClientsPartnership5Input, "HSCP receiving social care services/support<br>by Deprivation Quintile Financial year 2017/18<b>")
        ),
        margin = list(l = 90, r = 60, b = 40, t = 90),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  
  observeEvent(input$Clientsdeprivationbutton, {
    toggle("ClientsDeprivationTable")
    output$table_clients_deprivation <- DT::renderDataTable(DT::datatable(DeprivationD() %>%
                                                                            select(sending_location, simd2016_CA2011_quintile, nclient) %>%
                                                                            mutate(nclient = ifelse(nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                          style = "bootstrap",
                                                                          class = "table-bordered table-condensed",
                                                                          rownames = FALSE,
                                                                          colnames = c(
                                                                            "Location",
                                                                            "Deprivaton Quintile",
                                                                            "Number of People"
                                                                          ),
                                                                          options = list(
                                                                            pageLength = 16,
                                                                            autoWidth = TRUE,
                                                                            dom = "tip",
                                                                            bPaginate = FALSE,
                                                                            bInfo = FALSE
                                                                          )
    ))
  })
  
  output$download_clients_deprivation <- downloadHandler(
    filename = "client_deprivation.csv",
    content = function(file) {
      write.table(data_clients_deprivation %>%
                    select(sending_location, simd2016_CA2011_quintile, nclient) %>%
                    mutate(nclient = ifelse(nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Deprivaton Quintile",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.5.4 Social Care Client Group ----
  
  # Client Type Data
  
  output$ClientsAgeBandInput <- renderUI(shinyWidgets::pickerInput("ClientsAgeBandXInput",
                                                                   "Select Age Band:",
                                                                   choices = unique(data_clients_client_group$Age_Band[data_clients_client_group$sending_location == input$ClientsPartnership2Input]),
                                                                   selected = "All ages"
  ))
  
  
  ClientsclienttypeD <- reactive({
    data_clients_client_group %>%
      filter(
        sending_location == input$ClientsPartnership2Input,
        Measure == input$ClientsType2Input,
        Age_Band == input$ClientsAgeBandXInput
      )
  })
  
  
  
  
  # Client Type Chart
  
  output$Clientsclienttype <- renderPlotly({
    plot_ly(ClientsclienttypeD(),
            x = ~type,
            y = ~nclient,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Age Band:", Age_Band,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          tickangle = -90,
          title = "Client Group",
          categoryorder = "category array",
          categoryarray = ~nclient,
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        yaxis = list(
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          rangemode = "tozero",
          showline = TRUE,
          ticks = "outside"
        ),
        title = ifelse((input$ClientsPartnership2Input == "All Areas Submitted" & input$ClientsType2Input == "Number of people supported"),
                       paste("<b>Indicative", input$ClientsType2Input, "in", input$ClientsPartnership2Input, "<br>receiving social care support and services; by client group and<br>age group", input$ClientsAgeBandXInput, ":variable reference periods during 2017/18"),
                       ifelse((input$ClientsPartnership2Input != "All Areas Submitted" & input$ClientsType2Input == "Number of people supported"),
                              paste("<b>Indicative", input$ClientsType2Input, "in", input$ClientsPartnership2Input, "HSCP<br>receiving social care support and services; by client group and<br>age group", input$ClientsAgeBandXInput, ":variable reference periods during 2017/18"),
                              ifelse((input$ClientsPartnership2Input == "All Areas Submitted" & input$ClientsType2Input == "Number of people supported - Scottish Government social care comparison"),
                                     paste("<b>Indicative", input$ClientsType2Input, "<br>in", input$ClientsPartnership2Input, "receiving social care support<br>and services; by client group and age group", input$ClientsAgeBandXInput, ":<br>variable reference periods during 2017/18"),
                                     paste("<b>Indicative", input$ClientsType2Input, "<br>in", input$ClientsPartnership2Input, "HSCP receiving social care support<br>and services; by client group and age group", input$ClientsAgeBandXInput, ":<br>variable reference periods during 2017/18")
                              )
                       )
        ),
        margin = list(l = 10, r = 10, b = 110, t = 110),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  
  # Client Type Table - show/hide
  
  observeEvent(input$Clientsclienttypebutton, {
    toggle("ClientsClientTypeTable")
    output$table_clients_clienttype <- DT::renderDataTable(DT::datatable(ClientsclienttypeD() %>%
                                                                           mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                         style = "bootstrap",
                                                                         class = "table-bordered table-condensed",
                                                                         rownames = FALSE,
                                                                         colnames = c(
                                                                           "Location",
                                                                           "Client Type",
                                                                           "Age Band",
                                                                           "Measure",
                                                                           "Indicative Number of People"
                                                                         ),
                                                                         options = list(
                                                                           pageLength = 16,
                                                                           autoWidth = TRUE,
                                                                           dom = "tip",
                                                                           bPaginate = FALSE,
                                                                           bInfo = FALSE
                                                                         )
    ))
  })
  
  output$download_clients_clienttype <- downloadHandler(
    filename = "client_clientgroup.csv",
    content = function(file) {
      write.table(data_clients_client_group %>%
                    mutate(nclient = ifelse(is.na(nclient) | nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Client Type",
                    "Age Band",
                    "Measure",
                    "Indicative Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.5.5 Ethnicity Group ----
  
  # Ethnicity Data
  EthData <- reactive({
    data_clients_ethnicity %>%
      filter(
        sending_location == input$ClientsPartnership3Input,
        Reason == input$ClientsType3Input
      )
  })
  
  
  
  
  # Ethnicity Table show/hide
  
  output$table_clients_ethnicity <- DT::renderDataTable({
    DT::datatable(EthData() %>%
                    arrange(desc(EthnicGroup2)) %>%
                    mutate(nclient = ifelse(nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  style = "bootstrap",
                  class = "table-bordered table-condensed",
                  rownames = FALSE,
                  colnames = c(
                    "Location",
                    "Ethnicity",
                    "Measure",
                    "Number of People"
                  ),
                  options = list(
                    pageLength = 16,
                    autoWidth = TRUE,
                    dom = "tip",
                    bPaginate = FALSE,
                    bInfo = FALSE
                  )
    )
  })
  
  output$download_clients_ethnicity <- downloadHandler(
    filename = "client_ethnicity.csv",
    content = function(file) {
      write.table(data_clients_ethnicity %>%
                    arrange(desc(EthnicGroup2)) %>%
                    mutate(nclient = ifelse(nclient < 5, "*", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Ethnicity",
                    "Measure",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  # X.5.6 Support and Services ----
  
  # intro table
  observeEvent(input$supportservicesexpandbutton, {
    toggle("ServiceSupportTable")
    output$Service_Support_Table <- renderTable(
      ServicesSupportInfoTable,
      na = " ",
      spacing = "xs",
      bordered = TRUE
    )
  })
  
  # Support Data
  
  GroupAData <- reactive({
    data_clients_support_services %>%
      filter(sending_location == input$ClientsPartnership4Input)
  })
  
  # Support  Charts
  
  output$GroupA <- renderPlotly({
    plot_ly(GroupAData(),
            x = ~type,
            y = ~nclient,
            color = ~Group,
            colors = c("#08519c", "#3182bd", "#54278f"),
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Time Period:", Group,
              "<br>",
              "Social Care Service:", type,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          title = "Social Care Service/Support",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside",
          tickangle = -90,
          categorymode = "array",
          categoryarray = ~Group
        ),
        yaxis = list(
          title = "Number of People",
          titlefont = f2,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        margin = list(l = 5, r = 5, b = 20, t = 60),
        titlefont = f1,
        title = ifelse(input$ClientsPartnership4Input == "All Areas Submitted",
                       paste("<b>Summary metrics on people in", input$ClientsPartnership4Input, "receiving social care services or support:<br>for variable reference periods during 2017/18<b>"),
                       paste("<b>Summary metrics on people in", input$ClientsPartnership4Input, "HSCP<br>receiving social care services or support: for variable reference periods during 2017/18<b>")
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  observeEvent(input$Clientssummarybutton, {
    toggle("ClientsSummaryTable")
    output$table_clients_summary <- DT::renderDataTable(DT::datatable(GroupAData() %>%
                                                                        select(sending_location, Group, type, nclient) %>%
                                                                        mutate(nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                                                                      style = "bootstrap",
                                                                      class = "table-bordered table-condensed",
                                                                      rownames = FALSE,
                                                                      colnames = c(
                                                                        "Location",
                                                                        "Time Period",
                                                                        "Type of Service/Support",
                                                                        "Number of People"
                                                                      ),
                                                                      options = list(
                                                                        pageLength = 16,
                                                                        autoWidth = TRUE,
                                                                        dom = "tip",
                                                                        bPaginate = FALSE,
                                                                        bInfo = FALSE
                                                                      )
    ))
  })
  
  output$download_clients_summary <- downloadHandler(
    filename = "client_services.csv",
    content = function(file) {
      write.table(data_clients_support_services %>%
                    select(sending_location, Group, type, nclient) %>%
                    mutate(nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Time Period",
                    "Type of Service/Support",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  # X.5.7 Meals ----
  mealsD <- reactive({
    data_clients_meals %>%
      filter(
        sending_location == input$MealsPartnershipInput,
        AgeGroup != "All"
      ) %>%
      select(sending_location, AgeGroup, Meals)
  })
  
  output$mealsoutput <- renderPlotly({
    plot_ly(mealsD() %>%
              filter(sending_location != "Orkney Islands"),
            x = ~AgeGroup,
            y = ~Meals,
            type = "bar",
            hoverinfo = "text",
            text = ~ paste(
              "Location:", sending_location,
              "<br>",
              "Age Band:", AgeGroup,
              "<br>",
              "Number of People:", formatC(Meals, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        title = ifelse(input$MealsPartnershipInput == "All Areas Submitted",
                       paste("<b>Number of people in", input$MealsPartnershipInput, "receiving meals by Age Band;<br>Quarter ending March 2018<b>"),
                       paste("<b>Number of people in", input$MealsPartnershipInput, "HSCP receiving meals by Age Band;<br>Quarter ending March 2018<b>")
        ),
        yaxis = list(
          title = "Number of people receiving meals",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        xaxis = list(
          title = "Age Group",
          titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        margin = list(l = 10, r = 10, b = 70, t = 40),
        titlefont = f1
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = list(
          "select2d", "lasso2d",
          "zoomIn2d", "zoomOut2d",
          "autoScale2d",
          "resetScale2d",
          "zoom2d",
          "pan2d",
          "toggleSpikelines",
          "hoverCompareCartesian",
          "hoverClosestCartesian"
        ),
        displaylogo = F, collaborate = F, editable = F
      )
  })
  
  
  observeEvent(input$mealsbutton, {
    toggle("ClientsMealsTable")
    output$table_clients_meals <- DT::renderDataTable(DT::datatable(mealsD() %>%
                                                                      mutate(Meals = ifelse(is.na(Meals) | Meals < 5, "*", formatC(Meals, format = "f", big.mark = ",", drop0trailing = TRUE))),
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Location",
                                                                      "Age Group",
                                                                      "Number of Meals"
                                                                    ),
                                                                    options = list(
                                                                      pageLength = 16,
                                                                      autoWidth = TRUE,
                                                                      dom = "tip",
                                                                      columnDefs = list(list(className = "dt-left", targets = "_all")),
                                                                      bPaginate = FALSE,
                                                                      bInfo = FALSE
                                                                    )
    ))
  })
  
  output$download_clients_meals <- downloadHandler(
    filename = "clients_meals.csv",
    content = function(file) {
      write.table(data_clients_meals %>%
                    filter(AgeGroup != "All") %>%
                    select(sending_location, AgeGroup, Meals) %>%
                    mutate(Meals = ifelse(is.na(Meals) | Meals < 5, "*", formatC(Meals, format = "f", big.mark = ",", drop0trailing = TRUE))),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Location",
                    "Age Group",
                    "Number of Meals"
                  ),
                  sep = ","
      )
    }
  )
}