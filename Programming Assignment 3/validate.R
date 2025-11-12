# validate.R
# Sanity checks for Programming Assignment 3 functions.
# Run this from the folder containing:
#   - outcome-of-care-measures.csv
#   - hospital-data.csv
#   - best.R, rankhospital.R, rankall.R
#
# Usage in R:
#   source("validate.R")

cat("Sourcing A++ implementations...\n")
source("best.R")
source("rankhospital.R")
source("rankall.R")

pass <- 0L; fail <- 0L
assert_equal <- function(actual, expected, label) {
  ok <- identical(actual, expected)
  if (ok) {
    cat(sprintf("[PASS] %s -> %s\n", label, deparse(expected)))
    assign("pass", get("pass", inherits = TRUE) + 1L, inherits = TRUE)
  } else {
    cat(sprintf("[FAIL] %s\n  Expected: %s\n  Got     : %s\n",
                label, deparse(expected), deparse(actual)))
    assign("fail", get("fail", inherits = TRUE) + 1L, inherits = TRUE)
  }
}

assert_true <- function(expr_label, expr) {
  ok <- isTRUE(expr)
  if (ok) {
    cat(sprintf("[PASS] %s\n", expr_label))
    assign("pass", get("pass", inherits = TRUE) + 1L, inherits = TRUE)
  } else {
    cat(sprintf("[FAIL] %s\n", expr_label))
    assign("fail", get("fail", inherits = TRUE) + 1L, inherits = TRUE)
  }
}

cat("\n== best(state, outcome) ==\n")
assert_equal(best("TX", "heart attack"), "CYPRESS FAIRBANKS MEDICAL CENTER",
             'best("TX", "heart attack")')
assert_equal(best("TX", "heart failure"), "FORT DUNCAN MEDICAL CENTER",
             'best("TX", "heart failure")')
assert_equal(best("MD", "heart attack"), "JOHNS HOPKINS HOSPITAL, THE",
             'best("MD", "heart attack")')
assert_equal(best("MD", "pneumonia"), "GREATER BALTIMORE MEDICAL CENTER",
             'best("MD", "pneumonia")')

cat("\n(Expect errors next with exact messages)\n")
err_msg <- tryCatch(best("BB", "heart attack"),
                    error = function(e) e$message)
assert_equal(err_msg, "invalid state", 'best("BB", "heart attack") error message')

err_msg2 <- tryCatch(best("NY", "hert attack"),
                    error = function(e) e$message)
assert_equal(err_msg2, "invalid outcome", 'best("NY", "hert attack") error message')

cat("\n== rankhospital(state, outcome, num) ==\n")
assert_equal(rankhospital("TX", "heart failure", 4),
             "DETAR HOSPITAL NAVARRO",
             'rankhospital("TX","heart failure",4)')
assert_equal(rankhospital("MD", "heart attack", "worst"),
             "HARFORD MEMORIAL HOSPITAL",
             'rankhospital("MD","heart attack","worst")')
assert_true('is.na(rankhospital("MN","heart attack",5000))',
            is.na(rankhospital("MN","heart attack",5000)))

cat("\n== rankall(outcome, num) ==\n")
ra <- rankall("heart attack", 20)
cat("Head(rankall('heart attack', 20), 10):\n")
print(head(ra, 10))

cat("\nTail(rankall('pneumonia','worst'), 3):\n")
print(tail(rankall("pneumonia", "worst"), 3))

cat("\nTail(rankall('heart failure'), 10):\n")
print(tail(rankall("heart failure"), 10))

cat(sprintf("\nSummary: %d PASS, %d FAIL\n", pass, fail))
if (fail == 0L) {
  cat("All checks passed. 🎉\n")
} else {
  cat("Some checks failed. Investigate outputs above.\n")
}
