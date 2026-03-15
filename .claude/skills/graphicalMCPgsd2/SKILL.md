---
name: graphicalMCPgsd2
description: >
  Guide users through group sequential design with graphical multiplicity control
  using the graphicalMCP and gsDesign2 R packages. Use this skill whenever the user
  asks about: group sequential designs with multiple hypotheses, graphical multiplicity
  testing, sequential p-values with gsDesign2, combining graphicalMCP with gsDesign2,
  clinical trial designs with multiple endpoints and populations, Maurer-Bretz procedures,
  alpha-spending with multiplicity graphs, or adapting the gMCPLite vignette template.
  Also trigger when users mention spending time, information fraction, or sequential
  p-values in the context of group sequential or graphical testing.
---

# Group Sequential Design with graphicalMCP + gsDesign2

This skill helps users design and analyze clinical trials that combine **graphical multiplicity control** (graphicalMCP) with **group sequential designs** (gsDesign2). The workflow follows the Maurer-Bretz (2013) framework.

## When to use this skill

- Setting up a multiplicity graph for multiple hypotheses (endpoints x populations)
- Designing group sequential bounds for each hypothesis using gsDesign2
- Computing sequential p-values from observed data
- Testing hypotheses using graphicalMCP with sequential p-values
- Verifying rejection decisions with updated group sequential bounds

## Required packages

```r
library(dplyr)
library(tibble)
library(gsDesign)
library(gsDesign2)
library(graphicalMCP)
```

gsDesign2 must export `sequential_pval()`. Install from GitHub if needed:
```r
remotes::install_github("Merck/gsDesign2")
```

## Workflow overview

The workflow has 4 phases:

### Phase 1: Design specification

1. **Define hypotheses** — typically endpoints (OS, PFS, ORR) crossed with populations (subgroup, overall).
2. **Build the multiplicity graph** — assign initial alpha weights and transition matrix using `graphicalMCP::graph_create()`.
3. **Choose a sample-size-driving hypothesis** (typically OS in the subgroup). Design it with `gsDesign2::gs_design_ahr()` targeting the desired power (e.g., 90%). Use `info_frac = NULL` and specify `analysis_time` as calendar months; gsDesign2 derives the information fraction from the enrollment/failure rate assumptions and analysis timing.
4. **Derive enrollment rates** from the driving hypothesis. The subgroup enrollment rate comes directly from the design output. The complement enrollment rate is scaled by prevalence: `rate_complement = rate_sub * (1 - prevalence) / prevalence`. Build stratified enrollment for overall population designs using `define_enroll_rate()` with stratum columns.
5. **Compute power for remaining hypotheses**:
   - Time-to-event hypotheses (OS, PFS) in the subgroup or overall: use `gsDesign2::gs_power_ahr()` with the derived enrollment rates. Pass `event = NULL` so `analysis_time` drives the design. For overall population, use stratified `fail_rate` with different HRs per stratum.
   - Binary endpoints (ORR): use `gsDesign2::fixed_design_rd()` with sample sizes derived from the driving hypothesis. These get `NULL` in the design list.
6. **Specify analysis timing rules** — document when each analysis is triggered (minimum follow-up after FPE, event count thresholds, maximum extensions).
7. **Store designs** in an ordered list matching the hypothesis order in the graph. Use `NULL` for non-GSD hypotheses.

### Phase 2: Results entry

1. **Record event counts** at each analysis for each hypothesis.
2. **Record nominal one-sided p-values** for each analysis of each hypothesis.
3. **Compute spending times** — typically `events / max(events)` using the subgroup information fraction. The spending time must reach 1 at the final analysis of each hypothesis.

### Phase 3: Hypothesis testing

1. **Compute sequential p-values** using `gsDesign2::sequential_pval()` for each group sequential hypothesis. For non-GSD hypotheses, the nominal p-value is the sequential p-value.
2. **Test with graphicalMCP** using `graphicalMCP::graph_test_shortcut()` with the sequential p-values and total FWER alpha.

### Phase 4: Verification

1. **Extract the graph update sequence** using `graphicalMCP::graph_update()` to see the multiplicity graph at each rejection step.
2. **Update group sequential bounds** at the maximum alpha allocated to each hypothesis using `gsDesign2::gs_update_ahr()`.
3. **Compare nominal p-values** to updated bounds to confirm rejection decisions.

## Key code patterns

For detailed code templates covering each phase, read `references/code_patterns.md`.

## Important design considerations

- **H1 drives sample size**: One hypothesis (typically OS in the subgroup) is designed with `gs_design_ahr()` to determine enrollment rates and sample sizes. All other hypotheses derive their enrollment from H1 using `gs_power_ahr()` (time-to-event) or `fixed_design_rd()` (binary).
- **Stratified overall designs**: Overall population designs use stratified `define_enroll_rate()` and `define_fail_rate()` with separate stratum rows (e.g., "BM+" and "BM-") and stratum-specific HRs or rates.
- **`gs_power_ahr()` API**: Does not accept `info_frac`. Use `event = NULL` with `analysis_time` to let timing drive the design. If `event` is not set to `NULL`, the default `c(30, 40, 50)` may cause length mismatches for designs with fewer analyses.
- **`fixed_design_rd()` output**: Returns a `fixed_design` object. Wrap with `summary()` before piping to `gt()` or `kable()`.
- **Zero initial alpha**: If a hypothesis starts with alpha=0 (receives alpha only through reallocation), use another hypothesis's alpha for the bounds structure in the design. The actual testing uses the reallocated alpha from the graph.
- **Spending time vs information fraction**: Spending time determines how alpha is allocated across analyses. Information fraction drives the correlation structure. Both are needed for bound computation.
- **Non-binding futility**: Use `binding = FALSE` so efficacy bounds are computed ignoring the futility bound, preserving Type I error control even if the trial continues past a futility crossing.
- **Time travel**: If OS hypotheses are rejected and alpha passes to previously-tested PFS hypotheses, those PFS tests can be re-evaluated with updated bounds. This controls Type I error per Liu & Anderson (2008).
- **One-sided testing**: Maurer-Bretz designs assume one-sided testing or non-binding futility bounds.
- **Alpha spending function**: Lan-DeMets spending approximating O'Brien-Fleming (`sfLDOF`) is a common default.
