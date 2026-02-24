# Substitute Epsilon

Substitute Epsilon with a given value.

## Usage

``` r
substituteEps(graph, eps = 10^(-3))
```

## Arguments

- graph:

  A graph of class `graphMCP` or class `entangledMCP`.

- eps:

  A numeric scalar specifying a value for epsilon edges.

## Value

A graph where all epsilons have been replaced with the given value.

## Details

For details see the given references.

## See also

`graphMCP`, `entangledMCP`

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r

graph <- improvedParallelGatekeeping()
graph
#> A graphMCP graph
#> H1 (weight=0.5)
#> H2 (weight=0.5)
#> H3 (weight=0)
#> H4 (weight=0)
#> Edges:
#> H1  -( 0.5 )->  H3 
#> H1  -( 0.5 )->  H4 
#> H2  -( 0.5 )->  H3 
#> H2  -( 0.5 )->  H4 
#> H3  -( \epsilon )->  H1 
#> H3  -( 1-\epsilon )->  H4 
#> H4  -( \epsilon )->  H2 
#> H4  -( 1-\epsilon )->  H3 
#> 
substituteEps(graph, eps=0.01)
#> A graphMCP graph
#> H1 (weight=0.5)
#> H2 (weight=0.5)
#> H3 (weight=0)
#> H4 (weight=0)
#> Edges:
#> H1  -( 0.5 )->  H3 
#> H1  -( 0.5 )->  H4 
#> H2  -( 0.5 )->  H3 
#> H2  -( 0.5 )->  H4 
#> H3  -( 0.01 )->  H1 
#> H3  -( 0.99 )->  H4 
#> H4  -( 0.01 )->  H2 
#> H4  -( 0.99 )->  H3 
#> 

```
