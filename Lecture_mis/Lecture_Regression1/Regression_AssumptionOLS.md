---
title: "Regression_OLS_Assumption_FEVdata"
output:
  html_document:
    keep_md: yes
---

## Setup 
Load library, set figure size

```r
rm(list=ls()) # clear all workspace, very important to do this to refresh 
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(fig.width=4.5, fig.height=4.5) 
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✔ ggplot2 3.4.0     ✔ purrr   0.3.4
## ✔ tibble  3.1.8     ✔ dplyr   1.0.9
## ✔ tidyr   1.2.0     ✔ stringr 1.4.0
## ✔ readr   2.1.2     ✔ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

```r
library(epitools)
library(htmlTable)
library(autoReg)
library(labelled)
```

### Data size for simulation and custom function to format table names 

```r
N = 200

funcColNames <- function(d){
  colnames(d)[colnames(d) == "term"] <- "Coefficient"
  colnames(d)[colnames(d) == "conf.low"] <- "ConfInt.Lower"
  colnames(d)[colnames(d) == "conf.high"] <- "ConfInt.Higher"
  return(d)
}
# Make shorter variables names 
funcColNames2 <- function(d){
  colnames(d)[colnames(d) == "term"] <- "Coef"
  colnames(d)[colnames(d) == "conf.low"] <- "CI.Lower"
  colnames(d)[colnames(d) == "conf.high"] <- "CI.Higher"
  d <- d %>% select(-c(p.value, statistic))
  return(d)
}
```


## Real data to check the assumptions 
FEV (Forced Expiration Volume) study, can be download from many sources    

* Some anlaysis examples [https://www.tandfonline.com/doi/full/10.1080/10691898.2005.11910559](https://www.tandfonline.com/doi/full/10.1080/10691898.2005.11910559)  
* An Exhalent Problem for Teaching Statistics, Kahn (2017) [https://doi.org/10.1080/10691898.2005.11910559](https://doi.org/10.1080/10691898.2005.11910559)


```r
url <- "http://www.emersonstatistics.com/datasets/fev.txt"
download.file(url, "fev.txt" )
dat <- read.csv("https://github.com/walkabilly/chep801_usask/raw/main/fev.txt", sep="")

# Describe data 
glimpse(dat)
```

```
## Rows: 654
## Columns: 7
## $ seqnbr <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, …
## $ subjid <int> 301, 451, 501, 642, 901, 1701, 1752, 1753, 1901, 1951, 1952, 20…
## $ age    <int> 9, 8, 7, 9, 9, 8, 6, 6, 8, 9, 6, 8, 8, 8, 8, 7, 5, 6, 9, 9, 5, …
## $ fev    <dbl> 1.708, 1.724, 1.720, 1.558, 1.895, 2.336, 1.919, 1.415, 1.987, …
## $ height <dbl> 57.0, 67.5, 54.5, 53.0, 57.0, 61.0, 58.0, 56.0, 58.5, 60.0, 53.…
## $ sex    <int> 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 1, 1, 1, 1, 2, 1, 1, 2, …
## $ smoke  <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
```

```r
# Make categorical varaibles out of characters 
dat$sex <- factor(dat$sex)
levels(dat$sex) = c("Female", "Male")
table(dat$sex)
```

```
## 
## Female   Male 
##    336    318
```

```r
dat$smoke <- factor(dat$smoke)
levels(dat$smoke) <- c("Smoker", "Non-smoker")
table(dat$smoke)
```

```
## 
##     Smoker Non-smoker 
##         65        589
```

```r
pairs(dat %>%  select(-c("seqnbr", subjid)))
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-2-1.png)<!-- -->


We will start from descriptive statistics
### We will assess the association of each variables as well as potential non-linearity and effect measure modification 
Descritpive plots - histogram 

```r
# Distribution of continuous outcomes 
hist(dat$age, main = "Age", cex.main = 1)
hist(dat$fev, main = "FEV, outcome", cex.main = 1)
hist(dat$height, main = "Height", cex.main = 1)
```

<img src="Regression_AssumptionOLS_files/figure-html/fig1-1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/fig1-2.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/fig1-3.png" width="50%" />

