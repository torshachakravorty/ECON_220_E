

/* objective - generate figures 

data - generating process : treat is correlated with e 
* gen y3 = firms + n + te*treat + e

*/

clear all
capture log close
set seed 20200403

* globals - set path (change as needed - this is pathx)
global path = "C:/Users/Torsha Chakravorty/Dropbox/UCSD/year2/ECON_220E_Metrics/220E_simulationassignment/code/violation1_final"

* run .do file creating panel and the other describing selection process 

* file for generating panel 
do "$path/220e_sim1_genpanel.do"

* file for selection into treatment 
do "$path/220e_sim1b_dgp_selection.do"

* box plot visualizing selection into treatment 
graph box pdv_e, over(group) title(Correlation between PDV of shocks and treatment timing, size(medsmall) span) noout graphregion(fcolor(white))

* export 
graph export "$path/selection_pdverror.png", as(png) replace 

* binscatter 
binscatter y3 year, by(group) linetype(none) graphregion(fcolor(white))

* export 
graph export "$path/binscatter_teffect0.png", as(png) replace 


*************************************************************************
