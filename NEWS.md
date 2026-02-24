# gMCPLite 0.1.7

## Maintenance

- Update maintainer email (#39).

# gMCPLite 0.1.6

## Testing

- Added vdiffr-based visual regression tests for `hGraph()` (@nanxstats, #35).

## Maintenance

- Linked the gMCPShiny app from the README (@XDeng0921, #30).
- Removed invalid URLs from roxygen2 documentation (@nanxstats, #33).
- Updated the pkgdown site: navbar styling for pkgdown >= 2.1.0 and refreshed
  favicon assets (@nanxstats, #34).

# gMCPLite 0.1.5

- In `hGraph()`, the `scale_fill_manual()` call now has the `guide`
  argument explicitly named for compatibility with ggplot2 >= 3.5.0
  (thanks, @teunbrand, #25).
- Port essential upstream changes in gMCP 0.8-16, including a fix for
  confidence interval calculations (#28).
- Standardize package name style in documentation (#29).

# gMCPLite 0.1.4

- Use the `cairo_pdf()` device for better Unicode character plotting support
  in code examples when the `pdf()` device is intentionally used, for example,
  when running `R CMD check` on the package (#22).

# gMCPLite 0.1.3

- Fix pkgdown vignette rendering of dynamic tabsets (#16).
- Update maintainer email.

# gMCPLite 0.1.2

- Added `docs/` in `.Rbuildignore`.
- Fixed a few typos.

# gMCPLite 0.1.1

## Improvements

- Added method references DOI to the description field of the `DESCRIPTION` file.
- Removed redundant `\dontrun{}` from examples.
- Replaced `cat()` with `message()` where suppression options like `verbose` are
  not available, except for printing raw R Markdown content in vignettes,
  which requires `cat()`.
- Removed setting `options(warn=-1)` and `options(warn=0)` in function.
- Reset the user's `options()` in vignettes after changing it.

# gMCPLite 0.1.0

- Created a fork from gMCP 0.8-15 and removed Java dependencies.
- Ported the `hGraph()` function from gsDesign 3.3.0, removed dependencies of
  dplyr, tidyr and magrittr, and updated the default `wchar` to the Unicode alpha.
