# Programming Assignment 3 — Helper Notes

Files created:
- `best.R` — `best(state, outcome)` returns the hospital with the lowest (best) 30‑day mortality for the outcome in the given state.
- `rankhospital.R` — `rankhospital(state, outcome, num = "best")` returns the hospital with the requested rank in a state (ties broken alphabetically).
- `rankall.R` — `rankall(outcome, num = "best")` returns a two‑column data frame (`hospital`, `state`) with the requested rank per state.

Usage (in R, with working directory set to the folder containing the CSVs):
```r
source("best.R"); source("rankhospital.R"); source("rankall.R")

best("TX", "heart attack")
rankhospital("MD", "heart attack", "worst")
head(rankall("pneumonia", 10), 10)
```

Implementation notes:
- Exactly follows the assignment spec for argument validation and tie‑breaking.
- Reads the CSV with `colClasses="character"` and then safely coerces the needed column using `suppressWarnings(... <- as.numeric(...))`.
- Uses only base R.
- Returns `NA` where required (e.g., requesting a rank larger than the number of hospitals in a state).
```

