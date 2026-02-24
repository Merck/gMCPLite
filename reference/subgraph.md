# Get a subgraph

Given a set of nodes and a graph this function creates the subgraph
containing only the specified nodes.

## Usage

``` r
subgraph(graph, subset)
```

## Arguments

- graph:

  A graph of class `graphMCP`.

- subset:

  A logical or character vector specifying the nodes in the subgraph.

## Value

A subgraph containing only the specified nodes.

## See also

`graphMCP`

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r

graph <- improvedParallelGatekeeping()
subgraph(graph, c(TRUE, FALSE, TRUE, FALSE))
#> A graphMCP graph
#> Sum of weight: 0.5
#> H1 (weight=0.5)
#> H3 (weight=0)
#> Edges:
#> H1  -( 0.5 )->  H3 
#> H3  -( \epsilon )->  H1 
#> 
subgraph(graph, c("H1", "H3"))
#> A graphMCP graph
#> Sum of weight: 0.5
#> H1 (weight=0.5)
#> H3 (weight=0)
#> Edges:
#> H1  -( 0.5 )->  H3 
#> H3  -( \epsilon )->  H1 
#> 

```
