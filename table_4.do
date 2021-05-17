*******************************************
/* Table 4 : ANRR vs Demex IV with region*/
*******************************************
set more off

**********************************************
eststo clear
estimates drop _all
**********************************************
* 2SLS Regression table 1
**********************************************
* Column 1
* ANRR standardized
ren n_dem demstd1
ren n_demreg iv1_group1 
qui xtivreg2 y l(1/4).y (demstd1=l.iv1_group1) yy*, fe r cluster(wbcode2) partial(yy*) ///
	savefirst savefprefix(firstA1)
eststo esta1
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc1

* Column 2
* ANRR standardized + region dummies
gen demstd1_group1=demstd1
gen demstd1_group2=demstd1*group2
gen demstd1_group3=demstd1*group3
//gen iv1_group1=iv1_group1
gen iv1_group2=iv1_group1*group2
gen iv1_group3=iv1_group1*group3
qui xtivreg2 y l(1/4).y (demstd1_group1 demstd1_group2 demstd1_group3=l.iv1_group1 ///
	l.iv1_group2 l.iv1_group3) yy*, fe r cluster(wbcode2) partial(yy*) savefirst ///
	savefprefix(firstA2)
eststo esta2
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc2

* Column 3
* ANRR standardized + region dummies+ 4 lagged waves
qui xtivreg2 y l(1/4).y (demstd1_group1 demstd1_group2 demstd1_group3=l(1/4).iv1_group1 ///
	l(1/4).iv1_group2 l(1/4).iv1_group3) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstA3)
eststo esta3
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren iv1_group1 n_demreg
ren demstd1 n_dem
drop demstd1_group1 demstd1_group2 demstd1_group3 iv1_group2 iv1_group3
eststo nlc3

*********************************
* Democracy Experience
*********************************
* Column 4 : demex standardized
ren n_x1 demstd1
ren n_x2 demstd2
ren n_z1 iv1_group1
ren n_z2 iv2
qui xtivreg2 y l(1/4).y (demstd1 demstd2=l.iv1_group1 l.iv2) yy*, fe r ///
	cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD1)
eststo estd1
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(all:-_b[demstd1]/(2*_b[demstd2])), post
eststo nlc4

* Column 5 : demex standardized + region dummies
gen demstd1_group1=demstd1
gen demstd1_group2=demstd1*group2
gen demstd1_group3=demstd1*group3
gen demstd2_group1=demstd2
gen demstd2_group2=demstd2*group2
gen demstd2_group3=demstd2*group3
//gen iv1_group1=iv1
gen iv1_group2=iv1_group1*group2
gen iv1_group3=iv1_group1*group3
//gen iv2_group1=iv2
gen iv2_group2=iv2*group2
gen iv2_group3=iv2*group3

qui xtivreg2 y l(1/4).y (demstd1_group1 demstd2_group1 demstd1_group2 ///
	demstd2_group2 demstd1_group3 demstd2_group3=l.iv1_group1 l.iv1_group2 ///
	l.iv1_group3 l.iv2 l.iv2_group2 l.iv2_group3) yy*, fe r ///
	cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD2)
eststo estd2
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(group1:-_b[demstd1_group1]/(2*_b[demstd2_group1])) ///
			(group2:-_b[demstd1_group2]/(2*_b[demstd2_group2])) ///
			(group3:-_b[demstd1_group3]/(2*_b[demstd2_group3])), post
eststo nlc5

* Column 6 : demex standardized + region dummies + 4 lagged waves
qui xtivreg2 y l(1/4).y (demstd1_group1 demstd2_group1 demstd1_group2 ///
	demstd2_group2 demstd1_group3 demstd2_group3=l(1/4).iv1_group1 ///
	l(1/4).iv1_group2 l(1/4).iv1_group3 l(1/4).iv2 l(1/4).iv2_group2 ///
	l(1/4).iv2_group3) yy*, fe r cluster(wbcode2) partial(yy*) savefirst ///
	savefprefix(firstD3)
