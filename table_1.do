/* Descriptive statistics 		*/
eststo clear
estimates drop _all
scalar drop _all

***********************
sort group1
ren gdppercapitaconstant2000us z

**********************************************
* Summary of GDP and Democracy Experience of democracies
* Column 1: All countries
qui tabstat z x1 if dem==1, stat(mean sd count) save
qui scalar zdemmean=r(StatTotal)[1,1]
qui scalar zdemsd=r(StatTotal)[2,1]
qui scalar zdemcount=r(StatTotal)[3,1]
qui scalar x1demmean=r(StatTotal)[1,2]
qui scalar x1demsd=r(StatTotal)[2,2]
* Number of countries and growth rate
qui sum z if dem==1&year==1960&!missing(y)
qui scalar dem1960=r(N)
qui scalar zdem60=r(mean)
qui sum z if dem==1&year==2010&!missing(y)
qui scalar dem2010=r(N)
qui scalar column11=(r(mean)/zdem60)-1
qui scalar growthdem=column11*100

* Column 2: Western Europe and other developed countries (group 1)
qui tabstat z x1 if dem==1&group1, stat(mean sd count) save
qui scalar zdemmeang1=r(StatTotal)[1,1]
qui scalar zdemsdg1=r(StatTotal)[2,1]
qui scalar zdemcountg1=r(StatTotal)[3,1]
qui scalar x1demmeang1=r(StatTotal)[1,2]
qui scalar x1demsdg1=r(StatTotal)[2,2]
* Number of countries and growth rate
qui sum z if dem==1&group1==1&year==1960&!missing(y)
qui scalar dem1960g1=r(N)
qui scalar zdem60g1=r(mean)
qui sum z if dem==1&group1==1&year==2010&!missing(y)
qui scalar dem2010g1=r(N)
qui scalar column12=(r(mean)/zdem60g1)-1
qui scalar growthdemg1=column12*100

* Column 3: Africa and South Asia (group 2)
qui tabstat z x1 if dem==1&group2, stat(mean sd count) save
qui scalar zdemmeang2=r(StatTotal)[1,1]
qui scalar zdemsdg2=r(StatTotal)[2,1]
qui scalar zdemcountg2=r(StatTotal)[3,1]
qui scalar x1demmeang2=r(StatTotal)[1,2]
qui scalar x1demsdg2=r(StatTotal)[2,2]
* Number of countries and growth rate
qui sum z if dem==1&group2==1&year==1960&!missing(y)
qui scalar dem1960g2=r(N)
qui scalar zdem60g2=r(mean)
qui sum z if dem==1&group2==1&year==2010&!missing(y)
qui scalar dem2010g2=r(N)
qui scalar column13=(r(mean)/zdem60g2)-1
qui scalar growthdemg2=column13*100

* Column 4: Other countries (group 3)
qui tabstat z x1 if dem==1&group3, stat(mean sd count) save
qui scalar zdemmeang3=r(StatTotal)[1,1]
qui scalar zdemsdg3=r(StatTotal)[2,1]
qui scalar zdemcountg3=r(StatTotal)[3,1]
qui scalar x1demmeang3=r(StatTotal)[1,2]
qui scalar x1demsdg3=r(StatTotal)[2,2]
* Number of countries and growth rate
qui sum z if dem==1&group3==1&year==1960&!missing(y)
qui scalar dem1960g3=r(N)
qui scalar zdem60g3=r(mean)
qui sum z if dem==1&group3==1&year==2010&!missing(y)
qui scalar dem2010g3=r(N)
qui scalar column14=(r(mean)/zdem60g3)-1
qui scalar growthdemg3=column14*100

**********************************************
**********************************************
* Summary of GDP and Democracy Experience of nondemocracies
* Column 1: All countries
qui tabstat z x1 if dem==0, stat(mean sd count) save
scalar zautomean=r(StatTotal)[1,1]
scalar zautosd=r(StatTotal)[2,1]
scalar zautocount=r(StatTotal)[3,1]
scalar x1automean=r(StatTotal)[1,2] // not included in the result matrix
scalar x1autosd=r(StatTotal)[2,2] // not included in the result matrix
* Number of countries and growth rate
qui sum z if dem==0&year==1960&!missing(y)
qui scalar auto1960=r(N)
qui scalar zauto60=r(mean)
qui sum z if dem==0&year==2010&!missing(y)
qui scalar auto2010=r(N)
qui scalar column21=(r(mean)/zauto60)-1
qui scalar growthauto=column21*100

