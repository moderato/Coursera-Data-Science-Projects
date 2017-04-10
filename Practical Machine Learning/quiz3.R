library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
splitted <- split(segmentationOriginal,segmentationOriginal$Case)
testing <- splitted[[1]]
training <- splitted[[2]]
set.seed(125)
modelFit <- train(Class~.,method="rpart",data=training)
print(modelFit$finalModel)

library(pgmm)
data(olive)
olive = olive[,-1]
newdata = as.data.frame(t(colMeans(olive)))
modelFit <- train(Area~.,method="rpart",data=olive)
prediction <- predict(modelFit, newdata=newdata)

library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
set.seed(13234)
modelFit <- train(chd~age+alcohol+obesity+typea+ldl+tobacco,data=trainSA,method="glm",family="binomial")
valuesTraining <- trainSA$chd
predictionTraining <- predict(modelFit, trainSA)
valuesTesting <- testSA$chd
predictionTesting <- predict(modelFit, testSA)
missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
missClass(valuesTraining,predictionTraining)
missClass(valuesTesting,predictionTesting)

library(ElemStatLearn)
library(caret)
data(vowel.train)
data(vowel.test)
vowel.train <- transform(vowel.train, y=as.factor(y))
vowel.test <- transform(vowel.test, y=as.factor(y))
set.seed(33833)
modelFit <- train(y~., data=vowel.train, method="rf", prox=TRUE)