### Descriptive plots - xy age and fev

```r
ggplot(dat, aes(x= age, y = fev)) + 
  geom_point() +
  theme_classic() + 
  ggtitle("Relationship between Age (years) and FEV (Litres)") + 
  theme(plot.title = element_text(size = 9)) + 
   geom_smooth(se=FALSE)
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

```r
ggplot(dat, aes(x= age, y = fev)) + 
  geom_point() +
  theme_classic() + 
  ggtitle("Relationship between Age (years) and FEV (Litres) \n  by Sex") + 
  facet_wrap(~sex) + 
  theme(plot.title = element_text(size = 9)) + 
   geom_smooth(se=FALSE)
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

<img src="Regression_AssumptionOLS_files/figure-html/fig2-1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/fig2-2.png" width="50%" />

### Descriptive plots - height and fev 

```r
ggplot(dat, aes(x= height, y = fev)) + 
  geom_point() +
  theme_classic() + 
  ggtitle("Relationship between Height (years) and FEV (Litres)")+ 
  theme(plot.title = element_text(size = 9)) + 
   geom_smooth(se=FALSE)
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

```r
ggplot(dat, aes(x= height, y = fev)) + 
  geom_point() +
  theme_classic() + 
  ggtitle("Relationship between Height (years) and FEV (Litres) \n by smoking status") + 
  facet_wrap(~smoke)+ 
  theme(plot.title = element_text(size = 9)) + 
   geom_smooth(se=FALSE)
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

```r
ggplot(dat, aes(x= age, y = height)) + 
  geom_point() +
  theme_classic() + 
  ggtitle("Relationship between Age (years) and FEV (Litres)")+ 
  theme(plot.title = element_text(size = 9)) + 
   geom_smooth(se=FALSE)
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

<img src="Regression_AssumptionOLS_files/figure-html/fig3-1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/fig3-2.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/fig3-3.png" width="50%" />

### Descriptive plots - height and fev 

```r
ggplot(dat, aes(sex, fev)) + geom_boxplot() + theme_classic() + ggtitle("FEV by sex")
ggplot(dat, aes(smoke, fev)) + geom_boxplot() + theme_classic() + ggtitle("FEV by smoking status")

knitr::kable(table(dat$sex), digits = 2, caption = "Results: Linear model ")
```



Table: Results: Linear model 

|Var1   | Freq|
|:------|----:|
|Female |  336|
|Male   |  318|

```r
knitr::kable(table(dat$smoke), digits = 2, caption = "Results: Linear model ")
```



Table: Results: Linear model 

|Var1       | Freq|
|:----------|----:|
|Smoker     |   65|
|Non-smoker |  589|

<img src="Regression_AssumptionOLS_files/figure-html/fig4-1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/fig4-2.png" width="50%" />

### Plot all varaibles at once, execpt person IDs 

```r
dat %>% select(-c(seqnbr, subjid)) %>% pairs
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-3-1.png)<!-- -->


## Exploratory regression analysis,  
#### single variable regression between FEV and each covariate
#### remember though, just looking at coefficients only is not as imformative as x-y plots above 

```r
independentVariables <- c("age", "height", "smoke", "sex")
independentVariablesData<- dat[, independentVariables]
fitList <- lapply(1:ncol(independentVariablesData), function(x) lm(dat$fev ~ independentVariablesData[,x]))

# extract just coefficients
sapply(fitList, coef)
```

```
##                                    [,1]       [,2]       [,3]       [,4]
## (Intercept)                   0.4316481 -5.4326788  3.2768615  2.8124464
## independentVariablesData[, x] 0.2220410  0.1319756 -0.7107189 -0.3612766
```

```r
fit=lm(fev~age+sex+height+smoke,data=dat)

#fit=lm(fev~age*sex*height*smoke,data=dat)
autoReg(fit,uni=TRUE, threshold=0.2) %>% myft()
```

```
## Usage of empty symbol '' with footnote should not happen, 
## use `add_footer_lines()` instead, it does not require any symbol. 
## This usage will be forbidden in the next release. Please, wait for 10 seconds!
```

