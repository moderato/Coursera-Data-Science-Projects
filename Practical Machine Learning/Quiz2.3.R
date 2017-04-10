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
prePro <- preProcess(temp_training, method='pca', thresh=0.95, outcome=training$training.diagnosis)
modelFit <- train(training.diagnosis~., method='glm',preProcess = 'pca',trControl = trainControl(preProcOptions=list(thresh=0.8)),data=training)
print(prePro[[13]])
