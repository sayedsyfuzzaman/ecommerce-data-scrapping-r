library(shiny)
library(shinythemes)
library(DT)

df <- read.csv('data/dataset.csv')
cln_df <- read.csv('data/cleaned_dataset.csv')

ui <- fluidPage(theme = shinytheme("cosmo"),
                navbarPage(
                    "E-Commerce Data Scrapping and Analysis",
                    tabPanel("Overview",
                             sidebarPanel(
                                 h3("Project Name: E-Commerce Data Scrapping and Analysis"),
                                 p("Final Term Project"),
                                 p("Introduction to Data Science [B]"),
                                 uiOutput("datasource"),
                                 uiOutput("github")
                             ),
                             mainPanel(
                                 h1("Project Overview"),
                                 textOutput("poverview"),
                                 br(),
                                 
                                 h1("Solution Design"),
                                 imageOutput("solution"),
                                 br(),
                                 br(),
                                 br(),
                                 br(),
                                 br(),
                                 h1("Collection of data by web scrapping"),
                                 fluidRow(
                                     column(
                                         dataTableOutput(outputId = "dataset"), width = 12)
                                 ),
                                 br(),
                                 h1("Cleaned Data after data preprocessing"),
                                 fluidRow(
                                     column(
                                         dataTableOutput(outputId = "cleaned_dataset"), width = 12)
                                 ),
                                 
                                 br(),
                                 
                                 h1("Desriptive Statistics"),
                                 br(),
                                 strong("Mean of Price Attribute: "),
                                 verbatimTextOutput("mprice"),
                                 
                                 strong("Mode of Category Attribute: "),
                                 verbatimTextOutput("mcategory"),
                                 
                                 strong("Variance of Price Attribute: "),
                                 verbatimTextOutput("vprice"),
                                 
                                 strong("Standard Deviation of Price Attribute: "),
                                 verbatimTextOutput("sdprice"),
                                 
                                 strong("Quartile of Price Attribute: "),
                                 verbatimTextOutput("qprice"),
                                 
                             ) # mainPanel
                             
                    ),
                    tabPanel("Data Visualization",
                             mainPanel(
                                 h1("Data Visualization"),
                                 navlistPanel(
                                     id = "tabset",
                                     "Select Plots",
                                     tabPanel("Frequency of Each Category", plotOutput("frequencyofeachcategory")),
                                     tabPanel("Price vs Category", plotOutput("pricevscategory"),),
                                     tabPanel("Average Price Category", plotOutput("avgpricepercategory")),
                                     tabPanel("Maximum and Minimum Product by Category", plotOutput("maxpandminbycat"),),
                                     tabPanel("Product Price Histogram", imageOutput("productprice")),
                                     tabPanel("Availability Chart", imageOutput("availability"))
                                 )
                             )
                             
                    ),
                    tabPanel("Code",
                             sidebarPanel(
                                 h3("Project Code"),
                                 p("This project was all about scraping a data from an e-commerce site and do a complete analysis with that. The whole analysis has helped us gain knowledge with data and their workings which can use in our further data analysis.")
                             ),
                             mainPanel(
                                 tabsetPanel(
                                     type = "tab",
                                     tabPanel("scrapping.R", br(), verbatimTextOutput("scrapping")),
                                     tabPanel("data_cleaning.R", br(), verbatimTextOutput("data_cleaning")),
                                     tabPanel("visualizations.R", br(), verbatimTextOutput("visualizations")),
                                     tabPanel("app.R", br(), verbatimTextOutput("app"))
                                 )
                             )
                     ),
                    
                ) # navbarPage
) # fluidPage


# Define server function  
server <- function(input, output) {

    output$dataset <- renderDataTable(
        {df}, options = list(scrollX = TRUE, pageLength = 10))
    
    output$cleaned_dataset <- renderDataTable( 
        {cln_df}, options = list(scrollX = TRUE, pageLength = 10))
    
    output$poverview <- renderText(paste(readLines("overview.txt"), collapse="\n"))
    
    output$frequencyofeachcategory <- renderPlot(freq_of_each_car)
    
    output$pricevscategory <- renderPlot(prc_vs_cat)
    
    output$avgpricepercategory <- renderPlot(avg_p_cat)
    
    output$maxpandminbycat <- renderPlot(maxpandminp_by_cat)
    
    
    output$productprice <- renderImage({
        # Return a list containing the filename
        list(src = 'data/product_price.png',
             contentType = 'image/png')
    })
    
    output$availability <- renderImage({
        # Return a list containing the filename
        list(src = 'data/availability.jpg',
             contentType = 'image/jpg')
    })
    
    output$scrapping <- renderPrint({
        cat(paste(readLines("scrapping.R"), collapse="\n"), sep = "\n")
    })
    
    output$data_cleaning <- renderPrint({
        cat(paste(readLines("data_cleaning.R"), collapse="\n"), sep = "\n")
    })
    
    output$visualizations <- renderPrint({
        cat(paste(readLines("visualizations.R"), collapse="\n"), sep = "\n")
    })
    
    output$app <- renderPrint({
        cat(paste(readLines("app.R"), collapse="\n"), sep = "\n")
    })
    
    output$qprice <- renderPrint({
        quantile(products$Price)
    })
    
    output$mprice <- renderPrint({
        meanPrice
    })
    
    output$mcategory <- renderPrint({
        mode(products$Category)
    })
    
    output$vprice <- renderPrint({
        var(products$Price)
    })
    
    output$sdprice <- renderPrint({
        sd(products$Price)
    })
    
    output$solution <- renderImage({
        # Return a list containing the filename
        list(src = 'solution.png',
             contentType = 'image/png')
    })
    
    url <- a("MFFoodMart", href="https://www.mffoodmart.com/")
    output$datasource <- renderUI({
        tagList("Data Source: ", url)
    })
    
    url2 <- a("E-Commerce Data Scrapping and Analysis", href="https://github.com/sayedsyfuzzaman/ecommerce-data-scrapping-r")
    output$github <- renderUI({
        tagList("Project Github: ", url2)
    })
    
    
} # server


# Create Shiny object
shinyApp(ui = ui, server = server)

