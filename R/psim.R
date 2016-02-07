## ---------------------------------------------------------------------
## --- POWER SIMULATIONS FOR SELECTIVE TRIALS: -------------------------

power.SEL = function(type){ 

  # --------------------------------------------------------------------
  # R-code (www.r-project.org) for power calculations
  # of IV estimates from selective trials
  
  # The argument of the function is:
  # type  = one of:
  
  # "SEL.HOM"    : homogenous treatment effects
  # "SEL.HOM.np" : homogenous treatment effects; no price effects
  # "SEL.HET"    : heterogeneous treatment effects
  # "SEL.HET.np" : heterogeneous treatment effects; no price effects
  
  # Example: 
  # > install.packages("AER")
  # > library(AER)
  # > source("http://thiloklein.de/R/psim.R")
  # > power.SEL(type="SEL.HOM")
  # --------------------------------------------------------------------  
  
  ## load library for IV estimation
   library(AER)
  ## Set values of sample size
   n <<- c(200, 400, 600, 800, 1000, 1200, 1800, 2400)
   type <<- type

  ## Run simulations
   print("Simulating power...")
   
   data = sapply(1:1000, function(x){      

  ## Progress report
   if(x%in%seq(0,1000,100)) print(paste(x,"of 1000 draws"))
          
   sapply(n, function(N){     
    ## variable generation
     wtp  <- runif(N, min=10, max=40)  # willingness to pay
     pBDM <- runif(N, min=10, max=40)  # BDM random price draw
     t    <- ifelse(wtp>pBDM, 1, 0)  # endogenous treatment indicator
     d    <- sample(c(0,10),N,replace=TRUE)  # random discount
     tkup <- 0.85  # take-up rate
     het  <- ifelse(wtp>median(wtp), 37.5, 12.5)*tkup  # heterogenous treatment effects
     e    <- rnorm(N, mean=0, sd=40)  # noise
     if(type=="SEL.HOM" | type=="SEL.HET"){
       y  <- ifelse(t==1, het + e + wtp + d, e + wtp)  # outcome
     } else if(type=="SEL.HOM.np" | type=="SEL.HET.np"){
       y  <- ifelse(t==1, het + e + wtp, e + wtp)  # outcome
     } else {stop("type must be one of SEL.HOM, SEL.HOM.np, SEL.HET, SEL.HET.np")}
     data <- data.frame(pBDM=pBDM, wtp=wtp, y=y, t=t, d=d)

    ## IV estimation 
     if(type=="SEL.HOM"){
       summary(ivreg(y ~ t + t:d | pBDM + d, data=data))$coef[2,4] < 0.1
     } else if(type=="SEL.HOM.np"){
       summary(ivreg(y ~ t | pBDM, data=data))$coef[2,4] < 0.1
     } else if(type=="SEL.HET"){
       summary(ivreg(y ~ t*hwtp + t:d*hwtp | pBDM*hwtp + d*hwtp, data=data))$coef[4,4] < 0.1
     } else if(type=="SEL.HET.np"){
       summary(ivreg(y ~ t*hwtp | pBDM*hwtp, data=data))$coef[4,4] < 0.1
     } else{
       stop("type must be one of SEL.HOM, SEL.HOM.np, SEL.HET, SEL.HET.np")
     }
  })
  })

  ## calculate percentage of rejections when null is not true
   rejections = sapply(1:length(n), function(x) sum(data[x,])/1000)
   names(rejections) = n
   return(list(power=rejections))
}


## ---------------------------------------------------------------------
