---
title: "Bias Analysis"
output:
      html_document:
        keep_md: true
---

## Bias Analysis


```r
knitr::opts_chunk$set(echo = TRUE)
library(ggdag)
library(episensr) 
library(htmlTable)
library(tidyverse)
library(knitr)
library(epitools)
```

### Loading the data

```r
data <- read_csv("Data.csv")
```

```
## Warning: One or more parsing issues, call `problems()` on your data frame for details,
## e.g.:
##   dat <- vroom(...)
##   problems(dat)
```

```
## Rows: 41187 Columns: 440
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr   (5): ID, MSD11_PR, MSD11_REG, MSD11_ZONE, MSD11_CMA
## dbl (425): ADM_STUDY_ID, SDC_GENDER, SDC_AGE_CALC, SDC_MARITAL_STATUS, SDC_E...
## lgl  (10): DIS_MH_BIPOLAR_EVER, DIS_GEN_DS_EVER, DIS_GEN_SCA_EVER, DIS_GEN_T...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

### Bias analysis 

The bias analysis work presented here and included in the `episensr` package is based on the FREE book below. For the purpose of this course we being very applied but there is an entire field of work dedicated to this area. 

* Applying Quantitative Bias Analysis to Epidemiologic Data. Matthew P. Fox, Richard F. MacLehose, Timothy L. Lash. [https://doi.org/10.1007/978-3-030-82673-4](https://doi.org/10.1007/978-3-030-82673-4)

### Selection bias analysis

I'm taking these examples directly from the `episensr` package. For the assignment, you will need to recode some data and create 2x2 tables and conduct bias analyses based on the CanPATH data. If you want the vignette is available here. [https://cran.r-project.org/web//packages/episensr/vignettes/episensr.html](https://cran.r-project.org/web//packages/episensr/vignettes/episensr.html).

We will use a case-control study by [Stang et al.](https://pubmed.ncbi.nlm.nih.gov/16523014/) on the relation between mobile phone use and uveal melanoma. The observed odds ratio for the association between regular mobile phone use vs. no mobile phone use with uveal melanoma incidence is 0.71 [95% CI 0.51-0.97]. But there was a substantial difference in participation rates between cases and controls (94% vs 55%, respectively) and so selection bias could have an impact on the association estimate. The 2x2 table for the study is below.

---- |	Regular use |	No use |
---- |---- | ----| 
Cases |	136 |	107 |
Controls  |	297  |	165 |


The various episensr functions return an object which is a list containing the input and output variables. You can check it out with str().

The 2X2 table is provided as a matrix and selection probabilities given with the argument bias_parms, a vector with the 4 probabilities (guided by the participation rates in cases and controls) in the following order: among cases exposed, among cases unexposed, among noncases exposed, and among noncases unexposed. The output shows the observed 2X2 table and the observed odds ratio (and relative risk), followed by the corrected ones.


```r
# Lines below just creates example tables 
contingencyTable <- data.frame(Outcome_Yes = c("a", "c"), Outcome_No = c("b", "d"))
rownames(contingencyTable) <- c("Exposure_yes", "Exposure_No")
probTable <- data.frame(Outcome_Yes = c("P_a", "P_c"), Outcome_No = c("P_b", "P_d"))
rownames(probTable) <- c("Exposure_yes", "Exposure_No")

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


```r
probTable %>% 
  addHtmlTableStyle(css.cell = c("width: 140;","width: 140;")) %>% 
  htmlTable(caption = "Table of selection probabilities") 
```

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='3' style='text-align: left;'>
Table of selection probabilities</td></tr>
<tr><th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'></th>
<th style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Outcome_Yes</th>
<th style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Outcome_No</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>Exposure_yes</td>
<td style='width: 140; text-align: center;'>P_a</td>
<td style='width: 140; text-align: center;'>P_b</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>Exposure_No</td>
<td style='width: 140; border-bottom: 2px solid grey; text-align: center;'>P_c</td>
<td style='width: 140; border-bottom: 2px solid grey; text-align: center;'>P_d</td>
</tr>
</tbody>
</table>

