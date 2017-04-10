---
title: "Practical Machine Learning Project Writeup"
author: Zhongyi Lin
date: 07-20-2015
output: html_document
---

### Background
  
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 
  
### Import Libraries and Data
  
The following chunk of r code import libraries that are necessary for this project.
  
```{r, results='hide', message=FALSE}
library(lattice)
library(ggplot2)
library(caret)
library(rpart)
library(randomForest)
library(gbm)
library(plyr)
```
  
Then the working directory is set and the original data sets are imported as following.
  
```{r}
setwd("/Users/moderato/Desktop/r_wd/Practical Machine Learning Project")
trainingOriginal <- read.csv("pml-training.csv")
testingOriginal <- read.csv("pml-testing.csv")
```
  
  
### Preprocessing
  
By viewing the original data we can see that it is not a clean and tidy data so some preprocessing is needed. First we take a quick look at the original testing data. All the observations in it has the variable "new window" been "no", without even one "yes" in it. Thus the original training data is splitted by the variable "new window" and all observations in the "yes" list is discarded.
  
```{r}
splitted <- split(trainingOriginal, trainingOriginal$new_window)
no <- splitted[[1]]
```
  
  
Next we discards all columns in the "no" list which have missing values or NA values.
  
```{r}
temp <- c()
for(i in 1:160){
  temp <- c(temp, ((NA %in% no[,i]) | ('' %in% no[,i])))
}
temp <- (no[,which(!temp)])[,8:60]
```
  
  
It is time to create training and testing data sets for cross-validation from the original training data set. We create them by setting seed to 3433 and applying createDataPartition function. 75% data is assigned to the training set and 25% to the testing set.

```{r}
set.seed(3433)
index <- createDataPartition(y=temp$classe, p=3/4, list=FALSE)
training <- temp[index,]
testing <- temp[-index,]
```
  
There are totally 52 predictors and 1 outcome in both the new training and testing sets. In case we don't need so many predictors, a preprocessing based on principle component analysis method is applied to these two sets.
  
```{r}
preProc <- preProcess(training[,1:52], method='pca', thresh=0.95, outcome=training$classe)
pcaTraining <- predict(preProc, training[,1:52])
preProc <- preProcess(testing[,1:52], method='pca', thresh=0.95, outcome=testing$classe)
pcaTesting <- predict(preProc, testing[,1:52])
```
  
  
### Model Selection and Prediction
  
Before building appropriate models a selection of them is necessary as there are so many of them. In the course there are mainly 5 methods mentioned, including General Linear Regression ("glm"), Random Forest ("RF"), Decision Trees ("RP"), Boosting("gbm") and Bagging ("bag"). As glm is for problems with 2-level outcomes, and bagging is better for non-linear problems, only RF, RP and gbm methods will be used to build our models. Each of the methods is applied to both the training set and the preprocessed pca training set.
  
```{r}
set.seed(8484)
modelFitRFpca<- randomForest(training$classe ~. , data=pcaTraining)
modelFitRF <- randomForest(classe ~. , data=training)
modelFitRPpca<- rpart(training$classe ~. , data=pcaTraining, method="class")
modelFitRP <- rpart(classe ~. , data=training, method="class")
modelFitGBMpca <- gbm(training$classe ~. , data=pcaTraining, distribution="multinomial", n.trees=100)
modelFitGBM <- gbm(classe ~. , data=training, distribution="multinomial", n.trees=100)
```
  
  
With these models we can predict the testing set outcome by applying the predict function. Note that pca models should only be used on the pca-preprocessed testing set and so does the non-pca models.
  
```{r}
predRFpca <- predict(modelFitRFpca, pcaTesting)
predRF <- predict(modelFitRF, testing)
predRPpca <- predict(modelFitRPpca, pcaTesting, type="class")
predRP <- predict(modelFitRP, testing, type="class")
predGBMpca <- revalue(as.factor(apply(predict(modelFitGBMpca, pcaTesting, n.trees=100, type="response"),1,which.max)), c("1"="A","2"="B","3"="C","4"="D","5"="E"))
predGBM <- revalue(as.factor(apply(predict(modelFitGBM, testing, n.trees=100, type="response"),1,which.max)), c("1"="A","2"="B","3"="C","4"="D","5"="E"))
```
  
Since the GBM outcomes are generated as vectors of probabilities of which class the observation belongs to, we use the which.max function to find out the biggest probabilities of each row and assign the corresponding class as the outcome of the prediction on this observation.
  
  
Now all predictions are ready and listed for comparison:
  
```{r}
accuracyRFpca <- confusionMatrix(predRFpca, testing$classe)$overall[1]
accuracyRF <- confusionMatrix(predRF, testing$classe)$overall[1]
accuracyRPpca <- confusionMatrix(predRPpca, testing$classe)$overall[1]
accuracyRP <- confusionMatrix(predRP, testing$classe)$overall[1]
accuracyGBMpca <- confusionMatrix(predGBMpca, testing$classe)$overall[1]
accuracyGBM <- confusionMatrix(predGBM, testing$classe)$overall[1]
accuracyList <- data.frame(accuracyRFpca, accuracyRF, accuracyRPpca, accuracyRP, accuracyGBMpca, accuracyGBM)
accuracyList
confusionMatrix(predRF, testing$classe)$overall
```
  
The non-pca Random Forest model is the chosen one as it has the highest accuracy. If we take a 
look at the confusion matrix of this model, we see that the 95% confidence interval is (0.9908, 0.9956), which is quite high and narrow.
  
  
Now the model is applied to the original testing set to get the final prediction for submission.
  
```{r}
finalPrediction <- predict(modelFitRF, testingOriginal)
```
  
  
### Submission and Conclusion

According to the submission instruction the following chunk is run to output each outcome as a single txt file.
  
```{r}
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
answer <- as.character(finalPrediction)
pml_write_files(answer)
```
  
After submitting the files the webpage shows that all the answers are correct. It proves the efficiency of the model selection and prediction.