
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

#install.packages ("ggvis")
library(shiny)

# Fix tag("div", list(...)) : could not find function "showOut… 
library(rCharts)

shinyUI(
    navbarPage("World Hunger Database Explorer",
        tabPanel("Plot",
                sidebarPanel(
                    sliderInput("range", 
                        "Range:", 
                        min = 1990, 
                        max = 2015, 
                        value = c(1990, 2015),
                        format="####"),
                    uiOutput("sextypeControls"),
                    actionButton(inputId = "clear_all", label = "Clear selection", icon = icon("check-square")),
                    actionButton(inputId = "select_all", label = "Select all", icon = icon("check-square-o"))
                ),
  
                mainPanel(
                    tabsetPanel(
                        
                        # Data by Country
                        tabPanel(p(icon("map-marker"), "By Country"),
                            column(7,
                                plotOutput("HungerByCountry")
                            )

                        ),
                        
                        # Time series data
                        tabPanel(p(icon("line-chart"), "By year"),
                                 h4('Hunger by year', align = "center"),
                                 showOutput("HungerByYear", "nvd3")
                        ),
                        
                        # Data 
                        tabPanel(p(icon("table"), "Data"),
                                 column(3,
                                        wellPanel(
                                          radioButtons(
                                            "DataTypeCategory",
                                            "Data:",
                                            c("By Country" = "country", "By Year" = "year", "Data Set- No filter" = "dataset"))
                                        )
                                 ),
                            downloadButton('downloadData', 'Download'),
                            dataTableOutput(outputId="table")
                        )
                    )
                )
            
        ),
        
        tabPanel("About",
            mainPanel(
                includeMarkdown("include.md")
            )
        )
    )
)