If there is no bias (participation is 100% and no withdrawal) selection probabilities of participating to the study is found to be as follows:    
  * Exposed and Outcome, P_a in the table below = 1  
  * exposed and no Outcome, P_b = 1  
  * Unexposed and Outcome, P_c = 1  
  * unexposed and no Outcome, P_d = 1    

Here is an example usage of `episensr`'s `selection` bias function.If all selection probabilities are 1.0 (no selection bias), we enter the `bias_params` (selection bias probability parameter) line in the command below as all 1.0,  and  the output look as follows. Note  that `observed` and `selection bias corrected` RR and OR are identical in the output, indicating no bias. The values in the `bias_params` argument should be between 0 and 1. 

### Stang paper assuming no bias


```r
stang_no_bias <- selection(matrix(c(136, 107, 297, 165),
                          dimnames = list(c("UM+", "UM-"), c("Mobile+", "Mobile-")),
                          nrow = 2, byrow = TRUE),
                   bias_parms = c(1, 1, 1, 1))
stang_no_bias
```

```
## --Observed data-- 
##          Outcome: UM+ 
##        Comparing: Mobile+ vs. Mobile- 
## 
##     Mobile+ Mobile-
## UM+     136     107
## UM-     297     165
## 
##                                        2.5%     97.5%
## Observed Relative Risk: 0.7984287 0.6518303 0.9779975
##    Observed Odds Ratio: 0.7061267 0.5143958 0.9693215
## ---
##                                                  
## Selection Bias Corrected Relative Risk: 0.7984287
##    Selection Bias Corrected Odds Ratio: 0.7061267
```

### Stang correcting for bias

In the Stang paper there are substantial difference in participation rates between cases and controls (94% vs 55%, respectively) and so selection bias could have an impact on the association estimate. We can use episensr to adjuste the association to account for the known selection bias. In another Stang paper they report the response rates by study

* Stang, Andreas; Anastassiou, Gerasimos; Ahrens, Wolfgang; Bromen, Katja; Bornfeld, Norbert; Jöckel, Karl-Heinz. The Possible Role of Radiofrequency Radiation in the Development of Uveal Melanoma. Epidemiology 12(1):p 7-12, January 2001. 

So we can adjust the estimates by response rate, to try and understand the impact of selection bias. 


```r
stang <- selection(matrix(c(136, 107, 297, 165),
                          dimnames = list(c("UM+", "UM-"), c("Mobile+", "Mobile-")),
                          nrow = 2, byrow = TRUE),
                   bias_parms = c(.94, .85, .64, .25))
stang
```

```
## --Observed data-- 
##          Outcome: UM+ 
##        Comparing: Mobile+ vs. Mobile- 
## 
##     Mobile+ Mobile-
## UM+     136     107
## UM-     297     165
## 
##                                        2.5%     97.5%
## Observed Relative Risk: 0.7984287 0.6518303 0.9779975
##    Observed Odds Ratio: 0.7061267 0.5143958 0.9693215
## ---
##                                                 
## Selection Bias Corrected Relative Risk: 1.483780
##    Selection Bias Corrected Odds Ratio: 1.634608
```

Here the previous observed relative risk was 0.79 and observed OR was 0.70, while the bias correct relative risk is 1.48 and the bias correct OR is 1.63. 

We can play with this a bit a do some senstivity analyses. What if they probablities of selection were the following and had more representative sampling in the unexposed no outcome group and kept the rest the same. 
  * Exposed and Outcome, P_a in the table below = 1  
  * exposed and no Outcome, P_b = 1  
  * Unexposed and Outcome, P_c = 1  
  * unexposed and no Outcome, P_d = 1    



```r
stang_sensitivity <- selection(matrix(c(136, 107, 297, 165),
                          dimnames = list(c("UM+", "UM-"), c("Mobile+", "Mobile-")),
                          nrow = 2, byrow = TRUE),
                   bias_parms = c(.94, .85, .64, .64))
stang_sensitivity
```

