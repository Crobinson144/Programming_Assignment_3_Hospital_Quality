# rankall.R
# Programming Assignment 3 - R Programming
# Author: Chinua Eric Robinson
# Function: rankall(outcome, num = "best")
# Returns a data.frame with columns 'hospital' and 'state', giving for each state
# the hospital with the requested ranking for the specified outcome.
# Valid outcomes: "heart attack", "heart failure", "pneumonia"
# num: "best", "worst", or a positive integer. If rank exceeds hospitals in a state, return NA for that state.
# NOTE: Per assignment instructions, this function does NOT call rankhospital().

rankall <- function(outcome, num = "best") {
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
  
  # Coerce target column to numeric
  col_idx <- outcome_map[[outcome]]
  suppressWarnings(outcome_df[[col_idx]] <- as.numeric(outcome_df[[col_idx]]))
  # Select by column name: c("Hospital.Name", col_idx) would coerce the index to "11"
  rate_colname <- names(outcome_df)[col_idx]
  
  # Keep only needed columns to reduce memory
  df <- outcome_df[, c("Hospital.Name", "State", rate_colname)]
  names(df) <- c("Hospital.Name", "State", "Rate")
  
  # Drop NAs in Rate
  df <- df[!is.na(df$Rate), ]
  
  # Split by state
  by_state <- split(df, df$State)
  
  # Helper to pick the hospital by rank for one state's data.frame
  pick_by_rank <- function(d, num) {
    # Order by rate ascending, then name
    ord <- order(d$Rate, d$Hospital.Name)
    d <- d[ord, ]
    
    # Determine index
    if (is.character(num)) {
      if (num == "best") {
        idx <- 1L
      } else if (num == "worst") {
        idx <- nrow(d)
      } else {
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
    
    if (idx > nrow(d)) return(NA_character_)
    d$Hospital.Name[idx]
  }
  
  # Apply to each state; ensure states are sorted alphabetically in the result
  states <- sort(unique(df$State))
  hospitals <- vapply(states, function(st) {
    pick_by_rank(by_state[[st]], num)
  }, FUN.VALUE = character(1))
  
  # Return data.frame with required column names
  data.frame(hospital = hospitals, state = states, row.names = states)
}
