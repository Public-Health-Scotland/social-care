#####################################################
## Care Home Server Script ##
#####################################################


### Script creates buttons, plots and data tables to be passed to the user interface 
### this script creates required data outputs for the app based on user inputs (e.g drop down selections)
### Adapted from https://github.com/Health-SocialCare-Scotland/social-care 1718 
### Adapted for 1819 publication data - Jenny Armstrong July 2020
### Written/run on R Studio Server
### R version 3.5.1
### most recent update: 06/08/2020
##################################################



## code to password protect app - comment out if not required ##
## read in server credentials code from admin/create_credendentials.R ##
#credentials <- readRDS("admin/credentials.rds")  
################################################




### Server ----

function(input, output, session) {
  
  
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
  
  
  ######################################################################
  # X.1.1  People Supported In Care Homes - Resident Type (Short / Long Stay Split) (switched order) ----
  ######################################################################
  
  ## filter data ---- 
  
  data_care_home_resident_type_plot <- reactive({
    data_care_home_resident_type %>%
      filter(financial_year == input$ch_resident_type_year_input,
             age_group      == input$ch_resident_type_age_input,
             stay_type      == input$ch_resident_type_stay_input,
             measure        == input$ch_resident_type_measure_input)
  })
  
  ## plot ----
  
    output$ch_resident_type_plot <- renderPlotly({
      
    if (input$ch_resident_type_measure_input == "Rate per 1,000 People") {
        
    plot_ly(data_care_home_resident_type_plot() %>%
              filter(sending_location != "Scotland (All Areas Submitted)"),
            name = "Health and Social Care Partnership",
            y = ~sending_location,
            x = ~value,
            type = "bar",
            marker = phs_bar_col, # phs bar chart marker colour set in global.R script
         
            
            ### tool tip 
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", financial_year,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", input$ch_resident_type_age_input,
              "<br>",
              "Stay Length:", stay_type,
              "<br>",
              "HSCP",input$ch_resident_type_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Scotland",input$ch_resident_type_measure_input, ":",  formatC(value_scotland, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
  
        ### add scotland reference line
        
        add_trace(
          color = reference_line_style,  # scotland reference line colour set in global.R script
          name = "Scotland (All Areas Submitted)",
          x = ~value_scotland,
          y = ~sending_location,
          type = "scatter",
          mode = "line",
          hoverinfo = "text",
          text = ~ paste(
            "Financial Year:", financial_year,
            "<br>",
            "Location: Scotland (All Areas Submitted)",
            "<br>",
            "Age Group:", input$ch_resident_type_age_input,
            "<br>",
            "Stay Length:", stay_type,
            "<br>",
            "Scotland",input$ch_resident_type_measure_input, ":",  formatC(value_scotland, format = "f", big.mark = ",", drop0trailing = TRUE)
          ),
          inherit = FALSE,
          showlegend = TRUE
          
          ) %>%
            
      layout(
        barmode = "stack",
        
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
          categoryorder = "total ascending",
          categoryarray = ~value,
          showline = TRUE,
          ticks = "outside"
        ),
      
       
        
        ## x axis
        
        xaxis = list(
          title = input$ch_resident_type_measure_input,
          rangemode = "tozero",
          showline = TRUE,
          ticks = "outside",
          separatethousands = TRUE,
          eparators = ",",
          exponentformat = "none"
        ),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.25,
          font = list(size = 14)
        ),
        
        ## plot title 

        
        title = paste0("<b>", input$ch_resident_type_measure_input, " of ", 
                       input$ch_resident_type_stay_input, 
                       " Care Home Residents, <br> by Health and Social Care Partnerships, ",
                       input$ch_resident_type_age_input, ", ",
                       input$ch_resident_type_year_input, "."),
        
        margin = list(l = 80, r = 0, b = 70, t = 120)#,
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )

    } else {
    
      plot_ly(data_care_home_resident_type_plot() %>%
                filter(sending_location != "Scotland (All Areas Submitted)"),
              name = "Health and Social Care Partnership",
              y = ~sending_location,
              x = ~value,
              type = "bar",
              marker = phs_bar_col, # phs bar chart marker colour set in global.R script
              
              
              ### tool tip 
              
              hoverinfo = "text",
              text = ~ paste(
                "Financial Year:", financial_year,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Age Group:", input$ch_resident_type_age_input,
                "<br>",
                "Stay Length:", stay_type,
                "<br>",
                "HSCP",input$ch_resident_type_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE),
                "<br>",
                "Scotland",input$ch_resident_type_measure_input, ":",  formatC(value_scotland, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        
        layout(
          barmode = "stack",
          
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
           
            categoryorder = "total ascending",
            categoryarray = ~value,
            showline = TRUE,
            ticks = "outside"
          ),
          
         
          
          ## x axis
          
          xaxis = list(
            title = input$ch_resident_type_measure_input,
            rangemode = "tozero",
            showline = TRUE,
            ticks = "outside",
            separatethousands = TRUE,
            eparators = ",",
            exponentformat = "none"
          ),
          
          ## legend
          
          legend = list(
            x = 0, y = -0.25,
            font = list(size = 14)
          ),
          
          ## plot title 
         
          title = paste0("<b>", input$ch_resident_type_measure_input, " of ", 
                         input$ch_resident_type_stay_input, 
                         " Care Home Residents, <br> by Health and Social Care Partnerships, ",
                         input$ch_resident_type_age_input, ", ",
                         input$ch_resident_type_year_input, "."),
          
          margin = list(l = 80, r = 0, b = 70, t = 120)#,
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    }
      
    })

    
  
 
  ## Short / Long stay Table - hide/show button ----
    
    data_care_home_resident_type_table <- reactive({
      data_care_home_resident_type_plot() %>%
        select(
          financial_year,
          sending_location,
          age_group,
          stay_type,
          value
        ) %>%
        mutate(value = format(value, big.mark = ","))
    })
    
    observeEvent(input$ch_resident_type_showhide, {
      toggle("ch_resident_type_table")
      output$ch_resident_type_table_output <- 
        DT::renderDataTable(
          DT::datatable(data_care_home_resident_type_table(),
                        style = "bootstrap",
                        class = "table-bordered table-condensed",
                        rownames = FALSE,
                        colnames = c(
                                    "Financial Year",
                                    "Location",
                                    "Age Group",
                                    "Stay Type",
                                    input$ch_resident_type_measure_input),
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
    

  ## download data ----
    
    output$download_ch_resident_type_data <- downloadHandler(
      filename = "care_home_resident_type.csv",
      content = function(file) {
        write.table(data_care_home_resident_type, 
                    file,
                    row.names = FALSE,
                    col.names = c(
                      "Financial Year",
                      "Location",
                      "Age Group",
                      "Stay Type",
                      "Measure",
                      "Value",
                      "Scotland Value"
                    ),
                    sep = ","
        )
      }
    )
  
  
  
  #######################################################  
  # X.3.1 People Supported In Care Homes - Trend (switched order) ----
  #######################################################
  
  ## filter data ----
    
  data_care_home_trend_plot <- reactive({
    data_care_home_trend %>%
            filter(
            sending_location  == input$ch_trend_location_input,
            age_group         == input$ch_trend_age_input,
            measure           == input$ch_trend_measure_input,
            stay_type         == input$ch_trend_stay_input) 
  })
  
    ## Data for location comparison
    
    data_care_home_trend_comparison_plot <- reactive({
      data_care_home_trend %>%
        filter(
               sending_location  == input$ch_trend_location_comparison_input,
               age_group         == input$ch_trend_age_input,
               measure           == input$ch_trend_measure_input,
               stay_type         == input$ch_trend_stay_input) 
    })
    
    
  ## Trend plot ----
    
    output$ch_trend_plot <- renderPlotly({
      
        plot_ly(data_care_home_trend_plot(),
              x = ~financial_quarter,
              y = ~value,
              type = "scatter",                    # creates scatterplot
              mode = "lines+markers",                      # creates line graph
              line = trend_line_setting,           # trend_line_setting specified in global.R script    
              marker = trend_marker_setting,
              name = paste(input$ch_trend_measure_input, "in", input$ch_trend_location_input),
              
              ## Add tooltop information (text to appear when cursor hovers over a data point in the plot)
              
              hoverinfo = "text",
              text = ~ paste(
                "Financial Year Quarter:", financial_quarter,
                "<br>",
                "Location:", input$ch_trend_location_input,
                "<br>",
                input$ch_trend_measure_input, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        
        ## Add location Comparison line 
        
        add_trace(
          name = paste(input$ch_trend_measure_input ,"in", input$ch_trend_location_comparison_input),
          data = data_care_home_trend_comparison_plot(),
          x = ~financial_quarter,
          y = ~value,
          type = "scatter",
          mode = "lines+markers",
          marker = comparison_trend_marker_setting,
          line = comparison_trend_line_setting, # change settings in global.R script
          
          # Add tooltip for location comparison line
          
          hoverinfo = "text",
          text = ~ paste("Financial Year Quarter:", financial_quarter,
                         "<br>",
                         "Location:", input$ch_trend_location_comparison_input,
                         "<br>",
                         input$ch_trend_measure_input, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
          ),
          inherit = FALSE,
          showlegend = TRUE) %>%
        
        
        ## add COVID-19 reference line
        
        add_trace(name = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                  data = rbind(data_care_home_trend_plot(), data_care_home_trend_comparison_plot()),
                  type = "scatter",
                  mode = "line",
                  color = reference_line_style, 
                  x = "2019/20 Q4",
                  y = ~c(0,max(value)),
                  hoverinfo = "text",
                  text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                  inherit = FALSE) %>%
        
        layout(
          
          ## Y axis specifications 
          
          yaxis = list(
            title = paste0(c(
              rep("&nbsp;", 30),
              input$ch_trend_measure_input,
              rep("&nbsp;", 30),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            showline = TRUE,
            exponentformat = "none",
            ticks = "outside",
            tickmode = "array",
            rangemode = "tozero" 
             ),
          
          # x axis
          
          xaxis = list(
            type = "category",
            title = "Financial Quarter",
            tickangle = -45,
            tickmode = "array",
            showline = TRUE,
            ticks = "outside",
            showgrid = FALSE
          ),
          
          ## legend
          
          legend = list(
            x = 0, y = -1,
            font = list(size = 14)
          ),
          
          # title

          title = if_else(input$ch_trend_location_input == input$ch_trend_location_comparison_input,
                          paste0("<b>", input$ch_trend_measure_input, " of ", 
                          input$ch_trend_stay_input, 
                          " Care Home Residents, <br>", input$ch_trend_location_input, ", ",
                          input$ch_trend_age_input, ", by Quarter 2017/18 - 2020/21."),
                          paste0("<b>", input$ch_trend_measure_input, " of ", 
                                 input$ch_trend_stay_input, 
                                 " Care Home Residents, <br>", input$ch_trend_location_input, " and ",
                                 input$ch_trend_location_comparison_input, ", ",
                                 input$ch_trend_age_input, ",<br> by Quarter 2017/18 - 2020/21.")
                          ),
          
           margin = list(l = 10, r = 10, b = 40, t = 120)) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    })
    
 
  ## trend table - show/hide ----
  
    data_care_home_trend_table <- reactive({
      if(input$ch_trend_location_input == input$ch_trend_location_comparison_input){
        data_care_home_trend_plot() %>%
          select(financial_quarter, sending_location, age_group, stay_type, value) %>%
          mutate(
            value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
      } else{
        rbind(data_care_home_trend_plot(),data_care_home_trend_comparison_plot()) %>%
          select(financial_quarter, sending_location, age_group, stay_type, value) %>%
          mutate(
            value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
      }
    })
    
    
  observeEvent(input$ch_trend_showhide, {
    toggle("ch_trend_table")
    output$ch_trend_table_output <- DT::renderDataTable(DT::datatable(data_care_home_trend_table(),
                                                               style = "bootstrap",
                                                                   class = "table-bordered table-condensed",
                                                                   rownames = FALSE,
                                                                   colnames = c(
                                                                     "Financial Year Quarter",
                                                                     "Location",
                                                                     "Age Group",
                                                                     "Stay Type",
                                                                     input$ch_trend_measure_input
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
  
  
  ## download data ----
  
  output$download_ch_trend_data <- downloadHandler(
    filename = "care_home_trend.csv",
    content = function(file) {
      write.table(data_care_home_trend,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year Quarter",
                    "Location",
                    "Age Group",
                    "Stay Type",
                    "Measure",
                    "Value"
                  ),
                  sep = ","
      )
    }
  )
  
  
  ##################################################
  # X.3.2 Age and Sex of Care Home Residents ----
  ##################################################
    
  # Age/Sex Tab data ----
  
  # Create Reactive Dataset for Age/Sex
  data_care_home_age_sex_plot <- reactive({
    data_care_home_age_sex %>%
      filter(financial_year   == input$ch_age_sex_year_input,
             sending_location == input$ch_age_sex_location_input,
             stay_type        == input$ch_age_sex_stay_input,
             sex              != "Not Known / Unspecified",
             age_group        != "Unknown"
             ) %>%
      mutate(value = ifelse(sex == "Female", rate * -1, rate)
             )
  })
    
    
  # Age/Sex Tab plot ----
  
  output$ch_age_sex_plot <- renderPlotly({
      plot_ly(data_care_home_age_sex_plot(), 
                x = ~value,
                y = ~age_group,
                color = ~as.factor(sex),
                colors = palette_agesex_plot,
                type = "bar",
                orientation = "h",
              
            # add tooltip
            hoverinfo = "text",
            text = ~ paste(
            "Financial Year:", input$ch_age_sex_year_input,
            "<br>",
            "Location:", input$ch_age_sex_location_input,
            "<br>",
            "Gender:", sex,
            "<br>",
            "Age Group:", age_group,
            "<br>",
            "Rate per 1,000 Care Home Residents:", formatC(abs(value), format = "f", big.mark = ",", drop0trailing = TRUE),
            "<br>",
            "Number of Care Home Residents:", formatC(abs(nclient), format = "f", big.mark = ",", drop0trailing = TRUE))
                       
             ) %>% 
        
        layout(
          bargap = 0.2,
          barmode = "overlay",
          
          ## Y AXIS
          
          yaxis = list(
            type = "category",
            title = paste0(c(
              rep("&nbsp;", 30),
              "Age Group",
              rep("&nbsp;", 30),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            showline = TRUE,
            ticks = "outside"
          ),
          
          
          ## x axis
          
          xaxis = list(
            title = "Rate per 1,000 of Care Home Residents",
            showline = TRUE,
            exponentformat = "none",
            separatethousands = TRUE,
            tickmode = 'array',
            ticks = "outside",
            tickangle = 0,
            tickvals = c(-550, -450, -350, -250, -150, -50, 0, 50, 150, 250, 350),
            ticktext = c("550", "450", "350", "250", "150", "50", "0", "50", "150", "250", "350")
          ),
          
          ## legend
          
          legend = list(
            x = 120, y = 0.5,
            font = list(size = 15)
          ) ,
          
          ## plot title 
          
          title = paste0("<b> Rate per 1,000 of ", input$ch_age_sex_stay_input,
                         " Care Home Residents supported <br> in ", input$ch_age_sex_location_input,
                         " by Age and Sex, ", input$ch_age_sex_year_input, ". "),
          
          margin = list(l = 10, r = 10, b = 70, t = 120)#,
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    })
  
  # Age/Sex Table - hide/show button ----
  
  
  data_care_home_age_sex_table <- reactive({
    data_care_home_age_sex %>%
      filter(financial_year   == input$ch_age_sex_year_input,
             sending_location == input$ch_age_sex_location_input,
             stay_type        == input$ch_age_sex_stay_input
             ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             rate = format(rate, big.mark = ","))
  })  
    
  observeEvent(input$ch_age_sex_showhide, {
    toggle("ch_age_sex_table")
    output$ch_age_sex_table_output <- DT::renderDataTable(DT::datatable(data_care_home_age_sex_table(),
                                                                style = "bootstrap",
                                                                class = "table-bordered table-condensed",
                                                                rownames = FALSE,
                                                                colnames = c(
                                                                  "Financial Year",
                                                                  "Location",
                                                                  "Stay Type",
                                                                  "Age Group",
                                                                  "Sex",
                                                                  "Rate per 1,000 Residents",
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
  
  # download data ----  
    
  output$download_ch_age_sex_data <- downloadHandler(
    filename = "care_home_age_sex.csv",
    content = function(file) {
      write.table(data_care_home_age_sex,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Stay Type",
                    "Age Group",
                    "Sex",
                    "Rate per 1,000 Residents",
                    "Number of Residents"
                  ),
                  sep = ","
      )
    }
  )
  
  
  ##################################################
  # X.3.4 Median Length of Stay In Care Home ----
  ################################################
 
  ## filter data ----
   # Length of Stay data 
  
  data_care_home_length_of_stay_filtered <- reactive({
    data_care_home_length_of_stay %>%
      filter(financial_year == input$ch_los_year_input,
             age_group      == input$ch_los_age_input) 
  })
    
  ## plot -----
  
  # Length of Stay Chart
  output$ch_los_plot <- renderPlotly({
    plot_ly(data_care_home_length_of_stay_filtered() %>%
              filter(sending_location != "Scotland (All Areas Submitted)"),
            name = "Health and Social Care Partnership",
            y = ~sending_location,
            x = ~median_los,
            type = "bar",
            marker = phs_bar_col, # phs bar chart marker colour set in global.R script
            
            ### tooltip information
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", input$ch_los_year_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", input$ch_los_age_input,
              "<br>",
              "Stay Type:", stay_type,
              "<br>",
              "Median Length of Stay (days):", median_los,
              "<br>",
              "Scotland Median Length of Stay (days):", scotland_median_los
            ),
            showlegend = TRUE
    ) %>%
      
     add_trace(
         color =  reference_line_style,  # scotland reference line colour set in global.R script
         name = "Scotland (All Areas Submitted)",
         x = ~scotland_median_los,
         y = ~sending_location,
         type = "scatter",
         mode = "line",
         # tooltip

         hoverinfo = "text",
         text = ~ paste(
           "Financial Year:", input$ch_los_year_input,
           "<br>",
           "Location: Scotland (All Areas Submitted)",
           "<br>",
           "Age Group:", input$ch_los_age_input,
           "<br>",
           "Stay Type:", stay_type,
           "<br>",
           "Median Length of Stay (days):", scotland_median_los
         ),
         inherit = FALSE,
         showlegend = FALSE) %>%
      layout(
        
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
          categoryarray = ~median_los
        ),
        
        ## x AXIS
        
        xaxis = list(
          title = "Median Length of Stay (days)",
          showline = TRUE,
          separatethousands = TRUE,
          ticks = "outside"
        ),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.25,
          font = list(size = 14)
        ),
        
        ## title 
        
        title = paste0("<b> Median Length of Stay (days) for  <br> Long Stay Care Home Residents, ",
                       input$ch_los_age_input, ", ", input$ch_los_year_input, "."),
        
        margin = list(l = 10, r = 10, b = 70, t = 120)
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  
  ## Length of Stay - show/hide ----
  
  data_care_home_los_table <- reactive({
    data_care_home_length_of_stay_filtered() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        stay_type,
        median_los
      ) %>%
      mutate(median_los = format(median_los, big.mark = ","))
  })

  observeEvent(input$ch_los_showhide, {
    toggle("ch_los_table")
    output$ch_los_table_output <- DT::renderDataTable(DT::datatable(data_care_home_los_table(),
                                                                      style = "bootstrap",
                                                                      class = "table-bordered table-condensed",
                                                                      rownames = FALSE,
                                                                      colnames = c(
                                                                        "Financial Year",
                                                                        "Location",
                                                                        "Age Group",
                                                                        "Stay Type",
                                                                        "Median Length of Stay (days)"),
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
  
  ## download data ----
  
  output$download_ch_los_data <- downloadHandler(
    filename = "care_home_length_of_stay.csv",
    content = function(file) {
      write.table(data_care_home_length_of_stay,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Stay Type",
                    "Median Length of Stay (days)",
                    "Scotland Median Length of Stay (days)"
                  ),
                  sep = ","
      )
    }
  )
  
  #######################################
  ## X.3.5 Need For Nursing Care ----
  #########################################
  
  ## filter data ----
  # Nursing Care data 
  
  data_care_home_nursing_care_filtered <- reactive({
    data_care_home_nursing_care %>%
      filter(financial_year   == input$ch_nursing_year_input,
             age_group        == input$ch_nursing_age_input)
        })
  
  
  ## plot data ----
  # Nursing Care Chart
  
  output$ch_nursing_plot <- renderPlotly({
    plot_ly(data_care_home_nursing_care_filtered(),
            x = ~propn_nc_provision,
            y = ~sending_location,
            type = "bar",
            split = ~nursing_care_provision,
            color = ~nursing_care_provision,
            colors = two_col_pal,
            
            ### tooltip
            
            hoverinfo = "text",
            text = ~ paste(
              nursing_care_provision,
              "<br>",
              "Financial Year:", input$ch_nursing_year_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group: ", input$ch_nursing_age_input,
              "<br>",
              "Percentage of Residents:", propn_nc_provision, "%",
              "<br>",
              "Number of Residents:", number_nc_provision
            )
    ) %>%
      layout(
        barmode = "stack",
        
        ##### x axis
        
        xaxis = list(
          title = "Percentage of Care Home Residents",
          showline = TRUE,
          ticks = "outside",
          ticksuffix = "%",
          rangemode = "tozero"
        ),
        
         ### y axis
        
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
          categoryorder = "trace",
          autorange = "reversed"
          ),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.25,
          font = list(size = 14)
        ),
        
        ## plot title
        
        title = paste0("<b> Percentage of Long Stay Care Home Residents by Nursing Care Need <br> and Health and Social Care Partnership, ", 
                       input$ch_nursing_age_input, ", ", input$ch_nursing_year_input, ".", tags$sup("R", style="color:red")),
        
        margin = list(l = 10, r = 10, b = 50, t = 100)
       
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
  })
  
  ## show / hide data table ----
  # Nursing Care Table
  
  data_care_home_nursing_table <- reactive({
    data_care_home_nursing_care_filtered() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        nursing_care_provision,
        propn_nc_provision,
        number_nc_provision
      ) %>%
      mutate(number_nc_provision = format(number_nc_provision, big.mark = ","),
             propn_nc_provision = format(propn_nc_provision, big.mark = ","))
  })
  
  observeEvent(input$ch_nursing_showhide, {
    toggle("ch_nursing_table")
    output$ch_nursing_table_output <- DT::renderDataTable(DT::datatable(data_care_home_nursing_table(), 
                                                                        style = "bootstrap",
                                                               class = "table-bordered table-condensed",
                                                               rownames = FALSE,
                                                               colnames = c(
                                                                 "Financial Year",
                                                                 "Location",
                                                                 "Age Group",
                                                                 "Nursing Care Provision",
                                                                 "Percentage of Care Home Residents",
                                                                 "Number of Care Home Residents"
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
  
  ## download data ----
    
  output$download_ch_nursing_data <- downloadHandler(
    filename = "care_home_nursing_care.csv",
    content = function(file) {
      write.table(data_care_home_nursing_care %>%
                    select(financial_year, sending_location, age_group, nursing_care_provision, propn_nc_provision, number_nc_provision),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Nursing Care Provision",
                    "Percentage of Residents",
                    "Number of Residents"
                  ),
                  sep = ","
      )
    }
  )
  
  ###########################################
  # X.3.6 Emergency care ----
  ###########################################
 
  ## Admissions Data ----
  
  data_care_home_emergency_care_plot <- reactive({
    data_care_home_emergency_care %>%
      filter(
        financial_quarter == input$ch_emergency_year_input,
        age_group         == input$ch_emergency_age_input,
        measure           == input$ch_emergency_measure_input)
  })
  
  ## plot ----  
    
  output$ch_emergency_plot <- renderPlotly({
    plot_ly(data_care_home_emergency_care_plot() %>%
      filter(sending_location != "Scotland (All Areas Submitted)"),
        name = "Health and Social Care Partnership",
        y = ~sending_location,
        x = ~rate,
        type = "bar",
        marker = phs_bar_col,
        
        #### tooltip
        
        hoverinfo = "text",
        text = ~ paste(
          "Financial Quarter:", input$ch_emergency_year_input,
          "<br>",
          "Location:", sending_location,
          "<br>",
          "Age Group:", input$ch_emergency_age_input,
          "<br>",
          "Rate per 1,000 Residents:", rate,
          "<br>",
          "Number of", input$ch_emergency_measure_input, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
        )
        
      
      ) %>%
      
      add_trace(
        color = reference_line_style,  # scotland reference line colour set in global.R script
        name = "Scotland (All Areas Submitted)",
        x = ~scotland_rate,
        y = ~sending_location,
        type = "scatter",
        mode = "line",
        hoverinfo = "text",
        text = ~ paste(
          "Financial Quarter:", input$ch_emergency_year_input,
          "<br>",
          "Location: Scotland (All Areas Submitted)", 
          "<br>",
          "Age Group:", input$ch_emergency_age_input,
          "<br>",
          "Rate per 1,000 residents:", scotland_rate,
          "<br>",
          "Number of", input$ch_emergency_measure_input, ":", formatC(scotland_value, format = "f", big.mark = ",", drop0trailing = TRUE)
         
             ),
        inherit = FALSE,
        showlegend = TRUE
      ) %>%
      layout(
        barmode = "stack",
        
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
          categoryarray = ~rate
        ),
        
        xaxis = list(
          title = ~ paste(input$ch_emergency_measure_input, "Rate per 1,000 Care Home Residents"),
          #titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.25,
          font = list(size = 14)
        ),
        
        
        title = paste0("<b>", input$ch_emergency_measure_input, 
                       " per 1,000 Long Stay Care Home Residents <br> by Health and Social Care Partnership, ",
                       input$ch_emergency_age_input, ", ", input$ch_emergency_year_input, "."),
        
        margin = list(l = 10, r = 10, b = 70, t = 100)
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
  })
  
  ## Admissions Table - show/hide -----
  
  data_care_home_emergency_table <- reactive({
    data_care_home_emergency_care_plot() %>%
      select(
        financial_quarter,
        sending_location,
        age_group,
        rate,
        value
      ) %>%
      mutate(value = format(value, big.mark = ","),
             rate  = format(rate, big.mark = ","))
  })
  
  
  observeEvent(input$ch_emergency_showhide, {
    toggle("ch_emergency_table")
    output$ch_emergency_table_output <- DT::renderDataTable(DT::datatable(
      data_care_home_emergency_table(), 
      style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Financial Quarter",
                                                                      "Location",
                                                                      "Age Group",
                                                                      "Rate per 1,000 Residents",
                                                                      input$ch_emergency_measure_input
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

  ## download data -----
  
  output$download_ch_emergency_data <- downloadHandler(
    filename = "care_home_emergency_care.csv",
    content = function(file) {
      write.table(data_care_home_emergency_care %>%
                    select(financial_quarter, sending_location, age_group, measure, rate, value, scotland_rate, scotland_value),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Measure",
                    "Rate Per 1,000 Residents",
                    "Value",
                    "Scotland Rate",
                    "Scotland Value"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  
  ###################################################
  ## Tab 3.3: Referral Source ---- moved 
  ###################################################  
  ## filter data ----
    
    
    data_care_home_referral_source_filtered <- reactive({
      data_care_home_referral_source %>%
        filter(financial_quarter   == input$ch_referral_year_input,
               age_group        == input$ch_referral_age_input) 
               
    })
    
  ## plot data ----
    
    output$ch_referral_plot <- renderPlotly({
      plot_ly(data_care_home_referral_source_filtered(),
              x = ~percentage,
              y = ~sending_location,
              type = "bar",
              split = ~referral_source,
              color = ~referral_source,
              colors = five_col_pal,
              
              ### tooltip
              
              hoverinfo = "text",
              text = ~ paste(
                #referral_source_provision,
                #"<br>",
                "Financial Year:", input$ch_referral_year_input,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Age Group: ", input$ch_referral_age_input,
                "<br>",
                "Referral Source:", referral_source,
                "<br>",
                "Percentage of Referrals:", percentage, "%",
                "<br>",
                "Number of Referrals:", referrals
              )
      ) %>%
        layout(
          barmode = "stack",
          
          ##### x axis
          
          xaxis = list(
            title = "Percentage of Care Home Residents",
            showline = TRUE,
            ticks = "outside",
            ticksuffix = "%",
            rangemode = "tozero"
          ),
          
          ### y axis
          
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
            categoryorder = "trace",
            autorange = "reversed" #,
            
          ),
          
          ## legend
          
          legend = list(
            x = 0, y = -0.4,
            font = list(size = 14),
            traceorder = "normal"
          ),
          
          ## plot title
          
          title = paste0("<b> Percentage of Long Stay Care Home Residents by <br> Hospital Referral Source and Health and Social Care Partnership, <br>",
                         input$ch_referral_age_input, ", ", input$ch_referral_year_input, "."),
          
          margin = list(l = 10, r = 10, b = 0, t = 130)
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F, 
          editable = F
        )
    })
    
  ## show / hide data table ----
  
  data_care_home_referral_table <- reactive({
    data_care_home_referral_source_filtered() %>%
      select(
        financial_quarter,
        sending_location,
        age_group,
        referral_source,
        percentage,
        referrals
      ) %>%
      mutate(percentage = format(percentage, big.mark = ","),
             referrals  = format(referrals, big.mark = ","))
  })
  
    observeEvent(input$ch_referral_showhide, {
       toggle("ch_referral_table")
       output$ch_referral_table_output <- DT::renderDataTable(DT::datatable(data_care_home_referral_table(), 
                                                                  style = "bootstrap",
                                                                  class = "table-bordered table-condensed",
                                                                  rownames = FALSE,
                                                                  colnames = c(
                                                                    "Financial Year",
                                                                    "Location",
                                                                    "Age Group",
                                                                    "Referral Source",
                                                                    "Percentage of Referrals",
                                                                    "Number of Referrals"
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
     
  ## download data ----
     
     output$download_ch_referral_data <- downloadHandler(
       filename = "care_home_referral_source.csv",
       content = function(file) {
         write.table(data_care_home_referral_source %>%
                       select(financial_quarter, 
                              sending_location, 
                              age_group, 
                              referral_source,
                              percentage,
                              referrals,
                              scotland_percentage,
                              scotland_referrals),
                     file,
                     row.names = FALSE,
                     col.names = c(
                       "Financial Year",
                       "Location",
                       "Age Group",
                       "Referral Source",
                       "Percentage of Residents", 
                       "Number of Referrals",
                       "Scotland Percentage",
                       "Scotland Referrals"
                     ),
                   sep = ","
         )
       }
     )
    
    
  ###############################################
  # X.3.7 Level of Independence ioRN Care Home ----
  ################################################
  
  ## filter data ----
  data_care_home_iorn_filtered <- reactive({
    data_care_home_iorn %>%
      filter(
             financial_year   == input$ch_iorn_year_input,
             sending_location == input$ch_iorn_location_input
      )
  })
  
  
  ## plot data -----
  
  output$ch_iorn_plot <- renderPlotly({
    plot_ly(data_care_home_iorn_filtered(),
            x = ~iorn_group,
            y = ~propn_iorn,
            type = "bar",
            marker = phs_bar_col, # phs bar chart marker colour set in global.R script
            
            ### tooltip
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", input$ch_iorn_year_input,
              "<br>",
              "Location:", input$ch_iorn_location_input,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "% of IoRN:", propn_iorn, "%"
            )
    ) %>%
      layout(
        
        # plot title 
        
        title = paste0("<b> Percentage of all funded Care Home Residents <br> by pre-admission IoRN Group, ",
                       input$ch_iorn_location_input, ", ", input$ch_iorn_year_input, "."),
        
        margin = list(l = 10, r = 10, b = 70, t = 120),

        ###  x axis
        
        xaxis = list(
          title = "IoRN Group",
          showline = TRUE,
          ticks = "outside"
          #titlefont = f2,
         
        ),
        
        ## y axis
        
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Percentage by IoRN Group",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          showline = TRUE,         # y axis plot line to appear
          ticks = "outside",       # tick marks to appear outside of plot
          ticksuffix = "%",        # labels to have % after number
          rangemode = "tozero",    # axis minimum value to always = 0
          nticks = 6,              # number of axis tick marks
          range = c(0, 100)        # tick marks to range from 0 to 100
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
  
  data_care_home_iorn_table <- reactive({
    data_care_home_iorn_filtered() %>%
      select(financial_year, 
             sending_location,  
             iorn_group, 
             propn_iorn,
             nclient
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             propn_iorn = format(propn_iorn, big.mark = ","))
  })
  
  observeEvent(input$ch_iorn_showhide, {
    toggle("ch_iorn_table")
    output$ch_iorn_table_output <- DT::renderDataTable(DT::datatable(
      data_care_home_iorn_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
        "Financial Year",
        "Location",
        "ioRN Group",
        "Percentage of People with IoRN",
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
  
  
  ## download data ----
  
  output$download_ch_iorn_data <- downloadHandler(
    filename = "care_home_ioRN.csv",
    content = function(file) {
      write.table(data_care_home_iorn %>%
                    select(financial_year, sending_location, iorn_group, propn_iorn, nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year", 
                    "Location",
                    "ioRN Group",
                    "Percentage of People in IoRN Group",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  
}

## END OF SCRIPT 
