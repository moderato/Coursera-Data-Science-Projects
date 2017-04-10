rankall <- function(outcome, num = "best") {
	library(stringr)
	state <- vector()
	hospital <- vector()
	
	## Read outcome data
	file <- read.csv("outcome-of-care-measures.csv", na.strings = "Not Available")
	
	## Check that state and outcome are valid

	if (!str_detect("heart attack, heart failure, pneumonia", outcome)){
		stop("invalid outcome")}
	else{
	## For each state, find the hospital of the given rank
	## Return a data frame with the hospital names and the (abbreviated) state name

	if (outcome == "heart attack"){
		disease_index <- 11}
	else if(outcome == "heart failure"){
		disease_index <- 17}
	else if(outcome == "pneumonia"){
		disease_index <- 23}

	new_file_temp <- file[order(file[7], file[disease_index], file[2]),]
	new_file <- cbind(new_file_temp[2], new_file_temp[7], new_file_temp[disease_index])

	splitted <- split(new_file, new_file$State)
	for (i in 1:length(splitted)){
		splitted[[i]] <- splitted[[i]][complete.cases(splitted[[i]]),]
		
		if(num == "best"){
			rank_index <- 1}
		else if(num == "worst"){
			rank_index <- length(splitted[[i]][,3])}
		else if(is.numeric(num) && num <= length(splitted[[i]][,3])){
			rank_index <- num}
		else{
			rank_index <- 0}

		state <- c(state, names(splitted)[i])
		if (!rank_index == 0){
			hospital <- c(hospital, as.character(splitted[[i]][rank_index, 1]))}
		else{
			hospital <- c(hospital, NA)}
		
	}
	
	output <- as.data.frame(cbind(hospital, state))
	return(output)
	}
}