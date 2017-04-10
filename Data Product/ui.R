shinyUI(fluidPage(
  titlePanel("Prediction Based on Iris Data Set"),
  
  sidebarLayout(    
    sidebarPanel(
      
      radioButtons("method", "Fitting methods",
                   c("Random Forest" = "rf",
                     "Decision Trees" = "rpart")),
      
      radioButtons("ratio", "Cross-validation training-testing ratio",
                   c("60%/40%" = "0.6",
                     "70%/30%" = "0.7",
                     "75%/25%" = "0.75",
                     "80%/20%" = "0.8")),
      
      checkboxGroupInput("predictor", "Predictor(s)",
                    c("Sepal.Length" = "1", 
                      "Sepal.Width" = "2",
                      "Petal.Length" = "3", 
                      "Petal.Width" = "4")),
      
      submitButton("Predict")
    ),
    
    mainPanel(
      tabsetPanel(        
        tabPanel("Intro", verbatimTextOutput("message")),
        tabPanel("Model Summary", verbatimTextOutput("summary")),
        tabPanel("Confusion Matrix", verbatimTextOutput("confusion")),
        tabPanel("Plot", plotOutput("plot")),
        tabPanel("Result Table", tableOutput("table"))        
      )

    )
  )        
))