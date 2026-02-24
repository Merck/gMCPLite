# Placement of graph nodes

Places the nodes of a graph according to a specified layout.

## Usage

``` r
placeNodes(graph, nrow, ncol, byrow = TRUE, topdown = TRUE, force = FALSE)
```

## Arguments

- graph:

  A graph of class `graphMCP` or class `entangledMCP`.

- nrow:

  The desired number of rows.

- ncol:

  The desired number of columns.

- byrow:

  Logical whether the graph is filled by rows (otherwise by columns).

- topdown:

  Logical whether the rows are filled top-down or bottom-up.

- force:

  Logical whether a graph that has already a layout should be given the
  specified new layout.

## Value

The graph with nodes placed according to the specified layout.

## Details

If one of `nrow` or `ncol` is not given, an attempt is made to infer it
from the number of nodes of the `graph` and the other parameter. If
neither is given, the graph is placed as a circle.

## See also

`graphMCP`, `entangledMCP`

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r

g <- matrix2graph(matrix(0, nrow=6, ncol=6))

g <- placeNodes(g, nrow=2, force=TRUE)

```
