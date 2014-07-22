## Basic functions mirror the example functions for mean.
## Functions create the Matrix object and run Solve
## function on it.

## I have extended functionality of example functions which
## do not take into account ... parameters which may change
## the result


## makeCacheMatrix creates a 'cacheable' matrix

makeCacheMatrix <- function(x = matrix()) {

    ## sol : contains to solution to solve(x, ...)
    sol <- NULL

    ## optList : contains list of options (...) used to solve(x, ...)
    optList <- NULL
 
    ## set(y) : changes the value of the matrix.  sol (solution) is also
    ##   returned to NULL
    set <- function(y) {
        x <<- y
        sol <<- NULL
     }
 
    ## get() : returns the matrix
    get <- function() x
 
    ## checkOptList(...) : checks the option list (...) with the last option
    ##    list used.  If both contain the same options returns true.  If this 
    ##    is the first time the function has been called or the options are 
    ##    different to last time the function was called returns false.
    checkOptList <- function(...) {

        ## if checkOptList() has not previously been called - returns false
        if (is.null(opt)) {
            return(false)
        }
        
        ## converts ... to list
        newOpt <- list(...)
        
        ## sorts list - this ensures even if the same options are passed in a
        ## different order fuction will still find them equal
        if (length(newOpt) > 0) {
            newOpt <- newOpt[order(names(newOpt))]
        }
        
        ## checks if new and old list are equal
        ret <- (all.equal(opt,newOpt)[1] == TRUE)
        
        ## stores new option list
        opt <<- newOpt
        
        ## returns result
        ret
    }

    ## setSolve(s) : stores the calculated solution
    setSolve <- function(s) sol <<- s

    ## getSolve() : returns cached value of solution
    getSolve <- function() sol

    ## this is the list of functions that is returned for use.
    list(set = set, get = get,
         checkOptList = checkOptList,
         setSolve = setSolve, 
         getSolve = getSolve)
}


## cacheSolve returns solve(x, ...) 
## if the only element passed to cacheSolve is a 'cacheMatrix'
## this provides the inverse of x.  If solve(x, ...) has already
## been calculated with the same additional elements (...), cacheSolve
## refers to the cache rather than recalculating.

cacheSolve <- function(x, ...) {

    ## check if the optlist (...) is the same as last use of this function.
    ## If it is function gets cached solution.
    if (x$checkOptList(...)) {
        s <- x$getSolve()

        ## check cached solution is not null and return answer
        if(!is.null(s)) {
            message("getting cached data")
            return(s)
        }
    }

    ## no cached solution is found so output is calculated and stored in cache
    ## for future use
    data <- x$get()
    s <- solve(data , ...)
    x$setSolve(s)
    s
}
