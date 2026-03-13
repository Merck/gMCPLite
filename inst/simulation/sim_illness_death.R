# -- Internal helpers for marginal CDF computation --

# CDF of convolution of two independent exponentials Exp(a) + Exp(b)
.conv2_cdf <- function(t, a, b) {
  if (abs(a - b) < 1e-10) {
    # Erlang(2, a) case
    return(1 - exp(-a * t) * (1 + a * t))
  }
  1 - (b * exp(-a * t) - a * exp(-b * t)) / (b - a)
}

# CDF of convolution of three independent exponentials Exp(a) + Exp(b) + Exp(c)
.conv3_cdf <- function(t, a, b, c) {
  # Handle near-equal rates by adding small perturbation
  rates <- c(a, b, c)
  for (i in 2:3) {
    while (any(abs(rates[i] - rates[1:(i - 1)]) < 1e-10)) {
      rates[i] <- rates[i] * (1 + 1e-8)
    }
  }
  a <- rates[1]; b <- rates[2]; c <- rates[3]
  surv <- (b * c / ((a - b) * (a - c))) * exp(-a * t) +
    (a * c / ((b - a) * (b - c))) * exp(-b * t) +
    (a * b / ((c - a) * (c - b))) * exp(-c * t)
  1 - surv
}

# Marginal PFS CDF at time t given illness-death parameters
.pfs_cdf <- function(t, lambda_0, orr, lambda_1) {
  # PFS = T_0 for non-responders; T_0 + T_1 for responders
  # T_0 ~ Exp(lambda_0), T_1 ~ Exp(lambda_1)
  (1 - orr) * (1 - exp(-lambda_0 * t)) + orr * .conv2_cdf(t, lambda_0, lambda_1)
}

# Marginal OS CDF at time t given illness-death parameters
.os_cdf <- function(t, lambda_0, orr, lambda_1, lambda_death0,
                    lambda_prog0, lambda_death1, lambda_prog1, lambda_death2) {
  # 4 paths with weights
  p_death0 <- lambda_death0 / lambda_0
  p_prog0 <- lambda_prog0 / lambda_0
  p_resp_death1 <- orr * lambda_death1 / lambda_1
  p_resp_prog1 <- orr * lambda_prog1 / lambda_1

  cdf <- p_death0 * (1 - exp(-lambda_0 * t)) +
    p_prog0 * .conv2_cdf(t, lambda_0, lambda_death2) +
    p_resp_death1 * .conv2_cdf(t, lambda_0, lambda_1) +
    p_resp_prog1 * .conv3_cdf(t, lambda_0, lambda_1, lambda_death2)
  cdf
}


