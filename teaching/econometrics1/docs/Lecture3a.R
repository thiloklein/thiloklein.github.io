# -------------------------------------------------------------------
# Lecture 3: F-tests for goodness of fit, Non-linearity and Model Transformations, Dummy variables 

# Required libraries: AER, car
  rm(list=ls())
  source("http://klein.uk/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------




# --- California school districts once again... ---
 
 data("CASchools", package = "AER")
 CASchools$stratio = with(CASchools, students/teachers)
 CASchools$score = with(CASchools, (math + read)/2)
 attach(CASchools)

 par(mfrow = c(2, 2))
 plot(score ~ income, main = "district average income")
 
## Part A: Linear model
 lm1 = lm(score ~ income)
 shccm(lm1)
 abline(lm1, col = "blue", lwd=2)
 plot(lm1, which = 1)  # Diagnostic residual plot


## Part B: Quadratic model
 income2 = income * income
 lm2 = lm(score ~ income + income2)
 shccm(lm2)

 or = order(income)   # calculates a permutation vector. 
 plot(score ~ income, main = "district average income")
 abline(lm1, col = "blue", lwd = 2)
 lines(lm2$fitted[or] ~ income[or], col = "red", lwd = 2)
 legend("bottomright", c("linear", "quadratic"), lwd = 2,
  col = c("blue", "red"))
 plot(lm2, which = 1)   # Dignostic residual plot

# Are income and income2 jointly significant?
 library(car)
 lht(lm2, c("income","income2"))
 
# Marginal effect of a change of income at income level 50k?
 lm2$coef["income"] + 2 * 50 * lm2$coef["income2"]
# Is marginal effect at income level 50k significantly different from 0?
 lht(lm2, "income + 100*income2")




# --- Polynomials ---

 par(mfrow=c(1,1))
 plot(score ~ income, main = "district average income")
 abline(lm1, col = "blue", lwd=2)

# Sequential hypothesis test in the case of polynomial models:

 lm2 = lm(score ~ income + income2)
 lines(income[or], fitted(lm2)[or], col = "red", lwd = 2)
 shccm(lm2)

 income3 = income * income * income
 lm3 = lm(score ~ income + income2 + income3)
 lines(income[or], fitted(lm3)[or], col = "green", lwd = 2)
 shccm(lm3)

 lmp = lm(score ~ poly(income, 10))
 smooth = list(income = seq(5, 70, 0.5))
 lines(smooth$income, predict(lmp, newdata = smooth),
  col = "magenta", lwd = 2)
 legend("bottomright", c("linear", "quadratic", "cubic",
  "10th-deg"), lwd = 2, col = c("blue", "red", "green", "magenta"))




# --- Digression: Rescale variables to have mean=0 and sd=1 in polynomial models ---
 z = (income - mean(income) / sd(income))
 lm4 = lm(score ~ z + I(z^2) + I(z^3))    # equivalent to model lm3, except for using z-scores
 shccm(lm4)            # lower sd and larger t-statistics of the coefs than model lm3!
 vif(lm3); vif(lm4)    # lower vif statistics than model lm3




# --- Logarithms (see handout) ---

 plot(score ~ income, main = "district average income")
 abline(lm1, col = "blue", lwd=2)
 lines(income[or], fitted(lm2)[or], col = "red", lwd = 2)
 legend("bottomright", c("linear", "quadratic", "lin-log",
 "log-lin", "log-log"), lwd = 3, col = c("blue", "red",
 "green", "black", "orange"))

# linear-log model
# if X_i changes by 1%, Yi changes by 0.01 * beta_1
 lmLiLo = lm(score ~ log(income)); lmLiLo
 lines(income[or], fitted(lmLiLo)[or], col = "green", lwd = 3)
# marginal effect at median income-level: 
 lmLiLo$coef[2]/median(income)

# log-linear model
# a change of X_i by one unit translates into a change of Y_i by beta_1 * 100%
 lmLoLi = lm(log(score) ~ income); lmLoLi
 lines(income[or], exp(fitted(lmLoLi))[or], col = "black", lwd = 3)

# log-log model
# beta_1 is the elasticity of Y_i with respect to X_i .
 lmLoLo = lm(log(score) ~ log(income)); lmLoLo
 lines(income[or], exp(fitted(lmLoLo))[or], col = "orange", lwd = 3)




# --- Dummy variables and Interactions ---

# Data on the demand for refrigerators
 fridge = read.csv("http://klein.uk/R/fridge2.csv")
 str(fridge)
 attach(fridge)

# Data summaries and linear regression
 summary(fridge[, c("ecost", "price")])
 plot(price ~ ecost, main="Energy cost and refrigerator price")
 lm1 = lm(price ~ ecost); summary(lm1)
 abline(lm1, col="blue", lwd=2)   # fitted line plot

# OVB problem
 scatterplotMatrix(fridge[, 1:3])
 cor(fridge[, 1:3])


# --- Digression: Graphical Representation of Correlation Matrix (PLOTCORR) ---

 # install.packages("ellipse")
 library(ellipse)
 # corC =  cor(data.frame(price, volume, ecost, top, side, bottom))
 corC =  cor(fridge[,1:3])
 colors = c("#A50F15","#DE2D26","#FB6A4A","#FCAE91","#FEE5D9","white",
            "#EFF3FF","#BDD7E7","#6BAED6","#3182BD","#08519C")   
 plotcorr(corC, col=colors[5*corC + 6], type = "lower")
 
# --- End of Digression ---


# Mitigating OVB. Why can we not expect the following to be a good model?
 lm2 = lm(price ~ volume + ecost); summary(lm2)
 library(car)
 vif(lm2)

# What else? Freezer position can matter for price: dummy variables!
# What does the data look like?
 freezer = as.factor(freezer)
 levels(freezer) = c("bottom","top","side")

 # lm(price ~ volume + ecost + top + side + bottom)
 lm3 = lm(price ~ volume + ecost + freezer); summary(lm3)

# bottom effects (and others, e.g., E[u]!=0) are captured in the intercept
 lm3$coef["(Intercept)"]

# top intercept
 lm3$coef["(Intercept)"] + lm3$coef["freezertop"]

# side intercept
 lm3$coef["(Intercept)"] + lm3$coef["freezerside"]

# both differences (from bottom) are signif.
 lht(lm3, "freezerside"); lht(lm3, "freezertop")

# Is the effect of "top" different from "side"? 
# -> change the reference category to "side"
 freezer = relevel(freezer, ref="side")
 lm4 = lm(price ~ volume + ecost + freezer); summary(lm4)

# Is it reasonable to assume the slope coefficients are the same for all types 
# of fridges? See slope dummy variables

 # 3 separate models for top, bottom and side
 lm.top = lm(price ~ volume + ecost, data=fridge[freezer=="top",]); summary(lm.top)
 lm.bottom = lm(price ~ volume + ecost, data=fridge[freezer=="bottom",]); summary(lm.bottom)
 lm.side = lm(price ~ volume + ecost, data=fridge[freezer=="side",]); summary(lm.side)

 # slope dummies / interactions
 lm6 = lm(price ~ volume + ecost + freezer + volume:freezer + ecost:freezer); summary(lm6)
 vif(lm6)

# Do the slope coefs differ for top, side or bottom?
 lht(lm6, c("volume:freezerbottom","volume:freezertop","ecost:freezerbottom","ecost:freezertop"))

 levels(freezer)[2:3] = "topbottom"
 lm6 = lm(price ~ volume + ecost + freezer + volume:freezer + ecost:freezer); summary(lm6)
 lht(lm6, c("volume:freezertopbottom", "ecost:freezertopbottom"))




# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

