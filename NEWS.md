# gMCPLite 0.1.2

- Added `docs` in .Rbuildignore.
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
