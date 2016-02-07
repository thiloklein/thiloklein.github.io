# -------------------------------------------------------------------
# Lecture 3: Normal distribution, estimators, sampling distributions of estimators, tests of hypotheses

# Required libraries: --
  rm(list=ls())
  # source("http://thiloklein.de/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------


# --- Standard normal distribution ---------------------------------

# Normal distribution: 68-95-99.7 or six sigma rule
  plot(dnorm(seq(-5,5,.1)) ~ seq(-5,5,.1), type="l")
  abline(h=0, v=c(-3,-2,-1,0))

# What proportion of observations are smaller than 0.83? (p.6)
  pnorm(0.83)

# What proportion of observations are greater than -2.15? (p.7)
  1 - pnorm(-2.15)

# Inverse of SND: F^{-1}(0.03) = ? (p.8)
  qnorm(0.03)

# Inventory example. (p.9ff)
  # What is the probability of a stockout?
  1 - pnorm(20, mean=15, sd=6)
  # If the prob of stockout is to be no more than 5%, what should the reorder point be?
  qnorm(1-0.05, mean=15, sd=6)




# --- Asymptotic properties of estimators (pages 23-25) ----------------

  # Simulate probability distribution of sample mean.
  d = function(n) density( sapply(1:10000, function(x) mean(rnorm(n, mean=100, sd=50))) )
  
  # Plot probability density of sample mean (sample size 1).
  plot( d(1), ylim=c(0,.08), main="Distribution of sample mean")
  abline(h=0)
    
  # Sample size 4, 25, and 100.
  sapply(c(4,25,100), function(x) lines( d(x) ) )




# --- Simulation: Sample variance, unbiased estimators (pages 27-29) ----

# --- PART A: Biased vs unbiased estimator for population variance.

# What's special about n-1 in the equation for the sample standard deviation?
# What would happen if we used n instead?

# Unbiased sample variance with denominator n-1
  var(0:1)

# Biased sample variance with denominator n
  newvar = function(x) 1/length(x) * sum( (x-mean(x))^2 )
  newvar(0:1)

# 1,000 Simulations (sample size 10) and mean of biased vs unbiased sample variance
  s2 = sapply(1:1000, function(x){ 
      sample10 = rnorm(10,mean=0,sd=1)
      c( var(sample10), newvar(sample10) )
    }
  )
  s2.unbiased = s2[1,]; mean(s2.unbiased)
  s2.biased = s2[2,]; mean(s2.biased)
    

# --- PART B: Consistency of the biased variance estimator.

# If the sample size is increased it ceases to matter whether we use n or n-1 in the denominator.
# Simulate distribution of biased sample variance for different sample sizes
  d = function(n) density( sapply(1:10000, function(x) newvar(rnorm(n, mean=100, sd=50))) )
  
  # Sample size 10
  plot(d(10), ylim=c(0,.005)); abline(h=0, v=50^2)
  
  # Sample sizes 20, 100, and 1000
  sapply(c(20,100,1000), function(x) lines(d(x)) )

# In summary, using n gives a biased estimate of the true variance. The smaller the sample size, the greater this discrepancy between the unbiased and biased estimator.




# --- Simulation: Power of a test (pages 67-69) -------------------------

# Define hypothesis test function.
  h.test.A = function(n, mu){ 
    sapply(mu, function(x) abs( mean( rnorm(n, mean=x, sd=1) ) ) > qnorm(0.975)/sqrt(n) )
  }

  h.test.B = function(n, mu){ 
    sapply(n, function(x) abs( mean( rnorm(x, mean=mu, sd=1) ) ) > qnorm(0.975)/sqrt(x) )
  }


# --- PART A: Power of a test and evidence against H0 -------------------

# Set values of sample size and population mean.
  n = 10
  mu = c(0, .05, .1, .2, 1, 2)
# Run simulation for sample size n=10 and population means of 0, .05, .1, .2, 1, and 2.
  data = sapply(1:10000, function(x) h.test(n=n, mu=mu))
# calculate percentage of rejections when null is not true (= power of test).
  rejections = sapply(1:6, function(x) sum(data[x,])/10000)
# To see the test's power, graph the prob of rejecting H0 against the evidence.
  plot(rejections ~ mu, ylab="Prob of rejecting H0", xlab="Evidence against H0", main="Power of test")
  lines(lowess(rejections ~ mu, f=0.5))
  abline(h=0.05)  # horizontal line for size of the test, i.e., Prob(rejecting H0 | H0 true)


# --- PART B: Power of a test and sample size ---------------------------

# Set values of sample size and population mean.
  n = c(10, 100, 1000)
  mu = 0.2
# Run simulation for population mean mu=0.2 and sample size of 10, 100 and 1000. 
  data = sapply(1:10000, function(x) h.test.B(n=n, mu=mu))
# calculate percentage of rejections when null is not true (= power of test).
  rejections = sapply(1:3, function(x) sum(data[x,])/10000)
# To see the test's power, graph the prob of rejecting H0 against the evidence.
  plot(rejections ~ n, ylab="Prob of rejecting H0", xlab="Sample size", main="Power of test")
  lines(lowess(rejections ~ n, f=0.5))

  
  

# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

  q("no")
