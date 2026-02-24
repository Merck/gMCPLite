# Replaces variables in a general graph with specified numeric values

Given a list of variables and real values a general graph is processed
and each variable replaced with the specified numeric value.

## Usage

``` r
replaceVariables(
  graph,
  variables = list(),
  ask = TRUE,
  partial = FALSE,
  expand = TRUE,
  list = FALSE
)
```

## Arguments

- graph:

  A graph of class `graphMCP` or class `entangledMCP`.

- variables:

  A named list with one or more specified real values, for example
  `list(a=0.5, b=0.8, "tau"=0.5)` or
  `list(a=c(0.5, 0.8), b=0.8, "tau"=0.5)`. If `ask=TRUE` and this list
  is missing at all or single variables are missing from the list, the
  user is asked for the values (if the session is not interactive an
  error is thrown). For interactively entered values only single numbers
  are supported.

- ask:

  If `FALSE` all variables that are not specified are not replaced.

- partial:

  IF `TRUE` only specified variables are replaced and parameter `ask` is
  ignored.

- expand:

  Used internally. Don't use yourself.

- list:

  If `TRUE` the result will always be a list, even if only one graph is
  returned in this list.

## Value

A graph or a matrix with variables replaced by the specified numeric
values. Or a list of theses graphs and matrices if a variable had more
than one value.

## See also

`graphMCP`, `entangledMCP`

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
graph <- HungEtWang2010()
replaceVariables(graph, list("tau"=0.5,"omega"=0.5, "nu"=0.5))
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.5 )->  H_{1,S} 
#> H_{1,NI}  -( 0.5 )->  H_{2,NI} 
#> H_{1,S}  -( 0.5 )->  H_{2,NI} 
#> H_{1,S}  -( 0.5 )->  H_{2,S} 
#> H_{2,NI}  -( 0.5 )->  H_{1,S} 
#> H_{2,NI}  -( 0.5 )->  H_{2,S} 
#> 
replaceVariables(graph, list("tau"=c(0.1, 0.5, 0.9),"omega"=c(0.2, 0.8), "nu"=0.4))
#> [[1]]
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.4 )->  H_{1,S} 
#> H_{1,NI}  -( 0.6 )->  H_{2,NI} 
#> H_{1,S}  -( 0.1 )->  H_{2,NI} 
#> H_{1,S}  -( 0.9 )->  H_{2,S} 
#> H_{2,NI}  -( 0.2 )->  H_{1,S} 
#> H_{2,NI}  -( 0.8 )->  H_{2,S} 
#> 
#> 
#> [[2]]
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.4 )->  H_{1,S} 
#> H_{1,NI}  -( 0.6 )->  H_{2,NI} 
#> H_{1,S}  -( 0.5 )->  H_{2,NI} 
#> H_{1,S}  -( 0.5 )->  H_{2,S} 
#> H_{2,NI}  -( 0.2 )->  H_{1,S} 
#> H_{2,NI}  -( 0.8 )->  H_{2,S} 
#> 
#> 
#> [[3]]
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.4 )->  H_{1,S} 
#> H_{1,NI}  -( 0.6 )->  H_{2,NI} 
#> H_{1,S}  -( 0.9 )->  H_{2,NI} 
#> H_{1,S}  -( 0.1 )->  H_{2,S} 
#> H_{2,NI}  -( 0.2 )->  H_{1,S} 
#> H_{2,NI}  -( 0.8 )->  H_{2,S} 
#> 
#> 
#> [[4]]
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.4 )->  H_{1,S} 
#> H_{1,NI}  -( 0.6 )->  H_{2,NI} 
#> H_{1,S}  -( 0.1 )->  H_{2,NI} 
#> H_{1,S}  -( 0.9 )->  H_{2,S} 
#> H_{2,NI}  -( 0.8 )->  H_{1,S} 
#> H_{2,NI}  -( 0.2 )->  H_{2,S} 
#> 
#> 
#> [[5]]
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.4 )->  H_{1,S} 
#> H_{1,NI}  -( 0.6 )->  H_{2,NI} 
#> H_{1,S}  -( 0.5 )->  H_{2,NI} 
#> H_{1,S}  -( 0.5 )->  H_{2,S} 
#> H_{2,NI}  -( 0.8 )->  H_{1,S} 
#> H_{2,NI}  -( 0.2 )->  H_{2,S} 
#> 
#> 
#> [[6]]
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 0.4 )->  H_{1,S} 
#> H_{1,NI}  -( 0.6 )->  H_{2,NI} 
#> H_{1,S}  -( 0.9 )->  H_{2,NI} 
#> H_{1,S}  -( 0.1 )->  H_{2,S} 
#> H_{2,NI}  -( 0.8 )->  H_{1,S} 
#> H_{2,NI}  -( 0.2 )->  H_{2,S} 
#> 
#> 
```
