**# EVER DIAGNOSED #1
tab ht002
tab ht003
tab ht002
tab ht004
tab ht005
tab ht006
tab ht007
tab ht008
tab ht009
tab ht010 
**# CURRENTLY BEING TREATED #2
tab ht002c
gen dbt_treat = (ht003c ==1) + (ht003d==1)
tab dbt_treat
gen cancer_treat = (ht004fs1 ==1) + (ht004fs2 == 1) + (ht004fs3 == 1) + (ht004fs4 == 1)
tab cancer_treat
tab ht005c
tab ht006h
tab ht007c
tab ht008f
gen psy_treat = (ht009e == 1) + (ht009d == 1)
tab psy_treat
tab ht010c
**# FACILITY TYPE  #3
gen facility_public =.
replace facility_public = 0
replace facility_public = 1 if ( hc002s1 == 1)
replace facility_public = 1 if ( hc002s2 == 1)
replace facility_public = 1 if ( hc002s3 == 1)
replace facility_public = 1 if ( hc002s4 == 1)
replace facility_public = 1 if ( hc002s5 == 1)
replace facility_public = 1 if ( hc002s6 == 1)
replace facility_public = 1 if ( hc002s9 == 1)
gen facility_pvt =.
replace facility_pvt = 0
replace facility_pvt = 1 if ( hc002s7 == 1)
replace facility_pvt = 1 if ( hc002s8 == 1)
replace facility_pvt = 1 if ( hc002s10 == 1)
gen facility_type =.
replace facility_type = 1 if (facility_public == 1 & facility_pvt == 0)
replace facility_type = 2 if (facility_public == 0 & facility_pvt == 1)
replace facility_type = 3 if (facility_public == 1 & facility_pvt == 1)
replace facility_type = 4 if (facility_public == 0 & facility_pvt == 0)
label define type_facility 1 "Only public facilities" 2 "Only private facilities" 3 "both public and private facilities" 4 "Others"
label values facility_type facility_type
tab facility_type ht002c, col
tab facility_type ht005c, col
tab facility_type ht006h, col
tab facility_type ht007c, col
tab facility_type ht008f, col
tab facility_type ht010c, col
tab dbt_treat facility_type, row
tab cancer_treat facility_type, row
tab psy_treat facility_type, row
**# UNMET NEED #4
gen diag =.
replace diag = 0
replace diag = 1 if ( ht010 == 1)
replace diag = 1 if ( ht009 == 1)
replace diag = 1 if ( ht008 == 1)
replace diag = 1 if ( ht007 == 1)
replace diag = 1 if ( ht006 == 1)
replace diag = 1 if ( ht005 == 1)
replace diag = 1 if ( ht004 == 1)
replace diag = 1 if ( ht003 == 1)
replace diag = 1 if ( ht002 == 1)
gen treat =.
replace treat = 0
replace treat = 1 if ( ht002c == 1)
replace treat = 1 if ( ht003c == 1)
replace treat = 1 if ( ht003d == 1)
replace treat = 1 if (ht009c == 1)
replace treat = 1 if (ht009d == 1)
replace treat = 1 if (ht008f == 1)
replace treat = 1 if (ht007c == 1)
replace treat = 1 if (ht006h == 1)
replace treat = 1 if (ht005c == 1)
replace treat = 1 if (ht004fs4 == 1)
replace treat = 1 if (ht004fs3 == 1)
replace treat = 1 if (ht004fs2 == 1)
replace treat = 1 if (ht004fs1 == 1)
replace treat = 1 if (ht010c == 1)
gen unmet_need = diag - treat
tab dm003 unmet_need, col
tab agerec unmet_need, col
tab residence unmet_need, col
tab mpce unmet_need, col
recode stateid (28 18 10 22 7 24 6 1 20 29 32 23 27 21 3 8 33 36 9 5 19 = 1 "Bigger States")(12 30 2 14 17 15 13 16 = 2 "Smaller States")(35 4 26 25 31 34 = 3 "Union Territories"), gen (state_cat)
tab state_cat unmet_need, col

graph pie,over( opd_oope_cat ) title("Distribution of Out-of-Pocket""Expenditure After Reimbursement", size(medsmall)) plabel(_all percent,size(vsmall)format(%4.1f)) pie(1, color(green%80))pie(2, color(navy%80)) pie(3, color(blue%70)) pie(4, color(orange%70)) pie(5, color(red%70)) pie(6, color(cranberry%70)) pie(7, color(maroon%70)) pie(8, color(black%70)) legend(order( 1 "Full reimbursement (3.58%)" 2 "Less than 5K (72.02%)" 3 "5K-20K (19.12%)" 4 "20K-50K (4.08%)"5 "50K-2L (1.09%)" 6 "2L-5L (0.08%)"  7 "5L-10L (0.01%)" 8 "More than 10L (0.01%)") cols(2) size(vsmall)) graphregion(color(white))

**# REGRESSION #
logistic unmetneed i.agerec i.dm003 i.residence i.mpce_quintile, or
estimates store model1
coefplot model1, drop (_cons) xline (1)
mlogit facility_type i.agerec i.dm003 i.residence i.mpce_quintile, rrr
estimates store model2
coefplot model2, drop (_cons) xline (1)
reg ln_oope i.agerec i.dm003 i.residence i.mpce_quintile, vce(robust)
estimates store model3
coefplot model3, drop (_cons) xline (0)
