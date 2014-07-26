### Introduction

The Second Programming Assignment only seems to require that you copy
the provided code for 'makeVector' and 'cacheMean' and copy to layout
for new functions 'makeCacheMatrix' and 'cacheSolve'.  I have done this
as required.

I have then added some more functionality that I felt was lacking in the
example.

### The Basic Functions

The two functions have an almost identical usage to the example.  For 
example :

<!-- -->

	> mat <- matrix(c(2,5,4,6),2,2)
	> x <- makeCacheMatrix(mat)
	> 

'x' is now a special cacheable matrix.  Of course I know it is actually 
just a list containing functions but you know what I mean!!  Now to 
calculate 'solve(x)' simply run :

	> cacheSolve(x)
		   [,1]  [,2]
	[1,] -0.750  0.50
	[2,]  0.625 -0.25
	> cacheSolve(x)
	getting cached data
		   [,1]  [,2]
	[1,] -0.750  0.50
	[2,]  0.625 -0.25
	> 

Notice that the second time the funtion is called the return output includes
"getting cached data".  This indicates that the function has not rerun 
'solve(x)', but instead taken the cached data.

### But what about the added functionality?

The problem I felt with the basic solution provided in 'cacheMean' was that 
it provided for extra parameters ('...') in the function 'cacheMean(x, ...)'
however it failed to check if these parameters had changed.  Why is this 
important I hear you ask.  If those extra parameters change the calculation
then referring to the cached solution will return an incorrect result.  For 
example :

	> mat1 <- matrix(c(4,5,3,8),2,2)
	> mat2 <- matrix(c(3,2,7,4),2,2)
	> solve(mat1)
			   [,1]       [,2]
	[1,]  0.4705882 -0.1764706
	[2,] -0.2941176  0.2352941
	> solve(mat1 , b = mat2)
			   [,1]      [,2]
	[1,]  1.0588235  2.588235
	[2,] -0.4117647 -1.117647
	> 
	
Notice that the second call to solve returns a different result.  Under the 
implementation of a function similar to 'cacheMean', that second result would 
simply return the cached example, and be incorrect.  For this reason, my 
function takes one extra step, checking that the extra parameters are the 
same this time as they were last time.  If they have changed, the results 
will be recalculated.

You will see the extra function 'checkOptList' which simply compares the option 
list to a stored version of last time it was called.  It returns 'TRUE' if the 
options are the same (this includes if both this call and last, no parameters
have been passed).  It returns 'FALSE' if the parameters are different or if 
there is no stored parameters.

Try it out and see :

>mat1 <- matrix(c(4,5,3,8),2,2)
> mat2 <- matrix(c(3,2,7,4),2,2)
> x <- makeCacheMatrix(mat1)

> cacheSolve(x)
           [,1]       [,2]
[1,]  0.4705882 -0.1764706
[2,] -0.2941176  0.2352941

> cacheSolve(x)
getting cached data
           [,1]       [,2]
[1,]  0.4705882 -0.1764706
[2,] -0.2941176  0.2352941
> ##  SEE that cached results were accessed

> cacheSolve(x , b = mat2)
           [,1]      [,2]
[1,]  1.0588235  2.588235
[2,] -0.4117647 -1.117647
> ##  SEE that cached results were not accessed and a different 
> ##  result was returned.