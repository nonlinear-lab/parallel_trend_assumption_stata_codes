* ==============================================================================
* CHAPTER 4: EVENT STUDY
* ==============================================================================

* Ensure state variable is numerically encoded for fixed effects
capture encode ST, gen(ST_num)

* ==============================================================================
* 1. FIGURE 2: PREDICTIVE MARGINS EVENT STUDY (Absolute LFPR)
* ==============================================================================
* Run Regression
regress LFPR i.Gender##ib2019.YEAR Disability Race Education Age i.ST_num, vce(cluster ST_num)

* Calculate Margins
margins YEAR#Gender

* Plot Graph (Forced onto one single continuous line)
marginsplot, xdimension(YEAR) title("Predicted LFPR by Gender (Event Study)", color(black)) ytitle("Predicted Labour Force Participation Rate") xtitle("Year") xlabel(2017 2018 2019 2021 2022 2023) xline(2019.5, lpattern(dash) lcolor(black)) legend(order(1 "Male (Control)" 2 "Female (Treated)") region(lcolor(black))) plot1opts(lcolor(gs8) mcolor(gs8) msymbol(S) lpattern(solid)) plot2opts(lcolor(black) mcolor(black) msymbol(O) lpattern(dash)) ci1opts(lcolor(gs8)) ci2opts(lcolor(black)) graphregion(color(white)) bgcolor(white) name(fig1, replace)

* ==============================================================================
* 2. EVENT STUDY: COEFFICIENT PLOT & FORMAL WALD TEST
* ==============================================================================
* Run the Event Study Regression again
quietly regress LFPR i.Gender##ib2019.YEAR Disability Race Education Age i.ST_num, vce(cluster ST_num)

* Formal Wald Test for Pre-Trends (Testing if 2017 & 2018 delta = 0)
disp "--- Wald Test for Parallel Pre-Trends (2017 & 2018) ---"
test 1.Gender#2017.YEAR 1.Gender#2018.YEAR

* Extract Coefficients to Build the Plot Manually
capture drop plot_year plot_coef plot_lb plot_ub
gen plot_year = .
gen plot_coef = .
gen plot_lb = .
gen plot_ub = .

replace plot_year = 2017 in 1
replace plot_coef = _b[1.Gender#2017.YEAR] in 1
replace plot_lb = _b[1.Gender#2017.YEAR] - 1.96*_se[1.Gender#2017.YEAR] in 1
replace plot_ub = _b[1.Gender#2017.YEAR] + 1.96*_se[1.Gender#2017.YEAR] in 1

replace plot_year = 2018 in 2
replace plot_coef = _b[1.Gender#2018.YEAR] in 2
replace plot_lb = _b[1.Gender#2018.YEAR] - 1.96*_se[1.Gender#2018.YEAR] in 2
replace plot_ub = _b[1.Gender#2018.YEAR] + 1.96*_se[1.Gender#2018.YEAR] in 2

replace plot_year = 2019 in 3
replace plot_coef = 0 in 3
replace plot_lb = 0 in 3
replace plot_ub = 0 in 3

replace plot_year = 2021 in 4
replace plot_coef = _b[1.Gender#2021.YEAR] in 4
replace plot_lb = _b[1.Gender#2021.YEAR] - 1.96*_se[1.Gender#2021.YEAR] in 4
replace plot_ub = _b[1.Gender#2021.YEAR] + 1.96*_se[1.Gender#2021.YEAR] in 4

replace plot_year = 2022 in 5
replace plot_coef = _b[1.Gender#2022.YEAR] in 5
replace plot_lb = _b[1.Gender#2022.YEAR] - 1.96*_se[1.Gender#2022.YEAR] in 5
replace plot_ub = _b[1.Gender#2022.YEAR] + 1.96*_se[1.Gender#2022.YEAR] in 5

replace plot_year = 2023 in 6
replace plot_coef = _b[1.Gender#2023.YEAR] in 6
replace plot_lb = _b[1.Gender#2023.YEAR] - 1.96*_se[1.Gender#2023.YEAR] in 6
replace plot_ub = _b[1.Gender#2023.YEAR] + 1.96*_se[1.Gender#2023.YEAR] in 6

* Generate the Coefficient Plot (Forced onto one single continuous line)
twoway (rcap plot_lb plot_ub plot_year, lcolor(black)) (scatter plot_coef plot_year, mcolor(black) msymbol(S) msize(medium)), yline(0, lcolor(gs10) lpattern(dash)) xline(2019.5, lcolor(black) lpattern(shortdash)) xlabel(2017 2018 2019 2021 2022 2023) legend(off) title("Event Study: Shift in the Gender Gap Relative to 2019", color(black)) ytitle("Difference in LFPR Gap (delta)") xtitle("Year") graphregion(color(gs15)) bgcolor(gs15) name(fig2, replace)

* Clean up temporary variables
drop plot_year plot_coef plot_lb plot_ub