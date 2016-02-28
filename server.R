library(shiny)

# Plotting 
library(ggplot2)
library(rCharts)
library(ggvis)

# Data processing libraries
library(data.table)
library(reshape2)
library(dplyr)

# Required by includeMarkdown
library(markdown)

# It has to loaded to plot ggplot maps on shinyapps.io
library(mapproj)
library(maps)

require(rCharts)


# Load data
#world_map <- map_data("world2")
world_map <- map_data(map="world")

dt <- fread('data/hunger.csv') %>% mutate(SEX = tolower(SEX))
dt <- dt[order(dt$YEAR)]
sexType <- sort(unique(dt$SEX))


# Shiny server 
shinyServer(function(input, output, session) {
    #options(shiny.error = browser)  
  
    # Define and initialize reactive values
    values <- reactiveValues()
    values$sextype <- sexType
 
    output$cnt1 <- renderText({nrow(dt)})
    
    # Create event type checkbox
    output$sextypeControls <- renderUI({
        checkboxGroupInput('sextype', 'Gender types', sexType, selected=values$sextype)
    })
    
    # Add observers on clear and select all buttons
    observe({
        if(input$clear_all == 0) return()
        values$sextype <- c()
    })
    
    observe({
        if(input$select_all == 0) return()
        values$sextype <- sexType
    })

    # Preapre datasets

    dt.agg.COUNTRY <-  reactive({dt %>% filter(YEAR >= input$range[1] , YEAR <= input$range[2], SEX %in% input$sextype) %>%
      group_by(COUNTRY) %>%
      summarise_each(funs(sum), TCOUNT)
      })

    dt.agg.YEAR <-  reactive({dt %>% filter(YEAR >= input$range[1] , YEAR <= input$range[2], SEX %in% input$sextype) %>%
                               group_by(YEAR) %>%  
                               summarise_each(funs(sum), TCOUNT) 
    })
    
  
    # Render Plot
  plot_hunger_by_country <- function (dt, world_map, year_min, year_max, fill, title, low = "#fff5eb", high = "#d94801") {
          replace_na <- function(x) ifelse(is.na(x), 0, x)
          round_2 <- function(x) round(x, -3)
          
          dt <- dt %>% rename (region = COUNTRY, TCOUNT = TCOUNT)
          allcountries <-  data.table(region=sort(unique(world_map$region)))
          dt<- left_join(allcountries, dt, by = "region") %>% 
            mutate_each(funs(replace_na), TCOUNT) %>%    mutate_each(funs(round_2), TCOUNT) 
        
          
          title <- sprintf(title, year_min, year_max)
          p <- ggplot(dt, aes(map_id = region))
          p <- p + geom_map(aes_string(fill = fill), map = world_map, colour='black')
          p <- p + expand_limits(x = world_map$long, y = world_map$lat)
          p <- p + coord_equal() + theme_bw()
          p <- p + labs(x = "Long", y = "Lat", title = title)
          #p + scale_fill_gradient(low = "green", high = "red", guide = "colourbar")
          p + scale_fill_gradient(low = low, high = high)
  
  }

    # Hunger count  by Country
    output$HungerByCountry <- renderPlot({
        print(plot_hunger_by_country (
            dt.agg.COUNTRY(),
            world_map = world_map, 
            year_min = input$range[1],
            year_max = input$range[2],
            title = "Hunger count from  %d - %d",
            fill = "TCOUNT"
        ))
    })
    

  plot_hunger_by_year <- function(dt) {
    HByYear <- nPlot(
      TCOUNT ~ YEAR,
      data = dt,
      type = "multiBarChart", dom = "HungerCountByYear", width = 650
    )
     HByYear$chart(margin = list(left = 100))
     HByYear$yAxis( axisLabel = "Count", width = 80)
     HByYear$xAxis( axisLabel = "Year", width = 70)
    HByYear
  }

    # Hunger by year
    output$HungerByYear <- renderChart2({
      plot_hunger_by_year(dt.agg.YEAR())
    })
    
    # Render data table and create download handler
    output$table <- renderDataTable(
        {if(input$DataTypeCategory =='country'){
          dt.agg.COUNTRY()
        } else if (input$DataTypeCategory =='year'){
          dt.agg.YEAR()
        } else {
          dt
        }
        }, options = list(bFilter = FALSE, iDisplayLength = 50))

    output$downloadData <- downloadHandler(
        filename = 'data.csv',
        content = function(file) {
            write.csv(dt.agg.COUNTRY(), file, row.names=FALSE)
        }
    )
})