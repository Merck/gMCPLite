# Create a Block Diagonal Matrix with NA outside the diagonal

Build a block diagonal matrix with NA values outside the diagonal given
several building block matrices.

## Usage

``` r
bdiagNA(...)
```

## Arguments

- ...:

  individual matrices or a `list` of matrices.

## Value

A block diagonal matrix with NA values outside the diagonal.

## Details

This function is useful to build the correlation matrices, when only
partial knowledge of the correlation exists.

## See also

[`gMCP`](https://merck.github.io/gMCPLite/reference/gMCP.md)

## Author

Kornelius Rohmeyer <rohmeyer@small-projects.de>

## Examples

``` r
bdiagNA(diag(3), matrix(1/2,nr=3,nc=3), diag(2))
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    1    0    0   NA   NA   NA   NA   NA
#> [2,]    0    1    0   NA   NA   NA   NA   NA
#> [3,]    0    0    1   NA   NA   NA   NA   NA
#> [4,]   NA   NA   NA  0.5  0.5  0.5   NA   NA
#> [5,]   NA   NA   NA  0.5  0.5  0.5   NA   NA
#> [6,]   NA   NA   NA  0.5  0.5  0.5   NA   NA
#> [7,]   NA   NA   NA   NA   NA   NA    1    0
#> [8,]   NA   NA   NA   NA   NA   NA    0    1
```
