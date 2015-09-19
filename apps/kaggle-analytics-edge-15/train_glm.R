set.seed(1234)
logModel <- glm(Popular~.-UniqueID, data=evalNewsTrain, family=binomial)
summary(logModel)

logModel <- glm(
    Popular~
        I(NewsDesk=="Culture") + I(NewsDesk=="OpEd") + I(NewsDesk=="Styles") + I(NewsDesk=="TStyle") +
        I(SectionName=="Multimedia") + I(SubsectionName=="Room For Debate") + (SubsectionName=="The Public Editor") +
        WordCount +
        I(DayOfTheWeek=="Monday") + I(DayOfTheWeek=="Sunday") + 
        I(HourOfTheDay=="7") + I(HourOfTheDay=="19")
        -UniqueID, 
    data=evalNewsTrain, 
    family=binomial)
summary(logModel)

logModel3 <- glm(
    Popular ~ 
        SubsectionName + 
        DayOfTheWeekMonday + DayOfTheWeekSunday + 
        HourOfTheDay7 + HourOfTheDay12 + HourOfTheDay13 + HourOfTheDay19 + 
        WordCount - UniqueID,
    data=evalNewsTrain, family=binomial)
summary(logModel3)

logPred <- predict(logModel3, newdata=evalNewsTest, type="response")

# Calculate AUC
logRocr <- prediction(logPred, evalNewsTest$Popular)
logAuc <- as.numeric(performance(logRocr, "auc")@y.values)
logAuc

# Calculate accuracy
table(evalNewsTest$Popular, rfPred>.5)
