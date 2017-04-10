data(iris)
library(caret)
library(ggplot2)
fitFunction <- function(Predictor, Method, Data){
  if(length(Predictor) == 1)
    list(1)
  
  else if(length(Predictor) == 2){
    ind <- c(as.numeric(Predictor[1]),as.numeric(Predictor[2]))
    train(Data[,ind], Data[,5], method=Method)}
  
  else if(length(Predictor) == 3){
    ind <- c(as.numeric(Predictor[1]),as.numeric(Predictor[2]),as.numeric(Predictor[3]))
    train(Data[,ind], Data[,5], method=Method)}
  
  else{
    ind <- c(1,2,3,4)
    train(Data[,ind], Data[,5], method=Method)}
}

plotFunction <- function(Predictor, Data, Incorrect, Method){
  name <- names(Data)
  
  if(length(Predictor) == 1){}
  
  else if(length(Predictor) == 2){
    
    image <- ggplot(Data, aes_string(name[as.numeric(Predictor[1])],name[as.numeric(Predictor[2])])) + 
      geom_point(aes_string(color=name[6], shape=name[5]), size=4) + 
      geom_point(data=Incorrect, aes_string(name[as.numeric(Predictor[1])],name[as.numeric(Predictor[2])]), color="black") }
  
  else if(length(Predictor) == 3){
    
    image <- ggplot(Data, aes_string(name[as.numeric(Predictor[1])],name[as.numeric(Predictor[2])])) + 
      geom_point(aes_string(color=name[6], shape=name[5], size=name[as.numeric(Predictor[3])])) + 
      scale_size_continuous(range = c(3,7)) + 
      geom_point(data=Incorrect, aes_string(name[as.numeric(Predictor[1])],name[as.numeric(Predictor[2])]), color="black") }
  
  else{  
    
    image <- ggplot(Data, aes_string(name[1], name[2])) + 
      geom_point(aes_string(color=name[6], shape=name[5], size=name[3], alpha=name[4])) + 
      scale_color_manual(values=c("#330033", "red", "#3399FF")) + 
      scale_size_continuous(range = c(3,8)) + 
      geom_point(data=Incorrect, aes_string(name[1], name[2]), color="black")    
    
  }
  
  image <- image + ggtitle(paste0("Iris Prediction Results (", Method, ")")) + 
    theme(plot.title=element_text(face="bold", size=20))
  
}

heihei <- c(1,2,3,4)
mo <- "rf"

set.seed(3833)
index <- createDataPartition(iris$Species, p=0.6)[[1]]
training <- iris[index,]
testing <- iris[-index,]

set.seed(125)
modelFit <- fitFunction(heihei, mo, training)
Prediction <- predict(modelFit, testing)
confusion <- confusionMatrix(Prediction, testing$Species)
Fault <- Prediction == testing$Species
result <- data.frame(testing, Prediction, Fault)
fault <- result[Fault==FALSE,]
ggplotObject <- plotFunction(heihei, result, fault, mo)
print(ggplotObject)