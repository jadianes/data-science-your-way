library(shiny)

shinyUI(fluidPage(
    
    # Application title
    headerPanel("Text Sentiment Analyser"),
    
    sidebarLayout(
        # the control panel
        sidebarPanel(
            helpText("Starting...",
            textOutput("status")
            ),
            tags$hr(),
            fileInput('file1', 'Choose text File',
                      accept=c('text/tsv', 
                               'text/tab-separated-values,text/plain', 
                               '.tsv')),
            tags$hr(),
            sliderInput("threshold",
                        "Positive sentiment threshold",
                        min = .1,
                        max = .99,
                        value = .5),
            tags$hr(),
            sliderInput("sparsity",
                        "Max. term sparsity",
                        min = .1,
                        max = .99,
                        value = .95)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput('distribution')
        )
    ),
    tags$hr(),
    fluidRow(
        # the results detail panel
        column(12,
            tableOutput('contents')
        )
    )
))
