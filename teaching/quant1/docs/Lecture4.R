# -------------------------------------------------------------------
# Lecture 4: T-distribution, simple linear regression, introduction to multiple regression 

# Required libraries: car
  rm(list=ls())
  # source("http://thiloklein.de/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------




# --- Critical values for t and Normal distribution as n -> Inf, (p.8) ---
 # 97.5% quantile of t-distribution with 10, 20, 30, 60, and 300 degrees of freedom
 sapply(c(10,20,30,60,300), function(x) qt(p=0.975, df=x))
 # 97.5% quantile of Normal distribution
 qnorm(p=0.975)




# --- California test scores, Stock and Watson (2007, p.152), (Slides p.21) ---
 install.packages("AER")
 help("StockWatson2007", package = "AER")

## data and transformations
 data("CASchools", package = "AER")
 str(CASchools)
 CASchools$stratio <- with(CASchools, students/teachers)
 CASchools$score <- with(CASchools, (math + read)/2)

## scatterplot
 library(car)
 plot(score ~ stratio, data=CASchools, xlim=c(0,max(CASchools$stratio)))

## linear model
 lm1 <- lm(score ~ stratio, data = CASchools)
 summary(lm1)
 abline(lm1, col="green")
 # what is the size of the effect in terms of quantiles?
 quantile(CASchools$stratio, probs=seq(0,1,.1))
 quantile(CASchools$score, probs=seq(0,1,.1))

## Standard Error of the Regression or: Residual standard error, (p.22)
 sqrt(1/(420-2) * sum(lm1$resid^2))
 str(lm1)

## Without the model, the best estimate of Y_i is the sample mean, (p.23)
  mean(CASchools$score)
  lm(score ~ 1, data=CASchools)

## Coefficient of determination or: R^2, (p.24)
 RSS <- sum(lm1$resid^2)
 ESS <- sum( (lm1$fitted - mean(lm1$fitted))^2 ) 
 TSS <- RSS + ESS
 ESS/TSS 

## Assumption 1: E(u|X=x)=0, (p.29)
 scatterplot(lm1$resid ~ CASchools$stratio)

## Include a constant in the regression, (p.31)
 e = 2 + rnorm(1000)
 x = runif(1000,0,100)
 y = 0 + x + e
 lm(y ~ x)

## histrograms and qq-plots, (pp.40)
 par(mfrow=c(1,2))
 hist(lm1$resid, 20, freq=FALSE)
 lines(dnorm(seq(-50,50,.1),sd=18.58) ~ seq(-50,50,.1), col="blue")
 qqnorm(lm1$resid)
 qqline(lm1$resid)

## compare with histograms and qq-plots for a t-distribution (fait tailed!)
 set.seed(12)
 x = rt(150,10)
 hist(x, 20, freq=FALSE, main="Histrogram of t-distribution with 10 d.f.")
 lines(dnorm(seq(-6,6,.1),sd=sd(x)) ~ seq(-6,6,.1), col="blue")
 qqnorm(x)
 qqline(x)




# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

