# Class entangledMCP

A entangledMCP object describes ... TODO

## Slots

- `subgraphs`:

  A list of graphs of class graphMCP.

- `weights`:

  A numeric.

- `graphAttr`:

  A list for graph attributes like color, etc.

## Methods

- print:

  `signature(object = "entangledMCP")`: A method for printing the data
  of the entangled graph to the R console.

- getMatrices:

  `signature(object = "entangledMCP")`: A method for getting the list of
  transition matrices of the entangled graph.

- getWeights:

  `signature(object = "entangledMCP")`: A method for getting the matrix
  of weights of the entangled graph.

- getRejected:

  `signature(object = "entangledMCP")`: A method for getting the
  information whether the hypotheses are marked in the graph as already
  rejected. If a second optional argument `node` is specified, only for
  these nodes the boolean vector will be returned.

- getXCoordinates:

  `signature(object = "entangledMCP")`: A method for getting the x
  coordinates of the graph. If a second optional argument `node` is
  specified, only for these nodes the x coordinates will be returned. If
  x coordinates are not yet set, `NULL` is returned.

- getYCoordinates:

  `signature(object = "entangledMCP")`: A method for getting the y
  coordinates of the graph If a second optional argument `node` is
  specified, only for these nodes the x coordinates will be returned. If
  y coordinates are not yet set, `NULL` is returned.

## See also

[`graphMCP`](https://merck.github.io/gMCPLite/reference/graphMCP-class.md)

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
g1 <- BonferroniHolm(2)
g2 <- BonferroniHolm(2)

graph <- new("entangledMCP", subgraphs=list(g1,g2), weights=c(0.5,0.5))

getMatrices(graph)
#> [[1]]
#>    H1 H2
#> H1  0  1
#> H2  1  0
#> 
#> [[2]]
#>    H1 H2
#> H1  0  1
#> H2  1  0
#> 
getWeights(graph)
#>       H1  H2
#> [1,] 0.5 0.5
#> [2,] 0.5 0.5
```
