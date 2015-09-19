library(tm)
library(ROCR)
library(rpart)
library(rpart.plot)
library(caTools)
library(randomForest)
library(caret)
library(e1071)

newsTrain <- read.csv("data/NYTimesBlogTrain.csv", stringsAsFactors=FALSE)
newsTest <- read.csv("data/NYTimesBlogTest.csv", stringsAsFactors=FALSE)

# Bind the data in order to do the transformations jusnt once
newsAll <- rbind(newsTrain[,-9], newsTest)

    
# Extract date information
newsAll$PubDate <- strptime(newsAll$PubDate, format="%Y-%m-%d %H:%M:%S")
newsAll$DayOfTheWeek <- as.factor(weekdays(newsAll$PubDate))
# We saw during exploration that mont doesn't make a difference
# newsAll$MonthOfTheYear <- as.factor(months(newsAll$PubDate))
newsAll$HourOfTheDay <- as.factor(newsAll$PubDate$hour)
newsAll$PubDate <- NULL # Get rid of the original Dates

# Convert to factors
newsAll$NewsDesk <- as.factor(newsAll$NewsDesk)
newsAll$SectionName <- as.factor(newsAll$SectionName)
newsAll$SubsectionName <- as.factor(newsAll$SubsectionName)

# Split again
Popular <- as.factor(newsTrain$Popular)
newsTrain <- head(newsAll, nrow(newsTrain))
newsTrain$Popular <- Popular
newsTest <- tail(newsAll, nrow(newsTest))
