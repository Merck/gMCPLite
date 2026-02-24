# Class gMCPResult

A gMCPResult object describes an evaluated sequentially rejective
multiple test procedure.

## Slots

- `graphs`:

  Object of class `list`.

- `alpha`:

  A `numeric` specifying the maximal type I error rate.

- `pvalues`:

  The `numeric` vector of p-values.

- `rejected`:

  The `logical` vector of rejected null hypotheses.

- `adjPValues`:

  The `numeric` vector of adjusted p-values.

## See also

[`gMCP`](https://merck.github.io/gMCPLite/reference/gMCP.md)

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>