```{=html}
<template id="839db23e-7458-466b-85a0-5f8a70e4f3ad"><style>
.tabwid table{
  border-spacing:0px !important;
  border-collapse:collapse;
  line-height:1;
  margin-left:auto;
  margin-right:auto;
  border-width: 0;
  border-color: transparent;
  caption-side: top;
}
.tabwid-caption-bottom table{
  caption-side: bottom;
}
.tabwid_left table{
  margin-left:0;
}
.tabwid_right table{
  margin-right:0;
}
.tabwid td, .tabwid th {
    padding: 0;
}
.tabwid a {
  text-decoration: none;
}
.tabwid thead {
    background-color: transparent;
}
.tabwid tfoot {
    background-color: transparent;
}
.tabwid table tr {
background-color: transparent;
}
.katex-display {
    margin: 0 0 !important;
}
</style><div class="tabwid"><style>.cl-23e48b62{}.cl-23e0e4e4{font-family:'Helvetica';font-size:11pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-23e0e4ee{font-family:'Helvetica';font-size:10pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-23e0e4f8{font-family:'Helvetica';font-size:6pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;position: relative;bottom:3pt;}.cl-23e0e4f9{font-family:'Helvetica';font-size:6.6pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;position: relative;bottom:3.3pt;}.cl-23e25a0e{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:2pt;padding-top:2pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-23e25a0f{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:2pt;padding-top:2pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-23e25a18{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:2pt;padding-top:2pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-23e25a19{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-23e264e0{width:1.321in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264e1{width:1.586in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264ea{width:0.979in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264f4{width:0.902in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264f5{width:2.065in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264f6{width:1.321in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264f7{width:1.586in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264fe{width:0.979in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e264ff{width:0.902in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26500{width:2.065in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26508{width:1.321in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26509{width:1.586in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2650a{width:0.979in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2650b{width:0.902in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26512{width:2.065in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26513{width:1.321in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26514{width:1.586in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2651c{width:0.979in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2651d{width:0.902in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2651e{width:2.065in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2651f{width:1.321in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26526{width:1.586in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26527{width:0.979in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26528{width:0.902in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26529{width:2.065in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26530{width:1.321in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(255, 255, 255, 0.00);border-top: 0 solid rgba(255, 255, 255, 0.00);border-left: 0 solid rgba(255, 255, 255, 0.00);border-right: 0 solid rgba(255, 255, 255, 0.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26531{width:1.586in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(255, 255, 255, 0.00);border-top: 0 solid rgba(255, 255, 255, 0.00);border-left: 0 solid rgba(255, 255, 255, 0.00);border-right: 0 solid rgba(255, 255, 255, 0.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26532{width:0.979in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(255, 255, 255, 0.00);border-top: 0 solid rgba(255, 255, 255, 0.00);border-left: 0 solid rgba(255, 255, 255, 0.00);border-right: 0 solid rgba(255, 255, 255, 0.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e26533{width:0.902in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(255, 255, 255, 0.00);border-top: 0 solid rgba(255, 255, 255, 0.00);border-left: 0 solid rgba(255, 255, 255, 0.00);border-right: 0 solid rgba(255, 255, 255, 0.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-23e2653a{width:2.065in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(255, 255, 255, 0.00);border-top: 0 solid rgba(255, 255, 255, 0.00);border-left: 0 solid rgba(255, 255, 255, 0.00);border-right: 0 solid rgba(255, 255, 255, 0.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}</style><table class='cl-23e48b62'><thead><tr style="overflow-wrap:break-word;"><th class="cl-23e264e0"><p class="cl-23e25a0e"><span class="cl-23e0e4e4">Dependent: fev</span></p></th><th class="cl-23e264e1"><p class="cl-23e25a0e"><span class="cl-23e0e4e4"> </span></p></th><th class="cl-23e264ea"><p class="cl-23e25a0e"><span class="cl-23e0e4e4">unit</span></p></th><th class="cl-23e264f4"><p class="cl-23e25a0e"><span class="cl-23e0e4e4">value</span></p></th><th class="cl-23e264f5"><p class="cl-23e25a0e"><span class="cl-23e0e4e4">Coefficient (univariable)</span></p></th><th class="cl-23e264f5"><p class="cl-23e25a0e"><span class="cl-23e0e4e4">Coefficient (multivariable)</span></p></th></tr></thead><tbody><tr style="overflow-wrap:break-word;"><td class="cl-23e264f6"><p class="cl-23e25a0f"><span class="cl-23e0e4ee">age</span><span class="cl-23e0e4f8"></span></p></td><td class="cl-23e264f7"><p class="cl-23e25a18"><span class="cl-23e0e4ee">[3,19]</span><span class="cl-23e0e4f8"></span></p></td><td class="cl-23e264fe"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Mean ± SD</span></p></td><td class="cl-23e264ff"><p class="cl-23e25a18"><span class="cl-23e0e4ee">9.9 ± 3.0</span></p></td><td class="cl-23e26500"><p class="cl-23e25a18"><span class="cl-23e0e4ee">0.22 (0.21 to 0.24, p&lt;.001)</span></p></td><td class="cl-23e26500"><p class="cl-23e25a18"><span class="cl-23e0e4ee">0.07 (0.05 to 0.08, p&lt;.001)</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-23e26508"><p class="cl-23e25a0f"><span class="cl-23e0e4ee">sex</span></p></td><td class="cl-23e26509"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Female (N=336)</span></p></td><td class="cl-23e2650a"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Mean ± SD</span></p></td><td class="cl-23e2650b"><p class="cl-23e25a18"><span class="cl-23e0e4ee">2.8 ± 1.0</span></p></td><td class="cl-23e26512"><p class="cl-23e25a18"><span class="cl-23e0e4ee"></span></p></td><td class="cl-23e26512"><p class="cl-23e25a18"><span class="cl-23e0e4ee"></span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-23e264f6"><p class="cl-23e25a0f"><span class="cl-23e0e4ee"></span></p></td><td class="cl-23e264f7"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Male   (N=318)</span></p></td><td class="cl-23e264fe"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Mean ± SD</span></p></td><td class="cl-23e264ff"><p class="cl-23e25a18"><span class="cl-23e0e4ee">2.5 ± 0.6</span></p></td><td class="cl-23e26500"><p class="cl-23e25a18"><span class="cl-23e0e4ee">-0.36 (-0.49 to -0.23, p&lt;.001)</span></p></td><td class="cl-23e26500"><p class="cl-23e25a18"><span class="cl-23e0e4ee">-0.16 (-0.22 to -0.09, p&lt;.001)</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-23e26513"><p class="cl-23e25a0f"><span class="cl-23e0e4ee">height</span></p></td><td class="cl-23e26514"><p class="cl-23e25a18"><span class="cl-23e0e4ee">[46,74]</span></p></td><td class="cl-23e2651c"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Mean ± SD</span></p></td><td class="cl-23e2651d"><p class="cl-23e25a18"><span class="cl-23e0e4ee">61.1 ± 5.7</span></p></td><td class="cl-23e2651e"><p class="cl-23e25a18"><span class="cl-23e0e4ee">0.13 (0.13 to 0.14, p&lt;.001)</span></p></td><td class="cl-23e2651e"><p class="cl-23e25a18"><span class="cl-23e0e4ee">0.10 (0.09 to 0.11, p&lt;.001)</span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-23e26508"><p class="cl-23e25a0f"><span class="cl-23e0e4ee">smoke</span></p></td><td class="cl-23e26509"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Non-smoker (N=589)</span></p></td><td class="cl-23e2650a"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Mean ± SD</span></p></td><td class="cl-23e2650b"><p class="cl-23e25a18"><span class="cl-23e0e4ee">3.3 ± 0.7</span></p></td><td class="cl-23e26512"><p class="cl-23e25a18"><span class="cl-23e0e4ee"></span></p></td><td class="cl-23e26512"><p class="cl-23e25a18"><span class="cl-23e0e4ee"></span></p></td></tr><tr style="overflow-wrap:break-word;"><td class="cl-23e2651f"><p class="cl-23e25a0f"><span class="cl-23e0e4ee"></span></p></td><td class="cl-23e26526"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Smoker     (N=65)</span></p></td><td class="cl-23e26527"><p class="cl-23e25a18"><span class="cl-23e0e4ee">Mean ± SD</span></p></td><td class="cl-23e26528"><p class="cl-23e25a18"><span class="cl-23e0e4ee">2.6 ± 0.9</span></p></td><td class="cl-23e26529"><p class="cl-23e25a18"><span class="cl-23e0e4ee">-0.71 (-0.93 to -0.49, p&lt;.001)</span></p></td><td class="cl-23e26529"><p class="cl-23e25a18"><span class="cl-23e0e4ee">0.09 (-0.03 to 0.20, p=.141)</span></p></td></tr></tbody><tfoot><tr style="overflow-wrap:break-word;"><td  colspan="6"class="cl-23e26530"><p class="cl-23e25a19"><span class="cl-23e0e4f9"></span><span class="cl-23e0e4e4"></span></p></td></tr></tfoot></table></div></template>
<div class="flextable-shadow-host" id="892db509-9a46-4d91-b369-9d90833a3289"></div>
<script>
var dest = document.getElementById("892db509-9a46-4d91-b369-9d90833a3289");
var template = document.getElementById("839db23e-7458-466b-85a0-5f8a70e4f3ad");
var fantome = dest.attachShadow({mode: 'open'});
var templateContent = template.content;
fantome.appendChild(templateContent);
</script>

```

