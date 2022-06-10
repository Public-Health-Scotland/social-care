
#####################################################
## Self-directed Support Server Script ##
#####################################################


### Author: Ciaran Harvey
### Orignal Date: 05/06/19
### Written/run on R Studio Server
### R version 3.2.3
### Server script for dashbaord
############################################################



########################
### Self Directed Support (SDS) ----
########################


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
  
  
  
  
  ###########################
  ## Information
  ##########################
  
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
  
  #########################
  ## X.1.1 SDS Trend ----
  #########################
  
    ## data ----
  
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
  
    ## plot -----
  
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
                          title = paste0(c(
                            rep("&nbsp;", 30),
                            "Rate per 1,00 Population",
                            rep("&nbsp;", 30),
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
                          showline = TRUE,
                          ticks = "outside",
                          showgrid = FALSE
                          ),
             
             ### Plot title

            title = if_else(input$sds_trend_location_input == input$sds_trend_location_comparator_input,
                            if_else(input$sds_trend_option_input != "Any SDS", 
                                    paste0("<b> Rate per 1,000 People choosing Self-directed Support ", input$sds_trend_option_input,
                                           " <br>", input$sds_trend_location_input, ", 2014/15 - 2020/21."),
                                    paste0("<b> Number of People choosing ", input$sds_trend_option_input,
                                           " Option <br>", input$sds_trend_location_input, ", 2017/18 - 2020/21.")
                                    ),
                            if_else(input$sds_trend_option_input != "Any SDS", 
                                    paste0("<b> Rate per 1,000 People choosing Self-directed Support ", input$sds_trend_option_input,
                                           " <br>", input$sds_trend_location_input, " and ", input$sds_trend_location_comparator_input, 
                                           ", 2014/15 - 2020/21."),
                                    paste0("<b> Number of People choosing ", input$sds_trend_option_input,
                                           " Option <br>", input$sds_trend_location_input, " and ", input$sds_trend_location_comparator_input, 
                                           ", 2017/18 - 2020/21.")
                            )),
            
             
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
  
    ## show / hide table -----
  
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
  
    ## download ----
  
  output$download_sds_trend_data <- downloadHandler(
    filename = "sds_trend.csv",
    content = function(file) {
      write.table(data_sds_trend %>%
                    select(financial_year, sending_location, option_type, rate, nclient),
                  file,
                  row.names = FALSE,
                  col.names = c(
                    "Financial Year",
                    "Location",
                    "Option Type",
                    "Rate per 1000 People",
                    "Number of People"
                  ),
                  sep = ",")
    }
  )
  
  #################################
  ## X.1.2 SDS Options Chosen ----
  ##################################
  
  ## data -----
  
  data_sds_options_chosen_plot <- reactive({
    data_sds_options_chosen %>%
      filter(financial_year   == input$sds_options_chosen_year_input, 
             sending_location == input$sds_options_chosen_location_input,
             age_group        == input$sds_options_chosen_age_group)
  })
  
  
  
  ## plot ----
  
  output$sds_options_chosen_plot <- renderPlotly({
    plot_ly(data_sds_options_chosen_plot(),
            x = ~ option_type,                                               
            y = ~ rate,
            type = "bar",
            marker = list(color = "rgb(67,57,132)"),                                          
            
            
            ## Add tooltip to plot 
            hoverinfo = "text",
            text = ~ paste(
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
         title = paste0("<b> Rate per 1,000 People, ", input$sds_options_chosen_age_group, " by choice of Self-directed Support Option, <br>",
                      input$sds_options_chosen_location_input, ", ", input$sds_options_chosen_year_input, "."),
          
          
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
  })
  
  ## show / hide data table -----
  
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
  
  ## download data ----
  
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
  #################################
  ## SDS Implementation by HSCP 
  #################################
  ## data -----
  
  data_sds_implementation_hscp_plot <- reactive({
    data_sds_implementation_rate %>%
      filter(financial_year   == input$sds_implementation_hscp_year_input)
    })


  ## plot ----
  
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
            text = ~ paste(
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
          title =  paste0("<b> Percentage of People who receive Social Care Services and <br> Support through SDS, by Health and Social Care Partnership, ", 
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
          
       %>%
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
      )
  })
  
  ## show / hide data table -----
  
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
  
  ## download data ----
  
  output$download_sds_implementation_hscp_data <- downloadHandler(
    filename = "sds_implementation_rate.csv",
    content = function(file) {
      write.table(data_sds_implementation_rate %>%
                    select(financial_year,
                           sending_location,
                           implementation_rate,
                           sdsclient),
                    mutate(
                           implementation_rate = formatC(implementation_rate,
                                          format = "f",
                                          big.mark = ",",
                                          drop0trailing = TRUE),
                           sdsclient = formatC(sdsclient, format = "f", big.mark = ",", drop0trailing = TRUE)),
                  file,
                  row.names = FALSE,
                  col.names = c("Financial Year",
                                "Location",
                                "Percentage of Implementation",
                                "Number of People going through SDS"),
                  sep = ",")
    }
  )
  #################################
  ## Implementation Trend - NEW
  ################################
  ## data ----
  
  data_sds_implementation_plot <- reactive({
    data_sds_implementation_rate %>%
      filter(sending_location == input$sds_implementation_location_input)
  })
  
  data_sds_implementation_comparator <- reactive({
    data_sds_implementation_rate %>%
      filter(sending_location == input$sds_implementation_comparator_location_input)
  })
  
  ## plot -----
  
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
                       paste0("<b> Percentage of People who receive Social Care Services and <br> Support through SDS, ",
                              input$sds_implementation_location_input,
                              ", 2017/18 - 2020/21."),
                       paste0("<b> Percentage of People  who receive Social Care Services and <br> Support through SDS, ",
                              input$sds_implementation_location_input, " and <br>", 
                              input$sds_implementation_comparator_location_input,
                              ", 2017/18 - 2020/21.")
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
  
  ## show / hide table -----

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

  ## download ----

  output$download_sds_implementation_data <- downloadHandler(
    filename = "sds_implementation_rate.csv",
    content = function(file){
      write.table(data_sds_implementation_rate %>%
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
  #############################################
  ## X.1.3 SDS Option Chosen by Age Group  ----
  #############################################
  ## Filtered Data ----
  
  
  sds_options_age_plot <- reactive({
    data_sds_options_proportion %>%
      filter(
        financial_year   == input$sds_options_age_year_input,
        sending_location == input$sds_options_age_location_input
      )
  })
  
  ## Plot ----
   
  output$sds_options_age_plot <- renderPlotly({
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
            text = ~ paste(
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
              "Number of People:", format(nclients, big.mark = ","),
              "<br>"
            )
    ) %>%
      layout(
        title = paste0("<b> Percentage of People receiving Self-directed Support by <br> Age Group and Options Chosen, ",
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
  })
  
  ## Data Table ----
  
  data_sds_options_age_table <- reactive({
    sds_options_age_plot() %>%
      mutate(number_of_people = format(nclients, big.mark = ","),
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
  
  ## download data ----
  
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
  
  
  
  #######################################
  ## X.1.4 SDS Client Group Profile ----
  #######################################
  ## data -----
  
  data_sds_client_plot <- reactive({
    data_sds_client_group %>%
      filter(
        sending_location == input$sds_client_location_input,
        financial_year   == input$sds_client_year_input,
        age_group        == input$sds_client_age_input)
  })
  
  
  
  
  ## plot ----
  
  output$sds_client_plot <- renderPlotly({
    plot_ly(data_sds_client_plot(),
            x = ~rate,
            y = ~client_group,
            type = "bar",
            marker = phs_bar_col,
            hoverinfo = "text",
            text = ~ paste("Financial Year:", input$sds_client_year_input,
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
        
        title = paste0("<b> Rate per 1,000 SDS Clients, ", input$sds_client_age_input, 
                       ", receiving SDS (All Options) <br> by Client group, ",
                       input$sds_client_location_input, ", ", input$sds_client_year_input, "."),     
        
        
        margin = list(l = 10, r = 10, b = 70, t = 120)
        ) %>%  
      
      
      config(displayModeBar = TRUE,
             modeBarButtonsToRemove = buttons_to_remove,
             displaylogo = F,  
             editable = F)
  })
  
  ## show / hide data table ----
  
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
  
  ## donwload data ----
  
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
                                "Rate per 1,000 Self-directed Support Clients",
                                "Number of People"),
                  sep = ",")
    }
  )
  
  ###################################
  ## X.1.5 SDS Support/Service Needs ----
  ###################################
  
  ## data ----
  
  data_sds_support_service_plot <- reactive({
    data_sds_support_needs %>%
      filter(financial_year   == input$sds_support_service_year_input,
             sending_location == input$sds_support_service_location_input,
             age_group        == input$sds_support_service_age_input)
  })


  ## plot ----
  
  output$sds_support_service_plot <- renderPlotly({
    plot_ly(data_sds_support_service_plot(),
             y = ~sds_support_need,
             x = ~rate,
             type = "bar",
             marker = list(color = "rgb(67,57,132)"),     # specify bar chart colour
             
             ## Add tooltip to plot
             hoverinfo = "text",
             text = ~ paste(
               "Financial Year:", financial_year,
               "<br>",
               "Location:", sending_location,
               "<br>",
               "Age Group:", age_group,
               "<br>",
               "Support:", ifelse(sds_support_need == "Equipment and Temp...", "Equipment and Temporary Adaptations",
                                      ifelse(sds_support_need == "Social Educational...", "Social Educational Recreational", sds_support_need)
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

        
        title = paste0("<b> Rate per 1,000 SDS Clients, ", input$sds_support_service_age_input, 
                       ", <br> receiving SDS (All Options) by Assessed Support Need, <br>",
                       input$sds_support_service_location_input, ", ", input$sds_support_service_year_input, "."),
          
          
        margin = list(l = 70, r = 20, b = 70, t = 120)

      ) %>%
      
      
      config(
        displayModeBar = TRUE,
        modeBarButtonsToRemove = buttons_to_remove,
        displaylogo = F,
        editable = F
      )
  })
  
  ## show / hide data table ----
  
  data_sds_support_service_table <- reactive({
    data_sds_support_service_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        sds_support_need,
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
  
  
  
  
  ## download data -----

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
  
  
  #######################################
  ## X.1.6 SDS Type of Organisation ----
  #######################################
  
  ## data ----
  
  data_sds_type_of_organisation_plot <- reactive({
    data_sds_type_of_organisation %>%
      filter(financial_year   == input$sds_organisation_year_input,
             sending_location == input$sds_organisation_location_input,
             age_group        == input$sds_organisation_age_input)
  })
  
  
  
  ## plot ----
  
  output$sds_organisation_plot <- renderPlotly({
    plot_ly(data_sds_type_of_organisation_plot(),
            y = ~sds_support_services,
            x = ~rate,
            type = "bar",
            marker = phs_bar_col,
        
      ## add tooltip info 
            hoverinfo = "text",
            text = ~ paste(
              "Financial Year:", financial_year,
              "<br>",
              "Location:", sending_location,
              "<br>",
              "Age Group:", input$sds_organisation_age_input,
              "<br>",
              "Support Organisation Type:", sds_support_services,
              "<br>",
              "Rate per 1,000 SDS Clients:", formatC(round(rate,1), format = "f", big.mark = ",", drop0trailing = TRUE),
              "<br>",
              "Number of People:", formatC(nclient, format = "f", big.mark = ",", drop0trailing = TRUE)
            )) %>%
      layout(

        
        
        # PLOT TITLE
        title = paste0("<b> Rate per 1,000 SDS Clients, ", input$sds_organisation_age_input, 
                       ", <br> receiving SDS (All Options) by Support Organisation Type, <br>",
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
  })
  
  ## show / hide table ----
  
  data_sds_organisation_table <- reactive({
    data_sds_type_of_organisation_plot() %>%
      select(
        financial_year,
        sending_location,
        age_group,
        sds_support_services,
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
                                    
                  
  
  ## download data -----

  output$download_sds_support_organisation <- downloadHandler(
    filename = "sds_support_service_organisation.csv",
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