# Create train and test splits from the original train data, that is labeled
set.seed(1234)
spl <- sample.split(newsTrain$Popular, .80)
evalNewsTrain <- newsTrain[spl==T,]
evalNewsTest <- newsTrain[spl==F,]
