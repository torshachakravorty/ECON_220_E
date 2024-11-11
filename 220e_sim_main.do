
/*

to-do list before executing do-file - 

1.) ensure all .do files are in the same location (called that "pathx")
2.) change paths to your own preferred location, "pathx" 
2.) set min & max reps - these refer to number of draws in the simulation 
3.) do not change the seed - for replicability 

*/

* preliminaries 
clear all

* globals - set path (change as needed - this is pathx)
global path = "C:/Users/Torsha Chakravorty/Dropbox/UCSD/year2/ECON_220E_Metrics/220E_simulationassignment/code/violation1_final"

* locals - set # reps (change as needed)
local rep = 100

/*local minrep = 1000
local steps = 50
local maxrep = 2000

* for appending into one file 
local minrepstart = `minrep' + `steps'	*/


***********************************************************************
* begin writing function for simulation
program myreg3, eclass

* start
drop _all

* generate panel 
do "$path/220e_sim1_genpanel.do"


* data generating process - with selection 
do "$path/220e_sim1b_dgp_selection.do" 

end


* simulate 
simulate _b _se, reps(`rep') seed(5762): myreg3

/* create tempfile to store results 

forvalues i = `minrep'(`steps')`maxrep' {
	
	tempfile sims`i'
	
	simulate _b _se, reps(`i') seed(5762): myreg3

	summ _b_treat _se_treat

	gen ndraws = _N
	order ndraws, first 

	collapse _b_treat _se_treat (min) ndraws
	
	save `sims`i'', replace
}

* append results from each simulation 
use `sims`minrep'', clear 

forvalues x = `minrepstart'(`steps')`maxrep' {
	append using `sims`x''
}
*/

* edit final appended file 
rename _b_treat dd_coeff
rename _se_treat dd_stderror

save "$path/appendedsims.dta", replace 

* plot the coefficients from different draws

* generate coef matrix - 
mkmat dd_coeff dd_stderror, mat(A)

* transpose
matrix B = A'

* coefplots  
coefplot mat(B), se(2) vertical yla(-0.5 0 0.5 1) xtitle(i-th draw)  msize(tiny) title(DiD estimate is biased upwards, size(medsmall) span) yline(0, lp(dash) lc(red)) graphregion(fcolor(white))

e 

* save graph
graph export "$path/didcoefplot_sim_violation1.png", as(png)

* distribution of theta_hat 
kdensity dd_coeff, xtitle(theta_hat, size(small)) title(Bias of DiD estimate centred around .45, size(medsmall) span) ytitle(density, size(small)) graphregion(fcolor(white))

* save kdensity graph 
graph export "$path/kdensity_bias_ddcoeff.png", as(png)

* exit 
exit, clear 




