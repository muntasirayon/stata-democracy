*******************************************
/* Table A1 : ANRR vs Demex OLS (saturated model) */
*******************************************
set more off

**********************************************
eststo clear
estimates drop _all

**********************************************
* OLS Regression table
**********************************************
tab region, generate(region_dum)
/*
> region_dum1=="AFR" 
> region_dum2=="EAP" 
> region_dum3=="ECA" 
> region_dum4=="INL" 
> region_dum5=="LAC" 
> region_dum6=="MNA" 
> region_dum7=="SAS"
> */

* Column 1
* ANRR standardized+region dummy
ren n_dem demstd1

gen afr_dum1=demstd1*region_dum1
gen eap_dum1=demstd1*region_dum2
gen eca_dum1=demstd1*region_dum3
gen lac_dum1=demstd1*region_dum5
gen mna_dum1=demstd1*region_dum6
gen sas_dum1=demstd1*region_dum7

qui xtreg y l(1/4).y demstd1 afr_dum eap_dum eca_dum lac_dum mna_dum ///
	sas_dum yy*, fe r cluster(wbcode2)
eststo est1
ren demstd1 n_dem
drop afr_dum1 eap_dum1 eca_dum1 lac_dum1 mna_dum1 sas_dum1

*********************************
* Democracy Experience
*********************************
* Column 2 : non-linear+region dummy
ren n_x1 demstd1
ren n_x2 demstd2

gen afr_dum1=demstd1*region_dum1
gen eap_dum1=demstd1*region_dum2
gen eca_dum1=demstd1*region_dum3
gen lac_dum1=demstd1*region_dum5
gen mna_dum1=demstd1*region_dum6
gen sas_dum1=demstd1*region_dum7

gen afr_dum2=demstd2*region_dum1
gen eap_dum2=demstd2*region_dum2
gen eca_dum2=demstd2*region_dum3
gen lac_dum2=demstd2*region_dum5
gen mna_dum2=demstd2*region_dum6
gen sas_dum2=demstd2*region_dum7

qui xtreg y l(1/4).y demstd1 demstd2 afr_dum1 afr_dum2 eap_dum1 eap_dum2 ///
	eca_dum1 eca_dum2 lac_dum1 lac_dum2 mna_dum1 mna_dum2 sas_dum1 sas_dum2 ///
	yy*, fe r cluster(wbcode2)

eststo est2
ren demstd1 n_x1
ren demstd2 n_x2

drop afr_dum1 afr_dum2 eap_dum1 eap_dum2 eca_dum1 eca_dum2 lac_dum1 lac_dum2 ///
	mna_dum1 mna_dum2 sas_dum1 sas_dum2 
drop region_dum*
**********************************************
/* Table output in tex */
**********************************************
estout est1 est2 using ///
	"${results}table_A1.tex", replace ///
	style(tex) nolabel  mlabels(none) collabels(none) ///
	cells(b(star fmt(%9.3f)) se(par)) ///
	varlabels(demstd1 "Democracy standardized" ///
	demstd2 "Democracy squared standardized"  ///
	afr_dum1 "\hphantom{a} Democracy standardized" ///
	eap_dum1 "\hphantom{a} Democracy standardized" ///
	eca_dum1 "\hphantom{a} Democracy standardized" ///
	lac_dum1 "\hphantom{a} Democracy standardized" ///
	mna_dum1 "\hphantom{a} Democracy standardized" ///
	sas_dum1 "\hphantom{a} Democracy standardized" ///
	afr_dum2 "\hphantom{a} Democracy squared standardized"  ///
	eap_dum2 "\hphantom{a} Democracy squared standardized"  ///        
	eca_dum2 "\hphantom{a} Democracy squared standardized"  ///                 
	lac_dum2 "\hphantom{a} Democracy squared standardized"  ///                     
	mna_dum2 "\hphantom{a} Democracy squared standardized"  ///                     
	sas_dum2 "\hphantom{a} Democracy squared standardized"  ///                    
		elist(sas_dum2 \addlinespace)) ///
	refcat(afr_dum1 "Africa _" eap_dum1 "East Asia and the Pacific _" ///
		eca_dum1 "Eastern Europe and Central Asia _" ///
		lac_dum1 "Latin America and the Caribbean _" ///
		mna_dum1 "Middle East and North Afria _" ///
		sas_dum1 "South Asia _", nolabel) ///
	stats(N N_g, fmt(%9.0g %9.0g) ///
		labels( "Observations" "Countries in sample" ))  ///
	order(demstd1 demstd2 afr_dum1 afr_dum2 eap_dum1 eap_dum2 eca_dum1 ///
		eca_dum2 lac_dum1 lac_dum2 mna_dum1 mna_dum2 sas_dum1 sas_dum2) ///
	keep(demstd1 demstd2 afr_dum1 afr_dum2 eap_dum1 eap_dum2 eca_dum1 ///
		eca_dum2 lac_dum1 lac_dum2 mna_dum1 mna_dum2 sas_dum1 sas_dum2) ///
	sub(_ $\times$) starlevels(* 0.05)

