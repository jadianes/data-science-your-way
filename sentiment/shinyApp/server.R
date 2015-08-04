library(shiny)
library(tm)

build_model <- function() {
    # Load train and test data
    train_data_df <- read.csv(
        text = "../train_data.csv", 
        sep='\t', 
        header=FALSE, 
        quote = "",
        stringsAsFactor=F,
        col.names=c("Sentiment", "Text"))
    test_data_df <- read.csv(
        text = "../test_data.csv", 
        sep='\t', 
        header=FALSE, 
        quote = "",
        stringsAsFactor=F,
        col.names=c("Text"))
    train_data_df$Sentiment <- as.factor(train_data_df$Sentiment)
    # Create corpus
    corpus <- Corpus(VectorSource(c(train_data_df$Text, test_data_df$Text)))
    corpus <- tm_map(corpus, tolower)
    corpus <- tm_map(corpus, PlainTextDocument)
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, stemDocument)
    # create document-term matrix
    dtm <- DocumentTermMatrix(corpus)
    sparse <- removeSparseTerms(dtm, 0.99)
    important_words_df <- as.data.frame(as.matrix(sparse))
    colnames(important_words_df) <- make.names(colnames(important_words_df))
    # split into train and test
    important_words_train_df <- head(important_words_df, nrow(train_data_df))
    # Add to original dataframes
    train_data_words_df <- cbind(train_data_df, important_words_train_df)
    test_data_words_df <- cbind(test_data_df, important_words_test_df)
    # Get rid of the original Text field
    train_data_words_df$Text <- NULL
    test_data_words_df$Text <- NULL
    # train classifier
    log_model <- glm(Sentiment~., data=train_data_words_df, family=binomial)
}

build_model()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot
    
    output$distPlot <- renderPlot({
        x    <- faithful[, 2]  # Old Faithful Geyser data
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
})
