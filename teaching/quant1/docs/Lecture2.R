# -------------------------------------------------------------------
# Lecture 2: Random variables and probability distributions

# Required libraries: --
  rm(list=ls())
  # source("http://thiloklein.de/R/myfunctions.R")
  ls()
# -------------------------------------------------------------------


# --- Simulation: de Mere's Problem (page 2) -------------------

  set.seed(123)

# Simulate 4 throws of a single die
  dice4 = sample(6,4,T)
# Check condition
  6 %in% dice4
# 1000 simulations
  e = sapply(1:1000, function(x) 6 %in% sample(6,4,T))
# frequency table
  table(e)
# relative frequency
  mean(e)

# Simulate 24 throws of two dice
  dice24.1 = sample(6,24,T); dice24.2 = sample(6,24,T)
# Check condition
  12 %in% (dice24.1 + dice24.2)
# 1000 simulations
  f = sapply(1:1000, function(x) 12 %in% (sample(6,24,T) + sample(6,24,T)))
# frequency table 
  table(f)
# relative frequency
  mean(f)




# --- Simulation: Central Limit Theorem (page 27) -------------------

# 10,000 draws from a uniform distribution. This is the parent distribution which is obviously non-Normal.
  x = runif(10000)
  hist(x)

# To compute an average, two observations are drawn at random from the parent distribution and averaged. 
# Then another sample of two is drawn and another value average is computed. This process is repeated 10,000 times.
  x = sapply(1:10000, function(x) mean(runif(2)) )
# Distribution of averages of two
  hist(x, freq=F)

# Repeatedly taking eight from the parent distribution and computing averages
  x = sapply(1:10000, function(x) mean(runif(8)) )
  hist(x, freq=F)
# Distribution of the mean approaches a Normal distribution
  lines(x=seq(0,1,.01), y=dnorm(seq(0,1,.01), mean(x), sd(x)), col="blue")




# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

  q("no")
