cat("Sourcing v2 implementations...\n")
source("bestv2.R")
source("rankhospitalv2.R")
source("rankallv2.R")

pass <- 0L; fail <- 0L
assert_equal <- function(actual, expected, label) {
  ok <- identical(actual, expected)
  if (ok) { cat(sprintf("[PASS] %s -> %s\n", label, deparse(expected))); pass <<- pass + 1L }
  else { cat(sprintf("[FAIL] %s\n  Expected: %s\n  Got     : %s\n", label, deparse(expected), deparse(actual))); fail <<- fail + 1L }
}
assert_true <- function(label, expr) { if (isTRUE(expr)) { cat(sprintf("[PASS] %s\n", label)); pass <<- pass + 1L } else { cat(sprintf("[FAIL] %s\n", label)); fail <<- fail + 1L } }

cat("\n== best(state, outcome) ==\n")
assert_equal(best("TX", "heart attack"), "CYPRESS FAIRBANKS MEDICAL CENTER", 'best("TX", "heart attack")')
assert_equal(best("TX", "heart failure"), "FORT DUNCAN MEDICAL CENTER", 'best("TX", "heart failure")')
assert_equal(best("MD", "heart attack"), "JOHNS HOPKINS HOSPITAL, THE", 'best("MD", "heart attack")')
assert_equal(best("MD", "pneumonia"), "GREATER BALTIMORE MEDICAL CENTER", 'best("MD", "pneumonia")')

cat("\n(Expect errors next with exact messages)\n")
err1 <- tryCatch(best("BB","heart attack"), error=function(e) e$message)
assert_equal(err1, "invalid state", 'best("BB","heart attack") error message')
err2 <- tryCatch(best("NY","hert attack"), error=function(e) e$message)
assert_equal(err2, "invalid outcome", 'best("NY","hert attack") error message')

cat("\n== rankhospital(state, outcome, num) ==\n")
assert_equal(rankhospital("TX","heart failure",4), "DETAR HOSPITAL NAVARRO", 'rankhospital("TX","heart failure",4)')
assert_equal(rankhospital("MD","heart attack","worst"), "HARFORD MEMORIAL HOSPITAL", 'rankhospital("MD","heart attack","worst")')
assert_true('is.na(rankhospital("MN","heart attack",5000))', is.na(rankhospital("MN","heart attack",5000)))

cat("\n== rankall(outcome, num) ==\n")
print(head(rankall("heart attack", 20), 10))
print(tail(rankall("pneumonia","worst"), 3))
print(tail(rankall("heart failure"), 10))

cat(sprintf("\nSummary: %d PASS, %d FAIL\n", pass, fail))
if (fail == 0L) cat("All checks passed. 🎉\n") else cat("Some checks failed. See above.\n")
