# do the train
set.seed(1234)
rfModel <- randomForest(
    Popular ~ . - UniqueID,
    data=evalNewsTrain, ntree=500)

# Calculate AUC
rfPred <- predict(rfModel, newdata=evalNewsTest, type="prob")
rfRocr <- prediction(rfPred[,2], evalNewsTest$Popular)
rfAuc <- as.numeric(performance(rfRocr, "auc")@y.values)
rfAuc

# do cv
set.seed(1234)
x <- newsTrain
x$Popular <- NULL
y <- newsTrain$Popular
rf.cv <- rfcv(x, y, cv.fold=10, recursive=TRUE)
with(rf.cv, plot(n.var, error.cv))

# Calculate accuracy
table(evalNewsTest$Popular, rfPred>.5)

# Save to file
set.seed(1234)
rfModelSubmission <- randomForest(Popular~.-UniqueID, data=newsTrain, ntree=10000)
rfPredSubmission <- predict(rfModelSubmission, newdata=newsTest, type="prob")
mySubmission <- data.frame(
    UniqueID = newsTest$UniqueID, 
    Probability1 = abs(rfPredSubmission[,2])
)
write.csv(mySubmission, "SubmissionRF_all_corpora_10000.csv", row.names=FALSE)
