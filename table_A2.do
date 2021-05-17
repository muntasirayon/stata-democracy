*******************************************
/* Table 4 : ANRR vs Demex IV*/
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
// ren demreg iv1
// qui xtivreg2 y l(1/4).y (dem=l.iv1) yy*, fe r cluster(wbcode2) partial(yy*) ///
// 	savefirst savefprefix(firstA1)
// ren iv1 demreg

* Column 1
* ANRR standardized
ren n_dem demstd1
ren n_demreg iv1 
qui xtivreg2 y l(1/4).y (demstd1=l.iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) first ffirst savefirst savefprefix(firstA2)
eststo c1
matrix mc1=e(first)
qui estadd scalar fdem1g1=mc1[4,1], replace

* Column 2
* ANRR standardized+region dummy
gen demstd1_group2=demstd1*group2
gen demstd1_group3=demstd1*group3
gen iv1_group2=iv1*group2
gen iv1_group3=iv1*group3
qui xtivreg2 y l(1/4).y (demstd1 demstd1_group2 demstd1_group3=l.iv1 ///
	l.iv1_group2 l.iv1_group3) yy*, fe r cluster(wbcode2) partial(yy*) ///
	savefirst savefprefix(firstA3)
eststo c2
matrix mc2=e(first)
qui estadd scalar fdem1g1=mc2[4,1], replace
qui estadd scalar fdem1g2=mc2[4,2], replace
qui estadd scalar fdem1g3=mc2[4,3], replace
qui estadd scalar apdem1g1=mc2[15,1], replace
qui estadd scalar apdem1g2=mc2[15,2], replace
qui estadd scalar apdem1g3=mc2[15,3], replace

* Column 3
* ANRR standardized+region dummy+ 4 lagged waves
qui xtivreg2 y l(1/4).y (demstd1 demstd1_group2 demstd1_group3=l(1/4).iv1 ///
	l(1/4).iv1_group2 l(1/4).iv1_group3) yy*, fe r cluster(wbcode2) partial(yy*) ///
	savefirst savefprefix(firstA4)
eststo c3
matrix mc3=e(first)
qui estadd scalar fdem1g1=mc3[4,1], replace
qui estadd scalar fdem1g2=mc3[4,2], replace
qui estadd scalar fdem1g3=mc3[4,3], replace
qui estadd scalar apdem1g1=mc3[15,1], replace
qui estadd scalar apdem1g2=mc3[15,2], replace
qui estadd scalar apdem1g3=mc3[15,3], replace
ren iv1 n_demreg
ren demstd1 n_dem
drop demstd1_group2 demstd1_group3 iv1_group2 iv1_group3

*********************************
* Democracy Experience
*********************************
* Column 4 : linear
ren n_x1 demstd1
ren n_z1 iv1
qui xtivreg2 y l(1/4).y (demstd1=l.iv1) ///
	yy*, fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD1)
eststo c4
matrix mc4=e(first)
qui estadd scalar fdem1g1=mc4[4,1], replace
	
* Column 5 : non-linear
ren n_x2 demstd2
ren n_z2 iv2
qui xtivreg2 y l(1/4).y (demstd1 demstd2=l.iv1 l.iv2) group1 yy*, ///
	fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD2)
eststo c5
matrix mc5=e(first)
qui estadd scalar fdem1g1=mc5[4,1], replace
qui estadd scalar fdem2g1=mc5[4,2], replace
qui estadd scalar apdem1g1=mc5[15,1], replace
qui estadd scalar apdem2g1=mc5[15,2], replace

* Column 6 : non-linear+region dummy
gen demstd1_group2=demstd1*group2 
gen demstd1_group3=demstd1*group3 
gen iv1_group2=iv1*group2   
gen iv1_group3=iv1*group3   
gen demstd2_group2=demstd2*group2
gen demstd2_group3=demstd2*group3 
gen iv2_group2=iv2*group2 
gen iv2_group3=iv2*group3 

qui xtivreg2 y l(1/4).y (demstd1 demstd2 demstd1_group2 demstd2_group2 ///
	demstd1_group3 demstd2_group3=l.iv1 l.iv2 l.iv1_group2 l.iv2_group2 ///
	l.iv1_group3 l.iv2_group3) yy*, fe r cluster(wbcode2) partial(yy*) ///
	savefirst savefprefix(firstD3)