```r
final=step(fit,trace=0)
summary(final)
```

```
## 
## Call:
## lm(formula = fev ~ age + sex + height + smoke, data = dat)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.37656 -0.25033  0.00894  0.25588  1.92047 
## 
## Coefficients:
##                  Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     -4.387117   0.239799 -18.295  < 2e-16 ***
## age              0.065509   0.009489   6.904 1.21e-11 ***
## sexMale         -0.157103   0.033207  -4.731 2.74e-06 ***
## height           0.104199   0.004758  21.901  < 2e-16 ***
## smokeNon-smoker  0.087246   0.059254   1.472    0.141    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4122 on 649 degrees of freedom
## Multiple R-squared:  0.7754,	Adjusted R-squared:  0.774 
## F-statistic:   560 on 4 and 649 DF,  p-value: < 2.2e-16
```





#### Multivariable regression
Our model of interest is: 
$$E[Y_{fev}] = \alpha + \beta_{age}*age + \beta_{height}*height + \beta_{smoking}*smoking +  \beta_{sex}*sex  $$

```r
fit=lm(fev~age+sex+height+smoke,data=dat)
datPlot <- data.frame(dat, fitted =  fit$fitted.values, residual = fit$residuals)
```


### Our FEV model, for now throw everything, Exposure of interesting smoking yes/no 
#### As usual, be sure to consult with DAF for real analysis 
#### No interaction term for now 

