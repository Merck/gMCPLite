# Graph based Multiple Comparison Procedures

Performs a graph based multiple test procedure for a given graph and
unadjusted p-values.

## Usage

``` r
gMCP.extended(
  graph,
  pvalues,
  test,
  alpha = 0.05,
  eps = 10^(-3),
  upscale = FALSE,
  verbose = FALSE,
  adjPValues = TRUE,
  ...
)
```

## Arguments

- graph:

  A graph of class `graphMCP`.

- pvalues:

  A numeric vector specifying the p-values for the graph based MCP. Note
  the assumptions in the description of the selected test (if there are
  any - for example `test=bonferroni.test` has no further assumptions,
  but `test=parametric.test` assumes p-values from a multivariate normal
  distribution).

- test:

  A weighted test function.

  The package gMCP provides the following weighted test functions:

  bonferroni.test

  :   Bonferroni test - see
      [`?bonferroni.test`](https://merck.github.io/gMCPLite/reference/bonferroni.test.md)
      for details.

  parametric.test

  :   Parametric test - see
      [`?parametric.test`](https://merck.github.io/gMCPLite/reference/parametric.test.md)
      for details.

  simes.test

  :   Simes test - see
      [`?simes.test`](https://merck.github.io/gMCPLite/reference/simes.test.md)
      for details.

  bonferroni.trimmed.simes.test

  :   Trimmed Simes test for intersections of two hypotheses and
      otherwise Bonferroni - see
      [`?bonferroni.trimmed.simes.test`](https://merck.github.io/gMCPLite/reference/bonferroni.trimmed.simes.test.md)
      for details.

  simes.on.subsets.test

  :   Simes test for intersections of hypotheses from certain sets and
      otherwise Bonferroni - see
      [`?simes.on.subsets.test`](https://merck.github.io/gMCPLite/reference/simes.on.subsets.test.md)
      for details.

  To provide your own test function see `?weighted.test.function`.

- alpha:

  A numeric specifying the maximal allowed type one error rate.

- eps:

  A numeric scalar specifying a value for epsilon edges.

- upscale:

  Logical. If `upscale=FALSE` then for each intersection of hypotheses
  (i.e. each subgraph) a weighted test is performed at the possibly
  reduced level alpha of sum(w)\*alpha, where sum(w) is the sum of all
  node weights in this subset. If `upscale=TRUE` all weights are
  upscaled, so that sum(w)=1.

- verbose:

  Logical scalar. If `TRUE` verbose output is generated during
  sequentially rejection steps.

- adjPValues:

  Logical scalar. If `FALSE` no adjusted p-values will be calculated.
  Especially for the weighted Simes test this will result in
  significantly less calculations in most cases.

- ...:

  Test specific arguments can be given here.

## Value

An object of class `gMCPResult`, more specifically a list with elements

- `graphs`:

  list of graphs

- `pvalues`:

  p-values

- `rejected`:

  logical whether hypotheses could be rejected

- `adjPValues`:

  adjusted p-values

## References

Frank Bretz, Willi Maurer, Werner Brannath, Martin Posch: A graphical
approach to sequentially rejective multiple test procedures. Statistics
in Medicine 2009 vol. 28 issue 4 page 586-604.

Bretz F., Posch M., Glimm E., Klinglmueller F., Maurer W., Rohmeyer K.
(2011): Graphical approaches for multiple endpoint problems using
weighted Bonferroni, Simes or parametric tests. Biometrical Journal 53
(6), pages 894-913, Wiley.
[doi:10.1002/bimj.201000239](https://doi.org/10.1002/bimj.201000239)

Strassburger K., Bretz F.: Compatible simultaneous lower confidence
bounds for the Holm procedure and other Bonferroni based closed tests.
Statistics in Medicine 2008; 27:4914-4927.

Hommel G., Bretz F., Maurer W.: Powerful short-cuts for multiple testing
procedures with special reference to gatekeeping strategies. Statistics
in Medicine 2007; 26:4063-4073.

Guilbaud O.: Simultaneous confidence regions corresponding to Holm's
stepdown procedure and other closed-testing procedures. Biometrical
Journal 2008; 50:678-692.

## See also

`graphMCP`
[`multcomp::contrMat()`](https://rdrr.io/pkg/multcomp/man/contrMat.html)

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
g <- BonferroniHolm(5)
gMCP(g, pvalues=c(0.01, 0.02, 0.04, 0.04, 0.7))
#> gMCP-Result
#> 
#> Initial graph:
#> A graphMCP graph
#> H1 (weight=0.2)
#> H2 (weight=0.2)
#> H3 (weight=0.2)
#> H4 (weight=0.2)
#> H5 (weight=0.2)
#> Edges:
#> H1  -( 0.25 )->  H2 
#> H1  -( 0.25 )->  H3 
#> H1  -( 0.25 )->  H4 
#> H1  -( 0.25 )->  H5 
#> H2  -( 0.25 )->  H1 
#> H2  -( 0.25 )->  H3 
#> H2  -( 0.25 )->  H4 
#> H2  -( 0.25 )->  H5 
#> H3  -( 0.25 )->  H1 
#> H3  -( 0.25 )->  H2 
#> H3  -( 0.25 )->  H4 
#> H3  -( 0.25 )->  H5 
#> H4  -( 0.25 )->  H1 
#> H4  -( 0.25 )->  H2 
#> H4  -( 0.25 )->  H3 
#> H4  -( 0.25 )->  H5 
#> H5  -( 0.25 )->  H1 
#> H5  -( 0.25 )->  H2 
#> H5  -( 0.25 )->  H3 
#> H5  -( 0.25 )->  H4 
#> 
#> 
#> P-values:
#>   H1   H2   H3   H4   H5 
#> 0.01 0.02 0.04 0.04 0.70 
#> 
#> Adjusted p-values:
#>   H1   H2   H3   H4   H5 
#> 0.05 0.08 0.12 0.12 0.70 
#> 
#> Alpha: 0.05 
#> 
#> Hypothesis rejected:
#>    H1    H2    H3    H4    H5 
#>  TRUE FALSE FALSE FALSE FALSE 
#> 
#> Final graph after1steps:
#> A graphMCP graph
#> H1 (rejected, weight=0)
#> H2 (weight=0.25)
#> H3 (weight=0.25)
#> H4 (weight=0.25)
#> H5 (weight=0.25)
#> Edges:
#> H2  -( 0.333333333333333 )->  H3 
#> H2  -( 0.333333333333333 )->  H4 
#> H2  -( 0.333333333333333 )->  H5 
#> H3  -( 0.333333333333333 )->  H2 
#> H3  -( 0.333333333333333 )->  H4 
#> H3  -( 0.333333333333333 )->  H5 
#> H4  -( 0.333333333333333 )->  H2 
#> H4  -( 0.333333333333333 )->  H3 
#> H4  -( 0.333333333333333 )->  H5 
#> H5  -( 0.333333333333333 )->  H2 
#> H5  -( 0.333333333333333 )->  H3 
#> H5  -( 0.333333333333333 )->  H4 
#> 
# Simple Bonferroni with empty graph:
g2 <- matrix2graph(matrix(0, nrow=5, ncol=5))
gMCP(g2, pvalues=c(0.01, 0.02, 0.04, 0.04, 0.7))
#> gMCP-Result
#> 
#> Initial graph:
#> A graphMCP graph
#> H1 (weight=0.2)
#> H2 (weight=0.2)
#> H3 (weight=0.2)
#> H4 (weight=0.2)
#> H5 (weight=0.2)
#> No edges.
#> 
#> 
#> P-values:
#>   H1   H2   H3   H4   H5 
#> 0.01 0.02 0.04 0.04 0.70 
#> 
#> Adjusted p-values:
#>   H1   H2   H3   H4   H5 
#> 0.05 0.10 0.20 0.20 1.00 
#> 
#> Alpha: 0.05 
#> 
#> Hypothesis rejected:
#>    H1    H2    H3    H4    H5 
#>  TRUE FALSE FALSE FALSE FALSE 
#> 
#> Final graph after1steps:
#> A graphMCP graph
#> Sum of weight: 0.8
#> H1 (rejected, weight=0)
#> H2 (weight=0.2)
#> H3 (weight=0.2)
#> H4 (weight=0.2)
#> H5 (weight=0.2)
#> No edges.
#> 
# With 'upscale=TRUE' equal to BonferroniHolm:
gMCP(g2, pvalues=c(0.01, 0.02, 0.04, 0.04, 0.7), upscale=TRUE)
#> gMCP-Result
#> 
#> Initial graph:
#> A graphMCP graph
#> H1 (weight=0.2)
#> H2 (weight=0.2)
#> H3 (weight=0.2)
#> H4 (weight=0.2)
#> H5 (weight=0.2)
#> No edges.
#> 
#> 
#> P-values:
#>   H1   H2   H3   H4   H5 
#> 0.01 0.02 0.04 0.04 0.70 
#> 
#> Adjusted p-values:
#>   H1   H2   H3   H4   H5 
#> 0.05 0.08 0.12 0.12 0.70 
#> 
#> Alpha: 0.05 
#> 
#> Hypothesis rejected:
#>    H1    H2    H3    H4    H5 
#>  TRUE FALSE FALSE FALSE FALSE 
#> 
#> Final graph after1steps:
#> A graphMCP graph
#> H1 (rejected, weight=0)
#> H2 (weight=0.25)
#> H3 (weight=0.25)
#> H4 (weight=0.25)
#> H5 (weight=0.25)
#> No edges.
#> 

# Entangled graphs:
g3 <- Entangled2Maurer2012()
gMCP(g3, pvalues=c(0.01, 0.02, 0.04, 0.04, 0.7), correlation=diag(5))
#> gMCP-Result
#> 
#> Initial graph:
#> An object of class "entangledMCP"
#> Slot "subgraphs":
#> [[1]]
#> A graphMCP graph
#> H1 (weight=1)
#> H2 (weight=0)
#> H3 (weight=0)
#> H4 (weight=0)
#> H5 (weight=0)
#> Edges:
#> H1  -( 1 )->  H3 
#> H2  -( 1 )->  H5 
#> H3  -( 1 )->  H4 
#> H4  -( 1 )->  H2 
#> 
#> 
#> [[2]]
#> A graphMCP graph
#> H1 (weight=0)
#> H2 (weight=1)
#> H3 (weight=0)
#> H4 (weight=0)
#> H5 (weight=0)
#> Edges:
#> H1  -( 1 )->  H4 
#> H2  -( 1 )->  H3 
#> H3  -( 1 )->  H5 
#> H5  -( 1 )->  H1 
#> 
#> 
#> 
#> Slot "weights":
#> [1] 0.5 0.5
#> 
#> Slot "graphAttr":
#> list()
#> 
#> 
#> P-values:
#>   H1   H2   H3   H4   H5 
#> 0.01 0.02 0.04 0.04 0.70 
#> 
#> Adjusted p-values:
#>     H1     H2     H3     H4     H5 
#> 0.0199 0.0396 0.0400 0.0784 0.7000 
#> 
#> Alpha: 0.05 
#> 
#> Hypothesis rejected:
#>    H1    H2    H3    H4    H5 
#>  TRUE  TRUE  TRUE FALSE FALSE 
```
