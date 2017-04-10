library(shiny)
library(caret)
library(ggplot2)
data(iris)

intro <- paste("This interactive shiny application is based on the Iris data set. By specifying features in the sidebar the user can perform quick and customized prediction on iris species. Information of the prediction will be shown in the tab panels.",
               "When this page come up in your browser the system will automatically perform a prediction based on the default setting. After you specifying the features, click the Predict button to update the prediction. Notice that the result plot is shown in the Plot panel and error predictions will be marked by black dots.",
               sep="\n\n")


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


shinyServer(
  function(input,output){
    observe({
      values <- reactiveValues()
      set.seed(3833)
      values$index <- createDataPartition(iris$Species, p=as.numeric(input$ratio))[[1]]
      training <- iris[values$index,]
      testing <- iris[-values$index,]
      set.seed(125)
      if(length(input$predictor) != 1){
        modelFit <- fitFunction(input$predictor, input$method, training)
        Prediction <- predict(modelFit, testing)
        confusion <- confusionMatrix(Prediction, testing$Species)
        Correct <- Prediction == testing$Species
        result <- data.frame(testing, Prediction, Correct)
        fault <- result[Correct==FALSE,]
        ggplotObject <- plotFunction(input$predictor, result, fault, input$method)
        
        output$message <- renderText({intro;intro})
        output$summary <- renderPrint({modelFit})
        output$confusion <- renderPrint({confusion})
        output$plot <- renderPlot({ggplotObject})
        output$table <- renderTable({result})
      }
      else{
        output$message <- renderPrint({intro})
        output$summary <- renderPrint({"Cannot fit a model with only one predictor!"})
        output$confusion <- renderPrint({"Cannot fit a model with only one predictor!"})
        output$plot <- renderPlot({NULL})
        output$table <- renderPrint({"Cannot fit a model with only one predictor!"})
      }
    })
  } 
)