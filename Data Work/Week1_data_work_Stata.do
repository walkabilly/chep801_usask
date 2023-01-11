Data Wrangling CHEP 801
========================

## Preparing the dataset and log file

~~~~
<<dd_do>>
capture log close
log using "\\cabinet.usask.ca\work$\dlf545\My Documents\CANPTH_data_wrangling_log", replace

clear all
set more off
<</dd_do>>
~~~~

## Import the CSV dataset
~~~~
<<dd_do>>
import delimited "\\cabinet.usask.ca\work$\dlf545\My Documents\CANPTH_data_wrangling.csv", numericcols(4 5 6 7 8 9) clear 
<</dd_do>>
~~~~

## Summarize the physical activity dataset
~~~~
<<dd_do>>
summarize pa_total_short
<</dd_do>>
~~~~
The mean of physical activity is <<dd_display: %9.0g r(mean)>>. 

## Generating new gender variable

In stata we can label the data without changing the variable itself. R can do this too but this is software specific and we don't want to much that is very software specific this effectively creates a factor variable in Stata

~~~~
<<dd_do>>
generate gender_recode = sdc_gender
recode gender_recode (1 = 0) (2 = 1)
label define gender_recode 0 "Male" 1 "Female"
label values gender_recode gender_recode
tab gender_recode
<</dd_do>>
~~~~

## Generating new fruit and vegetable consumption

~~~~
<<dd_do>>
generate fruit_veg_total = nut_veg_qty + nut_fruits_qty
summarize fruit_veg_total
<</dd_do>>
~~~~

### Recoding fruit and vegetable consumption

~~~~
<<dd_do>>
generate fruit_veg_cat = fruit_veg_total

recode fruit_veg_cat (min/7 = 0) (7.1/max = 1)
label define fruit_veg_cat 0 "Not Meeting Guidelines" 1 "Meeting Guidelines"
label values fruit_veg_cat fruit_veg_cat

tab fruit_veg_total fruit_veg_cat
<</dd_do>>
~~~~


## Physical activity data

~~~~
<<dd_do>>
summarize pa_total_short

generate pa_cat = pa_total_short

recode pa_cat (min/599 = 0) (600/3000 = 1) (3000/max = 2)
label define pa_cat 0 "Low Activity" 1 "Moderate Activity" 2 "High Activity"
label values pa_cat pa_cat

tab pa_cat
<</dd_do>>
~~~~

## Gender*Fruit and vegetable 

~~~~
<<dd_do>>
tab gender_recode fruit_veg_cat 
<</dd_do>>
~~~~

Using Tables for Epidemiologists functions in Stata

https://www.stata.com/features/tables-for-epidemiologists/

~~~~
<<dd_do>>
cc gender_recode fruit_veg_cat
<</dd_do>>
~~~~


dyndoc "\\cabinet.usask.ca\work$\dlf545\My Documents\data wrangling stata CHEP 801.do"