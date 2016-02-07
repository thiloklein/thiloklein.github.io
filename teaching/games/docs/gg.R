#####################################################
## ~~ Script to analyse data from Guessing game ~~ ##
#####################################################

## install R software from http://cran.r-project.org/
## optional: install user-interface Rstudio http://www.rstudio.com/ide/download/

## read data and variable names:

## a) from clipboard in linux
 #data <- read.table("clipboard",sep=" ",header=TRUE)
 #names(data) <- names(read.table("clipboard",sep=" ",header=TRUE))

## b) from csv file
 data <- read.csv("~/Desktop/gg.csv")


## drop non-participants and attach data
 data <- subset(data, Guess!="*.**")
 attach(data)
 str(data)


## convert factors to numeric type
 Guess <- as.numeric(as.character(Guess))
 Avg.Guess <- as.numeric(as.character(Avg.Guess))


## plot histogram
 r <- 1 # first round
 hist(Guess[Round==r], breaks=seq(0,100,.25), xlim=c(0,max(Guess[Round==r])), 
   main="Histogram", xlab="Round 1", col="black")
 abline(v=Avg.Guess[Round==r],col="blue",lwd=2,lty=2)
 abline(v=2/3*Avg.Guess[Round==r],col="red",lwd=2,lty=2)
 legend(x=40,y=1.75,c("mean","2/3*mean","guesses"),col=c("blue","red","black"),lty=c(2,2,1),lwd=2,bty="n",cex=0.9)


# -------------------------------------------------------------------
# --- End of Session ------------------------------------------------

q("no") # exit