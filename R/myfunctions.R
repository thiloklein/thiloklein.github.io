# -------------------------------------
# --- Compute NA count from dataset ---

 showNAs <- function(x){

   # R-code (www.r-project.org) for computing
   # NA counts by variable in a dataset.
   # > source("http://thiloklein.de/R/myfunctions.R")
	 
   # The argument of the function is:
   # x = a dataframe

   # Example: showNAs(mydata)

   data.frame( 
     NA.count = sapply( 
       as.list( data.frame( 
           ifelse(is.na(x), 1, 0)[,1:dim(x)[2]] 
        ) )
     , FUN = sum ) 
   )
 }


# ----------------------------------------------------------------------------------------
# --- Round to two decimal places as specified in contest quizzes (by Michael Freeman) ---

 roundUp <- function(value, dp=2) {

   # R-code (www.r-project.org) for rounding to two decimal places.
   # > source("http://thiloklein.de/R/myfunctions.R")
	 
   # The argument of the function is:
   # x = a number

   # Example: roundUp(x)

    if (dp < 0) paste("Incorrectly specified decimal places.")
    else {
        dp <- as.integer(dp) ; mult <- 10^dp
        if (value < 0) newval <- ceiling(value * mult - 0.5)
        if (value >= 0) newval <- floor(value * mult + 0.5)
        newval/mult
    }
 }


# -----------------------------------------------------------------------------------
# --- Summary regression table with Heteroscedasticity-consistent standard errors ---

 shccm <- function(model, type=c("hc0", "hc1", "hc2", "hc3", "hc4")){

    # R-code (www.r-project.org) for computing
    # HC standard errors for a linear model (lm).
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The arguments of the function are:
    # model = a model fitted with lm()
    # type  = one of "hc0" to "hc4", refer to package hccm in the car library for a description

    # Example: shccm(my.lm.model, "hc0")

    if (!require(car)) stop("Required car package is missing.")
    type <- match.arg(type)
    V <- hccm(model, type=type)
    sumry <- summary(model)
    table <- coef(sumry)
    table[,2] <- sqrt(diag(V))
    table[,3] <- table[,1]/table[,2]
    table[,4] <- 2*pt(abs(table[,3]), df.residual(model), lower.tail=FALSE)
    sumry$coefficients <- table
    p <- nrow(table)
    hyp <- if (names(model$coef)[1]=="(Intercept)") cbind(0, diag(p - 1)) else diag(p)
    sumry$fstatistic[1] <- linearHypothesis(model, hyp, white.adjust=type)[2,"F"]
    print(sumry)
    cat("Note: Heteroscedasticity-consistent standard errors using adjustment", type, "\n") 
 }


# -------------------------------------------------------------------------------------------------------
# --- Summary regression table with Heteroscedasticity and autocorrelation consistent standard errors ---

 shaccm <- function(model){

    # R-code (www.r-project.org) for computing
    # HAC standard errors for a linear model (lm).
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The arguments of the function are:
    # model = a model fitted with lm()

    # Example: shaccm(my.linear.model)

    if (!require(sandwich)) stop("Required sandwich package is missing.")
    V <- vcovHAC(model)
    sumry <- summary(model)
    table <- coef(sumry)
    table[,2] <- sqrt(diag(V))
    table[,3] <- table[,1]/table[,2]
    table[,4] <- 2*pt(abs(table[,3]), df.residual(model), lower.tail=FALSE)
    sumry$coefficients <- table
    p <- nrow(table)
    hyp <- if (names(model$coef)[1]=="(Intercept)") cbind(0, diag(p - 1)) else diag(p)
    sumry$fstatistic[1] <- linearHypothesis(model, hyp, vcov.=vcovHAC)[2,"F"]
    print(sumry)
    cat("Note: Heteroscedasticity and autocorrelation consistent standard errors", "\n") 
 }


# ------------------------------------------------------
# --- convenience functions: HC0 and HC1 covariances ---

 hc0 <- function(x) vcovHC(x, type = "HC0")
 hc1 <- function(x) vcovHC(x, type = "HC1")


