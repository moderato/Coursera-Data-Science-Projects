pollutantmean <- function(directory, pollutant, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used

        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)

	## Initial Value
	summation <- 0
	number_of_non_NA <- 0
	mean <- numeric()

	for(i in id){
		
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



		## Choose pollutant
		if (pollutant == 'sulfate'){
			data <- data_origin[2]}
		else if(pollutant == 'nitrate'){
			data <- data_origin[3]} 


		## Calculate the total amount of pollutant and the number of days, NA excluded
		summation <- summation + sum(data,na.rm=TRUE)
		number_of_non_NA <- number_of_non_NA + dim(data)[1]-length(which(is.na(data))) 


	}

	mean <-summation/number_of_non_NA
	print(mean)
}