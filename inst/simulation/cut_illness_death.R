#' Determine analysis cut dates from timing rules
#'
#' Computes the calendar cut date for each planned analysis based on
#' minimum follow-up, event-driven triggers, and maximum extensions.
#'
#' @param sim_data Patient-level data frame from \code{sim_illness_death()}.
#' @param analyses A list of analysis specifications. Each element is a list with:
#'   \describe{
#'     \item{min_followup}{Minimum time after final patient enrolled (FPE) in months.}
#'     \item{endpoint}{Endpoint for event-driven timing: \code{"OS"} or \code{"PFS"}.
#'       Use \code{NULL} for calendar-only analyses.}
#'     \item{event_target}{Target event count to trigger analysis.
#'       Use \code{NULL} for calendar-only analyses.}
#'     \item{target_stratum}{Stratum in which to count events (e.g., \code{"BM+"}).
#'       Use \code{NULL} for overall.}
#'     \item{max_followup}{Maximum time after FPE (months). The cut date is capped here
#'       even if the event target is not reached. Use \code{NULL} for no cap.}
#'   }
#'
#' @return A numeric vector of calendar cut dates (months from study start).
#'
#' @examples
#' library(simtrial)
#' tr <- build_transition_rates(
#'   strata = "All", treatments = c("control", "experimental"),
#'   median_pfs = c(All = 5), median_os = c(All = 12),
#'   orr = list(All = c(control = 0.30, experimental = 0.45)),
#'   hr_pfs = c(All = 0.70), hr_os = c(All = 0.65)
#' )
#' sim <- sim_illness_death(
#'   n = 400, transition_rate = tr,
#'   enroll_rate = data.frame(rate = 30, duration = 14)
#' )
#' dates <- get_analysis_dates(sim, analyses = list(
#'   list(min_followup = 6, endpoint = NULL, event_target = NULL,
#'        target_stratum = NULL, max_followup = NULL),
#'   list(min_followup = 24, endpoint = "OS", event_target = 150,
#'        target_stratum = NULL, max_followup = 30)
#' ))
#'
#' @export
get_analysis_dates <- function(sim_data, analyses) {
  fpe <- max(sim_data$ENRLTIME)

  cut_dates <- numeric(length(analyses))

  for (i in seq_along(analyses)) {
    a <- analyses[[i]]
    calendar_min <- fpe + a$min_followup

    if (!is.null(a$event_target) && !is.null(a$endpoint)) {
      # Subset to target stratum if specified
      sdata <- sim_data
      if (!is.null(a$target_stratum)) {
        sdata <- sim_data[sim_data$STRATUM == a$target_stratum, ]
      }

      # Get endpoint-specific event times
      if (a$endpoint == "OS") {
        event_time <- sdata$OS_TIME
      } else if (a$endpoint == "PFS") {
        event_time <- sdata$PFS_TIME
      } else {
        stop("endpoint must be 'OS' or 'PFS'")
      }

      # Calendar time of each event (only if event occurs before dropout)
      is_event <- event_time < sdata$DROPOUT_TIME
      event_calendar <- sort((sdata$ENRLTIME + event_time)[is_event])

      if (length(event_calendar) >= a$event_target) {
        event_date <- event_calendar[a$event_target]
      } else {
        event_date <- Inf
      }

      cut_date <- max(calendar_min, event_date)

      if (!is.null(a$max_followup)) {
        cut_date <- min(cut_date, fpe + a$max_followup)
      }
    } else {
      cut_date <- calendar_min
    }

    cut_dates[i] <- cut_date
  }

  cut_dates
}


