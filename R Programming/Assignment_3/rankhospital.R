rankhospital <- function(state, outcome, num = "best") {
	library(stringr)
	
	## Read outcome data
	file <- read.csv("outcome-of-care-measures.csv")	

	## Check that state and outcome are valid
	if (!any(file[,7] == state) && !str_detect("heart attack, heart failure, pneumonia", outcome)){
		stop("invalid state and outcome")}
	else if (!any(file[,7] == state)){
		stop("invalid state")}
	else if (!str_detect("heart attack, heart failure, pneumonia", outcome)){
		stop("invalid outcome")}
	else{
	
		## Return hospital name in that state with the given rank 30-day death rate
		list <- as.matrix(split(file, file$State)[[state]])
		
		processed <- suppressWarnings(apply(cbind(list[,11],list[,17],list[,23]), 2, as.numeric))

		if (num == "best"){
			index <- 1}
		else if (num == "worst"){
			if (outcome == "heart attack"){
				index <- length(sort(processed[,1]))}
			else if (outcome == "heart failure"){
				index <- length(sort(processed[,2]))}
			else if (outcome == "pneumonia"){
				index <- length(sort(processed[,3]))}
		}
		else if (is.numeric(num) && num <= nrow(list)){
			index <- num}
		else{
			return(NA)}
		
		if (outcome == "heart attack"){
			return(sort(list[which(sort(processed[,1])[index] == processed[,1]),2])[[1]])}
		else if (outcome == "heart failure"){
			return(sort(list[which(sort(processed[,2])[index] == processed[,2]),2])[[1]])}
		else{
			return(sort(list[which(sort(processed[,3])[index] == processed[,3]),2])[[1]])}

	}
}
