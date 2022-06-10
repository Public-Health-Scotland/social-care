#####################################################
## Home Care Server Script ##
####################################################


### Script creates buttons, plots and data tables to be passed to the user interface 
### this script creates required data outputs for the app based on user inputs (e.g drop down selections)
### Adapted from https://github.com/Health-SocialCare-Scotland/social-care 1718 
### Adapted for 1819 publication data - Jenny Armstrong July 2020
### Written/run on R Studio Server
### R version 3.5.1
### most recent update: 29/11/2021
##################################################




# code to password protect app - comment out if not required ##
## read in server credentials code from admin/create_credendentials.R ##
#credentials <- readRDS("admin/credentials.rds")  
################################################



### Server ----

server <- function(input, output, session) {
  
  
  # shiny manager code required for password protection 
  #########################
  ## SHINY MANAGER ##
  #########################
   #res_auth <- shinymanager::secure_server(
  #   check_credentials = shinymanager::check_credentials(credentials)
  # )
   
   #output$auth_output <- renderPrint({
  #   shiny::reactiveValuesToList(res_auth)
  # })
  ################################################
  
  
  ### HOME CARE SECTION ----
  
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
  

  
  #################################################
  # X.2.1 Trend in Home Care Numbers and Hours ----
  #################################################
  ## Trend Data ----
  
  data_homecare_trend_plot <- reactive({
    data_homecare_trend %>%
      filter(time_period      == input$hc_trend_time_period_input,
             sending_location == input$hc_trend_location_input,
             measure          == input$hc_trend_measure_input,
             age_group        == "All Ages")
   
     })
  
  
  ## comparison data 
  
  data_homecare_trend_comparator <- reactive({
    data_homecare_trend %>%
      filter(time_period      == input$hc_trend_time_period_input,
             sending_location == input$hc_trend_comparator_location_input,
             measure          == input$hc_trend_measure_input,
             age_group        == "All Ages")
  })
  
  
  ## Trend plot -----
  
  output$hc_trend_plot <- renderPlotly({
    
    if (input$hc_trend_time_period_input == "Financial Quarter") {
                          plot_ly(data_homecare_trend_plot(),
                                    x = ~financial_quarter,
                                    y = ~value,
                                    type = "scatter",
                                    mode = "lines+markers",
                                    line = trend_line_setting,
                                    marker = trend_marker_setting,
            
            ### Add tooltip (text box to appear when hovering over data point)
            
            hoverinfo = "text",
            text = ~ paste(
              input$hc_trend_time_period_input," :", financial_quarter,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", age_group,
              "<br>",
            input$hc_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            name = paste(input$hc_trend_measure_input, "in",input$hc_trend_location_input)
    ) %>%
      
      ## Add location Comparison line 
      
      add_trace(
        name = paste(input$hc_trend_measure_input, "in",input$hc_trend_comparator_location_input),
        data = data_homecare_trend_comparator(),
        x = ~financial_quarter,
        y = ~value,
        type = "scatter",
        mode = "lines+markers",
        line = comparison_trend_line_setting, # black dashed line
        marker = comparison_trend_marker_setting,
        
        # Add tooltip for Comparator reference line
        
        hoverinfo = "text",
        text = ~ paste(
                       input$hc_trend_time_period_input, ":", financial_quarter,
                       "<br>",
                       "Location:", input$hc_trend_comparator_location_input,
                       "<br>",
                       "Age Group:", age_group,
                       "<br>",
                       input$hc_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
                       ),
        inherit = FALSE,
        showlegend = TRUE) %>%
      
      ## add COVID-19 reference line
      
      add_trace(name = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                data = rbind(data_homecare_trend_plot(), data_homecare_trend_comparator()),
                type = "scatter",
                mode = "line",
                color = reference_line_style, 
                x = "2019/20 Q4",
                y = ~c(0,max(value)),
                hoverinfo = "text",
                text = "Start of the COVID-19 Pandemic - 2019/20 Q4",
                inherit = FALSE) %>%
      
      ### Specify axis settings and names
      
      layout(
        
        ## Y AXIS
        
        yaxis = list(
          rangemode = "tozero",
          title = paste0(c(
            rep("&nbsp;", 30),
            input$hc_trend_measure_input,
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          separatethousands = TRUE,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        
        ## X AXIS

        xaxis = list(
          title = list(text = input$hc_trend_time_period_input, standoff = 30L), 
          tickangle = -45,
          showline = TRUE,
          type = "category",
          ticks = "outside",
          showgrid = FALSE
        ),
        
        
        ### PLOT TITLE 
        
        title =
              ifelse(input$hc_trend_location_input == input$hc_trend_comparator_location_input,

                     paste0("<b>", input$hc_trend_measure_input, " receiving Home Care in ",
                                   input$hc_trend_location_input, " <br> during ",
                                   input$hc_trend_time_period_input, " ",first_quarter, " - ", last_quarter, ".", tags$sup("R", style="color:red")),
                     
                      paste0("<b>", input$hc_trend_measure_input, " receiving Home Care in ",
                                   input$hc_trend_location_input, " and <br>", input$hc_trend_comparator_location_input, 
                                   " during ", input$hc_trend_time_period_input, " ", first_quarter, " - ", last_quarter, ".", tags$sup("R", style="color:red"))

                     ),

        ## legend
        
        legend = list(
          x = 0, y = -0.8,
          font = list(size = 14)
        ),
        
        margin = list(l = 100, r = 10, b = 0, t = 100)
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
    } else {
      
      plot_ly(data_homecare_trend_plot(),
              x = ~financial_quarter,
              y = ~value,
              type = "scatter",
              mode = "lines+markers",
              line = trend_line_setting,
              marker = trend_marker_setting,
              
              ### Add tooltip (text box to appear when hovering over data point)
              
              hoverinfo = "text",
              text = ~ paste(
                input$hc_trend_time_period_input," :", financial_quarter,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Age Group:", age_group,
                "<br>",
                input$hc_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
              ),
              name = paste(input$hc_trend_measure_input, "in",input$hc_trend_location_input)
      ) %>%
        
        ## Add location Comparison line 
        
        add_trace(
          name = paste(input$hc_trend_measure_input, "in",input$hc_trend_comparator_location_input),
          data = data_homecare_trend_comparator(),
          x = ~financial_quarter,
          y = ~value,
          type = "scatter",
          mode = "lines+markers",
          line = comparison_trend_line_setting, # black dashed line
          marker = comparison_trend_marker_setting,
          
          # Add tooltip for Comparator reference line
          
          hoverinfo = "text",
          text = ~ paste(
            input$hc_trend_time_period_input, ":", financial_quarter,
            "<br>",
            "Location:", input$hc_trend_comparator_location_input,
            "<br>",
            "Age Group:", age_group,
            "<br>",
            input$hc_trend_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
          ),
          inherit = FALSE,
          showlegend = TRUE) %>%
        
        ## add COVID-19 reference line
        
        add_trace(name = "Start of the COVID-19 Pandemic - March 2020",
                  data = rbind(data_homecare_trend_plot(), data_homecare_trend_comparator()),
                  type = "scatter",
                  mode = "line",
                  color = reference_line_style, 
                  x = "2020/21",
                  y = ~c(0,max(value)),
                  hoverinfo = "text",
                  text = "Start of the COVID-19 Pandemic - March 2020",
                  inherit = FALSE) %>%
        
        ### Specify axis settings and names
        
        layout(
          
          ## Y AXIS
          
          yaxis = list(
            rangemode = "tozero",
            title = paste0(c(
              rep("&nbsp;", 30),
              input$hc_trend_measure_input,
              rep("&nbsp;", 30),
              rep("\n&nbsp;", 1)
            ),
            collapse = ""
            ),
            separatethousands = TRUE,
            exponentformat = "none",
            showline = TRUE,
            ticks = "outside"
          ),
          
          ## X AXIS
          
          xaxis = list(
            title = list(text = input$hc_trend_time_period_input, standoff = 30L), 
            tickangle = -45,
            showline = TRUE,
            type = "category",
            ticks = "outside",
            showgrid = FALSE
          ),
          
          
          ### PLOT TITLE 
          
          title =
            ifelse(input$hc_trend_location_input == input$hc_trend_comparator_location_input,
                   
                   paste0("<b>", input$hc_trend_measure_input, " receiving Home Care in ",
                                 input$hc_trend_location_input, "<br> during Census Week, March ",
                                 first_census_week, " - ", last_census_week, ".", tags$sup("R", style="color:red")),
                   
                   paste0("<b>", input$hc_trend_measure_input, " receiving Home Care in ",
                                 input$hc_trend_location_input, " and <br>", input$hc_trend_comparator_location_input, 
                                 " during Census Week, March ",
                                 first_census_week, " - ", last_census_week, ".", tags$sup("R", style="color:red"))
                   
            ),
          
          ## legend
          
          legend = list(
            x = 0, y = -0.8,
            font = list(size = 14)
          ),
          
          margin = list(l = 100, r = 10, b = 0, t = 100)
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
      
    }
  })
  

  ## Trend table show/hide ----
  
  data_hc_trend_table <- reactive({
    if(input$hc_trend_location_input == input$hc_trend_comparator_location_input){
      data_homecare_trend_plot() %>%
        select(financial_quarter, sending_location, age_group, value) %>%
        mutate(
          value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    } else{
      rbind(data_homecare_trend_plot(), data_homecare_trend_comparator()) %>%
        select(financial_quarter, sending_location, age_group, value) %>%
        mutate(
          value = formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE))
    }
  })
  
  
  observeEvent(input$hc_trend_showhide, {
    toggle("hc_trend_table")
    output$hc_trend_table_output <- DT::renderDataTable(DT::datatable(data_hc_trend_table(),
      style = "bootstrap",
      class = "table-bordered table-condensed",
      rownames = FALSE,
      colnames = c(
      input$hc_trend_time_period_input, 
      "Location",
      "Age Group",
      input$hc_trend_measure_input
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
  
  ## download data -----
  
  output$download_homecare_trend_data <- downloadHandler(
    filename = "homecare_trend.csv",
    content = function(file) {
      write.table(data_homecare_trend %>%
                    select(time_period, financial_quarter, sending_location, age_group, measure, value),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    "Year / Quarter",
                    "Location",
                    "Age Group",
                    "Measure",
                    "Value"
                  ),
                  sep = ","
      )
    }
  )
  

  ####################################################
  # X.2.2 Home Care Numbers and Hours by HSCP ----
  ####################################################
  ## data ----
  data_homecare_hscp_filtered <- reactive({
    data_homecare_hscp %>%
      filter(
        time_period == input$hc_hscp_time_period_input_1,
        age_group   == input$hc_hscp_age_group,  
        measure     == input$hc_hscp_measure_input
             )
  })

  output$hc_financial_year_1 <- renderUI({
    shinyWidgets::pickerInput("hc_financial_year_1_X",
                              "Select Year / Quarter:",
                              choices = unique(data_homecare_hscp_filtered()$financial_quarter),
                              selected = c("2020/21 Q4", "2020/21"))
  })

  data_homecare_hscp_plot_X <- reactive({
    data_homecare_hscp %>%
      filter(time_period == input$hc_hscp_time_period_input_1,
             age_group   == input$hc_hscp_age_group,  
             measure     == input$hc_hscp_measure_input,
             financial_quarter == input$hc_financial_year_1_X)
  })
  
  
  ## hscp plot ----
  
  output$hc_hscp_plot <- renderPlotly({
    
    if (input$hc_hscp_measure_input == "Rate per 1,000 Population") {
      
          plot_ly(data_homecare_hscp_plot_X() %>%
                 filter(sending_location != "Scotland (Estimated)"), 
                 y = ~sending_location,
                 x = ~as.numeric(value),
                 name = "Health and Social Care Partnership",
                 type = "bar",
                 marker = phs_bar_col,
              
              ### add tooltip to plot
              
              hoverinfo = "text",
              text = ~ paste(
                input$hc_hscp_time_period_input_1,":", input$hc_financial_year_1_X,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Age Group:", age_group,
                "<br>",
                input$hc_hscp_measure_input, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
      
      ### Add Scotland reference line

      add_trace(
       color = reference_line_style,  # scotland reference line colour set in global.R script
       name = "Scotland (Estimated)",
       x = ~scotland_value,
       y = ~sending_location,
       type = "scatter",
       mode = "line",
       hoverinfo = "text",
       text = ~ paste(
         input$hc_hscp_time_period_input_1,":", input$hc_financial_year_1_X,
         "<br>",
         "Location: Scotland (Estimate)",
         "<br>",
         "Age Group:", age_group,
         "<br>",
         input$hc_hscp_measure_input, ":", formatC(scotland_value, format = "f", big.mark = ",", drop0trailing = TRUE)
       ),
       inherit = FALSE,
       showlegend = TRUE

        ) %>%

        ### specify axis titles and settings
        
        layout(
          
          
          
          ### Y AXIS
          
          yaxis =
            list(
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
              categoryarray = ~value
              ),
          
          ### X AXIS
          
          xaxis =
            list(
              title = paste(input$hc_hscp_measure_input),
              rangemode = "tozero",
              separatethousands = TRUE,
              showline = TRUE,
              ticks = "outside",
              exponentformat = "none"
            ),
          
          ### PLOT TITLE
         
          title = paste0("<b>", input$hc_hscp_measure_input, " receiving Home Care, ", input$hc_hscp_age_group, ", <br> during ", 
                   input$hc_hscp_time_period_input_1, " ", input$hc_financial_year_1_X, ".", tags$sup("R", style="color:red")),
          
          ## legend
          
          legend = list(
            x = 0, y = -0.2,
            font = list(size = 14)
          ),
          
          # Plot position on screen
          
          margin = list(l = 80, r = 0, b = 80, t = 70) #,
          
          
          
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    } else {
      
      plot_ly(data_homecare_hscp_plot_X() %>%
                filter(sending_location != "Scotland (Estimated)"), 
              y = ~sending_location,
              x = ~as.numeric(value),
              name = "Health and Social Care Partnership",
              type = "bar",
              marker = phs_bar_col,
              
              
              ### add tooltip to plot
              
              hoverinfo = "text",
              text = ~ paste(
                input$hc_hscp_time_period_input_1,":", input$hc_financial_year_1_X,
                "<br>",
                "Location:", sending_location,
                "<br>",
                "Age Group:", age_group,
                "<br>",
                input$hc_hscp_measure_input, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        
        ### specify axis titles and settings
        
        layout(
          
          
          
          ### Y AXIS
          
          yaxis =
            list(
              
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
              categoryarray = ~value
            ),
          
          ### X AXIS
          
          xaxis =
            list(
              title = paste(input$hc_hscp_measure_input),
              rangemode = "tozero",
              separatethousands = TRUE,
              showline = TRUE,
              ticks = "outside",
              exponentformat = "none"
            ),
          
          ### PLOT TITLE
          
          title = if_else(input$hc_hscp_measure_input == "Number of Hours",
                          paste0("<b> Number of Home Care Hours People Received, ", input$hc_hscp_age_group, ", <br> during ",
                          input$hc_hscp_time_period_input_1, " ", input$hc_financial_year_1_X, "."),
                          paste0("<b> Number of People receiving Home Care, ", input$hc_hscp_age_group, ", <br> during ",
                                 input$hc_hscp_time_period_input_1, " ", input$hc_financial_year_1_X, ".", tags$sup("R", style="color:red"))
          ),
          
          ## legend
          
          legend = list(
            x = 0, y = -0.2,
            font = list(size = 14)
          ),
          
          # Plot position on screen
          
          margin = list(l = 80, r = 0, b = 0, t = 70) #,
          
          
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
      
    }
    
  })
  
  
  
  ## hscp table show/hide ----

  
  data_hc_hscp_table <- reactive({
    data_homecare_hscp_plot_X() %>%
      select(financial_quarter, sending_location, age_group, value) %>%
      mutate(value = format(value, big.mark = ","))
  })
  
  observeEvent(input$hc_hscp_showhide, {
    toggle("hc_hscp_table")
    output$hc_hscp_table_output <- DT::renderDataTable(
      DT::datatable(data_hc_hscp_table(),
                    style = "bootstrap",
                    class = "table-bordered table-condensed",
                    rownames = FALSE,
                    colnames = c(
                      input$hc_hscp_time_period_input_1,
                      "Location",
                      "Age Group",
                      input$hc_hscp_measure_input
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
  
  ## download home care hscp functionality ----
  
  output$download_hc_hscp_data <- downloadHandler(
    filename = "homecare_hscp.csv",
    content = function(file) {
      write.table(data_homecare_hscp %>%
                    select(time_period, financial_quarter, sending_location, age_group, measure, value),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    "Year / Quarter",
                    "Location",
                    "Age Group",
                    "Measure",
                    "Value"
                  ),
                  sep = ","
      )
    }
  )
  
  ####################################################
  # X.2.2 Home Care Numbers and Hours by Locality ----
  ####################################################
  ## data ----

  data_homecare_locality_plot <- reactive({
    data_homecare_locality %>%
      filter(
        financial_quarter == input$hc_locality_year_quarter_input,
        sending_location  == input$hc_locality_location_input,
        age_group         == input$hc_locality_age_input,
        measure           == input$hc_locality_measure_input
      )
  })

  ## plot ----

  output$hc_locality_plot <- renderPlotly({
    
    
    # only show plot if data avliable otherwise an error will appear
    if (nrow(data_homecare_locality[data_homecare_locality$financial_quarter == input$hc_locality_year_quarter_input &
                                     data_homecare_locality$sending_location  == input$hc_locality_location_input &
                                     data_homecare_locality$age_group         == input$hc_locality_age_input &
                                     data_homecare_locality$measure           == input$hc_locality_measure_input , ]) == 0){
      
    
      text_locality_homecare <- list(
        x = 5,

        y = 2,

        font = list(color = "red", size = 16),

        text = paste(input$hc_locality_location_input, 
                     "HSCP were unable to provide home care hours data for the", 
                     "<br>", input$hc_locality_measure_input, "for",
                     input$hc_locality_year_quarter_input,
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
    }

    
    # else do the plot
    else {
      plot_ly(data_homecare_locality_plot() %>%
                mutate(
                  locality = recode(locality,
                                    "Skye, Lochalsh and West Ross" = "Skye, Loachalsh...",
                                    "Badenoch and Strathspey" = "Badenoch and Stra...",
                                    "Ayr North and Former Coalfield Communities" = "Ayr North and Former...",
                                    "Maybole and North Carrick Communities" = "Maybole and North...",
                                    "Girvan and South Carrick Villages" = "Girvan and South..."
                  )),
              x = ~locality,
              y = ~as.numeric(value),
              type = "bar",
              marker = phs_bar_col,
              
              ### add tooltip to plot
              
              hoverinfo = "text",
              text = ~ paste(
                "Financial Year Quarter:", input$hc_locality_year_quarter_input,
                "<br>",
                "Health and Social Care Partnership (HSCP):", input$hc_locality_location_input,
                "<br>",
                "HSCP Locality:", ifelse(locality == "Badenoch & Stra...", "Badenoch and Strathspey",
                                         ifelse(locality == "Skye, Loachalsh...", "Skye, Lochalsh and West Ross",
                                                ifelse(locality == "Ayr North and Former...", "Ayr North and Former Coalfield Communities",
                                                       ifelse(locality == "Maybole and North...", "Maybole and North Carrick Communities",
                                                              ifelse(locality == "Girvan and South...", "Girvan and South Carrick Villages", locality)
                                                       )
                                                )
                                         )
                ),
                "<br>",
                "Age Group:", input$hc_locality_age_input,
                "<br>",
                input$hc_locality_measure_input, ":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
              )
      ) %>%
        
        ### specify axis titles and settings
        
        layout(
          
          ### X AXIS
          
          xaxis =
            list(
              title = paste0(c(
                rep("&nbsp;", 30),
                "Health and Social Care Partnership Locality",
                rep("&nbsp;", 30),
                rep("\n&nbsp;", 1)
              ),
              collapse = ""
              ),
              showline = TRUE,
              ticks = "outside",
              categoryorder = "total descending",
              categoryarray = ~value,
              tickangle = ifelse(data_homecare_locality_plot()$sending_location %in% c("Argyll and Bute", "Aberdeenshire", "Dundee City", "Shetland", "Highland", "South Ayrshire", "City of Edinburgh", "Fife", "North Ayrshire", "North Lanarkshire", "Scottish Borders", "South Lanarkshire"),
                                 -45, 0
              )
            ),
          
          ### Y AXIS
          
          yaxis =
            list(
              
              title = paste0(c(
                rep("&nbsp;", 30),
                input$hc_locality_measure_input,
                rep("&nbsp;", 30),
                rep("\n&nbsp;", 1)
              ),
              collapse = ""
              ),
              separatethousands = TRUE,
              #title = plot_axis_font,
              showline = TRUE,
              ticks = "outside",
              exponentformat = "none"
            ),
          
          ### PLOT TITLE
          
          title = 
            
            ifelse(input$hc_locality_measure_input != "Number of Hours",
                   paste0("<b>", input$hc_locality_measure_input, " receiving Home Care, ", input$hc_locality_age_input,
                          ", <br> in ", input$hc_locality_location_input, ", ", input$hc_locality_year_quarter_input, "."),
                   paste0("<b> Number of Home Care Hours received, ", input$hc_locality_age_input,
                          ", <br> in ", input$hc_locality_location_input, ", ", input$hc_locality_year_quarter_input, ".")
                   ),
          
          
         
          # Plot position on screen
          
          margin = list(l = 80, r = 0, b = 80, t = 100) #,
          
          
          
        ) %>%
        config(
          displayModeBar = TRUE,
          modeBarButtonsToRemove = buttons_to_remove,
          displaylogo = F,
          editable = F
        )
    }
  })



  ## table show/hide ----

  data_hc_locality_table <- reactive({
    data_homecare_locality %>%
      filter(
        financial_quarter == input$hc_locality_year_quarter_input,
        sending_location  == input$hc_locality_location_input,
        age_group         == input$hc_locality_age_input,
        measure           == input$hc_locality_measure_input
      ) %>%
      select(financial_quarter, sending_location, locality, age_group, value) %>%
      mutate(value = format(value, big.mark = ","))
  })  
  
  observeEvent(input$hc_locality_showhide, {
    toggle("hc_locality_table")
    output$hc_locality_table_output <- DT::renderDataTable(
                                    DT::datatable(data_hc_locality_table(),
                                                                  style = "bootstrap",
                                                                  class = "table-bordered table-condensed",
                                                                  rownames = FALSE,
                                                                  colnames = c(
                                                                    "Financial Year Quarter",
                                                                    "Location",
                                                                    "Locality",
                                                                    "Age Group",
                                                                    input$hc_locality_measure_input
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

  ## download home care locality functionality ----
  
  output$download_hc_locality_data <- downloadHandler(
    filename = "homecare_locality.csv",
    content = function(file) {
      write.table(data_homecare_locality,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year Quarter",
                    "Location",
                    "Locality",
                    "Age Group",
                    "Measure",
                    input$hc_locality_measure_input
                  ),
                  sep = ","
      )
    }
  )

  ###################################################
  # X.2.3 Client Groups Receiving Home Care ----
  ########################################################
  
  ## data -----
  
  data_homecare_client_group_filtered <- reactive({
    data_homecare_client_group %>%
      filter(
             age_group         == input$hc_client_age_input, 
             sending_location  == input$hc_client_location_input, 
             time_period       == input$hc_client_time_period_input,
             measure           == input$hc_client_measure_input)
  })

  output$hc_client_year_quarter_input <- renderUI({
    shinyWidgets::pickerInput("hc_client_year_quarter_input_X",
                              "Select Year / Quarter:",
                              choices = unique(data_homecare_client_group_filtered()$financial_quarter),
                              selected = c("2020/21 Q4", "2020/21"))
  })

  data_homecare_client_group_filtered_X <- reactive({
    data_homecare_client_group %>%
      filter(
              age_group         == input$hc_client_age_input, 
              sending_location  == input$hc_client_location_input,
              measure           == input$hc_client_measure_input,
              time_period       == input$hc_client_time_period_input,
              financial_quarter == input$hc_client_year_quarter_input_X)
  })
  
  
  ## home care clients plot ----
  
  output$hc_client_plot <- renderPlotly({
    plot_ly(data_homecare_client_group_filtered_X(), #%>%
             y = ~client_group,
             x = ~as.numeric(value),
            
            ### tooltip
            hoverinfo = "text",
            text = ~ paste(
              input$hc_client_time_period_input, ": ", input$hc_client_year_quarter_input_X,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", age_group,
              "<br>",
              "Client Type:", client_group,
              "<br>",
              input$hc_client_measure_input,":", formatC(value, format = "f", big.mark = ",", drop0trailing = TRUE)
            ),
            type = "bar",
            marker = phs_bar_col
    ) %>%
      
      # specify plot layout, axes and title
      
      layout(
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Client Group",
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
        xaxis = list(
          title = input$hc_client_measure_input,
          separatethousands = TRUE,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),
        
        margin = list(l = 80, r = 10, b = 80, t = 100),
        
        ## PLOT TITLE
        
        title = ifelse(input$hc_client_time_period_input == "Financial Quarter",
                       paste0("<b>", input$hc_client_measure_input, " receiving Home Care, ", input$hc_client_age_input, ", <br> in ", 
                              input$hc_client_location_input, " by Client Group, ", input$hc_client_year_quarter_input_X, "."),
                       paste0("<b>", input$hc_client_measure_input, " receiving Home Care, ", input$hc_client_age_input, ", <br> in ", 
                              input$hc_client_location_input, " by Client Group, Census Week March ", input$hc_client_year_quarter_input_X, ".")
                       )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
    
  })

  ## show / hide table -----
  
  
  data_hc_client_table <- reactive({
    data_homecare_client_group %>%
      filter(
        age_group         == input$hc_client_age_input, 
        sending_location  == input$hc_client_location_input,
        measure           == input$hc_client_measure_input,
        time_period       == input$hc_client_time_period_input,
        financial_quarter == input$hc_client_year_quarter_input_X) %>%
      select(financial_quarter, sending_location, age_group, client_group, value) %>%
      mutate(value = format(value, big.mark = ","))
  })  
  
  observeEvent(input$hc_client_showhide, {
    toggle("hc_client_table")
    output$hc_client_table_output <- DT::renderDataTable(
                        DT::datatable(data_hc_client_table(),
                          style = "bootstrap",
                          class = "table-bordered table-condensed",
                          rownames = FALSE,
                          colnames = c(
                                      input$hc_client_time_period_input,
                                      "Location",
                                      "Age Group",
                                      "Client Group",
                                      input$hc_client_measure_input
                                       ),
                          options = list(
                                        pageLength = 16,
                                        autoWidth = TRUE,
                                        columnDefs = list(list(className = "dt-left",
                                                               targets = "_all")),
                                                                   dom = "tip",
                                                                   bPaginate = FALSE,
                                                                   bInfo = FALSE
                                                                 )
    ))
  })

  ## download client type data ----
  
  output$download_hc_client_data <- downloadHandler(
    filename = "homecare_client_type.csv",
    content = function(file) {
      write.table(data_homecare_client_group,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    "Financial Year Quarter",
                    "Location",
                    "Age Group",
                    "Client Group",
                    "Measure",
                    "Value"
                  ),
                  sep = ","
      )
    }
  )

  ######################################################
  # X.2.4 Service Providers of Home Care ----
  #####################################################
  
  ## data ----
  data_homecare_service_provider_filtered <- reactive({
    data_homecare_service_provider %>%
      filter(
        sending_location  == input$hc_service_provider_location_input, 
        time_period       == input$hc_service_provider_time_period_input)
  })
  
  output$hc_service_provider_year_quarter_input <- renderUI({
    shinyWidgets::pickerInput("hc_service_provider_year_quarter_input_X",
                              "Select Year / Quarter:",
                              choices = unique(data_homecare_service_provider_filtered()$financial_quarter),
                              selected = c("2020/21 Q4", "2020/21"))
  })
  
  data_homecare_service_provider_filtered_X <- reactive({
    data_homecare_service_provider %>%
      filter(
        sending_location     == input$hc_service_provider_location_input, 
        time_period          == input$hc_service_provider_time_period_input,
        financial_quarter    == input$hc_service_provider_year_quarter_input_X,
        hc_service_provider  == input$hc_service_provider_input)
  })
  
  
  ## service provider plot (bar chart) ----
  
  output$hc_service_plot <- renderPlotly({
    plot_ly(data_homecare_service_provider_filtered_X() %>%
              filter(age_group != "Unknown"),     
            x = ~as.numeric(round(percentage,1)),
            y = ~age_group,
            type = "bar",
            marker = phs_bar_col,
            
            
            ### add tooltip
            
            hoverinfo = "text",
            text = ~ paste(
              input$hc_service_provider_time_period_input,":", input$hc_service_provider_year_quarter_input_X,
              "<br>",
              "Location:", input$hc_service_provider_location_input,
              "<br>",
              "Age Group:", input$hc_service_provider_age_input,
              "<br>",
              "Service Provider:", input$hc_service_provider_input,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Percentage:", percentage, "%"
            )
    ) %>%
      layout(
        
        ### PLOT TITLE
        
        title = ifelse(input$hc_service_provider_time_period_input == "Financial Quarter",
                       paste0("<b> Percentage of People receiving Home Care <br> in ", input$hc_service_provider_location_input, 
                             " by <br>", input$hc_service_provider_input, 
                             ", ", input$hc_service_provider_year_quarter_input_X, "."),
                       paste0("<b> Percentage of People receiving Home Care <br> in ", input$hc_service_provider_location_input, 
                              " by <br>", input$hc_service_provider_input, 
                              ", Census Week March", input$hc_service_provider_year_quarter_input_X, ".")
        ),
        
       
        # X AXIS
        
        xaxis = list(
          showline = TRUE,
          ticks = "outside",
          categoryorder = "array",
          title = " Percentage of People receiving Home Care  ",
          nticks = 6,
          showline = TRUE,
          ticksuffix = "%"
        ),
        
        # Y AXIS
        
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
          title = "Age Group",
          tickangle = 0
        ),
        
        # plot size / position
        
        margin = list(l = 0, r = 0, b = 50, t = 180),

        # plot legend
        
        legend = list(
          yanchor="bottom",
          y=-1.2,
          xanchor="center",
          x=0.5)      
      ) %>%
      
      # set which icons to show on top right of plot output
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  
  ## show / hide button and hc service provider data table ----
  
  data_hc_service_table <- reactive({
    data_homecare_service_provider  %>%
      filter(sending_location  == input$hc_service_provider_location_input, 
             time_period       == input$hc_service_provider_time_period_input,
             financial_quarter    == input$hc_service_provider_year_quarter_input_X,
             hc_service_provider  == input$hc_service_provider_input) %>%
      select(
        financial_quarter, 
        sending_location,
        age_group,
        hc_service_provider,
        nclient,
        percentage
        ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$hc_service_showhide, {
    toggle("hc_service_table")
    output$hc_service_table_output <- DT::renderDataTable(DT::datatable(data_hc_service_table(),
                                                                         style = "bootstrap",
                                                                         class = "table-bordered table-condensed",
                                                                         rownames = FALSE,
                                                                         colnames = c(
                                                                           input$hc_service_provider_time_period_input,
                                                                           "Location",
                                                                           "Age Group",
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

  
  ## download data table functionality ----
  
  output$download_hc_service_data <- downloadHandler(
    filename = "homecare_service_provider.csv",
    content = function(file) {
      write.table(data_homecare_service_provider,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    input$hc_service_provider_time_period_input,
                    "Location",
                    "Age Group",
                    "Service Provider",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )

  #####################################
  # X.2.5 Home Care Hours Received ----
  ##################################### 
  
  ### data ----
  data_homecare_hours_received_filtered <- reactive({
    data_homecare_hours_received %>%
      filter(
        age_group         == input$hc_hours_received_age_input, 
        sending_location  == input$hc_hours_received_location_input, 
        time_period       == input$hc_hours_received_time_period_input)
  })
  
  
  observe({
    x = input$hc_hours_received_time_period_input
    
    if(x == "Financial Quarter"){
      updateSelectInput(session, "hc_hours_received_year_quarter_input",
                        choices = unique(data_homecare_hours_received$financial_quarter)[1:13],
                        selected = "2020/21 Q4")
    }else{
      updateSelectInput(session, "hc_hours_received_year_quarter_input",
                        choices = unique(data_homecare_hours_received$financial_quarter)[14:17],
                        selected = "2020/21")
    }
  })
  
  data_homecare_hours_received_filtered_X <- reactive({
    data_homecare_hours_received %>%
      filter(
        age_group         == input$hc_hours_received_age_input, 
        sending_location  == input$hc_hours_received_location_input, 
        time_period       == input$hc_hours_received_time_period_input,
        financial_quarter == input$hc_hours_received_year_quarter_input)
  })
  
  
  
  ## hours received plot -----

  output$hc_hours_recieved_plot <- renderPlotly({
    plot_ly(data_homecare_hours_received_filtered_X() %>%
              filter(level_of_service != "Unknown"),   # exclude "unknown" category from plot
            x = ~level_of_service,
            y = ~percentage,
            type = "bar",
            marker = phs_bar_col,

            ### add tooltip

            hoverinfo = "text",
            text = ~ paste(
              time_period, ": ", input$hc_hours_received_year_quarter_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:",input$hc_hours_received_age_input,
              "<br>",
              "Level of Service:", level_of_service,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Percentage of People:", formatC(percentage, format = "f", big.mark = ",", drop0trailing = TRUE), "%"
            )

      ### specify plot layout, axes specifications and title

    ) %>%
      layout(

        ## X AXIS

        xaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Average Weekly Hours",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          title = plot_axis_font,
          showline = TRUE,
          ticks = "outside",
          categoryorder = "category array",
          categoryarray = c("0 - <2 hours", "2 - <4 hours", "4 - <10 hours", "10+ hours")
        ),

        ## Y AXIS

        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Percentage of People",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          separatethousands = TRUE,
          exponentformat = "none",
          showline = TRUE,
          ticks = "outside"
        ),

        ## PLOT TITLE

        title = ifelse(input$hc_hours_received_time_period_input == "Financial Quarter",
                       paste0("<b> Percentage of People receiving Home Care, ", input$hc_hours_received_age_input, 
                              ", in ", input$hc_hours_received_location_input, 
                             " <br> by Level of Service received (Average Weekly Hours), ", 
                             input$hc_hours_received_year_quarter_input, "."),
                       paste0("<b> Percentage of People receiving Home Care, ", input$hc_hours_received_age_input, 
                              ", in ", input$hc_hours_received_location_input, 
                              " <br> by Level of Service received (Average Weekly Hours), Census Week March ", 
                              input$hc_hours_received_year_quarter_input, ".")
        ),

        ## PLOT POSITION

        margin = list(l = 80, r = 10, b = 90, t = 100) #,
        

      ) %>%

      ## buttons to add plot to allow for plot image (png) download

      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })

  ## show / hide data table button ----

  data_hc_hours_recieved_table <- reactive({
    data_homecare_hours_received_filtered_X() %>%
      select(
        financial_quarter,
        sending_location,
        age_group,
        level_of_service,
        nclient,
        percentage
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$hc_hours_recieved_showhide, {
    toggle("hc_hours_recieved_table")
    output$hc_hours_recieved_table_output <- DT::renderDataTable(
                                      DT::datatable(data_hc_hours_recieved_table(),
                                                                        style = "bootstrap",
                                                                        class = "table-bordered table-condensed",
                                                                        rownames = FALSE,
                                                                        colnames = c(
                                                                          input$hc_hours_received_time_period_input,
                                                                          "Location",
                                                                          "Age Group",
                                                                          "Number of Hours Home Care",
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
  
  ## download data table function / button ----
  
  output$download_hc_hours_recieved_data <- downloadHandler(
    filename = "homecare_level_of_service.csv",
    content = function(file) {
      write.table(data_homecare_hours_received %>%
                    select(-hours_order),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    "Year / Quarter",
                    "Location",
                    "Age Group",
                    "Number of Hours Home Care",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  #############################################
  # X.2.6 Home Care Hours Distribution ----
  ##########################################
  
  
  ## data -----
  data_homecare_hours_distribution_filtered <- reactive({
    data_homecare_hours_distribution %>%
      filter(
        age_group         == input$hc_hours_distribution_age_input, 
        sending_location  == input$hc_hours_distribution_location_input, 
        time_period       == input$hc_hours_distribution_time_period_input)
  })
  
  
  
  observe({
    x = input$hc_hours_distribution_time_period_input
    
    if(x == "Financial Quarter"){
      updateSelectInput(session, "hc_hours_distribution_year_quarter_input",
                        choices = unique(data_homecare_hours_distribution$financial_quarter)[1:13],
                        selected = "2020/21 Q4")
    }else{
      updateSelectInput(session, "hc_hours_distribution_year_quarter_input",
                        choices = unique(data_homecare_hours_distribution$financial_quarter)[14:17],
                        selected = "2020/21")
    }
  })
  
  data_homecare_hours_distribution_filtered_X <- reactive({
    data_homecare_hours_distribution %>%
      filter(
        age_group         == input$hc_hours_distribution_age_input, 
        sending_location  == input$hc_hours_distribution_location_input, 
        time_period       == input$hc_hours_distribution_time_period_input,
        financial_quarter == input$hc_hours_distribution_year_quarter_input)
  })
  
  
  ## create data plot based on filtered data ----
  
  output$hc_hours_distribution_plot <- renderPlotly({
    plot_ly(data_homecare_hours_distribution_filtered_X() %>%
              filter(!(is.na(nclient)), # exclude any NA's from the plot
                     hc_hours_category != "Unknown"),                         
            x = ~hc_hours_category,
            y = ~percentage,
            type = "bar",
            marker = phs_bar_col,
            
            ### add tooltip
            
            hoverinfo = "text",
            text = ~ paste(
              input$hc_hours_distribution_time_period_input, ": ", input$hc_hours_distribution_year_quarter_input,
              "<br>",
              "Location:", input$hc_hours_distribution_location_input,
              "<br>",
              "Age Group:", input$hc_hours_distribution_age_input,
              "<br>",
              "Home Care Hours:", hc_hours_category,
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Percentage of People:", formatC(percentage, format = "f", big.mark = ",", drop0trailing = TRUE), "%"
            )
    ) %>%
      layout(
        
        # x axis settings
        
        xaxis = list(
          categoryorder = "array",
           categoryarray = c(
           "< 1 hour", "1 - <2 hours", "2 - <3 hours", "3 - <4 hours", "4 - <5 hours", "5 - <6 hours", "6 - <7 hours", "7 - <8 hours", "8 - <9 hours", "9 - <10 hours", "10 - <12 hours", "12 - <14 hours", "14 - <16 hours", "16 - <18 hours", "18 - <20 hours", "20 - <30 hours", "30 - <40 hours", "40 - <50 hours", "50 - <60 hours", "60 - <70 hours", "70 - <80 hours", "80+ hours", "Unknown"
           ),
          showline = TRUE,
          tickangle = -45,
          ticks = "outside",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Average Weekly Hours",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          )
        ),
        
        # yaxis settings
        
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          separatethousands = TRUE,
          rangemode = "tozero",
          title = paste0(c(
            rep("&nbsp;", 30),
            "Percentage of People",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          )
        ),
        
        # plot title
        
        title = ifelse(input$hc_hours_distribution_time_period_input == "Financial Quarter",
                       paste0("<b> Percentage of People receiving Home Care, ", input$hc_hours_distribution_age_input, 
                              ", in ", input$hc_hours_distribution_location_input, 
                             "<br> by Hours Received (Average Weekly Hours), ", 
                             input$hc_hours_distribution_year_quarter_input, "."),
                       paste0("<b> Percentage of People receiving Home Care, ", input$hc_hours_distribution_age_input, 
                              ", in ", input$hc_hours_distribution_location_input, 
                              "<br> by Hours Received (Average Weekly Hours), Census Week March ", 
                              input$hc_hours_distribution_year_quarter_input, ".")
        ),
        
        # plot position
        
        margin = list(l = 80, r = 10, b = 70, t = 130)
        
      ) %>%
      
      ## buttons to add plot to allow for plot image (png) download
      
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })

  
  ## data table function / button -----
  
  data_hc_hours_distribution_table <- reactive({
    data_homecare_hours_distribution_filtered_X() %>%
      select(
        financial_quarter,
        sending_location,
        age_group,
        hc_hours_category,
        nclient,
        percentage
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$hc_hours_distribution_showhide, {
    toggle("hc_hours_distribution_table")
    output$hc_hours_distribution_table_output <- DT::renderDataTable(DT::datatable(data_hc_hours_distribution_table(),
                                                                   style = "bootstrap",
                                                                   class = "table-bordered table-condensed",
                                                                   rownames = FALSE,
                                                                   colnames = c(
                                                                     input$hc_hours_distribution_time_period_input,
                                                                     "Location",
                                                                     "Age Group",
                                                                     "Home Care Hours",
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

  ## download data ----
  
  output$download_hc_hours_distribution_data <- downloadHandler(
    filename = "homecare_hours_distribution.csv",
    content = function(file) {
      write.table(data_homecare_hours_distribution %>%
                    select(-hours_order),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    "Year / Quarter",
                    "Location",
                    "Age Group",
                    "Home Care Hours",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )

  ###############################
  # X.2.8 Personal Care ----
  ###############################
  ## data ----
  
  data_homecare_personal_care_filtered <- reactive({
      data_homecare_personal_care %>%
      filter(
        age_group         == input$hc_personal_care_age_input,
        financial_quarter == input$hc_personal_care_year_quarter_input,
        time_period       == "Financial Quarter"
        )
  })
  
  
  
  ## plot ----
  
  output$hc_personal_care_plot <- renderPlotly({
      
    plot_ly(data_homecare_personal_care_filtered() %>%
              filter(sending_location != "Scotland (All Areas Submitted)"),
            x = ~percentage,
            y = ~sending_location,
            type = "bar",
            marker = phs_bar_col,
            name = "Health and Social Care Partnership",

            # add tooltip

            hoverinfo = "text",
            text = ~ paste(
              "Financial Quarter:", input$hc_personal_care_year_quarter_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", age_group,
              "<br>",
              "Percentage of People:", percentage, "%",
              "<br>",
              "Number of People", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
           
            
    ) %>%
      
      
      # ## Add Comparison Scotland (All Areas Submitted) line
      
      add_trace(
        color = reference_line_style,
        name = "Scotland (All Areas Submitted)",
         x = ~scotland_percentage,
         y = ~sending_location,
         type = "scatter",
         mode = "line",
         hoverinfo = "text",
         text = ~ paste(
          "Financial Quarter:", input$hc_personal_care_year_quarter_input,
           "<br>",
           "Location: Scotland (All Areas Submitted)",
           "<br>",
           "Age Group:", age_group,
           "<br>",
           "Percentage of People:", scotland_percentage, "%"
         ),
        inherit = FALSE,
        showlegend = TRUE
       
        ) %>%
      
      layout(
        
        # yaxis 
        
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
          categoryarray = ~percentage
        ),
        
        # x axis 
        
          xaxis = list(
            title = "Percentage of People with Personal Care",
            showline = TRUE,         # y axis plot line to appear
            ticks = "outside",       # tick marks to appear outside of plot
            ticksuffix = "%",        # labels to have % after number
            rangemode = "tozero",    # axis minimum value to always = 0
            nticks = 6,              # number of axis tick marks
            range = c(0, 100)        # tick marks to range from 0 to 100
          
          
        ),
        
        # legend
        
        legend = list(
          
          x = 0,
          y = -0.2,
          font = list(size = 14)
        ),
        
        # plot title
        
        title = paste0("<b> Percentage of People, ", input$hc_personal_care_age_input, 
                       ", receiving Home Care Services with Personal Care <br> by Health and Social Care Partnership, ", 
                       input$hc_personal_care_year_quarter_input, "."),
        
        # plot placement 
        
        margin = list(l = 20, r = 20, b = 50, t = 100)
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  

  ## show / hide function and data table ----
  
  data_hc_personal_care_table <- reactive({
    data_homecare_personal_care_filtered() %>%
      select(
        financial_quarter,
        sending_location,
        age_group,
        nclient,
        percentage
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$hc_personal_care_showhide, {
    toggle("hc_personal_care_table")
    output$hc_personal_care_table_output <- DT::renderDataTable(
                                      DT::datatable(data_hc_personal_care_table(),
                                                  style = "bootstrap",
                                                  class = "table-bordered table-condensed",
                                                  rownames = FALSE,
                                                  colnames = c( "Financial Year / Quarter", 
                                                                "Location",
                                                                "Age Group",
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

  ## download personal care data ----
  
  output$download_personal_care <- downloadHandler(
    filename = "homecare_personal_care.csv",
    content = function(file) {
      write.table(data_homecare_personal_care %>% select(-scotland_percentage),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Time Period",
                    "Year / Quarter",
                    "Location",
                    "Age Group",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )
  
  ################################
  # # X.2.9 Technology Enabled Care (previously Alarms/Telecare) ----
  ################################
  ## data -----

    data_homecare_tec_plot <- reactive({
      data_homecare_tech_enabled_care %>%
        filter(
         financial_year    == input$hc_tec_year_input,
         age_group         == input$hc_tec_age_input
          
        )
    })
    
  
  ## plot ----
  
  output$hc_tec_plot <- renderPlotly({
    plot_ly(data_homecare_tec_plot() %>% 
              filter(sending_location != "Scotland (All Areas Submitted)"),
            x = ~percentage,
            y = ~sending_location,
            type = "bar",
            marker = phs_bar_col,
            
            
            ### tooltip
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", input$hc_tec_year_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", input$hc_tec_age_input,
              "<br>",
              "Percentage of People:", percentage, "%",
              "<br>" 
            )
    ) %>%
      

      ## Add Comparison Scotland line
      # 
      add_trace(
         color = reference_line_style,
         name = "Scotland (All Areas Submitted)",
         x = ~scotland_percentage,
         y = ~sending_location,
         type = "scatter",
         mode = "line",
         hoverinfo = "text",
         text = ~ paste(
           "Financial Year:",input$hc_tec_year_input,
           "<br>",
           "Location: All Areas Submitted",
           "<br>",
           "Age Group:", input$hc_tec_age_input,
           "<br>",
           "Percentage of People:", scotland_percentage, "%",
           "<br>"
         ),
         
         inherit = FALSE,
         showlegend = FALSE
       ) %>%
      
      layout(
        
        barmode = "stack",

        ### X AXIS
        
        xaxis = list(
          title = "Percentage of People",
          showline = TRUE,         # y axis plot line to appear
          ticks = "outside",       # tick marks to appear outside of plot
          ticksuffix = "%",        # labels to have % after number
          rangemode = "tozero",    # axis minimum value to always = 0
          nticks = 6,              # number of axis tick marks
          range = c(0, 100)        # tick marks to range from 0 to 100
          
        ),
        
        ### Y AXIS
        
                yaxis = list(
          
          type = "category",
          title = paste0(c(rep("&nbsp;", 30),
                           "Health and Social Care Partnership",
                           rep("&nbsp;", 30),
                           rep("\n&nbsp;", 3)),
                         collapse = ""),
          showline = TRUE,
          ticks = "outside",
          categoryorder = "total ascending",
          categoryarray = ~percentage
        ),
        legend = list(
          x = 0,
          y = -1
        ),
        
        ### Plot title 
        
        title = paste0("<b> Percentage of People, ", input$hc_tec_age_input, 
                      ", receiving Home Care who have a Community Alarm <br> and/or Telecare by Health and Social Care Partnership, ", 
                      input$hc_tec_year_input, "."),

        
        # plot margins
        margin = list(l = 20, r = 20, b = 90, t = 100)
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })

  ## show / hide button and data table ----
  
  data_hc_tec_table <- reactive({
    data_homecare_tec_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        nclient,
        percentage
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  observeEvent(input$hc_tec_showhide, {
    toggle("hc_tec_table")
    output$hc_tec_table_output <- DT::renderDataTable(DT::datatable(data_hc_tec_table(),
                                                                style = "bootstrap",
                                                                class = "table-bordered table-condensed",
                                                                rownames = FALSE,
                                                                colnames = c(
                                                                  "Financial Year",
                                                                  "Location",
                                                                  "Age Group",
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

  ## download alarms and telecare data ----
  
  output$download_hc_tec_data <- downloadHandler(
    filename = "homecare_alarms_telecare.csv",
    content = function(file) {
      write.table(data_homecare_tech_enabled_care %>%
                    select(-scotland_percentage),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )

  #############################################
  # 2.10 Emergency Care ----
  #############################################
  ## emergency care data ----
  data_homecare_emergency_care_plot <- reactive({
    data_homecare_emergency_care %>%
      filter(financial_quarter == input$hc_emergency_year_quarter_input,
             measure           == input$hc_emergency_measure_input,
             age_group         == input$hc_emergency_age_input)
  })

  ## emergency care Chart ----

  output$hc_emergency_plot <- renderPlotly({
    plot_ly(data_homecare_emergency_care_plot() %>%
              filter(sending_location != "Scotland (All Areas Submitted)"),
            x = ~rate,
            y = ~sending_location,
            type = "bar",
            marker = phs_bar_col,
            
            # tooltip
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year Quarter:", financial_quarter,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", age_group,
              "<br>",
              "Number of", input$hc_emergency_measure_input, ":", formatC(numerator, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Rate of", input$hc_emergency_measure_input, ":", rate
            ),
            showlegend = FALSE
    ) %>%
      
     
      # ### Add scotland rate comparison line
      add_trace(
         color = reference_line_style,
         name = "Scotland (All Areas Submitted)",
         x = ~scotland_rate,
         y = ~sending_location,
         type = "scatter",
         mode = "line",
         hoverinfo = "text",
         text = ~ paste(
           "Financial Year Quarter:", financial_quarter,
           "<br>",
           "Location: Scotland (All Areas Submitted)",
           "<br>",
           "Age Group:", age_group,
           "<br>",
           "Rate of ", input$hc_emergency_measure_input, ":", scotland_rate
         ),
         inherit = FALSE,
         showlegend = FALSE
       ) %>%
      layout(
        
        ### Y AXIS
        
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
        
        ### X AXIS
        
        xaxis = list(
          title = ~ paste(input$hc_emergency_measure_input, "Rate"),
          showline = TRUE,
          ticks = "outside",
          separatethousands = TRUE
        ),
        
        #### Plot Title
        
        title = paste0("<b> Rate per 1,000 People, ", input$hc_emergency_age_input, 
                       ", receiving Home Care who had an <br>", input$hc_emergency_measure_input, " by Health and Social Care Partnership, ",
                       input$hc_emergency_year_quarter_input, "."
          ),
        
        
        
        margin = list(l = 80, r = 10, b = 50, t = 100)
        
      ) %>%
      
      # show icons for functions available for plot e.g. zoom, download, pan, reset axes
      
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,

        editable = F
      )
  })

  ## Admissions Table - show/hide ----

  
  data_hc_emergency_table <- reactive({
    data_homecare_emergency_care_plot() %>%
      select(
        financial_quarter,
        sending_location,
        age_group,
        numerator,
        rate
      ) %>%
      mutate(
        numerator = format(numerator, big.mark = ","),
        rate = format(rate, big.mark = ","))
  })
  
  
  observeEvent(input$hc_emergency_showhide, {
    toggle("hc_emergency_table")
    output$hc_emergency_table_output <- DT::renderDataTable(DT::datatable(data_hc_emergency_table(),
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Financial Year Quarter",
                                                                      "Location",
                                                                      "Age Group",
                                                                      paste("Number of", input$hc_emergency_measure_input),
                                                                      paste("Rate per 1,000 People Receiving Home Care who had an", input$hc_emergency_measure_input)
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
  
  output$download_hc_emergency_data <- downloadHandler(
    filename = "homecare_emergency_admissions.csv",
    content = function(file) {
      write.table(data_homecare_emergency_care %>%
                    select(financial_quarter, sending_location, age_group, measure, numerator, rate),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year Quarter",
                    "Location",
                    "Age Group",
                    "Measure",
                    "Value",
                    "Rate per 1,000 People Receiving Home Care who had an Admission"
                  ),
                  sep = ","
      )
    }
  )
  
  ###################################################
  # X.3.14 Referral Source (NEW TAB) ----
  ########################################################

  ## data -----
  
  data_homecare_referral_source_plot <- reactive({
    data_homecare_referral_source %>%
      filter(financial_quarter == input$hc_referral_source_year_quarter_input,
             age_group         == input$hc_referral_source_age_input
      )
  })
  
  
  ## home care referral source plot ----
  
  output$hc_referral_plot <- renderPlotly({
    plot_ly(data_homecare_referral_source_plot(),
            x = ~percentage,
            y = ~sending_location,
            type = "bar",
            split = ~referral_source,
            color = ~referral_source,
            colors = five_col_pal,
            
            ### tooltip
            
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", input$hc_referral_source_year_quarter_input,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group: ", input$hc_referral_source_age_input,
              "<br>",
              "Referral Source:", referral_source,
              "<br>",
              "Percentage of Referrals:", percentage, "%",
              "<br>",
              "Number of Referrals:", numerator
            ),
            inherit = FALSE,
            showlegend = TRUE
    )  %>%
      
      layout(
        barmode = "stack",
        
        ##### x axis
        
        xaxis = list(
          title = "Percentage of People recieveing Home Care",
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
          autorange = "reversed",
          categoryorder = "trace" 
        ),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.3,
          font = list(size = 13),
          traceorder = "normal"
        ),
        
        ## title
        
        title = paste0("<b> Percentage of People receiving Home Care by Hospital Referral Source and <br> Health and Social Care Partnership, ",
                       input$hc_referral_source_age_input, ", ", input$hc_referral_source_year_quarter_input, "."),
        
        # plot margins
        
        margin = list(l = 0, r = 0, b = 20, t = 120)
      ) %>%
      
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F, 
        editable = F
      )
})
  
  ## show / hide table -----
  
  
  data_hc_referral_table <- reactive({
    data_homecare_referral_source_plot() %>%
      select(financial_quarter,
             sending_location,
             age_group,
             referral_source,
             percentage,
             numerator) %>%
      mutate(numerator = format(numerator, big.mark = ","),
             percentage = format(percentage, big.mark = ","))
  })
  
  
  observeEvent(input$hc_referral_showhide, {
    toggle("hc_referral_table")
    output$hc_referral_table_output <- DT::renderDataTable(
      DT::datatable(data_hc_referral_table(), 
                    style = "bootstrap",
                    class = "table-bordered table-condensed",
                    rownames = FALSE,
                    colnames = c(
                      "Financial Year Quarter",
                      "Location",
                      "Age Group",
                      "Referral Source",
                      "Percentage of Referrals",
                      "Number of Referrals"
                    ),
                    options = list(
                      pageLength = 16,
                      autoWidth = TRUE,
                      columnDefs = list(list(className = "dt-left",
                                             targets = "_all")),
                      dom = "tip",
                      bPaginate = FALSE,
                      bInfo = FALSE
                    )
      ))
  })
  
  ## download referral source data ----
  
  output$download_hc_referral_data <- downloadHandler(
    filename = "homecare_referral_source.csv",
    content = function(file) {
      write.table(data_homecare_referral_source %>% 
                    select(financial_quarter,
                           sending_location,
                           age_group,
                           referral_source,
                           percentage,
                           numerator),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year Quarter",
                    "Location",
                    "Age Group",
                    "Referral Source",
                    "Percentage of Referrals",
                    "Number of Referrals"
                  ),
                  sep = ","
      )
    }
  )

  #############################################
  # 2.11 Deprivation ----
  #############################################
  
  
  ## filter deprivation data ----
  
  data_homecare_deprivation_plot <- reactive({
    data_homecare_deprivation %>%
      filter(financial_quarter   == input$hc_simd_year_input,
             sending_location    == input$hc_simd_location_input,
             age_group           == input$hc_simd_age_input
      )
  })
  
  ## plot deprivation data ----
  
  output$hc_simd_plot <- renderPlotly({
    
    if (nrow(data_homecare_deprivation[data_homecare_deprivation$financial_quarter == input$hc_simd_year_input &
                                       data_homecare_deprivation$sending_location  == input$hc_simd_location_input &
                                       data_homecare_deprivation$age_group         == input$hc_simd_age_input , ]) == 0){
      
      
      text_simd_homecare <- list(
        x = 5,
        
        y = 2,
        
        font = list(color = "red", size = 16),
        
        text = paste(input$hc_simd_location_input, 
                     "HSCP were unable to provide deprivation data for <br>",
                     input$hc_simd_age_input, "for the time period",
                     input$hc_simd_year_input,
                     "and cannot be plotted."),
        
        xref = "x",
        
        yref = "y",
        
        showarrow = FALSE
      )
      
      ## create a blank plot, including the error text
      
      plot_ly() %>%
        layout(
          annotations = text_simd_homecare,
          
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
    
      plot_ly(data_homecare_deprivation_plot() %>%
              filter(
                deprivation != "Unknown"
              ),
            x = ~deprivation,
            y = ~simd_percentage,
            type = "bar",                          # chart type
            marker = phs_bar_col,      # colour of bars
            
            # tootltip information
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year: ", financial_quarter,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", age_group,
              "<br>",
              "Deprivation (SIMD) Quintile:", deprivation,
              "<br>",
              "Percentage of People:", formatC(simd_percentage, format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )
    ) %>%
      layout(
        xaxis = list(
          title = "SIMD Quintile",
          #titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        yaxis = list(
          title = paste0(c(
            rep("&nbsp;", 30),
            "Percentage of People (%)",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          exponentformat = "none",
          #titlefont = f2,
          showline = TRUE,
          ticks = "outside"
        ),
        
        # PLOT TITLE
        
        title = paste0("<b>SIMD Quintile Proportion, ", input$hc_simd_age_input ,", ", 
                      input$hc_simd_location_input, "<br> receiving Home Care Services/Support by Deprivation Category, ", 
                      input$hc_simd_year_input, "."),

        
        margin = list(l = 90, r = 60, b = 80, t = 90)#,
        
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
    }
  })
  
  
  ## show / hide deprivation table ----
  
  
  data_hc_deprivation_table <- reactive({
    data_homecare_deprivation_plot() %>%
      mutate(nclient = format(nclient, big.mark = ","),
             simd_percentage = format(simd_percentage, big.mark = ","))
  })
  
  observeEvent(input$hc_simd_showhide, {
    toggle("hc_simd_table")
    output$hc_simd_table_output <- DT::renderDataTable(DT::datatable(data_hc_deprivation_table(), 
                                                                     style = "bootstrap",
                                                                          class = "table-bordered table-condensed",
                                                                          rownames = FALSE,
                                                                          colnames = c(
                                                                            "Financial Quarter",
                                                                            "Location",
                                                                            "Age Group",
                                                                            "SIMD Deprivaton Quintile",
                                                                            "Percentage of People",
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
  
  ## download deprivation data ----
  
  output$download_hc_simd_data <- downloadHandler(
    filename = "home_care_deprivation.csv",
    content = function(file) {
      write.table(data_homecare_deprivation,
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Age Group",
                    "SIMD Deprivaton Quintile",
                    "Percentage of People",
                    "Number of People"
                  ),
                  sep = ","
      )
    }
  )
  
  
  
  
  ############################################
  # X.2.12 Level of Independence (ioRN) ----
  ############################################
  
  ## filter iorn data based on user inputs (dropdown selections) ----
  
  data_homecare_iorn_plot <- reactive({
   data_homecare_iorn %>%
      filter(financial_year== input$hc_iorn_year_input,
             sending_location  == input$hc_iorn_location,
             level_of_service  != "missing") 
  })
  
  data_homecare_iorn$level_of_service <- factor(data_homecare_iorn$level_of_service,
                                                levels = unique(data_homecare_iorn$level_of_service))

  ## plot ----
  
  output$hc_iorn_plot <- renderPlotly({
    plot_ly(
      data_homecare_iorn_plot(),
      x = ~iorn_group,
      y = ~propn_iorn,
      type = "bar",
      name = ~level_of_service,
      #name = ~hours_order,
      color = ~level_of_service,
      colors = five_col_pal,          # colour palette specified in global.R script
      
      ## add tooltip (text to appear when hovering over data points in plot)
      
      hoverinfo = "text",
      text = ~ paste(
        "Financial Year:", financial_year, 
        "<br>",
        "Location:", sending_location,
        "<br>",
        "Level of Service:", level_of_service,
        "<br>",
        "Number of People:", nclient,
        "<br>",
        "Percentage of People:", round(propn_iorn, 1), "%"
      )
    ) %>%
      layout(
        barmode = "stack",
        
        margin = list(l = 10, r = 10, b = 30, t = 80),
        
        ## legend
        
        legend = list(
          x = 0, y = -0.4,
          font = list(size = 12),
          traceorder = "normal"
        ),
        
        

        
        # PLOT TITLE
        title = paste0("<b>", input$hc_iorn_location, " Average Home Care Hours <br>received per week by IoRN Group, ", input$hc_iorn_year_input, "."),
        
        # X AXIS
        
        xaxis = list(
          showline = TRUE,
          ticks = "outside",
          #title = plot_axis_font,
          title = "ioRN Group",
          tickangle = 0
        ),
        
        # Y AXIS
        
        yaxis = list(
          showline = TRUE,
          ticks = "outside",
          categoryorder = "array",
          categoryarray = c("0 - <2 hours", "2 - <4 hours", "4 - <10 hours", "10+ hours", "No home care record", "Unknown"),
          title = paste0(c(
            rep("&nbsp;", 30),
            "Cumulative Percentage by ioRN Group",
            rep("&nbsp;", 30),
            rep("\n&nbsp;", 1)
          ),
          collapse = ""
          ),
          nticks = 6,
          showline = TRUE,
          ticksuffix = "%",
          range = c(0, 100)
        )
      ) %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })

  ## show / hide data table button and data table specifications
  
  
  data_hc_iorn_table <- reactive({
    data_homecare_iorn_plot() %>%
      select(
        financial_year,
        sending_location,
        iorn_group,
        level_of_service,
        nclient,
        propn_iorn
      ) %>%
      mutate(nclient = format(nclient, big.mark = ","),
             propn_iorn = format(propn_iorn, big.mark = ","))
  })
  
  observeEvent(input$hc_iorn_showhide, {
    toggle("hc_iorn_table")
    output$hc_iorn_table_output <- DT::renderDataTable(DT::datatable(data_hc_iorn_table() ,
                                                                    style = "bootstrap",
                                                                    class = "table-bordered table-condensed",
                                                                    rownames = FALSE,
                                                                    colnames = c(
                                                                      "Financial Year",
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
  
  
  ## donwload iorn data

  output$download_hc_iorn_data <- downloadHandler(
    filename = "homecare_iorn.csv",
    content = function(file) {
      write.table(data_homecare_iorn %>%
                    select(financial_year, 
                           sending_location,
                           iorn_group,
                           level_of_service,
                           nclient,
                           propn_iorn), 
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "IoRN Group",
                    "Home Care Hours",
                    "Number of People",
                    "Percentage of People"
                  ),
                  sep = ","
      )
    }
  )

  #################################################

### end bracket -----
  
}

## END OF SCRIPT 
