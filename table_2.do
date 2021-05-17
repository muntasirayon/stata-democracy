*******************************************
/* Table 2: ANRR replication+democracy experience*/
*******************************************
set more off

**********************************************
eststo clear
estimates drop _all

global limit=25 	/* Effect of democracy after $limit years */
local repsBS=100  	/* number of boostrap replications for HHK */


**********************************************
* Program to capture long term effects starts
**********************************************

* Long term effects with 4 lags
capture program drop vareffects
program define vareffects, eclass

quietly: nlcom (effect1: _b[shortrun]) ///
	  (shortrun: _b[shortrun]) ///
	  (lag1: _b[lag1]) ///
	  (lag2: _b[lag2]) ///
	  (lag3: _b[lag3]) ///
	  (lag4: _b[lag4]) ///
	  , post

quietly: nlcom (effect2: _b[effect1]*_b[lag1]+_b[shortrun]) ///
	  (effect1: _b[effect1]) ///
	  (shortrun: _b[shortrun]) ///
	  (lag1: _b[lag1]) ///
	  (lag2: _b[lag2]) ///
	  (lag3: _b[lag3]) ///
	  (lag4: _b[lag4]) ///
	  , post

quietly: nlcom (effect3: _b[effect2]*_b[lag1]+_b[effect1]*_b[lag2]+_b[shortrun]) ///
	  (effect2: _b[effect2]) ///
	  (effect1: _b[effect1]) ///
	  (shortrun: _b[shortrun]) ///
	  (lag1: _b[lag1]) ///
	  (lag2: _b[lag2]) ///
	  (lag3: _b[lag3]) ///
	  (lag4: _b[lag4]) ///
	  , post
	  
quietly: nlcom (effect4: _b[effect3]*_b[lag1]+_b[effect2]*_b[lag2]+_b[effect1]*_b[lag3]+_b[shortrun]) ///
	  (effect3: _b[effect3]) ///
	  (effect2: _b[effect2]) ///
	  (effect1: _b[effect1]) ///
	  (shortrun: _b[shortrun]) ///
	  (lag1: _b[lag1]) ///
	  (lag2: _b[lag2]) ///
	  (lag3: _b[lag3]) ///
	  (lag4: _b[lag4]) ///
	  , post	  

