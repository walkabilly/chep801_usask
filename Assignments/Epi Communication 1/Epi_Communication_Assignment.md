---
title: "Epi Communication 1"
author: "Daniel Fuller"
output:
  html_document:
    keep_md: yes
  word_document: default
  pdf_document: default
---



# Epi Communication Assignment 1



# Assignment 

The following analysis uses the Can-Path Dataset available in Canvas.  

One of your biostatistician staff has conducted an analysis examining the association between different social and behavioural factors on Body Mass Index using the Can-Path dataset. Your goal as a epidemiologist is to use the analysis provided and develop a one page communication report/document to communicate the beginning of health promotion strategy for your region. You can write text, develop an infographic, and use outside knowledge to support the development of your report. You can also use figures or tables that are available in the analysis as part of the one page document. 

Example documents you could use for inspiration include: 

- [Canada’s Guidance on Alcohol and Health](https://ccsa.ca/canadas-guidance-alcohol-and-health)
- [Describing Epidemiologic Data](https://www.cdc.gov/eis/field-epi-manual/chapters/Describing-Epi-Data.html)
- [Using Social Determinants of Health Data to Generate Value](https://hitconsultant.net/2018/06/08/social-determinants-of-health-2/)
- [HIV Transmission from Mother to Child](https://www.nichd.nih.gov/newsroom/digital-media/infographics/HIV-AIDS)

It is crucial when discussing obesity and weight status that we avoid adding to stigma as researchers and epidemiologists. There are a number of health consequences to weight stigma that we must attempt to avoid. At the same time, we need to work with people to try and improve health. Some resources here: 

1. Puhl, R M., Wharton, C M. Weight Bias: A Primer for the Fitness Industry. Health & Fitness Journal. 2007; 11(3), p 7-11. [https://doi.org/10.1249/01.FIT.0000269060.03465.ab](https://doi.org/10.1249/01.FIT.0000269060.03465.ab)
2. Phelan SM, Burgess DJ, Yeazel MW, Hellerstedt WL, Griffin JM, van Ryn M. Impact of weight bias and stigma on quality of care and outcomes for patients with obesity. Obes Rev. 2015;16(4):319-326. [https://doi.org/10.1111/obr.12266](https://doi.org/10.1111/obr.12266).
3. Puhl RM, Himmelstein MS, Pearl RL. Weight stigma as a psychosocial contributor to obesity. Am Psychol. 2020;75(2):274-289. [https://doi.org/10.1037/amp0000538](https://doi.org/10.1037/amp0000538)

### Outcome

The outcome is BMI. The histogram and summary statistics of the BMI variable is below. 



![](Epi_Communication_Assignment_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   15.16   23.34   26.52   27.35   30.27   49.94
```

### Behavioural Factors

The behavioural factors included in the analysis are smoking, physical activity, alcohol consumption, and fruit and vegetable consumption. The descriptive statistics for the 

#### SMK_CIG_CUR_FREQ  

Variable outlining the smoking status of participants. 

(0) Does not smoke currently  
(1) Current occasional smoker  
(2) Current daily smoker  
(3) Never smoked  




```
##             SMK_CIG_CUR_FREQ     n percent
##   0_Does not smoke currently  7552   33.8%
##  1_Current occasional smoker   554    2.5%
##       2_Current daily smoker  1782    8.0%
##               3_Never smoked 12488   55.8%
```

#### PA_LEVEL_SHORT   

Variable outlining the physical activity level of participants. 

(1) Low level of physical activity  
(2) Moderate level of physical activity  
(3) High level of physical activity  


```
##          PA_LEVEL_SHORT    n percent
##       1_Low level of PA 6067   27.1%
##  2_Moderate level of PA 7297   32.6%
##      3_High level of PA 9012   40.3%
```

#### ALC_CUR_FREQ   

Variable outlining the number (units are a bit all over the place) of alcoholic beverages consumed. 

(0) Never  
(1) Less than once a month  
(2) About once a month  
(3) 2 to 3 times a month  
(4) Once a week  
(5) 2 to 3 times a week  
(6) 4 to 5 times a week  
(7) 6 to 7 times a week  




```
##              ALC_CUR_FREQ    n percent
##                   0_Never 1394    6.5%
##  1_Less than once a month 3848   18.1%
##      2_About once a month 1766    8.3%
##    3_2 to 3 times a month 2758   12.9%
##             4_Once a week 2536   11.9%
##     5_2 to 3 times a week 4173   19.6%
##     6_4 to 5 times a week 2465   11.6%
##     7_6 to 7 times a week 2373   11.1%
```

#### FRUIT_VEG   

Count of the number of fruit and vegetables consumed per week. 



![](Epi_Communication_Assignment_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   3.000   4.000   4.768   6.000  51.000
```

### Social and Demographic Factors

The social and demographic factors included in the analysis are age, income category, student status, and education level. The descriptive statistics for these variables is below: 

#### SDC_GENDER

Variable representing the gender of participants. 

(1)	Male
(2)	Female


```
##  SDC_GENDER     n percent
##      Female 12058   56.6%
##        Male  9255   43.4%
```

#### SDC_AGE_CALC 

Age of the participant at the time of completing the survey. 


```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   30.00   43.00   52.00   51.33   60.00   74.00
```

#### SDC_INCOME   

Variable representing the income of participants. 

(1)	Less than 10 000 $
(2)	10 000 $ - 24 999 $
(3)	25 000 $ - 49 999 $
(4)	50 000 $ - 74 999 $
(5)	75 000 $ - 99 999 $
(6)	100 000 $ - 149 999 $
(7)	150 000 $ - 199 999 $
(8)	200 000 $ or more


```
##             SDC_INCOME    n percent
##    1_Less than 24 999$ 1371    6.4%
##    2_25 000$ - 49 999$ 3207   15.0%
##    3_50 000$ - 74 999$ 4051   19.0%
##    4_75 000$ - 99 999$ 4162   19.5%
##  5_100 000$ - 149 999$ 4771   22.4%
##  6_150 000$ - 199 999$ 2204   10.3%
##     7_200 000$ or more 1547    7.3%
```

#### WRK_STUDENT  

Variable representing if a participant is a student or not. 

(0)	Participant is not a student
(1)	Participant is a student


```
##  WRK_STUDENT     n percent
##            0 21118   99.1%
##            1   195    0.9%
```

#### SDC_EDU_LEVEL   

Variable representing the education level of participants. 

(0)	None
(1)	Elementary school
(2)	High school
(3)	Trade, technical or vocational school, apprenticeship training or technical CEGEP
(4)	Diploma from a community college, pre-university CEGEP or non-university certificate
(5)	University certificate below bachelor's level
(6)	Bachelor's degree
(7)	Graduate degree (MSc, MBA, MD, PhD, etc.)


```
##                                    SDC_EDU_LEVEL    n percent
##                      1_Elementary school or less  267    1.3%
##                                    2_High school 3803   17.8%
##          3_Trade, technical or vocational school 1775    8.3%
##               4_Diploma from a community college 5186   24.3%
##  5_University certificate below bachelor's level  878    4.1%
##                              6_Bachelor's degree 5996   28.1%
##                                7_Graduate degree 3408   16.0%
```

# Linear Regression

## Behavioural Variables


|   |Dependent: PM_BMI_SR |                                                |unit      |value      |Coefficient (univariable)       |Coefficient (multivariable)     |
|:--|:--------------------|:-----------------------------------------------|:---------|:----------|:-------------------------------|:-------------------------------|
|28 |SMK_CIG_CUR_FREQ     |0_Does not smoke currently                      |Mean (sd) |27.6 (5.6) |-                               |-                               |
|29 |                     |1_Current occasional smoker                     |Mean (sd) |27.7 (5.8) |0.06 (-0.42 to 0.55, p=0.795)   |0.30 (-0.18 to 0.79, p=0.218)   |
|30 |                     |2_Current daily smoker                          |Mean (sd) |27.8 (6.1) |0.17 (-0.13 to 0.46, p=0.269)   |0.04 (-0.25 to 0.33, p=0.795)   |
|31 |                     |3_Never smoked                                  |Mean (sd) |27.1 (5.5) |-0.50 (-0.66 to -0.33, p<0.001) |-0.28 (-0.45 to -0.11, p=0.001) |
|10 |PA_LEVEL_SHORT       |1_Low level of PA                               |Mean (sd) |28.1 (6.1) |-                               |-                               |
|11 |                     |2_Moderate level of PA                          |Mean (sd) |27.5 (5.6) |-0.63 (-0.83 to -0.44, p<0.001) |-0.50 (-0.70 to -0.31, p<0.001) |
|12 |                     |3_High level of PA                              |Mean (sd) |26.7 (5.3) |-1.38 (-1.56 to -1.19, p<0.001) |-1.19 (-1.38 to -1.00, p<0.001) |
|1  |ALC_CUR_FREQ         |0_Never                                         |Mean (sd) |28.4 (6.1) |-                               |-                               |
|2  |                     |1_Less than once a month                        |Mean (sd) |27.8 (6.0) |-0.59 (-0.94 to -0.25, p=0.001) |-0.47 (-0.81 to -0.14, p=0.006) |
|3  |                     |2_About once a month                            |Mean (sd) |27.5 (5.7) |-0.87 (-1.26 to -0.47, p<0.001) |-0.64 (-1.03 to -0.25, p=0.001) |
|4  |                     |3_2 to 3 times a month                          |Mean (sd) |27.5 (5.7) |-0.92 (-1.28 to -0.56, p<0.001) |-0.69 (-1.05 to -0.33, p<0.001) |
|5  |                     |4_Once a week                                   |Mean (sd) |26.8 (5.2) |-1.58 (-1.95 to -1.22, p<0.001) |-1.39 (-1.76 to -1.03, p<0.001) |
|6  |                     |5_2 to 3 times a week                           |Mean (sd) |27.0 (5.3) |-1.39 (-1.73 to -1.05, p<0.001) |-1.18 (-1.52 to -0.84, p<0.001) |
|7  |                     |6_4 to 5 times a week                           |Mean (sd) |27.0 (5.4) |-1.35 (-1.72 to -0.98, p<0.001) |-1.24 (-1.61 to -0.88, p<0.001) |
|8  |                     |7_6 to 7 times a week                           |Mean (sd) |27.3 (5.4) |-1.07 (-1.44 to -0.70, p<0.001) |-1.05 (-1.42 to -0.68, p<0.001) |
|9  |FRUIT_VEG            |[0.0,51.0]                                      |Mean (sd) |27.3 (5.6) |-0.15 (-0.18 to -0.12, p<0.001) |-0.10 (-0.13 to -0.07, p<0.001) |
|13 |SDC_AGE_CALC         |[30.0,74.0]                                     |Mean (sd) |27.3 (5.6) |0.04 (0.03 to 0.04, p<0.001)    |0.04 (0.03 to 0.04, p<0.001)    |
|21 |SDC_INCOME           |1_Less than 24 999$                             |Mean (sd) |28.0 (6.4) |-                               |-                               |
|22 |                     |2_25 000$ - 49 999$                             |Mean (sd) |27.7 (5.8) |-0.38 (-0.73 to -0.02, p=0.037) |-0.36 (-0.71 to -0.01, p=0.045) |
|23 |                     |3_50 000$ - 74 999$                             |Mean (sd) |27.5 (5.6) |-0.51 (-0.86 to -0.17, p=0.003) |-0.26 (-0.61 to 0.08, p=0.130)  |
|24 |                     |4_75 000$ - 99 999$                             |Mean (sd) |27.4 (5.4) |-0.67 (-1.01 to -0.33, p<0.001) |-0.21 (-0.56 to 0.13, p=0.223)  |
|25 |                     |5_100 000$ - 149 999$                           |Mean (sd) |27.1 (5.5) |-0.92 (-1.26 to -0.59, p<0.001) |-0.34 (-0.68 to 0.00, p=0.051)  |
|26 |                     |6_150 000$ - 199 999$                           |Mean (sd) |26.9 (5.6) |-1.12 (-1.50 to -0.74, p<0.001) |-0.35 (-0.74 to 0.03, p=0.069)  |
|27 |                     |7_200 000$ or more                              |Mean (sd) |26.9 (5.2) |-1.12 (-1.53 to -0.71, p<0.001) |-0.28 (-0.70 to 0.14, p=0.188)  |
|32 |WRK_STUDENT          |0                                               |Mean (sd) |27.4 (5.6) |-                               |-                               |
|33 |                     |1                                               |Mean (sd) |26.3 (5.8) |-1.04 (-1.83 to -0.25, p=0.010) |-0.62 (-1.41 to 0.16, p=0.118)  |
|14 |SDC_EDU_LEVEL        |1_Elementary school or less                     |Mean (sd) |28.7 (5.5) |-                               |-                               |
|15 |                     |2_High school                                   |Mean (sd) |28.1 (5.7) |-0.67 (-1.36 to 0.02, p=0.058)  |-0.42 (-1.11 to 0.27, p=0.234)  |
|16 |                     |3_Trade, technical or vocational school         |Mean (sd) |28.1 (5.6) |-0.65 (-1.37 to 0.07, p=0.078)  |-0.32 (-1.04 to 0.39, p=0.374)  |
|17 |                     |4_Diploma from a community college              |Mean (sd) |27.4 (5.7) |-1.35 (-2.04 to -0.66, p<0.001) |-0.91 (-1.59 to -0.22, p=0.010) |
|18 |                     |5_University certificate below bachelor's level |Mean (sd) |27.2 (5.8) |-1.57 (-2.34 to -0.81, p<0.001) |-1.16 (-1.92 to -0.40, p=0.003) |
|19 |                     |6_Bachelor's degree                             |Mean (sd) |27.0 (5.5) |-1.78 (-2.46 to -1.09, p<0.001) |-1.13 (-1.82 to -0.44, p=0.001) |
|20 |                     |7_Graduate degree                               |Mean (sd) |26.7 (5.4) |-2.02 (-2.72 to -1.33, p<0.001) |-1.34 (-2.04 to -0.64, p<0.001) |

Below is the same model output but includes the model descriptive statistics


|**Characteristic**          | **Beta** |  **95% CI**  | **p-value** |
|:---------------------------|:--------:|:------------:|:-----------:|
|SMK_CIG_CUR_FREQ            |          |              |             |
|0_Does not smoke currently  |    —     |      —       |             |
|1_Current occasional smoker |   0.10   | -0.38, 0.59  |     0.7     |
|2_Current daily smoker      |   0.02   | -0.27, 0.32  |     0.9     |
|3_Never smoked              |  -0.51   | -0.67, -0.35 |   <0.001    |
|PA_LEVEL_SHORT              |          |              |             |
|1_Low level of PA           |    —     |      —       |             |
|2_Moderate level of PA      |  -0.54   | -0.73, -0.34 |   <0.001    |
|3_High level of PA          |   -1.2   |  -1.4, -1.0  |   <0.001    |
|ALC_CUR_FREQ                |          |              |             |
|0_Never                     |    —     |      —       |             |
|1_Less than once a month    |  -0.60   | -0.94, -0.26 |   <0.001    |
|2_About once a month        |  -0.80   | -1.2, -0.40  |   <0.001    |
|3_2 to 3 times a month      |  -0.83   | -1.2, -0.48  |   <0.001    |
|4_Once a week               |   -1.5   |  -1.9, -1.2  |   <0.001    |
|5_2 to 3 times a week       |   -1.3   | -1.6, -0.95  |   <0.001    |
|6_4 to 5 times a week       |   -1.3   | -1.6, -0.90  |   <0.001    |
|7_6 to 7 times a week       |   -1.0   | -1.4, -0.63  |   <0.001    |
|FRUIT_VEG                   |  -0.11   | -0.14, -0.08 |   <0.001    |

![](Epi_Communication_Assignment_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

## Social and Demographic Variables


|**Characteristic**                              | **Beta** |  **95% CI**  | **p-value** |
|:-----------------------------------------------|:--------:|:------------:|:-----------:|
|SDC_GENDER                                      |          |              |             |
|Female                                          |    —     |      —       |             |
|Male                                            |   1.3    |   1.1, 1.4   |   <0.001    |
|SDC_AGE_CALC                                    |   0.02   |  0.02, 0.03  |   <0.001    |
|SDC_INCOME                                      |          |              |             |
|1_Less than 24 999$                             |    —     |      —       |             |
|2_25 000$ - 49 999$                             |  -0.45   | -0.81, -0.10 |    0.011    |
|3_50 000$ - 74 999$                             |  -0.54   | -0.88, -0.20 |    0.002    |
|4_75 000$ - 99 999$                             |  -0.58   | -0.92, -0.23 |   <0.001    |
|5_100 000$ - 149 999$                           |  -0.77   | -1.1, -0.43  |   <0.001    |
|6_150 000$ - 199 999$                           |  -0.85   | -1.2, -0.47  |   <0.001    |
|7_200 000$ or more                              |  -0.84   | -1.3, -0.43  |   <0.001    |
|WRK_STUDENT                                     |          |              |             |
|0                                               |    —     |      —       |             |
|1                                               |  -0.56   |  -1.3, 0.23  |     0.2     |
|SDC_EDU_LEVEL                                   |          |              |             |
|1_Elementary school or less                     |    —     |      —       |             |
|2_High school                                   |  -0.22   | -0.91, 0.47  |     0.5     |
|3_Trade, technical or vocational school         |  -0.41   |  -1.1, 0.31  |     0.3     |
|4_Diploma from a community college              |  -0.67   |  -1.4, 0.02  |    0.055    |
|5_University certificate below bachelor's level |   -1.0   | -1.8, -0.27  |    0.008    |
|6_Bachelor's degree                             |   -1.2   | -1.8, -0.46  |    0.001    |
|7_Graduate degree                               |   -1.5   | -2.2, -0.79  |   <0.001    |

![](Epi_Communication_Assignment_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

## Full model 


|**Characteristic**                              | **Beta** |  **95% CI**  | **p-value** |
|:-----------------------------------------------|:--------:|:------------:|:-----------:|
|SDC_GENDER                                      |          |              |             |
|Female                                          |    —     |      —       |             |
|Male                                            |   1.3    |   1.1, 1.5   |   <0.001    |
|SDC_AGE_CALC                                    |   0.03   |  0.02, 0.04  |   <0.001    |
|SDC_INCOME                                      |          |              |             |
|1_Less than 24 999$                             |    —     |      —       |             |
|2_25 000$ - 49 999$                             |  -0.37   | -0.72, -0.02 |    0.037    |
|3_50 000$ - 74 999$                             |  -0.35   | -0.69, -0.01 |    0.045    |
|4_75 000$ - 99 999$                             |  -0.33   | -0.67, 0.02  |    0.061    |
|5_100 000$ - 149 999$                           |  -0.48   | -0.81, -0.14 |    0.006    |
|6_150 000$ - 199 999$                           |  -0.50   | -0.88, -0.12 |    0.011    |
|7_200 000$ or more                              |  -0.44   | -0.85, -0.02 |    0.039    |
|WRK_STUDENT                                     |          |              |             |
|0                                               |    —     |      —       |             |
|1                                               |  -0.45   |  -1.2, 0.32  |     0.3     |
|SDC_EDU_LEVEL                                   |          |              |             |
|1_Elementary school or less                     |    —     |      —       |             |
|2_High school                                   |  -0.17   | -0.86, 0.51  |     0.6     |
|3_Trade, technical or vocational school         |  -0.28   | -0.99, 0.44  |     0.4     |
|4_Diploma from a community college              |  -0.58   |  -1.3, 0.10  |    0.10     |
|5_University certificate below bachelor's level |  -0.91   | -1.7, -0.15  |    0.019    |
|6_Bachelor's degree                             |  -0.92   | -1.6, -0.24  |    0.008    |
|7_Graduate degree                               |   -1.2   | -1.9, -0.52  |   <0.001    |
|SMK_CIG_CUR_FREQ                                |          |              |             |
|0_Does not smoke currently                      |    —     |      —       |             |
|1_Current occasional smoker                     |   0.34   | -0.14, 0.82  |     0.2     |
|2_Current daily smoker                          |   0.11   | -0.18, 0.40  |     0.5     |
|3_Never smoked                                  |  -0.32   | -0.48, -0.15 |   <0.001    |
|PA_LEVEL_SHORT                                  |          |              |             |
|1_Low level of PA                               |    —     |      —       |             |
|2_Moderate level of PA                          |  -0.50   | -0.69, -0.30 |   <0.001    |
|3_High level of PA                              |   -1.2   |  -1.4, -1.0  |   <0.001    |
|ALC_CUR_FREQ                                    |          |              |             |
|0_Never                                         |    —     |      —       |             |
|1_Less than once a month                        |  -0.41   | -0.74, -0.07 |    0.018    |
|2_About once a month                            |  -0.61   | -0.99, -0.22 |    0.002    |
|3_2 to 3 times a month                          |  -0.68   | -1.0, -0.32  |   <0.001    |
|4_Once a week                                   |   -1.4   |  -1.8, -1.1  |   <0.001    |
|5_2 to 3 times a week                           |   -1.3   | -1.6, -0.94  |   <0.001    |
|6_4 to 5 times a week                           |   -1.3   | -1.7, -0.96  |   <0.001    |
|7_6 to 7 times a week                           |   -1.2   | -1.6, -0.83  |   <0.001    |
|FRUIT_VEG                                       |  -0.04   | -0.07, -0.01 |    0.013    |

![](Epi_Communication_Assignment_files/figure-html/unnamed-chunk-19-1.png)<!-- -->
