# best.R
# Programming Assignment 3 - R Programming
# Author: (Your Name)
# Function: best(state, outcome)
# Returns the hospital name with the lowest 30-day mortality for the specified outcome in the given state.
# Valid outcomes: "heart attack", "heart failure", "pneumonia"
# Errors with exact messages per spec:
#   - invalid state
#   - invalid outcome

best <- function(state, outcome) {
  # Read outcome data
  outcome_df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # Map outcome to column index in file
  outcome_map <- c(
    "heart attack" = 11L,
    "heart failure" = 17L,
    "pneumonia"    = 23L
  )
  
  # Validate outcome
  if (!outcome %in% names(outcome_map)) {
    stop("invalid outcome")
  }
  
  # Validate state
  valid_states <- unique(outcome_df$State)
  if (!state %in% valid_states) {
    stop("invalid state")
  }
  
  # Extract relevant subset: rows for state, with non-missing outcome values
  col_idx <- outcome_map[[outcome]]
  # Coerce the selected outcome column to numeric, suppressing warnings about NAs
  suppressWarnings(outcome_df[, col_idx] <- as.numeric(outcome_df[, col_idx]))
  
  state_rows <- outcome_df[outcome_df$State == state, c("Hospital.Name", col_idx)]
  names(state_rows) <- c("Hospital.Name", "Rate")
  
  # Drop rows with NA Rate
  state_rows <- state_rows[!is.na(state_rows$Rate), ]
  
  # Order by Rate (ascending), then Hospital.Name (alphabetical) to break ties
  ord <- order(state_rows$Rate, state_rows$Hospital.Name)
  state_rows <- state_rows[ord, ]
  
  # Return hospital name with lowest (best) rate
  state_rows$Hospital.Name[1]
}
