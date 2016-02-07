# -------------------------------------------------------------------
# Lecture 5: Gauss-Markov Theorem, Precision of OLS estimators, Multiple regression models, Multicollinearity, F-tests for goodness of fit

# Required libraries: AER, car
  rm(list=ls())
  source("http://thiloklein.de/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------




## --- The larger V(X), the lower is V(beta), (p.6) ---
 # install.packages("AER")
 library(AER)
 data("CASchools")
 CASchools$stratio <- with(CASchools, students/teachers)
 CASchools$score <- with(CASchools, (math + read)/2)
 attach(CASchools)

 est1 <- lm(score ~ stratio)
 summary(est1)

# use only those observations where stratio deviates LITTLE from the mean value.

 lowVar <- stratio > quantile(stratio, 0.25) & stratio < quantile(stratio, 0.75)
 est2 <- lm(score ~ stratio, subset = lowVar)
 summary(est2)

# and compare with those where stratio deviates MUCH from the mean value.

 est3 <- lm(score ~ stratio, subset = lowVar==FALSE)
 summary(est3)

# We observe that standard errors and p-values are larger in the second case.
# The next diagram clarifies the problem:

 plot(score ~ stratio)
 points(score ~ stratio, col = "red", subset = lowVar)
 abline(est1); abline(est2, col="red"); abline(est3, col = "blue")
 legend("topright",legend=c("Pooled","lowVar","highVar"),lty=1,col=c("black","red","blue"))




# --- Heteroskedasticity Consistent Covariance Matrix (HCCM), (pp.5-8) ---
 set.seed(123) # this way we will all have the same draws from the RV
 x <- runif(1000)
 e <- rnorm(1000)
 par(mfrow=c(1,2))

 y.hom <- x + e	# homoscedasticity
 lm.hom <- lm(y.hom ~ x)
 plot(y.hom ~ x, ylim=c(-2,3)); abline(lm.hom, col="red", lwd=2)

 y.het <- x + e*x^2	# heteroscedasticity
 lm.het <- lm(y.het ~ x)
 plot(y.het ~ x, ylim=c(-2,3)); abline(lm.het, col="red", lwd=2)

 vcov(lm.het)
 # ??hccm
 library(car)
 hccm(lm.het, type="hc0")	# hc0 means White-adjusted errors (R's default setting)

# --- [load shccm function!] SHCCM = Summary with Heteroskedasticity Consistent Covariance Matrix ---
 source("http://thiloklein.de/R/myfunctions.R")

 summary(lm.hom)		# similar results under homoscedasticity
 shccm(lm.hom) 

 summary(lm.het)		# different results under heteroscedasticity
 shccm(lm.het) 




# --- Zero conditional mean assumption, (p.11) ---
 scatterplot(est1$resid ~ english)




# --- Digression: Linear regression in matrix notation, (p.19) ---
 X = cbind(Intercept=rep(1,420), stratio)
 head(X)
 Y = score
 # beta.hat = (X'X)^{-1} X'Y
 beta.hat = solve(t(X)%*%X) %*% t(X)%*%Y
 beta.hat
 # Y.hat = X beta
 X%*%beta.hat




# --- Simulation: Omitted variable bias, (p.19) ---
 set.seed(123)
 epsilon <- rnorm(10000)
 omega   <- rnorm(10000)
 eta     <- rnorm(10000)

 x1 <- 5  + omega 
 x2 <- 10 + omega + 0.3* eta
 y  <- 20 + x1 + x2 + epsilon
 
 lm(y ~ x1 + x2)$coef   # unbiased estimates
 lm(y ~ x1)$coef		# cov(x1,x2)=1 -> OVB for b1; Intercept biased

 1*cov(x1,x2)/var(x1)     # size of the bias.

 # back to the CASchools dataset
 cor(stratio, english)
 lm(score ~ stratio)
 lm(score ~ stratio + english)




# --- Multicollinearity, (p.24) ---
 str(CASchools)
 ?CASchools
 FracEnglish = english/100
 lm(score ~ stratio + english + FracEnglish)
 
 # Simulation
 set.seed(123)
 perturbedEstimate <- function(x) {
   FracEnglish = english/100 + rnorm(4) * 0.0000001
   est <- lm(score ~ stratio + english + FracEnglish)
   coef(est)[3:4]
 }
 estList <- sapply(1:100, perturbedEstimate)
 plot(t(estList), main = "multicollinearity, estimated coefficients")

 # Large coefficients for english are balanced by small coefficients for FracEnglish.
 # Essentially, we have estimated:
 # score = 686 - 1.1*stratio + (A - 0.65)*english - 100A*(english/100)
 # where A is a constant.
 # -> coefficients of english and FracEnglish (=english/100) cannot be identified anymore




# --- F-test, (pp.28) ---
# Why not run two t-tests at 5% level instead of the joint F-test?
 set.seed(100)
 N <- 1000
 p <- 0.05             # 5% significance level / size of the test
 qcrit <- -qnorm(p/2)  # critical value for two-sided test
 b1 <- rnorm(N)
 b2 <- rnorm(N)
 reject <- abs(b1) > qcrit | abs(b2) > qcrit   # two-sided test
 mean(reject) * 100                            # rejection rate of H0

# In the example 10.3 % of the values are rejected, not 5%. This is not a
# coincidence. The reaosn is that the method gives you too many chances:
# If you fail to reject the first t-statistic, you get to try again using the
# second.

# Additionally:
 par(mfrow=c(1,2))
 plot(b2 ~ b1)
 points(b2 ~ b1, subset = reject, col = "red", pch = 7)
 abline(v = c(qcrit, -qcrit), h = c(qcrit, -qcrit))
 data.ellipse(b1, b2, levels = 1 - p, plot.points = FALSE)
 legend("topleft", c("naive rejection", "confidence region"),
   pch = c(7, NA), col = "red", lty = c(NA, 1))

# We can see that this naive approach only takes the maximum
# deviation of the variables into account. It would be more sensible to exclude all
# observations outside of the red circle.

# The second problem becomes even more annoying, if the random variables are correlated:

 set.seed(100)
 b1 <- rnorm(N)
 b2 <- 0.3 * rnorm(N) + 0.7 * b1
 reject <- abs(b1) > qcrit | abs(b2) > qcrit
 plot(b2 ~ b1)
 points(b2 ~ b1, subset = reject, col = "red", pch = 7)
 abline(v = c(qcrit, -qcrit), h = c(qcrit, -qcrit))
 data.ellipse(b1, b2, levels = 1 - p, plot.points = FALSE)
 text(-1, 1, "A")
 legend("topleft", c("naive rejection", "confidence region"),
   pch = c(7, NA), col = "red", lty = c(NA, 1))

# For example, "A" in the diagram is clearly outside the confidence interval, but
# none of its coordinates are "conspicious".




# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

