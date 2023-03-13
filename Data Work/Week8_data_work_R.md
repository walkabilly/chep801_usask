---
title: "Week 8 Data Work"
output:
      html_document:
        keep_md: true
---



## Interaction/Effect Measure Modification

We will show different methods to estimate interaction in regression models in different scenarios depending on types of variables. We will present both regression based and visual methods to examine interaction. Interaction is complex and we will use new data instead of the usual data for this course in order to simplify the interpretation. 

### Interaction in linear regression with a contiunous exposure of interest (A) and a categorical effect modifier (Z)


```r
data <- read_csv("interaction_data1.csv")
```

```
## Rows: 230 Columns: 4
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (2): gender, screen_time
## dbl (2): mental_health_score, id
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

We have 3 variables in these data. 

1. Mental Health Score. A survey measure ranging from 10 to 25 with higher scores representing better mental health on average
2. Screen Time. A self-report measure of screen time that has been categorized into 8 hours or more. 
3. Gender. A three category gender variable. 

We suspect that gender is an effect modifier of the association between screen time and mental health score. We want to examine this. 

#### Visual inspection

1. Visualize the boxplot between screen time and mental health


```r
boxplot_screen <- ggplot(data, aes(x = screen_time, y = mental_health_score, colour = screen_time)) + 
                  geom_boxplot() + 
                  labs(x = "Screen Time", y = "Mental Health", colour = "Screen Time") 
plot(boxplot_screen)
```

![](Week8_data_work_R_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

We can see that there is probably a strong association between screen time and mental health. 

2. Visualize the boxplot between screen time and mental health stratified by gender


```r
boxplot_screen_gender <- ggplot(data, aes(x = screen_time, y = mental_health_score, colour = screen_time)) + 
                  geom_boxplot() + 
                  labs(x = "Screen Time", y = "Mental Health", colour = "Screen Time") +
                  facet_wrap(~ gender)
plot(boxplot_screen_gender)
```

![](Week8_data_work_R_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

We can also see here differences between mental and screen time by gender. It looks like men in general have greater mental health and women and non-binary people but the effect of screen time is still there for each group. 

3. Run the regression

Here we will run the regression including all three variables of interest `and` the interaction term between screen_time and gender. This is multiplicative interaction. There are a few ways to do this in R that will give you the same result. We also include both the main effect and interaction term in the models. 


```r
regression_m1 <- lm(mental_health_score ~ screen_time + gender + screen_time*gender, data=data) ## Method 1
summary(regression_m1)
```

```
## 
## Call:
## lm(formula = mental_health_score ~ screen_time + gender + screen_time * 
##     gender, data = data)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -6.1915 -1.1042 -0.1042  0.8958 12.9310 
## 
## Coefficients:
##                                      Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                           18.3478     0.4573  40.121  < 2e-16 ***
## screen_time>8 hours                    3.7211     0.5404   6.885 5.73e-11 ***
## genderNon Binary                      -6.2437     0.5562 -11.226  < 2e-16 ***
## genderWoman                           -3.5666     0.5995  -5.949 1.03e-08 ***
## screen_time>8 hours:genderNon Binary  -2.2344     0.7816  -2.859  0.00466 ** 
## screen_time>8 hours:genderWoman       -1.3109     0.7381  -1.776  0.07707 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.193 on 224 degrees of freedom
## Multiple R-squared:  0.7413,	Adjusted R-squared:  0.7356 
## F-statistic: 128.4 on 5 and 224 DF,  p-value: < 2.2e-16
```

```r
regression_m2 <- lm(mental_health_score ~ screen_time*gender, data=data) ## Method 2
summary(regression_m2)
```

```
## 
## Call:
## lm(formula = mental_health_score ~ screen_time * gender, data = data)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -6.1915 -1.1042 -0.1042  0.8958 12.9310 
## 
## Coefficients:
##                                      Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                           18.3478     0.4573  40.121  < 2e-16 ***
## screen_time>8 hours                    3.7211     0.5404   6.885 5.73e-11 ***
## genderNon Binary                      -6.2437     0.5562 -11.226  < 2e-16 ***
## genderWoman                           -3.5666     0.5995  -5.949 1.03e-08 ***
## screen_time>8 hours:genderNon Binary  -2.2344     0.7816  -2.859  0.00466 ** 
## screen_time>8 hours:genderWoman       -1.3109     0.7381  -1.776  0.07707 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.193 on 224 degrees of freedom
## Multiple R-squared:  0.7413,	Adjusted R-squared:  0.7356 
## F-statistic: 128.4 on 5 and 224 DF,  p-value: < 2.2e-16
```

Nicer output


```r
interaction_model <- tbl_regression(regression_m2) 

interaction_model %>% as_kable()
```



|**Characteristic**    | **Beta** | **95% CI**  | **p-value** |
|:---------------------|:--------:|:-----------:|:-----------:|
|screen_time           |          |             |             |
|<=8 hours             |    —     |      —      |             |
|>8 hours              |   3.7    |  2.7, 4.8   |   <0.001    |
|gender                |          |             |             |
|Man                   |    —     |      —      |             |
|Non Binary            |   -6.2   | -7.3, -5.1  |   <0.001    |
|Woman                 |   -3.6   | -4.7, -2.4  |   <0.001    |
|screen_time * gender  |          |             |             |
|>8 hours * Non Binary |   -2.2   | -3.8, -0.69 |    0.005    |
|>8 hours * Woman      |   -1.3   | -2.8, 0.14  |    0.077    |

We can see the interaction here 

