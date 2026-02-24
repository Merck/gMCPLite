# Simes on subsets, otherwise Bonferroni

Weighted Simes test introduced by Benjamini and Hochberg (1997)

## Usage

``` r
simes.on.subsets.test(
  pvalues,
  weights,
  alpha = 0.05,
  adjPValues = TRUE,
  verbose = FALSE,
  subsets,
  subset,
  ...
)
```

## Arguments

- pvalues:

  A numeric vector specifying the p-values.

- weights:

  A numeric vector of weights.

- alpha:

  A numeric specifying the maximal allowed type one error rate. If
  `adjPValues==TRUE` (default) the parameter `alpha` is not used.

- adjPValues:

  Logical scalar. If `TRUE` (the default) an adjusted p-value for the
  weighted test is returned. Otherwise if `adjPValues==FALSE` a logical
  value is returned whether the null hypothesis can be rejected.

- verbose:

  Logical scalar. If `TRUE` verbose output is generated.

- subsets:

  A list of subsets given by numeric vectors containing the indices of
  the elementary hypotheses for which the weighted Simes test is
  applicable.

- subset:

  A numeric vector containing the numbers of the indices of the
  currently tested elementary hypotheses.

- ...:

  Further arguments possibly passed by `gMCP` which will be used by
  other test procedures but not this one.

## Value

adjusted p-value or decision of rejection

## Details

As an additional argument a list of subsets must be provided, that
states in which cases a Simes test is applicable (i.e. if all hypotheses
to test belong to one of these subsets), e.g. subsets \<- list(c("H1",
"H2", "H3"), c("H4", "H5", "H6")) Trimmed Simes test for intersections
of two hypotheses and otherwise weighted Bonferroni-test

## Examples

``` r
simes.on.subsets.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0))
#> [1] 0.2
simes.on.subsets.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues=FALSE)
#> [1] FALSE

graph <- BonferroniHolm(4)
pvalues <- c(0.01, 0.05, 0.03, 0.02)

gMCP.extended(graph=graph, pvalues=pvalues, test=simes.on.subsets.test, subsets=list(1:2, 3:4))
#> gMCP-Result
#> 
#> Initial graph:
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
#> 
#> P-values:
#> [1] 0.01 0.05 0.03 0.02
#> 
#> Adjusted p-values:
#> [1] 0.04 0.06 0.06 0.06
#> 
#> Alpha: 0.05 
#> 
#> Hypothesis rejected:
#>    H1    H2    H3    H4 
#>  TRUE FALSE FALSE FALSE 
#> 
#> Final graph after1steps:
#> A graphMCP graph
#> H1 (rejected, weight=0)
#> H2 (weight=0.3333)
#> H3 (weight=0.3333)
#> H4 (weight=0.3333)
#> Edges:
#> H2  -( 0.5 )->  H3 
#> H2  -( 0.5 )->  H4 
#> H3  -( 0.5 )->  H2 
#> H3  -( 0.5 )->  H4 
#> H4  -( 0.5 )->  H2 
#> H4  -( 0.5 )->  H3 
#> 
```
