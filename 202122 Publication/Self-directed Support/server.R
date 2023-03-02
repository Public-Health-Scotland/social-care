#########################################-
## SELF-DIRECTED SUPPORT SERVER SCRIPT ##-
#########################################-


################################################-
## code to password protect app - comment out if not required ##
## read in server credentials code from admin/create_credentials.R ##
#credentials <- readRDS("admin/credentials.rds")  
################################################-



### SERVER ----

server <- function(input, output, session) {
  
  
  # shiny manager code required for password protection 
  #########################-
  ## SHINY MANAGER ##
  #########################-
  # library(shinymanager)
  # res_auth <- shinymanager::secure_server(
  #   check_credentials = check_credentials(credentials)
  # )
  # 
  # output$auth_output <- renderPrint({
  #   reactiveValuesToList(res_auth)
  # })
  ################################################-
  
  
  
  
  
  ##########################-
  ## DATA COMPLETENESS TABLE ----
  ##########################-
  
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
                  options = list(
                    pageLength = 16,
                    autoWidth = TRUE,
                    #dom = "tip",
                    bPaginate = FALSE,
                    bInfo = FALSE
                  )
    ))
  
  ##########################-
  ## DATA QUALITY TABLE ----
  ##########################-
  
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
                  options = list(
                    pageLength = 16,
                    autoWidth = TRUE,
                    #dom = "tip",
                    bPaginate = FALSE,
                    bInfo = FALSE
                  )
    ))
  
  
  #########################-
  ## TREND ----
  #########################-
  
  ## DATA ----
  
  data_sds_trend_plot <- reactive({
    data_sds_trend %>%
      filter(option_type      == input$sds_trend_option_input,
             sending_location == input$sds_trend_location_input)
  })
  
  data_sds_trend_comparator <- reactive({
    data_sds_trend %>%
      filter(option_type      == input$sds_trend_option_input,
             sending_location == input$sds_trend_location_comparator_input)
  })
  
  ## PLOT -----
  
  output$sds_trend_plot <- renderPlotly({
    plot_ly(data_sds_trend_plot(),
            x = ~financial_year,
            y = ~rate,
            type = "scatter",
            mode = "lines+markers",           # to add markers back in change to "lines+markers"
            name = paste("Rate per 1,000 People in",input$sds_trend_location_input),
            line = trend_line_setting,            # see global.R script to update this
            marker = trend_marker_setting,
            
            
            ### Add tooltip to trend plot
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", financial_year,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Option Type:", option_type,
              "<br>",
              "Rate per 1,000 Population:", rate,
              "<br>",
              "Number of People:", formatC(nclient, 
                                           format = "f", 
                                           big.mark = ",", 
                                           drop0trailing = TRUE))
    ) %>%
      
      ## Add location Comparison line 
      
      add_trace(
        name = paste("Rate per 1,000 People in",input$sds_trend_location_comparator_input),
        data = data_sds_trend_comparator(),
        x = ~financial_year,
        y = ~rate, 
        type = "scatter",
        mode = "lines+markers",
        line = comparison_trend_line_setting, # update global.R to change this
        marker = comparison_trend_marker_setting,
        
        # Add tooltip for Comparator reference line
        
        hoverinfo = "text",
        text = ~ paste("Financial Year: ", financial_year,
                       "<br>",
                       "Location: ", input$sds_trend_location_comparator_input,
                       "<br>",
                       "Option Type:", option_type,
                       "<br>",
                       "Rate per 1,000 Population:", rate,
                       "<br>",
                       "Number of People:", formatC(nclient, 
                                                    format = "f", 
                                                    big.mark = ",", 
                                                    drop0trailing = TRUE)),
        inherit = FALSE,
        showlegend = TRUE) %>%
      
      ## add COVID-19 reference line
      
      add_trace(name = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                data = rbind(data_sds_trend_plot(), data_sds_trend_comparator()),
                type = "scatter",
                mode = "line",
                color = reference_line_style, 
                x = "2019/20",
                y = ~c(0,max(rate)),
                hoverinfo = "text",
                text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                inherit = FALSE) %>%
      
      ### Specify plot titles, axis and formatting
      
      layout(
        
        ## Y AXIS
        
        yaxis = list(rangemode = "tozero",
                     title = paste0(c(rep("&nbsp;", 30),
                                      "Rate per 1,00 Population",
                                      rep("&nbsp;", 30),
                                      rep("\n&nbsp;", 1)),
                                    collapse = ""),
                     separators = ',',
                     exponentformat = "none",
                     separatethousands = TRUE,
                     showline = TRUE,
                     ticks = "outside",
                     rangemode="tozero"),
        
        ## X AXIS
        
        xaxis = list(title = "Financial Year",
                     showline = TRUE,
                     ticks = "outside",
                     showgrid = FALSE),
        
        ### Plot title
        
        title = if_else(input$sds_trend_location_input == input$sds_trend_location_comparator_input,
                        
                        if_else(input$sds_trend_option_input != "Any SDS", 
                                
                                paste0("<b> Number of People as a Rate per 1,000 Population <br>",  
                                       " choosing Self-directed Support ", input$sds_trend_option_input,
                                       ", <br> in ", input$sds_trend_location_input, ", 2014/15 - 2021/22."),
                                
                                paste0("<b> Number of People as a Rate per 1,000 Population <br>",  
                                       " choosing Any Self-directed Support Option <br> in ", 
                                       input$sds_trend_location_input, ", 2017/18 - 2021/22.")
                        ),
                        
                        if_else(input$sds_trend_option_input != "Any SDS", 
                                
                                paste0("<b> Number of People as a Rate per 1,000 Population <br>",  
                                       " choosing Self-directed Support ", input$sds_trend_option_input,
                                       ", <br> in ", input$sds_trend_location_input, " and ",
                                       input$sds_trend_location_comparator_input, ", 2014/15 - 2021/22."),
                                
                                paste0("<b> Number of People as a Rate per 1,000 Population <br>",  
                                       " choosing Any Self-directed Support Option <br> in ",
                                       input$sds_trend_location_input, " and ",
                                       input$sds_trend_location_comparator_input, ", 2017/18 - 2021/22.")
                        )),
        
        
        ## legend
        
        legend = list(x = 0, y = -0.5,
                      font = list(size = 14)),
        margin = list(l = 30, r = 30, b = 0, t = 130)
        
      ) %>% # end layout
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
  })
  
  ## TABLE -----
  
  data_sds_trend_table <- reactive({
    
    if(input$sds_trend_location_input == input$sds_trend_location_comparator_input){
      data_sds_trend_plot()%>%
        select(financial_year, sending_location, option_type, rate, nclient) %>%
        mutate(
          nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))
    }else{
      rbind(data_sds_trend_plot(), data_sds_trend_comparator())%>%
        select(financial_year, sending_location, option_type, rate, nclient) %>%
        mutate(
          nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))
    }
    
    
  })
  
  observeEvent(input$sds_trend_showhide, {
    toggle("sds_trend_table")
    output$sds_trend_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_trend_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c("Financial Year",
                     "Location",
                     "Option Type",
                     "Rate per 1,000 People",
                     "Number of People"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      )
    )
  })
  
  ## DOWNLOAD DATA ----
  
  output$download_sds_trend_data <- downloadHandler(
    filename = "sds_trend.csv",
    content = function(file) {
      write.table(data_sds_trend %>%
                    select(financial_year, sending_location, option_type, rate, nclient),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Option Type",
                                "Rate per 1000 People",
                                "Number of People"),
                  sep = ",")
    }
  )
  
  #################################-
  ## OPTIONS CHOSEN ----
  ##################################-
  
  ## DATA -----
  
  data_sds_options_chosen_plot <- reactive({
    data_sds_options_chosen %>%
      filter(financial_year   == input$sds_options_chosen_year_input, 
             sending_location == input$sds_options_chosen_location_input,
             age_group        == input$sds_options_chosen_age_group)
  })
  
  
  
  ## PLOT ----
  
  output$sds_options_chosen_plot <- renderPlotly({
    
    # SHOW ERROR IF NO DATA
    if (nrow(data_sds_options_chosen[data_sds_options_chosen$financial_year == input$sds_options_chosen_year_input &
                                     data_sds_options_chosen$sending_location  == input$sds_options_chosen_location_input & 
                                     data_sds_options_chosen$age_group == input$sds_options_chosen_age_group , ]) == 0){
      
      
      text_sds_options_chosen <- list(
        x = 5,
        y = 2,
        font = list(color = "red", size = 16),
        text = paste(input$sds_options_chosen_location_input, 
                     "were unable to provide Self-directed Support data for ", 
                     "<br>", input$sds_options_chosen_year_input, "for", input$sds_options_chosen_age_group,
                     "and cannot be plotted."),
        xref = "x",
        yref = "y",
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_sds_options_chosen,
          
          yaxis = list(showline = FALSE,
                       showticklabels = FALSE,
                       showgrid = FALSE),
          
          xaxis = list(showline = FALSE,
                       showticklabels = FALSE,
                       showgrid = FALSE)
        ) %>%
        config(displayModeBar = FALSE,
               displaylogo = F,
               editable = F)
      
    } else {
      
      plot_ly(data_sds_options_chosen_plot(),
              x = ~ option_type,                                               
              y = ~ rate,
              type = "bar",
              marker = list(color = "rgb(67,57,132)"),                                          
              
              
              ## Add tooltip to plot 
              hoverinfo = "text",
              hovertext = ~ paste(
                "Financial Year:", input$sds_options_chosen_year_input,
                "<br>",
                "Location:", input$sds_options_chosen_location_input,
                "<br>",
                "Option Chosen:", option_type,
                "<br>",
                "Age Group:", input$sds_options_chosen_age_group,
                "<br>",
                "Rate per 1,000 People:", formatC(round(rate, 1), 
                                                  format = "f", 
                                                  big.mark = ",", 
                                                  drop0trailing = TRUE),
                "<br>",
                "Number of People:", formatC(nclient, 
                                             format = "f", 
                                             big.mark = ",", 
                                             drop0trailing = TRUE)
              )
      ) %>%
        layout(
          barmode = "stack",
          margin = list(l = 20, r = 20, b = 70, t = 120),
          
          # plot title
          title = paste0("<b> Number of People as a Rate per 1,000 Population  <br> by choice of Self-directed Support Option, <br>",
                         input$sds_options_chosen_age_group, ", in ", input$sds_options_chosen_location_input, ", ", input$sds_options_chosen_year_input, "."),
          
          
          # x axis
          xaxis = list(showline = TRUE,
                       ticks = "outside",
                       categoryorder = "category array",
                       categoryarray = c("Option 1", "Option 2", "Option 3", "Option 4", "Any SDS"),
                       title = "Self-directed Support Option"),
          # y axis 
          yaxis = list(showline = TRUE,
                       title = paste0(c(
                         rep("&nbsp;", 30),
                         "Rate per 1,000 People",
                         rep("&nbsp;", 30),
                         rep("\n&nbsp;", 1)
                       ),
                       collapse = ""
                       ),
                       exponentformat = "none",
                       separatethousands = TRUE,
                       ticks = "outside",
                       rangemode="tozero")
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    }
  })
  
  ## TABLE -----
  
  data_sds_options_chosen_table <- reactive({
    data_sds_options_chosen_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        option_type,
        rate,
        nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate    = format(round(rate, 1), big.mark = ","))
  })
  
  observeEvent(input$sds_options_chosen_showhide, {
    toggle("sds_options_chosen_table")
    output$sds_options_chosen_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_options_chosen_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c("Financial Year",
                     "Location",
                     "Age Group",
                     "Self-directed Support Option",
                     "Rate per 1,000 People",
                     "Number of People"
        ),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      )
    )
  })
  
  ## DOWNLOAD DATA ----
  
  output$download_sds_optionschosen <- downloadHandler(
    filename = "sds_options_chosen.csv",
    content = function(file) {
      write.table(data_sds_options_chosen %>% 
                    select(financial_year,
                           sending_location,
                           age_group,
                           option_type,
                           rate,
                           nclient) %>%
                    mutate(
                      rate = round(rate, 1),
                      nclient = formatC(nclient,
                                        format = "f",
                                        big.mark = ",",
                                        drop0trailing = TRUE)
                      
                    ),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Self-directed Support Option",
                                "Rate per 1,000 People",
                                "Number of People"),
                  sep = ",")
    }
  )
  #################################-
  ## IMPLEMENTATION RATE BY HSCP -----
  #################################-
  ## DATA -----
  
  data_sds_implementation_hscp_plot <- reactive({
    data_sds_implementation_hscp %>%
      filter(financial_year   == input$sds_implementation_hscp_year_input)
  })
  
  
  ## PLOT ----
  
  output$sds_implementation_hscp_plot <- renderPlotly({
    plot_ly(data_sds_implementation_hscp_plot() %>%
              filter(sending_location != "Scotland (Estimated)"),
            name = "Health and Social Care Partnership",
            x = ~implementation_rate,
            y = ~sending_location,
            type = "bar",
            marker = phs_bar_col, # phs bar chart marker colour set in global.R script
            
            ## Add tooltip to plot
            hoverinfo = "text",
            hovertext = ~ paste(
              "Financial Year:", input$sds_implementation_hscp_year_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Percentage of Implementation:", formatC(implementation_rate,
                                                       format = "f",
                                                       big.mark = ",",
                                                       drop0trailing = TRUE),
              "<br>",
              "Number of People going through SDS :", formatC(sdsclient,
                                                              format = "f",
                                                              big.mark = ",",
                                                              drop0trailing = TRUE))
    ) %>%
      
      ### Add Scotland reference line
      
      add_trace(
        color = reference_line_style,  # scotland reference line colour set in global.R script
        name = "Scotland (Estimated)",
        x = ~scotland_rate,
        y = ~sending_location,
        type = "scatter",
        mode = "lines",
        hoverinfo = "text",
        text = ~ paste0(
          "Financial Year: ", input$sds_implementation_hscp_year_input,
          "<br>",
          "Location: Scotland (Estimate)",
          "<br>",
          "Percentage of Implementation: ", formatC(scotland_rate, format = "f", big.mark = ",", drop0trailing = TRUE),
          "<br>",
          "Number of People going through SDS: ", formatC(sdsclient, format = "f", big.mark = ",", drop0trailing = TRUE)
        ),
        inherit = FALSE,
        showlegend = TRUE
        
      ) %>%
      
      layout(
        
        barmode = "stack",
        margin = list(l = 10, r = 10, b = 80, t = 80),
        legend = list(x = 0, y = -0.2,
                      font = list(size = 14)),
        
        # plot title
        title =  paste0("<b> Percentage of People who receive Social Care Services/Support through SDS, <br> by Health and Social Care Partnership, ", 
                        input$sds_implementation_hscp_year_input, "."),
        
        ## X AXIS
        xaxis = list(showline = TRUE,
                     title = "Percentage of Social Care Clients who have a choice",
                     exponentformat = "none",
                     separatethousands = TRUE,
                     ticks = "outside",
                     rangemode="tozero"),
        
        ## Y AXIS
        yaxis = list(
          type = "category",
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
          categoryorder = "total ascending",
          categoryarray = ~implementation_rate
        )
      )%>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
    
  })
  
  ## TABLE -----
  
  data_sds_implementation_hscp_table <- reactive({
    data_sds_implementation_hscp_plot() %>%
      select(
        financial_year,
        sending_location,
        implementation_rate,
        sdsclient
      ) %>%
      mutate(
        implementation_rate    = format(round(implementation_rate, 1), big.mark = ","),
        sdsclient = formatC(sdsclient, format = "f", big.mark = ",", drop0trailing = TRUE)
      ) 
  })
  
  observeEvent(input$sds_implementation_hscp_showhide, {
    toggle("sds_implementation_hscp_table")
    output$sds_implementation_hscp_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_implementation_hscp_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c("Financial Year",
                     "Location",
                     "Percentage of Implementation",
                     "Number of People going through SDS"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      )
    )
  })
  
  ## DOWNLOAD DATA ----
  
  output$download_sds_implementation_hscp_data <- downloadHandler(
    filename = "sds_implementation_hscp.csv",
    content = function(file) {
      write.table(data_sds_implementation_hscp %>%
                    select(financial_year,
                           sending_location,
                           implementation_rate,
                           sdsclient),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Percentage of Implementation",
                                "Number of People going through SDS"),
                  sep = ",")
    }
  )
  #################################-
  ## IMPLEMENTATION RATE TREND ----
  ################################-
  ## DATA ----
  
  data_sds_implementation_plot <- reactive({
    data_sds_implementation_hscp %>%
      filter(sending_location == input$sds_implementation_location_input)
  })
  
  data_sds_implementation_comparator <- reactive({
    data_sds_implementation_hscp %>%
      filter(sending_location == input$sds_implementation_comparator_location_input)
  })
  
  ## PLOT -----
  
  output$sds_implementation_plot <- renderPlotly({
    plot_ly(data_sds_implementation_plot(),
            x = ~financial_year,
            y = ~implementation_rate,
            type = "scatter",
            mode = "lines+markers",           # to add markers back in change to "lines+markers"
            name = paste("Percentage of Implementation in", input$sds_implementation_location_input),
            line = trend_line_setting,            # see global.R script to update this
            marker = trend_marker_setting,
            
            ### Add tooltip to trend plot
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", financial_year,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Percentage of Implementation:", round(implementation_rate, 1),
              "<br>",
              "Number of People going through SDS:", format(sdsclient, big.mark = ","))
    ) %>%
      
      ## Add location Comparison line 
      
      add_trace(
        name = paste("Percentage of Implementation in", input$sds_implementation_comparator_location_input),
        data = data_sds_implementation_comparator(),
        x = ~financial_year,
        y = ~implementation_rate, 
        type = "scatter",
        mode = "lines+markers",
        line = comparison_trend_line_setting, # update global.R to change this
        marker = comparison_trend_marker_setting,
        
        # Add tooltip for Comparator reference line
        
        hoverinfo = "text",
        text = ~ paste("Financial Year: ", financial_year,
                       "<br>",
                       "Location: ", input$sds_implementation_comparator_location_input,
                       "<br>",
                       "Percentage of Implementation:", round(implementation_rate,1),
                       "<br>",
                       "Number of People going through SDS:", format(sdsclient, big.mark = ",")),
        inherit = FALSE,
        showlegend = TRUE) %>%
      
      ## add COVID-19 reference line
      
      add_trace(name = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                data = rbind(data_sds_implementation_plot(), data_sds_implementation_comparator()),
                type = "scatter",
                mode = "line",
                color = reference_line_style, 
                x = "2019/20",
                y = ~c(0:max(implementation_rate)),
                hoverinfo = "text",
                text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                inherit = FALSE) %>%
      
      ### Specify plot titles, axis and formatting
      
      layout(
        
        ## Y AXIS
        
        yaxis = list(rangemode = "tozero",
                     title = paste0(c(
                       rep("&nbsp;", 40),
                       "Percentage of Implementation",
                       rep("&nbsp;", 40),
                       rep("\n&nbsp;", 1)
                     ),
                     collapse = ""
                     ),
                     separators = ',',
                     exponentformat = "none",
                     separatethousands = TRUE,
                     showline = TRUE,
                     ticks = "outside",
                     rangemode="tozero"
        ),
        
        ## X AXIS
        
        xaxis = list(title = "Financial Year",
                     #font = axis_font,
                     showline = TRUE,
                     ticks = "outside",
                     showgrid = FALSE
        ),
        
        ### Plot title
        
        title = ifelse(input$sds_implementation_location_input == input$sds_implementation_comparator_location_input,
                       paste0("<b> Percentage of People who receive Social Care Services/Support through SDS, <br> in ",
                              input$sds_implementation_location_input,
                              ", 2017/18 - 2021/22."),
                       paste0("<b> Percentage of People who receive Social Care Services/Support through SDS, <br> in ",
                              input$sds_implementation_location_input, " and <br>", 
                              input$sds_implementation_comparator_location_input,
                              ", 2017/18 - 2021/22.")
        ),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.5,
          font = list(size = 14)
        ),
        
        margin = list(l = 30, r = 30, b = 0, t = 130)
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
  })
  
  ## TABLE -----
  
  data_sds_implementation_trend_table <- reactive({
    
    if(input$sds_implementation_location_input == input$sds_implementation_comparator_location_input){
      data_sds_implementation_plot()%>%
        select(financial_year, sending_location, implementation_rate, sdsclient) %>%
        mutate(
          implementation_rate = round(implementation_rate, 1),
          sdsclient = formatC(sdsclient, format = "f", big.mark = ",", drop0trailing = TRUE))
    }else{
      rbind(data_sds_implementation_plot(),data_sds_implementation_comparator())%>%
        select(financial_year, sending_location, implementation_rate, sdsclient) %>%
        mutate(
          implementation_rate = round(implementation_rate, 1),
          sdsclient = formatC(sdsclient, format = "f", big.mark = ",", drop0trailing = TRUE))
    }
    
    
  })
  
  observeEvent(input$sds_implementation_showhide, {
    toggle("sds_implementation_table")
    output$sds_implementation_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_implementation_trend_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c("Financial Year",
                     "Location",
                     "Percentage of Implementation",
                     "Number of People going through SDS"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left",
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      )
    )
  })
  
  ## DOWNLOAD DATA ----
  
  output$download_sds_implementation_data <- downloadHandler(
    filename = "sds_implementation_trend.csv",
    content = function(file){
      write.table(data_sds_implementation_hscp %>%
                    select(financial_year, 
                           sending_location, 
                           implementation_rate,
                           sdsclient) %>%
                    mutate(
                      sdsclient = formatC(sdsclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Percentage of Implementation",
                    "Number of People going through SDS"
                  ),
                  sep = ",")
    }
  )
  #############################################-
  ## OPTIONS CHOSEN BY AGE  -----
  #############################################-
  ## DATA ----
  
  sds_options_age_plot <- reactive({
    data_sds_options_proportion %>%
      filter(
        financial_year   == input$sds_options_age_year_input,
        sending_location == input$sds_options_age_location_input
      )
  })
  
  ## PLOT ----
  
  output$sds_options_age_plot <- renderPlotly({
    
    # SHOW ERROR IF NO DATA
    if (nrow(data_sds_options_proportion[data_sds_options_proportion$financial_year == input$sds_options_age_year_input &
                                         data_sds_options_proportion$sending_location  == input$sds_options_age_location_input  , ]) == 0){
      
      
      text_sds_options_age <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$sds_options_age_location_input, 
                     "were unable to provide Self-directed Support data for ", 
                     "<br>", input$sds_options_age_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_sds_options_age,
          
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
      
      
      plot_ly(sds_options_age_plot() %>% 
                filter(age_group != "Unknown"),
              x = ~age_group,
              y = ~percentage,
              type = "bar",
              name = ~sds_option,
              color = ~sds_option,
              colors = four_col_pal,    # customised color selection, see global.R script for stacked_bar_pal specifications  UPDATE THIS FOR 4 COLOUR OPTIONS
              
              #### Add tooltip to plot
              hoverinfo = "text",
              hovertext = ~ paste(
                sds_option,
                "<br>",
                "Financial Year: ", financial_year,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Age Group:", age_group,
                "<br>",
                "Percentage of People:", formatC(percentage, big.mark = ","), "%",
                "<br>",
                "Number of People:", format(nclient, big.mark = ","),
                "<br>"
              )
      ) %>%
        layout(
          title = paste0("<b> Percentage of People receiving Self-directed Support by <br> Age Group and Options Chosen, in ",
                         input$sds_options_age_location_input, ", ", input$sds_options_age_year_input, ". "
          ),
          
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 30),
              "Percentage of People",
              rep("&nbsp;", 30),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            exponentformat = "none",
            nticks = 6,
            showline = TRUE,
            ticksuffix = "%",
            range = c(0, 100),
            ticks = "outside"
          ),
          xaxis = list(
            title = "Age Group",
            showline = TRUE,
            ticks = "outside"
            
          ),
          
          ## legend
          
          legend = list(
            x = 0, y = -0.6,
            font = list(size = 14)
          ),
          
          margin = list(l = 20, r = 20, b = 80, t = 120),
          font = list(size = 13),
          barmode = 'stack'
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    }
  })
  
  ## TABLE ----
  
  data_sds_options_age_table <- reactive({
    sds_options_age_plot() %>%
      mutate(number_of_people = format(nclient, big.mark = ","),
             percentage = round(percentage, 1)
             
      ) %>% 
      select(
        financial_year,
        sending_location,
        age_group,
        sds_option,
        number_of_people,
        percentage
      )
  })
  
  observeEvent(input$sds_options_age_showhide, {
    toggle("sds_options_age_table")
    output$sds_options_age_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_options_age_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c("Financial Year",
                     "Location",
                     "Age Group",
                     "Self-directed Support Option",
                     "Number of People",
                     "Percentage of People (%)"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      )
    )
  })
  
  ## DOWNLOAD DATA ----
  
  output$download_sds_options_age_data <- downloadHandler(
    filename = "sds_options_chosen_age_percentage.csv",
    content = function(file) {
      write.table(data_sds_options_proportion,
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Self-directed Support Option",
                                "Number of People",
                                "Percentage of People"),
                  sep = ",")
    }
  )
  
  
  
  #######################################-
  ## SDS CLIENT GROUP ----
  #######################################-
  ## DATA -----
  
  data_sds_client_plot <- reactive({
    data_sds_client_group %>%
      filter(
        sending_location == input$sds_client_location_input,
        financial_year   == input$sds_client_year_input,
        age_group        == input$sds_client_age_input)
  })
  
  
  
  
  ## PLOT ----
  
  output$sds_client_plot <- renderPlotly({
    
    # SHOW ERROR IF NO DATA
    if (nrow(data_sds_client_group[data_sds_client_group$financial_year == input$sds_client_year_input &
                                   data_sds_client_group$sending_location  == input$sds_client_location_input &
                                   data_sds_client_group$age_group == input$sds_client_age_input , ]) == 0){
      
      
      text_sds_client_group <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$sds_client_location_input, 
                     "were unable to provide Self-directed Support data for ", 
                     "<br>", input$sds_client_location_input, "for", input$sds_client_age_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_sds_client_group,
          
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
      
      plot_ly(data_sds_client_plot(),
              x = ~rate,
              y = ~client_group,
              type = "bar",
              marker = phs_bar_col,
              hoverinfo = "text",
              hovertext = ~ paste("Financial Year:", input$sds_client_year_input,
                                  "<br>",
                                  "Location:", sending_location,
                                  "<br>",
                                  "Age Group:", age_group,
                                  "<br>",
                                  "Client Group:", client_group,
                                  "<br>",
                                  "Rate per 1,000 SDS Clients:", formatC(round(rate, 1), 
                                                                         format = "f", 
                                                                         big.mark = ",", 
                                                                         drop0trailing = TRUE),
                                  "<br>",
                                  "Number of People:", formatC(nclient, 
                                                               format = "f", 
                                                               big.mark = ",", 
                                                               drop0trailing = TRUE))
      ) %>%
        layout(
          
          # X AXIS
          
          xaxis = list(showline = TRUE,
                       ticks = "outside",
                       title = paste0(c(
                         rep("&nbsp;", 40),
                         "Rate per 1,000 Self-directed Support Clients",
                         rep("&nbsp;", 40),
                         rep("\n&nbsp;", 1)
                       ),
                       collapse = ""
                       ),
                       exponentformat = "none",
                       separatethousands = TRUE,
                       rangemode="tozero"),
          # Y AXIS
          
          yaxis = list(showline = TRUE,
                       ticks = "outside",
                       categoryorder = "total ascending",
                       categoryarray = ~rate,
                       tickangle = -45,
                       title = paste0(c(rep("&nbsp;", 10),
                                        "Client Group",
                                        rep("&nbsp;", 10),
                                        rep("\n&nbsp;", 1)),
                                      collapse = "")), #,
          #titlefont = f2),
          
          # PLOT TITLE
          
          title = paste0("<b> Number of People as Rate per 1,000 Self-directed Support Clients, <br> receiving SDS (All Options), ",
                         input$sds_client_age_input, ", <br> by Client Group in ",
                         input$sds_client_location_input, ", ", input$sds_client_year_input, "."),     
          
          
          margin = list(l = 10, r = 10, b = 70, t = 120)
        ) %>%  
        
        
        config(displayModeBar = TRUE,
               modeBarButtonsToRemove = buttons_to_remove,
               displaylogo = F,  
               editable = F
        )
    }
  })
  
  ## TABLE ----
  
  data_sds_client_table <- reactive({
    data_sds_client_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        client_group,
        rate,
        nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate = format(round(rate, 1), big.mark = ","))
  })
  
  observeEvent(input$sds_client_showhide, {
    toggle("sds_client_table")
    output$sds_client_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_client_table() ,
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c("Financial Year",
                     "Location",
                     "Age Group",
                     "Client Group",
                     "Rate per 1,000 Self-directed Support Clients",
                     "Number of People"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       dom = "tip",
                       bPaginate = FALSE,
                       bInfo = FALSE))
    )
  })
  
  ## DOWNLOAD DATA ----
  
  output$download_sds_client_data <- downloadHandler(
    filename = "sds_client_group.csv",
    content = function(file) {
      write.table(data_sds_client_group %>%
                    mutate(nclient =
                             formatC(nclient, 
                                     format = "f",
                                     big.mark = ",", 
                                     drop0trailing = TRUE),
                           rate = round(rate, 1)),
                  #),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Client Group",
                                "Number of People",
                                "Rate per 1,000 Self-directed Support Clients"),
                  sep = ",")
    }
  )
  
  ###################################-
  ## SUPPORT/SERVICES NEEDS ----
  ###################################-
  
  ## DATA ----
  
  data_sds_support_service_plot <- reactive({
    data_sds_support_needs %>%
      filter(financial_year   == input$sds_support_service_year_input,
             sending_location == input$sds_support_service_location_input,
             age_group        == input$sds_support_service_age_input)
  })
  
  
  ## PLOT ----
  
  output$sds_support_service_plot <- renderPlotly({
    
    # SHOW ERROR IF NO DATA
    if (nrow(data_sds_support_needs[data_sds_support_needs$financial_year == input$sds_support_service_year_input &
                                    data_sds_support_needs$sending_location  == input$sds_support_service_location_input &
                                    data_sds_support_needs$age_group == input$sds_support_service_age_input , ]) == 0){
      
      
      text_sds_support <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$sds_support_service_location_input, 
                     "were unable to provide Self-directed Support data for ", 
                     "<br>", input$sds_support_service_year_input, "for", input$sds_support_service_age_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_sds_support,
          
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
      
      data_sds_support_service_plot() %>% 
        #filter(nclient> 0) %>% 
        plot_ly(
          y = ~support_need,
          x = ~rate,
          type = "bar",
          marker = list(color = "rgb(67,57,132)"),     # specify bar chart colour
          
          ## Add tooltip to plot
          hoverinfo = "text",
          hovertext = ~ paste(
            "Financial Year:", financial_year,
            "<br>",
            "Location:", sending_location,
            "<br>",
            "Age Group:", age_group,
            "<br>",
            "Support:", ifelse(support_need == "Equipment and Temp...", "Equipment and Temporary Adaptations",
                               ifelse(support_need == "Social Educational...", "Social Educational Recreational", support_need)
            ),
            "<br>",
            "Rate per 1,000 SDS Clients:", formatC(round(rate, 1), 
                                                   format = "f", 
                                                   big.mark = ",", 
                                                   drop0trailing = TRUE),
            "<br>",
            "Number of People:", formatC(nclient, 
                                         format = "f", 
                                         big.mark = ",", 
                                         drop0trailing = TRUE)
          )
        ) %>%
        
        # specify plot axis and titles 
        
        layout(
          
          ### Y AXIS
          
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 40),
              "Support Need",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            showline = TRUE,
            categoryorder = "total ascending",
            categoryarray = ~nclient,
            ticks = "outside",
            tickangle = -45
            
          ),
          
          ### X AXIS
          
          xaxis = list(
            title = "Rate per 1,000 Self-directed Support Clients",
            exponentformat = "none",
            separatethousands = TRUE,
            showline = TRUE,
            ticks = "outside",
            rangemode="tozero"
          ),
          
          ## PLOT TITLE
          
          
          title = paste0("<b> Number of People as a Rate per 1,000 Self-directed Support Clients, <br>", 
                         input$sds_support_service_age_input, ", by Assessed Support Need, <br>",
                         input$sds_support_service_location_input, ", ", input$sds_support_service_year_input, "."),
          
          
          margin = list(l = 70, r = 20, b = 70, t = 120)
          
        ) %>%
        
        
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    }
  })
  
  ## TABLE ----
  
  data_sds_support_service_table <- reactive({
    data_sds_support_service_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        support_need,
        rate,
        nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate    = format(round(rate, 1), big.mark = ","))
  })
  
  observeEvent(input$sds_support_service_showhide, {
    toggle("sds_support_service_table")
    output$sds_support_service_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_support_service_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c(
          "Financial Year",
          "Location",
          "Age Group",
          "Support",
          "Rate per 1,000 Self-directed Support Clients",
          "Number of People"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      ))
  })
  
  
  
  
  ## DOWNLOAD DATA -----
  
  output$download_sds_support_service_data <- downloadHandler(
    filename = "sds_support_service_needs.csv",
    content = function(file) {
      write.table(data_sds_support_needs,
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Support",
                                "Number of People",
                                "Rate per 1,000 Self-directed Support Clients"),
                  sep = ",")
    }
  )
  
  
  #######################################-
  ## ORGANISATION ----
  #######################################-
  
  ## DATA ----
  
  data_sds_type_of_organisation_plot <- reactive({
    data_sds_type_of_organisation %>%
      filter(financial_year   == input$sds_organisation_year_input,
             sending_location == input$sds_organisation_location_input,
             age_group        == input$sds_organisation_age_input)
  })
  
  
  
  ## PLOT ----
  
  output$sds_organisation_plot <- renderPlotly({
    
    # SHOW ERROR IF NO DATA
    if (nrow(data_sds_type_of_organisation[data_sds_type_of_organisation$financial_year == input$sds_organisation_year_input &
                                           data_sds_type_of_organisation$sending_location  == input$sds_organisation_location_input &
                                           data_sds_type_of_organisation$age_group == input$sds_organisation_age_input , ]) == 0){
      
      
      text_sds_organisation <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$sds_organisation_location_input, 
                     "were unable to provide Self-directed Support data for ", 
                     "<br>", input$sds_organisation_year_input, "for", input$sds_organisation_age_input ,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_sds_organisation,
          
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
      
      data_sds_type_of_organisation_plot() %>% 
        #filter(nclient > 0) %>% 
        plot_ly(
          y = ~support_services,
          x = ~rate,
          type = "bar",
          marker = phs_bar_col,
          
          ## add tooltip info 
          hoverinfo = "text",
          hovertext = ~ paste(
            "Financial Year:", financial_year,
            "<br>",
            "Location:", sending_location,
            "<br>",
            "Age Group:", input$sds_organisation_age_input,
            "<br>",
            "Support Organisation Type:", support_services,
            "<br>",
            "Rate per 1,000 SDS Clients:", formatC(round(rate,1), format = "f", big.mark = ",", drop0trailing = TRUE),
            "<br>",
            "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
          )) %>%
        layout(
          
          
          
          # PLOT TITLE
          title = paste0("<b> Number of People as a Rate per 1,000 Self-directed Support Clients, <br> receiving SDS (All Options), ", 
                         input$sds_organisation_age_input, ", by Support Organisation Type, <br> in ",
                         input$sds_organisation_location_input, ", ", input$sds_organisation_year_input, "."),
          
          
          yaxis = list(
            showline = TRUE,
            ticks = "outside",
            tickangle = -45,
            title = paste0(c(
              rep("&nbsp;", 40),
              "Support Organisation Type",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            categoryorder = "total ascending",
            categoryarray = ~nclient
          ),
          xaxis = list(
            showline = TRUE,
            ticks = "outside",
            title = "Rate per 1,000 Self-directed Support Clients",
            exponentformat = "none",
            separatethousands = TRUE,
            rangemode="tozero"),
          margin = list(l = 80, r = 10, b = 90, t = 110)
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F, 
          editable = F
        )
    }
  })
  
  ## TABLE ----
  
  data_sds_organisation_table <- reactive({
    data_sds_type_of_organisation_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        support_services,
        rate,
        nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate = format(round(rate,1), big.mark = ","))
  })
  
  observeEvent(input$sds_organisation_showhide, {
    toggle("sds_organisation_table")
    output$sds_organisation_table_output <- DT::renderDataTable(
      DT::datatable(
        data_sds_organisation_table(),
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c(
          "Financial Year",
          "Location",
          "Age Group",
          "Self-directed Support Mechanism",
          "Rate per 1,000 Self-directed Support Clients",
          "Number of People"),
        options = list(pageLength = 16,
                       autoWidth = TRUE,
                       dom = "tip",
                       columnDefs = list(list(className = "dt-left", 
                                              targets = "_all")),
                       bPaginate = FALSE,
                       bInfo = FALSE)
      )
    )
  })
  
  
  
  ## DOWNLOAD DATA -----
  
  output$download_sds_organisation_data <- downloadHandler(
    filename = "sds_support_type_of_organisation.csv",
    content = function(file) {
      write.table(data_sds_type_of_organisation,
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Age Group",
                                "Self-directed Support Mechanism",
                                "Number of People",
                                "Rate per 1,000 Self-directed Support Clients"),
                  sep = ",")
    }
  )
  
  ################################
  ## server closing bracket ----
  
}


## end of script