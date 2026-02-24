# Class graphMCP

A graphMCP object describes a sequentially rejective multiple test
procedure.

## Slots

- `m`:

  A transition matrix. Can be either `numerical` or `character`
  depending whether the matrix contains variables or not. Row and column
  names will be the names of the nodes.

- `weights`:

  A numeric.

- `edgeAttr`:

  A list for edge attributes.

- `nodeAttr`:

  A list for node attributes.

## Methods

- getMatrix:

  `signature(object = "graphMCP")`: A method for getting the transition
  matrix of the graph.

- getWeights:

  `signature(object = "graphMCP")`: A method for getting the weights. If
  a third optional argument `node` is specified, only for these nodes
  the weight will be returned.

- setWeights:

  `signature(object = "graphMCP")`: A method for setting the weights. If
  a third optional argument `node` is specified, only for these nodes
  the weight will be set.

- getRejected:

  `signature(object = "graphMCP")`: A method for getting the information
  whether the hypotheses are marked in the graph as already rejected. If
  a second optional argument `node` is specified, only for these nodes
  the boolean vector will be returned.

- getXCoordinates:

  `signature(object = "graphMCP")`: A method for getting the x
  coordinates of the graph. If a second optional argument `node` is
  specified, only for these nodes the x coordinates will be returned. If
  x coordinates are not set yet `NULL` is returned.

- getYCoordinates:

  `signature(object = "graphMCP")`: A method for getting the y
  coordinates of the graph If a second optional argument `node` is
  specified, only for these nodes the x coordinates will be returned. If
  y coordinates are not set yet `NULL` is returned.

- setEdge:

  `signature(from="character", to="character", graph="graphNEL", weights="numeric")`:
  A method for adding new edges with the given weights.

- setEdge:

  `signature(from="character", to="character", graph="graphMCP", weights="character")`:
  A method for adding new edges with the given weights.

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
m <- rbind(H11=c(0,   0.5, 0,   0.5, 0,   0  ),
      H21=c(1/3, 0,   1/3, 0,   1/3, 0  ),
      H31=c(0,   0.5, 0,   0,   0,   0.5),
      H12=c(0,   1,   0,   0,   0,   0  ),
      H22=c(0.5, 0,   0.5, 0,   0,   0  ),
      H32=c(0,   1,   0,   0,   0,   0  ))

weights <- c(1/3, 1/3, 1/3, 0, 0, 0)

# Graph creation
graph <- new("graphMCP", m=m, weights=weights)

# Visualization settings
nodeX <- rep(c(100, 300, 500), 2)
nodeY <- rep(c(100, 300), each=3)
graph@nodeAttr$X <- nodeX
graph@nodeAttr$Y <- nodeY

getWeights(graph)
#>       H11       H21       H31       H12       H22       H32 
#> 0.3333333 0.3333333 0.3333333 0.0000000 0.0000000 0.0000000 

getRejected(graph)
#>   H11   H21   H31   H12   H22   H32 
#> FALSE FALSE FALSE FALSE FALSE FALSE 

pvalues <- c(0.1, 0.008, 0.005, 0.15, 0.04, 0.006)
result <- gMCP(graph, pvalues)

getWeights(result@graphs[[4]])
#>       H11       H21       H31       H12       H22       H32 
#> 0.6666667 0.0000000 0.0000000 0.0000000 0.3333333 0.0000000 
getRejected(result@graphs[[4]])
#>   H11   H21   H31   H12   H22   H32 
#> FALSE  TRUE  TRUE FALSE FALSE  TRUE 
```
