
/*
objective 	- specify how groups are created
			- groups choose to be treated earlier or later depending on pdv of future shocks
*/ 

* selection on treatment
su pdv_e_byfirm, detail

gen     group=0

replace group=1 if pdv_e_byfirm<=`r(p25)'
replace group=2 if pdv_e_byfirm>`r(p25)' & pdv_e_byfirm<=`r(p50)'
replace group=3 if pdv_e_byfirm>`r(p50)' & pdv_e_byfirm<=`r(p75)'
replace group=4 if pdv_e_byfirm>`r(p75)' & `r(p75)'!=.

* assign treatment 
gen     treat_date = 0 
replace treat_date = 1986 if group==1
replace treat_date = 1992 if group==2
replace treat_date = 1998 if group==3
replace treat_date = 2010 if group==4

* treatment indicator 
gen     treat=0 

replace treat=1 if group==1 & year>=1986
replace treat=1 if group==2 & year>=1992
replace treat=1 if group==3 & year>=1998
replace treat=1 if group==4 & year>=2010


* treatment effects - heterogenous treatment effects - make them numbers & not distributions
gen te1 = 0 
gen te2 = 0
gen te3 = 0
gen te4 = 0		// 4th group never gets treated 
gen te = 0

replace te = te1 if group == 1
replace te = te2 if group == 2
replace te = te3 if group == 3
replace te = te4 if group == 4


* DGP with endogenous group selection
gen y3 = firms + n+ te*treat + e 


* linear regression
eststo reg3a: areg y3 i.year treat, a(id) robust 

* chaisemartin & d'haultfoeuille estimator - could not extract betahat & se
*eststo reg3b: did_multiplegt y3 group year treat, breps(100) cluster(group)

***********************************************************************

