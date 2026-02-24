# gMCPLite

gMCPLite is a fork of gMCP for graph-based multiple comparison
procedures, with the following features:

- Kept a selected subset of the original functions.
- Removed the rJava dependency and the Java-based graphical interface.
- Added an
  [`hGraph()`](https://merck.github.io/gMCPLite/reference/hGraph.md)
  function for ggplot2 visualizations. It bridges gMCP result objects
  and gsDesign to produce multiple comparison graphs and sequential
  graph updates.

A [Shiny app](https://rinpharma.shinyapps.io/gmcp/) is also available to
generate graphs of multiple comparisons and update graphs based on
graphical approach.

## Installation

``` r
# The easiest way to get gMCPLite is to install:
install.packages("gMCPLite")

# Alternatively, install development version from GitHub:
# install.packages("remotes")
remotes::install_github("Merck/gMCPLite")
```