# ----------------------------------------------------------------
# --- Summary regression table for SEM with HC standard errors ---

 shccm.sysf <- function(model){

    # R-code (www.r-project.org) for computing HC s.e. using White correction ("hc0")
    # for a simultaneous equation model (SEM) estimated with system.fit().
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The argument of the function is:
    # model = a model fitted with system.fit()

    # Example: shccm.sysf(my.sem.model)

    if (!require(car)) stop("Required car package is missing.")

    ncoef1 <- length(model$eq[[1]]$coefficients)
    ncoef2 <- length(model$eq[[2]]$coefficients)    
    n <- dim(model.matrix(model))[1]

    X1 <- model.matrix(model)[1:(n/2),1:ncoef1]
    X2 <- model.matrix(model)[(n/2+1):n,(ncoef1+1):(ncoef1+ncoef2)]
    e1 <- residuals(model)$demand
    e2 <- residuals(model)$supply
    V1 <- solve(t(X1)%*%X1) %*% t(X1) %*% diag(e1^2) %*% X1 %*% solve(t(X1)%*%X1)
    V2 <- solve(t(X2)%*%X2) %*% t(X2) %*% diag(e2^2) %*% X2 %*% solve(t(X2)%*%X2)
    V <- c( sqrt(diag(V1)), sqrt(diag(V2)) )

    sumry <- summary(model)
    table <- coef(sumry)

    table[,2] <- V
    table[,3] <- table[,1]/table[,2]
    table[,4] <- 2*pt(abs(table[,3]), df.residual(model), lower.tail=FALSE)

    sumry$eq[[1]]$coefficients <- table[1:ncoef1,]
    sumry$eq[[2]]$coefficients <- table[(ncoef1+1):(ncoef1+ncoef2),]
    
    print(sumry)
    cat("Note: Heteroscedasticity-consistent standard errors using adjustment hc0 \n") 
 }


# ------------------------------------------------------
# --- Augmented Dickey Fuller test (correct p-value) ---

adf.test.1<-function (x, int, trend, k = trunc((length(x)- 1)^(1/3))){

    # R-code (www.r-project.org) for computing an
    # Augmented Dickey Fuller test.
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The arguments of the function are as in the original adf.test function, i.e.
    # x    = a numeric vector or time series
    # k    = the lag order to calculate the test statistic.
    # In addition, we have
    # int   = logical, a constant is included if int=T
    # trend = logical, a trend variable is included if trend=T

    # Example: adf.test.1(my.time.series, int=F, trend=T)

    # The null is ALWAYS non stationarity.

    if (NCOL(x) > 1) 
        stop("x is not a vector or univariate time series")

    if (any(is.na(x))) 
        stop("NAs in x")

    if (k < 0) 
        stop("k negative")

    DNAME <- deparse(substitute(x))

    k <- k + 1
    y <- diff(x)
    n <- length(y)
    z <- embed(y, k)
    yt <- z[,1]
    xt1 <- x[k:n]
    tt <- k:n

    if (int==F & trend==F){
        table <- cbind(c(2.66, 2.62, 2.6, 2.58, 2.58, 2.58), c(2.26, 
        2.25, 2.24, 2.23, 2.23, 2.23), c(1.95, 1.95, 1.95, 1.95, 
        1.95, 1.95), c(1.60, 1.61, 1.61, 1.62, 1.62, 1.62), c(0.92, 
        0.91, 0.90, 0.89, 0.89, 0.89), c(1.33, 1.31, 1.29, 1.29, 
        1.28, 1.28), c(1.70, 1.66, 1.64, 1.63, 1.62, 1.62), c(2.16, 
        2.08, 2.03, 2.01, 2.00, 2.00))
        if (k > 1) {
            yt1 <- z[,2:k]
            res <- lm(yt ~ xt1 - 1 + yt1)
        }
        else res <- lm(yt ~ xt1-1)
        res.sum <- summary(res)
        STAT <- res.sum$coefficients[1,1]/res.sum$coefficients[1,2]    
    }
    if (int==T & trend==F){
        table <- cbind(c(3.75, 3.58, 3.51, 3.46, 3.44, 3.43), c(3.33, 
        3.22, 3.17, 3.14, 3.13, 3.12), c(3.00, 2.93, 2.89, 2.88, 
        2.87, 2.86), c(2.62, 2.60, 2.58, 2.57, 2.57, 2.57), c(0.37, 
        0.40, 0.42, 0.42, 0.43, 0.44), c(0.00, 0.03, 0.05, 0.06, 
        0.07, 0.07), c(0.34, 0.29, 0.26, 0.24, 0.24, 0.23), c(0.72, 
        0.66, 0.63, 0.62, 0.61, 0.60))
        if (k > 1) {
            yt1 <- z[,2:k]
            res <- lm(yt ~ xt1 + 1 + yt1)
        }
        else res <- lm(yt ~ xt1 + 1)
        res.sum <- summary(res)
        STAT <- res.sum$coefficients[2,1]/res.sum$coefficients[2,2]
    }
    if (int==T & trend==T){
        table <- cbind(c(4.38, 4.15, 4.04, 3.99, 3.98, 3.96), c(3.95, 
        3.8, 3.73, 3.69, 3.68, 3.66), c(3.6, 3.5, 3.45, 3.43, 
        3.42, 3.41), c(3.24, 3.18, 3.15, 3.13, 3.13, 3.12), c(1.14, 
        1.19, 1.22, 1.23, 1.24, 1.25), c(0.8, 0.87, 0.9, 0.92, 
        0.93, 0.94), c(0.5, 0.58, 0.62, 0.64, 0.65, 0.66), c(0.15, 
        0.24, 0.28, 0.31, 0.32, 0.33))
        if (k > 1) {
            yt1 <- z[,2:k]
            res <- lm(yt ~ xt1 + 1 + tt + yt1)
        }
        else res <- lm(yt ~ xt1 + 1 + tt)
        res.sum <- summary(res)
        STAT <- res.sum$coefficients[2,1]/res.sum$coefficients[2,2]
    }
    table <- -table
    tablen <- dim(table)[2]
    tableT <- c(25, 50, 100, 250, 500, 1e+05)
    tablep <- c(0.01, 0.025, 0.05, 0.1, 0.9, 0.95, 0.975, 0.99)
    tableipl <- numeric(tablen)

    for (i in (1:tablen)) tableipl[i] <- approx(tableT, table[,i], n, rule = 2)$y
    interpol <- approx(tableipl, tablep, STAT, rule = 2)$y

    if (is.na(approx(tableipl, tablep, STAT, rule = 1)$y)) 
        if (interpol == min(tablep)) 
            warning("p-value smaller than printed p-value")
        else warning("p-value greater than printed p-value")

    PVAL <- interpol

    PARAMETER <- k - 1
    METHOD <- "Augmented Dickey-Fuller Test"
    names(STAT) <- "Dickey-Fuller"
    names(PARAMETER) <- "Lag order"

    structure(list(statistic = STAT, parameter = PARAMETER,alternative = "The series has no unit root",
    p.value = PVAL, method = METHOD, data.name = DNAME),class = "htest")
}


