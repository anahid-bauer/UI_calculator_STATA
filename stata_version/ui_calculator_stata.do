*Program constructed to replicate python program ui_calculator
*author: Anahid Bauer (abauer11@illinois.edu)


program calc_weekly_schedule
args base_wage rate intercept minimum maximum
gen no_truncation_benefits=(base_wage *rate)+intercept
egen aux=rowmin(no_truncation_benefits maximum)
egen wba = rowmax(aux minimum)
drop no_truncation_benefits aux
end

program is_eligible
args q1 q2 q3 q4 wba state
tempfile temp
preserve
gen is_elegible_result="True"
merge m:1 state using ${source}state_eligibility.dta
if (_merge!=1){
drop if _merge==2
drop _merge
egen sum_base_period=rowtotal(q1 q2 q3 q4)
replace is_elegible_result="False" if sum_base_period<absolute_base
egen max_base_period=rowmax(q1 q2 q3 q4)
replace is_elegible_result="False" if sum_base_period< hqw*max_base_period
replace is_elegible_result="False" if max_base_period< absolute_hqw
replace is_elegible_result="False" if sum_base_period< wba_tresh*wba
gen count_poswq=0
forvalues i=1/4{
replace count_poswq=count_poswq+1 if q`i'>0 & q`i'~=.
}
replace is_elegible_result="False" if count_poswq< num_quarters
replace is_elegible_result="False" if (sum_base_period - max_base_period)< outside_high_q
rowsort q1-q4, generate(e1-e4) descending
replace is_elegible_result="False" if e2< absolute_2nd_high
egen sum_e1_e2=rowtotal(e1 e2)
replace is_elegible_result="False" if sum_e1_e2 < wba_2hqw*wba
replace is_elegible_result="False" if sum_e1_e2 < hqw_2hqw*max_base_period
replace is_elegible_result="False" if sum_e1_e2< abs_2hqw
br
keep q1 q2 q3 q4 wba state is_elegible_result
save `temp', replace

}
else if (_merge==1){
di "There was an error indexing the dataframe. Check that your two character state code is is matched by a state code in state_eligibity.csv"
keep q1 q2 q3 q4 wba state 
save `temp', replace
}
restore
merge 1:1 q1 q2 q3 q4 wba state using `temp'
drop _merge
end

*  from the name of a wage concept and a list of earnings in the base period, calculate the total earnings that are used to calculate benefits in the state
program find_base_wage
args wage_concept q1 q2 q3 q4
    
gen base_wage=.
capture gen note_=""
egen max_base_period=rowmax(q1 q2 q3 q4)
egen sum_base_period=rowtotal(q1 q2 q3 q4)
rowsort q1-q4, generate(e1-e4) descending
egen sum_e1_e2=rowtotal(e1 e2)
egen sum_q3_q4=rowtotal(q3 q4)
di "in find_base_wage: start replacing"
replace base_wage=sum_e1_e2 if (wage_concept == "2hqw")
replace base_wage=max_base_period  if (wage_concept == "hqw")
replace base_wage=sum_base_period if (wage_concept == "annual_wage")
replace base_wage=sum_q3_q4 if (wage_concept == "2fqw")
replace base_wage=sum_e1_e2+0.5*e3 if (wage_concept == "ND")
local wage_cp= wage_concept
replace note_="The wage concept `wage_cp' from state_thresholds.csv is not defined" if (wage_concept != "2hqw") & (wage_concept != "hqw") &(wage_concept != "annual_wage") & (wage_concept != "2fqw") & (wage_concept != "ND")

drop max_base_period sum_base_period e1-e4  sum_e1_e2 sum_q3_q4
end

* From quarterly earnings history in chronological order, and a two character state index calculate the weekly benefits.


program calc_weekly_state
args q1 q2 q3 q4 state
tempfile temp2
preserve
merge m:1 state using ${source}state_thresholds_base.dta
if (_merge!=1){
drop if _merge==2
drop _merge 

find_base_wage(wage_concept,q1,q2,q3,q4)
replace wage_concept="" if base_wage < inc_thresh
replace rate=. if base_wage < inc_thresh
replace intercept=. if base_wage < inc_thresh
replace minimum=. if base_wage < inc_thresh
replace maximum=. if base_wage < inc_thresh
merge m:1 state using ${source}state_thresholds_base.dta, update
drop if _merge==2
drop _merge 
drop base_wage
qui find_base_wage(wage_concept,q1,q2,q3,q4)
qui calc_weekly_schedule(base_wage, rate, intercept, minimum, maximum)
qui is_eligible(q1,q2,q3,q4,wba,state)
replace wba=0 if is_elegible_result=="False"
keep q1 q2 q3 q4 state wba
save `temp2', replace
  }
else if (_merge==1){
di "There was an error indexing the dataframe. Check that your two character state code is is matched by a state code in state_thresholds.csv"
keep q1 q2 q3 q4 state 
save `temp2', replace
}
restore
merge 1:1 q1 q2 q3 q4 state using `temp2'
drop _merge
capture rename wba benefits
end  
    