#' Build transition rate table from marginal clinical assumptions
#'
#' Creates a transition_rate data frame for use with \code{sim_illness_death()}
#' from clinically interpretable parameters. The illness-death model has states:
#' \itemize{
#'   \item State 0: Alive, no response, no progression
#'   \item State 1: Alive, responded, no progression
#'   \item State 2: Alive, progressed
#'   \item State 3: Dead (absorbing)
#' }
#'
#' Transition rates are numerically calibrated so that the marginal PFS and OS
#' medians for the control arm match the input assumptions. The ORR is exact
#' (it equals the probability that response fires before progression or death
#' in the competing risks at state 0). Experimental arm rates are derived by
#' scaling control rates with the specified hazard ratios, then re-calibrating
#' the response rate to match the experimental ORR.
#'
#' @param strata Character vector of stratum names.
#' @param treatments Character vector of length 2 (control first, experimental second).
#' @param median_pfs Named numeric vector of control median PFS by stratum (months).
#' @param median_os Named numeric vector of control median OS by stratum (months).
#' @param orr Named list by stratum; each element is a named numeric vector
#'   with ORR for each treatment, e.g., \code{c(control = 0.30, experimental = 0.45)}.
#' @param hr_pfs Named numeric vector of PFS hazard ratio (experimental/control) by stratum.
#' @param hr_os Named numeric vector of OS hazard ratio (experimental/control) by stratum.
#' @param death_wo_prog_rate Baseline rate of death without prior progression (default 0.02/month).
#' @param responder_prog_ratio Ratio of progression rate for responders vs non-responders
#'   in the same treatment group (default 0.5, i.e., responders progress half as fast).
#'
#' @return A data frame with columns: \code{stratum}, \code{treatment},
#'   \code{transition}, \code{rate}, \code{duration}. Transition names are:
#'   \code{"response"} (0->1), \code{"prog_0"} (0->2), \code{"death_0"} (0->3),
#'   \code{"prog_1"} (1->2), \code{"death_1"} (1->3), \code{"death_2"} (2->3).
#'
#' @importFrom stats uniroot
#'
#' @examples
#' tr <- build_transition_rates(
#'   strata = c("BM+", "BM-"),
#'   treatments = c("control", "experimental"),
#'   median_pfs = c("BM+" = 5, "BM-" = 5),
#'   median_os = c("BM+" = 12, "BM-" = 12),
#'   orr = list("BM+" = c(control = 0.30, experimental = 0.45),
#'              "BM-" = c(control = 0.20, experimental = 0.24)),
#'   hr_pfs = c("BM+" = 0.70, "BM-" = 0.90),
#'   hr_os = c("BM+" = 0.65, "BM-" = 0.85)
#' )
#'
#' @export
build_transition_rates <- function(
    strata,
    treatments = c("control", "experimental"),
    median_pfs,
    median_os,
    orr,
    hr_pfs,
    hr_os,
    death_wo_prog_rate = 0.02,
    responder_prog_ratio = 0.5) {
  rows <- list()

  for (s in strata) {
    ctrl <- treatments[1]
    ctrl_orr <- orr[[s]][[ctrl]]
    lambda_death0 <- death_wo_prog_rate
    lambda_death1 <- lambda_death0 * 0.5

    # --- Calibrate control arm lambda_0 for PFS median ---
    pfs_obj <- function(lambda_0) {
      lambda_resp <- ctrl_orr * lambda_0
      lambda_prog0 <- lambda_0 - lambda_resp - lambda_death0
      if (lambda_prog0 <= 0) return(10)
      lambda_prog1 <- lambda_prog0 * responder_prog_ratio
      lambda_1 <- lambda_prog1 + lambda_death1
      .pfs_cdf(median_pfs[[s]], lambda_0, ctrl_orr, lambda_1) - 0.5
    }

    lambda_0_ctrl <- tryCatch(
      uniroot(pfs_obj, interval = c(lambda_death0 + 0.01, 10), tol = 1e-8)$root,
      error = function(e) log(2) / median_pfs[[s]]  # fallback
    )

    lambda_resp_ctrl <- ctrl_orr * lambda_0_ctrl
    lambda_prog0_ctrl <- max(lambda_0_ctrl - lambda_resp_ctrl - lambda_death0, 0.005)
    lambda_prog1_ctrl <- lambda_prog0_ctrl * responder_prog_ratio
    lambda_1_ctrl <- lambda_prog1_ctrl + lambda_death1

    # --- Calibrate control arm lambda_death2 for OS median ---
    os_obj <- function(lambda_death2) {
      .os_cdf(median_os[[s]], lambda_0_ctrl, ctrl_orr, lambda_1_ctrl,
              lambda_death0, lambda_prog0_ctrl, lambda_death1,
              lambda_prog1_ctrl, lambda_death2) - 0.5
    }

    lambda_death2_ctrl <- tryCatch(
      uniroot(os_obj, interval = c(0.001, 10), tol = 1e-8)$root,
      error = function(e) log(2) / max(median_os[[s]] - median_pfs[[s]], 1)
    )

    # --- Experimental arm ---
    exp_trt <- treatments[2]
    exp_orr <- orr[[s]][[exp_trt]]
    pfs_hr <- hr_pfs[[s]]
    os_hr <- hr_os[[s]]

    # Scale progression and death rates by HRs
    lambda_prog0_exp <- lambda_prog0_ctrl * pfs_hr
    lambda_death0_exp <- lambda_death0 * os_hr
    lambda_death1_exp <- lambda_death1 * os_hr

    # Solve for response rate to achieve target ORR
    non_resp_rate_exp <- lambda_prog0_exp + lambda_death0_exp
    lambda_resp_exp <- exp_orr * non_resp_rate_exp / (1 - exp_orr)

    lambda_prog1_exp <- lambda_prog1_ctrl * pfs_hr
    lambda_death2_exp <- lambda_death2_ctrl * os_hr

    # Assemble rows (single period = constant rate)
    for (info in list(
      list(trt = ctrl,
           resp = lambda_resp_ctrl, prog0 = lambda_prog0_ctrl,
           death0 = lambda_death0, prog1 = lambda_prog1_ctrl,
           death1 = lambda_death1, death2 = lambda_death2_ctrl),
      list(trt = exp_trt,
           resp = lambda_resp_exp, prog0 = lambda_prog0_exp,
           death0 = lambda_death0_exp, prog1 = lambda_prog1_exp,
           death1 = lambda_death1_exp, death2 = lambda_death2_exp)
    )) {
      transitions <- c("response", "prog_0", "death_0",
                        "prog_1", "death_1", "death_2")
      rates <- c(info$resp, info$prog0, info$death0,
                 info$prog1, info$death1, info$death2)
      for (k in seq_along(transitions)) {
        rows[[length(rows) + 1]] <- data.frame(
          stratum = s,
          treatment = info$trt,
          transition = transitions[k],
          rate = rates[k],
          duration = Inf,
          stringsAsFactors = FALSE
        )
      }
    }
  }

  do.call(rbind, rows)
}


