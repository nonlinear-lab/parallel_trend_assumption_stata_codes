* 3a. VIF and Tolerance [cite: 59]
* Note: VIF cannot be run directly after clustering in Stata, so we run a standard OLS first
quietly regress LFPR Gender Time c.Gender#c.Time Disability Race Education Age
vif

* 3b. PTS1 Assumption: Linear pre-pandemic trend [cite: 174]
* Tested using data solely from the pre-pandemic period (Time == 0) [cite: 175]
quietly regress LFPR c.Gender##c.YEAR Disability Race Education Age if Time == 0, vce(cluster ST)
test c.Gender#c.YEAR

* 3c. PTS2 Assumption: Categorical pre-pandemic trend [cite: 177]
gen Year2018 = (YEAR == 2018)
gen Year2019 = (YEAR == 2019)

quietly regress LFPR Gender YEAR c.Gender#c.Year2018 c.Gender#c.Year2019 Disability Race Education Age if Time == 0, vce(cluster ST)
* Joint Wald test for both interaction terms equaling 0 [cite: 181, 182]
test c.Gender#c.Year2018 c.Gender#c.Year2019
