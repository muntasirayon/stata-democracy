*******************************************
/* Effects of democracy on economic growth*/
*******************************************
clear all
set more off

/* Set program and data directory		*/
global progdir "~/Dropbox/Thesis_Hasan/Programs/"
global datadir "~/Dropbox/Thesis_Hasan/Data/"
global result "~/Dropbox/Thesis_Hasan/Results/Excel"

*************************************************
/* Use data from Acemoglu(2018) for cluster analysis	*/
use "${datadir}DDCGdata_final.dta", clear
/*
/* Clustering analysis		*/
/* Table ....*/
do "${progdir}clustering.do"
save "${datadir}clustering.dta", replace
*************************************************
*/
/* Use data from Acemoglu(2018)  			*/
use "${datadir}DDCGdata_final.dta", clear

/* generate three region group dummy based on the k-means cluster analysis */
gen byte group1=(region=="INL")
gen byte group2=(region=="AFR"|region=="SAS")
gen byte group3=(region=="EAP"|region=="ECA"|region=="LAC"|region=="MNA")

/* Define value labels				*/
label define dem 1 dem 0 nondem
label values dem dem
label define group1 0 "INL"
label values group1 group1
label define group2 1 "AFR and SAS"
label values group2 group2
label define group3 2 "EAP, ECA, LAC, and MNA"
label values group3 group3
*************************************************
/* Generate new measure of democracy	*/
/* sum of continous democratic years	*/
by wbcode2: gen x1=dem
by wbcode2: replace x1=x1[_n-1]+dem[_n] if dem[_n]==1&dem[_n-1]==1
gen x2=x1^2

*************************************************
* Democracy wave as Instrumental variable
*************************************************
/* using dem_exp to calculate wave by regionINITREG */
gen byte touse=!missing(x1)
egen total=sum(x1), by(regionINITREG year)
egen count=sum(touse), by(regionINITREG year)
gen z1= cond(touse,(total-cond(x1,x1,x1,0))/(count-1), ///
	(total-cond(x1,x1,x1,0))/count)
drop touse total count

/* using dem_exp2 to calculate wave by regionINITREG */
gen byte touse=!missing(x2)
egen total=sum(x2), by(regionINITREG year)
egen count=sum(touse), by(regionINITREG year)
gen z2= cond(touse,(total-cond(x2,x2,x2,0))/(count-1), ///
	(total-cond(x2,x2,x2,0))/count)
drop touse total count

*************************************************
* Standardize x1, x2 and dem variable
*************************************************
qui sum x1 
gen n_x1 = (x1 - r(mean)) / r(sd) 
qui sum x2
gen n_x2 = (x2 - r(mean)) / r(sd) 
qui sum dem
gen n_dem = (dem - r(mean)) / r(sd)

*************************************************
/* using standardized dem to calculate wave by regionINITREG */
gen byte touse=!missing(n_dem)
egen total=sum(n_dem), by(regionINITREG year)
egen count=sum(touse), by(regionINITREG year)
gen n_demreg= cond(touse,(total-cond(n_dem,n_dem,n_dem,0))/(count-1), ///
	(total-cond(n_dem,n_dem,n_dem,0))/count)
drop touse total count

/* using standardized dem_exp to calculate wave by regionINITREG */
gen byte touse=!missing(n_x1)
egen total=sum(n_x1), by(regionINITREG year)
egen count=sum(touse), by(regionINITREG year)
gen n_z1= cond(touse,(total-cond(n_x1,n_x1,n_x1,0))/(count-1), ///
	(total-cond(n_x1,n_x1,n_x1,0))/count)
drop touse total count

/* using standardized dem_exp2 to calculate wave by regionINITREG */
gen byte touse=!missing(n_x2)
egen total=sum(n_x2), by(regionINITREG year)
egen count=sum(touse), by(regionINITREG year)
gen n_z2= cond(touse,(total-cond(n_x2,n_x2,n_x2,0))/(count-1), ///
	(total-cond(n_x2,n_x2,n_x2,0))/count)
drop touse total count
sort wbcode2 year
save "${datadir}ANRR.dta", replace

*************************************************
*************************************************
use "${datadir}ANRR.dta", clear
*************************************************
/* Descriptive statistics 		*/
/* Table 1 */
do "${progdir}table_1.do"

*************************************************
/* OLS: ANRR+Demex*/
/* Table 2 */
do "${progdir}table_2.do"

*************************************************
/* 2SLS: ANRR+Demex	*/
/* Table 3 */
do "${progdir}table_3.do"

*************************************************
/* 2SLS: ANRR+Demex+Region dummies	*/
/* Table 4 */
do "${progdir}table_4.do"

*************************************************
/* Effects of democracy on the mechanisms of democracy*/
/* Table 4 */
do "${progdir}table_5-6.do"

*************************************************
/* Appendix Tables					*/
*************************************************
/* OLS saturated model							*/
/* Table A1 */
do "${progdir}table_A1.do"

*************************************************
/* First-stage of Table 3			*/
/* Table A1 */
do "${progdir}table_A2.do"

*************************************************
/* IV with democracy experience						*/
/* Table A2 */
do "${progdir}table_A3.do"

*************************************************
/* IV with democracy experience						*/
/* Table A2 */
do "${progdir}table_A4.do"
*************************************************
* do file ends*
*************************************************
