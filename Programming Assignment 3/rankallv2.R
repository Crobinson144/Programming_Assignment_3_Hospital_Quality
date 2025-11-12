# rankall.R (fixed)
rankall <- function(outcome, num = "best") {
  outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  outcome_map <- c("heart attack"=11L, "heart failure"=17L, "pneumonia"=23L)
  if (!outcome %in% names(outcome_map)) stop("invalid outcome")
  col_idx <- outcome_map[[outcome]]
  suppressWarnings(outcome_df[[col_idx]] <- as.numeric(outcome_df[[col_idx]]))
  rate_colname <- names(outcome_df)[col_idx]
  df <- outcome_df[, c("Hospital.Name", "State", rate_colname)]
  names(df) <- c("Hospital.Name", "State", "Rate")
  df <- df[!is.na(df$Rate), ]
  by_state <- split(df, df$State)
  pick_by_rank <- function(d, num) {
    d <- d[order(d$Rate, d$Hospital.Name), ]
    if (nrow(d) == 0L) return(NA_character_)
    idx <- if (is.character(num)) {
      if (num == "best") 1L else if (num == "worst") nrow(d) else {
        suppressWarnings(as.integer(num))
      }
    } else if (is.numeric(num)) as.integer(num) else NA_integer_
    if (is.na(idx) || idx < 1L || idx > nrow(d)) return(NA_character_)
    d$Hospital.Name[idx]
  }
  states <- sort(unique(df$State))
  hospitals <- vapply(states, function(st) pick_by_rank(by_state[[st]], num), FUN.VALUE = character(1))
  data.frame(hospital = hospitals, state = states, row.names = states)
}
