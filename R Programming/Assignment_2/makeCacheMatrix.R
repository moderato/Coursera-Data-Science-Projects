makeCacheMatrix <- function(x=matrix()){	
	i_matrix <- matrix(NA, nrow=1, ncol=1)

	set <- function(y){
		x <<- y
		i_matrix <<- matrix(NA, nrow=1, ncol=1)}

	get <- function() x
	
	setinverse <- function(new_matrix) i_matrix <<- new_matrix

	getinverse <- function() i_matrix

	list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}