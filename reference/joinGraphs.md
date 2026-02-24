# Joins two graphMCP objects

Creates a new graphMCP object by joining two given graphMCP objects.

## Usage

``` r
joinGraphs(graph1, graph2, xOffset = 0, yOffset = 200)
```

## Arguments

- graph1:

  A graph of class `graphMCP`.

- graph2:

  A graph of class `graphMCP`.

- xOffset:

  A numeric specifying an offset (on the x-axis) for placing the nodes
  and edge labels of the second graph.

- yOffset:

  A numeric specifying an offset (on the y-axis) for placing the nodes
  and edge labels of the second graph.

## Value

A graphMCP object that represents a graph that consists of the two given
graphs.

## Details

If `graph1` and `graph2` have duplicates in the node names, the nodes of
the second graph will be renamed.

If and only if the sum of the weights of graph1 and graph2 exceeds 1,
the weights are scaled so that the sum equals 1.

A description attribute of either graph will be discarded.

## See also

`graphMCP`

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r

g1 <- BonferroniHolm(2)
g2 <- BonferroniHolm(3)

suppressWarnings(joinGraphs(g1, g2))
#> A graphMCP graph
#> H1 (weight=0.25)
#> H2 (weight=0.25)
#> H4 (weight=0.1667)
#> H5 (weight=0.1667)
#> H3 (weight=0.1667)
#> Edges:
#> H1  -( 1 )->  H2 
#> H2  -( 1 )->  H1 
#> H4  -( 0.5 )->  H5 
#> H4  -( 0.5 )->  H3 
#> H5  -( 0.5 )->  H4 
#> H5  -( 0.5 )->  H3 
#> H3  -( 0.5 )->  H4 
#> H3  -( 0.5 )->  H5 
#> 

```
