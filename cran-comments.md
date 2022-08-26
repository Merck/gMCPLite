This is a new release that fixed the issues in v0.1.0 identified by CRAN.

## R CMD check results

0 errors | 0 warnings | 1 note

## Improvements

 * Added method references DOI to the description field of the DESCRIPTION file.
 * Removed redundant \dontrun{} from examples.
 * Replaced cat() with message() where suppression options like verbose are not available, except for printing raw R Markdown content in vignettes, which requires cat().
 * Removed setting options(warn=-1) and options(warn=0) in function.
 * Reset the user's options() in vignettes after changing it.
