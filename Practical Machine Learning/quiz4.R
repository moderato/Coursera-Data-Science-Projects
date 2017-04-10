library(ElemStatLearn)
library(caret)
data(vowel.train)
data(vowel.test) 
vowel.train <- transform(vowel.train, y=as.factor(y))
vowel.test <- transform(vowel.test, y=as.factor(y))
set.seed(33833)
modelFitRF <- train(y~., data=vowel.train, method="rf")
modelFitGBM <- train(y~., data=vowel.train, method="gbm")
predictionRF <- predict(modelFitRF, vowel.test)
predictionGBM <- predict(modelFitGBM, vowel.test)
confusionMatrix(predictionRF, vowel.test$y)
confusionMatrix(predictionGBM, vowel.test$y)
confusionMatrix(predictionGBM, predictionRF)

library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
set.seed(62433)
modelFitRF <- train(diagnosis~., data=training, method="rf")
modelFitGBM <- train(diagnosis~., data=training, method="gbm")
modelFitLDA <- train(diagnosis~., data=training, method="lda")
predRF <- predict(modelFitRF, testing)
predGBM <- predict(modelFitGBM, testing)
predLDA <- predict(modelFitLDA, testing)
stacked <- data.frame(predRF,predGBM,predLDA,diagnosis=testing$diagnosis)
modelFitStacked <- train(diagnosis~., data=stacked, method="rf")
stackedPrediction <- predict(modelFitStacked, stacked)
confusionMatrix(testing$diagnosis,stackedPrediction)
confusionMatrix(testing$diagnosis,predRF)
confusionMatrix(testing$diagnosis,predGBM)
confusionMatrix(testing$diagnosis,predLDA)

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(233)
object <- enet(as.matrix(training[,1:8]),as.matrix(training[,9]),lambda=0)
plot(object, xvar="penalty")
print(object)

library(lubridate)  # For year() function below
dat = read.csv("~/Desktop/gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)
tstest = ts(testing$visitsTumblr)
modelFit <- bats(tstrain)
forecast <- forecast(modelFit, h=235)
length(which(tstest <= forecast[[5]][,2]))/length(tstest)

set.seed(3523)
library(AppliedPredictiveModeling)
library(e1071)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(325)
modelFit <- svm(CompressiveStrength~., data=training)
prediction <- predict(modelFit, testing)
accuracy(prediction, testing$CompressiveStrength)
