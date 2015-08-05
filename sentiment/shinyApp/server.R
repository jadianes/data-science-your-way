library(shiny)
library(tm)

build_model <- function(new_data_df) {
    
    message("build_model: ", "starting...")
    # Load train and test data
    train_data_df <- read.csv(
        file = "train_data.csv", 
        sep='\t', 
        header=FALSE, 
        quote = "",
        stringsAsFactor=F,
        col.names=c("Sentiment", "Text"))
    message("build_model: ", "train data loaded")
    train_data_df$Sentiment <- as.factor(train_data_df$Sentiment)
    
    # Create corpus
    corpus <- Corpus(VectorSource(c(train_data_df$Text, new_data_df$Text)))
    message("build_model: ", "corpus created")
    corpus <- tm_map(corpus, tolower)
    message("build_model: ", "corpus to lower")
    corpus <- tm_map(corpus, PlainTextDocument)
    corpus <- tm_map(corpus, removePunctuation)
    message("build_model: ", "corpus punctuation removed")
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    message("build_model: ", "corpus stopwords removed")
    corpus <- tm_map(corpus, stripWhitespace)
    message("build_model: ", "corpus white space stripped")
    corpus <- tm_map(corpus, stemDocument)
    message("build_model: ", "corpus stemmed")
    message("build_model: ", "corpus DONE")
    
    # create document-term matrix
    dtm <- DocumentTermMatrix(corpus)
    sparse <- removeSparseTerms(dtm, 0.98)
    important_words_df <- as.data.frame(as.matrix(sparse))
    colnames(important_words_df) <- make.names(colnames(important_words_df))
    # split into train and test
    important_words_train_df <- head(important_words_df, nrow(train_data_df))
    important_words_new_df <- tail(important_words_df, nrow(new_data_df))
    # Add to original dataframes
    train_data_words_df <- cbind(train_data_df, important_words_train_df)
    new_data_words_df <- cbind(new_data_df, important_words_new_df)
    # Get rid of the original Text field
    train_data_words_df$Text <- NULL
    new_data_words_df$Text <- NULL
    message("build_model: ", "term matrix created")
    
    # train classifier
    log_model <- glm(Sentiment~., data=train_data_words_df, family=binomial)
    message("build_model: ", "model trained")
    
    list(log_model, new_data_words_df)
}



shinyServer(function(input, output) {
    
    output$contents <- renderTable({
        results()
    })
    
    output$distribution <- renderPlot({
        if (is.null(results()))
            return(NULL)
        d <- density(
            as.numeric(results()$Sentiment)
        )
        plot(
            d, 
            xlim = c(0, 1),
            main="Sentiment Distribution"
        )
        polygon(d, col="lightgrey", border="lightgrey")
    })
    
    distribution <- reactive({
        
    })
    results <- reactive({
        inFile <- input$file1
            
        if (is.null(inFile))
            return(NULL)
        
        # load input data
        new_data_df <- read.csv(
            inFile$datapath, 
            header=input$header, 
            sep=input$sep, 
            quote=input$quote,
            stringsAsFactor=F,
            col.names=c("Text")
        )
        message("renderTable: ", "input file loaded")
        
        model_and_data <- build_model(new_data_df)
        
        pred <- predict(model_and_data[[1]], newdata=model_and_data[[2]], type="response")
        message("renderTable: ", "predictions made")
        
        new_data_df$Sentiment <- pred
        
        new_data_df
    })
})

