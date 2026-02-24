# Trimmed Simes test for intersections of two hypotheses and otherwise weighted Bonferroni-test

Trimmed Simes test for intersections of two hypotheses and otherwise
weighted Bonferroni-test

## Usage

``` r
bonferroni.trimmed.simes.test(
  pvalues,
  weights,
  alpha = 0.05,
  adjPValues = FALSE,
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
  weighted test is returned. Otherwise if `adjPValues==FALSE` a logical
  value is returned whether the null hypothesis can be rejected.

- verbose:

  Logical scalar. If `TRUE` verbose output is generated.

- ...:

  Further arguments possibly passed by `gMCP` which will be used by
  other test procedures but not this one.

## Value

adjusted p-value or decision of rejection

## References

Brannath, W., Bretz, F., Maurer, W., & Sarkar, S. (2009). Trimmed
Weighted Simes Test for Two One-Sided Hypotheses With Arbitrarily
Correlated Test Statistics. Biometrical Journal, 51(6), 885-898.

## Examples

``` r
bonferroni.trimmed.simes.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0))
#> [1] FALSE
bonferroni.trimmed.simes.test(pvalues=c(0.1,0.2,0.05), weights=c(0.5,0.5,0), adjPValues=FALSE)
#> [1] FALSE
```
