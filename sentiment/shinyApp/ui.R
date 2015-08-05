library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    headerPanel("Text Sentiment Analyser"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput('file1', 'Choose text File',
                      accept=c('text/csv', 
                               'text/comma-separated-values,text/plain', 
                               '.csv')),
            tags$hr(),
            sliderInput("threshold",
                        "Positive sentiment threshold",
                        min = 0.1,
                        max = 1.0,
                        value = .5),
            tags$hr(),
            sliderInput("num_trees",
                        "Num. trees in RandomForest",
                        min = 5,
                        max = 500,
                        value = 10)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput('distribution')
        )
    ),
    tags$hr(),
    fluidRow(
        column(12,
            tableOutput('contents')
        )
    )
))