### Assumption 1 - Lienarity of outcome with fitted values (or x if univariate model)

```r
ggplot(data = datPlot, aes(y = fev, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs Observed outcome") + 
  geom_smooth(se = FALSE) + 
  geom_abline(slope = 1,linetype = "dashed")
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
ggplot(data = datPlot, aes(y = residual, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs residuals") + 
  geom_smooth(se = FALSE) + 
  geom_hline(yintercept = 0, linetype = "dashed")
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-6-2.png)<!-- -->

### Assumption 1 - plot by Sex and Smoking
#### Besure though, smokign is our exposure of interest, so we cannot subset data by smoke 

```r
ggplot(data = datPlot, aes(y = fev, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  facet_wrap(~smoke) + 
  ggtitle("Assumption 1: Fitted vs Observed outcome, \n by Smoke")+ 
  geom_abline(slope = 1,linetype = "dashed")
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

```r
ggplot(data = datPlot, aes(y = fev, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  facet_wrap(~sex) + 
  ggtitle("Assumption 1: Fitted vs Observed outcome, \n by Sex")+ 
  geom_abline(slope = 1,linetype = "dashed")
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-7-2.png)<!-- -->

### Assumption 1 - Perhaps, quadratic term in the regression model, since we saw that FEV is non-linear with age and height? This cold lead to residual confounding by age and height. 
#### Abter adding quadratic term for age and height, the association of fitted and observed FEV look linear **BUT**, the interpretation of age and height are no longer linear (quadratic term added), and there is a larger disagreement at higher values of fitted and observed. 

```r
dat$age2 <- dat$age*dat$age
dat$height2 <- dat$height*dat$height
fit=lm(fev~age +age2 +sex+height + height2+smoke,data=dat)
datPlot_Q <- data.frame(dat, fitted =  fit$fitted.values, residual = fit$residuals)

ggplot(data = datPlot_Q, aes(y = fev, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs Observed outcome, \n quadratic age and height")


ggplot(data = datPlot_Q, aes(y = fev, x = fitted, color = smoke)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs Observed outcome, \n quadratic age and height \n color separated by smoking ")

ggplot(data = datPlot, aes(y = fev, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs Observed outcome \ Original model ")
```

<img src="Regression_AssumptionOLS_files/figure-html/assumption 1 fig quadratic -1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/assumption 1 fig quadratic -2.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/assumption 1 fig quadratic -3.png" width="50%" />



### Assumption 2 - Independence of errors (residuals)



#### Assumption 3 - Constant dispersion of residuals across the value of fitted values (if multiple regression), or x (if univariate model) 

```r
ggplot(data = datPlot, aes(y = residual, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 3: Fitted vs residuals \n increase of variance \n but U-shaped") + 
  geom_smooth(se = FALSE) + 
  geom_hline(yintercept = 0, linetype = "dashed")
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

```r
ggplot(data = datPlot_Q, aes(y = residual, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 3: Fitted vs age \n increase of variance") + 
    geom_smooth(se = FALSE) + 
  geom_hline(yintercept = 0, linetype = "dashed")
```

```
## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

<img src="Regression_AssumptionOLS_files/figure-html/assumption 3 -1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/assumption 3 -2.png" width="50%" />

#### Assumption 3 - Constant dispersion of residuals across the value of fitted values (if multiple regression), or x (if univariate model) 

```r
ggplot(data = datPlot[datPlot$smoke == "Smoker", ], aes(y = residual, x = fitted)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 3: Fitted vs height \n smokers only") + 
  geom_hline(yintercept = 0, linetype = "dashed")
```

<img src="Regression_AssumptionOLS_files/figure-html/assumption 3 by smoking subset-1.png" width="50%" />


#### Assumption 3 - Constant dispersion of residuals across the value of fitted values (if multiple regression), or x (if univariate model) 

```r
ggplot(data = datPlot, aes(y = residual, x = age)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs age \n increase of variance") + 
  geom_hline(yintercept = 0, linetype = "dashed")

ggplot(data = datPlot, aes(y = residual, x = height)) + 
  geom_point() + 
  theme_classic() + 
  ggtitle("Assumption 1: Fitted vs height \n increase of variance \n and bit of u-shape") + 
  geom_hline(yintercept = 0, linetype = "dashed")
```

<img src="Regression_AssumptionOLS_files/figure-html/assumption 3 by covarites-1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/assumption 3 by covarites-2.png" width="50%" />


### Assumption 4 - Resisuals are normally distributed 
#### We typically do not get very normal distribution of residuals 

```r
hist(fit$residuals, main = "Histrogram of residuals, longer tails", breaks = 20)
qqnorm(fit$residuals)
qqline(fit$residuals)
```

<img src="Regression_AssumptionOLS_files/figure-html/assumption 4 -1.png" width="50%" /><img src="Regression_AssumptionOLS_files/figure-html/assumption 4 -2.png" width="50%" />

### Assumptions - Summary of residual diagnosis 

```r
plot(fit)
```

![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-9-1.png)<!-- -->![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-9-2.png)<!-- -->![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-9-3.png)<!-- -->![](Regression_AssumptionOLS_files/figure-html/unnamed-chunk-9-4.png)<!-- -->









