# A bit of exploratory data analysis to see which of these variables make
# a difference between popular articles

summary(newsTrain)
table(newsTrain$Popular)

table(newsTrain$Popular, newsTrain$NewsDesk)

table(newsTrain$Popular, newsTrain$SectionName)

table(newsTrain$Popular, newsTrain$SubsectionName)

summary(newsTrain$WordCount)
table(newsTrain$Popular, newsTrain$WordCount>374)

table(newsTrain$Popular, newsTrain$MonthOfTheYear)
table(newsTrain$Popular, newsTrain$DayOfTheWeek)
hoursPopular <- data.frame(table(newsTrain$Popular, newsTrain$HourOfTheDay))

# Let's plot this
library(ggplot2)
ggplot(hoursPopular, aes(x=Var2, y=Freq)) + geom_line(aes(group=Var1, color=Var1))

# explore headline corpus
headlineWordsCountsPopular <- colSums(subset(headlineWords, Popular==T))
headlineWordsCountsUnpopular <- colSums(subset(headlineWords, Popular==F))
headlineWordsCountsPopular
topPopular <- tail(sort(headlineWordsCountsPopular), 100)
topUnpopular <- tail(sort(headlineWordsCountsUnpopular), 100)
topPopular[names(topPopular) %in% names(topUnpopular)]
topUnpopular[names(topUnpopular) %in% names(topPopular)]

headlineWordsPopularDiff <- subset(headlineWords, select=names(headlineWords) %in% setdiff(names(topPopular), names(topUnpopular)))
