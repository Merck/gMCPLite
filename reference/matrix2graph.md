# Matrix2Graph and Graph2Matrix

Creates a graph of class `graphMCP` from a given transition matrix or
vice versa.

## Usage

``` r
matrix2graph(m, weights = rep(1/dim(m)[1], dim(m)[1]))

graph2matrix(graph)
```

## Arguments

- m:

  A transition matrix.

- weights:

  A numeric for the initial weights.

- graph:

  A graph of class `graphMCP`.

## Value

A graph of class `graphMCP` with the given transition matrix for
matrix2graph. The transition matrix of a `graphMCP` graph for
graph2matrix.

## Details

The hypotheses names are the row names or if these are `NULL`, the
column names or if these are also `NULL` of type H1, H2, H3, ...

If the diagonal of the matrix is unequal zero, the values are ignored
and a warning is given.

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r

# Bonferroni-Holm:
m <- matrix(rep(1/3, 16), nrow=4)
diag(m) <- c(0, 0, 0, 0)
graph <- matrix2graph(m)
print(graph)
#> A graphMCP graph
#> H1 (weight=0.25)
#> H2 (weight=0.25)
#> H3 (weight=0.25)
#> H4 (weight=0.25)
#> Edges:
#> H1  -( 0.333333333333333 )->  H2 
#> H1  -( 0.333333333333333 )->  H3 
#> H1  -( 0.333333333333333 )->  H4 
#> H2  -( 0.333333333333333 )->  H1 
#> H2  -( 0.333333333333333 )->  H3 
#> H2  -( 0.333333333333333 )->  H4 
#> H3  -( 0.333333333333333 )->  H1 
#> H3  -( 0.333333333333333 )->  H2 
#> H3  -( 0.333333333333333 )->  H4 
#> H4  -( 0.333333333333333 )->  H1 
#> H4  -( 0.333333333333333 )->  H2 
#> H4  -( 0.333333333333333 )->  H3 
#> 
graph2matrix(graph)
#>           H1        H2        H3        H4
#> H1 0.0000000 0.3333333 0.3333333 0.3333333
#> H2 0.3333333 0.0000000 0.3333333 0.3333333
#> H3 0.3333333 0.3333333 0.0000000 0.3333333
#> H4 0.3333333 0.3333333 0.3333333 0.0000000

```
