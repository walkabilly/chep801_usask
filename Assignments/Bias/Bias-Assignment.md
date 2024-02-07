---
title: "Bias Assignment"
output:
  html_document:
    keep_md: yes
  pdf_document: default
---


```r
knitr::opts_chunk$set(echo = TRUE)
# load the episenr package after installation. This needs to be done every time you analyse
library("episensr") #you can quote or unquote, but need quote when using install.package, but not when using library, don't ask me why
library(htmlTable)

# packaged used in the data work lab and assignment 1, needed to run some functions in this assignment
library(tidyverse)
library("knitr")
library("epitools")
```

# Question 1a

#### Enter the selection probabilites provided below into the `bias_params` line in the episens command  and show the output. You need to copy and paste the `selection` function of episens I wrote above, paste below, and enter the appropriate selection probabilities. There is no need to edit anything else in the command.  

```{}
selection(matrix(c(434, 1094, 4937, 16263), 
                 dimnames = list(c("Diabetes", "No Diabetes"), 
                                 c("Low PA", "moderate/high PA"))
                 , nrow = 2, byrow = TRUE),
          bias_parms  = c(1, 1, 1, 1))
```

  - Exposed (low PA) and Outcome (Diabetes) = 0.9
  - Exposed and no Outcome =0.6
  - Unexposed and Outcome = 0.8
  - Unexposed and no Outcome = 0.8
  

```r
#Enter your answer here 
```

# Question 1b 

#### Based on the output you generated, is there selection bias in the original RR?

```r
#Enter your answer here 
```

# Question 1c 

#### Another study on the same population found out that the selection probabitlies are actually as follows: 
  - Exposed (low PA) and Outcome (Diabetes) = 0.9
  - Exposed and no Outcome =0.9
  - Unexposed and Outcome = 0.8
  - Unexposed and no Outcome = 0.8

```r
#Enter your answer here 
```

#### Run the `selection` command again (paste below) based on these updated probabilities by filling  `bias_parms`. Again, careful with the ordering of these values. 

# Question 1d

Based on the output from Question 1c, answer if there is selection bias or not, and if not please explain why in one or two sentences.

```r
#Enter your answer here 
```

# Question 2 - Information bias 

#### We will correct missclassificaiton of the exposure, PA variable. 

Suppose that a subsequent validation study using these data show that people inaccurately reports physical activity status, with the following sensitivity and specificity of exposure classification among diabetes cases and non-cases.  


```r
# Lines below just creates example tables 
contingencyTable <- data.frame(Outcome_Yes = c("a", "c"), Outcome_No = c("b", "d"))
rownames(contingencyTable) <- c("Exposure_yes", "Exposure_No")

contingencyTable %>% 
  addHtmlTableStyle(css.cell = c("width: 140;","width: 140;")) %>% 
  htmlTable(caption = "Table cell labels") 
```

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='3' style='text-align: left;'>
Table cell labels</td></tr>
<tr><th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'></th>
<th style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Outcome_Yes</th>
<th style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Outcome_No</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>Exposure_yes</td>
<td style='width: 140; text-align: center;'>a</td>
<td style='width: 140; text-align: center;'>b</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>Exposure_No</td>
<td style='width: 140; border-bottom: 2px solid grey; text-align: center;'>c</td>
<td style='width: 140; border-bottom: 2px solid grey; text-align: center;'>d</td>
</tr>
</tbody>
</table>

  - Se_outcome: Sensitivity of exposure classification among outcome (i.e., extent of misclassification from a to c among outcome)  = 0.95 
  - Sp_outcome: Specificity of exposure classification among outcome (i.e., extent of misclassification from c to a among outcome)   =0.8 
  - Se_noOutcome: Sensitivity of exposure classification among no outcome (i.e., extent of misclassification from b to d among no outcome) = 0.95   
  - Sp_noOutcome: Specificity of exposure classification among no outcome (i.e., extent of misclassification from  d to b among no outcome) = 0.8   
  
  
As a practice, we will plug in these classification metrics into the `misclassification` function in `episenser`, when there is no missclassification (i.e., all Se and Sp values are 1.0). The probabilities values entering the `bias_parms` line is *Se_outcome, Se_noOutcome, Sp_outcome, Sp_noOutcome*.   


```r
misclassification(matrix(c(434, 1094, 4937, 16263), 
                 dimnames = list(c("Diabetes", "No Diabetes"), 
                                 c("Low PA", "moderate/high PA")), 
                 nrow = 2, byrow = TRUE), 
                 type = "exposure",
          bias_parms  = c(1.0, 1.0, 1.0, 1.0))
```

```
## --Observed data-- 
##          Outcome: Diabetes 
##        Comparing: Low PA vs. moderate/high PA 
## 
##             Low PA moderate/high PA
## Diabetes       434             1094
## No Diabetes   4937            16263
## 
##                                      2.5%    97.5%
## Observed Relative Risk: 1.282011 1.152043 1.426642
##    Observed Odds Ratio: 1.306802 1.164072 1.467033
## ---
##                                                              2.5%    97.5%
## Misclassification Bias Corrected Relative Risk: 1.282011                  
##    Misclassification Bias Corrected Odds Ratio: 1.306802 1.164072 1.467033
```

# Question 2a
#### Now, perform bias sensitivity analysis based on the imperfect classification accuracies provided above (values of sensitivities and specificities), by updating the four values in the `bias_parms` line. Show the output below. 

```r
#Enter your answer here 
```


# Question 2b

#### Comparing `Misclassification Bias Corrected Relative Risk` and `Observed Relative Risk` (the latter is the crude - uncorrected association). Is there information bias? 

```r
#Enter your answer here 
```

# Question 2c

#### Is this differential or non-differential missclassification? Please provide 1 or 2 sentence of explanation. 

```r
#Enter your answer here 
```


# Question 2d
  - Sensitivity of exposure classification among outcome (i.e., extent of misclassification from a to c among outcome)  = 0.9
  - Specificity of exposure classification among outcome (i.e., extent of misclassification from c to a among outcome)   =0.9 
  - Sensitivity of exposure classification among no outcome (i.e., extent of misclassification from b to d among no outcome) = 0.5   
  - Specificity of exposure classification among no outcome (i.e., extent of misclassification from  d to b among no outcome) = 0.9   



```r
#Enter your answer here 
```

# Question 2e

#### Is this differential or non-differential missclassification (results of Question 2d)? Please provide 1 or 2 sentence of explanation. 

```r
#Enter your answer here 
```
