# rankhospital.R (fixed)
rankhospital <- function(state, outcome, num = "best") {
  outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  outcome_map <- c("heart attack"=11L, "heart failure"=17L, "pneumonia"=23L)
  if (!outcome %in% names(outcome_map)) stop("invalid outcome")
  if (!state %in% unique(outcome_df$State)) stop("invalid state")
  col_idx <- outcome_map[[outcome]]
  suppressWarnings(outcome_df[[col_idx]] <- as.numeric(outcome_df[[col_idx]]))
  rate_colname <- names(outcome_df)[col_idx]
  df <- outcome_df[outcome_df$State == state, c("Hospital.Name", rate_colname)]
  names(df) <- c("Hospital.Name", "Rate")
  df <- df[!is.na(df$Rate), ]
  if (nrow(df) == 0L) return(NA_character_)
  df <- df[order(df$Rate, df$Hospital.Name), ]
  idx <- if (is.character(num)) {
    if (num == "best") 1L else if (num == "worst") nrow(df) else {
      suppressWarnings(as.integer(num))
    }
  } else if (is.numeric(num)) as.integer(num) else NA_integer_
  if (is.na(idx) || idx < 1L || idx > nrow(df)) return(NA_character_)
  df$Hospital.Name[idx]
}
