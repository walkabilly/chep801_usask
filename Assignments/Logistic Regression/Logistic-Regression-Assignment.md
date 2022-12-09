---
title: "Logistic Regression Assignment"
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

# Logistic Regression Assignment

## General instructions

You must submit the following. 

**Stata**

* Stata Log File
* Stata Do File
* Report in Word doc form with tables/figures cut and pasted from Stata output file

**R**

* RMarkdown file
* Knit report in HTML or PDF

## Part 1 - Statistical Model Building

You are interested in examining the association between the occurrence of major depression at any point during the life of the participant `DIS_DEP_EVER` and physical activity `PA_TOTAL_SHORT`. It is well known that there are many factors associated with depression [https://doi.org/10.1176/appi.ajp.2020.19111158](https://doi.org/10.1176/appi.ajp.2020.19111158). There also been attempts to develop data driven DAGs for depression as it is such an outcome with a very complicated causal web [https://doi.org/10.3389/fpsyt.2022.809745](https://doi.org/10.3389/fpsyt.2022.809745).

Your task in this analysis is to determine which variables should be included in a regression model examining the association between depression and physical activity. We previously learned two approaches for determining which variables should be included in a model

1. A DAG/theory based approach
2. A data driven/model fit approach

This assignment requires you to do the following

1. Present a model building approach based on the DAG/theory based approach
2. Present a model building approach based on the data driven/model fit approach
3. Compare the results between your DAG/theory approach and your data driven/model fit approach

## Part 2 - Format and Effort 

### General Formatting
- A combination sentences/paragraphs with some bullet points is appropriate.
- Include a list of references where appropriate. For this assignment, you do not need to worry
about providing references to the scales/items within the dataset.

### Overall
- Assignments will be evaluated based on the overall effort and thoroughness of the assignment, attention to details, and overall presentation of results.

## Data

We will again be using the CanPath data. For this assignment you have access to the entire CanPath dataset. Your key variables of interest are

1. Outcome (__Hint. You will need to recode this variable__)
    * Occurrence of major depression at any point during the life of the participant
    * Variable name - `DIS_DEP_EVER`
2. Exposure (__Hint. In the data wrangling assignment we recoded this variable into 3 categories__)
    * Quantitative indicator of global physical activity in metabolic equivalent (MET)-minutes per week (IPAQ short form)
    * Variable name - `PA_TOTAL_SHORT`
