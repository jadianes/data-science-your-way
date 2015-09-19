# Prepare corpus using snippet
corpusSnippet <- Corpus(VectorSource(c(newsTrain$Snippet, newsTest$Snippet)))
corpusSnippet <- tm_map(corpusSnippet, tolower)
corpusSnippet <- tm_map(corpusSnippet, PlainTextDocument)
corpusSnippet <- tm_map(corpusSnippet, removePunctuation)
corpusSnippet <- tm_map(corpusSnippet, removeWords, stopwords("english"))
corpusSnippet <- tm_map(corpusSnippet, stripWhitespace)
corpusSnippet <- tm_map(corpusSnippet, stemDocument)

# Generate term matrix
dtmSnippet <- DocumentTermMatrix(corpusSnippet)
sparseSnippet <- removeSparseTerms(dtmSnippet, 0.99)
snippetWords <- as.data.frame(as.matrix(sparseSnippet))

colnames(snippetWords) <- make.names(colnames(snippetWords))
colnames(snippetWords) <- paste0("S_", colnames(snippetWords))

# Find most significative terms
snippetWordsTrain2 <- head(snippetWords, nrow(newsTrain))
snippetWordsTrain2$Popular <- newsTrain$Popular
logModelSnippetWords <- glm(Popular~., data=snippetWordsTrain2, family=binomial)
snippet_three_star_terms <- names(which(summary(logModelSnippetWords)$coefficients[,4]<0.001))
snippet_two_star_terms <- names(which(summary(logModelSnippetWords)$coefficients[,4]<0.01))
snippet_one_star_terms <- names(which(summary(logModelSnippetWords)$coefficients[,4]<0.05))

# Leave just those terms that are different between popular and unpopular articles
snippetWords <- subset(snippetWords, 
                        select=names(snippetWords) %in% snippet_one_star_terms)

# Split again
snippetWordsTrain <- head(snippetWords, nrow(newsTrain))
snippetWordsTest <- tail(snippetWords, nrow(newsTest))

# Add to dataframes
newsTrain <- cbind(newsTrain, snippetWordsTrain)
newsTest <- cbind(newsTest, snippetWordsTest)

# Explore a bit
# ...

# Remove original text variables
newsTrain$Snippet <- NULL
newsTest$Snippet <- NULL