# ----------------------------------------------
# --- Augmented Dickey Fuller test (summary) ---

adf.test.2 <- function(x, int = T, trend = T, k = trunc((length(x)- 1)^(1/3))){

# Construct Data for Augmented Dickey Fuller Model with k lags.

    # R-code (www.r-project.org) for computing an
    # Augmented Dickey Fuller test with k lags.
    # Correct p-values need to be obtained from a Dickey-Fuller table!
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The arguments of the function are: 
    # x     = time series vector
    # k     = number of lags to be included in the test
    # int   = logical, a constant is included if int=t
    # trend = logical, a trend variable is included if trend=T

    # a) Models with intercept and trend (int=T, trend=T)
    # b) Models with intercept but without trend (int=T, trend=F)
    # c) Models without intercept and without trend (int=F, trend=F) 

    # Example: adf.test.2(my.time.series, k=2, int=T, trend=T)

        x <- ts(x)   # convert the data x into time series
        D <- diff(x) # compute the first difference of data x
        if(k > 0) {
            for(i in 1:k)
                D <- ts.intersect(D, lag(diff(x),  - i))
        }
        D <- ts.intersect(lag(x, -1), D) # binds series exclude NAs
        if(trend == T)
            D <- ts.intersect(D, time(x))
        y <- D[, 2]
        x <- D[, -2]
        if(int == T)
            o2=lm(y ~ x)
        else o2=lm(y ~ x - 1)
    # if no intercept wanted then force regr thru origin using the -1
    # list(o1=cbind(y,x), o2=o2)           # there are two outputs
    o2
}


