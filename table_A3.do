*******************************************
/* Table  : Comparison of IV of ANRR vs Demex*/
*******************************************
set more off

**********************************************
eststo clear
estimates drop _all
**********************************************
* 2SLS Regression table 1
**********************************************
* ANRR democracy indicator
* Column 1 
* ANRR original
ren demreg iv1
qui xtivreg2 y l(1/4).y (dem=l(1/4).iv1) yy*, ///
	fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstA1)
eststo est1
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren iv1 demreg
eststo nlc1

* Column 2
* ANRR standardized
ren n_dem demstd1
ren n_demreg iv1
qui xtivreg2 y l(1/4).y (demstd1=l(1/4).iv1) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstA2)
eststo est2
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
eststo nlc2

* Column 3
* ANRR standardized+region dummy
gen demstd1_group1=demstd1
gen demstd1_group2=demstd1*group2
gen demstd1_group3=demstd1*group3
gen iv1_group2=iv1*group2
gen iv1_group3=iv1*group3
qui 
xtivreg2 y l(1/4).y (demstd1_group1 demstd1_group2 demstd1_group3=l(1/4).iv1 ///
	l(1/4).iv1_group2 l(1/4).iv1_group3) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(firstA3)
eststo est3
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
ren iv1 n_demreg
ren demstd1 n_dem
drop demstd1_group1 demstd1_group2 demstd1_group3 iv1_group2 iv1_group3
eststo nlc3

*********************************
* Democracy Experience
*********************************
* Column 4
* Demex standardized
ren n_x1 demstd1
ren n_x2 demstd2
ren n_z1 iv1
ren n_z2 iv2
qui xtivreg2 y l(1/4).y (demstd1 demstd2=l(1/4).iv1 l(1/4).iv2) yy*, ///
	fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD1)
eststo est4
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(all:-_b[demstd1]/(2*_b[demstd2])), post
eststo nlc4

* Column 5
* Demex standardized+region dummy
gen demstd1_group1=demstd1
gen demstd1_group2=demstd1*group2 
gen demstd1_group3=demstd1*group3 
gen demstd2_group1=demstd2
gen demstd2_group2=demstd2*group2
gen demstd2_group3=demstd2*group3 
gen iv1_group2=iv1*group2   
gen iv1_group3=iv1*group3   
gen iv2_group2=iv2*group2 
gen iv2_group3=iv2*group3 

qui xtivreg2 y l(1/4).y (demstd1_group1 demstd2_group1 demstd1_group2 ///
	demstd2_group2 demstd1_group3 demstd2_group3=l(1/4).iv1 l(1/4).iv2 ///
	l(1/4).iv1_group2 l(1/4).iv2_group2 l(1/4).iv1_group3 l(1/4).iv2_group3) ///
	yy*, fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(firstD2)
eststo est5
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(group1:-_b[demstd1_group1]/(2*_b[demstd2_group1])) ///
			(group2:-_b[demstd1_group2]/(2*_b[demstd2_group2])) ///
			(group3:-_b[demstd1_group3]/(2*_b[demstd2_group3])), post
eststo nlc5

ren iv1 n_z1
ren iv2 n_z2
ren demstd1 n_x1
ren demstd2 n_x2
drop demstd1_group1 demstd2_group1 demstd1_group2 demstd2_group2 demstd1_group3 ///
	demstd2_group3 iv1_group2 iv2_group2 iv1_group3 iv2_group3
**********************************************
/* Table output in tex */
**********************************************
* Second-stage
estout est1 est2 est3 est4 est5 using ///
	"${results}table_A3_second.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(dem "\vspace*{-2mm}\shortstack{Democracy}" ///
		demstd1 "\vspace*{-2mm}\shortstack[l]{Democracy standardized}" ///
		demstd2 "\vspace*{-2mm}\shortstack[l]{Democracy squared standardized}" ///
		demstd1_group1 "\vspace*{-2mm}\hphantom{a} Democracy standardized" ///
		demstd2_group1 "\vspace*{-2mm}\hphantom{a} Democracy squared standardized" ///
		demstd1_group2 "\vspace*{-2mm}\hphantom{a} Democracy standardized" ///
		demstd2_group2 "\vspace*{-2mm}\hphantom{a} Democracy squared standardized" ///
		demstd1_group3 "\vspace*{-2mm}\hphantom{a} Democracy standardized" ///
		demstd2_group3 "\vspace*{-2mm}\hphantom{a} Democracy squared standardized", ///
			elist(demstd2_group1 \addlinespace)) ///
	refcat(demstd1_group1 "\vspace*{3mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \hphantom{a} developed countries _}}" ///
		demstd1_group2 "\vspace*{-2mm}Africa and South Asia _" ///
		demstd1_group3 "\vspace*{-2mm}Other countries _", nolabel) ///
	stats(N N_g, fmt(%9.0g %9.0g %9.1f) ///
		labels( "Observations" "Countries in sample"))  ///
	order(dem demstd1 demstd2 demstd1_group1 demstd2_group1 demstd1_group2 ///
		demstd2_group2 demstd1_group3 demstd2_group3) ///
	keep(dem demstd1 demstd2 demstd1_group1 demstd2_group1 demstd1_group2 ///
		demstd2_group2 demstd1_group3 demstd2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* First-stage
estout firstA1dem firstA2demstd1 firstA3demstd1_group1 firstD1demstd1 ///
	firstD2demstd1_group1 using ///
	"${results}table_A3_firstx1.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.iv1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-1}}" ///
		L2.iv1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-2}}" ///
		L3.iv1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-3}}" ///
		L4.iv1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-4}}") ///
	keep(L.iv1 L2.iv1 L3.iv1 L4.iv1) starlevels(* 0.05)

* f-stats
estout est1 est2 est3 est4 est5 using ///
	"${results}table_A3_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	stats(fs apf, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(dem demstd1 demstd2 demstd1_group1 demstd2_group1 demstd1_group2 ///
		demstd2_group2 demstd1_group3 demstd2_group3 L.y L2.y L3.y L4.y) ///
	sub(_ $\times$) starlevels(* 0.05)
	
* turning points in years
estout nlc1 nlc2 nlc3 nlc4 nlc5 using ///
	"${results}table_A3_nl.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(all "\vspace*{-2mm}\shortstack[l]{All countries}" ///
		group1 "\vspace*{-2mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \vspace*{2mm}\hphantom{a} developed countries}}" ///
		group2 "\vspace*{-2mm}\shortstack[l]{Africa and South Asia}" ///
		group3 "\vspace*{-2mm}\shortstack[l]{Other countries}") ///
	order(all group1 group2 group3) ///
	keep(all group1 group2 group3)  eqlabels(none) starlevels(* 0.05)
