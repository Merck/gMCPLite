# Permutation for a design matrix

Permutation for a design matrix

## Usage

``` r
permutations(n)
```

## Arguments

- n:

  dimension of the matrix

## Value

a n\*(2^n) dimensional matrix

## Examples

``` r
permutations(3)
#>      [,1] [,2] [,3]
#> [1,]    0    0    0
#> [2,]    0    0    1
#> [3,]    0    1    0
#> [4,]    0    1    1
#> [5,]    1    0    0
#> [6,]    1    0    1
#> [7,]    1    1    0
#> [8,]    1    1    1
```