#' Simulate a clinical trial using an illness-death model with response
#'
#' Simulates enrollment, randomization, and multi-state outcomes for a
#' two-arm clinical trial. The illness-death model has four states:
#' alive without response or progression (0), responded without progression (1),
#' progressed (2), and dead (3). Derived endpoints include OS, PFS, ORR, and TTR.
#'
#' Piecewise exponential distributions (via \code{simtrial::rpwexp()}) are used
#' for all state transition times, allowing flexible hazard patterns.
#'
#' @param n Total number of patients (both arms combined).
#' @param stratum Data frame with columns \code{stratum} and \code{p} (prevalence).
#' @param block Character vector defining fixed randomization blocks.
#' @param enroll_rate Data frame with \code{rate} and \code{duration} columns
#'   for enrollment (passed to \code{simtrial::rpwexp_enroll()}).
#' @param transition_rate Data frame with columns \code{stratum}, \code{treatment},
#'   \code{transition}, \code{rate}, \code{duration}. Multiple rows per
#'   (stratum, treatment, transition) combination define piecewise rates.
#'   Transition names: \code{"response"} (0->1), \code{"prog_0"} (0->2),
#'   \code{"death_0"} (0->3), \code{"prog_1"} (1->2), \code{"death_1"} (1->3),
#'   \code{"death_2"} (2->3).
#' @param dropout_rate Constant dropout rate per month (default 0.001).
#'
#' @return A data frame with one row per patient and columns:
#'   \code{USUBJID}, \code{STRATUM}, \code{TRT}, \code{ENRLTIME},
#'   \code{OS_TIME}, \code{PFS_TIME}, \code{TTR}, \code{ORR},
#'   \code{DROPOUT_TIME}, \code{CTE_OS}, \code{CTE_PFS}.
#'
#' @importFrom simtrial rpwexp rpwexp_enroll randomize_by_fixed_block
#' @importFrom stats rexp
#'
#' @examples
#' library(simtrial)
#' tr <- build_transition_rates(
#'   strata = c("BM+", "BM-"),
#'   treatments = c("control", "experimental"),
#'   median_pfs = c("BM+" = 5, "BM-" = 5),
#'   median_os = c("BM+" = 12, "BM-" = 12),
#'   orr = list("BM+" = c(control = 0.30, experimental = 0.45),
#'              "BM-" = c(control = 0.20, experimental = 0.24)),
#'   hr_pfs = c("BM+" = 0.70, "BM-" = 0.90),
#'   hr_os = c("BM+" = 0.65, "BM-" = 0.85)
#' )
#' sim <- sim_illness_death(n = 100, transition_rate = tr)
#'
#' @export
sim_illness_death <- function(
    n = 400,
    stratum = data.frame(stratum = "All", p = 1),
    block = c("control", "control", "experimental", "experimental"),
    enroll_rate = data.frame(rate = 9, duration = 1),
    transition_rate,
    dropout_rate = 0.001) {
  # Enrollment times
  enroll_time <- simtrial::rpwexp_enroll(n = n, enroll_rate = enroll_rate)

  # Stratum assignment
  strat <- sample(
    stratum$stratum,
    size = n,
    replace = TRUE,
    prob = stratum$p
  )

  # Randomization
  trt <- simtrial::randomize_by_fixed_block(n = n, block = block)

  # Helper: draw piecewise exponential times for a specific transition
  draw_pwexp <- function(n_draw, strat_val, trt_val, trans_name) {
    rates <- transition_rate[
      transition_rate$stratum == strat_val &
        transition_rate$treatment == trt_val &
        transition_rate$transition == trans_name, , drop = FALSE
    ]
    if (nrow(rates) == 0) return(rep(Inf, n_draw))
    simtrial::rpwexp(
      n = n_draw,
      fail_rate = data.frame(rate = rates$rate, duration = rates$duration)
    )
  }

  # Initialize result vectors
  os_time <- numeric(n)
  pfs_time <- numeric(n)
  ttr <- rep(Inf, n)
  response <- logical(n)

  # Simulate per stratum x treatment combination
  for (s in unique(strat)) {
    for (tr in unique(trt)) {
      idx <- which(strat == s & trt == tr)
      ni <- length(idx)
      if (ni == 0) next

      # State 0: draw competing risks
      t_resp <- draw_pwexp(ni, s, tr, "response")
      t_prog0 <- draw_pwexp(ni, s, tr, "prog_0")
      t_death0 <- draw_pwexp(ni, s, tr, "death_0")

      # Determine which transition fires first
      t_exit0 <- pmin(t_resp, t_prog0, t_death0)
      exit_to <- ifelse(
        t_resp <= t_prog0 & t_resp <= t_death0, 1L,
        ifelse(t_prog0 <= t_death0, 2L, 3L)
      )

      # Initialize per-group results
      pfs_g <- numeric(ni)
      os_g <- numeric(ni)
      ttr_g <- rep(Inf, ni)
      resp_g <- logical(ni)

      # -- Path 0 -> 3: death without progression --
      death0_idx <- which(exit_to == 3L)
      if (length(death0_idx) > 0) {
        pfs_g[death0_idx] <- t_exit0[death0_idx]
        os_g[death0_idx] <- t_exit0[death0_idx]
      }

      # -- Path 0 -> 2 -> 3: progression then death --
      prog0_idx <- which(exit_to == 2L)
      if (length(prog0_idx) > 0) {
        t_death2_a <- draw_pwexp(length(prog0_idx), s, tr, "death_2")
        pfs_g[prog0_idx] <- t_exit0[prog0_idx]
        os_g[prog0_idx] <- t_exit0[prog0_idx] + t_death2_a
      }

      # -- Paths through state 1 (response) --
      resp_idx <- which(exit_to == 1L)
      if (length(resp_idx) > 0) {
        resp_g[resp_idx] <- TRUE
        ttr_g[resp_idx] <- t_exit0[resp_idx]

        # State 1: competing risks (progression vs death)
        t_prog1 <- draw_pwexp(length(resp_idx), s, tr, "prog_1")
        t_death1 <- draw_pwexp(length(resp_idx), s, tr, "death_1")
        t_exit1 <- pmin(t_prog1, t_death1)
        exit1_to <- ifelse(t_prog1 <= t_death1, 2L, 3L)

        # PFS for all responders = time in state 0 + time in state 1
        pfs_g[resp_idx] <- t_exit0[resp_idx] + t_exit1

        # Path 0 -> 1 -> 3: death without progression after response
        death1_sub <- which(exit1_to == 3L)
        if (length(death1_sub) > 0) {
          os_g[resp_idx[death1_sub]] <-
            t_exit0[resp_idx[death1_sub]] + t_exit1[death1_sub]
        }

        # Path 0 -> 1 -> 2 -> 3: progression after response, then death
        prog1_sub <- which(exit1_to == 2L)
        if (length(prog1_sub) > 0) {
          t_death2_b <- draw_pwexp(length(prog1_sub), s, tr, "death_2")
          os_g[resp_idx[prog1_sub]] <-
            t_exit0[resp_idx[prog1_sub]] + t_exit1[prog1_sub] + t_death2_b
        }
      }

      # Store results
      os_time[idx] <- os_g
      pfs_time[idx] <- pfs_g
      ttr[idx] <- ttr_g
      response[idx] <- resp_g
    }
  }

  # Dropout (exponential, independent of disease process)
  t_dropout <- rexp(n, rate = dropout_rate)

  data.frame(
    USUBJID = seq_len(n),
    STRATUM = strat,
    TRT = trt,
    ENRLTIME = enroll_time,
    OS_TIME = os_time,
    PFS_TIME = pfs_time,
    TTR = ttr,
    ORR = as.integer(response),
    DROPOUT_TIME = t_dropout,
    CTE_OS = enroll_time + pmin(os_time, t_dropout),
    CTE_PFS = enroll_time + pmin(pfs_time, t_dropout),
    stringsAsFactors = FALSE
  )
}