# ---------------------------------------------------
# --- F-test with Dickey-Fuller corrected p-value ---

 linearHypothesis.adf <- function(model, hypothesis){

    # R-code (www.r-project.org) for conducting a
    # F-test with ADF corrected p-value.
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The arguments of the function are as in the original linearHypothesis function, i.e.
    # model       = fitted model object
    # hypothesis  = a character vector giving the hypothesis in symbolic form

    # Example: linearHypothesis.adf(mymodel, c("xD.lag(x, -1)", "xtime(x)", "(Intercept)"))

   if (!require(car)) stop("Required car package is missing.")
   STAT <- lht(model, hypothesis)$F[2]
   names(STAT) <- "F-statistic"
   n <- length(model$resid)
   
  if("(Intercept)" %in% hypothesis  &  "xtime(x)" %in% hypothesis == F){
    table <- cbind(c(4.12, 3.94, 3.86, 3.81, 3.79, 3.78), #phi1
         c(5.18, 4.86, 4.71, 4.63, 4.61, 4.59), 
         c(6.30, 5.80, 5.57, 5.45, 5.41, 5.38), 
         c(7.88, 7.06, 6.70, 6.52, 6.47, 6.43))
  }
  if("(Intercept)" %in% hypothesis  &  "xtime(x)" %in% hypothesis){
    table <- cbind(c(4.67, 4.31, 4.16, 4.07, 4.05, 4.03), #phi2
         c(5.68, 5.13, 4.88, 4.75, 4.71, 4.68), 
         c(6.75, 5.94, 5.59, 5.40, 5.35, 5.31), 
         c(8.21, 7.02, 6.50, 6.22, 6.15, 6.09))
  }
  if("(Intercept)" %in% hypothesis == F  &  "xtime(x)" %in% hypothesis){
    table <- cbind(c(5.91, 5.61, 5.47, 5.39, 5.36, 5.34), #phi3
         c(7.24, 6.73, 6.49, 6.34, 6.30, 6.25), 
         c(8.65, 7.81, 7.44, 7.25, 7.20, 7.16), 
         c(10.61, 9.31, 8.73, 8.43, 8.34, 8.27))
  }

  tablen <- dim(table)[2]
  tableT <- c(25, 50, 100, 250, 500, 1e+05)
  tablep <- c(0.1, 0.05, 0.025, 0.01)
  tableipl <- numeric(tablen)

  for (i in (1:tablen)) tableipl[i] <- approx(tableT, table[,i], n, rule = 2)$y
  interpol <- approx(tableipl, tablep, STAT, rule = 2)$y

  if (is.na(approx(tableipl, tablep, STAT, rule = 1)$y)){
      if (interpol == min(tablep)){
          warning("p-value smaller than printed p-value")
      }
      else{
          warning("p-value greater than printed p-value")
      }
  }

  structure(list(statistic = STAT, alternative = "a0/a2 and gamma jointly significant",
    p.value = interpol, method="F-test with p-value from DF-table",data.name="ADF regression model"),class = "htest")
 }


# ---------------------------------------------------
# --- Ljung-Box Test statistic with flexible lags ---

ljung.box.test.1 <- function (x, lags){

# Performs the Ljung-Box Test with flexible specification of lags.

    # R-code (www.r-project.org) for computing the
    # Ljung-Box Test statistic.
    # > source("http://thiloklein.de/R/myfunctions.R")
	 
    # The arguments of the function are: 
    # x     = a vector of variables to be tested
    # lags  = the lags for which test statistic and p-value should be reported

    # Example: ljung.box.test.1(x = myvector, lags = seq(from=1,to=10,by=1))

    if (!is.vector(x)) {
        cat("Error: The argument must be a vector.\n")
    }
    else {
        nobs <- length(x)
        nlag <- seq(1, 50, 1)
        y <- x - mean(x)
        denom <- sum(y^2)
        rho <- numeric(length(nlag))
        for (i in 1:length(nlag)) {
            rho[i] <- sum(y[(nlag[i] + 1):nobs] * y[1:(nobs - 
                nlag[i])])/denom
        }
        rho <- nobs * (nobs + 2) * (rho^2/(nobs - nlag))
        Q <- cumsum(rho)
        p.val <- pchisq(Q, df = nlag, lower.tail = FALSE)
        ans <- cbind(Q, p.val)
        colnames(ans) <- c("test stat", "p-value")
        rownames(ans) <- paste("Lag", nlag)
        ans[lags, ]
    }
}


# -------------------------------------------------
# --- Hausman test for exogeneity of regressors ---

 dwh.test <- function(model.iv, model.ols){

   # R-code (www.r-project.org) for computing the Hausman test
   # for for endogeneity of regressors.
   # > source("http://thiloklein.de/R/myfunctions.R")
	 
   # The arguments of the function are:
   # model.iv  = model fitted with ivreg()
   # model.ols = model fitted with lm(), without instruments

   # Example: dwh.test(my.ivreg, my.lm)

   cf_diff <- coef(model.iv) - coef(model.ols)
   vc_diff <- vcovHC(model.iv, "HC0") - vcovHC(model.ols, "HC0")
   x2_diff <- as.vector(t(cf_diff) %*% solve(vc_diff) %*% cf_diff)
   pchisq(q = x2_diff, df = dim(vc_diff)[1], lower.tail = F)
 }


