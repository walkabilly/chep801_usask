---
title: "Week 3 Data Work"
output:
      html_document:
        keep_md: true
---



## Data Viz

### 1. Logistic Regression

A logistic regression is a type of regression where the outcome variable is a 0 or 1 variable. That is the outcome can only have 2 possible values. The logistic in logistic regression refers to the fact that we are using a logistic function to fit a model for the 2 possible values (more on this later). More generally, logistic regression in a form of classification problem where we want to try and predict which group a unit (in our case usually a person) belongs to using variables about that unit. In logistic regression the outcome must be 0 or 1 but we can include both continous and categorical predictors in the model.

#### Variable selection

For this data work we are not going to worry about variable selection. Variable selection should be based on subject area knowledge about the study design and research question. Ideally, variable selection is done with the help of a DAG. 

### 2. Research question and data

Our research question is:  

- **What factors are associated with ever having been diagnosed with type 2 diabetes?**

We have created a DAG and identified that the following factors are associated with type 2 diabetes:   

- `No varaible in data` = Have prediabetes
- `PM_BMI_SR` = Are overweight
- `SDC_AGE_CALC` = Are 45 years or older
- `No varaible in data` = Have a parent, brother, or sister with type 2 diabetes
- `PA_LEVEL_LONG` = Are physically active less than 3 times a week
- `diabetes == "Gestational"` = Have ever had gestational diabetes (diabetes during pregnancy) or given birth to a baby who weighed over 9 pounds
- `SDC_EB_ABORIGINAL` + `SDC_EB_LATIN` + `SDC_EB_BLACK` = Are an African American, Hispanic or Latino, American Indian, or Alaska Native person
- `DIS_LIVER_FATTY_EVER` = Have non-alcoholic fatty liver disease

Let's simplify the dataset so we are not working with so many variables. 


```r
data_working <- select(data, "DIS_DIAB_TYPE", "PM_BMI_SR", "SDC_AGE_CALC", "PA_LEVEL_SHORT", "SDC_EB_ABORIGINAL", "SDC_EB_LATIN", "SDC_EB_BLACK", "DIS_LIVER_FATTY_EVER")

rm(data) ### Remove the old data from working memory
```

#### Outcome variable

Let's look at the outcome variable, recode, and drop observations that are not relevant. We know that the GLM function needs a 0/1 variable and we want to recode that way now so we don't need to change it after. We also know we want to keep our gestational diabetes variable because we need it later. 


```r
table(data_working$DIS_DIAB_TYPE)
```

```
## 
##    -7     1     2     3 
## 36807   315  2160   425
```

```r
data_working <- data_working %>%
	mutate(diabetes_t2 = case_when(
    DIS_DIAB_TYPE == 2 ~ 1,
    DIS_DIAB_TYPE == -7 ~ 0, 
		TRUE ~ NA_real_
	))

table(data_working$diabetes_t2, data_working$DIS_DIAB_TYPE)
```

```
##    
##        -7     1     2     3
##   0 36807     0     0     0
##   1     0     0  2160     0
```

```r
data_working <- data_working %>%
	mutate(diabetes_gestat = case_when(
    DIS_DIAB_TYPE == 3 ~ 1,
    DIS_DIAB_TYPE == -7 ~ 0, 
		TRUE ~ NA_real_
	))

data_working <- filter(data_working, diabetes_t2 == 0 | diabetes_t2 == 1 | diabetes_gestat == 1)
```

For logistic regression in the case of a cross-section study we want the outcome to be ~10% of the total sample. Here we have `2160/36807*100 = 5.86%`. 

#### Preparing predictor variables

**BMI overweight**


```r
glimpse(data_working$PM_BMI_SR)
```

```
##  num [1:39392] NA 28.3 25.5 44.8 NA ...
```

```r
summary(data_working$PM_BMI_SR) ### Lots of NAs! 
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    8.86   23.34   26.58   27.53   30.52   69.40   11124
```

```r
data_working <- data_working %>%
	mutate(bmi_overweight = case_when(
	  PM_BMI_SR >= 25.00 ~ "Overweight",
		PM_BMI_SR < 25.00 ~ "Not Overweight"
	))

table(data_working$bmi_overweight)
```

```
## 
## Not Overweight     Overweight 
##          10607          17661
```

**Age**


```r
glimpse(data_working$SDC_AGE_CALC)
```

```
##  num [1:39392] 47 57 62 64 40 36 63 58 60 41 ...
```

```r
summary(data_working$SDC_AGE_CALC) ### Lots of NAs! 
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    30.0    43.0    52.0    51.5    60.0    74.0
```

```r
data_working <- data_working %>%
	mutate(age_45 = case_when(
	  SDC_AGE_CALC >= 45.00 ~ "Over 45",
		SDC_AGE_CALC < 45.00 ~ "Under 45"
	))

table(data_working$age_45)
```

