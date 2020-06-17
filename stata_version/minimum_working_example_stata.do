cd ${ui_calc}
clear 

import delimited ${examplefile}, clear

gen weekly_earnings = wage/weeks_worked

foreach quarter of num 1/4 {
	gen q`quarter'_weeks = weeks_worked - 52 + 13 * (`quarter') 
	
	gen q`quarter' = q`quarter'_weeks * weekly_earnings
	replace q`quarter' = 0 if q`quarter'_weeks < 0 
	replace q`quarter' = 13*weekly_earnings if q`quarter'_weeks > 13 
	
	drop q`quarter'_weeks
}
qui calc_weekly_state(q1,q2,q3,q4, state)
