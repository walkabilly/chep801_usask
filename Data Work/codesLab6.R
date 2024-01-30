knitr::purl(input = "Week6_data_work_R.Rmd", output = "codesLab6.R",documentation = 0)

library(tidyverse)
library(ggplot2)

# Set see to get same results within the same computer 
set.seed(1)

# Set the number of people, this is sample size in your data
N = 500


# Create a binary confounder variable 
L=rbinom(N,1, 0.5)
table(L)


# Then binary exposure, partially based on the status of confounder 
A=runif(N, max=(1+L))
A <- ifelse(A > 0.4, 0, 1)
table(A)


# QUickly check the association of A and L
epitools::epitab(A, L, method = "oddsratio")$tab
table(A, L)

# Create a third variable (fake confounder) from the outcome and exposure  
theta = -1 + 0.3*A + -0.4*L  # Generate logit of outcome
prob <- 1/(1+exp(-theta))  # convert logit values into probabilities
Y= rbinom(N,1,prob) # Generate the binary values from the probabilities of the outcome

head(Y, 40) # display values 

myData <- data.frame(Y, A, L)
table(myData$Y)
table(myData$A)
table(myData$L)

epitools::epitab(myData$A, myData$Y, method = "oddsratio")$tab
epitools::epitab(myData$L, myData$Y, method = "oddsratio")$tab

myData %>%  group_by(L, A, Y) %>% summarise(count = n()) 

regressResult <- glm(data=myData, Y~L + A,  family="binomial")


# Show the results - logit scale 
coefficients(regressResult) %>%  round(2)
regressResult %>%  confint() %>% round(2)

# Show the results - odds ratio scale
coefficients(regressResult) %>%  exp %>% round(2)
regressResult %>%  confint()  %>% exp %>%  round(2)

myData_allExposed <- myData %>% mutate(A=1) 
table(myData_allExposed$A)

myData_NotExposed <- myData %>% mutate(A=0) 
table(myData_NotExposed$A)

pred_Ya_1 <- predict(regressResult, newdata =myData_allExposed, type = "response")
hist(pred_Ya_1)
pred_Ya_0 <- predict(regressResult, newdata =myData_NotExposed, type = "response")
hist(pred_Ya_0)

mean(pred_Ya_1) / mean(pred_Ya_0) # no CI for this 
{mean(pred_Ya_1) / (1-mean(pred_Ya_1))} / {mean(pred_Ya_0)/(1-mean(pred_Ya_0))}
mean(pred_Ya_1) - mean(pred_Ya_0)
