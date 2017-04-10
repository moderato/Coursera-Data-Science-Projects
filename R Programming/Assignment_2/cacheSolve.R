cacheSolve <- function(x,...){
	i_matrix <- x$getinverse()
	if(!identical(i_matrix,matrix(NA, nrow=1, ncol=1))){
		message("getting cached data")
		return(i_matrix)
	}
	data <- x$get()
	if(nrow(data) != ncol(data)){
		message("Not square")
	}
	else if(!identical(data, data[complete.cases(data*0),,drop=FALSE])){
		message("Not completed")
	}
	else if(det(data) == 0){
		message("Non-invertible")
	}
	else{
		i_matrix <- solve(data)
	}
	x$setinverse(i_matrix)
	i_matrix
}