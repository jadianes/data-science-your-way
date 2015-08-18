library(shiny)
library(tm)
library(SnowballC)
library(randomForest)

options(shiny.maxRequestSize=3*1024^2)
options(mc.cores=1)

build_model <- function(new_data_df, sparsity) {
    # Create new data corpus
    new_corpus <- Corpus(VectorSource(new_data_df$Text))
    new_corpus <- tm_map(new_corpus, content_transformer(tolower))
    new_corpus <- tm_map(new_corpus, removePunctuation)
    new_corpus <- tm_map(new_corpus, removeWords, stopwords("english"))
    new_corpus <- tm_map(new_corpus, stripWhitespace)
    new_corpus <- tm_map(new_corpus, stemDocument)
    message("build_model: corpus DONE")
    
    # create document-term matrix
    new_dtm <- DocumentTermMatrix(new_corpus)
    new_dtm <- removeSparseTerms(new_dtm, sparsity)
    new_dtm_df <- as.data.frame(as.matrix(new_dtm))
    colnames(new_dtm_df) <- make.names(colnames(new_dtm_df))
    message("build_model: ", "term matrix created for new data with ", ncol(new_dtm_df), " variables")
    
    # intersect corpora and prepare final training data
    common_names = intersect(colnames(train_dtm_df),colnames(new_dtm_df))
    new_dtm_df <- subset(new_dtm_df, select=names(new_dtm_df) %in% common_names)
    message("build_model: ", "new data term matrix reduced to ", ncol(new_dtm_df), " variables")
    
    model_train_data_df <- cbind(train_data_df, subset(train_dtm_df, select=names(train_dtm_df) %in% common_names))
    model_train_data_df$Text <- NULL
    message("build_model: ", "final training data created with ", ncol(model_train_data_df)-1, " variables")
    
    # train classifier
    message("build_model: ", "training classifier...")
    model <- randomForest(Sentiment~.,data=model_train_data_df, ntree=50)
    message("build_model: ", "classifier training DONE!")
    
    list(model, new_dtm_df)
}


shinyServer(function(input, output) {
    
    output$contents <- renderTable({
        results()
    })
    
    output$status <- renderText({
        if (!is.null(train_dtm_df))
            return("Ready!")
        return("Starting...")
    })
    
    output$distribution <- renderPlot({
        if (is.null(results()))
            return(NULL)
        d <- density(
            as.numeric(results()$Prob > input$threshold)
        )
        plot(
            d, 
            xlim = c(0, 1),
            main=paste0("Sentiment Distribution (Prob > ", input$threshold, ")")
        )
        polygon(d, col="lightgrey", border="lightgrey")
        abline(v = input$threshold, col = "blue")
    })
    
    results <- reactive({
        inFile <- input$file1
            
        if (is.null(inFile))
            return(NULL)
        
        # load input data
        new_data_df <- read.csv(
            inFile$datapath, 
            sep='\t', 
            header=FALSE, 
            quote = "",
            stringsAsFactor=F,
            col.names=c("Text")
        )
        message("renderTable: ", "input file loaded")
        
        model_and_data <- build_model(new_data_df, input$sparsity)
        
        message("renderTable: ", "making predictions...")
        pred <- predict(model_and_data[[1]], newdata=model_and_data[[2]], type="prob")
        message("renderTable: ", "predictions DONE")
        
        new_data_df$Prob <- pred[,2]

        new_data_df
    })
})

# Load train and test data
train_data_df <- read.csv(
    file = 'train_data.tsv',
    sep='\t', 
    quote = "",
    header=FALSE, 
    stringsAsFactor=F,
    col.names=c("Sentiment", "Text")
)
train_data_df$Sentiment <- as.factor(train_data_df$Sentiment)
message(paste("There are", nrow(train_data_df), "rows in training dataset"))

# Create training corpus for later re-use
train_corpus <- Corpus(VectorSource(train_data_df$Text))
#message("init: corpus created with length ", length(train_corpus))
train_corpus <- tm_map(train_corpus, content_transformer(tolower))
#message("init: corpus lowercased with length ", length(train_corpus))
train_corpus <- tm_map(train_corpus, removePunctuation)
#message("init: corpus punctuation removed with length ", length(train_corpus))
train_corpus <- tm_map(train_corpus, removeWords, stopwords("english"))
#message("init: corpus stopwords removed with length ", length(train_corpus))
train_corpus <- tm_map(train_corpus, stripWhitespace)
#message("init: corpus space stripped with length ", length(train_corpus))
train_corpus <- tm_map(train_corpus, stemDocument)
#message("init: corpus stemmed with length ", length(train_corpus))
message("init: training corpus DONE")

# create document-term matrix
train_dtm <- DocumentTermMatrix(train_corpus)
train_dtm <- removeSparseTerms(train_dtm, 0.995)
message(paste0("init: training dtm created (", ncol(train_dtm), " terms in training corpus)"))
train_dtm_df <- data.frame(as.matrix(train_dtm))
message(paste0("init: training dtm converted to df (", ncol(train_dtm), " terms in training corpus)"))
colnames(train_dtm_df) <- make.names(colnames(train_dtm_df))
message(paste0("init: training dtm DONE (", ncol(train_dtm_df), " terms in training corpus)"))


