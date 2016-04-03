---
title: FAQ
layout: default
group: Teaching
comments: true
published: true
---



## FAQ I

This FAQ for [Quantitative Methods I](/teaching/quant1/index.html) and [Econometrics I](/teaching/econometrics1/index.html) is a compilation of questions and answers that where posted on the course forum in previous years. For more comprehensive FAQs on R and statistics, see [http://ats.ucla.edu](http://ats.ucla.edu) and [http://cran.r-project.org](http://cran.r-project.org). 

***

#### Course resources

- [Where do I find the datasets you used in lectures and workshops?](#a1)
- [I have issues installing the R commander. Where do I find help?](#a2)
- [I want to replicate textbook examples using R. Where can I find some hints?](#a3)
- [What does the shccm() function do?](#a4)

####  R commands

- [How can I change the language in the console?](#b1)
- [How do I plot normal density functions and shaded areas in R?](#b2)
- [How do I know my current working directory? How can I set my workspace?](#b3)
- [How do I create a dummy variable? How do I change the reference category of an explanatory variable?](#b4)
- [How do I check the length of a variable or the dimension of a dataset?](#b5)
- [How do I obtain growth rates from a vector of observations?](#b6)
- [How do I load Excel, SPSS, Stata, SAS, or EViews files in R?](#b7)
- [How do I change variable names in R?](#b8)

#### Error messages

- [I use "exactly" the same commands as in your script / the R help but still get an error message.](#c1)
- [I get an error saying "object myvariable is not found" although I loaded mydata including myvariable. What is wrong?](#c2)
- [I get an error saying "ERROR: 'x' must be numeric", or "using type="numeric" with a factor response will be ignored". What's that?](#c3)
- [The results I get with R differ from Excel, which I use as a "test".](#c4)
- [One of my explanatory variables is automatically dropped from the model. Why is that?](#c5)
- [Why do I get "ERROR: there are aliased coefficients in the model" when estimating my model?](#c6)
- [I get the following warning message: "longer object length is not a multiple of shorter object length".](#c7)

#### Statistical concepts 

- [How can I get a one sided t-test with the linearHypothesis() function?](#d1)
- [Breusch-Pagan, Koenker, White? How to test for heteroskedasticity in R?](#d2)
- [How do I find suitable variable transformations in a multiple regression model?](#d3)
- [How is it possible that my tests indicate homoskedasticity but standard errors under summary() and shccm() still differ?](#d4)
- [Can I use the RESET test to check if there are no relevant omitted variables in the regression model?](#d5)
- [I found a model with a good overall fit but it fails several assumptions. How should I proceed?](#d6)

#### Organisation

- [I have a question on the course material. Where do I get an answer?](#e1)
- [Which questions should be reserved for office hours?](#e2)
- [Can you write me a reference letter?](#e3)
- [Can you supervise my M.Phil. dissertation?](#e4)
- [I don't like the course the way it is. What can I do?](#e5)
- [I like this course!](#e6)
- [Lectures, handout, workshops, exercises, contest... -- do I have to do all this?](#e7)

***

#### Course resources

***

##### <a name="a1"></a> Where do I find the datasets you used in lectures and workshops?
All datasets we use in lecture and workshops are available online in the folder [http://klein.uk/R/](https://github.com/thiloklein/thiloklein.github.io/tree/master/R/). One way to pull the data from the website is to paste the full path in your browser command line and save the dataset in txt or csv format. You can also use the R console to read the data in the active workspace by typing:

```r
yourdata <- read.csv("http://klein.uk/R/yourdata")
```

and write it to your local disk

```r 
write.csv(yourdata, "C:/mydata.csv")
```

and also re-read it in your active R-workspace

```r 
yourdata.new <- read.csv("C:/mydata.csv")
```

if you check your workspace you will find the two datasets (in R's language: dataframes)

```r 
ls()
```

to remove one of them type

```r 
rm("yourdata.new"); ls()
```

[Back to top](index.html)

***

##### <a name="a2"></a> I have issues installing the R commander. Where do I find help?

Follow [this](http://socserv.mcmaster.ca/jfox/Misc/Rcmdr/installation-notes.html) tutorial for Mac, Windows, and Linux systems.

[Back to top](index.html)

***

##### <a name="a3"></a> I want to replicate textbook examples using R. Where can I find some hints?

If you are working with the Stock and Watson (2007) book, you may find this helpful:

```r 
install.packages("AER"); help("StockWatson2007", package = "AER")
```

The same works for `"Greene2003"`, `"Baltagi2002"`, `"CameronTrivedi1998"`, `"Franses1998"`, and `"WinkelmannBoes2009"`.

[Back to top](index.html)

***

##### <a name="a4"></a> What does the shccm() function do?

Use the `shccm()` function instead of `summary()` to report regressions results with heteroskedasticity robust standard errors for large samples. If your data is homoskedastic, the robust errors will give the same results as the errors estimated under the homoskedasticity assumption. If your data is heteroskedastic, only the robust errors will be consistent. Therefore, with heteroskedasticity robust errors you are always on the safe side.
In the course of last year's programme, I wrote several convenience functions that should make your life easier. The functions and a short documentation are available at [http://klein.uk/R/myfunctions.R](http://klein.uk/R/myfunctions.R). To work with the functions, first source them

```r 
source("http://klein.uk/R/myfunctions.R")
```

and look at the required arguments and the example

```r 
R> shccm
 
  function(model, type=c("hc0","hc1","hc2","hc3","hc4")){

    # R-code (www.r-project.org) for computing
    # HC standard errors for a linear model (lm).
    # > source("http://klein.uk/R/myfunctions.R")
	 
    # The arguments of the function are:
    # model = a model fitted with lm()
    # type  = one of "hc0" to "hc4", 
    # refer to package hccm in the car library

    # Example: shccm(my.lm.model, "hc0")
    ...
  }
```

[Back to top](index.html)

***

#### R commands

***

##### <a name="b1"></a> How can I change the language in the console?

Switch to English

```r 
library(tcltk2); setLanguage("en_US")
```

and test your setting with a command that issues a warning

```r 
1:3 + 1:2
```

For other languages check
```r 
?setLanguage
```

[Back to top](index.html)

***

##### <a name="b2"></a> How do I plot normal density functions and shaded areas in R?

Plot normal densities

```r 
grid  <- seq(9,11,0.001)
norm  <- dnorm(grid,mean=10,sd=0.2)
plot(grid, norm,type="l",xlab="x", ylab="f(x)")

norm  <- dnorm(grid,mean=10.3,sd=0.2)
lines(grid, norm)
abline(h=0)
```

Plot of shaded areas below density curves ([Source]( http://www.feferraz.net/en/P/Shaded_areas_in_R))

```r 
## light
cord.x <- c(10.4,seq(10.4,11,0.01),11)
cord.y <- c(0,dnorm(seq(10.4,11,0.01), mean=10.3,sd=0.2),0) 
polygon(cord.x,cord.y,col="grey80", lty=0)

## dark
cord.x <- c(10.4,seq(10.4,11,0.01),11)
cord.y <- c(0,dnorm(seq(10.4,11,0.01), mean=10,sd=0.2),0)
polygon(cord.x,cord.y,col="grey30", lty=0)

## add legend
legend("topleft",legend=c("dark","light"),fill=c("grey30","grey80"),bty="n")
```

[Back to top](index.html)

***

##### <a name="b3"></a> How do I know my current working directory? How can I set my workspace?

To get your working directory, use the command

```r 
getwd()
```

and to change it, use

```r 
setwd("C:/...")
```

[Back to top](index.html)

***

##### <a name="b4"></a> How do I create a dummy variable? How do I change the reference category of an explanatory variable?

Generate a factor variable

```r 
gender <- factor(c("male","male","female","female","male","female")); gender
[1] male   male   female female male   female
Levels: female male
```

Create dummy variable

```r 
yourgenderdummy <- ifelse(gender=="female",1,0); yourgenderdummy
[1] 0 0 1 1 0 1
```

Change reference category
```r 
levels(gender)
[1] "female" "male"  

gender <- relevel(gender, ref="male")

levels(gender)
[1] "male"   "female"
```

[Back to top](index.html)

***

##### <a name="b5"></a> How do I check the length of a variable or the dimension of a dataset?

Length
```r 
length(myvariable)
```

Dimension and variable types of a dataset
```r 
str(mydataset)
```

Dimension
```r 
dim(mydataset)
```

[Back to top](index.html)

***

##### <a name="b6"></a> How do I obtain growth rates from a vector of observations?

There are several ways to accomplish this in R. One way is by using

```r 
x <- cumsum(1:5); x
[1]  1  3  6 10 15

n <- length(x); n
[1] 5

xg <- c( NA, diff(x) / x[1:(n-1)] ); xg
[1]        NA 2.0000000 1.0000000 0.6666667 0.5000000

cbind(x, xg)
      x        xg
[1,]  1        NA
[2,]  3 2.0000000
[3,]  6 1.0000000
[4,] 10 0.6666667
[5,] 15 0.5000000
```

At this point it comes in handy to write your own convenience function:

```r 
growthrate <- function(x){
  c( NA, diff(x) / x[1:(length(x)-1)] )
}
growthrate(x)
[1]        NA 2.0000000 1.0000000 0.6666667 0.5000000
```

Note: the difference in length of the level vector `x` and the growth vector `xg` is taken care of by placing the additional `NA`.

[Back to top](index.html)

***

##### <a name="b7"></a> How do I load Excel, SPSS, Stata, SAS, or EViews files in R?

For xls files:

```r 
library(gdata)
read.xls("C:/yourdata.xls")
```

In the R Commander: Data -> import data from excel file. For the other software packages:

```r 
library(foreign)
help(package=foreign)
```

For example, SPSS can be read using `read.spss`, Stata files using `read.dta`, etc

[Back to top](index.html)

***

##### <a name="b8"></a> How do I change variable names in R?

Suppose you want to change the first variable name in your dataset 'yourdata'. Just type:

```r 
names(yourdata)[1] <- "newname"
```

[Back to top](index.html)

***

#### Error messages

***

##### <a name="c1"></a> I use "exactly" the same commands as in your script / the R help but still get an error message.

Be aware that R is case sensitive. If you type, for example

```r 
cov(x, y, use=" pairwise.complete.obs")
```

instead of

```r 
cov(x, y, use="pairwise.complete.obs")
```

you will receive an error message. Please rule out such problems before you post on the forum.

[Back to top](index.html)

***

##### <a name="c2"></a> I get an error saying "object myvariable is not found" although I loaded mydata including myvariable. What is wrong?

R allows you to load multiple datasets in the active workspace. This additional freedom comes at a price: you have to tell R which dataset you want to work with -- otherwise it will not know and tell you that the object is not found. You should either do

```r 
plot(mydata$myvariable)
```

or alternatively

```r 
attach(mydata)
plot(myvariable)
```

If you choose the second option, make sure you detach your data by typing

```r 
detach(mydata)
```

when you attach a new dataset to work with. I usually forget this and therefore prefer to go for the first option.

[Back to top](index.html)

***

##### <a name="c3"></a> I get an error saying "ERROR: 'x' must be numeric", or "using type="numeric" with a factor response will be ignored". What's that?

When you get one of these error messages you are probably trying to apply a statistical method that requires an integer (such as years of schooling) or numeric variable (such as body height) but your input variable is stored in a factor format (with levels, for example, "red", "green", "blue"). You can check the storage format of all the variables in your data by typing

```r 
str(yourdata)
```

R will not run a linear regression for a dependent variable that is stored in factor format. While this is quite sensible in most cases, there may be cases where your factor levels are "1", "2", "3", and so forth and you may wish to use this variable as the dependent variable in a linear regression or a corrlation matrix. In this case, you can convert the variable type to numeric

```r 
yourdata$yourvariable <- as.numeric( as.character( yourdata$yourvariable ) )
```

or integer format

```r 
yourdata$yourvariable <- as.integer( as.character( yourdata$yourvariable ) )
```

[Back to top](index.html)

***

##### <a name="c4"></a> The results I get with R differ from Excel, which I use as a "test".

Let me first reemphasise that Excel is not a statistical software and does things in a very, well.. at best idiosyncratic way. One example I came across last year is Excel's skewness formula. There are generally two ways of calculating the sample skewness, dependent on how you do the degrees of freedom adjustments.

See the definition of sample skewness at [wikipedia](http://en.wikipedia.org/wiki/Skewness#Sample_skewness).

Data

```r 
data <- c(1,6,3,4,2,5,9,6,2,2)
```

Caculate skewness using R's `timeDate` package

```r 
install.packages("timeDate")
library(timeDate)
skewness(data, method="moment")

## this is the skewness formula in the timeDate package:
skewness.timeDate = function(x){
  m3 <- mean((x-mean(x))^3)
  m3/(sd(x)^3)
}
skewness.timeDate(data)
[1] 0.5798614
```

Caculate skewness using R's `moment` package

```r 
install.packages("moments")
library(moments)
skewness(data)

## this is the skewness formula in the moment package:
skewness.moments = function(x){
  m3 = mean((x-mean(x))^3)
  m3/(1/10*sum((x-mean(x))^2))^(3/2)
}
skewness.moments(data)
[1] 0.6791418
```

The difference is in the degrees of freedom adjustment of the standard deviation:

```r 
## timeDate does:
sqrt(1/9*sum((data-mean(data))^2))

## moments does:
sqrt(1/10*sum((data-mean(data))^2))
```

Now, here is how Excel does things. Its [SKEW function](http://office.microsoft.com/en-us/excel-help/skew-HP005209261.aspx) actually calculates the population (not the sample!) skewness: n/((n-1)*(n-2)) * sum(((x-x_bar)/s)^3). Here s is the sample standard deviation, yielding

```r 
10/((10-1)*(10-2)) * sum(((data-mean(data))/sd(data))^3)
[1] 0.8053631
```

[Back to top](index.html)

***

##### <a name="c5"></a> One of my explanatory variables is automatically dropped from the model. Why is that?

The non-technical answer is that (at least) two of the variables in your model are collinear. For the technical version check the [next question](#c6).

[Back to top](index.html)

***

##### <a name="c6"></a> Why do I get "ERROR: there are aliased coefficients in the model" when estimating my model?

Having aliased coefficients in your model means that the square matrix `X'X` (where `X` is your design matrix) is singular, i.e., it has determinant of zero and is non-invertible. This is the classical problem of perfect multicollinearity. The coefficient vector `b_hat=(X'X)^[-1]X'y` can therefore not be estimated. For the model summary, R will drop one variable and return NA as the estimate for it's aliased coefficient. To obtain the vif and other model statistics, drop one of the variables that cause the singularity manually and try the command again.

[Back to top](index.html)

***

##### <a name="c7"></a> I get the following warning message: "longer object length is not a multiple of shorter object length".

You are using two variables with different length. This usually happens when you work with both level and growth rates or differenced data. See a detailed treatment [here](#b6).

[Back to top](index.html)

***

#### Statistical concepts

***

##### <a name="d1"></a> How can I get a one sided t-test with the linearHypothesis() function?

For the case of testing a single hypothesis, you can use the equivalence of F-test and t-test: `F stat = (t stat)^2` and the general relationship between p-values for one-sided and two-sided test. Here is an example from MPO1 Lab Session 2, Exercise 2. Suppose we want to test whether employment grows at a lower rate than GDP does. The null is GDPgrow=1, the alternative GDPgrow<1.

Read the data and run the simple OLS regression:

```r 
growth <- read.csv("http://klein.uk/R/growth",header=T,sep=",")
lm2    <- lm(empgrow ~ GDPgrow, data=growth); summary(lm2)
...
Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.54589    0.27404  -1.992   0.0584 .  
GDPgrow      0.48974    0.08512   5.754 7.34e-06 ***
...

t-test (manually):

my.ttest <- function(model, coef, h0){
  # which number does coef GDPgrow have in the regression eqn?
    x  <- which(names(model$coef)==coef)      
  # coef estimate   
    b  <- summary(model)$coef[x,1]           
  # coef standard error estimate   
    se_b <- summary(model)$coef[x,2]          
  # t-value 
    t  <- (b - h0) / se_b       
  # model degrees of freedom = n - k                
    df <- length(lm2$resid) - length(lm2$coef)  
  # probability mass exceeding the t-value
    p  <- pt(q=abs(t), df=df, lower.tail=FALSE) 
    print(list(t.value=t, degrees.of.freedom=df, 
    p.value.onesided=p, p.value.twosided=2*p))
}

my.ttest(model=lm2, coef="GDPgrow", h0=1)
$t.value
[1] -5.994741

$degrees.of.freedom
[1] 23

$p.value.onesided
[1] 2.054161e-06

$p.value.twosided
[1] 4.108322e-06
```

Observe that you get the same results for the two-sided p-value with an F-test because F-test and t-test are equivalent for testing a single hypothesis. To obtain the one-sided p-value, simply devide the two-sided p-value by two.

F-test (using lht function):

```r 
library(car)
linearHypothesis(model=lm2, "GDPgrow=1")
Linear hypothesis test

Hypothesis:
GDPgrow = 1

Model 1: restricted model
Model 2: empgrow ~ GDPgrow

  Res.Df    RSS Df Sum of Sq      F    Pr(>F)    
1     24 25.949                                  
2     23 10.127  1    15.823 35.937 4.108e-06 ***
...
```

[Back to top](index.html)

***

##### <a name="d2"></a> Breusch-Pagan, Koenker, White? How to test for heteroskedasticity in R?

The LM test in the lecture slides can be obtained in R using the option `studentize=T`. This test was suggested by Koenker (1981) and is preferable to the classical Breusch-Pagan test (option: `studentize=F`) because it does not rely on normally distributed errors.

The White test is an extension of the above tests and can be obtained for your linear model, lm1, and a single explanatory variable, x, as follows:

```r 
bptest(lm1, ~ x + I(x^2))
```

While the BP test tests for the expected value of the squared residuals to be a linear function of the explanatory variables, the White test tests for any general correlation structure including squared and interaction terms. The shortcomings of the White test are probably twofold. First, it is not feasible for a large number of explanatory variables. Second, both tests also lead us to reject the null if the model is misspecified (the White test even more so). I would generally recommend to test for missepecification of the functional form using a REgression Specification Error Test (RESET) before testing for the minor problem of heteroskedasticity.

Sources: Wooldridge (2009) Introductory econometrics: a modern approach, pages 271ff; Kleiber and Zeileis (2008) [Applied Econometrics with R](http://www.springerlink.com/content/w38470382115gu30/), pages 101ff.

[Back to top](index.html)

***

##### <a name="d3"></a> How do I find suitable variable transformations in a multiple regression model?

For the simple linear regression one can plot the variables and see how they relate to each other. In multiple regression, you can use residual plots against fitted values (y hat) or independent variables to find suitable variable transformations, the very same way that you would proceed with simple linear regression. This is an iterative process. One way to automate this, although no panacea, is to use step-wise model-selection based on information criteria such as AIC or BIC (covered in Lent Term). Do lookup the `stepAIC()` function from library MASS.

[Back to top](index.html)

***

##### <a name="d4"></a> How is it possible that my tests indicate homoskedasticity but standard errors under summary() and shccm() still differ?

Homoskedasticity tests can probably not reject the null because the tests have low power for low sample size. The same problem then carries through to your robust estimates. Note that standard and robust error estimates only converge for large samples.

[Back to top](index.html)

***

##### <a name="d5"></a> Can I use the RESET test to check if there are no relevant omitted variables in the regression model?

Linearity tests, such as the RESET test, only test for a very specific type of misspecification: imposing a linear model on non-linear data. To see this, let us first simulate two models, `y = 20 + x1 + x2` and `z = 20 + x1 + x1^2` as follows.

Generate some error terms
```r 
set.seed(123)

epsilon <- rnorm(10000)
omega   <- rnorm(10000)
eta     <- rnorm(10000)
```

Generate independent variables

```r 
x1 <- 5 + omega + 0.3* eta
x2 <- 10 + omega
```

Generate dependent variables

```r 
y <- 20 + x1 + x2 + epsilon
z <- 20 + x1 + x1^2 + epsilon
```

Let us now regress misspecified versions of these true models and see whether RESET test complains.

General model misspecification: Omitted Variable Bias for b2

```r 
cov(x1,x2)  # =1
[1] 1.002215

## misspecified model lm1
lm1 <- lm(y ~ x1); lm1$coef
(Intercept)          x1 
  25.352378    1.929317 

## true model:
lm(y ~ x1 + x2)$coef
(Intercept)          x1          x2 
 20.2702907   1.0666237   0.9394416 

## misspecification NOT indicated by RESET test!
library(lmtest)
resettest(lm1)
	RESET test

data:  lm1 
RESET = 0.437, df1 = 2, df2 = 9996, p-value = 0.646
```

Misspecification of functional form

```r 
## misspecified model lm2
lm2 <- lm(z ~ x1); lm2$coef
(Intercept)          x1 
  -3.935416   11.004898 

## true model
lm(z ~ x1 + I(x1^2))$coef
(Intercept)          x1     I(x1^2) 
 19.7731242   1.0819818   0.9928987 

## misspecification indicated by RESET test
resettest(lm2)
	RESET test

data:  lm2 
RESET = 11556.97, df1 = 2, df2 = 9996, p-value < 2.2e-16
```

[Back to top](index.html)

***

##### <a name="d6"></a> I found a model with a good overall fit but it fails several assumptions. How should I proceed?

The first step is to be aware of the problem, i.e., any effects on consistency and efficiency of the estimates? In how far would sample size mitigate problems? What alternative estimation methods are available? You would then want to describe possible model improvements and also estimate these models (given you have the data you need).

[Back to top](index.html)

***

#### Organisation

***

##### <a name="e1"></a> I have a question on the course material. Where do I get an answer?

It works best to ask your question directly in the lecture. And indeed, if at all possible, ask me and not your neighbors (o: This reduces the noise level and I can immediately address problems and avoid confusion.

Of course, there will be questions that come up only after the lecture. Here are three suggestions:

- First, try to find an answer individually and, if necessary, refer to the literature. Try to work independently -- this is the aim of your studies.
- Of course, no one is born a master, and you may have several questions that you can't find an answer to. Questions related to lectures and workshops can simply be posted on the forum. Other students, the teaching associates, and I can then comment on them. You will notice that it is not easy to formulate questions and answers clearly. The forum gives you the opportunity to gain more routine in the formulation of scientific concepts. In addition, you are certainly not the only person who would like a response. Only if you ask your question in public, can we all benefit from questions and answers.
- Finally, there are questions that have nothing to do with the lecture, but with econometrics, and that won't let you sleep at night. In this case, please email me a brief description of what you've done to find a solution, and why your attempts have so far failed. I will then try to give you a hint or point you to resources. Also, consider booking an appointment at the School's [Empirics Lab](/teaching/consulting/index.html) or at the University's [Statistics Clinic](http://www.statslab.cam.ac.uk/clinic).

I try my best to help you, and sometimes it would be easier -- in the short term -- to explain a connection, instead of showing you how to find an answer yourself -- in the long term, however, you will learn more in the latter approach.

[Back to top](index.html)

***

##### <a name="e2"></a> Which questions should be reserved for office hours?

I answer any questions that concern you and only you -- at least I will try it. These are, for example, questions regarding your study plans, individual research projects, reference letters, etc. You should prepare these questions by email. For simple requests (appointments) during the term, you can expect an answer within one business day, and we should find a date within a week.

In the interest of all students, I answer subject-related questions directly in the lectures, the workshops, or later in the forum. Please keep in mind that I teach many other students. If only a fraction of those would use the office hours to recap the material in private lessons, there would be no time for questions relating to individual aspects (study plans, individual research projects, reference letters, etc.).

This applies equally to the teaching associates. Again, it works best to ask questions on the material directly in the workshops or later in the discussion forum. The teaching associates are not paid to repeat the same material again and again in private lessons. It is also not their job to give individual students an edge over other students and provide "insider" information. Questions regarding course material and assignments are relevant to all students in the course. Please ask these questions so that everyone can benefit from the response -- in lecture, workshop, or forum.

This leaves office hours with all the more time for questions that are unrelated to assignments (such as your individual research projects, individual difficulties in your studies, ...). Send me an email and we will arrange an appointment in the next few days.

[Back to top](index.html)

***

##### <a name="e3"></a> Can you write me a reference letter?

I can always write you a reference letter for a scholarship, a PhD programme, etc. However, my recommendation can be more or less strong. In particular your grades in my course will only determine part of the letter. Please consider the following points when asking me for a reference letter.

- Make sure that your proposed research and your referee are a good fit. A referee who is not familiar with your research area is obviously not a good recommendation for you. If your research is on development finance, experimental economics, or empirical methods, a selection panel may better undestand why you chose me as a referee and will take my letter more seriously.
- I can only write a reference letter once your workbooks for the course have been graded. If you need an early reference, one option for me is to consider your performance in the weekly contest and issue your letter at the end of Michaelmas term.
- If you can check off the above points, please send me your letter of motivation / cover letter, your research proposal, as well as an overview of your grades (transcript of records from CamSIS) if available. Please send these documents in pdf, postscript, text, or odt format (not in a microsoft .doc or .docx format). I will have a look at your documents and we will arrange an interview.

[Back to top](index.html)

***

##### <a name="e4"></a> Can you supervise my M.Phil. dissertation?

No. You should find a faculty member who is interested in supervising your research. If you are not sure which scholar to approach with your research proposal, I can probably help you with that. That being said, I am more than happy to discuss the empirical aspects of your dissertation at any stage of your research. To do so, please go to [Empirics Lab](/teaching/consulting/index.html) to arrange an appointment, or stop by at the University's [Statistics Clinic](http://www.statslab.cam.ac.uk/clinic).

[Back to top](index.html)

***

##### <a name="e5"></a> I don't like the course the way it is. What can I do?

In this case, please give me an advance notice. Many things are a lot easier for you to notice (font too small, micro distorted, presentation too fast / too slow ...). For me it is very frustrating to read about problems -- which I could have fixed in the first term week -- only in the end of term evaluation. Please notify me directly in class or just after class, send me an email, or give vent to your anger in the forum. As long as you give no feedback, I have to assume that you are very happy (o:

[Back to top](index.html)

***

##### <a name="e6"></a> I like this course!

If you like something particularly well, I am of course happy to hear it (o:

[Back to top](index.html)

***

##### <a name="e7"></a> Lectures, handout, workshops, exercises, contest... -- do I have to do all this?

Short answer: No. Simply choose the modules that suit your learning style best.

- Learn the concepts based on handouts and recommended literature, or based on the lectures -- both are possible. In particular, the lecture is not a "must" but a "can".
- Practice as much as possible -- certainly using the tasks of the contest, and, if possible, using the exercises.
- Use the feedback from the contest.
- Attending the workshops will be particularly useful if you have familiarized yourself with the exercises in advance.

It is not my goal that you work more for this course than for other, equally important courses. The components are simply supposed to help you organize your learning process adapted to your needs.

[Back to top](index.html)
