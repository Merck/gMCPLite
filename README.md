# gMCPLite <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/Merck/gMCPLite/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Merck/gMCPLite/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/Merck/gMCPLite/graph/badge.svg)](https://app.codecov.io/gh/Merck/gMCPLite)
[![CRAN status](https://www.r-pkg.org/badges/version/gMCPLite)](https://cran.r-project.org/package=gMCPLite)
[![CRAN Downloads](https://cranlogs.r-pkg.org/badges/gMCPLite)](https://cran.r-project.org/package=gMCPLite)
<!-- badges: end -->

gMCPLite is a fork of gMCP for graph-based multiple comparison procedures,
with the following features:

- Kept a selected subset of the original functions.
- Removed the rJava dependency and the Java-based graphical interface.
- Added an `hGraph()` function for ggplot2 visualizations.
  It bridges gMCP result objects and gsDesign to produce
  multiple comparison graphs and sequential graph updates.

A [Shiny app](https://rinpharma.shinyapps.io/gmcp/) is also available to generate graphs of multiple comparisons and update graphs based on graphical approach.

## Installation

```r
# The easiest way to get gMCPLite is to install:
install.packages("gMCPLite")

# Alternatively, install development version from GitHub:
# install.packages("remotes")
remotes::install_github("Merck/gMCPLite")
```
