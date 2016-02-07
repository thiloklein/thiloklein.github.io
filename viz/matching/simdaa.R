# deferred acceptance algorithm after Gale and Shapley

# Deferred Acceptance Algorithm with male offer
# accepts your preferences or chooses randomly

daa <- function(nMen,nWomen,m.prefs=NULL,w.prefs=NULL){
	require(animation)	# load animation package

	if (is.null(m.prefs)){	# if no prefs given, make them randomly
		m.prefs <- replicate(n=nMen,sample(seq(from=1,to=nWomen,by=1)))
		w.prefs <- replicate(n=nWomen,sample(seq(from=1,to=nMen,by=1)))
	}
	m.hist    <- rep(0,length=nMen)	# number of proposals made
	w.hist    <- rep(0,length=nWomen)	# current mate
	m.singles <- 1:nMen
	w.singles <- 1:nWomen
	m.mat <- matrix(data=1:nMen,nrow=nMen,ncol=nWomen,byrow=F)
	saveGIF({	# this line and next are for recording the movie
		ani.options(interval=0.5,nmax=nWomen,ani.width=2000,ani.height=2000,dev=png,type="png","convert",outdir=getwd())
		for (iter in 1:nWomen){		# there are as many rounds as maximal preference orders
			# look at market: all single men
			# if history not full (been rejected by all women in his prefs)
			# look at single male's history
			# propose to next woman on list
			offers <- NULL
			for (i in 1:length(m.singles)){
				m.hist[m.singles[i]] <- m.hist[m.singles[i]]+1	# make next proposal according to single i's count
				offers[i] <- m.prefs[m.hist[m.singles[i]],m.singles[i]]		# offer if single i is the index of the woman corresponding to current round
			}
			approached   <- unique(offers)	# index of women who received offers
			temp.singles <- m.singles
			m.singles    <- NULL	# reset singles
			for (j in approached){
				proposers   <- temp.singles[offers==j]
				stay.single <- temp.singles[offers==0]		# guys who prefer staying single at current history
				for (k in 1:length(proposers)){
					if (w.hist[j]==0&any(w.prefs[ ,j]==proposers[k])){	# if no history and proposer 
						w.hist[j] <- proposers[k]						# is somewhere on preference list, accept

					} else if (match(w.prefs[w.prefs[ ,j]==proposers[k],j],w.prefs[ ,j])<match(w.prefs[w.prefs[ ,j]==w.hist[j],j],w.prefs[ ,j])){
								m.singles <- c(m.singles,w.hist[j])		# if proposer better, fire current guy
								w.hist[j] <- proposers[k]	# and take proposer on
							} else {
								m.singles <- c(m.singles,proposers[k])	# otherwise k stays single
							}
				}	
			}
			m.singles <- sort(c(m.singles,stay.single))
			if (length(m.singles)==0){	# if no singles left: stop
				return(list(m.prefs=m.prefs,w.prefs=w.prefs,iterations=iter,matches=w.hist,singles=m.singles))
				break
			}
		current.match   <- (matrix(rep(w.hist,each=nMen),nrow=nMen,ncol=nWomen)==m.mat)
		current.singles <- matrix(m.mat %in% m.singles,nrow=nMen)*2
		image(y=1:nWomen,x=1:nMen,z=current.match+current.singles,ylab="colleges",xlab="students",col=c("white","black","blue"),
			  sub=paste("Iterations to go: ",nWomen-iter,". currently ",length(m.singles)," students unmatched", sep=""))
		title("Current matches (black) and unmatched students (blue)",line=3)
		title(paste(nMen," students and ",nWomen," colleges",sep=""),line=2)
		grid(nx=nMen,ny=nWomen,col="black",lty=1)
		}
	},movie.name="simdaa.gif")	# end movie recorder
	return(list(m.prefs=m.prefs,w.prefs=w.prefs,iterations=iter,matches=w.hist,match.mat=current.match,singles=m.singles))
}

daa(nMen=20,nWomen=20)
