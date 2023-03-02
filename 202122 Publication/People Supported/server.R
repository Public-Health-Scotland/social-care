####################################-
## CLIENT SERVER SCRIPT ##
####################################-


########################################################################-
## code to password protect app - comment out if not required ##
## read in server credentials code from admin/create_credendentials.R ##

#credentials <- readRDS("admin/credentials.rds")
########################################################################-


### SERVER ----

server <- function(input, output, session) {
  
  #   # shiny manager code required for password protection 
  #   #########################-
  #   ## SHINY MANAGER ##
  #   #########################-
  #   library(shinymanager)
  #   res_auth <- shinymanager::secure_server(
  #     check_credentials = check_credentials(credentials)
  #   )
  #   
  #   output$auth_output <- renderPrint({
  #     reactiveValuesToList(res_auth)
  #   })
  #########################-
  
  
  
  #########################-
  ## DATA COMPLETENESS 
  #########################-
  
  
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
  
  
  #########################-
  ## DATA QUALITY -----
  #########################-
  
  data_quality_table_filtered <- reactive({
    
    if (input$client_data_quality_location_input == "All HSCPs" & input$client_data_quality_financial_year_input == "All Financial Years") { 
      data_quality_table
      
    } else if (input$client_data_quality_location_input == "All HSCPs" & input$client_data_quality_financial_year_input != "All Financial Years") {
      data_quality_table %>%
        filter(`Financial Year` == input$client_data_quality_financial_year_input)
      
    } else if (input$client_data_quality_location_input != "All HSCPs" & input$client_data_quality_financial_year_input == "All Financial Years") {
      data_quality_table %>%
        filter(`Health and Social Care Partnership` == input$client_data_quality_location_input)
      
    } else {
      data_quality_table %>%
        filter(`Health and Social Care Partnership` == input$client_data_quality_location_input,
               `Financial Year` == input$client_data_quality_financial_year_input)
      
    }
  })
  
  output$data_quality_table <-  DT::renderDataTable(
    DT::datatable(data_quality_table_filtered(),
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
  
  ## appendix table 
  
  output$appendix_table <-  DT::renderDataTable(
    DT::datatable(appendix_table,
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
  
  ##############################-
  ### PEOPLE SUPPORTED ----
  ##############################-
  ##################################-
  ## PEOPLE SUPPORTED ----
  ##################################-
  ## DATA ----
  
  data_people_supported_summary_plot <- reactive({
    data_people_supported_summary %>%
      filter(financial_year == input$client_summary_year_input,
             measure        == input$client_summary_measure_input)
  })
  
  
  ## PLOT -----
  
  output$ClientTotals <- renderPlotly({
    plot_ly(data_people_supported_summary_plot() %>%
              filter(sending_location != "Scotland (Estimated)"),
            name = "Health and Social Care Partnership",
            x = ~rate,
            y = ~sending_location,
            type = "bar",              # type of plot / chart
            marker = phs_bar_col,      # colour of bars
            
            ### Add tooltip to plot
            
            hoverinfo = "text",
            hovertext = ~ paste0(
              "Financial Year: ", financial_year,
              "<br>",
              "Location: ", sending_location,
              "<br>",
              input$client_summary_measure_input, ": ", formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Number of People: ", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
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
          "Financial Year: ", input$client_summary_year_input,
          "<br>",
          "Location: Scotland (Estimate)",
          "<br>",
          input$client_summary_measure_input, ": ", formatC(scotland_rate, format = "f", big.mark = ",", drop0trailing = TRUE),
          "<br>",
          "Number of People: ", formatC(scotland_nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
        ),
        inherit = FALSE,
        showlegend = TRUE
        
      ) %>%
      
      # add plot title, x axis and y axis names and settings
      
      layout(
        
        title = paste0("<b>", "People Supported through Social Care Services/Support, ", "<br> as a ", 
                       input$client_summary_measure_input, "<br> by Health and Social Care Partnership by, ", 
                       input$client_summary_year_input),
        
        ## x axis         
        
        xaxis = list(
          title =  input$client_summary_measure_input,
          exponentformat = "none",
          separatethousands = TRUE,
          showline = TRUE,
          ticks = "outside"
        ), 
        
        ## y axis 
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 40),
            "Health and Social Care Partnership",
            rep("&nbsp;", 40),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          showline = TRUE,
          ticks = "outside",
          categoryorder = "total ascending",
          categoryarray = ~nclient
        ),
        
        margin = list(l = 10, r = 10, b = 50, t = 120),
        legend = list(x = 0, y = -0.2,
                      font = list(size = 13))
        
      ) %>%
      
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
  })
  
  ## TABLE ---------
  
  data_people_supported_summary_table <- reactive({
    data_people_supported_summary_plot() %>%
      select(
        financial_year,
        sending_location,
        rate,
        nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate = format(rate, big.mark = ",")
      )
  })
  
  observeEvent(input$Clients_button_1, {
    toggle("ClientsTotalsTable")
    output$table_clients_totals <- DT::renderDataTable(DT::datatable(
      data_people_supported_summary_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        input$client_summary_measure_input,
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
  
  ## DOWNLOAD DATA ----
  
  output$download_clients_totals <- downloadHandler(
    filename = "people_supported_summary.csv",
    content = function(file) {
      write.table(data_people_supported_summary %>%
                    select(financial_year, sending_location, measure, rate, nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Measure",
                    "Value",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  #################################-
  # TREND ----
  #################################-
  ## DATA ----
  
  data_people_supported_trend_plot <- reactive({
    data_people_supported_trend %>%
      filter(sending_location  == input$client_trend_location_input,
             measure           == input$client_trend_measure_input)
  })
  
  ## Data for location comparison
  
  data_people_supported_trend_comparison_plot <- reactive({
    data_people_supported_trend %>%
      filter(sending_location  == input$client_trend_location_comparison_input,
             measure           == input$client_trend_measure_input)
  })
  
  
  ## PLOT ----
  
  output$client_trend_plot_output <- renderPlotly({
    plot_ly(data_people_supported_trend_plot(),
            x = ~financial_year,
            y = ~rate,
            type = "scatter",                    # creates scatterplot
            mode = "lines+markers",                      # creates line graph
            line = trend_line_setting,           # trend_line_setting specified in global.R script    
            marker = trend_marker_setting,
            
            ## Add tooltop information (text to appear when cursor hovers over a data point in the plot)
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", financial_year,
              "<br>",
              "Location:", input$client_trend_location_input,
              "<br>",
              input$client_trend_measure_input, ":", formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            ), # end of hoverinfo text bracket
            name = paste(input$client_trend_measure_input, input$client_trend_location_input)
            
    ) %>%
      
      ## Add location Comparison line 
      
      add_trace(
        data = data_people_supported_trend_comparison_plot(),
        x = ~financial_year,
        y = ~rate,
        type = "scatter",
        mode = "lines+markers",
        marker = comparison_trend_marker_setting,
        line = comparison_trend_line_setting, # change settings in global.R script
        name = paste(input$client_trend_measure_input, input$client_trend_location_comparison_input),
        
        
        # Add tooltip for location comparison line
        
        hoverinfo = "text",
        text = ~ paste(
          "Financial Year:", financial_year,
          "<br>",
          "Location:", input$client_trend_location_comparison_input,
          "<br>",
          input$client_trend_measure_input, ":", formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
          "<br>",
          "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
        ),
        inherit = FALSE,
        showlegend = TRUE) %>% # end of comparison location trend line 
      
      
      ## add COVID-19 reference line
      
      add_trace(name = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                data = rbind(data_people_supported_trend_plot(), data_people_supported_trend_comparison_plot()),
                type = "scatter",
                mode = "line",
                color = reference_line_style, 
                x = "2019/20",
                y = ~c(0:max(rate)),
                hoverinfo = "text",
                text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                inherit = FALSE) %>%
      
      layout(
        
        # x axis
        
        xaxis = list(
          type = "category",
          title = "Financial Year",
          tickangle = 0,
          tickmode = "array",
          showline = TRUE,
          ticks = "outside",
          showgrid = FALSE
        ),
        
        ## Y axis specifications 
        
        yaxis = list(
          
          title = input$client_trend_measure_input,
          showline = TRUE,
          ticks = "outside",
          tickmode = "array",
          rangemode = "tozero",
          separators = ",",
          exponentformat = "none",
          separatethousands = TRUE
        ),
        
        
        ## plot title
        
        title = ifelse(input$client_trend_location_input == input$client_trend_location_comparison_input,
                       paste0("<b>", "People Supported through Social Care Services/Support, <br> as a ", 
                              input$client_trend_measure_input, " in ", input$client_trend_location_input,
                              ", <br> 2017/18 - 2021/22."),
                       paste0("<b>", "People Supported through Social Care Services/Support, <br> as a ", 
                              input$client_trend_measure_input, " in <br>", input$client_trend_location_input, 
                              " and ", input$client_trend_location_comparison_input, ", 2017/18 - 2021/22.")
        ),
        
        ## legend
        
        legend = list(
          
          x = 0, y = -0.5,
          font = list(size = 14)
        ),
        
        margin = list(l = 10, r = 10, b = 90, t = 120)
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  
  ## TABLE ----- 
  
  data_people_supported_trend_table <- reactive({
    
    if(input$client_trend_location_input == input$client_trend_location_comparison_input){
      data_people_supported_trend_plot()%>%
        select(financial_year, sending_location, measure, rate, nclient) %>%
        mutate(
          rate = formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
          nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))
    }else{
      rbind(data_people_supported_trend_plot(),data_people_supported_trend_comparison_plot())%>%
        select(financial_year, sending_location, measure, rate, nclient) %>%
        mutate(
          rate = formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
          nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))
    }
    
    
  })
  
  observeEvent(input$Clients_trend_button_1, {
    toggle("ClientsTrendTable")
    output$table_clients_trend <- DT::renderDataTable(DT::datatable(
      data_people_supported_trend_table()  %>%
        select(financial_year,
               sending_location,
               rate,
               nclient),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        input$client_trend_measure_input,
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
  
  
  ## DOWNLOAD DATA ----
  
  output$download_clients_trend <- downloadHandler(
    filename = "people_supported_trend.csv",
    content = function(file) {
      write.table(
        data_people_supported_trend %>%
          select(financial_year, sending_location, measure, rate, nclient) %>%
          mutate(
            nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
            rate = formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE)),
        file,
        row.names = FALSE,
        col.names = c(
          "Financial Year",
          "Location",
          "Measure",
          "Rate",
          "Number of People"
        ),
        sep = ","
      )
    }
  )
  
  ###############################
  ## AGE & SEX ----
  ###############################
  
  ## DATA ----
  
  data_people_supported_age_sex_plot <- reactive({
    data_people_supported_age_sex %>%
      filter(
        financial_year   == input$clients_age_sex_year_input,
        sending_location == input$clients_age_sex_location_input,
        measure          == input$clients_age_sex_measure_input,
        sex              != "Not Known / Unspecified",
        sex              != "Unknown/Not Specified",
        age_group        != "Unknown"
      ) %>%
      mutate(
        value = ifelse(sex == "Female", rate *-1 , rate)
      )
  })
  
  
  ## PLOT ---- 
  
  
  output$Clientsagesex <- renderPlotly({
    
    # only show plot if data avliable otherwise an error will appear
    if (nrow(data_people_supported_age_sex[data_people_supported_age_sex$financial_year == input$clients_age_sex_year_input &
                                           data_people_supported_age_sex$sending_location  == input$clients_age_sex_location_input &
                                           data_people_supported_age_sex$measure           == input$clients_age_sex_measure_input , ]) == 0){
      
      
      text_people_supported_age_sex <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$clients_age_sex_location_input, 
                     "HSCP were unable to provide Client data for", 
                     input$clients_age_sex_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_people_supported_age_sex,
          
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
    }
    
    else{
      plot_ly(data_people_supported_age_sex_plot(), 
              x = ~value,
              y = ~age_group,
              color = ~ as.factor(sex),
              colors = palette_agesex_plot,
              type = 'bar', 
              orientation = 'h',
              
              # add tooltip
              
              hoverinfo = "text",
              hovertext = ~ paste0(
                "Financial Year: " , financial_year,
                "<br>",
                "Location: " , sending_location,
                "<br>",
                "Sex: " , sex,
                "<br>",
                "Age Group: " , age_group,
                "<br>",
                input$clients_age_sex_measure_input, ": ", formatC(abs(rate), format = "f", big.mark = ",", drop0trailing = TRUE),
                "<br>",
                "Number of People: ", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE))
              
      ) %>% 
        
        layout(
          bargap = 0.2,
          barmode = "overlay",
          
          ## x axis ##
          
          xaxis = list(title = input$clients_age_sex_measure_input, 
                       showline = TRUE,
                       exponentformat = "none",
                       ticks = "outside",
                       tickmode = 'array', 
                       tickvals = c(-650, -550, -450, -350, -250, -150, -50, 0, 50, 150, 250, 350, 450),
                       ticktext = c('650', '550', '450', '350', '250', '150', '50', '0', '50', '150', '250', '350', '450')),
          
          ## y axis ##
          
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 40),
              "Age Group",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            showline = TRUE,
            ticks = "outside"
          ),
          
          
          ## plot title ##
          
          title = paste0("<b> People Supported through Social Care Services/Support, <br> as a ", 
                         input$clients_age_sex_measure_input, ", by Age and Sex <br> in ",
                         input$clients_age_sex_location_input, ", ", input$clients_age_sex_year_input, "."),
          
          ### plot legend 
          
          legend = list(x = 120, y = 0.5, font = list(size = 15)),
          
          ### plot position / margins
          
          margin = list(l = 10, r = 10, b = 80, t = 100)
          
        ) %>%
        
        # buttons to include on plot (download png option)
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    }
  })
  
  
  ## TABLE --------
  
  
  data_people_supported_age_sex_table <- reactive({
    data_people_supported_age_sex %>%
      filter(
        financial_year   == input$clients_age_sex_year_input,
        sending_location == input$clients_age_sex_location_input,
        measure          == input$clients_age_sex_measure_input
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate    = format(round(rate, 1), big.mark = ","))
  })
  
  observeEvent(input$Clients_button_2, {
    toggle("ClientsAgeSexTable")
    output$table_clients_agesex <- 
      DT::renderDataTable(DT::datatable(
        data_people_supported_age_sex_table() %>%
          select(financial_year, 
                 sending_location,  
                 sex, 
                 age_group,
                 rate,
                 nclient), 
        style = "bootstrap",
        class = "table-bordered table-condensed",
        rownames = FALSE,
        colnames = c(
          "Financial Year",
          "Location",
          "Sex",
          "Age Group",
          input$clients_age_sex_measure_input,
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
  
  ## DOWNLOAD DATA -----
  
  output$download_clients_agesex <- downloadHandler(
    filename = "people_supported_age_sex.csv",
    content = function(file) {
      write.table(data_people_supported_age_sex %>%
                    select(financial_year, sending_location, sex, measure, age_group, rate, nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Sex",
                    "Measure",
                    "Age Group",
                    "Rate per 1,000 Social Care Clients",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  ##################################-
  ## ETHNICITY ----
  ##################################-
  
  ## DATA ----
  
  data_people_supported_ethnicity_plot <- reactive({
    data_people_supported_ethnicity %>%
      filter(
        financial_year   == input$client_ethnicity_year_input,
        sending_location == input$client_ethnicity_location_input,
        age_group        == input$client_ethnicity_age_input,
        measure          == input$client_ethnicity_measure_input
      )
  })
  
  
  ## PLOT ----
  
  output$Clients_ethnicity_plot <- renderPlotly({ 
    
    # only show plot if data avliable otherwise an error will appear
    if (nrow(data_people_supported_ethnicity[data_people_supported_ethnicity$financial_year == input$client_ethnicity_year_input &
                                             data_people_supported_ethnicity$sending_location  == input$client_ethnicity_location_input &
                                             data_people_supported_ethnicity$measure           == input$client_ethnicity_measure_input , ]) == 0){
      
      
      text_people_supported_ethnicity <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$client_ethnicity_location_input, 
                     "HSCP were unable to provide Client data for", 
                     input$client_ethnicity_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_people_supported_ethnicity,
          
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
    }
    
    else{
      plot_ly(data_people_supported_ethnicity_plot(), x = ~rate,
              y = ~ethnicity,
              type = "bar",
              marker = phs_bar_col,      # colour of bars
              
              ## tooltip 
              
              hoverinfo = "text",
              hovertext = ~ paste0(
                "Financial Year: ", financial_year,
                "<br>",
                "Location: ", sending_location,
                "<br>",
                "Ethnic Group: ", ethnicity,
                "<br>",
                "Age Group: ", age_group,
                "<br>",
                input$client_ethnicity_measure_input, ": ", formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
                "<br>",
                "Number of People: ", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        layout(
          
          xaxis = list(
            title = input$client_ethnicity_measure_input,
            exponentformat = "none",
            rangemode = "tozero",
            nticks = 8,
            separatethousands = TRUE,
            showline = TRUE,
            ticks = "outside"
          ),
          
          yaxis = list(
            tickangle = 0,
            title = paste0(c(
              rep("&nbsp;", 40),
              "Ethnic Group",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            categoryarray = ~rate,
            categoryorder = "total ascending",
            showline = TRUE,
            ticks = "outside"
          ),
          
          
          ## plot title
          
          title = paste0("<b>  People Supported through Social Care Services/Support, <br> as a ", 
                         input$client_ethnicity_measure_input, ", ", input$client_ethnicity_age_input, 
                         ", <br> by Ethnic Group in ", input$client_ethnicity_location_input, ", ",
                         input$client_ethnicity_year_input, "."),
          
          
          margin = list(l = 0, r = 20, b = 80, t = 100)
          
        ) %>%
        
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )}
  }
  )
  
  
  ## TABLE ----
  
  data_people_supported_ethnicity_table <- reactive({
    data_people_supported_ethnicity_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        ethnicity,
        rate,
        nclient
      ) %>%
      mutate(
        nclient = format(nclient, big.mark = ","),
        rate    = format(rate, big.mark = ","))
  })
  
  
  observeEvent(input$Clients_button_ethnicity, {
    toggle("ClientsEthnicityTable")
    output$table_clients_ethnicity <- DT::renderDataTable(DT::datatable(
      data_people_supported_ethnicity_table() ,
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "Age Group",
        "Ethnic Group",
        input$client_ethnicity_measure_input,
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
  
  
  
  ## DOWNLOAD DATA ----
  
  output$download_clients_ethnicity <- downloadHandler(
    filename = "people_supported_ethnicity.csv",
    content = function(file) {
      write.table(data_people_supported_ethnicity %>%
                    select(financial_year, 
                           sending_location,
                           age_group,
                           ethnicity,
                           measure,
                           rate,
                           nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Ethnic Group",
                    "Measure",
                    "Rate per 1,000 Social Care Clients",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  ####################################
  ## CLIENT GROUP ----
  ####################################
  
  ## DATA  -----
  
  data_client_group_filtered <- reactive({
    data_people_supported_client_group %>%
      filter(
        financial_year   == input$client_group_year_input, 
        sending_location == input$client_group_location_input,
        measure          == input$client_group_measure_input,
        age_group        == input$client_group_age_input
      )
  })
  
  
  ## PLOT -----
  
  output$Clientsclienttype <- renderPlotly({
    
    # only show plot if data avliable otherwise an error will appear
    if (nrow(data_people_supported_client_group[data_people_supported_client_group$financial_year == input$client_group_year_input &
                                                data_people_supported_client_group$sending_location  == input$client_group_location_input &
                                                data_people_supported_client_group$measure           == input$client_group_measure_input , ]) == 0){
      
      
      text_people_supported_client_group <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$client_group_location_input, 
                     "HSCP were unable to provide Client group data for", 
                     input$client_group_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_people_supported_client_group,
          
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
    }
    
    else{
      plot_ly(data_client_group_filtered(),
              x = ~rate,
              y = ~client_group,
              type = "bar",
              marker = phs_bar_col,      # colour of bars
              
              
              ## tooltip 
              
              hoverinfo = "text",
              hovertext = ~ paste0(
                "Financial Year: ", financial_year,
                "<br>",
                "Location: ", sending_location,
                "<br>",
                "Age Group: ", age_group,
                "<br>",
                input$client_group_measure_input,": ", formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
                "<br>",
                "Number of People: ", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        layout(
          
          xaxis = list(
            title = input$client_group_measure_input,
            #titlefont = f2,
            exponentformat = "none",
            rangemode = "tozero",
            separatethousands = TRUE,
            showline = TRUE,
            ticks = "outside"
          ),
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 40),
              "Client Group",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            categoryorder = "total ascending",
            categoryarray = ~nclient,
            #titlefont = f2,
            showline = TRUE,
            ticks = "outside"
          ),
          
          
          ## plot title
          
          title = paste0("<b> People Supported through Social Care Services/Support, <br> as a ",
                         input$client_group_measure_input, ", ", input$client_group_age_input, 
                         ", <br> by Client Group in ", input$client_group_location_input, ", ", 
                         input$client_group_year_input, "."),
          
          
          
          margin = list(l = 0, r = 30, b = 100, t = 130)
          
        ) %>%
        
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )}
  })
  
  
  ## TABLE ------
  
  data_people_supported_client_group_table <- reactive({
    data_client_group_filtered() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        client_group,
        rate,
        nclient
      ) %>%
      mutate(
        nclient = format(nclient, big.mark = ","),
        rate    = format(rate, big.mark = ","))
  })
  
  observeEvent(input$Client_group_button, {
    toggle("ClientsClientTypeTable")
    output$table_clients_client_type <- DT::renderDataTable(DT::datatable(
      data_people_supported_client_group_table() ,
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "Age Group",
        "Client Group",
        input$client_group_measure_input,
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
  
  
  ## DOWNLOAD DATA ----
  
  output$download_clients_client_group <- downloadHandler(
    filename = "people_supported_client_group.csv",
    content = function(file) {
      write.table(data_people_supported_client_group %>%
                    select(financial_year, 
                           sending_location,
                           age_group,
                           client_group,
                           measure,
                           rate,
                           nclient) %>%
                    mutate(
                      rate = formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
                      nclient = formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Client Group",
                    "Measure",
                    "Rate per 1,000 Social Care Clients",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  
  #####################################
  ## SUPPORT & SERVICES ----
  #####################################
  
  ## DATA ----
  
  data_client_support_services <- reactive({
    data_people_supported_services %>%
      filter(
        financial_year == input$client_service_year_input,
        sending_location == input$client_service_location_input,
        age_group == input$client_service_age_input
      )
  })
  
  
  ## PLOT  ----
  
  output$client_support_services <- renderPlotly({
    
    # only show plot if data avliable otherwise an error will appear
    if (nrow(data_people_supported_services[data_people_supported_services$financial_year == input$client_service_year_input &
                                            data_people_supported_services$sending_location  == input$client_service_location_input , ]) == 0){
      
      
      text_people_supported_services <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$client_service_location_input, 
                     "HSCP were unable to provide Client data for", 
                     input$client_service_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_people_supported_services,
          
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
    }
    
    else{
      plot_ly(data_client_support_services(),
              y = ~nclient,
              x = ~service_group,
              type = "bar",
              marker = phs_bar_col,
              
              
              ### add tool tip
              
              hoverinfo = "text",
              hovertext = ~ paste(
                "Financial Year:", input$client_service_year_input,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Social Care Service:", service_group,
                "<br>",
                "Number of People:", format(nclient, big.mark = ",")
              )
      ) %>%
        
        layout(
          
          ### Y AXIS
          
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 40),
              "Number of People",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            exponentformat = "none",
            separatethousands = TRUE,
            showline = TRUE,
            ticks = "outside"
          ),
          
          ### X AXIS
          
          xaxis = list(
            showline = TRUE,
            ticks = "outside",
            title = paste0(c(
              rep("&nbsp;", 40),
              "Social Care Service or Support Type",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            categoryarray = ~nclient,
            categoryorder = "total ascending"
          ),
          
          
          ## plot position
          
          margin = list(l = 10, r = 10, b = 110, t = 130),
          
          # plot title
          
          title = paste0("<b> Number of People receiving Social Care Services/Support,", 
                         " <br>", input$client_service_age_input, ", by Support Service Type <br> in ",
                         input$client_service_location_input, ", ", input$client_service_year_input, ".")
        ) %>%
        
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )}
  })
  
  
  ## TABLE ----
  
  data_people_supported_service_table <- reactive({
    data_client_support_services() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        service_group,
        nclient
      ) %>%
      mutate(nclient = format(round(nclient, 1), big.mark = ","))
  })
  
  observeEvent(input$Clients_services_action_button, {
    toggle("ClientsServicesTable")
    output$table_clients_services <- DT::renderDataTable(DT::datatable(
      data_people_supported_service_table() ,
      
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "Age Group",
        "Type of Service / Support",
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
  
  ## DOWNLOAD DATA ----
  
  output$download_clients_services <- downloadHandler(
    filename = "people_supported_services.csv",
    content = function(file) {
      write.table(data_people_supported_services %>%
                    select(financial_year, 
                           sending_location,
                           age_group,
                           service_group,
                           nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Service Group",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  #####################################-
  ## MEALS ----
  #####################################-
  
  ## DATA ----
  
  meals_data_filtered <- reactive({
    data_people_supported_meals %>%
      filter(
        financial_year   == input$client_meals_year_input,
        sending_location == input$client_meals_location_input,
        measure          == input$client_meals_measure_input
      ) 
  })
  
  
  ## PLOT ----
  
  output$meals_plot_output <- renderPlotly({
    
    # only show plot if data avliable otherwise an error will appear
    if (nrow(data_people_supported_meals[data_people_supported_meals$financial_year == input$client_meals_year_input &
                                         data_people_supported_meals$sending_location  == input$client_meals_location_input &
                                         data_people_supported_meals$measure           == input$client_meals_measure_input , ]) == 0){
      
      
      text_people_supported_meals <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$client_meals_location_input, 
                     "HSCP were unable to provide Meals Services data for <br>", 
                     input$client_meals_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_people_supported_meals,
          
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
    }
    
    else{plot_ly(meals_data_filtered() %>%
                   filter(age_group != "Unknown"),
                 x = ~age_group,
                 y = ~rate,
                 type = "bar",
                 marker = phs_bar_col,      # colour of bars
                 
                 # add tooltip
                 
                 hoverinfo = "text",
                 hovertext = ~ paste0(
                   "Financial Year: ", financial_year,
                   "<br>",
                   "Location: ", sending_location,
                   "<br>",
                   "Age Group: ", age_group,
                   "<br>",
                   input$client_meals_measure_input, ": ", formatC(rate, format = "f", big.mark = ",", drop0trailing = TRUE),
                   "<br>",
                   "Number of People: ", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
                 )
    ) %>%
        layout(
          
          title = paste0("<b> People Supported through Social Care Services/Support, that also receive a Meals Service, <br> as a ",
                         input$client_meals_measure_input, " <br> in ",  input$client_meals_location_input, ", ",
                         input$client_meals_year_input, "."),
          
          
          # y axis
          
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 40),
              input$client_meals_measure_input,
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            showline = TRUE,
            separatethousands = TRUE,
            ticks = "outside"
          ),
          
          # x axis
          
          xaxis = list(
            title = paste0(c(
              rep("&nbsp;", 40),
              "Age Group",
              rep("&nbsp;", 40),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            showline = TRUE,
            ticks = "outside"
          ),
          margin = list(l = 10, r = 10, b = 70, t = 120) 
          
        ) %>%
        
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )}
  })
  
  
  ## TABLE ----
  
  data_people_supported_meals_table <- reactive({
    meals_data_filtered() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        rate,
        nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate    = format(rate, big.mark = ","))
  })
  
  observeEvent(input$client_meals_table_button, {
    toggle("ClientsMealsTable")
    output$table_client_meals <- DT::renderDataTable(DT::datatable(
      data_people_supported_meals_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "Age Group",
        input$client_meals_measure_input,
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
  
  
  ## DOWNLOAD DATA ---- 
  
  output$download_clients_meals <- downloadHandler(
    filename = "people_supported_meals.csv",
    content = function(file) {
      write.table(data_people_supported_meals %>%
                    select(financial_year, 
                           sending_location, 
                           age_group, 
                           measure,
                           rate,
                           nclient), 
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Measure",
                    "Rate",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  #####################################
  ## LIVING ALONE ----
  #####################################
  
  ## DATA ----
  
  data_living_alone_filtered <- reactive({
    data_people_supported_living_alone %>%
      filter(
        financial_year   == input$client_living_alone_year_input,
        age_group        == input$client_living_alone_age_input,
        measure          == input$client_living_alone_measure_input,
        !(is.na(living_alone))
      ) 
  })
  
  
  ## PLOT ----
  
  output$living_alone_plot <- renderPlotly({
    
    plot_ly(data_living_alone_filtered(),
            x = ~percentage,
            y = ~sending_location,
            type = "bar",
            split = ~living_alone,
            color = ~living_alone,
            colors = three_col_pal,
            
            
            ### tooltip
            
            hoverinfo = "text",
            hovertext = ~ paste0(
              "Financial Year: ", input$client_living_alone_year_input,
              "<br>",
              "Location: ", sending_location,
              "<br>",
              "Age Group: ", input$client_living_alone_age_input,
              "<br>",
              "Living Alone: ", living_alone,
              "<br>",
              input$client_living_alone_measure_input, ": ", percentage, " % ",
              "<br>",
              "Number of People: ", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            inherit = FALSE,
            showlegend = TRUE
    )  %>%
      
      layout(
        barmode = "stack",
        
        
        # x axis
        
        xaxis = list(
          title = input$client_living_alone_measure_input,
          showline = TRUE,
          ticks = "outside",
          ticksuffix = "%",
          rangemode = "tozero"
        ),
        
        # y axis
        
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
          autorange = "reversed",
          categoryorder = "trace" 
        ),
        
        
        ## legend
        
        legend = list(
          x = 0, y = -0.3,
          font = list(size = 14),
          traceorder = "normal"
        ),
        
        ## title
        
        title = paste0("<b>", input$client_living_alone_measure_input, " of Social Care Clients <br> who receive Social Care Services/Support that live alone, <br>",
                       input$client_living_alone_age_input, ", by Health & Social Care Partnership, ", input$client_living_alone_year_input, "."),
        
        
        margin = list(l = 10, r = 10, b = 20, t = 140)
        
      ) %>%
      
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
  })
  
  ## TABLE ----
  
  data_people_supported_living_alone_table <- reactive({
    data_living_alone_filtered() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        living_alone,
        percentage,
        nclient
      ) %>%
      mutate(
        percentage = format(percentage, big.marl = ","),
        nclient = format(nclient, big.mark = ",")
      )
  })
  
  observeEvent(input$client_living_alone_table_button, {
    toggle("client_living_alone_table")
    output$table_client_living_alone <- DT::renderDataTable(DT::datatable(
      data_people_supported_living_alone_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "Age Group",
        "Living Alone",
        paste0(input$client_living_alone_measure_input, " (%): "),
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
  
  ## DOWNLOAD DATA ----
  
  output$download_clients_living_alone <- downloadHandler(
    filename = "people_supported_living_alone.csv",
    content = function(file) {
      write.table(data_people_supported_living_alone %>%
                    select(financial_year, 
                           sending_location, 
                           age_group, 
                           living_alone,
                           measure,
                           percentage,
                           nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Living Alone",
                    "Measure",
                    "Value",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  #################################################-
  ### DATA COMPLETENESS -----
  #################################################-
  
  data_completeness_table_filtered <- reactive({
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
    DT::datatable(data_completeness_table_filtered(),
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
  
  ##################################################-
  
  ####  end server bracket ----
  
  
}