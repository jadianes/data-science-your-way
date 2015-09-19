# Prepare corpus using headline
corpusHeadline <- Corpus(VectorSource(c(newsTrain$Headline, newsTest$Headline)))
corpusHeadline <- tm_map(corpusHeadline, tolower)
corpusHeadline <- tm_map(corpusHeadline, PlainTextDocument)
corpusHeadline <- tm_map(corpusHeadline, removePunctuation)
corpusHeadline <- tm_map(corpusHeadline, removeWords, stopwords("english"))
corpusHeadline <- tm_map(corpusHeadline, stripWhitespace)
corpusHeadline <- tm_map(corpusHeadline, stemDocument)

# Generate term matrix
dtm <- DocumentTermMatrix(corpusHeadline)
sparse <- removeSparseTerms(dtm, 0.99)
headlineWords <- as.data.frame(as.matrix(sparse))

colnames(headlineWords) <- make.names(colnames(headlineWords))
colnames(headlineWords) <- paste0("H_", colnames(headlineWords))

# Find most significative terms
headlineWordsTrain2 <- head(headlineWords, nrow(newsTrain))
headlineWordsTrain2$Popular <- newsTrain$Popular
logModelHeadlineWords <- glm(Popular~., data=headlineWordsTrain2, family=binomial)
three_star_terms <- names(which(summary(logModelHeadlineWords)$coefficients[,4]<0.001))
two_star_terms <- names(which(summary(logModelHeadlineWords)$coefficients[,4]<0.01))
one_star_terms <- names(which(summary(logModelHeadlineWords)$coefficients[,4]<0.05))

# Leave just those terms that are different between popular and unpopular articles
headlineWords <- subset(headlineWords, 
                        select=names(headlineWords) %in% one_star_terms)
                    

# Filter out common frequent terms
# headlineWordsCountsPopular <- colSums(subset(headlineWords, Popular==T))
# headlineWordsCountsUnpopular <- colSums(subset(headlineWords, Popular==F))
# topPopular <- tail(sort(headlineWordsCountsPopular), 20)
# topUnpopular <- tail(sort(headlineWordsCountsUnpopular), 20)

# Leave just those terms that are different between popular and unpopular articles
# headlineWords <- subset(headlineWords, 
#                         select=names(headlineWords) %in% setdiff(names(topPopular), names(topUnpopular))
#                     )

# Split again
headlineWordsTrain <- head(headlineWords, nrow(newsTrain))
headlineWordsTest <- tail(headlineWords, nrow(newsTest))

# Add to dataframes
newsTrain <- cbind(newsTrain, headlineWordsTrain)
newsTest <- cbind(newsTest, headlineWordsTest)

# Remove original text variables
newsTrain$Headline <- NULL
newsTest$Headline <- NULL

