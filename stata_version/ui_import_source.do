*This program is oriented to convert source files
*author: Anahid Bauer (abauer11@illinois.edu)
cd ${source}
import delimited "state_eligibility.csv", clear
rename wba wba_tresh
save "state_eligibility.dta", replace

import delimited "state_thresholds.csv", clear
bys state: egen max_inc_thresh=max(inc_thresh )
preserve
keep if inc_thresh ==max_inc_thresh
drop max_inc_thresh
save "state_thresholds_base.dta", replace
restore
preserve
keep if inc_thresh !=max_inc_thresh
drop max_inc_thresh
save "state_thresholds_alt.dta", replace
restore
