# rankhospital.R
# Programming Assignment 3 - R Programming
# Author: (Your Name)
# Function: rankhospital(state, outcome, num = "best")
# Returns the hospital name in a state with the given ranking for 30-day mortality.
# Valid outcomes: "heart attack", "heart failure", "pneumonia"
# num: "best", "worst", or a positive integer. If num > number of hospitals, return NA.
# Errors with exact messages per spec:
#   - invalid state
#   - invalid outcome

rankhospital <- function(state, outcome, num = "best") {
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
  
  # Prepare subset for the state
  col_idx <- outcome_map[[outcome]]
  suppressWarnings(outcome_df[, col_idx] <- as.numeric(outcome_df[, col_idx]))
  
  df <- outcome_df[outcome_df$State == state, c("Hospital.Name", col_idx)]
  names(df) <- c("Hospital.Name", "Rate")
  df <- df[!is.na(df$Rate), ]
  
  # If no data after filtering, return NA (defensive)
  if (nrow(df) == 0L) return(NA_character_)
  
  # Order by Rate ascending, then Hospital.Name to break ties
  ord <- order(df$Rate, df$Hospital.Name)
  df <- df[ord, ]
  
  # Interpret num
  if (is.character(num)) {
    if (num == "best") {
      idx <- 1L
    } else if (num == "worst") {
      idx <- nrow(df)
    } else {
      # If a non-numeric string supplied, try to coerce to integer and validate
      suppressWarnings(num_int <- as.integer(num))
      if (is.na(num_int) || num_int < 1L) return(NA_character_)
      idx <- num_int
    }
  } else if (is.numeric(num)) {
    num_int <- as.integer(num)
    if (is.na(num_int) || num_int < 1L) return(NA_character_)
    idx <- num_int
  } else {
    return(NA_character_)
  }
  
  # If requested rank exceeds available hospitals, return NA
  if (idx > nrow(df)) return(NA_character_)
  
  df$Hospital.Name[idx]
}