/* add "first ffirst" to get the first-stage estimates
to get Angrist-Pischke F-stat: matrix list e(first) */
eststo c6
matrix mc6=e(first)
qui estadd scalar fdem1g1=mc6[4,1], replace
qui estadd scalar fdem2g1=mc6[4,2], replace
qui estadd scalar fdem1g2=mc6[4,3], replace
qui estadd scalar fdem2g2=mc6[4,4], replace
qui estadd scalar fdem1g3=mc6[4,5], replace
qui estadd scalar fdem2g3=mc6[4,6], replace
qui estadd scalar apdem1g1=mc6[15,1], replace
qui estadd scalar apdem2g1=mc6[15,2], replace
qui estadd scalar apdem1g2=mc6[15,3], replace
qui estadd scalar apdem2g2=mc6[15,4], replace
qui estadd scalar apdem1g3=mc6[15,5], replace
qui estadd scalar apdem2g3=mc6[15,6], replace

* Column 7 : non-linear+region dummy
qui xtivreg2 y l(1/4).y (demstd1 demstd2 demstd1_group2 demstd2_group2 ///
	demstd1_group3 demstd2_group3=l(1/4).iv1 l(1/4).iv2 l(1/4).iv1_group2 ///
	l(1/4).iv2_group2 l(1/4).iv1_group3 l(1/4).iv2_group3) yy*, fe r ///
	cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD4)
eststo c7
matrix mc7=e(first)
qui estadd scalar fdem1g1=mc7[4,1], replace
qui estadd scalar fdem2g1=mc7[4,2], replace
qui estadd scalar fdem1g2=mc7[4,3], replace
qui estadd scalar fdem2g2=mc7[4,4], replace
qui estadd scalar fdem1g3=mc7[4,5], replace
qui estadd scalar fdem2g3=mc7[4,6], replace
qui estadd scalar apdem1g1=mc7[15,1], replace
qui estadd scalar apdem2g1=mc7[15,2], replace
qui estadd scalar apdem1g2=mc7[15,3], replace
qui estadd scalar apdem2g2=mc7[15,4], replace
qui estadd scalar apdem1g3=mc7[15,5], replace
qui estadd scalar apdem2g3=mc7[15,6], replace
ren iv1 n_z1
ren iv2 n_z2
ren demstd1 n_x1
ren demstd2 n_x2
drop demstd1_group2 demstd2_group2 demstd1_group3 demstd2_group3 iv1_group2 ///
	iv2_group2 iv1_group3 iv2_group3

**********************************************
/* Table output in tex */
**********************************************
* Panel 1: democracy
estout firstA2demstd1 firstA3demstd1 firstA4demstd1 ///
	firstD1demstd1 firstD2demstd1 firstD3demstd1 firstD4demstd1 using ///
	"${results}table_A2_p1.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-1}}" ///
		L2.iv1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-2}}" ///
		L3.iv1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-3}}" ///
		L4.iv1 "\vspace*{-2mm}Democracy wave standardized\textsubscript{\textit{t-4}}" ) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	order(L.iv1 L2.iv1 L3.iv1 L4.iv1) ///
	keep(L.iv1 L2.iv1 L3.iv1 L4.iv1) ///
	sub(_ $\times$) starlevels(* 0.05)

* Panel 1: f-stats
estout c1 c2 c3 c4 c5 c6 c7 using ///
	"${results}table_A2_p1_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	stats(fdem1g1 apdem1g1, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 L.y L2.y L3.y L4.y demstd1_group2 demstd1_group3 demstd2 ///
		demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)

* Panel 2: democracy x group 2
estout firstA2demstd1 firstA3demstd1_group2 firstA4demstd1_group2 firstD1demstd1 ///
	firstD2demstd1 firstD3demstd1_group2 firstD4demstd1_group2 using ///
	"${results}table_A2_p2.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv1_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-1}}" ///
		L2.iv1_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-2}}" ///
		L3.iv1_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-3}}" ///
		L4.iv1_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-4}}") ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	order(L.iv1_group2 L2.iv1_group2 L3.iv1_group2 L4.iv1_group2) ///
	keep(L.iv1_group2 L2.iv1_group2 L3.iv1_group2 L4.iv1_group2) ///
	sub(_ $\times$) starlevels(* 0.05)	

* Panel 2: f-stats
estout c1 c2 c3 c4 c5 c6 c7 using ///
	"${results}table_A2_p2_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	stats(fdem1g2 apdem1g2, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 L.y L2.y L3.y L4.y demstd1_group2 demstd1_group3 demstd2 ///
		demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* Panel 3: democracy x group 3
