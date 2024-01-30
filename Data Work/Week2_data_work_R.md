---
title: "Week 2 Data Work"
output:
      html_document:
        keep_md: true
---



```r
library(rstatix)
library(tidyverse)
library(pastecs)
library(knitr)
library(epitools)
library(Epi)
options(scipen=999) 
```



```r
data <- read_csv("CANPATH_data_wrangling.csv")
```

```
## Rows: 41187 Columns: 9
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (1): ID
## dbl (8): ADM_STUDY_ID, SDC_GENDER, SDC_INCOME, HS_GEN_HEALTH, NUT_VEG_QTY, N...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## General instructions

### 1. Identify the variable types for each variable in the dataset

Example

__R__


```r
glimpse(data)
```

```
## Rows: 41,187
## Columns: 9
## $ ID              <chr> "SYN_58621", "SYN_58622", "SYN_58623", "SYN_58624", "S…
## $ ADM_STUDY_ID    <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, …
## $ SDC_GENDER      <dbl> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 2, …
## $ SDC_INCOME      <dbl> 6, 6, 4, 3, NA, 4, 5, 3, 3, 5, 8, NA, 3, 5, 4, 4, 4, N…
## $ HS_GEN_HEALTH   <dbl> 3, 4, 3, 4, 3, 5, 5, 3, 3, 4, 4, 4, 4, 5, 5, 3, 4, NA,…
## $ NUT_VEG_QTY     <dbl> 3, 0, 5, 1, 2, 5, 3, 5, 8, 1, 1, 3, 2, 2, 3, 1, 4, NA,…
## $ NUT_FRUITS_QTY  <dbl> 1, 0, 3, 3, 3, 5, 3, 2, 5, 0, 1, 5, 3, 1, 2, 1, 3, NA,…
## $ PA_TOTAL_SHORT  <dbl> 3564.0, 0.0, NA, 594.0, NA, NA, 2118.0, 297.0, NA, 240…
## $ DIS_ASTHMA_EVER <dbl> 0, 0, 2, 0, 1, 2, 0, NA, 0, 0, NA, 0, 0, 0, 0, 0, 0, 0…
```

All of the variables here currently coded as _dbl_ except `ID` which is _chr_. That's incorrect and we are going to need to fix that when we recode.

### 2. Recode and label categorical variables as necessary

__R__


```r
data <- data %>%
	mutate(gender_recode = case_when(
		SDC_GENDER == 1 ~ "Male",
    SDC_GENDER == 2 ~ "Female"
	))

data$gender_recode <- as.factor(data$gender_recode) 

### Checking our code to make sure our recode is correct
table(data$SDC_GENDER, data$gender_recode)
```

```
##    
##     Female  Male
##   1      0 15200
##   2  25987     0
```

### 3. Add the `NUT_VEG_QTY` and the `NUT_FRUITS_QTY` to create one variable
    * Create a categorical variable that represents the recommended fruit and vegetable consumption per day

__R__


```r
summary(data$NUT_VEG_QTY)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   2.000   2.000   2.672   3.000  35.000    2549
```

```r
summary(data$NUT_FRUITS_QTY)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   1.000   2.000   2.132   3.000  25.000    2426
```

```r
### No missing data the no weird codings for the numbers. Great! 

data <- data %>%
	mutate(fruit_veg_tot = NUT_VEG_QTY + NUT_FRUITS_QTY)

summary(data$fruit_veg_tot)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   3.000   4.000   4.816   6.000  55.000    2908
```

```r
data <- data %>%
	mutate(fruit_veg_cat = case_when(
		fruit_veg_tot <= 7  ~ "Not Meeting Guidelines",
    fruit_veg_tot > 7 ~ "Meeting Guidelines"
	))

table(data$fruit_veg_cat)
```

```
## 
##     Meeting Guidelines Not Meeting Guidelines 
##                   5237                  33042
```

```r
data <- data %>%
	mutate(fruit_veg_dic = case_when(
		fruit_veg_tot <= 7 ~ 0,
    fruit_veg_tot > 7 ~ 1
	))

