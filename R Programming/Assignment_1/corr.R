corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0

        ## Return a numeric vector of correlations
	
	qualified <- numeric()
	correlation <- numeric()

	nobs_table <- complete(directory,1:332)
	for(i in 1:nrow(nobs_table)){
		if(nobs_table$nobs[i]>=threshold){
			qualified <- c(qualified, nobs_table$id[i])
		}
	}
	
	if (length(qualified) != 0){
		for(j in qualified){

			## Read files
			working_directory <- getwd()

			if (j < 10){
				file_name <- paste('00',j,'.csv',sep='')}
			else if (j < 100){
				file_name <- paste('0',j,'.csv',sep='')}
			else{
				file_name <- paste(j,'.csv',sep='')}

			address <-paste(working_directory, '/', directory, '/', file_name, sep='')
			data_origin <- read.csv(address)
		
			data <- na.omit(data_origin)
			correlation <- c(correlation, as.numeric(cor(data[2],data[3])))
		}
		print(correlation)
	}
}