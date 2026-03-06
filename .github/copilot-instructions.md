# Copilot Instructions

## R CMD Check

Always ensure `R CMD check` passes without any errors, warnings, or notes before pushing changes.

To run `R CMD check` locally:

```sh
R CMD build . && R CMD check --no-manual --as-cran *.tar.gz
```

### Common issues to watch for

- **Documentation and NAMESPACE**: After making any changes to source code in `R/*.R`, always run `roxygen2::roxygenize()` to regenerate the documentation in `man/*.Rd` and the `NAMESPACE` file.
- **Snapshot tests**: If you change plotting code (e.g., in `R/hgraph.R`), the vdiffr snapshot tests in `tests/testthat/test-hgraph.R` will fail. To regenerate snapshots, run:

  ```sh
  NOT_CRAN=true Rscript -e "
    setwd('tests/testthat')
    library(testthat)
    library(gMCPLite)
    test_file('test-hgraph.R')
  "
  ```

  Then commit the updated SVG files in `tests/testthat/_snaps/hgraph/`.
