

/* objective 	- create a panel of 1000 firms ; each observed for 30 years 
				- each firm has perfect foresight over 30 years - calculates present discounted value of errors with a discount factor beta = 0.5
*/
				
* 1,000 firms (25 per state), 40 states, 4 groups (250 per groups), 30 years

* create the states
set obs 40
gen state = _n

* generate 1000 firms - 25 per state.
expand 25
bysort state: gen firms=runiform(0,5)
label variable firms "Unique firm fixed effect per state"

* Second create the years
expand 30
sort state
bysort state firms: gen year = _n
gen n=year
replace year = 1980 if year==1
replace year = 1981 if year==2
replace year = 1982 if year==3
replace year = 1983 if year==4
replace year = 1984 if year==5
replace year = 1985 if year==6
replace year = 1986 if year==7
replace year = 1987 if year==8
replace year = 1988 if year==9
replace year = 1989 if year==10
replace year = 1990 if year==11
replace year = 1991 if year==12
replace year = 1992 if year==13
replace year = 1993 if year==14
replace year = 1994 if year==15
replace year = 1995 if year==16
replace year = 1996 if year==17
replace year = 1997 if year==18
replace year = 1998 if year==19
replace year = 1999 if year==20
replace year = 2000 if year==21
replace year = 2001 if year==22
replace year = 2002 if year==23
replace year = 2003 if year==24
replace year = 2004 if year==25
replace year = 2005 if year==26
replace year = 2006 if year==27
replace year = 2007 if year==28
replace year = 2008 if year==29
replace year = 2009 if year==30

egen id =group(state firms)
label var id "firm identifier"


* Cohort years 1986, 1992, 1998, 2004

* selection into treatment - groups choose to be treated based on some discounting:

* create discount factor
gen beta = 0.5 

* error 	- don't need TIME-VARYING ERROR TERM
gen e 	= rnormal(0,(1.5)^2)			// is different over time

* present discounted value - sum(beta^t * e_t) for each firm i 

* gen (beta^t * e_t)
gen disc_e = (beta^n)*e 

bys id: egen pdv_e_byfirm = total(disc_e)
label var pdv_e_byfirm "PDV of errors: beta = 0.5"


************************************************************************

