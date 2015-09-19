# Prepare corpus using snippet
# newsTrain$AllText <- do.call(paste, newsTrain[,c("Headline","Snippet","Abstract")])
# newsTest$AllText <- do.call(paste, newsTest[,c("Headline","Snippet","Abstract")])
newsTrain$AllText <- do.call(paste, newsTrain[,c("Headline","Snippet")])
newsTest$AllText <- do.call(paste, newsTest[,c("Headline","Snippet")])

corpusAll <- Corpus(VectorSource(c(newsTrain$AllText, newsTest$AllText)))
corpusAll <- tm_map(corpusAll, tolower)
corpusAll <- tm_map(corpusAll, PlainTextDocument)
corpusAll <- tm_map(corpusAll, removePunctuation)
corpusAll <- tm_map(corpusAll, removeWords, stopwords("english"))
corpusAll <- tm_map(corpusAll, stripWhitespace)
corpusAll <- tm_map(corpusAll, stemDocument)

# Generate term matrix
dtmAll <- DocumentTermMatrix(corpusAll)
sparseAll <- removeSparseTerms(dtmAll, 0.99)
allWords <- as.data.frame(as.matrix(sparseAll))

colnames(allWords) <- make.names(colnames(allWords))

# Find most significative terms
allWordsTrain2 <- head(allWords, nrow(newsTrain))
allWordsTrain2$Popular <- newsTrain$Popular
logModelAllWords <- glm(Popular~., data=allWordsTrain2, family=binomial)
all_three_star_terms <- names(which(summary(logModelAllWords)$coefficients[,4]<0.001))
all_two_star_terms <- names(which(summary(logModelAllWords)$coefficients[,4]<0.01))
all_one_star_terms <- names(which(summary(logModelAllWords)$coefficients[,4]<0.05))

# Leave just those terms that are different between popular and unpopular articles
allWords <- subset(allWords, 
                       select=names(allWords) %in% all_one_star_terms)

# Split again
allWordsTrain <- head(allWords, nrow(newsTrain))
allWordsTest <- tail(allWords, nrow(newsTest))

# Add to dataframes
newsTrain <- cbind(newsTrain, allWordsTrain)
newsTest <- cbind(newsTest, allWordsTest)

# Explore a bit
# ...

# Remove original text variables
newsTrain$AllText <- NULL
newsTest$AllText <- NULL

