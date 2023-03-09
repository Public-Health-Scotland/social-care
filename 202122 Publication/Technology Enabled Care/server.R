#####################################################-
## TECHNOLOGY ENABLED CARE SERVER SCRIPT ##
#####################################################-


################################################-
## code to password protect app - comment out if not required ##
## read in server credentials code from admin/create_credentials.R ##
#credentials <- readRDS("admin/credentials.rds")  
################################################-


### SERVER ----

server <- function(input, output, session) {
  
  
  # shiny manager code required for password protection 
  #########################-
  #### SHINY MANAGER -----
  #########################-
  # library(shinymanager)
  # res_auth <- shinymanager::secure_server(
  #   check_credentials = check_credentials(credentials))
  # 
  # output$auth_output <- renderPrint({
  #   reactiveValuesToList(res_auth)
  # })
  ################################################-
  
  
  #########################-
  ## DATA COMPLETENESS ------
  #########################-
  
  data_completeness_hscp_table <- reactive({
    if (input$data_completeness_hscp == "All HSCPs" & input$data_completeness_year == "All Financial Years") { 
      data_completeness_table
      
    } else if (input$data_completeness_hscp == "All HSCPs" & input$data_completeness_year != "All Financial Years") { 
      data_completeness_table %>% 
        filter(`Financial Year` == input$data_completeness_year)
      
    } else if (input$data_completeness_hscp != "All HSCPs" & input$data_completeness_year == "All Financial Years") { 
      data_completeness_table %>% 
        filter(`Health and Social Care Partnership` == input$data_completeness_hscp)
      
    } else {
      data_completeness_table %>%
        filter(`Health and Social Care Partnership` == input$data_completeness_hscp,
               `Financial Year` == input$data_completeness_year)
      
    }
  })
  
  
  output$data_completeness_table <-  DT::renderDataTable(
    DT::datatable(data_completeness_hscp_table(),
                  style = "bootstrap",
                  class = "table-bordered table-condensed",
                  rownames = FALSE,
                  options = list(pageLength = 16,
                                 autoWidth = TRUE,
                                 #dom = "tip",
                                 bPaginate = FALSE,
                                 bInfo = FALSE)))
  
  
  #########################-
  ## DATA QUALITY -----
  #########################-
  
  
  data_quality_hscp_table <- reactive({
    if (input$data_quality_hscp == "All HSCPs" & input$data_quality_year == "All Financial Years") { 
      data_quality_table
      
    } else if (input$data_quality_hscp == "All HSCPs" & input$data_quality_year != "All Financial Years") { 
      data_quality_table %>% 
        filter(`Financial Year` == input$data_quality_year)
      
    } else if (input$data_quality_hscp != "All HSCPs" & input$data_quality_year == "All Financial Years") { 
      data_quality_table %>% 
        filter(`Health and Social Care Partnership` == input$data_quality_hscp)
      
    } else {
      data_quality_table %>%
        filter(`Health and Social Care Partnership` == input$data_quality_hscp,
               `Financial Year` == input$data_quality_year)
      
    }
  })
  
  output$data_quality_table <-  DT::renderDataTable(
    DT::datatable(data_quality_hscp_table(),
                  style = "bootstrap",
                  class = "table-bordered table-condensed",
                  rownames = FALSE,
                  options = list(pageLength = 16,
                                 autoWidth = TRUE,
                                 #dom = "tip",
                                 bPaginate = FALSE,
                                 bInfo = FALSE)))
  
  
  #########################################-
  #### TREND ----
  #########################################-
  
  ## TREND - DATA ----
  
  data_tech_enabled_care_trend_plot <- reactive({
    data_tech_enabled_care_trend %>%
      filter(sending_location == input$tec_trend_location_input,
             service          == input$tec_trend_service_input,
             measure          == input$tec_trend_measure_input)
  })
  
  ## Data for location comparison
  data_tech_enabled_care_trend_comparison_plot <- reactive({
    data_tech_enabled_care_trend %>%
      filter(sending_location == input$tec_trend_location_comparison_input,
             service          == input$tec_trend_service_input,
             measure          == input$tec_trend_measure_input)
  })
  
  ## TREND - PLOT ----
  
  output$tec_trend_plot <- renderPlotly({
    plot_ly(data = data_tech_enabled_care_trend_plot(),
            x = ~financial_year,
            y = ~value,
            type = "scatter", # creates scatterplot
            mode = "lines+markers",  # creates line graph 
            line = trend_line_setting,
            marker = trend_marker_setting,
            name = paste(input$tec_trend_measure_input, input$tec_trend_location_input),
            
            ## Add tooltop information (text to appear when cursor hovers over a data point in the plot)
            hoverinfo = "text",
            text = ~ paste("Service received:", input$tec_trend_service_input,
                           "<br>", 
                           "Location:", sending_location,
                           "<br>",
                           "Financial Year:", financial_year,
                           "<br>",
                           "Age Group:", age_group,
                           "<br>",
                           input$tec_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))) %>% 
      
      ## Add location Comparison line 
      add_trace(name = paste(input$tec_trend_measure_input, input$tec_trend_location_comparison_input),
                data = data_tech_enabled_care_trend_comparison_plot(),
                x = ~financial_year,
                y = ~value,
                type = "scatter",
                mode = "lines+markers",
                line = comparison_trend_line_setting, # black dashed line
                marker = comparison_trend_marker_setting,
                
                # Add tooltip for location comparison line
                hoverinfo = "text",
                text = ~ paste("Service received:", input$tec_trend_service_input,
                               "<br>",
                               "Location:", input$tec_trend_location_comparison_input,
                               "<br>",
                               "Financial Year:", financial_year,
                               "<br>",
                               "Age Group:", age_group,
                               "<br>",
                               input$tec_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)),
                inherit = FALSE,
                showlegend = TRUE) %>%
      
      ## add COVID-19 reference line
      add_trace(name = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                data = rbind(data_tech_enabled_care_trend_plot(), data_tech_enabled_care_trend_comparison_plot()),
                type = "scatter",
                mode = "lines",
                color = reference_line_style,
                x = "2019/20",
                y = ~c(0:max(value)),
                hoverinfo = "text",
                text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                inherit = FALSE) %>%
      
      ## Specify plot layout, titles and axis settings
      layout(yaxis = list(rangemode = "tozero",## Y axis specifications 
                          title = paste0(c(rep("&nbsp;", 30),
                                           input$tec_trend_measure_input,
                                           rep("&nbsp;", 30),
                                           rep("\n&nbsp;", 1)),
                                         collapse = ""),
                          showline = TRUE,
                          exponentformat = "none",
                          separatethousands = TRUE,
                          ticks = "outside"),
             xaxis = list(title = "Financial Year",## X axis specifications
                          showline = TRUE,
                          ticks = "outside",
                          showgrid = FALSE),
             margin = list(l = 50, r = 10, b = 60, t = 150),
             
             ## legend
             legend = list(x = 0, y = -0.9,
                           font = list(size = 14)),
             
             ### Plot title 
             title = ifelse(input$tec_trend_measure_input != "Rate per 1,000 Population",
                            ifelse(input$tec_trend_location_input == input$tec_trend_location_comparison_input,
                                   paste0("<b> Number of People with ", input$tec_trend_service_input, "<br> in ",
                                          input$tec_trend_location_input, " 2015-16 - 2021/22"),
                                   paste0("<b> Number of People with ", input$tec_trend_service_input, "<br> in ",
                                          input$tec_trend_location_input, " and ", input$tec_trend_location_comparison_input, 
                                          " 2015/16 - 2021/22.")),
                            ifelse(input$tec_trend_location_input == input$tec_trend_location_comparison_input,
                                   paste0("<b> Number of People as a Rate per 1,000 Population with <br>", 
                                          input$tec_trend_service_input, "<br> in ",
                                          input$tec_trend_location_input, " 2015-16 - 2021/22"),
                                   paste0("<b> Number of People as a Rate per 1,000 Population with <br>", 
                                          input$tec_trend_service_input, "<br> in ",
                                          input$tec_trend_location_input, " and ", input$tec_trend_location_comparison_input, " 2015/16 - 2021/22.")))
      ) %>% # end of layout
      config(displayModeBar = TRUE,
             modeBarButtonsToRemove = buttons_to_remove,
             displaylogo = F,
             editable = F)
  }) # end of renderPlotly  
  
  ## TREND - TABLE ----
  
  ## data for the table 
  data_tec_trend_table <- reactive({
    if(input$tec_trend_location_input == input$tec_trend_location_comparison_input){
      data_tech_enabled_care_trend_plot() %>%
        select(financial_year, sending_location, service, age_group, value) %>%
        mutate(value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    } else {
      rbind(data_tech_enabled_care_trend_plot(),data_tech_enabled_care_trend_comparison_plot()) %>%
        select(financial_year, sending_location, service, age_group, value) %>%
        mutate(value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    }
  }) # end of reactive
  
  observeEvent(input$tec_trend_showhide, {
    toggle("tec_trend_table")
    output$tec_trend_table_output <- DT::renderDataTable(DT::datatable(
      data_tec_trend_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c("Financial Year",
                   "Location",
                   "Service",
                   "Age Group",
                   input$tec_trend_measure_input),
      options = list(pageLength = 16,
                     autoWidth = TRUE,
                     dom = "tip",
                     bPaginate = FALSE,
                     bInfo = FALSE)) # end of datatable
    ) # end of render table
  })# end of observe event
  
  
  ## TREND - DOWNLOAD DATA ----
  
  output$download_tec_trend_data <- downloadHandler(
    filename = "technology_enabled_care_trend.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_trend %>% 
                    select(financial_year, sending_location, age_group, service, measure, value),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Service",
                                "Measure",
                                "Value"),
                  sep = ",")
    }
  ) # end of download handler
  
  
  #############################################-
  #### SUMMARY ----
  #############################################-
  
  ## SUMMARY - DATA ----
  
  data_tech_enabled_care_summary_plot <- reactive({
    data_tech_enabled_care_summary %>%
      filter(financial_year == input$tec_summary_year_input,
             age_group      == input$tec_summary_age_input,
             service        == input$tec_summary_service_input,
             measure        == input$tec_summary_measure_input,        
             value != 0) # remove values equal to 0 to avoid plotting these locations
  }) # end of reactive
  
  ## SUMMARY - PLOT ----
  
  output$tec_summary_plot <- renderPlotly({
    if (input$tec_summary_measure_input == "Rate per 1,000 Population") {
      plot_ly(data_tech_enabled_care_summary_plot() %>%
                filter(sending_location != "Scotland (All Areas Submitted)"),
              y = ~sending_location,
              x = ~as.numeric(value),
              type = "bar",
              name = input$tec_summary_measure_input,
              marker = phs_bar_col,
              
              ### Add tooltip to plot
              hoverinfo = "text",
              hovertext = ~ paste("Financial Year: ", financial_year,
                                  "<br>",
                                  "Location:", sending_location,
                                  "<br>",
                                  "Age Group:", input$tec_summary_age_input,
                                  "<br>",
                                  "Service:",input$tec_summary_service_input,
                                  "<br>",
                                  input$tec_summary_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
      ) %>% # end of plot_ly
        
        ### Add Scotland reference line
        add_trace(color = reference_line_style,  # scotland reference line colour set in global.R script
                  name = "Scotland (All Areas Submitted)",
                  y = ~sending_location,
                  x = ~scotland_value,
                  type = "scatter",
                  mode = "line",
                  hoverinfo = "text",
                  text = ~ paste("Financial Year: ", financial_year,
                                 "<br>",
                                 "Location: Scotland (All Areas Submitted)",
                                 "<br>",
                                 "Age Group:", input$tec_summary_age_input,
                                 "<br>",
                                 "Service:",input$tec_summary_service_input,
                                 "<br>",
                                 input$tec_summary_measure_input,":", formatC(scotland_value, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  inherit = FALSE,
                  showlegend = TRUE) %>%
        
        layout(
          ### Plot title
          title = paste0("<b> Number of People as a Rate per 1,000 Population <br> with ", 
                         input$tec_summary_service_input, ", ", input$tec_summary_age_input, 
                         ", <br> by Health and Social Care Partnership, ", input$tec_summary_year_input, "."),
          xaxis = list(title = paste(input$tec_summary_measure_input), # X AXIS
                       separatethousands = TRUE,
                       rangemode = "tozero",
                       exponentformat = "none",
                       #titlefont = f2,
                       showline = TRUE,
                       ticks = "outsde"),  
          yaxis = list(title = paste0(c(rep("&nbsp;", 30),# Y AXIS 
                                        "Health and Social Care Partnership",
                                        rep("&nbsp;", 30),
                                        rep("\n&nbsp;", 1)),
                                      collapse = ""),
                       categoryorder = "total ascending",
                       categoryarray = ~value,
                       showline = TRUE,
                       ticks = "outside",
                       tickangle = 0),
          margin = list(l = 15, r = 10, b = 30, t = 110),
          legend = list(x = 0, y = -0.3, ## legend
                        font = list(size = 14))
        ) %>% # end of layout
        config(displayModeBar = TRUE,
               modeBarButtonsToRemove = buttons_to_remove,
               displaylogo = F,
               editable = F)
      
    } else {
      
      plot_ly(data_tech_enabled_care_summary_plot() %>%
                filter(sending_location != "Scotland (All Areas Submitted)"),
              y = ~sending_location,
              x = ~as.numeric(value),
              type = "bar",
              name = input$tec_summary_measure_input,
              marker = phs_bar_col,
              
              ### Add tooltip to plot
              hoverinfo = "text",
              hovertext = ~ paste("Financial Year: ", financial_year,
                                  "<br>",
                                  "Location:", sending_location,
                                  "<br>",
                                  "Age Group:", input$tec_summary_age_input,
                                  "<br>",
                                  "Service:",input$tec_summary_service_input,
                                  "<br>",
                                  input$tec_summary_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
      ) %>% # end of plot_ly
        layout(
          ### Plot title
          title = paste0("<b> Number of People with ", input$tec_summary_service_input, ", <br>", input$tec_summary_age_input, 
                         ", by Health and Social Care Partnership, ", input$tec_summary_year_input, "."),
          xaxis = list(title = paste(input$tec_summary_measure_input), # X AXIS
                       separatethousands = TRUE,
                       rangemode = "tozero",
                       exponentformat = "none",
                       showline = TRUE,
                       ticks = "outsde"),
          yaxis = list(title = paste0(c(rep("&nbsp;", 30), # Y AXIS 
                                        "Health and Social Care Partnership",
                                        rep("&nbsp;", 30),
                                        rep("\n&nbsp;", 1)),
                                      collapse = ""),
                       categoryorder = "total ascending",
                       categoryarray = ~value,
                       showline = TRUE,
                       ticks = "outside",
                       tickangle = 0),
          margin = list(l = 15, r = 10, b = 30, t = 110),
          legend = list(x = 0, y = -0.3, ## legend
                        font = list(size = 14))        
        ) %>% # end layout
        config(displayModeBar = TRUE,
               modeBarButtonsToRemove = buttons_to_remove,
               displaylogo = F,
               editable = F)
    }
  }) # end of render plotly
  
  
  ## SUMMARY - TABLE ----
  
  data_tec_summary_table <- reactive({
    data_tech_enabled_care_summary_plot() %>%
      select(financial_year, 
             sending_location,
             age_group,
             service,
             value) %>%
      mutate(value = format(value, big.mark = ","))
  })
  
  observeEvent(input$tec_summary_show_table, {
    toggle("tec_summary_table")
    output$tec_summary_table_output <- DT::renderDataTable(DT::datatable(
      data_tec_summary_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c("Financial Year",
                   "Location",
                   "Age Group",
                   "Service",
                   input$tec_summary_measure_input),
      options = list(pageLength = 16,
                     autoWidth = TRUE,
                     dom = "tip",
                     bPaginate = FALSE,
                     bInfo = FALSE)
    ) # end of datatable
    ) # end of render table
  }) # end of observe event
  
  ## SUMMARY - DOWNLOAD DATA ----
  
  output$download_tech_enabled_care_alarmstelecare <- downloadHandler(
    filename = "technology_enabled_care_summary.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_summary %>%
                    select(financial_year,
                           sending_location,
                           age_group,
                           service,
                           measure,
                           value),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Service",
                                "Measure",
                                "Value"),
                  sep = ",") # end of write table
    } # end of function
  ) # end of donwload handler
  
  
  ##########################################.
  #### LIVING ALONE -----
  ##########################################.
  
  ## LIVING ALONE - DATA -----
  
  data_telecare_living_alone_filtered <- reactive({
    data_tech_enabled_care_living_alone %>%
      filter(financial_year == input$tec_living_alone_financial_year_input,
             age_group      == input$tec_living_alone_age_input,
             service        ==  input$tec_living_alone_service_input,
             nclient != 0) %>% 
      arrange(sending_location)
  })
  
  ## LIVING ALONE - PLOT ----
  
  output$tec_living_alone_plot <- renderPlotly({
    plot_ly(data_telecare_living_alone_filtered() %>%
              filter(sending_location != "Scotland (All Areas Submitted)"),
            y = ~sending_location,
            x = ~percentage,
            type = "bar",
            name = ~living_alone_status,
            color = ~living_alone_status,
            colors = four_col_pal,
            
            #### Add tooltip to plot
            hoverinfo = "text",
            hovertext = ~ paste("Living Alone Status:", living_alone_status,
                                "<br>",
                                "Financial Year: ", input$tec_living_alone_financial_year_input,
                                "<br>",
                                "Location:", sending_location,
                                "<br>",
                                "Service:", service,
                                "<br>",
                                "Age Group:", input$tec_living_alone_age_input,
                                "<br>",
                                "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
                                "<br>",
                                "Percentage of People:", formatC(percentage, format = "f", digits = 1), "%",
                                "<br>")
    ) %>% # end of ploty
      layout(
        title = paste0("<b> Percentage of People receiving Technology Enabled Care Support through <br>", input$tec_living_alone_service_input, ", ",
                       input$tec_living_alone_age_input, ", <br> by Living Arrangement and Health and Social Care Partnership, ", 
                       input$tec_living_alone_financial_year_input, "."),
        
        
        
        xaxis = list(title = "Percentage of People",   ### X AXIS
                     showline = TRUE,
                     ticks = "outside",
                     nticks = 6,
                     ticksuffix = "%",
                     rangemode = "tozero"),  
        yaxis = list(title = paste0(c(rep("&nbsp;", 30),### Y AXIS
                                      "Health and Social Care Partnership", 
                                      rep("&nbsp;", 30),
                                      rep("\n&nbsp;", 1)),
                                    collapse = ""),
                     showline = TRUE,
                     autorange = "reversed",
                     categoryorder = "category ascending",
                     ticks = "outside",
                     tickangle = 0),
        margin = list(l = 10, r = 10, b = 30, t = 100),
        barmode = 'stack',
        legend = list(x = 0, y = -0.3,## legend
                      font = list(size = 14),
                      traceorder = "normal")  
      ) %>% # end of layout
      config(displayModeBar = TRUE,
             modeBarButtonsToRemove = buttons_to_remove,
             displaylogo = F,
             editable = F)
  }) # end of reder plotly
  
  ## LIVING ALONE - TABLE ----
  
  data_tec_living_alone_table <- reactive({
    data_telecare_living_alone_filtered() %>%
      filter(sending_location != "Scotland") %>%
      select(financial_year,
             sending_location,
             age_group,
             service,
             living_alone_status,
             nclient,
             percentage) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$tec_living_alone_showhide, {
    toggle("tec_living_alone_table")
    output$tec_living_alone_table_output <- DT::renderDataTable(DT::datatable(
      data_tec_living_alone_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c("Financial Year",
                   "Location",
                   "Age Group",
                   "Service",
                   "Living Alone Status",
                   "Number of People",
                   "Percentage (%)"),
      options = list(pageLength = 16,
                     autoWidth = TRUE,
                     dom = "tip",
                     bPaginate = FALSE,
                     bInfo = FALSE)
    ) # end of datatable
    )# end of render data table
  }) # end of observe event
  
  ## LIVING ALONE - DOWNLOAD DATA ----
  
  output$download_tec_living_alone_data <- downloadHandler(
    filename = "technology_enabled_care_living_alone.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_living_alone %>%
                    filter(sending_location != "Scotland") %>%
                    select(financial_year, sending_location, age_group, service, living_alone_status, nclient, percentage),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Service",
                                "Living Arrangement",
                                "Number of People",
                                "Percentage"),
                  sep = ",")
    } # end of function
  ) # end of download handler
  
  
  ##########################################.
  #### CARE AT HOME -----
  ##########################################.
  
  ##  CARE AT HOME -DATA ----
  
  data_telecare_cah_plot <- reactive({
    data_tech_enabled_care_cah %>%
      filter(financial_year != "2017/18",
             financial_year == input$tec_cah_financial_year_input,
             age_group == input$tec_cah_age_input    
      )
  })
  
  ##  CARE AT HOME -PLOT ----
  output$tec_cah_plot <- renderPlotly({
    plot_ly(data_telecare_cah_plot(), 
            y = ~sending_location,
            x = ~percentage,
            type = "bar",
            name = ~cah_status,
            color = ~cah_status,
            colors = stacked_bar_pal,    # customised color selection, see global.R script for stacked_bar_pal specifications
            
            #### Add tooltip to plot
            hoverinfo = "text",
            hovertext = ~ paste(cah_status,
                                "<br>",
                                "Financial Year: ", input$tec_cah_financial_year_input,
                                "<br>",
                                "Location:", sending_location,
                                "<br>",
                                "Age:", input$tec_cah_age_input,
                                "<br>",
                                "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
                                "<br>",
                                "Percentage of People:", formatC(percentage, format = "f", digits = 1),"%",
                                "<br>")
    ) %>% # end of plotly
      layout(
        title = paste0("<b> Percentage of People, ", input$tec_cah_age_input, 
                       ", with Community Alarms and/or Telecare <br> who also receive Care at Home by Health and Social Care Partnership, ",
                       input$tec_cah_financial_year_input, "."),
        xaxis = list(title = list(text = "Percentage of People", standoff = 10L), ### X AXIS
                     showline = TRUE,
                     ticks = "outside",
                     ticksuffix = "%",         
                     rangemode = "tozero"),
        yaxis = list(title = paste0(c(rep("&nbsp;", 30),      ### Y AXIS 
                                      "Health and Social Care Partnership",
                                      rep("&nbsp;", 30),
                                      rep("\n&nbsp;", 1)),
                                    collapse = ""),
                     showline = TRUE,
                     ticks = "outside",
                     tickangle = 0,
                     autorange = "reversed",
                     categoryorder = "trace"),
        margin = list(l = 10, r = 10, b = 90, t = 110),
        barmode = 'stack',
        legend = list(x = 0, y = -0.2,  ## legend
                      font = list(size = 14),
                      traceorder = "normal")
      ) %>% # end of layout
      config(displayModeBar = TRUE,
             modeBarButtonsToRemove = buttons_to_remove,
             displaylogo = F,
             editable = F)
  }) # end of render plotly
  
  ##  CARE AT HOME -TABLE ----
  
  data_tec_cah_table <- reactive({
    data_telecare_cah_plot() %>%
      select(financial_year,
             sending_location,
             age_group,
             cah_status,
             nclient,
             percentage) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$tec_cah_showhide, {
    toggle("tec_cah_table")
    output$tec_cah_table_output <- DT::renderDataTable(DT::datatable(
      data_tec_cah_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c("Financial Year", 
                   "Location",
                   "Age Group",
                   "Care at Home Status",
                   "Number of People",
                   "Percentage (%)"),
      options = list(pageLength = 16,
                     autoWidth = TRUE,
                     dom = "tip",
                     bPaginate = FALSE,
                     bInfo = FALSE)) # end of datatable
    ) # end of render data table
  }) # end of observe event
  
  ## CARE AT HOME - DOWNLOAD DATA ----
  
  output$download_tec_cah_data <- downloadHandler(
    filename = "technology_enabled_care_cah.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_cah %>%
                    select(financial_year, sending_location, age_group, cah_status, nclient, percentage),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Care at Home Status",
                                "Number of People",
                                "Percentage"),
                  sep = ",")
    }) # end of download handler
  
  
  ##########################################.
  #### CARE AT HOME BY AGE -----
  ##########################################.
  
  ## CARE AT HOME BY AGE - DATA ----
  
  data_telecare_cah_age_plot <- reactive({
    data_tech_enabled_care_cah %>%
      filter(financial_year == input$tec_cah_age_financial_year_input,
             sending_location == input$tec_cah_age_location_input)
  })
  
  ## CARE AT HOME BY AGE - PLOT ----
  
  output$tec_cah_age_plot <- renderPlotly({
    
    if (nrow(data_tech_enabled_care_cah[data_tech_enabled_care_cah$financial_year == input$tec_cah_age_financial_year_input &
                                        data_tech_enabled_care_cah$sending_location  == input$tec_cah_age_location_input , ]) == 0){
      
      text_tec_cah <- list(x = 5,
                           y = 2,
                           font = list(color = "red", size = 16),
                           text = paste(input$tec_cah_age_location_input, 
                                        "were unable to provide data for Care at Home Services <br> with Technology Enabled Care for",
                                        input$tec_cah_age_financial_year_input,
                                        "and cannot be plotted."),
                           xref = "x",
                           yref = "y",
                           showarrow = FALSE)
      
      ## create a blank plot, including the error text
      plot_ly() %>%
        layout(annotations = text_tec_cah,
               yaxis = list(showline = FALSE,
                            showticklabels = FALSE,
                            showgrid = FALSE),
               xaxis = list(showline = FALSE,
                            showticklabels = FALSE,
                            showgrid = FALSE)) %>%
        config(displayModeBar = FALSE,
               displaylogo = F,
               editable = F)
    } else {
      plot_ly(data_telecare_cah_age_plot(),
              x = ~percentage,
              y = ~age_group,
              type = "bar",
              name = ~cah_status,
              color = ~cah_status,
              colors = stacked_bar_pal,    # customised color selection, see global.R script for stacked_bar_pal specifications
              
              #### Add tooltip to plot
              hoverinfo = "text",
              hovertext = ~ paste(cah_status,
                                  "<br>",
                                  "Financial Year: ", input$tec_cah_age_financial_year_input,
                                  "<br>",
                                  "Location:", input$tec_cah_age_location_input,
                                  "<br>",
                                  "Age:", age_group,
                                  "<br>",
                                  "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
                                  "<br>",
                                  "Percentage of People:", formatC(percentage, format = "f", digits = 1),"%",
                                  "<br>")) %>%
        layout(
          title = paste0("<b> Percentage of People with Community Alarms and/or Telecare <br> who also receive Care at Home by Age Group in <br>",
                         input$tec_cah_age_location_input, ", ", input$tec_cah_age_financial_year_input, "."),
          xaxis = list(title = "Percentage of People", ### X AXIS
                       showline = TRUE,
                       ticks = "outside",
                       ticksuffix = "%",
                       rangemode = "tozero"),
          yaxis = list(title = paste0(c(rep("&nbsp;", 30), ### Y AXIS 
                                        "Age Group",
                                        rep("&nbsp;", 30),
                                        rep("\n&nbsp;", 1)),
                                      collapse = ""),
                       showline = TRUE,
                       ticks = "outside",
                       tickangle = 0,
                       categoryorder = "array",
                       # set the order age groups should appear in
                       categoryarray = c("All Ages", "85+ years", "75-84 years", "65-74 years",  "18-64 years", "0-17 years")),
          margin = list(l = 10, r = 10, b = 10, t = 100),
          barmode = 'stack',
          legend = list(x = 0, y = -0.4,  ## legend
                        font = list(size = 14))) %>%
        config(displayModeBar = TRUE,
               modeBarButtonsToRemove = buttons_to_remove,
               displaylogo = F,
               editable = F)
    }
  }) # end of render plotly
  
  
  ## CARE AT HOME BY AGE - TABLE ----
  
  data_tec_cah_age_table <- reactive({
    data_telecare_cah_age_plot() %>%
      select(financial_year,
             sending_location,
             age_group,
             cah_status,
             nclient,
             percentage) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$tec_cah_age_showhide, {
    toggle("tec_cah_age_table")
    output$tec_cah_age_table_output <- DT::renderDataTable(
      DT::datatable(data_tec_cah_age_table(),
                    style = "bootstrap",
                    class = "table-bordered table-condensed",
                    rownames = FALSE,
                    colnames = c("Financial Year",
                                 "Location",
                                 "Age Group",
                                 "Care at Home Status",
                                 "Number of People",
                                 "Percentage (%)"),
                    options = list(pageLength = 16,
                                   autoWidth = TRUE,
                                   dom = "tip",
                                   bPaginate = FALSE,    
                                   bInfo = FALSE)
      )# end of datatable
    ) # end of render data table
  }) # end of observe event
  
  ## CARE AT HOME BY AGE - DOWNLOAD DATA ----
  
  output$download_tec_cah_age_data <- downloadHandler(
    filename = "technology_enabled_care_cah_age.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_cah %>%
                    select(financial_year, sending_location, age_group, cah_status, nclient, percentage),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Care at Home Status",
                                "Number of People",
                                "Percentage of People"),
                  sep = ",")
    }) # end of download handler
  
  ##########################################-
  #### DEPRIVATION  -----
  ##########################################-
  
  ## DEPRIVATION DATA ----
  
  data_tec_simd_plot <- reactive({
    data_tech_enabled_care_deprivation %>%
      filter(
        financial_year   == input$tec_simd_financial_year_input,
        sending_location == input$tec_simd_location_input,
        age_group        == input$tec_simd_age_input,
        measure          == input$tec_simd_measure_input,
        simd != "Unknown")
  })
  
  ## DEPRIVATION PLOT ----
  
  output$tec_simd_plot <- renderPlotly({
    
    if (nrow(data_tech_enabled_care_deprivation[data_tech_enabled_care_deprivation$financial_year == input$tec_simd_financial_year_input &
                                                data_tech_enabled_care_deprivation$sending_location  == input$tec_simd_location_input &
                                                data_tech_enabled_care_deprivation$age_group == input$tec_simd_age_input &
                                                data_tech_enabled_care_deprivation$measure == input$tec_simd_measure_input , ]) == 0){
      
      text_tec_simd <- list(x = 5,
                            y = 2,
                            font = list(color = "red", size = 16),
                            text = paste(input$tec_simd_location_input, 
                                         "were unable to provide Technology Enabled Care Deprivation data for ", 
                                         "<br>", input$tec_simd_financial_year_input, "for", input$tec_simd_age_input,
                                         "and cannot be plotted."),
                            xref = "x",
                            yref = "y",
                            showarrow = FALSE)
      
      ## create a blank plot, including the error text
      plot_ly() %>%
        layout(annotations = text_tec_simd,
               yaxis = list(showline = FALSE,
                            showticklabels = FALSE,
                            showgrid = FALSE),
               xaxis = list(showline = FALSE,
                            showticklabels = FALSE,
                            showgrid = FALSE)) %>%
        config(displayModeBar = FALSE,
               displaylogo = F,
               editable = F)
    } else {
      
      
      plot_ly(data_tec_simd_plot(),
              x = ~simd,
              y = ~value,
              type = "bar",
              marker = phs_bar_col,
              #### Add tooltip to plot
              hoverinfo = "text",
              hovertext = ~ paste("Scottish Index of Multiple Deprivation (SIMD):", simd,
                                  "<br>",
                                  "Financial Year: ", input$tec_simd_financial_year_input,
                                  "<br>",
                                  "Location:", input$tec_simd_location_input,
                                  "<br>",
                                  "Age Group:", input$tec_simd_age_input,
                                  "<br>",
                                  input$tec_simd_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
      ) %>% # end of plotly
        layout(
          title = paste0("<b> ", input$tec_simd_measure_input, " with Community Alarms and/or Telecare, <br>", 
                         input$tec_simd_age_input, ", by Deprivation Category in ", 
                         input$tec_simd_location_input, ", ", input$tec_simd_financial_year_input, "."),
          yaxis = list(title = if_else(input$tec_simd_measure_input == "SIMD Quintile Proportion",   ### Y AXIS
                                       paste0(c(rep("&nbsp;", 30),
                                                input$tec_simd_measure_input, " %",
                                                rep("&nbsp;", 30),
                                                rep("\n&nbsp;", 1)),
                                              collapse = ""),
                                       paste0(c(rep("&nbsp;", 30),
                                                input$tec_simd_measure_input,
                                                rep("&nbsp;", 30),
                                                rep("\n&nbsp;", 1)),
                                              collapse = "")),
                       showline = TRUE,
                       ticks = "outside",
                       rangemode = "tozero",
                       separators = ",",
                       exponentformat = "none",
                       separatethousands = TRUE),
          xaxis = list(title = "SIMD Deprivation Category",### X AXIS 
                       showline = TRUE,
                       ticks = "outside",
                       tickangle = 0),
          margin = list(l = 10, r = 10, b = 10, t = 100),
          barmode = 'stack',
          legend = list(x = 0, y = -0.8,  ## legend
                        font = list(size = 14))
        ) %>% # end of layout
        config(displayModeBar = TRUE,
               modeBarButtonsToRemove = buttons_to_remove,
               displaylogo = F,
               #collaborate = F,
               editable = F)
    }
  }) # end of render plotly
  
  
  ## DEPRIVATION TABLE ----
  
  data_tec_simd_table <- reactive({
    data_tec_simd_plot() %>%
      select(financial_year,
             sending_location,
             age_group,
             simd,
             value) %>%
      mutate(value = format(round(value, 1), big.mark = ","))
  })
  
  observeEvent(input$tec_simd_showhide, {
    toggle("tec_simd_table")
    output$tec_simd_table_output <- DT::renderDataTable(
      DT::datatable(data_tec_simd_table(),
                    style = "bootstrap",
                    class = "table-bordered table-condensed",
                    rownames = FALSE,
                    colnames = c("Financial Year",
                                 "Location",
                                 "Age Group",
                                 "SIMD",
                                 input$tec_simd_measure_input),
                    options = list(pageLength = 16,
                                   autoWidth = TRUE,
                                   dom = "tip",
                                   bPaginate = FALSE,
                                   bInfo = FALSE)
      ) # end of datatable
    ) # end of render datatable
  }) # end of observe event
  
  ## DEPRIVATION DOWNLOAD DATA ----
  output$download_tec_simd_data <- downloadHandler(
    filename = "technology_enabled_care_deprivation.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_deprivation, 
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "SIMD",
                                "Measure",
                                "Value"),
                  sep = ",")
    }) # end of download handler
  
  
  ###################################################.
  
  ####  end server bracket ----
  
}