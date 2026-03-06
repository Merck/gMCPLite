# Copilot Instructions

## R CMD Check

Always ensure `R CMD check` passes without any errors, warnings, or notes before pushing changes.

To run `R CMD check` locally:

```r
# Install check dependencies
install.packages("rcmdcheck")

# Run the check
rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")
```

Or using devtools:

```r
devtools::check()
```

### Common issues to watch for

- **Documentation mismatches**: If you add or rename function parameters, update the corresponding `man/*.Rd` file and the `@param` roxygen2 tags in the source `R/*.R` file.
- **Snapshot tests**: If you change plotting code (e.g., in `R/hgraph.R`), the vdiffr snapshot tests in `tests/testthat/test-hgraph.R` will fail. To regenerate snapshots, run:

  ```r
  NOT_CRAN=true Rscript -e "
    setwd('tests/testthat')
    library(testthat)
    library(gMCPLite)
    test_file('test-hgraph.R')
  "
  ```

  Then commit the updated SVG files in `tests/testthat/_snaps/hgraph/`.

- **NAMESPACE**: If you add new imports or exports, update `NAMESPACE` using `devtools::document()`.
