# Programming Assignment 3 — Hospital Quality (Johns Hopkins R Programming)

This repository contains my implementation of **Programming Assignment 3: Hospital Quality**  
from the [Johns Hopkins University *R Programming* course](https://www.coursera.org/learn/r-programming),  
part of the **Data Science Specialization**.

---

## 🩺 Project Overview
This assignment analyzes U.S. hospital performance data from the **Hospital Compare** dataset (CMS/HHS).  
The goal is to find and rank hospitals based on 30-day mortality rates for:
- **Heart Attack**
- **Heart Failure**
- **Pneumonia**

This demonstrates data handling, validation, and reproducibility using **base R** only.

---

## 📂 Repository Structure

```
Programming Assignment 3/
  best.R, rankhospital.R, rankall.R         # final implementations
  validate.R                                # checks against the assignment's expected outputs
  outcome-of-care-measures.csv, hospital-data.csv
  Hospital_Revised_Flatfiles.pdf            # dataset documentation from Hospital Compare
```

---

## Usage
Set the working directory to `Programming Assignment 3/`, then:

```r
source("best.R"); source("rankhospital.R"); source("rankall.R")

best("TX", "heart attack")                  # "CYPRESS FAIRBANKS MEDICAL CENTER"
rankhospital("MD", "heart attack", "worst") # "HARFORD MEMORIAL HOSPITAL"
head(rankall("heart attack", 20), 10)
```

Rules implemented:
- Valid outcomes are `"heart attack"`, `"heart failure"` and `"pneumonia"`; anything else stops with `invalid outcome`. An unknown state stops with `invalid state`.
- Hospitals with no data for the outcome are excluded.
- Ties on mortality rate are broken alphabetically by hospital name.
- `num` can be `"best"`, `"worst"` or a rank; a rank larger than the number of hospitals returns `NA`.

## Validation
`source("validate.R")` runs 9 checks against the expected results given in the assignment instructions (9 PASS, 0 FAIL as of September 2026).

## Notes
This is course work for the Johns Hopkins R Programming course on Coursera. The data are historical Hospital Compare files distributed with the assignment; the output is not clinical guidance.
