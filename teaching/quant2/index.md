---
title: Quant. Methods II
layout: default
group: Teaching
comments: true
published: true
---




## Quantitative Methods II

This advanced course in econometrics is designed for the Cambridge [MPhil in Finance](http://www.jbs.cam.ac.uk/programmes/research-programmes/research-masters/mphil-finance/) and the [MPhil in Management Science & Operations](https://www.jbs.cam.ac.uk/programmes/research-programmes/research-masters/mres/). The course gives an overview of the following concepts. 

***

#### Course material

<TABLE WIDTH="100%"> 
<TR>
<TH align="center" WIDTH="10%"> Week </TH>
<TH align="left" WIDTH="40%">Lectures  </TH>
<TH align="center" WIDTH="10%">Exercises </TH>
<TH align="left" WIDTH="40%">Lab sessions </TH>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">1</TD>
<TD >Distributed lag model [Slides, <a href="docs/Lec1.html">R-script</a>]</TD>
<TD align="center"><a href="docs/Quiz1Qs.pdf">Sheet 1</a></TD>
<TD >--</TD>
</TR>
<TR >
<TD align="center">2</TD>
<TD >Stationarity testing [Slides, <a href="docs/Lec2.html">R-Script</a>]</TD>
<TD align="center"><a href="docs/Quiz2Qs.pdf">Sheet 2</a></TD>
<TD >Unit Root Test and ADL Models [<a href="docs/MPhilLabSessionLent1.pdf">Handout</a>, <a href="docs/LabSessionLent1.html">R-Script</a>]</TD>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">3</TD>
<TD >Introduction to time series: ARIMA models [Slides, R-Script]</TD>
<TD align="center"><a href="docs/Quiz3Qs.pdf">Sheet 3</a></TD>
<TD >--</TD>
</TR>
<TR >
<TD align="center">4</TD>
<TD >ARCH and GARCH models [Slides, <a href="docs/Lec4.html">R-script</a>]</TD>
<TD align="center"><a href="docs/Quiz4Qs.pdf">Sheet 4</a></TD>
<TD >ARIMA, ARCH and GARCH Models [<a href="docs/MPhilLabSessionLent2.pdf">Handout</a>, <a href="docs/LabSessionLent2.html">R-Script</a>]</TD>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">5</TD>
<TD >Endogeneity and IV [Slides, <a href="docs/Lec5.html">R-Script</a>]</TD>
<TD align="center"><a href="docs/Quiz5Qs.pdf">Sheet 5</a></TD>
<TD >--</TD>
</TR>
<TR >
<TD align="center">6</TD>
<TD >SEM [Slides, <a href="docs/Lec6.html">R-Script</a>]</TD>
<TD align="center"><a href="docs/Quiz6Qs.pdf">Sheet 6</a></TD>
<TD >Endogeneity, IV and SEM [<a href="docs/MPhilLabSessionLent3.pdf">Handout</a>, <a href="docs/LabSessionLent3.html">R-Script</a>]</TD>
</TR>
<TR bgcolor="#f0f0f0">
<TD align="center">7</TD>
<TD >Limited dependent variables [Slides, <a href="docs/Lec7_logit.html">R-Script</a>, <a href="docs/Lec7_tobitSimulation.html">Simulation</a>]</TD>
<TD align="center"><a href="docs/Quiz7Qs.pdf">Sheet 7</a></TD>
<TD >--</TD>
</TR>
<TR >
<TD align="center">8</TD>
<TD >Panel data [Slides, <a href="docs/Lec8.html">R-Script</a>]</TD>
<TD align="center">--</TD>
<TD >Limited Dependent Variables and Panel Data [<a href="docs/MPhilLabSessionLent4.pdf">Handout</a>, <a href="docs/LabSessionLent4.html">R-Script</a>]</TD>
</TR>
</TABLE>

***

#### Lectures

> 23, 30 Jan, 6, 13, 20, 27 Feb, 5, 15 Mar, all 2-4pm @ Keynes House 107

#### Lab sessions

> 2, 16 Feb, 2-4pm | 2 Mar, 1-3pm | 16 Mar, 2-4pm, all @ Judge Business School Computer Lab

***

####  Reading
- Dougherty, C. (2007) Introduction to econometrics. Judge: HB139.D68 2007
- Tsay, R. S. (2005) Analysis of Financial Time Series. Judge: HA30.3.T72 2005
- Brooks, C. (2008) Introductory econometrics for finance. Judge: HG173.B76 2008
- Wooldridge, J. M. (2009) Introductory econometrics: a modern approach. Judge: HB139.W66 2009
- Greene, W. H. (2008) Econometric analysis. Judge: HB131.G73 2008

***

#### Software

For the lab sessions we will use the software environment R. We will need the rgarch package to fit various advanced GARCH models. The package is available on the R-forge repository.

If you have at least R versions 2.13 or 2.12 you should be able to install the package using: `install.packages("rgarch")` with option `repos="http://r-forge.r-project.org"`.

If you are working in the Judge computer lab, follow three simple steps:

- Right-click on the following link rgarch+dependencies.zip and save the zip file on your machine.
- Extract the zip-file and save the 9 unzipped packages in your R library-folder 'C:\Program Files\R\library'.
- In the R console, type: `library(rgarch)`

***

##### Documentation

Good references for the methods covered in this advanced course are Grant Farnsworth's [Econometrics in R](http://cran.r-project.org/doc/contrib/Farnsworth-EconometricsInR.pdf) and the UCLA [Resources to help you learn and use R](http://www.ats.ucla.edu/stat/R/). 

***

You can help us improve this site. If you spot errors, typos, and inconsistencies in the course resources (website, slides, handouts, exercise sheets) or want to share ideas and interesting resources, please send us an email.
