*******************************************
/* Table A3 : IV full result*/
*******************************************
set more off

**********************************************
eststo clear
estimates drop _all
**********************************************
* 2SLS Regression table 2
**********************************************
* Column 1 
qui xtivreg2 y l(1/4).y (x1 x2=l.z1 l.z2) yy*, fe r cluster(wbcode2) ///
	partial(yy*) savefirst savefprefix(first1)
eststo est1
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(all:-_b[x1]/(2*_b[x2])), post
eststo nlc1

* Column 2: with region dummy+ 1 lag wave
gen x1_group1=x1
gen x2_group1=x2
gen x1_group2=x1*group2 
gen x2_group2=x2*group2 
gen x1_group3=x1*group3 
gen x2_group3=x2*group3 
gen z1_group2=z1*group2
gen z2_group2=z2*group2
gen z1_group3=z1*group3
gen z2_group3=z2*group3 
qui xtivreg2 y l(1/4).y (x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 ///
	x2_group3=l.z1 l.z2 l.z1_group2 l.z2_group2 l.z1_group3 l.z2_group3) ///
	group1 yy*, fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(first2)
eststo est2
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(group1:-_b[x1_group1]/(2*_b[x2_group1])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlc2

* Column 3: with region dummy+ 2 lag wave
qui xtivreg2 y l(1/4).y (x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 x2_group3=l(1/2).z1 ///
	l(1/2).z2 l(1/2).z1_group2 l(1/2).z2_group2 l(1/2).z1_group3 l(1/2).z2_group3) ///
	yy*, fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(first3)
eststo est3
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(group1:-_b[x1_group1]/(2*_b[x2_group1])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlc3

* Column 4: with region dummy+ 3 lag wave
qui xtivreg2 y l(1/4).y (x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 x2_group3=l(1/3).z1 ///
	l(1/3).z2 l(1/3).z1_group2 l(1/3).z2_group2 l(1/3).z1_group3 l(1/3).z2_group3) ///
	yy*, fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(first4)
eststo est4
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(group1:-_b[x1_group1]/(2*_b[x2_group1])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlc4

* Column 5: with region dummy+ 4 lag wave
qui xtivreg2 y l(1/4).y (x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 x2_group3=l(1/4).z1 ///
	l(1/4).z2 l(1/4).z1_group2 l(1/4).z2_group2 l(1/4).z1_group3 l(1/4).z2_group3) ///
	yy*, fe r cluster(wbcode2) partial(yy*) savefirst savefprefix(first5)
eststo est5
matrix mc1=e(first)
qui estadd scalar fs=mc1[4,1], replace
qui estadd scalar apf=mc1[15,1], replace
qui nlcom 	(group1:-_b[x1_group1]/(2*_b[x2_group1])) ///
			(group2:-_b[x1_group2]/(2*_b[x2_group2])) ///
			(group3:-_b[x1_group3]/(2*_b[x2_group3])), post
eststo nlc5

drop x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 x2_group3 z1_group2 ///
	z2_group2 z1_group3 z2_group3
**********************************************
/* Table output in tex */
**********************************************	
* Second-stage
estout est1 est2 est3 est4 est5 using ///
	"${results}table_A4_second.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(x1 "\vspace*{-2mm}\shortstack[l]{Democracy}" ///
		x2 "\vspace*{-2mm}\shortstack[l]{Democracy squared}" ///
		x1_group1 "\vspace*{-2mm}\hphantom{a} Democracy" ///
		x2_group1 "\vspace*{-2mm}\hphantom{a} Democracy squared" ///
		x1_group2 "\vspace*{-2mm}\hphantom{a} Democracy" ///
		x2_group2 "\vspace*{-2mm}\hphantom{a} Democracy squared" ///
		x1_group3 "\vspace*{-2mm}\hphantom{a} Democracy" ///
		x2_group3 "\vspace*{-2mm}\hphantom{a} Democracy squared", ///
			elist(x2_group3 \addlinespace)) ///
	refcat(x1_group1 "\vspace*{3mm}\multirow{2}{*}{\makecell[l]{Western Europe and other developed countries _}}" ///
		x1_group2 "Africa and South Asia _"  ///
		x1_group3 "Other countries _", nolabel) ///	
	stats(N N_g, fmt(%9.0g %9.0g %9.1f) ///
		labels( "Observations" "Countries in sample"))  ///
	keep(x1 x2 x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 x2_group3) ///
	sub(_ $\times$) starlevels(* 0.05)

* First-stage
estout first1x1 first2x1_group1 first3x1_group1 first4x1_group1 first5x1_group1 using ///
	"${results}table_A4_firstx1.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(L.z1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-1}}" ///
		L2.z1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-2}}" ///
		L3.z1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-3}}" ///
		L4.z1 "\vspace*{-2mm}Democracy wave\textsubscript{\textit{t-4}}") ///
	keep(L.z1 L2.z1 L3.z1 L4.z1) starlevels(* 0.05)
	
* f-stats
estout est1 est2 est3 est4 est5 using ///
	"${results}table_A4_f.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	stats(fs apf, fmt(%9.1f) ///
		labels( "F(first-stage instrument)" "Multivariate first-stage F statistic"))  ///
	drop(x1 x2 x1_group1 x2_group1 x1_group2 x2_group2 x1_group3 x2_group3 L.y L2.y L3.y L4.y) ///
	sub(_ $\times$) starlevels(* 0.05)

* turning points in years
estout nlc1 nlc2 nlc3 nlc4 nlc5 using ///
	"${results}table_A4_nl.tex", replace  ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.2f)) se(par)) ///
	varlabels(all "\vspace*{-2mm}\shortstack[l]{All countries}" ///
		group1 "\vspace*{-2mm}\multirow{2}{*}{\makecell[l]{Western Europe and other \vspace*{-2mm}\\ \vspace*{2mm}\hphantom{a} developed countries}}" ///
		group2 "\vspace*{-2mm}\shortstack[l]{Africa and South Asia}" ///
		group3 "\vspace*{-2mm}\shortstack[l]{Other countries}") ///
	order(all group1 group2 group3) ///
	keep(all group1 group2 group3)  eqlabels(none) starlevels(* 0.05)