table(data$fruit_veg_tot, data$fruit_veg_cat)
```

```
##     
##      Meeting Guidelines Not Meeting Guidelines
##   0                   0                    404
##   1                   0                   1561
##   2                   0                   5015
##   3                   0                   5807
##   4                   0                   6720
##   5                   0                   5525
##   6                   0                   4955
##   7                   0                   3055
##   8                2200                      0
##   9                1213                      0
##   10                816                      0
##   11                433                      0
##   12                226                      0
##   13                125                      0
##   14                 87                      0
##   15                 29                      0
##   16                 45                      0
##   17                 13                      0
##   18                 12                      0
##   19                  4                      0
##   20                  7                      0
##   21                  1                      0
##   22                  2                      0
##   24                  1                      0
##   25                  1                      0
##   26                  1                      0
##   27                  2                      0
##   28                  4                      0
##   30                  2                      0
##   31                  1                      0
##   32                  3                      0
##   34                  1                      0
##   35                  1                      0
##   44                  1                      0
##   45                  1                      0
##   49                  2                      0
##   50                  1                      0
##   51                  1                      0
##   55                  1                      0
```

### 4. Create a categorical variable for the `PA_TOTAL_SHORT` variable the defines low, moderate, and high activity per week
    * Low - < 600 MET minutes per week
    * Moderate - >=600 to <3000 MET minutes per week
    * High - >=3000 MET minutes per week

### 5. Calculate the mean and standard deviation
    * For the variables were it is appropriate
    * Including the new variables you have created
    

```r
summary(data$PA_TOTAL_SHORT)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0     600    1782    2574    3732   19278    6763
```

```r
data <- data %>%
	mutate(pa_cat = case_when(
		PA_TOTAL_SHORT < 600  ~ "Low Activity",
		PA_TOTAL_SHORT >= 3000 ~ "High Activity",
		PA_TOTAL_SHORT >= 600 ~ "Moderate Activity"
	))

### Flag we need to put the low and how activity first otherwise we don't get the right answer
```

### 6. Calculate the percents and frequencies 
    * For the variables were it is appropriate to do so

There are __MANY__ different ways to do this in R. There is no one best way. 


```r
## First we need to make sure we get the variables recoded and organized

### Example with gender where we already recoded
gender_table <- bind_rows(table(data$gender_recode), prop.table(table(data$gender_recode)))

### Example with fruit_veg_cat where we already recoded
fruit_veg_table <- bind_rows(table(data$fruit_veg_cat), prop.table(table(data$fruit_veg_cat)))
```

### 7. Are there missing data?


```r
summary(data$fruit_veg_tot)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   3.000   4.000   4.816   6.000  55.000    2908
```

### 8. Create a 2*2 table for fruit and vegetable consumption by gender
    * Interpret the 2*2 table result


```r
gender_fv_table <- table(data$gender_recode, data$fruit_veg_cat)
gender_fv_table
```

```
##         
##          Meeting Guidelines Not Meeting Guidelines
##   Female               4004                  20213
##   Male                 1233                  12829
```

```r
epitab(gender_fv_table, method = "oddsratio")
```

```
## $tab
##         
##          Meeting Guidelines        p0 Not Meeting Guidelines        p1
##   Female               4004 0.7645599                  20213 0.6117366
##   Male                 1233 0.2354401                  12829 0.3882634
##         
##          oddsratio    lower   upper
##   Female  1.000000       NA      NA
##   Male    2.061071 1.926424 2.20513
##         
##                                                                                                                     p.value
##   Female                                                                                                                 NA
##   Male   0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001651292
## 
## $measure
## [1] "wald"
## 
## $conf.level
## [1] 0.95
## 
## $pvalue
## [1] "fisher.exact"
```

## OOOPSSSS 

#### Epitab expects

| --- | --- | Disease | --- | 
| --- | --- | --- | --- | --- |
| --- | --- | No (REF) | Yes |
| Exposure | Level 1 (REF) | a | b | 
| --- | Level 2 | c | d | 

#### We gave it 

| --- | --- | Disease | --- | 
| --- | --- | --- | --- | --- |
| --- | --- | Yes  | No (REF) |
| Exposure | Level 1 (REF) | a | b | 
| --- | Level 2 | c | d | 


```r
gender_fv_table <- table(data$gender_recode, data$fruit_veg_cat)
gender_fv_table
```

```
##         
##          Meeting Guidelines Not Meeting Guidelines
##   Female               4004                  20213
##   Male                 1233                  12829
```

```r
epitab(gender_fv_table, method = "oddsratio", rev = "columns") ## Here we flip the columns around to get the right answer for males. 
```

```
## $tab
##         
##          Not Meeting Guidelines        p0 Meeting Guidelines        p1
##   Female                  20213 0.6117366               4004 0.7645599
##   Male                    12829 0.3882634               1233 0.2354401
##         
##          oddsratio    lower     upper
##   Female 1.0000000       NA        NA
##   Male   0.4851846 0.453488 0.5190966
##         
##                                                                                                                     p.value
##   Female                                                                                                                 NA
##   Male   0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001651292
## 
## $measure
## [1] "wald"
## 
## $conf.level
## [1] 0.95
## 
## $pvalue
## [1] "fisher.exact"
```
   
