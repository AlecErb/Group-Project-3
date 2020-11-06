// Bobby Kallay 
// Group Assignment 3 Do File

import delimited "C:\Users\bobby\Downloads\EducationDataPortal_11.04.2020_years_after_entry.csv", clear

tempfile gender

tostring year, replace
gen yrschoolid=year+inst_name



save `gender'

import delimited "C:\Users\bobby\Downloads\EducationDataPortal_11.04.2020_institutions.csv", clear

tempfile instituiton

tostring year, replace
gen yrschoolid=year+inst_name



save `instituiton'

import delimited "C:\Users\bobby\Downloads\EducationDataPortal_11.05.2020_years_after_entry.csv", clear

tempfile income

tostring year, replace
tostring years_after_entry, replace
gen identify=year+inst_name+years_after_entry

drop years_after_entry
drop inst_name

save `income'

use `gender', clear

merge m:1 yrschoolid using `instituiton'
tostring years_after_entry, replace
gen identify=yrschoolid+years_after_entry
destring years_after_entry, replace

merge m:1 identify using `income', generate(_merge2)
drop yrschoolid
drop number_enrolled_ft
drop number_enrolled_pt
drop state_name
drop institution_level
drop inst_control

keep if year != "2006" 
keep if year != "2008" 
keep if year != "2010" 
keep if year != "2015"
keep if completion_rate_100pct != .
keep if years_after_entry != 8

replace inst_name = "University of Colorado at Boulder" if inst_name == "University of Colorado Boulder"
replace inst_name = "U of C @ B" if inst_name == "University of Colorado at Boulder"
replace inst_name = "U of U" if inst_name == "University of Utah"
replace inst_name = "L&C Col" if inst_name == "Lewis & Clark College"
replace inst_name = "MT St" if inst_name == "Montana State University"
replace inst_name = "U of V" if inst_name == "University of Vermont"

gen mf_ratio_100 = (count_working_male/count_working_female)*100

summ mf_ratio_100

generate salarydiff=earnings_male_mean-earnings_female_mean

reg completion_rate_100pct mf_ratio_100

reg salarydiff mf_ratio_100 completion_rate_100pct

twoway (scatter completion_rate_100pct mf_ratio_100)
graph bar (mean) salarydiff, over(inst_name, descending label(angle(vertical)))
graph bar (mean) mf_ratio_100, over(inst_name, descending label(angle(vertical)))