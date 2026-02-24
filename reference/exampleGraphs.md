# Functions that create different example graphs

Functions that creates example graphs, e.g. graphs that represents a
Bonferroni-Holm adjustment, parallel gatekeeping or special procedures
from selected papers.

## Usage

``` r
BonferroniHolm(n, weights = rep(1/n, n))

BretzEtAl2011()

BauerEtAl2001()

BretzEtAl2009a()

BretzEtAl2009b()

BretzEtAl2009c()

HommelEtAl2007()

HommelEtAl2007Simple()

parallelGatekeeping()

improvedParallelGatekeeping()

fallback(weights)

fixedSequence(n)

simpleSuccessiveI()

simpleSuccessiveII()

truncatedHolm(gamma)

generalSuccessive(weights = c(1/2, 1/2), gamma, delta)

HuqueAloshEtBhore2011()

HungEtWang2010(nu, tau, omega)

MaurerEtAl1995()

cycleGraph(nodes, weights)

improvedFallbackI(weights = rep(1/3, 3))

improvedFallbackII(weights = rep(1/3, 3))

FerberTimeDose2011(times, doses, w = "\\nu")

Ferber2011(w)

Entangled1Maurer2012()

Entangled2Maurer2012()

WangTing2014(nu, tau)
```

## Arguments

- n:

  Number of hypotheses.

- weights:

  Numeric vector of node weights.

- gamma:

  An optional number in \[0,1\] specifying the value for variable gamma.

- delta:

  An optional number in \[0,1\] specifying the value for variable delta.

- nu:

  An optional number in \[0,1\] specifying the value for variable nu.

- tau:

  An optional number in \[0,1\] specifying the value for variable tau.

- omega:

  An optional number in \[0,1\] specifying the value for variable omega.

- nodes:

  Character vector of node names.

- times:

  Number of time points.

- doses:

  Number of dose levels.

- w:

  Further variable weight(s) in graph.

## Value

A graph of class `graphMCP` that represents a sequentially rejective
multiple test procedure.

## Details

