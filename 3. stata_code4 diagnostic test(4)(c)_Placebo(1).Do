* ==============================================================================
* 3. PLACEBO TEST 1: IN-TIME SHOCK (Fake Year 2019)
* ==============================================================================
preserve

keep if YEAR < 2021
gen Fake_Time = (YEAR >= 2019)

quietly regress LFPR c.Gender##c.Fake_Time Disability Race Education Age i.ST_num, vce(cluster ST_num)

disp "--- In-Time Placebo Test Results (Fake Shock in 2019) ---"
test c.Gender#c.Fake_Time

restore


* ==============================================================================
* 4. PLACEBO TEST 2: FAKE TREATMENT GROUP (Race instead of Gender)
* ==============================================================================
preserve

keep if Gender == 0
capture drop Time
gen Time = (YEAR >= 2021)

quietly regress LFPR c.Race##c.Time Disability Education Age i.ST_num, vce(cluster ST_num)

disp "--- Fake Treatment Group Placebo Test Results (Race instead of Gender) ---"
test c.Race#c.Time

restore


