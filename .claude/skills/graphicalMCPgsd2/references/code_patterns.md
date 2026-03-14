# Code Patterns for graphicalMCP + gsDesign2

## Table of Contents
1. [Multiplicity graph setup](#multiplicity-graph-setup)
2. [Sample-size-driving design (H1)](#sample-size-driving-design)
3. [Deriving enrollment from H1](#deriving-enrollment)
4. [Power for remaining hypotheses](#power-remaining)
5. [Results entry template](#results-entry)
6. [Sequential p-value computation](#sequential-p-values)
7. [Hypothesis testing with graphicalMCP](#hypothesis-testing)
8. [Verification with updated bounds](#verification)

---

## Multiplicity graph setup {#multiplicity-graph-setup}

Define hypotheses, alpha allocation, and transition matrix:

```r
# Hypothesis names (endpoints x populations)
nameHypotheses <- c(
  "H1: OS\n Subgroup",
  "H2: OS\n All subjects",
  "H3: PFS\n Subgroup",
  "H4: PFS\n All subjects",
  "H5: ORR\n Subgroup",
  "H6: ORR\n All subjects"
)
nHypotheses <- length(nameHypotheses)

# Transition matrix (row i -> col j reallocation weights)
m <- matrix(c(
  0, 1, 0, 0, 0, 0,
  0, 0, .5, .5, 0, 0,
  0, 0, 0, 1, 0, 0,
  0, 0, 0, 0, .5, .5,
  0, 0, 0, 0, 0, 1,
  .5, .5, 0, 0, 0, 0
), nrow = 6, byrow = TRUE)

# Initial alpha allocation (one-sided)
alphaHypotheses <- c(.01, .01, .004, 0.000, 0.0005, .0005)
fwer <- sum(alphaHypotheses)

# Create graph (weights must sum to 1, so divide by fwer)
g0 <- graphicalMCP::graph_create(
  hypotheses = stats::setNames(alphaHypotheses / fwer, nameHypotheses),
  transitions = m,
  hyp_names = nameHypotheses
)

# Plot with alpha levels on vertices (using α character)
alphaLabels <- sprintf("\u03b1 = %s", format(alphaHypotheses, scientific = FALSE))
vertexLabels <- paste(nameHypotheses, alphaLabels, sep = "\n")

plot(g0,
  layout = layout6,
  vertex.size = 45,
  vertex.label = vertexLabels,
  vertex.label.cex = 0.9,
  vertex.color = vertex_colors,
  margin = 0.25
)
```

## Sample-size-driving design (H1) {#sample-size-driving-design}

One hypothesis drives sample size — typically OS in the subgroup, designed with
`gs_design_ahr()` targeting the desired power. Use `info_frac = NULL` and specify
`analysis_time` as calendar months from enrollment start. gsDesign2 derives the
information fraction from the enrollment/failure rate assumptions and analysis timing.

```r
fail_rate_os_sub <- gsDesign2::define_fail_rate(
  duration = Inf,
  fail_rate = log(2) / osmedian,
  hr = 0.65,
  dropout_rate = 0.001
)

# Initial enrollment rate with ramp-up (gs_design_ahr will scale)
enroll_rate_sub_init <- gsDesign2::define_enroll_rate(
  duration = c(2, 2, 2, 8),
  rate = c(0.25, 0.50, 0.75, 1.00)  # Relative rates
)

ossub <- gsDesign2::gs_design_ahr(
  enroll_rate = enroll_rate_sub_init,
  fail_rate = fail_rate_os_sub,
  alpha = alphaHypotheses[1],
  beta = 0.1,
  binding = FALSE,
  analysis_time = c(20, 28, 38),   # Calendar months from enrollment start
  info_frac = NULL,                  # Derived from analysis_time + enroll/fail rates
  info_scale = "h0_info",
  upper = gsDesign2::gs_spending_bound,
  upar = list(sf = gsDesign::sfLDOF, total_spend = alphaHypotheses[1]),
  test_lower = FALSE
)
```

### Analysis timing rules

Analysis timing should be pre-specified with rules relative to final patient enrolled (FPE):

| Analysis | Timing rule (after FPE) | Max extension | Endpoints assessed |
|----------|------------------------|---------------|-------------------|
| IA1 | 6 months after FPE | None | ORR (final), PFS and OS (interim) |
| IA2 | 14 months after FPE AND targeted PFS events in subgroup | +3 months | PFS (final), OS (interim) |
| Final | 24 months after FPE AND targeted OS events in subgroup | +6 months | OS (final) |

These rules ensure adequate follow-up for each endpoint while providing flexibility
for event-driven timing. The `analysis_time` values in `gs_design_ahr()` should reflect
enrollment duration + follow-up (e.g., 14 months enrollment + 6 months = 20 months).

## Deriving enrollment from H1 {#deriving-enrollment}

The driving hypothesis determines enrollment rates and sample sizes for all other designs.

```r
# Extract subgroup enrollment rate from H1 design
enroll_rate_sub <- ossub$enroll_rate
n_sub <- sum(enroll_rate_sub$rate * enroll_rate_sub$duration)
n_complement <- n_sub * (1 - prevalence) / prevalence
n_total <- n_sub + n_complement

# Build stratified enrollment for overall population designs
enroll_rate_overall <- gsDesign2::define_enroll_rate(
  stratum = rep(c("BM+", "BM-"), each = nrow(enroll_rate_sub)),
  duration = rep(enroll_rate_sub$duration, 2),
  rate = c(
    enroll_rate_sub$rate,                                    # Subgroup rates from H1
    enroll_rate_sub$rate * (1 - prevalence) / prevalence     # Complement rates
  )
)
```

## Power for remaining hypotheses {#power-remaining}

### Time-to-event in subgroup — `gs_power_ahr()`

```r
pfssub <- gsDesign2::gs_power_ahr(
  enroll_rate = enroll_rate_sub,
  fail_rate = fail_rate_pfs_sub,
  ratio = 1,
  event = NULL,                    # IMPORTANT: must be NULL to use analysis_time
  analysis_time = c(20, 28),       # 2 analyses for PFS
  info_scale = "h0_info",
  upper = gsDesign2::gs_spending_bound,
  upar = list(sf = gsDesign::sfLDOF, total_spend = alphaHypotheses[3]),
  test_lower = FALSE,
  binding = FALSE
)
```

### Time-to-event in overall population — stratified `gs_power_ahr()`

Use stratified `define_fail_rate()` with different HRs per stratum:

```r
fail_rate_os_overall <- gsDesign2::define_fail_rate(
  stratum = c("BM+", "BM-"),
  duration = c(Inf, Inf),
  fail_rate = log(2) / osmedian,
  hr = c(0.65, 0.85),
  dropout_rate = 0.001
)

os <- gsDesign2::gs_power_ahr(
  enroll_rate = enroll_rate_overall,
  fail_rate = fail_rate_os_overall,
  ratio = 1,
  event = NULL,
  analysis_time = c(20, 28, 38),
  info_scale = "h0_info",
  upper = gsDesign2::gs_spending_bound,
  upar = list(sf = gsDesign::sfLDOF, total_spend = alphaHypotheses[2]),
  test_lower = FALSE,
  binding = FALSE
)
```

### Zero initial alpha workaround

If a hypothesis starts with alpha=0 (e.g., H4: PFS Overall), the spending function
will error. Use another hypothesis's alpha for the bounds structure:

```r
# H4 starts with alpha=0; use H3's alpha for bounds structure
pfs <- gsDesign2::gs_power_ahr(
  enroll_rate = enroll_rate_overall,
  fail_rate = fail_rate_pfs_overall,
  ratio = 1,
  event = NULL,
  analysis_time = c(20, 28),
  info_scale = "h0_info",
  upper = gsDesign2::gs_spending_bound,
  upar = list(sf = gsDesign::sfLDOF, total_spend = alphaHypotheses[3]),  # H3's alpha
  test_lower = FALSE,
  binding = FALSE
)
```

### Binary endpoint — `fixed_design_rd()`

For rate difference tests (e.g., ORR), use `fixed_design_rd()` with sample sizes
from H1. Wrap with `summary()` before piping to `gt()`.

```r
# Subgroup
orr_sub <- gsDesign2::fixed_design_rd(
  alpha = alphaHypotheses[5],
  power = NULL,
  p_c = 0.30,
  p_e = 0.45,
  rd0 = 0,
  n = ceiling(n_sub) * 2  # Total N (both arms)
)
summary(orr_sub) %>%
  gt::gt() %>%
  gt::fmt_number(columns = "Bound", decimals = 2) %>%
  gt::fmt_number(columns = "Power", decimals = 3)

# Overall (weighted average rates across strata)
orr_ctrl_overall <- orr_ctrl_sub * prevalence + orr_ctrl_complement * (1 - prevalence)
orr_exp_overall <- orr_exp_sub * prevalence + orr_exp_complement * (1 - prevalence)

orr_all <- gsDesign2::fixed_design_rd(
  alpha = alphaHypotheses[6],
  power = NULL,
  p_c = orr_ctrl_overall,
  p_e = orr_exp_overall,
  rd0 = 0,
  n = ceiling(n_total) * 2
)
summary(orr_all) %>%
  gt::gt() %>%
  gt::fmt_number(columns = "Bound", decimals = 2) %>%
  gt::fmt_number(columns = "Power", decimals = 3)
```

### Design list (ordered to match graph hypotheses)

```r
# NULL for non-GSD hypotheses (e.g., ORR tested at a single analysis)
gsD2list <- list(ossub, os, pfssub, pfs, NULL, NULL)
```

## Results entry template {#results-entry}

For calendar-time-based interim timing (common interim dates across endpoints), see [analysis_timing.md](analysis_timing.md).

```r
# Event counts per hypothesis per analysis
events_pfs_all <- c(675, 750)
events_pfs_sub <- c(265, 310)
events_os_all <- c(529, 700, 800)
events_os_sub <- c(185, 245, 295)

inputResults <- tibble(
  H = c(rep(1, 3), rep(2, 3), rep(3, 2), rep(4, 2), 5, 6),
  Pop = c(rep("Subgroup", 3), rep("All", 3),
          rep("Subgroup", 2), rep("All", 2),
          "Subgroup", "All"),
  Endpoint = c(rep("OS", 6), rep("PFS", 4), rep("ORR", 2)),
  nominalP = c(
    .03, .0001, .000001,   # H1: OS Subgroup (3 analyses)
    .2, .15, .1,            # H2: OS All (3 analyses)
    .2, .001,               # H3: PFS Subgroup (2 analyses)
    .3, .2,                 # H4: PFS All (2 analyses)
    .00001,                 # H5: ORR Subgroup (1 analysis)
    .1                      # H6: ORR All (1 analysis)
  ),
  Analysis = c(1:3, 1:3, 1:2, 1:2, 1, 1),
  events = c(events_os_sub, events_os_all,
             events_pfs_sub, events_pfs_all, NA, NA),
  # Spending time: subgroup info fraction for all hypotheses
  spendingTime = c(
    events_os_sub / max(events_os_sub),
    events_os_sub / max(events_os_sub),
    events_pfs_sub / max(events_pfs_sub),
    events_pfs_sub / max(events_pfs_sub),
    NA, NA
  )
)
```

## Sequential p-value computation {#sequential-p-values}

```r
EOCtab <- inputResults %>%
  group_by(H) %>%
  slice(1) %>%
  ungroup() %>%
  select("H", "Pop", "Endpoint", "nominalP")
EOCtab$seqp <- .9999

for (EOCtabline in 1:nHypotheses) {
  EOCtab$seqp[EOCtabline] <-
    ifelse(is.null(gsD2list[[EOCtabline]]),
      EOCtab$nominalP[EOCtabline],
      {
        tem <- filter(inputResults, H == EOCtabline)
        gsDesign2::sequential_pval(
          gs_design = gsD2list[[EOCtabline]],
          event = tem$events,
          z = -stats::qnorm(tem$nominalP),
          ustime = tem$spendingTime,
          interval = c(1e-05, 0.9999)
        )
      }
    )
}
EOCtab <- EOCtab %>% select(-"nominalP")
```

## Hypothesis testing with graphicalMCP {#hypothesis-testing}

```r
result <- graphicalMCP::graph_test_shortcut(
  graph = g0,
  p = EOCtab$seqp,
  alpha = fwer,
  verbose = TRUE
)

adj_p <- result$outputs$adjusted_p
rej <- result$outputs$rejected

# Convert to logical if needed
if (is.numeric(rej)) {
  rej_logical <- rep(FALSE, nHypotheses)
  rej_logical[rej] <- TRUE
} else {
  rej_logical <- as.logical(rej)
}

EOCtab$Rejected <- rej_logical
EOCtab$adjPValues <- adj_p
```

## Verification with updated bounds {#verification}

### Extract graph update sequence

```r
rejected_order <- which(EOCtab$Rejected)[order(EOCtab$adjPValues[EOCtab$Rejected])]

graphs <- list(g0)
if (length(rejected_order) > 0) {
  gu <- graphicalMCP::graph_update(g0, delete = rejected_order)
  graphs <- gu$intermediate_graphs
}

# Get max alpha allocated to each hypothesis
lastWeights <- as.numeric(graphs[[length(graphs)]]$hypotheses)
for (j in seq_along(rejected_order)) {
  h <- rejected_order[j]
  lastWeights[h] <- as.numeric(graphs[[j]]$hypotheses[h])
}
EOCtab$lastAlpha <- fwer * lastWeights
```

### Plot graph sequence with alpha labels

When plotting the graph update sequence, show actual alpha levels (not weights) on each vertex:

```r
for (i in seq_along(graphs)) {
  gi_alpha <- fwer * as.numeric(graphs[[i]]$hypotheses)
  gi_labels <- paste(
    names(graphs[[i]]$hypotheses),
    sprintf("\u03b1 = %s", format(gi_alpha, scientific = FALSE)),
    sep = "\n"
  )
  plot(graphs[[i]],
    layout = layout6,
    vertex.size = 45,
    vertex.label = gi_labels,
    vertex.label.cex = 0.9,
    vertex.color = vertex_colors,
    margin = 0.25
  )
}
```

### Update bounds for verification

```r
for (i in 1:nHypotheses) {
  hresults <- inputResults %>% filter(H == i)
  d2 <- gsD2list[[i]]

  if (!is.null(d2) && EOCtab$lastAlpha[i] > 0) {
    d2_upd <- gsDesign2::gs_update_ahr(
      x = d2,
      alpha = EOCtab$lastAlpha[i],
      ustime = hresults$spendingTime,
      event_tbl = data.frame(
        analysis = hresults$Analysis,
        event = hresults$events
      )
    )
    # Compare nominal p-values to updated bounds
    # Rejected: at least one nominal p <= bound nominal p
    # Not rejected: all nominal p > bound nominal p
  }
}
```

## P-value computation {#p-value-computation}

### 1-sided logrank test (OS, PFS)

```r
logrank_pval <- function(data, stratified = FALSE) {
  data$event <- 1L - data$CNSR
  if (stratified) {
    fit <- survdiff(Surv(AVAL, event) ~ TRT + strata(STRATUM), data = data)
  } else {
    fit <- survdiff(Surv(AVAL, event) ~ TRT, data = data)
  }
  # IMPORTANT: with strata, obs/exp are matrices (groups x strata); sum across strata
  obs_ctrl <- if (is.matrix(fit$obs)) sum(fit$obs[1, ]) else fit$obs[1]
  exp_ctrl <- if (is.matrix(fit$exp)) sum(fit$exp[1, ]) else fit$exp[1]
  z_sign <- sign(obs_ctrl - exp_ctrl)
  z <- z_sign * sqrt(fit$chisq)
  pnorm(-z)  # 1-sided: small when experimental is better
}
```

**Key pitfall**: `survdiff()` with `strata()` returns `obs` and `exp` as a **matrix**
(treatment groups × strata). Using `fit$obs[1]` extracts just the first stratum for the
control group, giving wrong results. Always check `is.matrix()` and sum across strata.

### Stratified risk difference test (ORR)

```r
rd_pval <- function(data, stratified = FALSE) {
  if (!stratified) {
    # Pooled test (unstratified)
    ...
    z <- (p_exp - p_ctrl) / se
    return(pnorm(-z))
  }
  # Stratified: combine stratum-specific RDs with sample size weights
  strata <- unique(data$STRATUM)
  for (k in seq_along(strata)) {
    # Compute rd_s[k], var_s[k], n_s[k] per stratum
  }
  w <- n_s / sum(n_s)  # sample size weights
  rd_combined <- sum(w * rd_s)
  se_combined <- sqrt(sum(w^2 * var_s))
  z <- rd_combined / se_combined
  pnorm(-z)  # 1-sided: small when experimental is better
}
```

## Theoretical survival curves {#theoretical-curves}

The illness-death model's internal CDF helpers (`.pfs_cdf()`, `.os_cdf()`) can compute
marginal PFS and OS survival curves from the transition rates without simulation.
Use this to visualize assumed treatment effects during the design phase.

```r
# Extract rates for a stratum/treatment from the transition_rate table
get_theoretical_surv <- function(transition_rate, stratum_val, trt_val, t_grid) {
  tr <- transition_rate[transition_rate$stratum == stratum_val &
                          transition_rate$treatment == trt_val, ]
  get_rate <- function(trans) tr$rate[tr$transition == trans]

  lambda_resp <- get_rate("response")
  lambda_prog0 <- get_rate("prog_0")
  lambda_death0 <- get_rate("death_0")
  lambda_prog1 <- get_rate("prog_1")
  lambda_death1 <- get_rate("death_1")
  lambda_death2 <- get_rate("death_2")

  lambda_0 <- lambda_resp + lambda_prog0 + lambda_death0
  orr_param <- lambda_resp / lambda_0
  lambda_1 <- lambda_prog1 + lambda_death1

  pfs_surv <- 1 - sapply(t_grid, function(t)
    .pfs_cdf(t, lambda_0, orr_param, lambda_1))
  os_surv <- 1 - sapply(t_grid, function(t)
    .os_cdf(t, lambda_0, orr_param, lambda_1,
            lambda_death0, lambda_prog0, lambda_death1,
            lambda_prog1, lambda_death2))

  tibble(time = rep(t_grid, 2), surv = c(pfs_surv, os_surv),
         endpoint = rep(c("PFS", "OS"), each = length(t_grid)),
         stratum = stratum_val, treatment = trt_val)
}

# Limit t_grid to trial duration (final analysis time)
t_grid <- seq(0, 38, by = 0.25)

# By-stratum curves (BM+ and BM-)
stratum_curves <- bind_rows(
  get_theoretical_surv(transition_rate, "BM+", "control", t_grid),
  get_theoretical_surv(transition_rate, "BM+", "experimental", t_grid),
  get_theoretical_surv(transition_rate, "BM-", "control", t_grid),
  get_theoretical_surv(transition_rate, "BM-", "experimental", t_grid)
) %>% mutate(population = "By stratum")

# Overall population: prevalence-weighted mixture of BM+ and BM-
bm_pos_curves <- bind_rows(
  get_theoretical_surv(transition_rate, "BM+", "control", t_grid),
  get_theoretical_surv(transition_rate, "BM+", "experimental", t_grid)
)
bm_neg_curves <- bind_rows(
  get_theoretical_surv(transition_rate, "BM-", "control", t_grid),
  get_theoretical_surv(transition_rate, "BM-", "experimental", t_grid)
)
overall_curves <- bm_pos_curves %>%
  select(time, endpoint, treatment, surv_pos = surv) %>%
  left_join(
    bm_neg_curves %>% select(time, endpoint, treatment, surv_neg = surv),
    by = c("time", "endpoint", "treatment")
  ) %>%
  mutate(surv = bm_prev * surv_pos + (1 - bm_prev) * surv_neg,
         stratum = "Overall", population = "Overall") %>%
  select(time, surv, endpoint, stratum, treatment, population)

theor_curves <- bind_rows(stratum_curves, overall_curves)

# 2x2 layout: facet_grid(population ~ endpoint)
# Top row: by stratum (BM+ solid, BM- dashed)
# Bottom row: overall population
ggplot(theor_curves, aes(x = time, y = surv,
                          color = treatment, linetype = stratum)) +
  geom_line(linewidth = 0.8) +
  facet_grid(population ~ endpoint)
```

## Kaplan-Meier plots {#km-plots}

KM plots should include:
- X-axis grid every 6 months, y-axis grid every 20%
- HR with 95% CI and 1-sided logrank p-value in upper right corner
- Number at risk table below the plot at month 0 and every 6 months

Use `gridExtra::grid.arrange()` to stack the KM plot and at-risk table.

## WPGSD analysis {#wpgsd}

The wpgsd package accounts for group sequential and population-induced correlations.

### Correlation matrix construction

For nested populations (BM+ ⊂ Overall), the event-count matrix D has entries:
- D[Hi_As, Hi_At] = events_i at min(s,t)  (within-hypothesis, across-analysis)
- D[Hi_As, Hj_At] = intersection events at min(s,t)  (cross-hypothesis)
- Intersection for nested populations = subgroup events at min(s,t)

**Bug in `generate_corr()` for k > 2**: The function incorrectly computes
within-hypothesis cross-analysis entries for non-adjacent analyses. Use
`generate_corr()` only for k = 2. For k > 2, build D manually and compute
`corr = diag(1/sqrt(diag(D))) %*% D %*% diag(1/sqrt(diag(D)))`.

### generate_bounds and closed_test

```r
# Sub-graph: 2 hypotheses with full reallocation
m_sub <- matrix(c(0, 1, 1, 0), nrow = 2, byrow = TRUE)
w <- c(0.5, 0.5)  # weights must be > 0 (gsDesign requires alpha > 0)

bound_wpgsd <- wpgsd::generate_bounds(
  type = 3, k = n_analyses, w = w, m = m_sub, corr = corr,
  alpha = total_alpha_for_endpoint,
  sf = list(gsDesign::sfLDOF, gsDesign::sfLDOF),
  sfparm = list(0, 0),
  t = list(info_frac_h1, info_frac_h2)
)

ct <- wpgsd::closed_test(bound_wpgsd, p_obs)
```