#' Cut simulated trial data for analysis and produce ADTTE-format datasets
#'
#' Applies administrative censoring at a specified cut date and produces
#' analysis datasets in ADaM ADTTE-like format. Each endpoint (OS, PFS, TTR)
#' becomes a set of rows identified by PARAMCD. ORR is included as a binary
#' endpoint.
#'
#' @param sim_data Patient-level data frame from \code{sim_illness_death()}.
#' @param cut_date Calendar time (months from study start) at which to cut.
#' @param paramcd Character vector of endpoints to include. Possible values:
#'   \code{"OS"}, \code{"PFS"}, \code{"TTR"}, \code{"ORR"} (default: all four).
#'
#' @return A data frame in long ADTTE format with columns:
#'   \code{USUBJID}, \code{STRATUM}, \code{TRT}, \code{PARAMCD}, \code{PARAM},
#'   \code{AVAL} (months), \code{AVALU}, \code{CNSR} (0 = event, 1 = censored),
#'   \code{EVNTDESC}.
#'
#' @examples
#' library(simtrial)
#' tr <- build_transition_rates(
#'   strata = "All", treatments = c("control", "experimental"),
#'   median_pfs = c(All = 5), median_os = c(All = 12),
#'   orr = list(All = c(control = 0.30, experimental = 0.45)),
#'   hr_pfs = c(All = 0.70), hr_os = c(All = 0.65)
#' )
#' sim <- sim_illness_death(
#'   n = 200, transition_rate = tr,
#'   enroll_rate = data.frame(rate = 20, duration = 10)
#' )
#' adtte <- cut_illness_death(sim, cut_date = 24)
#' head(adtte)
#'
#' @export
cut_illness_death <- function(
    sim_data,
    cut_date,
    paramcd = c("OS", "PFS", "TTR", "ORR")) {
  # Follow-up available for each patient
  followup <- cut_date - sim_data$ENRLTIME

  # Only include patients enrolled before cutoff
  enrolled <- sim_data[followup > 0, , drop = FALSE]
  followup <- followup[followup > 0]

  adtte_list <- list()

  if ("OS" %in% paramcd) {
    # OS: event = death; censored at min(dropout, admin cutoff)
    censor_time <- pmin(enrolled$DROPOUT_TIME, followup)
    os_aval <- pmin(enrolled$OS_TIME, censor_time)
    os_cnsr <- as.integer(enrolled$OS_TIME > censor_time)
    os_event <- ifelse(
      os_cnsr == 0, "Death",
      ifelse(enrolled$DROPOUT_TIME < followup, "Dropout",
             "Administrative censoring")
    )

    adtte_list[["OS"]] <- data.frame(
      USUBJID = enrolled$USUBJID,
      STRATUM = enrolled$STRATUM,
      TRT = enrolled$TRT,
      PARAMCD = "OS",
      PARAM = "Overall Survival",
      AVAL = os_aval,
      AVALU = "Months",
      CNSR = os_cnsr,
      EVNTDESC = os_event,
      stringsAsFactors = FALSE
    )
  }

  if ("PFS" %in% paramcd) {
    censor_time <- pmin(enrolled$DROPOUT_TIME, followup)
    pfs_aval <- pmin(enrolled$PFS_TIME, censor_time)
    pfs_cnsr <- as.integer(enrolled$PFS_TIME > censor_time)
    # Distinguish progression from death as PFS event
    pfs_event <- ifelse(
      pfs_cnsr == 0 & enrolled$PFS_TIME == enrolled$OS_TIME,
      "Death",
      ifelse(pfs_cnsr == 0, "Progression",
             ifelse(enrolled$DROPOUT_TIME < followup, "Dropout",
                    "Administrative censoring"))
    )

    adtte_list[["PFS"]] <- data.frame(
      USUBJID = enrolled$USUBJID,
      STRATUM = enrolled$STRATUM,
      TRT = enrolled$TRT,
      PARAMCD = "PFS",
      PARAM = "Progression-Free Survival",
      AVAL = pfs_aval,
      AVALU = "Months",
      CNSR = pfs_cnsr,
      EVNTDESC = pfs_event,
      stringsAsFactors = FALSE
    )
  }

  if ("TTR" %in% paramcd) {
    censor_time <- pmin(enrolled$DROPOUT_TIME, followup)
    # TTR: event = response observed before censoring
    resp_observed <- enrolled$ORR == 1 & enrolled$TTR <= censor_time
    # Non-responders censored at min(PFS event, dropout, admin cutoff)
    ttr_aval <- ifelse(resp_observed, enrolled$TTR,
                       pmin(enrolled$PFS_TIME, censor_time))
    ttr_cnsr <- as.integer(!resp_observed)

    adtte_list[["TTR"]] <- data.frame(
      USUBJID = enrolled$USUBJID,
      STRATUM = enrolled$STRATUM,
      TRT = enrolled$TRT,
      PARAMCD = "TTR",
      PARAM = "Time to Response",
      AVAL = ttr_aval,
      AVALU = "Months",
      CNSR = ttr_cnsr,
      EVNTDESC = ifelse(resp_observed, "Response", "Censored"),
      stringsAsFactors = FALSE
    )
  }

  if ("ORR" %in% paramcd) {
    censor_time <- pmin(enrolled$DROPOUT_TIME, followup)
    # ORR: binary indicator of observed response before censoring
    resp_observed <- enrolled$ORR == 1 & enrolled$TTR <= censor_time

    adtte_list[["ORR"]] <- data.frame(
      USUBJID = enrolled$USUBJID,
      STRATUM = enrolled$STRATUM,
      TRT = enrolled$TRT,
      PARAMCD = "ORR",
      PARAM = "Objective Response Rate",
      AVAL = as.integer(resp_observed),
      AVALU = "",
      CNSR = NA_integer_,
      EVNTDESC = ifelse(resp_observed, "Response", "No response"),
      stringsAsFactors = FALSE
    )
  }

  result <- do.call(rbind, adtte_list)
  rownames(result) <- NULL
  attr(result, "cut_date") <- cut_date
  result
}