# ---------------------------------------------------------------------
# --- Overall, between and within standard deviation for panel data ---

 s.panel <- function(data, index, name=" "){

   # R-code (www.r-project.org) for computing the overall, between and
   # within standard deviation for panel data.
   # > source("http://thiloklein.de/R/myfunctions.R")
	 
   # The arguments of the function are:
   # data  = a vector of data
   # index = a factor of lenght length(data)
   # name = optional, the variable name to be printed next to "Variable:"

   # Example: s.panel(my.variable, my.index, "my.variable.name")

   m <- mean(data)
   s.o <- sd(data)#*sqrt((length(data)-1)/length(data))  # overall
   s.b <- sd(by(data, index, mean))#*sqrt((length(data)-1)/length(data))  # between
   s.w <- mean( c( by( data, index, function(x) sd(x))))#*sqrt((length(x)-1)/length(x))) ) )  # within
   cat("------------------------------------------ \n")
   cat("Variable:", name, "\n")
   print(round( data.frame(Mean=m, SE.overall=s.o, SE.between=s.b, SE.within=s.w), 3))
   cat("\n")
 }


# ---------------------------------------------------
# --- Clustered-standard errors (by Mahmood Arai) ---

 clx <- function(fm, dfcw, cluster){
         # R-codes (www.r-project.org) for computing
         # clustered-standard errors. Mahmood Arai, Jan 26, 2008.
	 
	 # The arguments of the function are:
         # fitted model, cluster1 and cluster2
         # You need to install libraries `sandwich' and `lmtest'
	 
         # reweighting the var-cov matrix for the within model
         library(sandwich);library(lmtest)
         M <- length(unique(cluster))   
         N <- length(cluster)           
         K <- fm$rank                        
         dfc <- (M/(M-1))*((N-1)/(N-K))  
         uj  <- apply(estfun(fm),2, function(x) tapply(x, cluster, sum));
         vcovCL <- dfc*sandwich(fm, meat=crossprod(uj)/N)*dfcw
         coeftest(fm, vcovCL) 
 }


# -------------------------------------------------------------
# --- Multi-way clustered-standard errors (by Mahmood Arai) ---

 mclx <- function(fm, dfcw, cluster1, cluster2){
         # R-codes (www.r-project.org) for computing multi-way 
         # clustered-standard errors. Mahmood Arai, Jan 26, 2008. 
         # See: Thompson (2006), Cameron, Gelbach and Miller (2006)
         # and Petersen (2006).
	 # reweighting the var-cov matrix for the within model
         
         # The arguments of the function are:
         # fitted model, cluster1 and cluster2
         # You need to install libraries `sandwich' and `lmtest'
         
         library(sandwich);library(lmtest)
         cluster12 = paste(cluster1,cluster2, sep="")
         M1  <- length(unique(cluster1))
         M2  <- length(unique(cluster2))   
         M12 <- length(unique(cluster12))
         N   <- length(cluster1)          
         K   <- fm$rank             
         dfc1  <- (M1/(M1-1))*((N-1)/(N-K))  
         dfc2  <- (M2/(M2-1))*((N-1)/(N-K))  
         dfc12 <- (M12/(M12-1))*((N-1)/(N-K))  
         u1j   <- apply(estfun(fm), 2, function(x) tapply(x, cluster1,  sum)) 
         u2j   <- apply(estfun(fm), 2, function(x) tapply(x, cluster2,  sum)) 
         u12j  <- apply(estfun(fm), 2, function(x) tapply(x, cluster12, sum)) 
         vc1   <-  dfc1*sandwich(fm, meat=crossprod(u1j)/N )
         vc2   <-  dfc2*sandwich(fm, meat=crossprod(u2j)/N )
         vc12  <- dfc12*sandwich(fm, meat=crossprod(u12j)/N)
         vcovMCL <- (vc1 + vc2 - vc12)*dfcw
         coeftest(fm, vcovMCL)
 }


