*******************************************
/* Table 4 : ANRR vs Demex IV without region*/
*******************************************
set more off

**********************************************
eststo clear
estimates drop _all
**********************************************
* 2SLS Regression table 1
**********************************************
* Column 1
* ANRR original
ren dem indvar
ren demreg iv1
qui xtivreg2 y l(1/4).y (indvar=l.iv1) yy*, fe r cluster(wbcode2) partial(yy*) ///
	savefirst savefprefix(firstA1)
eststo esta1
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc1

* Column 2
* ANRR original+ 4 lagged waves
qui xtivreg2 y l(1/4).y (indvar=l(1/4).iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstA2)
eststo esta2
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren indvar dem
ren iv1 demreg
eststo nlc2

* Column 3
* ANRR standardized
ren n_dem demstd1
ren n_demreg iv1 
qui xtivreg2 y l(1/4).y (demstd1=l.iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstA3)
eststo esta3
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc3

* Column 4
* ANRR standardized+ 4 lagged waves
qui xtivreg2 y l(1/4).y (demstd1=l(1/4).iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstA4)
eststo esta4
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren iv1 n_demreg
ren demstd1 n_dem
eststo nlc4

*********************************
* Democracy Experience
*********************************
* Column 5 : demex original
ren x1 indvar
ren z1 iv1
qui xtivreg2 y l(1/4).y (indvar=l.iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstD1)
eststo estd1
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc5

* Column 6 : demex original+ 4 lagged waves
qui xtivreg2 y l(1/4).y (indvar=l(1/4).iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstD2)
eststo estd2
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren indvar x1
ren iv1 z1
eststo nlc6

* Column 7 : demex standardized
ren n_x1 demstd1
ren n_z1 iv1
qui xtivreg2 y l(1/4).y (demstd1=l.iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstD3)
eststo estd3
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc7

* Column 8 : demex standardized+ 4 lagged waves
qui xtivreg2 y l(1/4).y (demstd1=l(1/4).iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstD4)
eststo estd4
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc8

* Column 9 : demex non-linear
ren n_x2 demstd2
ren n_z2 iv2
qui xtivreg2 y l(1/4).y (demstd1 demstd2=l.iv1 l.iv2) group1 yy*, ///
	fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD5)
eststo estd5
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom (all:-_b[demstd1]/(2*_b[demstd2])), post
eststo nlc9

* Column 10 : demex non-linear+ 4 lagged waves
qui xtivreg2 y l(1/4).y (demstd1 demstd2=l(1/4).iv1 l(1/4).iv2) yy*, ///
	fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD6)
eststo estd6
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren demstd1 n_x1
ren iv1 n_z1
ren demstd2 n_x2
ren iv2 n_z2
qui nlcom (all:-_b[demstd1]/(2*_b[demstd2])), post
eststo nlc10

**********************************************
/* Table output in tex */
**********************************************
* Second-stage
estout esta1 esta2 esta3 esta4 estd1 estd2 estd3 estd4 estd5 estd6 using ///
	"${results}table_3_second.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(indvar "\shortstack{Democracy}" ///
		demstd1 "\shortstack[l]{Democracy standardized}" ///
		demstd2 "\shortstack[l]{Democracy squared standardized}" ) ///
	stats(N N_g, fmt(%9.0g %9.0g) ///
		labels( "Observations" "Countries in sample"))  ///
	order(indvar demstd1 demstd2) ///
	keep(indvar demstd1 demstd2) ///
	sub(_ $\times$) starlevels(* 0.05)

* First-stage
estout firstA1indvar firstA2indvar firstA3demstd1 firstA4demstd1 ///
	firstD1indvar firstD2indvar firstD3demstd1 firstD4demstd1 firstD5demstd1 ///
	firstD6demstd1 using ///
	"${results}table_3_first.tex", replace ///
	style(tex) nolabel mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv1 "Democracy wave standardized\textsubscript{\textit{t-1}}" ///
		L2.iv1 "Democracy wave standardized\textsubscript{\textit{t-2}}" ///
		L3.iv1 "Democracy wave standardized\textsubscript{\textit{t-3}}" ///
		L4.iv1 "Democracy wave standardized\textsubscript{\textit{t-4}}" ) ///
	keep(L.iv1 L2.iv1 L3.iv1 L4.iv1) sub(_ \textsubscript{\textit{t-1}}) ///
	starlevels(* 0.05)
	
* f-stats
estout esta1 esta2 esta3 esta4 estd1 estd2 estd3 estd4 estd5 estd6 using ///
	"${results}table_3_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	stats(fs apf, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(indvar demstd1 demstd2 L.y L2.y L3.y L4.y) ///
	sub(_ $\times$) starlevels(* 0.05)

* turning points in years
estout nlc1 nlc2 nlc3 nlc4 nlc5 nlc6 nlc7 nlc8 nlc9 nlc10 using ///
	"${results}table_3_nl.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(all "\shortstack[l]{ }") ///
	keep(all)  eqlabels(none) starlevels(* 0.05)
