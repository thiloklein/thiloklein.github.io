# -------------------------------------------------------------------
# Lecture 4: Tests of regression assumptions, continued: Outliers and Influential observations

# Required libraries: sfsmisc, car, stats
  rm(list=ls())
  source("http://thiloklein.de/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------




## --- Confidence intervals, prediction intervals, Outliers, Influential observations ---

 data = read.csv("http://thiloklein.de/R/wineandwealth.csv")
 str(data)
 attach(data)
 data

# Summary stats
 summary(data[seq(1,7,2)])   # Income data
 summary(data[seq(2,8,2)])   # Sales data

# Simple linear regressions for each product 
 lmA <- lm(SalesA ~ IncomeA); summary(lmA)
 lmB <- lm(SalesB ~ IncomeB); summary(lmB)
 lmC <- lm(SalesC ~ IncomeC); summary(lmC)
 lmD <- lm(SalesD ~ IncomeD); summary(lmD)


# --- Confidence and prediction bands for predicted sales of Almaden, (pp.7) ---

 # install.packages("sfsmisc")
 library(sfsmisc)
 library(car) 
 plot(SalesA ~ IncomeA, main="Confidence/prediction bands/intervals for predicted sales of Almaden", xlim=c(0,15), ylim=c(0,14))
 abline(lmA)

# fitted value for income level 15K
 abline(v=15, h=sum(lmA$coef*c(1,15)), lty=2)

# confidence bands
 linesHyperb.lm(lmA, c.prob=0.95, confidence=TRUE, do.abline=TRUE, col="blue")

# prediction bands
 linesHyperb.lm(lmA, c.prob=0.95, confidence=FALSE, k=1)
 legend("topleft", c("confidence band","prediction band"), col = c("blue","red"), lty=c(2,2))

# confidence/prediction intervals
 abline(h=c(8.692466, 12.31044), col="blue")  # confidence interval
 abline(h=c(7.170113, 13.8328), col="red")   # prediction interval
 legend("topleft", c("confidence band","prediction band","confidence interval at 15K income","prediction interval at 15K income"), col = c("blue","red","blue","red"), lty=c(2,2,1,1), bg="white")


# --- SE of the fitted value for Xi = 15, (p.8) ---
 n = length(IncomeA)   # number of obs
 RSE = sqrt(sum(lmA$resid^2 / (n-2)))   # = 1.237 Residual Standard Error from regression summary()
 Xi = 15
 Xbar = mean(IncomeA)
 varX = var(IncomeA)
 s.e.fitted = sqrt(  RSE^2 * (1/n + ((Xi - Xbar)^2) / ((n-1)*varX))  ); s.e.fitted   # formula, slide 8.


# --- conf interval at IncomeA = 15, (p.9) ---
 x = data.frame(IncomeA = 15)
 conf_a = predict(lmA, x, se.fit=T, level=.95, interval="confidence")
 conf_a


# --- prediction interval at IncomeA = 15, (p.10) ---
 x = data.frame(IncomeA = 15)
 pred_a = predict(lmA, x, se.fit=T, level=.95, interval="prediction")
 pred_a




# --- Digression: confidence/prediction intervals, the hard way, (pp.9) ---
# install.packages("stats")
 library(stats)
 vcov(lmA)   # variance-covariance matrix

# s.e. of fitted value at income = 15
 s.e.fitted # from above
 
# s.e. of prediction
 s.e.predicted = sqrt(  RSE^2 * (1 + 1/n + ((Xi - Xbar)^2) / ((n-1)*varX))  ); s.e.predicted   # formula, slide 10.
 
# Note: only difference between conf and pred is that we add RSE^2, i.e., "RSE^2 * (1 +"
# 97.5%-quantile of t-distribution with 9 (=11-2) degrees of freedom
 quantile.t = qt(p=.025, df=9, lower.tail = FALSE); quantile.t

# confidence interval
 round(sum(lmA$coef*c(1,15)) + c(-1,+1)*quantile.t*s.e.fitted, digits = 2)   # formula, slide 7.

# prediction interval
 round(sum(lmA$coef*c(1,15)) + c(-1,+1)*quantile.t*s.e.predicted, digits = 2)   # formula, slide 7.





# --- Leverage, the DELACROIX data, (pp.13) ---

# --- Influential observation, (p.14) ---

 plot(SalesD ~ IncomeD, ylim=c(min(SalesD), max(SalesD)+1))
 abline(lm(SalesD ~ IncomeD), col="red")
 at = which(SalesD == max(SalesD)); at
 text(x=IncomeD[at], y=SalesD[at], "Influential obs", pos=2)

# --- Leverage, (p.15) ---

 hD = hat(model.matrix(lmD))
 plot(hD)
# Criterion: Is leverage > 2K/n ?
# where K/n is the average leverage (Note: sum of leverages add up to the number of parameters, K)
 abline(h=2*2/11)
 sort(hD)    # sum(hD) = 2 = number of parameters (intercept + slope coef)




# --- Outliers, the CASAROSA data, (pp.17) ---

 plot(SalesC ~ IncomeC, ylim=c(min(SalesC), max(SalesC)+1))
 abline(lm(SalesC ~ IncomeC), col="red")
 at <- which(SalesC == max(SalesC)); at
 points(SalesC[at] ~ IncomeC[at], col="red")
 text(x = IncomeC[at], y = SalesC[at], "Outlier", pos=2, col="red")
 abline(lm(SalesC[-at] ~ IncomeC[-at]), col="blue")
 legend("topleft", legend=c("with","~out"), fill=c("red","blue"))

# --- Studentized residuals, (p.20) ---

 sort(rstudent(lmC), decreasing=TRUE)
 qt(.025, df=9, lower.tail=FALSE)   # compare to critical t-quantile
 
 


# --- Cook's Distance: combining outlierness and leverage, (pp.22) ---

 cookD <- cooks.distance(lmD)
 plot(cookD)
 round(cookD, 2)
 # Note: obs 8 in D is NaN (Not a Number). 
 # Result of improper mathematical expression 0/0.




# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

