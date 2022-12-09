---
title: "Data Wrangling Example"
output:
      html_document:
        keep_md: true
---



```r
library(rstatix)
library(tidyverse)
library(pastecs)
library(knitr)
library(tableone)
```



```r
data <- read_csv("CANPTH_data_wrangling.csv")
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

# Data Wrangling and Descriptive Statistics

## General instructions

You must submit the following. 

**Stata**

* Stata Log File
* Stata Do File
* Report in Word doc form with tables/figures cut and pasted from Stata output file

**R**

* RMarkdown file
* Knit report in HTML or PDF

## Part 1 - Explore the data 

1. Identify the variable types for each variable in the dataset

Example

R


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

Stata

```{}
```

All of the variables here currently coded as _dbl_ except `ID` which is _chr_. That's incorrect and we are going to need to fix that when we recode.

Stata

```{}

```

2. Recode and label categorical variables as necessary

R


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

Stata

```{}

```

2. Add the `NUT_VEG_QTY` and the `NUT_FRUITS_QTY` to create one variable
    * Create a categorical variable that represents the recommended fruit and vegetable consumption per day
3. Create a categorical variable for the `PA_TOTAL_SHORT` variable the defines low, moderate, and high activity per week
    * Low - < 600 MET minutes per week
    * Moderate - >=600 to <3000 MET minutes per week
    * High - >=3000 MET minutes per week
4. Calculate the mean and standard deviation
    * For the variables were it is appropriate
    * Including the new variables you have created
    

```r
CreateTableOne(data = data,
               vars = c("NUT_VEG_QTY", "NUT_FRUITS_QTY"),
               includeNA = TRUE)
```

```
##                             
##                              Overall     
##   n                          41187       
##   NUT_VEG_QTY (mean (SD))     2.67 (1.68)
##   NUT_FRUITS_QTY (mean (SD))  2.13 (1.41)
```

Stata

```{}

```


5. Calculate the percents and frequencies 
    * For the variables were it is appropriate to do so
    
```{}
```

Stata



    
6. Draw the histogram of continuous variables
    * Discuss the normality of the data 
7. Are there missing data? 
8. Are there outliers? 
9. Create a 2*2 table for fruit and vegetable consumption by gender
    * Interpret the 2*2 table result

## Part 2 - Format and Effort 

### General Formatting
- A combination sentences/paragraphs with some bullet points is appropriate.
- Include a list of references where appropriate. For this assignment, you do not need to worry
about providing references to the scales/items within the dataset.

### Overall
- Assignments will be evaluated based on the overall effort and thoroughness of the assignment, attention to details, and overall presentation of results.

## Data

In this course we will use the CanPath Student Dataset that provides students the unique opportunity to gain hands-on experience working with CanPath data. For the purpose of this assignment we will use a simplified CanPath dataset with only 9 variables of interest. 