forvalues j=5(1)$limit{	  
local j1=`j'-1
local j2=`j'-2
local j3=`j'-3
local j4=`j'-4

quietly: nlcom (effect`j': _b[effect`j1']*_b[lag1]+_b[effect`j2']*_b[lag2]+_b[effect`j3']*_b[lag3]+_b[effect`j4']*_b[lag4]+_b[shortrun]) ///
	  (effect`j1': _b[effect`j1']) ///
	  (effect`j2': _b[effect`j2']) ///
	  (effect`j3': _b[effect`j3']) ///
	  (shortrun: _b[shortrun]) ///
	  (lag1: _b[lag1]) ///
	  (lag2: _b[lag2]) ///
	  (lag3: _b[lag3]) ///
	  (lag4: _b[lag4]) ///
	  , post	  	  

}

quietly: nlcom (effect$limit: _b[effect$limit]) ///
	  (longrun: _b[shortrun]/(1-_b[lag1]-_b[lag2]-_b[lag3]-_b[lag4])) ///
      (shortrun: _b[shortrun]) ///
	  (persistence: _b[lag1]+_b[lag2]+_b[lag3]+_b[lag4]) ///
	  (lag1: _b[lag1]) ///
	  (lag2: _b[lag2]) ///
	  (lag3: _b[lag3]) ///
	  (lag4: _b[lag4]) ///
	  , post
ereturn display
end

**********************************************
* Program to capture long term effects ends
**********************************************

**********************************************
* HHK code starts
**********************************************
capture program drop helm
program define helm
*
* This program will do Helmert transformation for a list of variables
* NOTE:  must have variables named id, year   
* to use enter >> helm var1 var2...
* new variables will be names with h_ in front h_var1  and so on
*
qui while "`1'"~="" {
gsort id -year                /*sort years descending */
tempvar one sum n m w 
* capture drop h_`1'         /* IF the variable exist - it will remain and not generated again */
gen `one'=1 if `1'~=.             /*generate one if x is nonmissing */
qui by id: gen `sum'=sum(`1')-`1' /*running sum without current element */
qui by id: gen `n'=sum(`one')-1     /*number of obs included in the sum */
replace `n'=. if `n'<=0             /* n=0 for last observation and =-1 if
                                   last observation is missing*/
gen `m'=`sum'/`n'                 /* m is forward mean of variable x*/
gen `w'=sqrt(`n'/(`n'+1))         /* weight on mean difference */
capture gen h_`1'=`w'*(`1'-`m')             /* transformed variable */ 
sort id year
mac shift
}
end


capture program hhkBS drop // drop included
program define hhkBS // this is new line
syntax anything[, ydeep(integer 1960) ystart(integer 1964) yfinal(integer 2009) truncate(integer 4) depvarlags(integer 4)]
	local 0 `anything' 
	gettoken yvar 0 : 0 /*dependent variable*/
	gettoken seqexg   0 : 0, match(par) /*Sequentially exogenous variables*/
	gettoken gmminst  0 : 0, match(par) /*gmm style instruments*/
	gettoken gmmtrunc 0 : 0, match(par) /*gmm style instruments, truncated*/
	gettoken excov 0 : 0, match(par) /*exogenous covariates: diff coefficient for each equation*/
		
/*declares panel structure and defines estimation sample*/
quietly: tsset, clear
quietly: tsset newcl year // newcl comes from where?
sort newcl year
quietly: xtreg `yvar' `seqexg' `excov', fe
quietly: gen tsample=e(sample)

/**************************************************************************************
*********Helmert transformations and partialing out covariates************************/
quietly: gen id=newcl
sort newcl year
quietly: reg `yvar' `excov' if tsample==1
quietly: predict `yvar'_res if tsample==1, resid
quietly: helm `yvar'_res
rename h_`yvar'_res h_`yvar'
drop `yvar'_res

local num_seqexg=0
local seqexg_helm
foreach var of local seqexg{
sort newcl year
local num_seqexg=`num_seqexg'+1
quietly: gen seqexg`num_seqexg'=`var'
quietly: reg seqexg`num_seqexg' `excov' if tsample==1
quietly: predict seqexg`num_seqexg'_res if tsample==1, resid
quietly: helm seqexg`num_seqexg'_res
rename h_seqexg`num_seqexg'_res h_seqexg`num_seqexg'
local seqexg_helm `seqexg_helm' h_seqexg`num_seqexg'
drop seqexg`num_seqexg' seqexg`num_seqexg'_res
}

/***************************************************************
***************Creation of GMM instruments**********************
***************************************************************/
local gmmlist
local num_gmm=0
foreach var of local gmminst{
	sort newcl year
	local num_gmm=`num_gmm'+1
	quietly: gen abond`num_gmm'=`var'
	quietly: reg abond`num_gmm' `excov' if tsample==1
	quietly: predict abond`num_gmm'_res, resid
	drop abond`num_gmm' 
	rename abond`num_gmm'_res abond`num_gmm'

	quietly: replace abond`num_gmm'=0 if abond`num_gmm'==.
	local gmmlist `gmmlist' abond`num_gmm' 

}

local gmmlist_trunc
local num_gmm_trunc=0
foreach var of local gmmtrunc{
	sort newcl year
	local num_gmm_trunc=`num_gmm_trunc'+1
	quietly: gen abond_trunc`num_gmm_trunc'=`var'
	quietly: reg abond_trunc`num_gmm_trunc' `excov' if tsample==1
	quietly: predict abond_trunc`num_gmm_trunc'_res, resid
	drop abond_trunc`num_gmm_trunc' 
	rename abond_trunc`num_gmm_trunc'_res abond_trunc`num_gmm_trunc'
	quietly: replace abond_trunc`num_gmm_trunc'=0 if abond_trunc`num_gmm_trunc'==.
	local gmmlist_trunc `gmmlist_trunc' abond_trunc`num_gmm_trunc' 
}

/***************************************************************
***************Estimator for year j between maxy and  start***/
***************************************************************/
sort newcl year

*initialize objects*
local obs=0
quietly: gen samptemp=.
matrix def Num1=J(`num_seqexg', 1, 0)
matrix def Num2=J(`num_seqexg', `num_seqexg', 0) 
matrix def Den1=J(`num_seqexg', `num_seqexg', 0) 

forvalues maxyear=`ystart'(1)`yfinal'{

	local maxinst=`maxyear'-`ydeep' /*deeper gmm lags until ydeep. Warning: many of these instruments may be zero if no data*/
	local maxtrunc=min(`truncate',`maxinst')
	local j=`maxyear'-1960+1

	*ivreg to check for collinearities and obtain degree of overidentification*
	cap ivreg2 h_`yvar' (`seqexg_helm'=l(1/`maxinst').(`gmmlist') l(1/`maxtrunc').(`gmmlist_trunc'))  if year==`maxyear',   noid  noconstant

	if _rc==0{
		/*Runs k-class estimator*/
		local lambda=1+e(sargandf)/e(N)
		cap ivreg2 h_`yvar' (`seqexg_helm'=l(1/`maxinst').(`gmmlist') l(1/`maxtrunc').(`gmmlist_trunc'))  if year==`maxyear',  k(`lambda') nocollin coviv  noid noconstant

		if _rc==0{
			quietly: replace samptemp=e(sample) if year==`maxyear'
			local mobs=e(N)
			local obs=`obs'+`mobs'

			/*Construct locals with restrictions*/
			local restriction
			local mresults
			forvalues m=1(1)`num_seqexg'{
				local restriction `restriction' & _b[h_seqexg`m']!=0
				local mresults `mresults' (seqexg`m': _b[h_seqexg`m'])
			}

			/*Extracts results and weights them by the adjusted variance*/
			if _rc==0   `restriction'  {
				quietly: nlcom `mresults', post
				matrix b=e(b)
				matrix V=e(V)
				cap matrix Num1=Num1+`mobs'*inv(V)*b'
				cap matrix Num2=Num2+`mobs'^2*inv(V)
				cap matrix Den1=Den1+`mobs'*inv(V)
			}
		}
	}
}

/******************Compiles results and post them******************/
matrix est2top=inv(Den1)*Num1
matrix var2top=inv(Den1)*Num2*inv(Den1)
matrix b=est2top'
matrix V=var2top
mat colnames b = `seqexg' 
mat colnames V = `seqexg' 
mat rownames V = `seqexg' 
/*Countries in sample*/
quietly: bysort newcl: egen newsamp=max(samptemp)
quietly: replace newsamp=0 if newsamp!=1
/*Post estimation results*/
ereturn post b V, obs(`obs') depname("Dep var") esample(newsamp)

drop tsample samptemp id  h_`yvar' `seqexg_helm'  `gmmlist' `gmmlist_trunc' 
end


**********************************************
* HHK code ends
**********************************************

**********************************************
* OLS Regression table 1
**********************************************
* ANRR
**************
* Within estimates
**************
* Column 1
/*
ren dem indvar1

qui xtreg y l(1/4).y indvar1 yy*, fe r cluster(wbcode2) 
eststo esta1
eststo nlc1
nlcom (shortrun: _b[indvar1])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa1

* Column 2
gen dem1_group1=indvar1
gen dem1_group2=indvar1*group2
gen dem1_group3=indvar1*group3

qui xtreg y l(1/4).y dem1_group1 dem1_group2 dem1_group3 yy*, fe r cluster(wbcode2)
eststo esta2
eststo nlc2
* Long-run effect of group 1
nlcom (shortrun: _b[dem1_group1])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa2_1 
* Long-run effect of group 2
qui xtreg y l(1/4).y dem1_group1 dem1_group2 dem1_group3 yy*, fe r cluster(wbcode2)
nlcom (shortrun: _b[dem1_group2])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa2_2
* Long-run effect of group 3
qui xtreg y l(1/4).y dem1_group1 dem1_group2 dem1_group3 yy*, fe r cluster(wbcode2)
nlcom (shortrun: _b[dem1_group3])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa2_3

**************
* GMM
**************
* Column 3
qui xtabond2 y l(1/4).y indvar1 yy*, gmmstyle(y, laglimits(2 .)) ///
	gmmstyle(indvar1, laglimits(1 .)) ivstyle(yy*, p) noleveleq robust nodiffsargan
eststo esta3
eststo nlc3
nlcom (shortrun: _b[indvar1])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa3

* Column 4
qui xtabond2 y l(1/4).y dem1_group1 dem1_group2 dem1_group3 yy*, gmmstyle(y, laglimits(2 .)) ///
	gmmstyle(indvar1 dem1_group2 dem1_group3, laglimits(1 .)) ivstyle(yy*, p) ///
	noleveleq robust nodiffsargan
eststo esta4
eststo nlc4
* Long-run effect of group 1
nlcom (shortrun: _b[dem1_group1])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa4_1 
* Long-run effect of group 2
qui xtabond2 y l(1/4).y dem1_group1 dem1_group2 dem1_group3 yy*, gmmstyle(y, laglimits(2 .)) ///
	gmmstyle(indvar1 dem1_group2 dem1_group3, laglimits(1 .)) ivstyle(yy*, p) ///
	noleveleq robust nodiffsargan
nlcom (shortrun: _b[dem1_group2])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa4_2
* Long-run effect of group 3
qui xtabond2 y l(1/4).y dem1_group1 dem1_group2 dem1_group3 yy*, gmmstyle(y, laglimits(2 .)) ///
	gmmstyle(indvar1 dem1_group2 dem1_group3, laglimits(1 .)) ivstyle(yy*, p) ///
	noleveleq robust nodiffsargan
nlcom (shortrun: _b[dem1_group3])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa4_3

ren indvar1 dem
drop dem1_group1 dem1_group2 dem1_group3
*/
**************
* HHK
**************
* Column 5
ren dem indvar1

sort wbcode2 year
gen newcl=wbcode2
tsset newcl year

// gen L1_y=L1.y
// gen L2_y=L2.y
// gen L3_y=L3.y
// gen L4_y=L4.y
//reps(`rep
bootstrap _b, seed(12345) reps(`repsBS') cluster(wbcode2) idcluster(newcl):  hhkBS y (dem L1.y L2.y L3.y L4.y) (y dem) () (yy*), ydeep(1960) ystart(1964) yfinal(2009) truncate(4)

estimates store e3md
nlcom (shortrun: _b[indvar1])  (lag1: _b[L.y])  (lag2: _b[L2.y])  (lag3: _b[L3.y])  (lag4: _b[L4.y]), post
vareffects
eststo vareffectsa5
//estimates store e3md_add



* Column 6
gen dem1_group1=indvar1
gen dem1_group2=indvar1*group2
gen dem1_group3=indvar1*group3

sort wbcode2 year
replace newcl=wbcode2
tsset newcl year

bootstrap _b, seed(12345) reps(`repsBS') cluster(wbcode2) idcluster(newcl):  hhkBS y (dem1_group1 dem1_group2 ///
	dem1_group3 L1.y L2.y L3.y L4.y) (y dem1_group1 dem1_group2 dem1_group3) () (yy*), ydeep(1960) ystart(1964) ///
	yfinal(2009) truncate(4)
estimates store e3md







**********************************************
* Democracy experience
**********************************************
* Column 7
ren x1 indvar1
qui xtreg y l(1/4).y indvar1 yy*, fe r cluster(wbcode2)
eststo estd1
eststo nlc5

* Column 8
ren x2 indvar2
qui xtreg y l(1/4).y indvar1 indvar2 yy*, fe r cluster(wbcode2)
eststo estd2
qui nlcom (all:-_b[indvar1]/(2*_b[indvar2])), post
eststo nlc6

* Column 9
gen dem1_group1=indvar1
gen dem2_group1=indvar2
gen dem1_group2=indvar1*group2
gen dem2_group2=indvar2*group2
gen dem1_group3=indvar1*group3
gen dem2_group3=indvar2*group3

qui xtreg y l(1/4).y dem1_group1 dem2_group1 dem1_group2 dem2_group2 dem1_group3 ///
	dem2_group3 yy*, fe r cluster(wbcode2)
eststo estd3
qui nlcom 	(group1:-_b[dem1_group1]/(2*_b[dem2_group1]))  ///
			(group2:-_b[dem1_group2]/(2*_b[dem2_group2])) ///
			(group3:-_b[dem1_group3]/(2*_b[dem2_group3])), post
eststo nlc7

* GMM
* Column 10
qui xtabond2 y l(1/4).y indvar1 yy*, gmmstyle(y, laglimits(2 .)) ///
	gmmstyle(indvar1, laglimits(1 .)) ivstyle(yy*, p) noleveleq robust nodiffsargan
eststo estd4
eststo nlc8

* Column 11
qui xtabond2 y l(1/4).y indvar1 indvar2 yy*, gmmstyle(y, laglimits(2 .)) ///
	gmmstyle(indvar1 indvar2, laglimits(1 .)) ivstyle(yy*, p) noleveleq robust nodiffsargan
eststo estd5
qui nlcom (all:-_b[indvar1]/(2*_b[indvar2])), post
eststo nlc9

* Column 12
qui xtabond2 y l(1/4).y dem1_group1 dem2_group1 dem1_group2 dem2_group2 dem1_group3 dem2_group3 ///
	yy*, gmmstyle(y, laglimits(2 .)) gmmstyle(indvar1 indvar2 dem1_group2 dem2_group2 ///
	dem1_group3 dem2_group3, laglimits(1 .)) ivstyle(yy*, p) noleveleq robust nodiffsargan
eststo estd6
qui nlcom 	(group1:-_b[dem1_group1]/(2*_b[dem2_group1])) ///
			(group2:-_b[dem1_group2]/(2*_b[dem2_group2])) ///
			(group3:-_b[dem1_group3]/(2*_b[dem2_group3])), post
eststo nlc10
ren indvar1 x1
ren indvar2 x2
drop dem1_group1 dem2_group1 dem1_group2 dem2_group2 dem1_group3 dem2_group3


**********************************************
************ HHK******************************
**********************************************

/*
* Column 13
ren x1 indvar1

sort wbcode2 year
gen newcl=wbcode2
tsset newcl year

bootstrap _b, seed(12345) reps(`repsBS') cluster(wbcode2) idcluster(newcl):  hhkBS y (indvar1 ///
	L1.y L2.y L3.y L4.y) (y indvar1) () (yy*), ydeep(1960) ystart(1964) yfinal(2009) truncate(4)
estimates store e3md

* Column 14
ren x2 indvar2

sort wbcode2 year
replace newcl=wbcode2
tsset newcl year

bootstrap _b, seed(12345) reps(`repsBS') cluster(wbcode2) idcluster(newcl):  hhkBS y (indvar1 indvar2 ///
	L1.y L2.y L3.y L4.y) (y indvar1 indvar2) () (yy*), ydeep(1960) ystart(1964) yfinal(2009) truncate(4)
estimates store e3md

* Column 15
gen dem1_group1=indvar1
gen dem2_group1=indvar2
gen dem1_group2=indvar1*group2
gen dem2_group2=indvar2*group2
gen dem1_group3=indvar1*group3
gen dem2_group3=indvar2*group3

sort wbcode2 year
replace newcl=wbcode2
tsset newcl year

bootstrap _b, seed(12345) reps(`repsBS') cluster(wbcode2) idcluster(newcl):  hhkBS y (dem1_group1 dem2_group1 ///
	dem1_group2 dem2_group2 dem1_group3 dem2_group3 L1.y L2.y L3.y L4.y) (y dem1_group1 dem2_group1 ///
	dem1_group2 dem2_group2 dem1_group3 dem2_group3) () (yy*), ydeep(1960) ystart(1964) yfinal(2009) truncate(4)
estimates store e3md
*/
**********************************************
/* Table output in csv */
**********************************************
* Panel A
estout esta1 esta2 esta3 esta4 estd1 estd2 estd3 estd4 estd5 estd6 using ///
	"${results}table_2.csv", replace  ///
	style(tab) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(indvar1 "\vspace*{-2mm}\shortstack[l]{democracy}" ///
		indvar2 "\vspace*{-2mm}\shortstack[l]{democracy squared}" ///
		dem1_group1 "\vspace*{-2mm}\hphantom{a} democracy" ///
		dem2_group1 "\vspace*{-2mm}\hphantom{a} democracy squared" ///
		dem1_group2 "\vspace*{-2mm}\hphantom{a} democracy" ///
		dem2_group2 "\vspace*{-2mm}\hphantom{a} democracy squared" ///
		dem1_group3 "\vspace*{-2mm}\hphantom{a} democracy" ///
		dem2_group3 "\vspace*{-2mm}\hphantom{a} democracy squared", ///
			elist(dem2_group3 \addlinespace)) ///
	refcat(dem1_group1 "\vspace*{-2mm}Western Europe and other developed countries _" ///
		dem1_group2 "\vspace*{-2mm}Africa and South Asia _" ///
		dem1_group3 "\vspace*{-2mm}Other countries _", nolabel) ///
	stats(N N_g, fmt(0 0) ///
		labels( "Observations" "Countries in sample" ))  ///
	order(indvar1 indvar2 dem1_group1 dem2_group1 dem1_group2 dem2_group2 ///
		dem1_group3 dem2_group3) ///
	keep(indvar1 indvar2 dem1_group1 dem2_group1 dem1_group2 dem2_group2 ///
		dem1_group3 dem2_group3)  ///
	eqlabels(none) sub(_ $\times$) starlevels(* 0.05)

* Panel B
* turning points in years
estout nlc1 nlc2 nlc3 nlc4 nlc5 nlc6 nlc7 nlc8 nlc9 nlc10 using ///
	"${results}table_2_nl.csv", replace  ///
	style(tab) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(all "\vspace*{-2mm}\shortstack[l]{All countries}" ///
		group1 "\vspace*{-2mm}\shortstack[l]{Western Europe and other developed countries}" ///
		group2 "\vspace*{-2mm}\shortstack[l]{Africa and South Asia}" ///
		group3 "\vspace*{-2mm}\shortstack[l]{Other countries}") ///
	order(all group1 group2 group3) ///
	keep(all group1 group2 group3)  eqlabels(none) starlevels(* 0.05)

**************************