We are providing functions and not the resulting graphs directly because
this way you have additional examples: You can look at the function body
with [`body`](https://rdrr.io/r/base/body.html) and see how the graph is
built.

- list("BonferroniHolm"):

  Returns a graph that represents a Bonferroni-Holm adjustment. The
  result is a complete graph, where all nodes have the same weights and
  each edge weight is \\\frac{1}{n-1}\\.

- list("BretzEtAl2011"):

  Graph in figure 2 from Bretz et al. See references (Bretz et al.
  2011).

- list("HommelEtAl2007"):

  Graph from Hommel et al. See references (Hommel et al. 2007).

- list("parallelGatekeeping"):

  Graph for parallel gatekeeping. See references (Dmitrienko et al.
  2003).

- list("improvedParallelGatekeeping"):

  Graph for improved parallel gatekeeping. See references (Hommel et al.
  2007).

- list("HungEtWang2010"):

  Graph from Hung et Wang. See references (Hung et Wang 2010).

- list("MaurerEtAl1995"):

  Graph from Maurer et al. See references (Maurer et al. 1995).

- list("cycleGraph"):

  Cycle graph. The weight `weights[i]` specifies the edge weight from
  node \\i\\ to node \\i+1\\ for \\i=1,\ldots,n-1\\ and `weight[n]` from
  node \\n\\ to node 1.

- list("improvedFallbackI"):

  Graph for the improved Fallback Procedure by Wiens & Dmitrienko. See
  references (Wiens et Dmitrienko 2005).

- list("improvedFallbackII"):

  Graph for the improved Fallback Procedure by Hommel & Bretz. See
  references (Hommel et Bretz 2008).

- list("Ferber2011"):

  Graph from Ferber et al. See references (Ferber et al. 2011).

- list("FerberTimeDose2011"):

  Graph from Ferber et al. See references (Ferber et al. 2011).

- list("Entangled1Maurer2012"):

  Entangled graph from Maurer et al. TODO: Add references as soon as
  they are available.

## References

Holm, S. (1979). A simple sequentially rejective multiple test
procedure. Scandinavian Journal of Statistics 6, 65-70.

Dmitrienko, A., Offen, W., Westfall, P.H. (2003). Gatekeeping strategies
for clinical trials that do not require all primary effects to be
significant. Statistics in Medicine. 22, 2387-2400.

Bretz, F., Maurer, W., Brannath, W., Posch, M.: A graphical approach to
sequentially rejective multiple test procedures. Statistics in Medicine
2009 vol. 28 issue 4 page 586-604.

Bretz, F., Maurer, W. and Hommel, G. (2011), Test and power
considerations for multiple endpoint analyses using sequentially
rejective graphical procedures. Statistics in Medicine, 30: 1489–1501.

Hommel, G., Bretz, F. und Maurer, W. (2007). Powerful short-cuts for
multiple testing procedures with special reference to gatekeeping
strategies. Statistics in Medicine, 26(22), 4063-4073.

Hommel, G., Bretz, F. (2008): Aesthetics and power considerations in
multiple testing - a contradiction? Biometrical Journal 50:657-666.

Hung H.M.J., Wang S.-J. (2010). Challenges to multiple testing in
clinical trials. Biometrical Journal 52, 747-756.

W. Maurer, L. Hothorn, W. Lehmacher: Multiple comparisons in drug
clinical trials and preclinical assays: a-priori ordered hypotheses. In
Biometrie in der chemisch-pharmazeutischen Industrie, Vollmar J (ed.).
Fischer Verlag: Stuttgart, 1995; 3-18.

Maurer, W., & Bretz, F. (2013). Memory and other properties of multiple
test procedures generated by entangled graphs. Statistics in medicine,
32 (10), 1739-1753.

Wiens, B.L., Dmitrienko, A. (2005): The fallback procedure for
evaluating a single family of hypotheses. Journal of Biopharmaceutical
Statistics 15:929-942.

Wang, B., Ting, N. (2014). An Application of Graphical Approach to
Construct Multiple Testing Procedures in a Hypothetical Phase III
Design. Frontiers in public health, 1 (75).

Ferber, G. Staner, L. and Boeijinga, P. (2011): Structured multiplicity
and confirmatory statistical analyses in pharmacodynamic studies using
the quantitative electroencephalogram, Journal of neuroscience methods,
Volume 201, Issue 1, Pages 204-212.

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
g <- BonferroniHolm(5)

gMCP(g, pvalues=c(0.1, 0.2, 0.4, 0.4, 0.7))
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
#>  H1  H2  H3  H4  H5 
#> 0.1 0.2 0.4 0.4 0.7 
#> 
#> Adjusted p-values:
#>  H1  H2  H3  H4  H5 
#> 0.5 0.8 1.0 1.0 1.0 
#> 
#> Alpha: 0.05 
#> 
#> No hypotheses could be rejected.

HungEtWang2010()
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( \nu )->  H_{1,S} 
#> H_{1,NI}  -( 1-\nu )->  H_{2,NI} 
#> H_{1,S}  -( \tau )->  H_{2,NI} 
#> H_{1,S}  -( 1-\tau )->  H_{2,S} 
#> H_{2,NI}  -( \omega )->  H_{1,S} 
#> H_{2,NI}  -( 1-\omega )->  H_{2,S} 
#> 
HungEtWang2010(nu=1)
#> A graphMCP graph
#> H_{1,NI} (weight=1)
#> H_{1,S} (weight=0)
#> H_{2,NI} (weight=0)
#> H_{2,S} (weight=0)
#> Edges:
#> H_{1,NI}  -( 1 )->  H_{1,S} 
#> H_{1,NI}  -( 1-1 )->  H_{2,NI} 
#> H_{1,S}  -( \tau )->  H_{2,NI} 
#> H_{1,S}  -( 1-\tau )->  H_{2,S} 
#> H_{2,NI}  -( \omega )->  H_{1,S} 
#> H_{2,NI}  -( 1-\omega )->  H_{2,S} 
#> 
```