```
## 
##  Over 45 Under 45 
##    28415    10977
```

**Physical Activity**


```r
glimpse(data_working$PA_LEVEL_SHORT)
```

```
##  num [1:39392] 3 1 NA NA NA 3 1 NA 3 3 ...
```

```r
table(data_working$PA_LEVEL_SHORT)
```

```
## 
##     1     2     3 
##  9538 10606 13140
```

```r
data_working <- data_working %>%
	mutate(pa_cat = case_when(
		PA_LEVEL_SHORT == 1 ~ "1_Low Activity",
		PA_LEVEL_SHORT == 2 ~ "2_Moderate Activity",
		PA_LEVEL_SHORT == 3 ~ "3_High Activity"
	))

table(data_working$pa_cat, data_working$PA_LEVEL_SHORT)
```

```
##                      
##                           1     2     3
##   1_Low Activity       9538     0     0
##   2_Moderate Activity     0 10606     0
##   3_High Activity         0     0 13140
```

**Racialized**


```r
table(data_working$SDC_EB_ABORIGINAL)
```

```
## 
##     0     1 
## 35331  1351
```

```r
table(data_working$SDC_EB_LATIN)
```

```
## 
##     0     1 
## 36221   451
```

```r
table(data_working$SDC_EB_BLACK)
```

```
## 
##     0     1 
## 36149   518
```

```r
### Latinx

data_working <- data_working %>%
	mutate(latinx = case_when(
		SDC_EB_LATIN == 1 ~ "Latinx",
		SDC_EB_LATIN == 0 ~ "Not Latinx"
	))

table(data_working$SDC_EB_LATIN, data_working$latinx)
```

```
##    
##     Latinx Not Latinx
##   0      0      36221
##   1    451          0
```

```r
### Indigenous

data_working <- data_working %>%
	mutate(indigenous = case_when(
		SDC_EB_ABORIGINAL == 1 ~ "Indigenous",
		SDC_EB_ABORIGINAL == 0 ~ "Not Indigenous"
	))

table(data_working$SDC_EB_ABORIGINAL, data_working$indigenous)
```

```
##    
##     Indigenous Not Indigenous
##   0          0          35331
##   1       1351              0
```

```r
### Black

data_working <- data_working %>%
	mutate(black = case_when(
		SDC_EB_BLACK == 1 ~ "Black",
		SDC_EB_BLACK == 0 ~ "Not Black"
	))

table(data_working$SDC_EB_BLACK, data_working$black)
```

```
##    
##     Black Not Black
##   0     0     36149
##   1   518         0
```

**Fatty liver disease**


```r
table(data_working$DIS_LIVER_FATTY_EVER)
```

```
## 
##   1   2 
##  50 199
```

```r
data_working <- data_working %>%
	mutate(fatty_liver = case_when(
		DIS_LIVER_FATTY_EVER == 1 ~ "Yes",
		DIS_LIVER_FATTY_EVER == 2 ~ "Yes"
	))

data_working <- data_working %>%
	mutate(fatty_liver = case_when(
		DIS_LIVER_FATTY_EVER == 1 ~ "Yes",
		DIS_LIVER_FATTY_EVER == 2 ~ "Yes"
	))

data_working <- data_working %>% 
                  mutate(fatty_liver = replace_na(fatty_liver, "No"))

table(data_working$fatty_liver)
```

```
## 
##    No   Yes 
## 39143   249
```

#### 3. Preliminary analysis

We want to start by doing bivariable regression on the outcome and each variable. This can a be a bit of a process if we have lots of variables. Here we are using the `glm` (General Linear Model) function. 


```r
table(data_working$diabetes_t2, data_working$bmi_overweight)
```

```
##    
##     Not Overweight Overweight
##   0          10171      16329
##   1            349       1144
```

```r
model_weight <- glm(diabetes_t2 ~ bmi_overweight, data = data_working, family = "binomial")
summary(model_weight)
```

```
## 
## Call:
## glm(formula = diabetes_t2 ~ bmi_overweight, family = "binomial", 
##     data = data_working)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.3680  -0.3680  -0.3680  -0.2598   2.6100  
## 
## Coefficients:
##                          Estimate Std. Error z value Pr(>|z|)    
## (Intercept)              -3.37222    0.05444  -61.95   <2e-16 ***
## bmi_overweightOverweight  0.71381    0.06244   11.43   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 11657  on 27992  degrees of freedom
## Residual deviance: 11512  on 27991  degrees of freedom
##   (11399 observations deleted due to missingness)
## AIC: 11516
## 
## Number of Fisher Scoring iterations: 6
```

```r
exp(cbind(coef(model_weight), confint(model_weight))) ## Old school way
```

```
## Waiting for profiling to be done...
```

```
##                                          2.5 %     97.5 %
## (Intercept)              0.03431324 0.03078491 0.03811045
## bmi_overweightOverweight 2.04175987 1.80871009 2.31048759
```




