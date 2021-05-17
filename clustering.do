*******************************************
/* Clustering Analysis					*/
*******************************************
set more off

*******************************************
use "${datadir}ANRR.dta", clear

global varlist "x1 yl0 yl1 yl2 yl3 yl4 loginvpc ltfp marketref tradewb lgov lprienr lsecenr lmort unrestn"
global z_varlist "z_x1 z_yl0 z_yl1 z_yl2 z_yl3 z_yl4 z_loginvpc z_ltfp z_marketref z_tradewb z_lgov z_lprienr z_lsecenr z_lmort z_unrestn"

/* Creates lags of GDP */
gen yl0=y
gen yl1=L1.y
gen yl2=L2.y
gen yl3=L3.y
gen yl4=L4.y

local list1	"${varlist}"
di `list1'	
collapse `list1', by(region)

save "${datadir}cluster.dta", replace

local list1	"${varlist}"
foreach v of varlist `list1' {
	egen z_`v'=std(`v')
	}

local list2 "${z_varlist}"
forvalues k=1(1)5	{
	cluster kmeans `list2', k(`k') start(random(123)) name(cs`k')
	}

* WSS Matrix
matrix WSS=J(5,5,.)
matrix colnames WSS=k WSS log(WSS) eta-squared PRE
* WSS for each clustering
local list2 "${z_varlist}"
forvalues k=1(1)5 {
	scalar ws`k'=0
		foreach v of varlist `list2' {
		qui anova `v' cs`k'
		scalar ws`k'=ws`k'+e(rss)
		}
	matrix WSS[`k',1]=`k'
	matrix WSS[`k',2]=ws`k'
	matrix WSS[`k',3]=log(ws`k')
	matrix WSS[`k',4]=1-ws`k'/WSS[1,2]
	matrix WSS[`k',5]=(WSS[`k'-1,2]-ws`k')/WSS[`k'-1,2]
	}
matrix list WSS
local squared=char(178)

_matplot WSS, columns(2 1) connect(1) xlabel(#10) name(plot1, replace) nodraw noname
_matplot WSS, columns(3 1) connect(1) xlabel(#10) name(plot2, replace) nodraw noname
_matplot WSS, columns(4 1) connect(1) xlabel(#10) name(plot3, replace) nodraw noname ///
	ytitle({&eta}`squared')
_matplot WSS, columns(5 1) connect(1) xlabel(#10) name(plot4, replace) nodraw noname
graph combine plot1 plot2 plot3 plot4, name(plot1to4, replace)

graph matrix ${z_varlist}, msym(i) mlab(cs4) mlabpos(0) ///
	name(matrixplot, replace)
