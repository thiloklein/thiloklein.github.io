rm(list=ls())
#set.seed(123)
set.seed(125)
library(graphics)



require(animation)  # load animation package
saveGIF({  # this line and next are for recording the movie
  ani.options(interval=2,nmax=20,ani.width=1000,ani.height=1000,dev=png,type="png","convert",outdir=getwd())
  
  ## Data
  N = 6 ##70, 20, 6
  W = 10*runif(N)
  #source("http://www.matchingmarkets.org/OneSidedMatching.R")
  #require(partitions)
  #require(MASS)
  #data = simdata.onesided(m=1, ind=3, s=124, gpm=2)
  #matchdata = OneSidedMatchingDesign(data=data, selection = list(add="pi",add="wst")
  #, outcome = list(add="pi",add="wst"), roommates=FALSE, simulation=TRUE)
  
  e = rnorm(N)
  V = -2.5 + 0.5*W + e
  equ1 = which(V == max(V))
  equ2 = which(V == min(V)) 
  
  W = c(W[c(equ1,equ2)], W[-c(equ1,equ2)])
  V = c(V[c(equ1,equ2)], V[-c(equ1,equ2)]) 
  D = c(1,1,rep(0,4))
  
  niter = 7
  Vsim = rep(0,N)
  alphadraws = rep(NA,niter)
  alpha = c(0,0)
  scale = 3


for(iter in 1:niter){
  liter = 1:iter

  ##########################################################
  ## Simulate the latent valuations conditional on alpha. ##
  ## considering upper bounds for unobserved groups       ##
  ##########################################################
 
  Vlowerbar = 4.5
  Vupperbar = max(Vsim[1:2])
  end = length(V)
  Vhat = cbind(1,W[3:end])%*%alpha
  uppercdf = pnorm(Vupperbar,Vhat,1)
  Vsim[3:end] = qnorm(uppercdf*runif(length(3:end)),Vhat,1) # Inverse c.d.f. sampling.
 
  ## PLOT 1a
  Y = paste("Simulate: V.",iter,sep="")
  b = paste("conditional on: a.",iter-1,sep="")
  plot(V ~ W, col="white", ylim=c(-4.5,4), xlim=c(0,10), axes=FALSE, ,xlab="Characteristics (W) / Iterations"
     , ylab="Latent valuation (V)",main=paste(Y,b,sep=" "))
  axis(2,ylim=c(-4.5,4),lwd=2)
  axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
  axis(1,xlim=c(1,10),lwd=2)
  rect(xleft=-1,xright=11,ybottom=Vlowerbar,ytop=Vupperbar,density=10,col="grey")
  points(Vsim[1:2] ~ W[1:2], col="red",pch=8, lwd=2)
  abline(alpha[1],alpha[2],lwd=2,lty=2)
  abline(h=-4.5+scale*0.5, col="blue", lwd=2)
  lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
  points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
  legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
  legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=c(8,1), bty="n")


  ## PLOT 1b
  Y = paste("Simulate: V.",iter,sep="")
  b = paste("conditional on: a.",iter-1,sep="")
  plot(V ~ W, col="white", ylim=c(-4.5,4), xlim=c(0,10), axes=FALSE, ,xlab="Characteristics (W) / Iterations"
     , ylab="Latent valuation (V)",main=paste(Y,b,sep=" "))
  axis(2,ylim=c(-4.5,4),lwd=2)
  axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
  axis(1,xlim=c(1,10),lwd=2)
  rect(xleft=-1,xright=11,ybottom=Vlowerbar,ytop=Vupperbar,density=10,col="grey")
  points(Vsim[3:end] ~ W[3:end], col="black")
  points(Vsim[1:2] ~ W[1:2], col="red",pch=8,lwd=2)
  abline(alpha[1],alpha[2],lwd=2,lty=2)
  abline(h=-4.5+scale*0.5, col="blue", lwd=2)
  lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
  points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
  legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
  legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=c(8,1), bty="n")
  


  ###################################################
  ## considering lower bounds for observed groups. ##
  ###################################################

  Vupperbar = -5
  for(G in 1:2){ # groups A and B.
  
    Vhat = cbind(1,W[G])%*%alpha
  
    if (length( Vsim[(D==0) & (Vsim>Vsim[3-G])] ) != 0){ # to avoid: Empty matrix: 0-by-1.
    
      Vlowerbar = max( Vsim[ (D==0) & (Vsim>Vsim[3-G]) ] ) 
      lowercdf = pnorm(Vlowerbar,Vhat,1)
      Vsim[G] = qnorm(lowercdf + (1-lowercdf)*runif(1), Vhat, 1) # Inverse c.d.f. sampling.

    }else{ # no bounds in this case.
    
      Vlowerbar = NA
      Vsim[G] = qnorm(runif(1), Vhat, 1); # Inverse c.d.f. sampling.
    
    }

    ## PLOT 2a
    Y = paste("Simulate: V.",iter,sep="")
    b = paste("conditional on: a.",iter-1,sep="")
    plot(V ~ W, col="white", ylim=c(-4.5,4), xlim=c(0,10), axes=FALSE, ,xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(Y,b,sep=" "))
    axis(2,ylim=c(-4.5,4),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)  
    if(is.na(Vlowerbar)==FALSE){
      rect(xleft=-1,xright=11,ybottom=Vupperbar,ytop=Vlowerbar,density=10,col="grey")
    } else{
      rect(xleft=-1,xright=11,ybottom=max(Vsim[3:end]),ytop=Vsim[3-G],density=10,col="yellow")
    }
    points(Vsim[3:end] ~ W[3:end], col="black")
    points(Vsim[3-G] ~ W[3-G], col="red", pch=8, lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=c(8,1), bty="n")
  
    ## PLOT 2b
    Y = paste("Simulate: V.",iter,sep="")
    b = paste("conditional on: a.",iter-1,sep="")
    plot(V ~ W, col="white", ylim=c(-4.5,4), xlim=c(0,10), axes=FALSE, ,xlab="Characteristics (W) / Iterations"
         , ylab="Latent valuation (V)",main=paste(Y,b,sep=" "))
    axis(2,ylim=c(-4.5,4),lwd=2)
    axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
    axis(1,xlim=c(1,10),lwd=2)  
    if(is.na(Vlowerbar)==FALSE){
      rect(xleft=-1,xright=11,ybottom=Vupperbar,ytop=Vlowerbar,density=10,col="grey")
    } else{
      rect(xleft=-1,xright=11,ybottom=max(Vsim[3:end]),ytop=Vsim[3-G],density=10,col="yellow")
    }
    points(Vsim[3:end] ~ W[3:end], col="black")
    points(Vsim[3-G] ~ W[3-G], col="red", pch=8, lwd=2)
    points(Vsim[G] ~ W[G], col="red", pch=8, lwd=2)
    abline(alpha[1],alpha[2],lwd=2,lty=2)
    abline(h=-4.5+scale*0.5, col="blue", lwd=2)
    lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
    points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
    legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
    legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=c(8,1), bty="n")
      
  }


  ## PLOT 3
  Y = paste("conditional on: V.",iter,sep="")
  b = paste("Simulate: a.",iter,sep="")
  plot(V ~ W, col="white", ylim=c(-4.5,4), xlim=c(0,10), axes=FALSE, ,xlab="Characteristics (W) / Iterations"
       , ylab="Latent valuation (V)",main=paste(b,Y,sep=" "))
  axis(2,ylim=c(-4.5,4),lwd=2)
  axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
  axis(1,xlim=c(1,10),lwd=2)  
  points(Vsim[3:end] ~ W[3:end], col="black")
  points(Vsim[1:2] ~ W[1:2], col="red", pch=8, lwd=2)
  abline(alpha[1],alpha[2],lwd=2,lty=2)
  
  # lm1 = lm(I(Vsim+2.5) ~ -1 + W)
  lm1 = lm(Vsim ~ W)
  
  abline(lm1, lwd=2)
  abline(h=-4.5+scale*0.5, col="blue", lwd=2)
  lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
  points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
  legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
  legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=c(8,1), bty="n")

  
  ## PLOT 4
  Y = paste("conditional on: V.",iter,sep="")
  b = paste("Simulate: a.",iter,sep="")
  plot(V ~ W, col="white", ylim=c(-4.5,4), xlim=c(0,10), axes=FALSE, ,xlab="Characteristics (W) / Iterations"
       , ylab="Latent valuation (V)",main=paste(b,Y,sep=" "))
  axis(2,ylim=c(-4.5,4),lwd=2)
  axis(4,ylim=c(-4.5,-1.5),at=c(-4.5,-3,-1.5),labels=c(0,0.5,1),lwd=2, col="blue",xlab="alpha draw")
  axis(1,xlim=c(1,10),lwd=2)  
  points(Vsim[3:end] ~ W[3:end], col="black")
  points(Vsim[1:2] ~ W[1:2], col="red", pch=8, lwd=2)
  abline(alpha[1],alpha[2],lwd=2,lty=2)

  alpha = lm1$coef
  alphadraws[iter] = alpha[2]*scale
  
  abline(lm1, lwd=2)
  abline(h=-4.5+scale*0.5, col="blue", lwd=2)
  lines(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), lty=2, col="blue", lwd=2)
  points(-4.5+I(c(0,alphadraws[liter])) ~ I(c(0,liter)), pch="*", col="blue")
  legend("bottomright",c("true alpha", "alpha draws"), col = c("blue","blue"), lwd = 2, lty=1:2, bty="n")
  legend("topleft",c("observed","unobserved"), col = c("red","black"), pch=c(8,1), bty="n")

}

},movie.name="simmatch.gif")  # end movie recorder

