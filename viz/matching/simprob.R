rm(list=ls())
set.seed(124)
N = 100
X = 10*runif(N)
e = rnorm(N)
Y = -2.5 + 0.5*X + e
R = ifelse(Y>0,1,0)

## true model
plot(Y ~ X,col="white")
points(Y[R==0] ~ X[R==0], col="black")
points(Y[R==1] ~ X[R==1], col="red")
abline(lm(Y ~ X), col="blue", lwd=2)

#install.packages("animation")
library(animation)  # load animation package
saveGIF({  # this line and next are for recording the movie
  ani.options(interval=2,nmax=20,ani.width=1000,ani.height=1000,dev=png,type="png","convert",outdir=getwd())
  
  ## iterations
  niter = 10
  alphadraws = rep(NA,niter)
  alpha = c(0,0)
  scale = 3
  
  Yupperbar = ifelse(R==0, 0, Inf)
  Ylowerbar = ifelse(R==1, 0, -Inf)
  
  for(iter in 1:niter){

    liter = 1:iter
    
    Yhat = cbind(1,X)%*%alpha
    
    uppercdf = pnorm(Yupperbar,Yhat,1)
    lowercdf = pnorm(Ylowerbar,Yhat,1)
    Ysim = qnorm(lowercdf+(uppercdf-lowercdf)*runif(N),Yhat,1) # Inverse c.d.f. sampling.    
    
    ## PLOT 1
    V = paste("Simulate: V.",iter,sep="")
    b = paste("conditional on: a.",iter-1,sep="")
    plot(Y ~ X, col="white", axes=F, xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(V,b,sep=" "))
    axis(2,ylim=c(min(Y),max(Y)),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=1, bty="n")

    ## PLOT 1b
    V = paste("Simulate: V.",iter,sep="")
    b = paste("conditional on: a.",iter-1,sep="")
    plot(Y ~ X, col="white", axes=F, xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(V,b,sep=" "))
    axis(2,ylim=c(min(Y),max(Y)),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    points(Ysim[R==1] ~ X[R==1], col="red")
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=1, bty="n")
    rect(xleft=-2,xright=12,ybottom=-5,ytop=0,density=10,col="grey")
    
    ## PLOT 2
    V = paste("Simulate: V.",iter,sep="")
    b = paste("conditional on: a.",iter-1,sep="")
    plot(Y ~ X, col="white", axes=F, xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(V,b,sep=" "))
    axis(2,ylim=c(min(Y),max(Y)),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    points(Ysim[R==0] ~ X[R==0], col="black")
    points(Ysim[R==1] ~ X[R==1], col="red")
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=1, bty="n")
    rect(xleft=-2,xright=12,ybottom=0,ytop=5,density=10,col="grey")
    
    ## PLOT 3
    b = paste("Simulate: a.",iter,sep="")
    V = paste("conditional on: V.",iter,sep="")
    plot(Y ~ X, col="white", axes=F, xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(b,V,sep=" "))
    axis(2,ylim=c(min(Y),max(Y)),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    points(Ysim[R==0] ~ X[R==0], col="black")
    points(Ysim[R==1] ~ X[R==1], col="red")
    
    lm1 = lm(Ysim ~ X)
    #alpha = lm1$coef
    
    abline(lm1, lwd=2)
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=1, bty="n")
    
    ## PLOT 4
    b = paste("Simulate: a.",iter,sep="")
    V = paste("conditional on: V.",iter,sep="")
    plot(Y ~ X, col="white", axes=F, xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(b,V,sep=" "))
    axis(2,ylim=c(min(Y),max(Y)),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    points(Ysim[R==0] ~ X[R==0], col="black")
    points(Ysim[R==1] ~ X[R==1], col="red")
    
    #lm1 = lm(Ysim ~ X)
    alpha = lm1$coef
    alphadraws[iter] = scale*alpha[2]
    
    abline(lm1, lwd=2)
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=1, bty="n")
    
  }
  
},movie.name="simprob.gif")  # end movie recorder
