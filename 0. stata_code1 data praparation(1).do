* ==============================================================================
* DATA PREPARATION
* ==============================================================================
* Set the working directory
cd "C:\stata"

* Import the CSV data file (clear any existing data in memory)
* import delimited "acs_2017_2023.csv", clear
* Import the CSV data file using insheet (bypasses Java requirements)
insheet using "acs_2017_2023.csv", comma clear

* Convert all variable names back to uppercase to match the dataset headers
rename *, upper

* Restrict the sample to the working-age population aged 16 to 64.
keep if AGEP >= 16 & AGEP <= 64

* Dependent Variables
gen LFPR = (ESR != 6) if !missing(ESR)            // 0 if ESR=6, 1 otherwise [cite: 17]
gen At_Work = (ESR == 1 | ESR == 4)               // 1 if ESR=1 or 4, 0 otherwise [cite: 66]
gen Unemployment = (ESR == 3)                     // 1 if ESR=3, 0 otherwise [cite: 78]
gen EMP = (ESR != 3 & ESR != 6)                   // 0 if ESR=3 or 6, 1 otherwise [cite: 83]

* Independent & Control Variables
gen Gender = (SEX == 2)                           // 1 for Female, 0 for Male [cite: 13]
gen Time = (YEAR >= 2021)                         // 1 for Pandemic, 0 for Pre-pandemic [cite: 11]
gen Disability = (DIS == 1)                       // 1 for Disabled, 0 otherwise [cite: 22]
gen Race = (RAC1P > 1)                            // 1 for Non-White, 0 for White [cite: 25]
gen Education = (SCHL < 16)                       // 1 for No HS diploma, 0 for HS or above [cite: 29]
gen Age = (AGEP >= 16 & AGEP <= 24)               // 1 for youth (16-24), 0 for non-youth (25-64)

encode ST, gen(ST_num)
