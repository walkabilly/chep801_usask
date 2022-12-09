---
title: "Data Wrangling Assignment"
output:
      html_document:
        keep_md: true
---


```r
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(pastecs)
library(knitr)
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
2. Recode and label categorical variables as necessary
2. Add the `NUT_VEG_QTY` and the `NUT_FRUITS_QTY` to create one variable
    * Create a categorical variable that represents the recommended fruit and vegetable consumption per day
3. Create a categorical variable for the `PA_TOTAL_SHORT` variable the defines low, moderate, and high activity per week
    * Low - < 600 MET minutes per week
    * Moderate - >=600 to <3000 MET minutes per week
    * High - >=3000 MET minutes per week
4. Calculate the mean and standard deviation
    * For the variables were it is appropriate
    * Including the new variables you have created
5. Calculate the percents and frequencies 
    * For the variables were it is appropriate to do so
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

In this course we will use the CanPath Student Dataset that provides students the unique opportunity to gain hands-on experience working with CanPath data. The CanPath Student Dataset is a synthetic dataset that was manipulated to mimic CanPath’s nationally harmonized data but does not include or reveal actual data of any CanPath participants.
The CanPath Student Dataset is available to instructors at a Canadian university or college for use in an academic course, at no cost. 

* Large sample size (Over 40,000 participants)
* Real-world population-level Canadian data
* Variety of areas of information allowing for a wide range of research topics
* No cost to faculty
* Potential for students to apply for real CanPath data to publish their findings


