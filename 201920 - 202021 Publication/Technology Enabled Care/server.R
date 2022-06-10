#####################################################
## Technology Enabled Care Server Script ##
#####################################################




## code to password protect app - comment out if not required ##

## read in server credentials code from admin/create_credendentials.R ##
#credentials <- readRDS("admin/credentials.rds")  
################################################


### Server ----

server <- function(input, output, session) {
  
  
  # shiny manager code required for password protection 
  #########################
  ## SHINY MANAGER ##
  #########################
  #library(shinymanager)
  #res_auth <- shinymanager::secure_server(
  #  check_credentials = check_credentials(credentials)
  #)
  
  #output$auth_output <- renderPrint({
  #  reactiveValuesToList(res_auth)
  #})
  ################################################
  
  
  #########################
  ## INFORMATION
  #########################
  
  ## data completeness table ----
  
  output$data_completeness_table <-  DT::renderDataTable(
    DT::datatable(data_completeness_table,
                  style = "bootstrap",
                  class = "table-bordered table-condensed",
                  rownames = FALSE,
                  options = list(
                    pageLength = 16,
                    autoWidth = TRUE,
                    #dom = "tip",
                    bPaginate = FALSE,
                    bInfo = FALSE
                  )
    ))
  
  
  
  #########################################
  ####  Community Alarms/Telecare Trend ----
  #########################################
  
  ## Apply user filter choices to trend data set ----
  
  
  data_tech_enabled_care_trend_plot <- reactive({
    data_tech_enabled_care_trend %>%
      filter(
        sending_location == input$tec_trend_location_input,
        service          == input$tec_trend_service_input,
        measure          == input$tec_trend_measure_input
      )
  })
  
  ## Data for location comparison
  
  data_tech_enabled_care_trend_comparison_plot <- reactive({
    data_tech_enabled_care_trend %>%
      filter(
                sending_location == input$tec_trend_location_comparison_input,
                service          == input$tec_trend_service_input,
                measure          == input$tec_trend_measure_input)
  })

  ## Create trend plot (using filtered data) ----
  
  output$tec_trend_plot <- renderPlotly({
    plot_ly(data_tech_enabled_care_trend_plot(),
            x = ~financial_year,
            y = ~value,
            type = "scatter",                    # creates scatterplot
            mode = "lines+markers",                      # creates line graph 
            line = trend_line_setting,
            marker = trend_marker_setting,
            name = paste(input$tec_trend_measure_input, input$CAT_location_input),
          
            
            ## Add tooltop information (text to appear when cursor hovers over a data point in the plot)
            
            hoverinfo = "text",
            text = ~ paste(
              "Service received:", input$tec_trend_service_input,
              "<br>", 
              "Location:", sending_location,
              "<br>",
              "Financial Year:", financial_year,
              "<br>",
              "Age Group:", age_group,
              "<br>",
              input$tec_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
            )) %>% 
          
      
            ## Add location Comparison line 
            
            add_trace(
                      name = paste(input$tec_trend_measure_input, input$tec_trend_location_comparison_input),
                      data = data_tech_enabled_care_trend_comparison_plot(),
                      x = ~financial_year,
                      y = ~value,
                      type = "scatter",
                      mode = "lines+markers",
                      line = comparison_trend_line_setting, # black dashed line
                      marker = comparison_trend_marker_setting,
                      
                      # Add tooltip for location comparison line
                      
                      hoverinfo = "text",
                      text = ~ paste(
                        "Service received:", input$tec_trend_service_input,
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
                mode = "line",
                color = reference_line_style,
                x = "2019/20",
                y = ~c(0:max(value)),
                hoverinfo = "text",
                text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                inherit = FALSE) %>%

      ## Specify plot layout, titles and axis settings
      
      layout(
        
        ## Y axis specifications 
        yaxis = list(
          rangemode = "tozero",
          title = paste0(c(
            rep("&nbsp;", 30),
            input$tec_trend_measure_input,
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          showline = TRUE,
          exponentformat = "none",
          separatethousands = TRUE,
          ticks = "outside"
        ),
        
        ## X axis specifications
        
        xaxis = list(
          title = "Financial Year",
          showline = TRUE,
          ticks = "outside",
          showgrid = FALSE
        ),
        
        margin = list(l = 50, r = 10, b = 60, t = 150),
      
        ## legend
        
        legend = list(
          x = 0, y = -0.9,
          font = list(size = 14)
        ),

        ### Plot title 

        title = 
          if_else(input$tec_trend_location_input == input$tec_trend_location_comparison_input, 
                  paste0("<b>", input$tec_trend_measure_input, " with ", input$tec_trend_service_input, ", <br>",
                         input$tec_trend_location_input, ", 2015/16 - 2020/21."),
                  paste0("<b>", input$tec_trend_measure_input, " with ", input$tec_trend_service_input, ", <br>",
                         input$tec_trend_location_input, " and ", input$tec_trend_location_comparison_input,
                         ",  <br> 2015/16 - 2020/21."))
        
        
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
     
    
  })
  
  ## Show / Hide Trend data table button ----
  
  ## data for the table 
  
  data_tec_trend_table <- reactive({
    if(input$tec_trend_location_input == input$tec_trend_location_comparison_input){
      data_tech_enabled_care_trend_plot() %>%
        select(financial_year, sending_location, service, age_group, value) %>%
        mutate(
          value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    } else{
      rbind(data_tech_enabled_care_trend_plot(),data_tech_enabled_care_trend_comparison_plot()) %>%
        select(financial_year, sending_location, service, age_group, measure, value) %>%
        mutate(
          value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    }
  })
  
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
                                   input$tec_trend_measure_input
                                   ),
                      options = list(
                        pageLength = 16,
                        autoWidth = TRUE,
                        dom = "tip",
                        bPaginate = FALSE,
                        bInfo = FALSE
                        )
    ) )
    

  })
  
  
  ## Trend data file download ----
  
  output$download_tec_trend_data <- downloadHandler(
    filename = "technology_enabled_care_trend.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_trend %>% 
                    select(financial_year, sending_location, age_group, service, measure, value),
                   file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Service",
                    "Measure",
                    "Value"
                  ),
                  sep = ","
      )
    }
  )
  
  
  #############################################
  ####  Community Alarms/Telecare Summary ----
  #############################################
  
  ## Apply user filter choices to tech_enabled_care summary data ----
  
  data_tech_enabled_care_summary_plot <- reactive({
    data_tech_enabled_care_summary %>%
      filter(
        financial_year == input$tec_summary_year_input,
        age_group      == input$tec_summary_age_input,
        service        == input$tec_summary_service_input,
        measure        == input$tec_summary_measure_input,
        
        # remove values equal to 0 to avoid plotting these locations
        value != 0
      )
  })
  
  ## Create tech_enabled_care summary plot (using filtered data) ----
  
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
            text = ~ paste(
              "Financial Year: ", financial_year,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", input$tec_summary_age_input,
              "<br>",
              "Service:",input$tec_summary_service_input,
              "<br>",
              input$tec_summary_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      
      ### Add Scotland reference line
      
        add_trace(
       color = reference_line_style,  # scotland reference line colour set in global.R script
       name = "Scotland (All Areas Submitted)",
       y = ~sending_location,
       x = ~scotland_value,
       type = "scatter",
       mode = "line",
       hoverinfo = "text",
       text = ~ paste(
         "Financial Year: ", financial_year,
         "<br>",
         "Location: Scotland (All Areas Submitted)",
         "<br>",
         "Age Group:", input$tec_summary_age_input,
         "<br>",
         "Service:",input$tec_summary_service_input,
         "<br>",
         input$tec_summary_measure_input,":", formatC(scotland_value, format = "f", big.mark = ",", drop0trailing = TRUE)
      ),
      inherit = FALSE,
      showlegend = TRUE
      ) %>%
    
    
       layout(

        ### Plot title

        
         title = paste0(
           "<b>", input$tec_summary_measure_input, ", ", input$tec_summary_age_input, " with ", input$tec_summary_service_input,
           "<br> by Health and Social Care Partnership, ", input$tec_summary_year_input, "."
       ),
           
        # X AXIS
        
        xaxis = list(
          title = paste(input$tec_summary_measure_input),
          separatethousands = TRUE,
          rangemode = "tozero",
          exponentformat = "none",
          #titlefont = f2,
          showline = TRUE,
          ticks = "outsde"
        ),
        
        # Y AXIS 
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health and Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          categoryorder = "total ascending",
          categoryarray = ~value,
          showline = TRUE,
          ticks = "outside",
          tickangle = 0
        ),
       
       margin = list(l = 15, r = 10, b = 30, t = 110),
      
        ## legend
        
        legend = list(
          x = 0, y = -0.3,
          font = list(size = 14)
        )
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
    
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
            text = ~ paste(
              "Financial Year: ", financial_year,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", input$tec_summary_age_input,
              "<br>",
              "Service:",input$tec_summary_service_input,
              "<br>",
              input$tec_summary_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      
      
      
      layout(
        
        ### Plot title
        
        title = paste0(
          "<b>", input$tec_summary_measure_input, ", ", input$tec_summary_age_input, " with ", input$tec_summary_service_input,
          "<br> by Health and Social Care Partnership, ", input$tec_summary_year_input, "."
        ),
        
        # X AXIS
        
        xaxis = list(
          title = paste(input$tec_summary_measure_input),
          separatethousands = TRUE,
          rangemode = "tozero",
          exponentformat = "none",
          showline = TRUE,
          ticks = "outsde"
        ),
        
        # Y AXIS 
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health and Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          categoryorder = "total ascending",
          categoryarray = ~value,
          showline = TRUE,
          ticks = "outside",
          tickangle = 0
        ),
        margin = list(l = 15, r = 10, b = 30, t = 110),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.3,
          font = list(size = 14)
        )
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  }
  })
  
  
  ## Show / Hide tech_enabled_care Summary data table button ----
  
  
  data_tec_summary_table <- reactive({
    data_tech_enabled_care_summary_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        service,
        value
      ) %>%
      mutate(value = format(value, big.mark = ","))
  })
  
  observeEvent(input$tec_summary_show_table, {
    toggle("tec_summary_table")
    output$tec_summary_table_output <- DT::renderDataTable(DT::datatable(
      data_tec_summary_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "Age Group",
        "Service",
        input$tec_summary_measure_input
        ),
      ptions = list(
        pageLength = 16,
        autoWidth = TRUE,
        dom = "tip",
        bPaginate = FALSE,
        bInfo = FALSE
        )
    ))
  })
  
  ## tech_enabled_care Summary data file download ----
  
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
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Service",
                    "Measure",
                    "Value"
                    
                  ),
                  sep = ","
      )
    }
  )
 
  
  ##########################################
  ####  Technology Enabled Care and Living Alone Summary -----
  ##########################################
  
  ## filter data 
  
  data_telecare_living_alone_filtered <- reactive({
    data_tech_enabled_care_living_alone %>%
      filter(
        financial_year == input$tec_living_alone_financial_year_input,
        age_group      == input$tec_living_alone_age_input,
        service        ==  input$tec_living_alone_service_input,
        la_status_nclient != 0
      )
  })
  
  ## create plot ----
  
  output$tec_living_alone_plot <- renderPlotly({
    plot_ly(data_telecare_living_alone_filtered() %>%
              filter(sending_location != "Scotland"),
            y = ~sending_location,
            x = ~propn_la_status_nclient,
            type = "bar",
            name = ~living_alone_status,
            color = ~living_alone_status,
            colors = four_col_pal,
            
            #### Add tooltip to plot
            hoverinfo = "text",
            text = ~ paste(
              "Living Alone Status:", living_alone_status,
              "<br>",
              "Financial Year: ", input$tec_living_alone_financial_year_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Service:", service,
              "<br>",
              "Age Group:", input$tec_living_alone_age_input,
              "<br>",
              "Number of People:", formatC(la_status_nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Percentage of People:", formatC(propn_la_status_nclient, format = "f", digits = 1), "%",
              "<br>"
            )
    ) %>%
      layout(
        title = paste0("<b> Percentage of People, ", input$tec_living_alone_age_input, 
                       ", with Living Arrangement <br> and Health and Social Care Partnership, ", 
                       input$tec_living_alone_financial_year_input, "."),
        
        ### X AXIS
        
        xaxis = list(
          title = "Percentage of People",
          showline = TRUE,
          ticks = "outside",
          nticks = 6,
          ticksuffix = "%",
          rangemode = "tozero"
        ),
        
        ### Y AXIS
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health and Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          showline = TRUE,
          autorange = "reversed",
          categoryorder = "trace",
          ticks = "outside",
          tickangle = 0
        ),
        margin = list(l = 10, r = 10, b = 30, t = 100),
        barmode = 'stack',
        
        ## legend
        
        legend = list(
          x = 0, y = -0.3,
          font = list(size = 14),
          traceorder = "normal"
        )
        
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  
  ## show hide table ----
  
  data_tec_living_alone_table <- reactive({
    data_telecare_living_alone_filtered() %>%
      filter(sending_location != "Scotland") %>%
      select(
        financial_year,
        sending_location,
        age_group,
        service,
        living_alone_status,
        la_status_nclient,
        propn_la_status_nclient
      ) %>%
      mutate(la_status_nclient = format(la_status_nclient, big.mark = ","),
             propn_la_status_nclient = format(propn_la_status_nclient, big.mark = ","))
  })
  
  observeEvent(input$tec_living_alone_showhide, {
    toggle("tec_living_alone_table")
    output$tec_living_alone_table_output <- DT::renderDataTable(DT::datatable(
        data_tec_living_alone_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c(
          "Financial Year",
          "Location",
          "Age Group",
          "Service",
          "Living Alone Status",
          "Number of People",
          "Percentage (%)"
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
  
  ## download data ----
  
  output$download_tec_living_alone_data <- downloadHandler(
    filename = "technology_enabled_care_living_alone.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_living_alone %>%
                    filter(sending_location != "Scotland") %>%
                    select(financial_year, sending_location, age_group, service, living_alone_status, la_status_nclient, propn_la_status_nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Service",
                    "Living Arrangement",
                    "Number of People",
                    "Percentage"
                  ),
                  sep = ","
      )
    }
  )

  
  
  
  ##########################################
  ####  tech_enabled_care and Homecare Summary -----
  ##########################################
  
  ## filter data ----
  
  data_telecare_home_care_plot <- reactive({
    data_tech_enabled_care_home_care %>%
      filter(
        financial_year != "2017/18",
        financial_year == input$tec_hc_financial_year_input,
        age_group == input$tec_hc_age_input
        #hc_status_nclient != 0
      )
  })
  
  ## plot data ----
  
  output$tec_hc_plot <- renderPlotly({
    plot_ly(data_telecare_home_care_plot(), 
            y = ~sending_location,
            x = ~prop_hc_status_nclient,
            type = "bar",
            name = ~hc_status,
            color = ~hc_status,
            colors = stacked_bar_pal,    # customised color selection, see global.R script for stacked_bar_pal specifications
        
            #### Add tooltip to plot
            hoverinfo = "text",
            text = ~ paste(
              hc_status,
              "<br>",
              "Financial Year: ", input$tec_hc_financial_year_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age:", input$tec_hc_age_input,
              "<br>",
              "Number of People:", formatC(hc_status_nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Percentage of People:", formatC(prop_hc_status_nclient, format = "f", digits = 1),"%",
              "<br>"
            )
    ) %>%
      layout(

        title = paste0("<b> Percentage of People, ", input$tec_hc_age_input, 
                       ", with Community Alarms and/ or Telecare <br> who also receive Home Care by Health and Social Care Partnership, ",
                       input$tec_hc_financial_year_input, "."),
        

        ### X AXIS
        
        xaxis = list(
          title = list(text = "Percentage of People", standoff = 10L),
          showline = TRUE,
          ticks = "outside",
          ticksuffix = "%",
          rangemode = "tozero"
        ),
        
        
        ### Y AXIS 
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Health and Social Care Partnership",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          
          showline = TRUE,
          ticks = "outside",
          tickangle = 0,
          autorange = "reversed",
          categoryorder = "trace"
        ),
       
        margin = list(l = 10, r = 10, b = 90, t = 110),
        
        barmode = 'stack',
        
        
        ## legend
        
        legend = list(
          x = 0, y = -0.2,
          font = list(size = 14),
          traceorder = "normal"
        )
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  
  ## show / hide data table ----
  
  data_tec_hc_table <- reactive({
    data_telecare_home_care_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        hc_status,
        hc_status_nclient,
        prop_hc_status_nclient
      ) %>%
      mutate(hc_status_nclient = format(hc_status_nclient, big.mark = ","),
             prop_hc_status_nclient = format(prop_hc_status_nclient, big.mark = ","))
  })
  
  observeEvent(input$tec_hc_showhide, {
    toggle("tec_hc_table")
    output$tec_hc_table_output <- DT::renderDataTable(DT::datatable(
                                    data_tec_hc_table(),
                                    style = "bootstrap",
                                    class = "table-bordered table-condensed",
                                    rownames = FALSE,
                                    colnames = c(
                                      "Financial Year", 
                                      "Location",
                                      "Age Group",
                                      "Home Care Status",
                                      "Number of People",
                                      "Percentage (%)"
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
  
  ## download data ----
  
  output$download_tec_hc_data <- downloadHandler(
    filename = "technology_enabled_care_home_care.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_home_care %>%
                    select(financial_year, sending_location, age_group, hc_status, hc_status_nclient, prop_hc_status_nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Home Care Status",
                    "Number of People",
                    "Percentage"
                  ),
                  sep = ","
      )
    }
  )
  
  
  ##########################################
  ####  tech_enabled_care and Homecare by Age - TEST TAB 2021 -----
  ##########################################
  
  ## filter data ----
  
  data_telecare_home_care_age_plot <- reactive({
    data_tech_enabled_care_home_care %>%
      filter(
        financial_year == input$tec_hc_age_financial_year_input,
        sending_location == input$tec_hc_age_location_input
      )
  })
  
  ## plot data ----
  
  output$tec_hc_age_plot <- renderPlotly({
    
    if (nrow(data_tech_enabled_care_home_care[data_tech_enabled_care_home_care$financial_year == input$tec_hc_age_financial_year_input &
                                              data_tech_enabled_care_home_care$sending_location  == input$tec_hc_age_location_input , ]) == 0){
      
      text_locality_homecare <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$tec_hc_age_location_input, 
                     "HSCP were unable to provide data for the proportion of people <br> supported by community alarms and or telecare services who also received support <br> through a home care service for",
                     input$tec_hc_age_financial_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
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
          displaylogo = F,
          editable = F
        )
    } else {
      plot_ly(data_telecare_home_care_age_plot(),
            x = ~prop_hc_status_nclient,
            y = ~age_group,
            type = "bar",
            name = ~hc_status,
            color = ~hc_status,
            colors = stacked_bar_pal,    # customised color selection, see global.R script for stacked_bar_pal specifications
            
            #### Add tooltip to plot
            hoverinfo = "text",
            text = ~ paste(
              hc_status,
              "<br>",
              "Financial Year: ", input$tec_hc_age_financial_year_input,
              "<br>",
              "Location:", input$tec_hc_age_location_input,
              "<br>",
              "Age:", age_group,
              "<br>",
              "Number of People:", formatC(hc_status_nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Percentage of People:", formatC(prop_hc_status_nclient, format = "f", digits = 1),"%",
              "<br>"
            )
    ) %>%
      layout(
        
        title = paste0("<b> Percentage of People with Community alarms and/ or Telecare <br> who also receive Home Care by Age Group in ",
                       input$tec_hc_age_location_input, ", ", input$tec_hc_age_financial_year_input, "."),
          
        ### X AXIS
        
        xaxis = list(
          title = "Percentage of People",
          showline = TRUE,
          ticks = "outside",
          ticksuffix = "%",
          rangemode = "tozero"
        ),
        
        
        ### Y AXIS 
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Age Group",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          
          showline = TRUE,
          ticks = "outside",
          tickangle = 0,
          categoryorder = "array",
          # set the order age groups should appear in
          categoryarray = c(
            "All Ages", "85+ years", "75-84 years", "65-74 years",  "18-64 years", "0-17 years")
        ),
        
        margin = list(l = 10, r = 10, b = 10, t = 100),
       
        barmode = 'stack',
        
        ## legend
        
        legend = list(
          x = 0, y = -0.4,
          font = list(size = 14)
        )
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        
        editable = F
      )
    }
  })
  
 
  ## show / hide data table ----
  
  data_tec_hc_age_table <- reactive({
    data_telecare_home_care_age_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        hc_status,
        hc_status_nclient,
        prop_hc_status_nclient
      ) %>%
      mutate(hc_status_nclient = format(hc_status_nclient, big.mark = ","),
             prop_hc_status_nclient = format(prop_hc_status_nclient, big.mark = ","))
  })
  
  observeEvent(input$tec_hc_age_showhide, {
    toggle("tec_hc_age_table")
    output$tec_hc_age_table_output <- DT::renderDataTable(
      DT::datatable(
        data_tec_hc_age_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c(
          "Financial Year",
          "Location",                      
          "Age Group",
          "Home Care Status",
          "Number of People",
          "Percentage (%)"
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
  
  ## download data ----
  
  output$download_tec_hc_age_data <- downloadHandler(
    filename = "technology_enabled_care_home_care_age.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_home_care %>%
                    select(financial_year, sending_location, age_group, hc_status, hc_status_nclient, prop_hc_status_nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Home Care Status",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )
  
  ##########################################
  ####  Technology Enabled Care and Deprivation (SIMD) -----
  ##########################################
  
  ## filter data including unknowns ----
  
  data_tec_simd_plot <- reactive({
    data_tech_enabled_care_deprivation %>%
      filter(
        #financial_year != "2017/18",
        financial_year   == input$tec_simd_financial_year_input,
        sending_location == input$tec_simd_location_input,
        
        age_group        == input$tec_simd_age_input,
        measure          == input$tec_simd_measure_input,
        simd != "Unknown"
      )
  })
  
  ## plot data ----
  
  output$tec_simd_plot <- renderPlotly({
    plot_ly(data_tec_simd_plot(),
            x = ~simd,
            y = ~value,
            type = "bar",
            marker = phs_bar_col,
            
            #### Add tooltip to plot
            hoverinfo = "text",
            text = ~ paste(
              "Scottish Index of Multiple Deprivation (SIMD):", simd,
              "<br>",
              "Financial Year: ", input$tec_simd_financial_year_input,
              "<br>",
              "Location:", input$tec_simd_location_input,
              "<br>",
              "Age Group:", input$tec_simd_age_input,
              "<br>",
              input$tec_simd_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    ) %>%
      layout(
        
        title = paste0("<b>", input$tec_simd_measure_input, ", ", input$tec_simd_age_input, 
                       ", with Community Alarms and/ or Telecare <br> by Deprivation Category and ", 
                       input$tec_simd_location_input, ", ", input$tec_simd_financial_year_input, "."),
        
        
        ### Y AXIS
        
        yaxis = list(
          title = if_else(input$tec_simd_measure_input == "SIMD Quintile Proportion", 
                          paste0(c(
                            rep("&nbsp;", 30),
                            input$tec_simd_measure_input, " %",
                            rep("&nbsp;", 30),
                            rep("\n&nbsp;", 1)
                          ),
                          collapse = ""
                          ),
                          paste0(c(
                            rep("&nbsp;", 30),
                            input$tec_simd_measure_input,
                            rep("&nbsp;", 30),
                            rep("\n&nbsp;", 1)
                          ),
                          collapse = ""
                          )),
          
          showline = TRUE,
          ticks = "outside",
          rangemode = "tozero",
          separators = ",",
          exponentformat = "none",
          separatethousands = TRUE
          ),
        
        
        ### X AXIS 
        
        xaxis = list(
          title = "SIMD Deprivation Category",
          
          showline = TRUE,
          ticks = "outside",
          tickangle = 0
        ),
        
        margin = list(l = 10, r = 10, b = 10, t = 100),
       
        barmode = 'stack',
        
        
        ## legend
        
        legend = list(
          x = 0, y = -0.8,
          font = list(size = 14)
        )
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        #collaborate = F,
        editable = F
      )
  })
  
  
  ## show / hide data table ----
  
  data_tec_simd_table <- reactive({
    data_tec_simd_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        simd,
        value
      ) %>%
      mutate(value = format(round(value, 1), big.mark = ","))
  })
  
  observeEvent(input$tec_simd_showhide, {
    toggle("tec_simd_table")
    output$tec_simd_table_output <- DT::renderDataTable(
      DT::datatable(
        data_tec_simd_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c(
          "Financial Year",
          "Location",
          "Age Group",
          "SIMD",
          input$tec_simd_measure_input
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
  
  ## download data ----
  
  output$download_tec_simd_data <- downloadHandler(
    filename = "technology_enabled_care_deprivation.csv",
    content = function(file) {
      write.table(data_tech_enabled_care_deprivation, 
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "SIMD",
                    "Measure",
                    "Value"
                  ),
                  sep = ","
      )
    }
  )
  
  
  #################################################
  ### Information tab ----
  #################################################
  
  ## data completeness table ----
  
  output$data_completeness_table <-  DT::renderDataTable(
                                       DT::datatable(data_completeness_table,
                                                     style = "bootstrap",
                                                     class = "table-bordered table-condensed",
                                                     rownames = FALSE,
                                                    options = list(
                                                       pageLength = 16,
                                                       autoWidth = TRUE,
                                                       #dom = "tip",
                                                       bPaginate = FALSE,
                                                       bInfo = FALSE
                                                     )
                                                    ))
  
  ##################################################
  
  ####  end server bracket ----
   
}