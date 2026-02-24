# Weighted Bonferroni-test

Weighted Bonferroni-test

## Usage

``` r
bonferroni.test(
  pvalues,
  weights,
  alpha = 0.05,
  adjPValues = TRUE,
  verbose = FALSE,
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
  weighted Bonferroni-test is returned. Otherwise if `adjPValues==FALSE`
  a logical value is returned whether the null hypothesis can be
  rejected.

- verbose:

  Logical scalar. If `TRUE` verbose output is generated.

- ...:

  Further arguments possibly passed by `gMCP` which will be used by
  other test procedures but not this one.

## Value

adjusted p-value or decision of rejection

## Examples

``` r
bonferroni.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0))
#> [1] 0.2
bonferroni.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues=FALSE)
#> [1] FALSE
```
