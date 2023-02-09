### HM, Feb 9, 2023
# Optional codes, demonsration only 
# Function to perform the simulation in data lab 6 


library(tidyverse)
library(ggplot2)

# Set the number of people, this is sample size in your data
N = 500


# Function to repeat the simulation experiement 
funcGetSim <- function(N){
  # Create a binary confounder variable 
  L=rbinom(N,1, 0.5)
  
  # Then binary exposure, partially based on the status of confounder 
  A=runif(N, max=(1+L))
  A <- ifelse(A > 0.4, 0, 1)
  
  # Create a third variable (fake confounder) from the outcome and exposure  
  theta = -1 + 0.3*A + -0.4*L  # Generate logit of outcome
  prob <- 1/(1+exp(-theta))  # convert logit values into probabilities
  Y= rbinom(N,1,prob) # Generate the binary values from the probabilities of the outcome
  
  myData <- data.frame(Y, A, L)

  regressResult <- glm(data=myData, Y~L + A,  family="binomial")
  
  myData_allExposed <- myData %>% mutate(A=1)
  myData_NotExposed <- myData %>% mutate(A=0) 
  
  pred_Ya_1 <- predict(regressResult, newdata =myData_allExposed, type = "response")
  pred_Ya_0 <- predict(regressResult, newdata =myData_NotExposed, type = "response")
  
  RR <- mean(pred_Ya_1) / mean(pred_Ya_0) # no CI for this 
  OR <- {mean(pred_Ya_1) / (1-mean(pred_Ya_1))} / {mean(pred_Ya_0)/(1-mean(pred_Ya_0))}
  RD <- mean(pred_Ya_1) - mean(pred_Ya_0)
  return(c(RR, OR, RD))
}




# Perform simulation and compile results 
d <- replicate(100, funcGetSim(500))
rownames(d) <- c("RR", "OR", "RD")
d <- data.frame(t(d))
d$simulationID <- 1:nrow(d)

# Plot the distribution with title  
hist(d$RD, main = "RD")
hist(d$OR, main = "OR")
hist(d$RR, main = "RR")

# Mean 
mean(d$OR)
exp(0.3)

