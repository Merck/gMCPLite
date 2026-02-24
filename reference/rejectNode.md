# Rejects a node/hypothesis and updates the graph accordingly.

Rejects a node/hypothesis and updates the graph accordingly.

## Usage

``` r
rejectNode(graph, node, upscale = FALSE, verbose = FALSE, keepWeights = FALSE)
```

## Arguments

- graph:

  A graph of class `graphMCP` or `entangledMCP`.

- node:

  A character string specifying the node to reject.

- upscale:

  Logical. If `upscale=TRUE` then the weights of all non-rejected nodes
  are scaled so that the sum is equal to 1. This forces
  `keepWeights=FALSE` to reduce confusion, since otherwise the sum of
  weights could become bigger than 1.

- verbose:

  Logical scalar. If `TRUE` verbose output is generated during
  sequentially rejection steps.

- keepWeights:

  Logical scalar. If `FALSE` the weight of a node without outgoing edges
  is set to 0 if it is removed. Otherwise it keeps its weight.

## Value

An updated graph of class `graphMCP` or `entangledMCP`.

## Details

For details see the given references.

## References

Frank Bretz, Willi Maurer, Werner Brannath, Martin Posch: A graphical
approach to sequentially rejective multiple test procedures. Statistics
in Medicine 2009 vol. 28 issue 4 page 586-604.

## See also

`graphMCP`

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
m <- matrix(0, nrow = 4, ncol = 4)
m[1,3] <- m[2,4] <- m[3,2] <- m[4,1] <- 1
p1 <- c(0.01, 0.005, 0.01, 0.5)
a <- 0.05
w <- c(1/2, 1/2, 0, 0)
g <- matrix2graph(m, w)
gMCP(g, pvalues=p1, alpha=a)
#> gMCP-Result
#> 
#> Initial graph:
#> A graphMCP graph
#> H1 (weight=0.5)
#> H2 (weight=0.5)
#> H3 (weight=0)
#> H4 (weight=0)
#> Edges:
#> H1  -( 1 )->  H3 
#> H2  -( 1 )->  H4 
#> H3  -( 1 )->  H2 
#> H4  -( 1 )->  H1 
#> 
#> 
#> P-values:
#>    H1    H2    H3    H4 
#> 0.010 0.005 0.010 0.500 
#> 
#> Adjusted p-values:
#>   H1   H2   H3   H4 
#> 0.02 0.01 0.02 0.50 
#> 
#> Alpha: 0.05 
#> 
#> Hypothesis rejected:
#>    H1    H2    H3    H4 
#>  TRUE  TRUE  TRUE FALSE 
#> 
#> Final graph after3steps:
#> A graphMCP graph
#> H1 (rejected, weight=0)
#> H2 (rejected, weight=0)
#> H3 (rejected, weight=0)
#> H4 (weight=1)
#> No edges.
#> 
rejectNode(graph = g, node = 4)
#> A graphMCP graph
#> H1 (weight=0.5)
#> H2 (weight=0.5)
#> H3 (weight=0)
#> H4 (rejected, weight=0)
#> Edges:
#> H1  -( 1 )->  H3 
#> H2  -( 1 )->  H1 
#> H3  -( 1 )->  H2 
#> 

```
