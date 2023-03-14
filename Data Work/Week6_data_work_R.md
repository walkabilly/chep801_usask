---
title: "Week6_data_work_r"
output:
      html_document:
        keep_md: true
---

### Simulating counterfactual outcomes with 1 confounder variable   

We only need two libraries today 




We will generate variables whose name follows the lecture material, specifically:    
  
  *A*: Binary exposure    
  *L*: Binary confounder   
  *Y*: Binary outcome (observed outcome)    

  
Note that the confounder variable is first generated, from which the exposure and the outcome are generated. Thus, the variable L is a common cause, rather than common effect (collider).  

#### Be sure to check to see if the positivity assumption is met in your data. 


```r
# Set see to get same results within the same computer 
set.seed(1)

# Set the number of people, this is sample size in your data
N = 500


# Create a binary confounder variable 
L=rbinom(N,1, 0.5)
table(L)
```

```
## L
##   0   1 
## 270 230
```

```r
# Then binary exposure, partially based on the status of confounder 
A=runif(N, max=(1+L))
A <- ifelse(A > 0.4, 0, 1)
table(A)
```

```
## A
##   0   1 
## 344 156
```

```r
# QUickly check the association of A and L
epitools::epitab(A, L, method = "oddsratio")$tab
```

```
##          Outcome
## Predictor   0        p0   1  p1 oddsratio     lower     upper      p.value
##         0 160 0.5925926 184 0.8 1.0000000        NA        NA           NA
##         1 110 0.4074074  46 0.2 0.3636364 0.2427488 0.5447254 6.665396e-07
```

```r
table(A, L)
```

```
##    L
## A     0   1
##   0 160 184
##   1 110  46
```


If there is no zero-cell across A and L, proceed to the next step, creating *Y*. 

```r
# Create a third variable (fake confounder) from the outcome and exposure  
theta = -1 + 0.3*A + -0.4*L  # Generate logit of outcome
prob <- 1/(1+exp(-theta))  # convert logit values into probabilities
Y= rbinom(N,1,prob) # Generate the binary values from the probabilities of the outcome

head(Y, 40) # display values 
```

```
##  [1] 0 0 0 1 0 0 0 0 1 0 1 0 0 1 0 1 1 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 1 0 0 0 0
## [39] 1 0
```


We need to create a data frame with the three variables before running the model 

```r
myData <- data.frame(Y, A, L)
table(myData$Y)
```

```
## 
##   0   1 
## 370 130
```

```r
table(myData$A)
```

```
## 
##   0   1 
## 344 156
```

```r
table(myData$L)
```

```
## 
##   0   1 
## 270 230
```


As usual, check the association between Y and L, A and L.  

```r
epitools::epitab(myData$A, myData$Y, method = "oddsratio")$tab
```

```
##          Outcome
## Predictor   0        p0  1        p1 oddsratio    lower    upper    p.value
##         0 265 0.7162162 79 0.6076923  1.000000       NA       NA         NA
##         1 105 0.2837838 51 0.3923077  1.629295 1.072274 2.475676 0.02749075
```

```r
epitools::epitab(myData$L, myData$Y, method = "oddsratio")$tab
```

```
##          Outcome
## Predictor   0        p0  1        p1 oddsratio     lower    upper      p.value
##         0 183 0.4945946 87 0.6692308 1.0000000        NA       NA           NA
##         1 187 0.5054054 43 0.3307692 0.4836806 0.3183224 0.734937 0.0007061134
```


Check the disttribution of L, A, Y and calculate inverse weights if you like 

```r
myData %>%  group_by(L, A, Y) %>% summarise(count = n()) 
```

```
## `summarise()` has grouped output by 'L', 'A'. You can override using the
## `.groups` argument.
```

```
## # A tibble: 8 × 4
## # Groups:   L, A [4]
##       L     A     Y count
##   <int> <dbl> <int> <int>
## 1     0     0     0   112
## 2     0     0     1    48
## 3     0     1     0    71
## 4     0     1     1    39
## 5     1     0     0   153
## 6     1     0     1    31
## 7     1     1     0    34
## 8     1     1     1    12
```



##### Run the regression to capture the association between Y and A, and Y and L

```r
regressResult <- glm(data=myData, Y~L + A,  family="binomial")


# Show the results - logit scale 
coefficients(regressResult) %>%  round(2)
```

```
## (Intercept)           L           A 
##       -0.89       -0.66        0.34
```

```r
regressResult %>%  confint() %>% round(2)
```

```
## Waiting for profiling to be done...
```

```
##             2.5 % 97.5 %
## (Intercept) -1.21  -0.58
## L           -1.09  -0.23
## A           -0.09   0.77
```

```r
# Show the results - odds ratio scale
coefficients(regressResult) %>%  exp %>% round(2)
```

```
## (Intercept)           L           A 
##        0.41        0.52        1.41
```

```r
regressResult %>%  confint()  %>% exp %>%  round(2)
```

```
## Waiting for profiling to be done...
```

```
##             2.5 % 97.5 %
## (Intercept)  0.30   0.56
## L            0.34   0.79
## A            0.91   2.16
```


We now set A=1 and A=0 to everyone in the data

```r
myData_allExposed <- myData %>% mutate(A=1) 
table(myData_allExposed$A)
```

```
## 
##   1 
## 500
```

```r
myData_NotExposed <- myData %>% mutate(A=0) 
table(myData_NotExposed$A)
```

```
## 
##   0 
## 500
```

Generate marginal outcome and plot the distribution. Do you know why the histogram is so bimodal? 

```r
pred_Ya_1 <- predict(regressResult, newdata =myData_allExposed, type = "response")
hist(pred_Ya_1)
```

![](Week6_data_work_R_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

```r
pred_Ya_0 <- predict(regressResult, newdata =myData_NotExposed, type = "response")
hist(pred_Ya_0)
```

![](Week6_data_work_R_files/figure-html/unnamed-chunk-9-2.png)<!-- -->

Lets calculate marginal outcome, had everyone exposed and not exposed 
##### Be sure to know which measure corresponds to ATE, OR, and RR, and why the values differ. ALso check to see your analyssi correctly recovered the odds ratio you set during the data generation process. Report these values to combine with colleague's results. 

```r
mean(pred_Ya_1) / mean(pred_Ya_0) # no CI for this 
```

```
## [1] 1.277803
```

```r
{mean(pred_Ya_1) / (1-mean(pred_Ya_1))} / {mean(pred_Ya_0)/(1-mean(pred_Ya_0))}
```

```
## [1] 1.399434
```

```r
mean(pred_Ya_1) - mean(pred_Ya_0)
```

```
## [1] 0.06620223
```