estout firstA2demstd1 firstA3demstd1_group3 firstA4demstd1_group3 firstD1demstd1 ///
	firstD2demstd1 firstD3demstd1_group3 firstD4demstd1_group3 using ///
	"${results}table_A2_p3.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv1_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-1}}" ///
		L2.iv1_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-2}}" ///
		L3.iv1_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-3}}" ///
		L4.iv1_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave standardized\textsubscript{\textit{t-4}}") ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	order(L.iv1_group3 L2.iv1_group3 L3.iv1_group3 L4.iv1_group3) ///
	keep(L.iv1_group3 L2.iv1_group3 L3.iv1_group3 L4.iv1_group3) ///
	sub(_ $\times$) starlevels(* 0.05)

* Panel 3: f-stats
estout c1 c2 c3 c4 c5 c6 c7 using ///
	"${results}table_A2_p3_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	stats(fdem1g3 apdem1g3, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 L.y L2.y L3.y L4.y demstd1_group2 demstd1_group3 demstd2 ///
		demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)

**************************************
* Squared terms
* Panel 4: democracy squared
estout firstA2demstd1 firstA3demstd1 firstA4demstd1 ///
	firstD1demstd1 firstD2demstd2 firstD3demstd2 firstD4demstd2 using ///
	"${results}table_A2_p4.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv2 "\vspace*{-2mm}Democracy wave sq. standardized\textsubscript{\textit{t-1}}" ///
		L2.iv2 "\vspace*{-2mm}Democracy wave sq. standardized\textsubscript{\textit{t-2}}" ///
		L3.iv2 "\vspace*{-2mm}Democracy wave sq. standardized\textsubscript{\textit{t-3}}" ///
		L4.iv2 "\vspace*{-2mm}Democracy wave sq. standardized\textsubscript{\textit{t-4}}" ) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	order(L.iv2 L2.iv2 L3.iv2 L4.iv2) ///
	keep(L.iv2 L2.iv2 L3.iv2 L4.iv2) ///
	sub(_ $\times$) starlevels(* 0.05)

* Panel 4: f-stats
estout c1 c2 c3 c4 c5 c6 c7 using ///
	"${results}table_A2_p4_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	stats(fdem2g1 apdem2g1, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 L.y L2.y L3.y L4.y demstd1_group2 demstd1_group3 demstd2 ///
		demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* Panel 5: democracy squared x group 1
estout firstA2demstd1 firstA3demstd1 firstA4demstd1 ///
	firstD1demstd1 firstD2demstd1 firstD3demstd2_group2 firstD4demstd2_group2 using ///
	"${results}table_A2_p5.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv2_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-1}}" ///
		L2.iv2_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-2}}" ///
		L3.iv2_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-3}}" ///
		L4.iv2_group2 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-4}}" ) ///
	refcat(L.iv2_group2 "Africa and South Asia _" L.iv2_group3 ///
		"Other countries _", nolabel) ///
	order(L.iv2_group2 L2.iv2_group2 L3.iv2_group2 L4.iv2_group2) ///
	keep(L.iv2_group2 L2.iv2_group2 L3.iv2_group2 L4.iv2_group2) ///
	sub(_ $\times$) starlevels(* 0.05)

* Panel 5: f-stats
estout c1 c2 c3 c4 c5 c6 c7 using ///
	"${results}table_A2_p5_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	stats(fdem2g2 apdem2g2, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 L.y L2.y L3.y L4.y demstd1_group2 demstd1_group3 demstd2 ///
		demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* Panel 6: democracy squared x group 2
estout firstA2demstd1 firstA3demstd1 firstA4demstd1 ///
	firstD1demstd1 firstD2demstd1 firstD3demstd2_group3 firstD4demstd2_group3 using ///
	"${results}table_A2_p6.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv2_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-1}}" ///
		L2.iv2_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-2}}" ///
		L3.iv2_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-3}}" ///
		L4.iv2_group3 "\vspace*{-2mm}\hphantom{a} Democracy wave sq. standardized\textsubscript{\textit{t-4}}" ) ///
	refcat(L.iv2_group2 "Africa and South Asia _" L.iv2_group3 ///
		"Other countries _", nolabel) ///
	order(L.iv2_group3 L2.iv2_group3 L3.iv2_group3 L4.iv2_group3) ///
	keep(L.iv2_group3 L2.iv2_group3 L3.iv2_group3 L4.iv2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* Panel 6: f-stats
estout c1 c2 c3 c4 c5 c6 c7 using ///
	"${results}table_A2_p6_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	refcat(L.iv1_group2 "Africa and South Asia _" L.iv1_group3 ///
		"Other countries _", nolabel) ///
	stats(fdem2g3 apdem2g3, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(demstd1 L.y L2.y L3.y L4.y demstd1_group2 demstd1_group3 demstd2 ///
		demstd2_group2 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)
