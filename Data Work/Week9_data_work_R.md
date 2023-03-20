---
title: "Week 9 Data Work"
output:
      html_document:
        keep_md: true
---



### 1. Logistic Regression - The Machine Learning Way
 
Here we are going to take exactly the same logistic regression problem we used in the Week 4 data work and do the same analysis using a machine learning way of thinking rather than a statistics/epi way of of thinking. Same exact data, different approach. This is a supervised learning classification example. There are other classifiers and we could use decision tress or random forest for this problem if we wanted. 

#### Variable selection

In general machine learning does really care about which variables go into your model, rather we care about how the model as a whole performs in training versus testing. 

### 2. Research question and data

Our research question is:  

- **Can we develop a model that will predict type 2 diabetes**

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

data_working$diabetes_t2 <- as.factor(data_working$diabetes_t2)

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

data_working$diabetes_gestat <- as.factor(data_working$diabetes_gestat)


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
		SDC_EB_LATIN == 1 ~ "Yes",
		SDC_EB_LATIN == 0 ~ "No"
	))

table(data_working$SDC_EB_LATIN, data_working$latinx)
```

```
##    
##        No   Yes
##   0 36221     0
##   1     0   451
```

```r
### Indigenous

data_working <- data_working %>%
	mutate(indigenous = case_when(
		SDC_EB_ABORIGINAL == 1 ~ "Yes",
		SDC_EB_ABORIGINAL == 0 ~ "No"
	))

table(data_working$SDC_EB_ABORIGINAL, data_working$indigenous)
```

```
##    
##        No   Yes
##   0 35331     0
##   1     0  1351
```

```r
### Black

data_working <- data_working %>%
	mutate(black = case_when(
		SDC_EB_BLACK == 1 ~ "Yes",
		SDC_EB_BLACK == 0 ~ "No"
	))

table(data_working$SDC_EB_BLACK, data_working$black)
```

```
##    
##        No   Yes
##   0 36149     0
##   1     0   518
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

#### 3. Preliminary analysis and setup

We are going to use the [Tidymodels](https://www.tidymodels.org/) framework for this analysis since we are in the Tidyverse world for this course. On our previous examples for logistic and linear regression we did not use the tidyverse framework. 

More machine learning we need a way to split the data into a training set and a test set. There are a few different approaches too this. Here we are going to use an 70/30 split with 70% of the data going to training and 30 going to testing. This is sort of an older way to split data and I would say that a k-fold cross validation is probably more in line with modern practice... but we are here for the learning. 


```r
# Fix the random numbers by setting the seed 
# This enables the analysis to be reproducible when random numbers are used 
set.seed(222)
# Put 3/4 of the data into the training set 
data_split <- initial_split(data_working, prop = 0.80)

# Create data frames for the two sets:
train_data <- training(data_split)
test_data  <- testing(data_split)
```

Now we have split the data, we want to create the model for the training data and save it so it can be applied to the testing set. 

```{}
lr_mod <- 
  logistic_reg(diabetes_t2 ~ bmi_overweight + age_45 + pa_cat + latinx + indigenous + black + fatty_liver, data = training_data) %>% 
  set_engine("glm")
```
