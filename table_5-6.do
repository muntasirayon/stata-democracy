*******************************************
/* Table 3: Democracy Experience on potential mechanisms of economic growth*/
*******************************************
set more off
set matsize 1000
**********************************************

eststo clear
estimates drop _all
**********************************************
* Regression table 
**********************************************
gen x1_group2=x1*group2
gen x2_group2=x2*group2
gen x1_group3=x1*group3
gen x2_group3=x2*group3

gen z1_group2=z1*group2 
gen z2_group2=z2*group2
gen z1_group3=z1*group3 
gen z2_group3=z2*group3

* Column 1: INVESTMENT
gen depvar=loginvpc
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est1ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols1
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est1iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv1

* Column 2: TFP
gen depvar=ltfp
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est2ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols2
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst  partial(yy*)
eststo est2iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv2

* Column 3: MARKET REFORMS
gen depvar=marketref
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est3ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols3
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est3iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv3

* Column 4: TRADE SHARE
gen depvar=ltrade
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est4ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols4
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est4iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv4

* Column 5: GOVERNMENT EXPENDITURE
gen depvar=lgov
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est5ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols5
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est5iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv5

* Column 6: PRIMARY ENROLLMENT
gen depvar=lprienr
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est6ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols6
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est6iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv6

* Column 7: SECONDARY ENROLLMENT
gen depvar=lsecenr
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est7ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols7
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est7iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv7

* Column 8: CHILD MORTALITY
gen depvar=lmort
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est8ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols8
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est8iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv8

* Column 9: RIOTS AND REVOLUTIONS
gen depvar=unrestn
* OLS
qui xtreg depvar l(1/4).depvar l(1/4).y x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3 yy*, fe r cluster(wbcode2)
eststo est9ols
qui sum depvar
qui estadd scalar dvmean=r(mean)
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlols9
* 2SLS
qui xtivreg2 depvar l(1/4).depvar l(1/4).y (x1 x2 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) yy*, ///
	fe r cluster(wbcode2) savefirst partial(yy*)
eststo est9iv
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui sum depvar
qui estadd scalar dvmean=r(mean)
drop depvar
qui nlcom 	(group1:-_b[x1]/(2*_b[x2])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nliv9

*******
drop x1_group2 x2_group2 x1_group3 x2_group3 z1_group2 z2_group2 z1_group3 z2_group3

**********************************************
/* Table output in tex */
**********************************************
* OLS: table 5
* Panel A
estout est1ols est2ols est3ols est4ols est5ols est6ols est7ols est8ols ///
	est9ols using ///
	"${results}table_5_ols.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(x1 "\vspace*{-2mm}\hphantom{a} Democracy" ///
			x2 	"\vspace*{-2mm}\hphantom{a} Democracy squared" ///
			x1_group2 "\vspace*{-2mm}\hphantom{a} Democracy" ///
			x2_group2 "\vspace*{-2mm}\hphantom{a} Democracy squared" ///
			x1_group3 "\vspace*{-2mm}\hphantom{a} Democracy" ///
			x2_group3 "\vspace*{-2mm}\hphantom{a} Democracy squared" ) ///
	refcat(x1 "\vspace*{3mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \hphantom{a} developed countries _}}" ///
		x1_group2 "Africa and South Asia _" ///
		x1_group3 "Other countries _", nolabel) ///
	order(x1 x2 x1_group2 x2_group2 x1_group3 x2_group3) ///
	stats(N N_g dvmean, fmt(%9.0g %9.0g %9.1f) ///
		labels( "Observations" "Countries in sample" "Sample mean"))  ///
	keep(x1 x2 x1_group2 x2_group2 x1_group3 x2_group3)  eqlabels(none) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* Panel B
* turning points in years
estout nlols1 nlols2 nlols3 nlols4 nlols5 nlols6 nlols7 nlols8 nlols9 using ///
	"${results}table_5_nl.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(group1 "\vspace*{-2mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \vspace*{2mm}\hphantom{a} developed countries}}" ///
		group2 "\vspace*{-2mm}\shortstack[l]{Africa and South Asia}" ///
		group3 "\vspace*{-2mm}\shortstack[l]{Other countries}") ///
	order(group1 group2 group3) ///
	keep(group1 group2 group3)  eqlabels(none) starlevels(* 0.05)

**********************************************
* 2SLS: table 6
* Panel A
estout est1iv est2iv est3iv est4iv est5iv est6iv est7iv est8iv est9iv using ///
	"${results}table_6_2sls.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(x1 "\vspace*{-2mm}\hphantom{a} Democracy" ///
			x2 	"\vspace*{-2mm}\hphantom{a} Democracy squared" ///
			x1_group2 "\vspace*{-2mm}\hphantom{a} Democracy" ///
			x2_group2 "\vspace*{-2mm}\hphantom{a} Democracy squared" ///
			x1_group3 "\vspace*{-2mm}\hphantom{a} Democracy" ///
			x2_group3 "\vspace*{-2mm}\hphantom{a} Democracy squared" ) ///
	refcat(x1 "\vspace*{3mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \hphantom{a} developed countries _}}" ///
		x1_group2 "Africa and South Asia _" ///
		x1_group3 "Other countries _", nolabel) ///
	order(x1 x2 x1_group2 x2_group2 x1_group3 x2_group3) ///
	stats(N N_g dvmean, fmt(%9.0g %9.0g %9.1f) ///
		labels( "Observations" "Countries in sample" "Sample mean"))  ///
	keep(x1 x2 x1_group2 x2_group2 x1_group3 x2_group3)  eqlabels(none) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* f-stats
estout est1iv est2iv est3iv est4iv est5iv est6iv est7iv est8iv est9iv using ///
	"${results}table_6_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	stats(fs apf, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(x1 x2 L.y L2.y L3.y L4.y L.depvar L2.depvar L3.depvar L4.depvar x1_group2 x1_group3 x2_group2 ///
		x2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)

* Panel B
* turning points in years
estout nliv1 nliv2 nliv3 nliv4 nliv5 nliv6 nliv7 nliv8 nliv9 using ///
	"${results}table_6_nl.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(group1 "\vspace*{-2mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \vspace*{2mm}\hphantom{a} developed countries}}" ///
		group2 "\vspace*{-2mm}\shortstack[l]{Africa and South Asia}" ///
		group3 "\vspace*{-2mm}\shortstack[l]{Other countries}") ///
	order(group1 group2 group3) ///
	keep(group1 group2 group3)  eqlabels(none) starlevels(* 0.05)
