# Calendar-Time Analysis Timing for OS/PFS/ORR

This note explains how to define analysis timing on the calendar and convert it into spending time for sequential p-value calculations.

## Planning vs execution

- Planning: set a calendar schedule for interim analyses. Use common calendar dates across endpoints where required.
- Execution: use actual data-cut dates (or a defined cutting routine) to compute realized elapsed times. Keep the same common cut dates for endpoints tied to the same interim.

## Design-time timing rules

- Interim 1 uses a common calendar date for ORR, PFS, and OS.
- Interim 2 uses a common calendar date for PFS and OS.
- Final analyses can be endpoint-specific (e.g., OS final later than PFS final).

## Example timing table (calendar months from FPFV)

Assume FPFV = month 0.

| Endpoint | Analysis | PlannedMonth | Notes |
| --- | --- | --- | --- |
| ORR | Interim 1 | 12 | Common interim 1 date |
| PFS | Interim 1 | 12 | Common interim 1 date |
| OS | Interim 1 | 12 | Common interim 1 date |
| PFS | Interim 2 | 18 | Common interim 2 date |
| OS | Interim 2 | 18 | Common interim 2 date |
| PFS | Final | 24 | Endpoint-specific final |
| OS | Final | 30 | Endpoint-specific final |

### Customize planned months for your study

Replace the example months with your planned calendar schedule. Use common interim 1 and interim 2 dates across endpoints, then endpoint-specific finals.

```r
t_interim1 <- 12
t_interim2 <- 18
t_final_pfs <- 24
t_final_os <- 30

analysis_timing <- tibble(
  Endpoint = c("ORR", "PFS", "OS", "PFS", "OS", "PFS", "OS"),
  Analysis = c(1, 1, 1, 2, 2, 3, 3),
  PlannedMonth = c(t_interim1, t_interim1, t_interim1,
                   t_interim2, t_interim2, t_final_pfs, t_final_os)
)
```

## Convert calendar time to spendingTime

Define elapsed time as planned months (or actual months at execution). Compute spending time within each endpoint as elapsed time divided by the endpoint-specific final elapsed time. Ensure the final analysis equals 1.

```r
analysis_timing <- tibble(
  Endpoint = c("ORR", "PFS", "OS", "PFS", "OS", "PFS", "OS"),
  Analysis = c(1, 1, 1, 2, 2, 3, 3),
  PlannedMonth = c(12, 12, 12, 18, 18, 24, 30)
)

analysis_timing <- analysis_timing %>%
  group_by(Endpoint) %>%
  mutate(spendingTime = PlannedMonth / max(PlannedMonth)) %>%
  ungroup()

# Join to your results entry for sequential p-values
inputResults <- inputResults %>%
  left_join(analysis_timing, by = c("Endpoint", "Analysis")) %>%
  mutate(spendingTime = ifelse(Endpoint == "ORR", NA, spendingTime))
```

## Execution-time variant using data-cut dates

Use actual cut dates (or a defined cutting routine) to compute elapsed time and spendingTime. Keep the common interim 1 date across ORR, PFS, OS and the common interim 2 date across PFS, OS.

```r
fpfv_date <- as.Date("2025-01-15")

analysis_timing_exec <- tibble(
  Endpoint = c("ORR", "PFS", "OS", "PFS", "OS", "PFS", "OS"),
  Analysis = c(1, 1, 1, 2, 2, 3, 3),
  CutDate = as.Date(c("2026-01-15", "2026-01-15", "2026-01-15",
                      "2026-07-15", "2026-07-15", "2027-01-15", "2027-07-15"))
)

analysis_timing_exec <- analysis_timing_exec %>%
  mutate(ElapsedMonths = as.numeric(difftime(CutDate, fpfv_date, units = "days")) / 30.4375) %>%
  group_by(Endpoint) %>%
  mutate(spendingTime = ElapsedMonths / max(ElapsedMonths)) %>%
  ungroup()
```

## Notes

- Use endpoint-specific denominators so PFS and OS can share interim dates but still reach 1 at their own finals.
- If you follow a cutting routine (e.g., simtrial-style calendar cuts), replace PlannedMonth with observed elapsed time at each data cut and recompute spendingTime.
- The common-date rule at interims ensures synchronized decision points across endpoints at design time.