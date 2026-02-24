# Changelog

## gMCPLite 0.1.7

### Maintenance

- Snapshot files are now included in the built package to satisfy
  testthat (\>= 3.3.0) requirements
  ([\#40](https://github.com/Merck/gMCPLite/issues/40)).
- Update maintainer email
  ([\#39](https://github.com/Merck/gMCPLite/issues/39)).

## gMCPLite 0.1.6

CRAN release: 2025-08-26

### Testing

- Added vdiffr-based visual regression tests for
  [`hGraph()`](https://merck.github.io/gMCPLite/reference/hGraph.md)
  ([@nanxstats](https://github.com/nanxstats),
  [\#35](https://github.com/Merck/gMCPLite/issues/35)).

### Maintenance

- Linked the gMCPShiny app from the README
  ([@XDeng0921](https://github.com/XDeng0921),
  [\#30](https://github.com/Merck/gMCPLite/issues/30)).
- Removed invalid URLs from roxygen2 documentation
  ([@nanxstats](https://github.com/nanxstats),
  [\#33](https://github.com/Merck/gMCPLite/issues/33)).
- Updated the pkgdown site: navbar styling for pkgdown \>= 2.1.0 and
  refreshed favicon assets ([@nanxstats](https://github.com/nanxstats),
  [\#34](https://github.com/Merck/gMCPLite/issues/34)).

## gMCPLite 0.1.5

CRAN release: 2024-01-11

- In [`hGraph()`](https://merck.github.io/gMCPLite/reference/hGraph.md),
  the
  [`scale_fill_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html)
  call now has the `guide` argument explicitly named for compatibility
  with ggplot2 \>= 3.5.0 (thanks,
  [@teunbrand](https://github.com/teunbrand),
  [\#25](https://github.com/Merck/gMCPLite/issues/25)).
- Port essential upstream changes in gMCP 0.8-16, including a fix for
  confidence interval calculations
  ([\#28](https://github.com/Merck/gMCPLite/issues/28)).
- Standardize package name style in documentation
  ([\#29](https://github.com/Merck/gMCPLite/issues/29)).

## gMCPLite 0.1.4

CRAN release: 2023-11-08

- Use the [`cairo_pdf()`](https://rdrr.io/r/grDevices/cairo.html) device
  for better Unicode character plotting support in code examples when
  the [`pdf()`](https://rdrr.io/r/grDevices/pdf.html) device is
  intentionally used, for example, when running `R CMD check` on the
  package ([\#22](https://github.com/Merck/gMCPLite/issues/22)).

## gMCPLite 0.1.3

CRAN release: 2023-09-25

- Fix pkgdown vignette rendering of dynamic tabsets
  ([\#16](https://github.com/Merck/gMCPLite/issues/16)).
- Update maintainer email.

## gMCPLite 0.1.2

CRAN release: 2022-08-30

- Added `docs/` in `.Rbuildignore`.
- Fixed a few typos.

## gMCPLite 0.1.1

### Improvements

- Added method references DOI to the description field of the
  `DESCRIPTION` file.
- Removed redundant `\dontrun{}` from examples.
- Replaced [`cat()`](https://rdrr.io/r/base/cat.html) with
  [`message()`](https://rdrr.io/r/base/message.html) where suppression
  options like `verbose` are not available, except for printing raw R
  Markdown content in vignettes, which requires
  [`cat()`](https://rdrr.io/r/base/cat.html).
- Removed setting `options(warn=-1)` and `options(warn=0)` in function.
- Reset the user’s [`options()`](https://rdrr.io/r/base/options.html) in
  vignettes after changing it.

## gMCPLite 0.1.0

- Created a fork from gMCP 0.8-15 and removed Java dependencies.
- Ported the
  [`hGraph()`](https://merck.github.io/gMCPLite/reference/hGraph.md)
  function from gsDesign 3.3.0, removed dependencies of dplyr, tidyr and
  magrittr, and updated the default `wchar` to the Unicode alpha.
