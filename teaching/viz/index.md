---
title: Data Visualisation
layout: default
group: Teaching
comments: true
published: true
---

## Data Visualisation

To make full use of the development data revolution, statisticians must take advantage of technological advancement and innovative approaches to data collection, analysis and dissemination to improve the way they analyse and disseminate statistics and thereby encourage wider use of statistics. 

[PARIS21](http://www.paris21.org) is committed to help the statistical system in Ghana to improve their data dissemination practices as a means of promoting evidence-based policy-making and decisions at the country level.  In this regard, PARIS21 in collaboration with Ghana Statistics Service (GSS) endeavours to provide support to statisticians in strengthening their data dissemination and communication practices through capacity building activities such as training.

With the aim of sustaining the capacity building program for statistical systems, PARIS21 will partner with GSS in the training on data communication and visualization.  


<TABLE WIDTH="100%"> 
<TR>
<TH align="center" WIDTH="20%">Time </TH>
<TH align="left" WIDTH="40%">Session  </TH>
<TH align="center" WIDTH="20%">Resources  </TH>
<TH align="center" WIDTH="20%">Facilitator </TH>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">1</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
<TR >
<TD align="center">2</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">3</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
<TR >
<TD align="center">4</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD></TD>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">5</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
<TR >
<TD align="center">6</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">7</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
<TR >
<TD align="center">8</TD>
<TD >--</TD>
<TD align="center">--</TD>
<TD align="center">--</TD>
</TR>
</TABLE>




#### Software

##### R 

* Download and install R from [http://www.r-project.org](http://www.r-project.org):
     + Under `Download` on left side, click: `CRAN`
     + Choose a local mirror in the UK, e.g., London or Bristol.
     + Choose platform, e.g. Windows, Linux or OSX (MAC)
     + Under Windows, select `base` (Binaries for base distribution (managed by Duncan Murdoch))
     + Click `Download R 3.2.3 for Windows` (62 megabytes) to save and run Setup program: R-3.2.3-win62.exe
* Documentation for R is provided via the build in `help` or `??` (use, for example, `help("plot")` or `??plot` in the console) but also through the [R manual Homepage from the ETH Zurich](https://stat.ethz.ch/R-manual/R-devel/doc/html/packages.html). Useful tools from the CRAN project are [An Introduction to R](https://cran.r-project.org/doc/manuals/R-intro.pdf) and the [R Reference Card](https://cran.r-project.org/doc/contrib/Short-refcard.pdf). Other manuals are available on the website.
* If you are new to R, I recommend working through W.J. Owen's [R tutorial](https://cran.r-project.org/doc/contrib/Owen-TheRGuide.pdf). It is easy to read and tries to explain R with the help of examples from basic statistics.
* The R Commander allows an easy start with R using mouse and menu. Install the commander by typing `install.packages("Rcmdr")` and load it in the active workspace `library(Rcmdr)`. You can run the Commander by typing `Commander() in the console.


##### RStudio

Many of the packages require that you have Rtools installed in addition to base R. I also recommend using RStudio as a front end.

* Download and install RStudio from [https://www.rstudio.com](https://www.rstudio.com):
    + In the homepage, click : `Download RStudio
    + Under `RStudio Desktop`, choose the "Open Source Edition" and click `Download RStudio Desktop` for free
    + Under "Installers for Supported Platforms",choose the first one, `Windows Vista/7/8/10`
    + Open the document in your download file and follow the instruction for installation.    
    
    
**To update your version of RStudio**:

*1. Via the web*  
The newest stable versions of RStudio Desktop and Server can be found here: 
[RStudio](http://www.rstudio.com/products/rstudio/)
 
*2. Via RStudio*    
- You can check for new versions of RStudio using RStudio itself; go to the `Help` menu and click `Check for Updates`.    
- This is the most conservative method to look for updates; new versions are posted to the web site frequently, but RStudio support team does not advertise them to existing installations as often.


##### R Packages

To get the latest stable version of a package from CRAN:

```install.packages("namepackage")```

```library(namepackage)```


To get the most recent development version of a package from GitHub:

```install.packages("devtools")```

```devtools::install_github("author/namepackage")```

```library(namepackage)```



