* Alec Erb Do-File
* Source: https://educationdata.urban.org/data-explorer/colleges/

* Data prep
import delimited "/Users/alec/Desktop/School/University of Utah/Fall 2020/Econemetrics - ECON 4651/Group Project 3/Master.csv", clear
tempfile masterData
replace year = year-1
replace inst_name = "University of Colorado at Boulder" if inst_name == "University of Colorado Boulder"
save `masterData'

import delimited "/Users/alec/Desktop/School/University of Utah/Fall 2020/Econemetrics - ECON 4651/Group Project 3/Secondary2.csv", clear
drop if years_after_entry == 6
drop if years_after_entry == 8
drop if years_after_entry == 9
drop if years_after_entry == 7
replace year = 2010 if year == 2009
replace year = 2009 if year == 2007
replace inst_name = "University of Colorado at Boulder" if inst_name == "University of Colorado Boulder"




tempfile secondaryData
save `secondaryData'

use `masterData', clear
* Lewis & Clark didn't make their ACT data available in the data set but made it available on their website
replace act_composite_75_pctl = 30 in 1
replace act_composite_75_pctl = 30 in 11
replace act_composite_75_pctl = 30 in 21
replace act_composite_75_pctl = 30 in 26

* Merge masterData and secondaryData
merge 1:1 year inst_name using `secondaryData', nogen keep(2 3)

* Regression -- Determine impact of student/faculty ratio on student success
reg completion_rate_100pct student_faculty_ratio, robust
generate private_school = (inst_control == "Private not-for-profit")
reg completion_rate_100pct student_faculty_ratio act_composite_75_pctl private_school, robust


reg earnings_med student_faculty_ratio, robust
reg earnings_med student_faculty_ratio act_composite_75_pctl private_school, robust

