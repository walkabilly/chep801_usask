Data Viz CHEP 801
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
import delimited "\\cabinet.usask.ca\work$\dlf545\My Documents\Data.csv", numericcols(_all) clear 
<</dd_do>>
~~~~

## 1. Data Viz

In general data visualization is going to be less powerful in Stata compared to R. That said, there is a lot we can with data viz in Stata. As well, there are some decent tutorials and things out there for stata graphics. Here are two good ones. 

UCLA Statistical Methods and Data Analytics - 
Stata Support - 

## 2. Histograms and single variable box plots

Unlike ggplot2 there is no consistent command for the different plots. We are just going to have to memorize them. All good. 

**Histograms**

~~~~
<<dd_do>>
histogram pa_total_short
<</dd_do>>
~~~~

We can visually inspect the plot and change the binwidth. Most of the time you won't need to do this. 

~~~~
<<dd_do>>
histogram pa_total_short, bin(100) name(histo_pa, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(histo_pa) png>>

**Single Bar Graph**

People get stuck in Stata making bar graphs because they are used to Excel and only have the mean value for a given column then making a bar graph from that mean column. It's always questionnable whether you should be making a bar graph, but if you really need to you can in Stata. 

First lets create labels for our income variable

~~~~
<<dd_do>>
table sdc_income
generate income_recode = sdc_income
recode income_recode (1 = 0) (2 = 1) (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7)
label define income_recode 0 "Less than $10K" 1 "$10K - $24,999" 2 "$25K - $49,999" 3 "$50K - $79,999" 4 "$75K - $99,999" 5 "$100K - $149,999" 6 "$150K - $199,999" 7 "$200K plus"
label values income_recode income_recode
tab income_recode
<</dd_do>>
~~~~

**Single Bar Graph**

~~~~
<<dd_do>>
graph hbar, over(income_recode) name(bar_income, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(bar_income) png>>

Here we can use **bar** or **hbar** to define a vertial or horizontal bar plot, respectively. 


**Single variable boxplot

~~~~
<<dd_do>>
graph box pa_total_short, name(box_pa, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(box_pa) png>>

## 3. Scatter plots 

Scatter plots show the relationship between two variables. There are lots of things we can do and we will build a plot sequentially. We are going to plot the relationship between age and physical activity, two continuous variables. 

~~~~
<<dd_do>>
graph twoway scatter pa_total_short sdc_age_calc, name(scatter_pa_age, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(scatter_pa_age) png>>

Let's add a fitted line. By default Stata uses a linear regression. This is not the same as R. I think a line is a better default but that's me. Here we are combining graphs sort of like we did with ggplot2. We use brackets to call two plots and overlay them. 

~~~~
<<dd_do>>
graph twoway (scatter pa_total_short sdc_age_calc) (lfit pa_total_short sdc_age_calc), name(scatter_fit, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(scatter_fit) png>>

We still have a problem with overplotting. We can use **mcolour** to change the opacity of the colours. 

~~~~
<<dd_do>>
graph twoway (scatter pa_total_short sdc_age_calc, mcolor(%5)) (lfit pa_total_short sdc_age_calc), name(scatter_colour, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(scatter_colour) png>>

## 4. Group with Stata graphics

We can pretty easily group by for different variables in stata graphics. Here we are going to group by using gender. First let's add value labels to our gender variable. 

~~~~
<<dd_do>>
generate gender_recode = sdc_gender
recode gender_recode (1 = 0) (2 = 1)
label define gender_recode 0 "Male" 1 "Female"
label values gender_recode gender_recode
tab gender_recode
<</dd_do>>
~~~~

**Faceting by gender 

~~~~
<<dd_do>>
graph twoway scatter pa_total_short sdc_age_calc, by(gender_recode) mcolor(%5) name(scatter_gender_facet, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(scatter_gender_facet) png>>

**Colour by gender**

There is no default way in Stata to colour by a variable in a scatter plot. There is a community develop method in a package called *SCC*. This is a community written program like an R package. There are more and more of these in Stata, which is great. We need to install this. From what I can tell 

~~~~
ssc install sepscatter
~~~~

~~~~
<<dd_do>>
sepscatter pa_total_short sdc_age_calc, separate(gender_recode) name(scatter_gender_colour, replace)
<</dd_do>>
~~~~

<<dd_graph: graphname(scatter_gender_colour) png>>


dyndoc "\\cabinet.usask.ca\work$\dlf545\My Documents\Week3_data_work_Stata.do"