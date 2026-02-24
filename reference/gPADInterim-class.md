# Class gPADInterim

A gPADInterim object describes an object holding interim information for
an adaptive procedure that is based on a preplanned graphical procedure.

## Slots

- `Aj`:

  Object of class `numeric`. Giving partial conditional errors (PCEs)
  for all elementary hypotheses in each intersection hypothesis

- `BJ`:

  A `numeric` specifying the sum of PCEs per intersection hypothesis.

- `z1`:

  The `numeric` vector of first stage z-scores.

- `v`:

  A `numeric` specifying the proportion of measurements collected up to
  interim

- `preplanned`:

  Object of class
  [`graphMCP`](https://merck.github.io/gMCPLite/reference/graphMCP-class.md)
  specifying the preplanned graphical procedure.

- `alpha`:

  A `numeric` giving the alpha level of the pre-planned test

## See also

[`gMCP`](https://merck.github.io/gMCPLite/reference/gMCP.md)

## Author

Florian Klinglmueller <float@lefant.net>