eststo estd3
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren demstd1 n_x1
ren demstd2 n_x2
ren iv1_group1 n_z1
ren iv2 n_z2
qui nlcom 	(group1:-_b[demstd1_group1]/(2*_b[demstd2_group1])) ///
			(group2:-_b[demstd1_group2]/(2*_b[demstd2_group2])) ///
			(group3:-_b[demstd1_group3]/(2*_b[demstd2_group3])), post
eststo nlc6
drop demstd1_group1 demstd2_group1 demstd1_group2 demstd1_group3 demstd2_group2 ///
	demstd2_group3 iv1_group2 iv1_group3 iv2_group2 iv2_group3
**********************************************
/* Table output in tex */
**********************************************
* Second-stage
estout esta1 esta2 esta3 estd1 estd2 estd3 using ///
	"${results}table_4_second.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(demstd1 "\vspace*{-2mm}\shortstack[l]{Democracy standardized}" ///
		demstd2 "\vspace*{-2mm}\shortstack[l]{Democracy squared standardized}" ///
		demstd1_group1 "\vspace*{-2mm}\hphantom{a} Democracy standardized" ///
		demstd2_group1 "\vspace*{-2mm}\hphantom{a} Democracy squared standardized" ///
		demstd1_group2 "\vspace*{-2mm}\hphantom{a} Democracy standardized" ///
		demstd2_group2 "\vspace*{-2mm}\hphantom{a} Democracy squared standardized" ///
		demstd1_group3 "\vspace*{-2mm}\hphantom{a} Democracy standardized" ///
		demstd2_group3 "\vspace*{-2mm}\hphantom{a} Democracy squared standardized", ///
			elist(dem2_group3 \addlinespace)) ///
	refcat(demstd1_group1 "Western Europe and other developed countries _" ///
		demstd1_group2 "Africa and South Asia _" ///
		demstd1_group3 "Other countries _", ///
			nolabel) ///
	stats(N N_g, fmt(0 0) ///
		labels( "Observations" "Countries in sample" ))  ///
	order(demstd1 demstd2 demstd1_group1 demstd2_group1 demstd1_group2 ///
		demstd2_group2 demstd1_group3 demstd2_group3) ///
	keep(demstd1 demstd2 demstd1_group1 demstd2_group1 demstd1_group2 ///
		demstd2_group2 demstd1_group3 demstd2_group3)  ///
	eqlabels(none) sub(_ $\times$) starlevels(* 0.05)

* First-stage
estout firstA1demstd1 firstA2demstd1_group1 firstA3demstd1_group1 ///
	firstD1demstd1 firstD2demstd1_group1 firstD3demstd1_group1 using ///
	"${results}table_4_first.tex", replace ///
	style(tex) nolabel mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv1_group1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-1}}" ///
		L2.iv1_group1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-2}}" ///
		L3.iv1_group1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-3}}" ///
		L4.iv1_group1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-4}}" ) ///
	keep(L.iv1_group1 L2.iv1_group1 L3.iv1_group1 L4.iv1_group1) ///
		sub(_ \textsubscript{\textit{t-1}}) ///
	starlevels(* 0.05)
	
* f-stats
estout esta1 esta2 esta3 estd1 estd2 estd3 using ///
	"${results}table_4_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	stats(fs apf, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 demstd2 L.y L2.y L3.y L4.y demstd1_group1 demstd2_group1 ///
		demstd1_group2 demstd1_group3 demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)

* turning points in years
estout nlc1 nlc2 nlc3 nlc4 nlc5 nlc6 using ///
	"${results}table_4_nl.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(all "\vspace*{-2mm}\shortstack[l]{All countries}" ///
		group1 "\vspace*{-2mm}\shortstack[l]{Western Europe and other developed countries}" ///
		group2 "\vspace*{-2mm}\shortstack[l]{Africa and South Asia}" ///
		group3 "\vspace*{-2mm}\shortstack[l]{Other countries}") ///
	order(all group1 group2 group3) ///
	keep(all group1 group2 group3)  eqlabels(none) starlevels(* 0.05)
