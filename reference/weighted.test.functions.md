# Weighted Test Functions for use with gMCP

The package gMCP provides the following weighted test functions:

- bonferroni.test:

  Bonferroni test - see
  [`?bonferroni.test`](https://merck.github.io/gMCPLite/reference/bonferroni.test.md)
  for details.

- parametric.test:

  Parametric test - see
  [`?parametric.test`](https://merck.github.io/gMCPLite/reference/parametric.test.md)
  for details.

- simes.test:

  Simes test - see
  [`?simes.test`](https://merck.github.io/gMCPLite/reference/simes.test.md)
  for details.

- bonferroni.trimmed.simes.test:

  Trimmed Simes test for intersections of two hypotheses and otherwise
  Bonferroni - see
  [`?bonferroni.trimmed.simes.test`](https://merck.github.io/gMCPLite/reference/bonferroni.trimmed.simes.test.md)
  for details.

- simes.on.subsets.test:

  Simes test for intersections of hypotheses from certain sets and
  otherwise Bonferroni - see
  [`?simes.on.subsets.test`](https://merck.github.io/gMCPLite/reference/simes.on.subsets.test.md)
  for details.

## Details

Depending on whether `adjPValues==TRUE` these test functions return
different values:

- If `adjPValues==TRUE` the minimal value for alpha is returned for
  which the null hypothesis can be rejected. If that's not possible (for
  example in case of the trimmed Simes test adjusted p-values can not be
  calculated), the test function may throw an error.

- If `adjPValues==FALSE` a logical value is returned whether the null
  hypothesis can be rejected.

To provide your own test function write a function that takes at least
the following arguments:

- pvalues:

  A numeric vector specifying the p-values.

- weights:

  A numeric vector of weights.

- alpha:

  A numeric specifying the maximal allowed type one error rate. If
  `adjPValues==TRUE` (default) the parameter `alpha` should not be used.

- adjPValues:

  Logical scalar. If `TRUE` an adjusted p-value for the weighted test is
  returned (if possible - if not the function should call `stop`).
  Otherwise if `adjPValues==FALSE` a logical value is returned whether
  the null hypothesis can be rejected.

- ...:

  Further arguments possibly passed by `gMCP` which will be used by
  other test procedures but not this one.

Further the following parameters have a predefined meaning:

- verbose:

  Logical scalar. If `TRUE` verbose output should be generated and
  printed to the standard output

- subset:

- correlation:

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
# The test function 'bonferroni.test' is used in by gMCP in the following call:
graph <- BonferroniHolm(4)
pvalues <- c(0.01, 0.05, 0.03, 0.02)
alpha <- 0.05
r <- gMCP.extended(graph=graph, pvalues=pvalues, test=bonferroni.test, verbose=TRUE)
#> Info:
#> Subset {4}: rejected (adj-p: 0.02)
#> Subset {3}: rejected (adj-p: 0.03)
#> Subset {3,4}: rejected (adj-p: 0.04)
#> Subset {2}: rejected (adj-p: 0.05)
#> Subset {2,4}: rejected (adj-p: 0.04)
#> Subset {2,3}: not rejected (adj-p: 0.06)
#> Subset {2,3,4}: not rejected (adj-p: 0.06)
#> Subset {1}: rejected (adj-p: 0.01)
#> Subset {1,4}: rejected (adj-p: 0.02)
#> Subset {1,3}: rejected (adj-p: 0.02)
#> Subset {1,3,4}: rejected (adj-p: 0.03)
#> Subset {1,2}: rejected (adj-p: 0.02)
#> Subset {1,2,4}: rejected (adj-p: 0.03)
#> Subset {1,2,3}: rejected (adj-p: 0.03)
#> Subset {1,2,3,4}: rejected (adj-p: 0.04) 

# For the intersection of all four elementary hypotheses this results in a call
bonferroni.test(pvalues=pvalues, weights=getWeights(graph))
#> [1] 0.04
bonferroni.test(pvalues=pvalues, weights=getWeights(graph), adjPValues=FALSE)
#> [1] TRUE

# bonferroni.test function:
bonferroni.test <- function(pvalues, weights, alpha=0.05, adjPValues=TRUE, verbose=FALSE, ...) {
  if (adjPValues) {
    return(min(pvalues/weights))
  } else {
    return(any(pvalues<=alpha*weights))
  }
}
```
