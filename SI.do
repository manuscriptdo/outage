***Summary statistics 
cd D:\data\停电数据\natural_and_outage\data\
use "data_natural.dta",clear
sum2docx Natural_disaster Strong_wind Rainstorm Cold_wave Geo_hazard Wildfire Heatwave festival using sum.docx, replace stats(N mean(%9.2f) sd(%9.2f) min max) landscape title("Summary statistics") 
***************************************
use "data_natural.dta",clear
foreach var of varlist  Outage_frequency Outage_frequency_unplanned  Outage_frequency_planned Outage_frequency_0_6h Outage_frequency_6h {
gen ln`var'=ln((`var'+1)/pop)
}
foreach var of varlist  Outage_duration Outage_duration_6h  Outage_duration_unplanned  Outage_duration_planned  Outage_duration_0_6h  {
gen ln`var'=ln(`var'+1)
}
********************Robustness check of main results
reghdfe lnOutage_frequency Natural_disaster festival weekend CEPI Coal_price COVID_19, absorb(County#YM) vce(cluster County)
est store m1
reghdfe lnOutage_duration Natural_disaster festival weekend CEPI Coal_price COVID_19, absorb(County#YM) vce(cluster County)
est store m2
reghdfe lnOutage_frequency Strong_wind Rainstorm Cold_wave Geo_hazard Wildfire Heatwave festival weekend CEPI Coal_price COVID_19, absorb(County#YM) vce(cluster County)
est store m3
reghdfe lnOutage_duration Strong_wind Rainstorm Cold_wave Geo_hazard Wildfire Heatwave festival weekend CEPI Coal_price COVID_19, absorb(County#YM) vce(cluster County)
est store m4
esttab m1 m2 m3 m4 using robustness_policy.csv, scalars(r2 r2_w r2_o r2_b)  pr2  se replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*****Robustness1 check of heterogeneity of power outages caused by natural disasters
reghdfe lnOutage_frequency c.Natural_disaster##i.Vulnerable festival weekend , absorb(County#YM) vce(cluster County)
est store m1
reghdfe lnOutage_duration c.Natural_disaster##i.Vulnerable festival weekend , absorb(County#YM) vce(cluster County)
est store m2
*****Robustness2 check of heterogeneity of power outages caused by natural disasters
gen Natural_disaster_2=1 if Natural_disaster>0
replace Natural_disaster_2=0 if Natural_disaster_2==.
reghdfe lnOutage_frequency c.Natural_disaster_2##i.Vulnerable festival weekend , absorb(County#YM) vce(cluster County)
est store m3
reghdfe lnOutage_duration c.Natural_disaster_2##i.Vulnerable festival weekend , absorb(County#YM) vce(cluster County)
est store m4
*****Robustness3 check of heterogeneity of power outages caused by natural disasters
xtile x_income = income, nq(3)
gen Vulnerable_2=1 if x_income==1
replace Vulnerable_2=0 if x_income==2
replace Vulnerable_2=0 if x_income==3
reghdfe lnOutage_frequency c.Natural_disaster##i.Vulnerable_2 festival weekend , absorb(County#YM) vce(cluster County)
est store m5
reghdfe lnOutage_duration c.Natural_disaster##i.Vulnerable_2 festival weekend , absorb(County#YM) vce(cluster County)
est store m6
esttab m1 m2 m3 m4 m5 m6 using robustness.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*******************************************Mechanism analysis
use "data_natural.dta",clear
foreach var of varlist  Outage_frequency Outage_frequency_unplanned  Outage_frequency_planned Outage_frequency_0_6h Outage_frequency_6h {
gen ln`var'=ln((`var'+1)/pop)
}
foreach var of varlist  Outage_duration Outage_duration_6h  Outage_duration_unplanned  Outage_duration_planned  Outage_duration_0_6h  {
gen ln`var'=ln(`var'+1)
}
reghdfe lnOutage_frequency c.Natural_disaster##c.EGI festival weekend , absorb(County#YM) vce(cluster County)
est store m1
reghdfe lnOutage_duration c.Natural_disaster##c.EGI festival weekend , absorb(County#YM) vce(cluster County)
est store m2
reghdfe lnOutage_frequency c.Natural_disaster##c.Labor festival weekend , absorb(County#YM) vce(cluster County)
est store m3
reghdfe lnOutage_duration c.Natural_disaster##c.Labor festival weekend , absorb(County#YM) vce(cluster County)
est store m4
esttab m1 m2 m3 m4 using mechanism.csv, scalars(r2 r2_w r2_o r2_b)  pr2  se replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*********************************************Empirical p values
use "data_natural.dta",clear
foreach var of varlist  Outage_frequency Outage_frequency_unplanned  Outage_frequency_planned Outage_frequency_0_6h Outage_frequency_6h {
gen ln`var'=ln((`var'+1)/pop)
}
foreach var of varlist  Outage_duration Outage_duration_6h  Outage_duration_unplanned  Outage_duration_planned  Outage_duration_0_6h  {
gen ln`var'=ln(`var'+1)
}
******************************************
cls
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail

bdiff, group(Vulnerable) model(reghdfe lnOutage_duration Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
******************************************
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency Strong_wind Rainstorm Cold_wave Geo_hazard Wildfire Heatwave festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail

bdiff, group(Vulnerable) model(reghdfe lnOutage_duration Strong_wind Rainstorm Cold_wave Geo_hazard Wildfire Heatwave festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail

bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency_unplanned Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration_unplanned Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
**************
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency_planned Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration_planned Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
*************
cls
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency_0_6h Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration_0_6h Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
*************
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency_6h Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration_6h Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
**************
preserve
keep if north==1
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
restore
***********************
preserve
keep if north==0
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
restore
*************************
preserve
keep if summer==1 
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
restore
*********************
preserve
keep if summer==0
bdiff, group(Vulnerable) model(reghdfe lnOutage_frequency Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
bdiff, group(Vulnerable) model(reghdfe lnOutage_duration Natural_disaster festival weekend, absorb(County#YM) vce(cluster County)) reps(100) detail
restore



