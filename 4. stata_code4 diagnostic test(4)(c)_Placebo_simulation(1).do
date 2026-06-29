* ==============================================================================
* 5. FIGURE 9: PLACEBO TEST (500 Randomized Simulations)
* ==============================================================================
mat b = J(500,1,0)
mat p = J(500,1,0)

quietly {
    forvalues i = 1/500 {
        preserve
        
        gen pseudo_Gender = (runiform() <= 0.5) 
        gen pseudo_Time = (YEAR >= runiformint(2018, 2022))
        
        gen pseudo_DID = pseudo_Gender * pseudo_Time
        
        areg LFPR pseudo_DID Disability Race Education Age i.YEAR, absorb(ST_num) vce(cluster ST_num)
        
        mat b[`i',1] = _b[pseudo_DID]
        mat p[`i',1] = 2 * ttail(e(df_r), abs(_b[pseudo_DID] / _se[pseudo_DID]))
        
        restore
		if mod(`i', 100) == 0 {
            noisily display "   -> Progress: `i' of 500 loops completed."
        }
    }
}

capture drop coef1 pval1
svmat b, names(coef)
svmat p, names(pval)
drop if missing(coef1)

* Plot Figure 9 (Strictly Black formatting, Legend placed at bottom)
twoway (kdensity coef1, lcolor(black) lpattern(solid) yaxis(1)) ///
       (scatter pval1 coef1, mcolor(black) msymbol(Oh) msize(small) yaxis(2)), ///
       yline(0.05, lcolor(gs10) lpattern(dash) axis(2)) ///
       xline(0.010, lcolor(black) lpattern(dash)) /// REPLACE 0.031 with your actual baseline Gender*Time coefficient
       xtitle("Estimated Pseudo-Coefficient") ///
       ytitle("Kernel Density", axis(1)) ///
       ytitle("p Value", axis(2)) ///
       legend(order(1 "Kernel Density of Coefficients" 2 "p-value") ring(1) pos(6) rows(1) region(lcolor(black))) ///
       title("Placebo Test (Randomized Treatment)", color(black)) ///
       graphregion(color(gs15)) bgcolor(gs15)