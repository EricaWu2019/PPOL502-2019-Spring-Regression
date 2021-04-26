

clear all

cd "/Users/erica_wu/Desktop/McCourt/20 Spring/3. Regression/Final Project/Data_Set_QoG/"
use "qog_bas_cs_jan20.dta"

ssc install outreg2
help outreg2  

* scatter plot to see the relationship to make assumption 
scatter wdi_co2 pwt_hci
scatter wdi_co2 wdi_gdpcapcon2010
scatter wdi_co2 ef_ef

* modify the name
gen co2_emission = wdi_co2
gen eco_footprint = ef_ef
gen ele_renewable = wdi_elerenew
gen human_capital = pwt_hci
gen gdp_percapita = wdi_gdpcapcon2010


* #1 regression model (without quadratic)

** Log 
**** histogram distribution  
hist co2_emission
hist eco_footprint
**** generate log variable  
gen log_co2_emission = log(co2_emission)
gen log_eco_footprint = log(eco_footprint)
**** normal distribution
hist log_co2_emission
hist log_eco_footprint

** run regression for the 1st model 
regress log_co2_emission log_eco_footprint ele_renewable human_capital gdp_percapita 
outreg2 using result_basic_model.doc, replace dec(3)
estat hettest 


* #2 regression model (with log and quadratic terms)

** Add Quadratic terms
gen square_human_capital = human_capital^2
gen square_gdp = gdp_percapita^2

**  run regression for the 2st model 
regress log_co2_emission log_eco_footprint ele_renewable human_capital square_human_capital gdp_percapita square_gdp
outreg2 using result_basic_model.doc, dec(3)

** joint test of the linear and quadratic coefficients
test human_capital square_human_capital
test gdp_percapita square_gdp

** turning point (max point)
disp 3.79/(2*0.63) // human_capital
disp 0.0000264/(2*2.13*10^(-10)) //gdp_percapita

** Detect Heteroskedastic

**** residual plot 
rvfplot yline(0)

**** formally test (validate visual finding with Breusch-Pagan Test )
estat hettest 

**** run robust model to re-estimates the standard errors in light of heteroskedasticity
regress log_co2_emission log_eco_footprint ele_renewable human_capital square_human_capital gdp_percapita square_gdp, robust
****** joint test of the linear and quadratic coefficients
test human_capital square_human_capital
test gdp_percapita square_gdp










