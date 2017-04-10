complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases
		
	nobs <- numeric()

	for(i in id){

		number_of_complete_cases <- 0

		## Read files
		working_directory <- getwd()

		if (i < 10){
			file_name <- paste('00',i,'.csv',sep='')}
		else if (i < 100){
			file_name <- paste('0',i,'.csv',sep='')}
		else{
			file_name <- paste(i,'.csv',sep='')}

		address <-paste(working_directory, '/', directory, '/', file_name, sep='')
		data_origin <- read.csv(address)

		number_of_complete_cases <- nrow(na.omit(data_origin))
		nobs <- c(nobs,number_of_complete_cases)
		
			
	}

	data_frame <- data.frame(id, nobs)	
	print(data_frame)
	
}