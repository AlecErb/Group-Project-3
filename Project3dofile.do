import delimited "C:\Users\Alex\Downloads\EducationDataPortal_11.02.2020_tuition_typeType_of_aidIncome_level.csv

* Cleaning and creating a few variables
drop if income_level =="Total"
encode income_level, gen(income)
gen low_income= income_level=="$30,001-$48,000"
gen mid_income = income_level=="$48,001-$75,000"
gen high_income = income_level=="$75,001-$110,000"
gen very_high_income = income_level=="$110,001 or more"
gen very_low_income = income_level=="Less than $30,000"

drop if tuition_type=="Total"

tabulate income_level
destring income_level, replace
destring inst_name, replace

* Running regressions to see association between variables
reg number_of_students average_grant very_low_income, robust
reg number_of_students average_grant very_high_income, robust
reg number_of_students average_grant very_high_income very_low_income, robust


* Proxy for actual affordability after financial assitance
gen avg_after_grant = net_price-average_grant
reg number_of_students avg_after_grant
reg number_of_students avg_after_grant very_low_income
reg number_of_students avg_after_grant very_high_income, robust
reg number_of_students avg_after_grant very_high_income very_low_income, robust


* Gen instituition variables if nesscery