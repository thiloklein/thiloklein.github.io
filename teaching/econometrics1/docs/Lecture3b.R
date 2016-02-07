# -------------------------------------------------------------------
# Lecture 3: Specification errors and consequences
 
# Required libraries: lmtest
  rm(list=ls())
  source("http://thiloklein.de/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------




# --- Heteroskedasticity / Breusch Pagan test and White test ---


# Generate data
 set.seed(107)
 u = rnorm(30)*.5
 x = runif(30)
 # true model: log(y) = 0 + 1*x + u
 y = exp( x + u )


# Regression and diagnostic scatter plots
 lmLi = lm(y ~ x)
 shccm(lmLi)

 par(mfrow=c(1,2))
 plot(y ~ x, main="Scatter of y against x"); abline(lmLi, col="red", lwd=2)
   legend("topleft", "regression line", lwd = 2, col = "red")
 plot(lmLi$resid ~ x, main="Residuals against x", ylim=c(-3.5,3.5)); abline(h=0, col="red", lwd=2)
   legend("topleft", "mean of residuals (=0)", lwd = 2, col = "red")


# Diagnostic regression of squared residuals on regressors
 lm.dia = lm(lmLi$resid^2 ~ x); shccm(lm.dia)
 plot(lmLi$resid^2 ~ x, main="Squared residuals against x")
   abline(lm.dia, col="blue", lwd=2)
   legend("topleft", "diagnostic regression \n of e^2 on x", lwd = 2, col = "blue")
 plot(lmLi$resid^2 ~ lmLi$fitted, main="Squared residuals against fitted values")
   abline(lm(lmLi$resid^2 ~ lmLi$fitted), col="blue", lwd=2)
   legend("topleft", "diagnostic regression \n of e^2 on y.hat", lwd = 2, col = "blue")

 
# Formal test: Koenker / Breusch-Pagan LM test (recommended)

 # 1. regress u^2 on a constant and x in an auxiliary regression.
 lm.aux = lm(lmLi$resid^2 ~ x)

 # 2. obtain regression R-squared and multiply it with the number of observations
 R.sqr = summary(lm.aux)$r.squared
 n = length(x)
 T = R.sqr * n

 # 3. compare the Lagrange Multiplier (LM) test statistic to the Chi-Sqr distribution with 
 #    degrees of freedom equal to the number of regressors in the auxiliary regression
 pchisq(q=T, df=1, lower.tail=F)

 # 4. reject null hypothesis of homoskedasticity if p-value smaller than pre-specified size of test

 # 5. the above procedure is canned in R's bptest function
 # install.packages("lmtest")
 library(lmtest)
 bptest(lmLi)
 

# Alternatives to the above test are:

 # A) Breusch-Pagan test (depreciated because it depends on normality assumption!)
 bptest(lmLi, studentize=F)   

 # B) White test (also detects non-linear conditional variances but only appropriate 
 #    in large samples and few regressors!)
 bptest(lmLi, ~ x + I(x^2))   


# ALWAYS CHECK BEFORE Heteroskedasticity testing: functional form misspecification?

 # The data was actually generated using homoskedastic disturbances (see true model above)
 # So let us see what happens when we follow the true log-linear model specification
 lmLoLi = lm(log(y) ~ x); shccm(lmLoLi)

 # Run the same visual heteroskedasticity diagnostics as above for the misspecified (linear model) 
 # and the correct log-linear specification:
 par(mfrow=c(2,2))
 plot(y ~ x, main="Scatter of y against x")
   abline(lmLi, col="red", lwd=2)
   legend("topleft", "linear regression of y on x \n TRUE MODEL: log-linear", lwd = 2, col = "red")
 plot(log(y) ~ x, main="Scatter of log(y) against x")
   abline(lmLoLi, col="red", lwd=2)
   legend("topleft", "log-linear regression of log(y) on x \n TRUE MODEL: log-linear", lwd = 2, col = "red")
 plot(lmLi$resid^2 ~ x, main="Linear model")
   abline(lm(lmLi$resid^2 ~ x), col="blue", lwd=2) 
   legend("topleft", "regression of e^2 on x \n TRUE MODEL: log-linear", lwd = 2, col = "blue")
 plot(lmLoLi$resid^2 ~ x, ylim=c(0,max(lmLi$resid^2)), main="Log-linear model")
   abline(lm(lmLoLi$resid^2 ~ x), col="blue", lwd=2)
   legend("topleft", "regression of e^2 on x \n TRUE MODEL: log-linear", lwd = 2, col = "blue")




# --- Linearity / RESET test ---


# NOTE: Linearity tests, such as the RESET test, only test for a very specific 
# type of misspecification: imposing a linear model on non-linear data. 
# To see this, let us first simulate two models, y = 20 + x1 + x2 and z = 20 + x1 + x1^2 as follows.


# Generate some random variates terms
 set.seed(123)
 epsilon <- rnorm(1000)
 omega <- rnorm(1000)
 eta <- rnorm(1000)

# Generate independent variables
 x1 <- 5 + omega + 0.3* eta
 x2 <- 10 + omega

# Generate dependent variables
 y <- 20 + x1 + x2 + epsilon
 z <- 20 + x1 + x1^2 + epsilon


# Let us now regress misspecified versions of these true models and see whether RESET test complains.


# --- General model misspecification: Omitted Variable Bias for b1 ---

# Omitting x2: misspecified model lm1
 lm1 <- lm(y ~ x1); lm1$coef
 
 # Diagnostic plots
 par(mfrow=c(2,2))
 plot(y ~ x1, main="General misspecification")
  abline(lm1, col="red", lwd=2)
  legend("topleft", c("True model: y = b0 + b1*x1 + b2*x2","Estimated: y = b0 + b1*x1"), lwd=2, col=c("white","red"))
 plot(lm1$resid ~ x1, main = "Residual plot")
  abline(h=0, col="red", lwd=2)
  
# true model:
 lm(y ~ x1 + x2)$coef
 
# misspecification NOT indicated by RESET test!
 library(lmtest)
 resettest(lm1)


# --- Misspecification of functional form ---

# Omitting quadratic term of x1: misspecified model lm2
 lm2 <- lm(z ~ x1); lm2$coef
 
 # Diagnostic plots
 plot(z~x1, main="Misspecification of functional form")
  abline(lm2,col="red", lwd=2)
  legend("topleft", c("True model: z = b0 + b1*x1 + b2*x1^2","Estimated: z = b0 + b1*x1"), lwd=2, col=c("white","red"))
 plot(lm2$resid~x1, main="Residual plot")
  abline(h=0,col="red", lwd=2)
  
# true model
 lm(z ~ x1 + I(x1^2))$coef
 
# misspecification indicated by RESET test
 resettest(lm2)




# --- Normality / Jarque Bera test ---


# Let us apply the Jarque Bera test for the null of Normal disturbance terms of the heteroskedasticity example
 # install.packages("tseries")
 library(tseries) 
 
 # Diagnostic plots
 par(mfrow=c(1,2))
 hist(lmLi$resid, freq=FALSE) # normality assumption not justified in this case!
 lines(dnorm(seq(-2,4,.1),sd=sd(lmLi$resid)) ~ seq(-2,4,.1), col="blue")
 qqnorm(lmLi$resid); qqline(lmLi$resid) 
 
 # Linear model: Normality is clearly rejected at 1% significance level
 jarque.bera.test(lmLi$res) 
 
 # Log-linear model: cannot reject the null :)
 jarque.bera.test(lmLoLi$res)




# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------


