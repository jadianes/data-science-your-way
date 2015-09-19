# Prepare corpus using snippet
corpusAbstract <- Corpus(VectorSource(c(newsTrain$Abstract, newsTest$Abstract)))
corpusAbstract <- tm_map(corpusAbstract, tolower)
corpusAbstract <- tm_map(corpusAbstract, PlainTextDocument)
corpusAbstract <- tm_map(corpusAbstract, removePunctuation)
corpusAbstract <- tm_map(corpusAbstract, removeWords, stopwords("english"))
corpusAbstract <- tm_map(corpusAbstract, stripWhitespace)
corpusAbstract <- tm_map(corpusAbstract, stemDocument)

# Generate term matrix
dtmAbstract <- DocumentTermMatrix(corpusAbstract)
sparseAbstract <- removeSparseTerms(dtmAbstract, 0.995)
abstractWords <- as.data.frame(as.matrix(sparseAbstract))

colnames(abstractWords) <- make.names(colnames(abstractWords))
colnames(abstractWords) <- paste0("A_", colnames(abstractWords))

# Find most significative terms
abstractWordsTrain2 <- head(abstractWords, nrow(newsTrain))
abstractWordsTrain2$Popular <- newsTrain$Popular
logModelAbstractWords <- glm(Popular~., data=abstractWordsTrain2, family=binomial)
abstract_three_star_terms <- names(which(summary(logModelAbstractWords)$coefficients[,4]<0.001))
abstract_two_star_terms <- names(which(summary(logModelAbstractWords)$coefficients[,4]<0.01))
abstract_one_star_terms <- names(which(summary(logModelAbstractWords)$coefficients[,4]<0.05))

# Leave just those terms that are different between popular and unpopular articles
abstractWords <- subset(abstractWords, 
                       select=names(abstractWords) %in% abstract_three_star_terms)

# split again
abstractWordsTrain <- head(abstractWords, nrow(newsTrain))
abstractWordsTest <- tail(abstractWords, nrow(newsTest))

# Add to dataframes
newsTrain <- cbind(newsTrain, abstractWordsTrain)
newsTest <- cbind(newsTest, abstractWordsTest)

# Explore a bit
# ...

# Remove original text variables
newsTrain$Abstract <- NULL
newsTest$Abstract <- NULL