* Column 2: Western Europe and other developed countries (group 1)
qui tabstat z x1 if dem==0&group1, stat(mean sd count) save
scalar zautomeang1=r(StatTotal)[1,1]
scalar zautosdg1=r(StatTotal)[2,1]
scalar zautocountg1=r(StatTotal)[3,1]
scalar x1automeang1=r(StatTotal)[1,2] // not included in the result matrix
scalar x1autosdg1=r(StatTotal)[2,2] // not included in the result matrix
* Number of countries and growth rate
qui sum z if dem==0&group1==1&year==1960&!missing(y)
qui scalar auto1960g1=r(N)
qui scalar zauto60g1=r(mean)
qui sum z if dem==0&group1==1&year==2010&!missing(y)
qui scalar auto2010g1=r(N)
qui scalar column22=(r(mean)/zauto60g1)-1
qui scalar growthautog1=column22*100

* Column 3: Africa and South Asia (group 2)
qui tabstat z x1 if dem==0&group2, stat(mean sd count) save
scalar zautomeang2=r(StatTotal)[1,1]
scalar zautosdg2=r(StatTotal)[2,1]
scalar zautocountg2=r(StatTotal)[3,1]
scalar x1automeang2=r(StatTotal)[1,2] // not included in the result matrix
scalar x1autosdg2=r(StatTotal)[2,2] // not included in the result matrix
* Number of countries and growth rate
qui sum z if dem==0&group2==1&year==1960&!missing(y)
qui scalar auto1960g2=r(N)
qui scalar zauto60g2=r(mean)
qui sum z if dem==0&group2==1&year==2010&!missing(y)
qui scalar auto2010g2=r(N)
qui scalar column23=(r(mean)/zauto60g2)-1
qui scalar growthautog2=column23*100

* Column 4: Other countries (group 3)
qui tabstat z x1 if dem==0&group3, stat(mean sd count) save
scalar zautomeang3=r(StatTotal)[1,1]
scalar zautosdg3=r(StatTotal)[2,1]
scalar zautocountg3=r(StatTotal)[3,1]
scalar x1automeang3=r(StatTotal)[1,2] // not included in the result matrix
scalar x1autosdg3=r(StatTotal)[2,2] // not included in the result matrix
* Number of countries and growth rate
qui sum z if dem==0&group3==1&year==1960&!missing(y)
qui scalar auto1960g3=r(N)
qui scalar zauto60g3=r(mean)
qui sum z if dem==0&group3==1&year==2010&!missing(y)
qui scalar auto2010g3=r(N)
qui scalar column24=(r(mean)/zauto60g3)-1
qui scalar growthautog3=column24*100

***********************
***********************
* Present the scalars in a matrix
qui matrix results=(zdemmean, zdemmeang1, zdemmeang2, zdemmeang3\ zdemsd, zdemsdg1, ///
				zdemsdg2, zdemsdg3\x1demmean, x1demmeang1,	x1demmeang2, ///
				x1demmeang3\x1demsd, x1demsdg1, x1demsdg2, x1demsdg3\zdemcount, ///
				zdemcountg1, zdemcountg2, zdemcountg3\dem1960, dem1960g1, ///
				dem1960g2, dem1960g3\dem2010, dem2010g1, dem2010g2, dem2010g3\ ///
				growthdem, growthdemg1, growthdemg2, growthdemg3\zautomean, ///
				zautomeang1, zautomeang2, zautomeang3\zautosd, zautosdg1, ///
				zautosdg2, zautosdg3\ zautocount, zautocountg1, zautocountg2, ///
				zautocountg3\auto1960, auto1960g1, auto1960g2, auto1960g3\ ///
				auto2010, auto2010g1, auto2010g2, auto2010g3\growthauto, ///
				growthautog1, growthautog2, growthautog3)
			
qui putexcel set table_1, replace
qui putexcel A1=matrix(results) 

************************
sort wbcode2 year
