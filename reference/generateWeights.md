# generateWeights

compute Weights for each intersection Hypotheses in the closure of a
graph based multiple testing procedure

## Usage

``` r
generateWeights(g, w)
```

## Arguments

- g:

  Graph either defined as a matrix (each element defines how much of the
  local alpha reserved for the hypothesis corresponding to its row index
  is passed on to the hypothesis corresponding to its column index), as
  `graphMCP` object or as `entangledMCP` object.

- w:

  Vector of weights, defines how much of the overall alpha is initially
  reserved for each elementary hypothesis. Can be missing if `g` is a
  `graphMCP` object (in which case the weights from the graph object are
  used). Will be ignored if `g` is an `entangledMCP` object (since then
  the matrix of weights from this object is used).

## Value

Returns matrix with each row corresponding to one intersection
hypothesis in the closure of the multiple testing problem. The first
half of elements indicate whether an elementary hypotheses is in the
intersection (1) or not (0). The second half of each row gives the
weights allocated to each elementary hypotheses in the intersection.

## References

Bretz F, Maurer W, Brannath W, Posch M; (2008) - A graphical approach to
sequentially rejective multiple testing procedures. - Stat Med - 28/4,
586-604 Bretz F, Posch M, Glimm E, Klinglmueller F, Maurer W, Rohmeyer
K; (2011) - Graphical approaches for multiple endpoint problems using
weighted Bonferroni, Simes or parametric tests - to appear

## Author

Florian Klinglmueller \<float@lefant.net\>, Kornelius Rohmeyer
<rohmeyer@small-projects.de>

## Examples

``` r
 g <- matrix(c(0,0,1,0,
               0,0,0,1,
               0,1,0,0,
               1,0,0,0), nrow = 4,byrow=TRUE)
 ## Choose weights
 w <- c(.5,.5,0,0)
 ## Weights of conventional gMCP test:
 generateWeights(g,w)
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#>  [1,]    0    0    0    1  0.0  0.0  0.0  1.0
#>  [2,]    0    0    1    0  0.0  0.0  1.0  0.0
#>  [3,]    0    0    1    1  0.0  0.0  0.5  0.5
#>  [4,]    0    1    0    0  0.0  1.0  0.0  0.0
#>  [5,]    0    1    0    1  0.0  1.0  0.0  0.0
#>  [6,]    0    1    1    0  0.0  0.5  0.5  0.0
#>  [7,]    0    1    1    1  0.0  0.5  0.5  0.0
#>  [8,]    1    0    0    0  1.0  0.0  0.0  0.0
#>  [9,]    1    0    0    1  0.5  0.0  0.0  0.5
#> [10,]    1    0    1    0  1.0  0.0  0.0  0.0
#> [11,]    1    0    1    1  0.5  0.0  0.0  0.5
#> [12,]    1    1    0    0  0.5  0.5  0.0  0.0
#> [13,]    1    1    0    1  0.5  0.5  0.0  0.0
#> [14,]    1    1    1    0  0.5  0.5  0.0  0.0
#> [15,]    1    1    1    1  0.5  0.5  0.0  0.0

g <- Entangled2Maurer2012()
generateWeights(g)
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#>  [1,]    0    0    0    0    1  0.0  0.0  0.0  0.0   1.0
#>  [2,]    0    0    0    1    0  0.0  0.0  0.0  1.0   0.0
#>  [3,]    0    0    0    1    1  0.0  0.0  0.0  0.5   0.5
#>  [4,]    0    0    1    0    0  0.0  0.0  1.0  0.0   0.0
#>  [5,]    0    0    1    0    1  0.0  0.0  1.0  0.0   0.0
#>  [6,]    0    0    1    1    0  0.0  0.0  1.0  0.0   0.0
#>  [7,]    0    0    1    1    1  0.0  0.0  1.0  0.0   0.0
#>  [8,]    0    1    0    0    0  0.0  1.0  0.0  0.0   0.0
#>  [9,]    0    1    0    0    1  0.0  1.0  0.0  0.0   0.0
#> [10,]    0    1    0    1    0  0.0  0.5  0.0  0.5   0.0
#> [11,]    0    1    0    1    1  0.0  0.5  0.0  0.5   0.0
#> [12,]    0    1    1    0    0  0.0  0.5  0.5  0.0   0.0
#> [13,]    0    1    1    0    1  0.0  0.5  0.5  0.0   0.0
#> [14,]    0    1    1    1    0  0.0  0.5  0.5  0.0   0.0
#> [15,]    0    1    1    1    1  0.0  0.5  0.5  0.0   0.0
#> [16,]    1    0    0    0    0  1.0  0.0  0.0  0.0   0.0
#> [17,]    1    0    0    0    1  0.5  0.0  0.0  0.0   0.5
#> [18,]    1    0    0    1    0  1.0  0.0  0.0  0.0   0.0
#> [19,]    1    0    0    1    1  0.5  0.0  0.0  0.0   0.5
#> [20,]    1    0    1    0    0  0.5  0.0  0.5  0.0   0.0
#> [21,]    1    0    1    0    1  0.5  0.0  0.5  0.0   0.0
#> [22,]    1    0    1    1    0  0.5  0.0  0.5  0.0   0.0
#> [23,]    1    0    1    1    1  0.5  0.0  0.5  0.0   0.0
#> [24,]    1    1    0    0    0  0.5  0.5  0.0  0.0   0.0
#> [25,]    1    1    0    0    1  0.5  0.5  0.0  0.0   0.0
#> [26,]    1    1    0    1    0  0.5  0.5  0.0  0.0   0.0
#> [27,]    1    1    0    1    1  0.5  0.5  0.0  0.0   0.0
#> [28,]    1    1    1    0    0  0.5  0.5  0.0  0.0   0.0
#> [29,]    1    1    1    0    1  0.5  0.5  0.0  0.0   0.0
#> [30,]    1    1    1    1    0  0.5  0.5  0.0  0.0   0.0
#> [31,]    1    1    1    1    1  0.5  0.5  0.0  0.0   0.0
```
