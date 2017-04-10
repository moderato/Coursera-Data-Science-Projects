library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
temp_training <- training[grep("^IL",names(training))]
training <- data.frame(training$diagnosis, temp_training)
temp_testing <- testing[grep("^IL",names(testing))]
testing <- data.frame(testing$diagnosis, temp_testing)
model1 <- train(training.diagnosis~., method='glm',data=training)
model2 <- train(training.diagnosis~., method='glm',preProcess = 'pca',trControl = trainControl(preProcOptions=list(thresh=0.8)),data=training)
predictions1 <- predict(model1, testing)
predictions2 <- predict(model2, testing)
C1 <- confusionMatrix(predictions1, testing[,1])
C2 <- confusionMatrix(predictions2, testing[,1])
