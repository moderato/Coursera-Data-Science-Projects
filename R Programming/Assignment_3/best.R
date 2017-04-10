best <- function(state, outcome) {

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

	## Return hospital name in that state with lowest 30-day death rate
		list <- as.matrix(split(file, file$State)[[state]])
		
		if (outcome == "heart attack"){
			processed <- suppressWarnings(as.numeric(list[,11]))
			return(sort(list[which(processed == min(processed, na.rm = TRUE)),2])[[1]])}
		else if (outcome == "heart failure"){
			processed <- suppressWarnings(as.numeric(list[,17]))
			return(sort(list[which(processed == min(processed, na.rm = TRUE)),2])[[1]])}
		else{
			processed <- suppressWarnings(as.numeric(list[,23]))
			return(sort(list[which(processed == min(processed, na.rm = TRUE)),2])[[1]])}

	}	
}