# best.R (fixed)
best <- function(state, outcome) {
  outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  outcome_map <- c("heart attack"=11L, "heart failure"=17L, "pneumonia"=23L)
  if (!outcome %in% names(outcome_map)) stop("invalid outcome")
  if (!state %in% unique(outcome_df$State)) stop("invalid state")
  col_idx <- outcome_map[[outcome]]
  suppressWarnings(outcome_df[[col_idx]] <- as.numeric(outcome_df[[col_idx]]))
  rate_colname <- names(outcome_df)[col_idx]
  state_rows <- outcome_df[outcome_df$State == state, c("Hospital.Name", rate_colname)]
  names(state_rows) <- c("Hospital.Name", "Rate")
  state_rows <- state_rows[!is.na(state_rows$Rate), ]
  if (nrow(state_rows) == 0L) return(NA_character_)
  state_rows <- state_rows[order(state_rows$Rate, state_rows$Hospital.Name), ]
  state_rows$Hospital.Name[1]
}