# --------------------------------------------------------------------------------
# --- STATA-like Heteroskedasticity-robust standard errors (by Kevin Goulding) ---

 summaryw <- function(model) {
         s <- summary(model)
         X <- model.matrix(model)
         u2 <- residuals(model)^2
         XDX <- 0

         ## Here one needs to calculate X'DX. But due to the fact that
         ## D is huge (NxN), it is better to do it with a cycle.
         for(i in 1:nrow(X)) {
                  XDX <- XDX + u2[i]*X[i,]%*%t(X[i,])
         }

         # inverse(X'X)
         XX1 <- solve(t(X)%*%X)

         # Variance calculation (Bread x meat x Bread)
         varcovar <- XX1 %*% XDX %*% XX1

         # degrees of freedom adjustment
         dfc <- sqrt(nrow(X))/sqrt(nrow(X)-ncol(X))

         # Standard errors of the coefficient estimates are the
         # square roots of the diagonal elements
         stdh <- dfc*sqrt(diag(varcovar))

         t <- model$coefficients/stdh
         p <- 2*pnorm(-abs(t))
         results <- cbind(model$coefficients, stdh, t, p)
         dimnames(results) <- dimnames(s$coefficients)
         results
 }


# --------------------------------------------------------------
# --- STATA-like Clustered Standard Errors (by Mahmood Arai) ---

 cl   <- function(dat,fm, cluster){
           attach(dat, warn.conflicts = F)
           library(sandwich)
           M <- length(unique(cluster))
           N <- length(cluster)
           K <- fm$rank
           dfc <- (M/(M-1))*((N-1)/(N-K))
           uj  <- apply(estfun(fm),2, function(x) tapply(x, cluster, sum));
           vcovCL <- dfc*sandwich(fm, meat=crossprod(uj)/N)
           coeftest(fm, vcovCL) 
 }


# -------------------------------------------
# --- Marginal effects for matching model ---

 mfxVal <- function(postmean,poststd,nrowX){

     ## Reference: Sorensen (2007, p. 2748)

     mx <- dnorm(0)*postmean/sqrt(2)
     s.e. <- dnorm(0)*poststd/sqrt(2)
     t.stat <- mx/s.e.
     p.val <- pt(-abs(t.stat),df=nrowX-length(postmean))
     stars <- ifelse(p.val<0.001,"***",ifelse(p.val<0.01,"**",ifelse(p.val<0.05,"*",ifelse(p.val<0.10,".",""))))
     #res <- data.frame( round(cbind(mx, s.e., t.stat, p.val),3), stars)
     sign <- ifelse(mx>0,"~","")
     res <- data.frame( "&", sign, round(mx,3), se=paste(paste("(",round(s.e.,3),sep=""),")",sep=""), stars, "\\")
     return(res)
 }


# -----------------------------------------
# --- Marginal effects for probit model ---

 mfx <- function(sims=10000,x.mean=TRUE,postmean,poststd,X){
    ## source: http://researchrepository.ucd.ie/handle/10197/3404
    ## method: average of individual marginal effects at each observation
    ## interpretation: http://www.indiana.edu/~statmath/stat/all/cdvm/cdvm.pdf page 8
    set.seed(1984)
    if(x.mean==TRUE){
      ## marginal effects are calculated at the means of independent variables
      pdf <- dnorm(mean(X%*%postmean))
      pdfsd <- dnorm(sd(X%*%postmean))
    } else{
      ## marginal effects are calculated for each observation and then averaged
      pdf <- mean(dnorm(X%*%postmean))
      pdfsd <- sd(dnorm(X%*%postmean))
    }  
    mx <- pdf*postmean
  
    sim <- matrix(rep(NA,sims*length(postmean)), nrow=sims)
    for(i in 1:length(postmean)){
      sim[,i] <- rnorm(sims,postmean[i],poststd[i])
    }
    pdfsim <- rnorm(sims,pdf,pdfsd)
    sim.se <- pdfsim*sim
    s.e. <- apply(sim.se,2,sd)
  
    t.stat <- mx/s.e.
    p.val <- pt(-abs(t.stat),df=dim(X)[1]-length(postmean)+1)
    stars <- ifelse(p.val<0.001,"***",ifelse(p.val<0.01,"**",ifelse(p.val<0.05,"*",ifelse(p.val<0.10,".",""))))
    #res <- data.frame( colnames(X), round(cbind(mx, s.e., t.stat, p.val),3), stars)
    sign <- ifelse(mx>0,"~","")
    res <- data.frame( colnames(X), "&", sign, round(mx,3), se=paste(paste("(",round(s.e.,3),sep=""),")",sep=""), stars, "\\")
    return(res)
}