```
## --Observed data-- 
##          Outcome: UM+ 
##        Comparing: Mobile+ vs. Mobile- 
## 
##     Mobile+ Mobile-
## UM+     136     107
## UM-     297     165
## 
##                                        2.5%     97.5%
## Observed Relative Risk: 0.7984287 0.6518303 0.9779975
##    Observed Odds Ratio: 0.7061267 0.5143958 0.9693215
## ---
##                                                  
## Selection Bias Corrected Relative Risk: 0.7244325
##    Selection Bias Corrected Odds Ratio: 0.6385188
```

## Misclassification

Misclassification bias can be assessed with the function misclassification. Confidence intervals for corrected association due to exposure misclassification are also directly available, or the estimates can also be bootstrapped (see below). The confidence intervals from the variance of the corrected odds ratio estimator in the misclassification function are computed as in [Greenland et al.](https://doi.org/10.1002/sim.4780070704) and [Chu et al.](https://doi.org/10.1016/j.annepidem.2006.04.001), when adjusting for exposure misclassification using sensitivity and specificity. Using the example in Chu et al. of a case-control study of cigarette smoking and invasive pneumococcal disease, the unadjusted odds ratio is 4.32, with a 95% confidence interval of 2.96 to 6.31. 

Similar to the selection bias example we can input the sensivity and specificity of the measures in the `bias_parms` function. Here were are saying they are 1 (ie., perfect measures).


```r
misclassification(matrix(c(126, 92, 71, 224),
                         dimnames = list(c("Case", "Control"),
                                         c("Smoking +", "Smoking - ")),
                         nrow = 2, byrow = TRUE),
                  type = "outcome",
                  bias_parms = c(1, 1, 1, 1))
```

```
## --Observed data-- 
##          Outcome: Case 
##        Comparing: Smoking + vs. Smoking -  
## 
##         Smoking + Smoking - 
## Case          126         92
## Control        71        224
## 
##                                      2.5%    97.5%
## Observed Relative Risk: 2.196866 1.796016 2.687181
##    Observed Odds Ratio: 4.320882 2.958402 6.310846
## ---
##                                                         
## Misclassification Bias Corrected Relative Risk: 2.196866
##    Misclassification Bias Corrected Odds Ratio: 4.320882
```

Now, let’s say the sensitivity of self-reported smoking is 94% and specificity is 97%, for both the case and control groups. From the [Chu et al.](https://doi.org/10.1016/j.annepidem.2006.04.001) paper.

> The corrected OR increases to 5.02, which is 21% [= (4.02 − 3.32)/3.32] greater than the uncorrected OR. For this example, the nondifferential misclassification causes a notable bias toward the null, even for the very high Se and Sp. Furthermore, the 95% interval for the corrected OR is widened to (3.28 to 7.69), which is 10% [= (7.69/3.28)/(6.31/2.96) − 1] wider than the 95% interval for the uncorrected OR.


```r
misclassification(matrix(c(126, 92, 71, 224),
                         dimnames = list(c("Case", "Control"),
                                         c("Smoking +", "Smoking - ")),
                         nrow = 2, byrow = TRUE),
                  type = "exposure",
                  bias_parms = c(0.94, 0.94, 0.97, 0.97))
```

```
## --Observed data-- 
##          Outcome: Case 
##        Comparing: Smoking + vs. Smoking -  
## 
##         Smoking + Smoking - 
## Case          126         92
## Control        71        224
## 
##                                      2.5%    97.5%
## Observed Relative Risk: 2.196866 1.796016 2.687181
##    Observed Odds Ratio: 4.320882 2.958402 6.310846
## ---
##                                                              2.5%    97.5%
## Misclassification Bias Corrected Relative Risk: 2.377254                  
##    Misclassification Bias Corrected Odds Ratio: 5.024508 3.282534 7.690912
```

We can also do this in a probabilistic way with the `probsens` function.

Here we have the relative risk and OR for various probabilities accounting for missclassification and error.

##### Non-differential missclassification

```r
 probsens(matrix(c(126, 92, 71, 224),
    dimnames = list(c("Case", "Control"), c("Smoke+", "Smoke-")), nrow = 2, byrow = TRUE),
    type = "exposure",
    reps = 20000,
    seca.parms = list("trapezoidal", c(.75, .85, .95, 1)),
    spca.parms = list("trapezoidal", c(.75, .85, .95, 1)))
```

```
## Chosen prior Se/Sp distributions lead to 55 negative adjusted counts which were discarded.
```

```
## --Observed data-- 
##          Outcome: Case 
##        Comparing: Smoke+ vs. Smoke- 
## 
##         Smoke+ Smoke-
## Case       126     92
## Control     71    224
## 
##                                       2.5%    97.5%
##  Observed Relative Risk: 2.196866 1.796016 2.687181
##     Observed Odds Ratio: 4.320882 2.958402 6.310846
## ---
##                                                  Median 2.5th percentile
##            Relative Risk -- systematic error:  2.837336         2.367349
##               Odds Ratio -- systematic error:  7.798096         5.046733
## Relative Risk -- systematic and random error:  2.848993         2.148550
##    Odds Ratio -- systematic and random error:  7.952874         4.280031
##                                               97.5th percentile
##            Relative Risk -- systematic error:          3.745682
##               Odds Ratio -- systematic error:         36.495609
## Relative Risk -- systematic and random error:          4.011928
##    Odds Ratio -- systematic and random error:         38.294476
```

##### Non-differential missclassification

```r
probsens(matrix(c(45, 94, 257, 945),
    dimnames = list(c("BC+", "BC-"), c("Smoke+", "Smoke-")), nrow = 2, byrow = TRUE),
    type = "exposure",
    reps = 20000,
    seca.parms = list("trapezoidal", c(.75, .85, .95, 1)),
    seexp.parms = list("trapezoidal", c(.7, .8, .9, .95)),
    spca.parms = list("trapezoidal", c(.75, .85, .95, 1)),
    spexp.parms = list("trapezoidal", c(.7, .8, .9, .95)),
    corr.se = .8,
    corr.sp = .8)
```

```
## Chosen prior Se/Sp distributions lead to 4417 negative adjusted counts which were discarded.
```

```
## --Observed data-- 
##          Outcome: BC+ 
##        Comparing: Smoke+ vs. Smoke- 
## 
##     Smoke+ Smoke-
## BC+     45     94
## BC-    257    945
## 
##                                       2.5%    97.5%
##  Observed Relative Risk: 1.646999 1.182429 2.294094
##     Observed Odds Ratio: 1.760286 1.202457 2.576898
## ---
##                                                  Median 2.5th percentile
##            Relative Risk -- systematic error:  2.914722         1.689526
##               Odds Ratio -- systematic error:  3.528499         1.815519
## Relative Risk -- systematic and random error:  2.978228         1.536538
##    Odds Ratio -- systematic and random error:  3.623369         1.632743
##                                               97.5th percentile
##            Relative Risk -- systematic error:         10.216576
##               Odds Ratio -- systematic error:         53.870702
## Relative Risk -- systematic and random error:         10.512527
##    Odds Ratio -- systematic and random error:         53.821351
```

Now, let’s say the sensitivity of self-reported smoking is 85% and specificity is 87%, for both the case and control groups. 


```r
misclassification(matrix(c(126, 92, 71, 224),
                         dimnames = list(c("Case", "Control"),
                                         c("Smoking +", "Smoking - ")),
                         nrow = 2, byrow = TRUE),
                  type = "outcome",
                  bias_parms = c(0.85, 0.85, 0.87, 0.87))
```

```
## --Observed data-- 
##          Outcome: Case 
##        Comparing: Smoking + vs. Smoking -  
## 
##         Smoking + Smoking - 
## Case          126         92
## Control        71        224
## 
##                                      2.5%    97.5%
## Observed Relative Risk: 2.196866 1.796016 2.687181
##    Observed Odds Ratio: 4.320882 2.958402 6.310846
## ---
##                                                         
## Misclassification Bias Corrected Relative Risk: 3.162445
##    Misclassification Bias Corrected Odds Ratio: 8.399786
```

## Other forms of bias analysis

There are other forms of bias analysis we are not covering in the course. You can find info in the vignette for the `episensr` package. I've listed the major one's below

* Unmeasured or unknown confounders
* Selection bias caused by M bias
* Multidimensional bias analysis
* Multiple bias modeling
