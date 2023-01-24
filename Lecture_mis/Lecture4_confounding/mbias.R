
library(tidyverse)
library(ggplot2)
library(arm) # to plot coefficients

myFunc <- function(){
  
  # Create a binary outcome variable 
  outcome<-rbinom(n=2000,size=1,prob=0.7)
  head(outcome, 40)
  mean(outcome)
  
  # Create a binary exposure variable 
  Exposure<-rbinom(n=2000,size=1,prob=0.3)
  head(Exposure, 40)
  mean(Exposure)
  
  # Create a fake confounded variable from the outcome and exposure  
  theta = 0 + 1.5*Exposure + 2*outcome 
  prob <- 1/(1+exp(-theta))  
  conf= rbinom(2000,1,prob)
  head(Exposure, 40)
  mean(Exposure)
  
 
  
  # Descriptive associations
  epitools::epitab(Exposure, outcome, method = "oddsratio")$tab[, c(1,3,5,6,7,8)]
  epitools::epitab(Exposure, conf, method = "oddsratio")$tab[, c(1,3,5,6,7,8)]
  epitools::epitab(outcome, conf, method = "oddsratio")$tab[, c(1,3,5,6,7,8)]


  # Make a data table from these 3 variables 
  myData <- data.frame(Exposure, outcome, conf)
  onlyZero <- myData %>%  filter(conf== 0) 
  onlyOne <- myData %>%  filter(conf== 1) 
  
  tabZeroStrata <- epitools::epitab(onlyZero$Exposure, onlyZero$outcome, method = "oddsratio")
  tabOneStrata <- epitools::epitab(onlyOne$Exposure, onlyOne$outcome, method = "oddsratio")
  
  c(
  mean <- tabOneStrata$tab[2,5],
  lo <- tabOneStrata$tab[2,6],
  hi <- tabOneStrata$tab[2,7]
  )
}

d <- replicate(20, myFunc())
d <- data.frame(t(d))
names(d) <- c("Point", "Lower", "Upper")
d$simulationID <- 1:nrow(d)

ggplot(d, aes(x=simulationID, y=Point, ymin=Lower, ymax=Upper))+
    geom_pointrange()+
    geom_hline(yintercept = 1, linetype=2)+
    coord_flip()+
    xlab('Simulation ID') + 
    ylab("Odds Ratio, Exposure and Outcome") + 
    theme_classic()

regress_eo <- glm(outcome~Exposure,data=myData,family="binomial")
coefplot(regress_eo, main = "Not adjusted for C")

regress_eoc <- glm(outcome~Exposure + conf,data=myData,family="binomial")
coefplot(regress_eoc, main = "Adjusted for C")



https://stats.stackexchange.com/questions/46523/how-to-simulate-artificial-data-for-logistic-regression?rq=1
