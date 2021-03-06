---
title: "Robust methods & stats software"
author: Martina Sladekova
date: '2021-05-24'
slug: robust-statistics-in-jasp-and-jamovi
categories: []
tags: ["coding", "robust methods", "software"]
subtitle: ''
summary: 'There are a lot of methods out there that belong under the "robust" umbrella term. So many that you could fit them into a ~800 page book on robust estimation and call it an "introduction". This post summarises their availability in  statistical packages.'
authors: []
lastmod: '2021-05-24'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
toc: true
---

**TL;DR:**

- [R.](#r) Main packages are `WRS2`, `boot`, `robust` and `robustbase`. Wide range of methods available, including hypothesis testing based on trimmed means and bootstrapping, robust standard errors, and DAS *M*-estimation.  
- [Python.](#python) Libraries `hypothesize`, `statmodels` and `scikit-learn` can perform robust hypothesis tests, bootstrapping, winsorizing, robust correlation and *M*-estimation. 
- [SPSS.](#spss) Bootstrapping for a limited range of designs. Robust standard errors and extended bootstrapping is available in the `Process` plugin. Descriptive *M*-estimation only.
- [JASP & Jamovi.](#jasp--jamovi) Robust Median Absolute Deviation (MAD) for descriptive stats, bootstrapping of marginal mean for most designs included in JAPS (excluding mixed designs). Jamovi has no functionality for robust methods. 
- [R Shiny Apps.](#r-shiny-apps) `RobStatTM` is an R package that provides an interface for range of robust methods including robust measures of location and scale, *M*-estimation with hypothesis testing, robust covariance matrices and robust principal component analysis. I also had a go at writing a small app for running linear models using *M*-estimation and results are not completely horrible.

<br>

There are *lots* of methods out there that belong under the "robust" umbrella term. So many that you could fit them into a ~800 page book on robust estimation and call it an "introduction" [^1]. This post summarises their availability in  statistical packages. It's not meant to be a comprehensive list and I'll probably expand it at some point - for now, it covers R, Python, SPSS, JASP, and Jamovi, but I'm aware that other stats software (e.g. STATA) can also run robust models.

<br>

## Coding options 

### R 

The `WRS2` package is the probably the most comprehensive package for robust methods out there. Some of the available methods include robust trimmed *t*-test and ANOVA designs (including factorial and multivariate models), robust correlation, robust mediation.  

Other packages include the `parameters` package which produces heteroscedasticity-consistent standard errors (from HC0 to HC4), `boot` package allows you to write custom bootstrapping functions, while packages `robust` and `robustbase` provide the option for robust *M*-estimation. The `robustbase` package has the advantage of having the preset `setting = "KS2014"` which produces a Design Adaptive Scale (DAS) estimate and at the moment it seems to be the most reliable option for hypothesis testing (when compared to the default *MM*-estimation of `robust`)[^2]. Both packages have the option to tune the weight functions. Finally, package `robustlmm` allows the DAS adaptation of the *M*-estimates for mixed-effects models. 

### Python

The `hypothesize` library is the Python-based alternative to `WRS2`. Methods include null hypothesis tests based on trimmed means and bootstrapping, as well as robust correlation and winsorized methods. The `statsmodels` library supports *M*-estimation for linear models with a number of preset weight functions including Huber's *t* and Tukey's biweight function. I'm probably easily impressed, but the package has really nice [documentation page](https://www.statsmodels.org/stable/index.html). A whole array of robust methods for machine learning is concentrated in the `scikit-learn` library. 

<br>

## Non-coding options

### SPSS

SPSS, to my bitter disappointment, seems to have the widest (but not nearly wide enough) selection of robust methods when it comes to software with point-and-click interface. Which really doesn't bode well, given that when students who use SPSS ask me what to do about their messy model, my answer is  `??\_(???)_/??` in 99% of the cases[^3]. SPSS can perform bootstrapping for simple one-way designs (but not for mixed- or repeated-measures). For slightly more complex models (e.g. ANCOVA), you can bootstrap the *post hoc* tests, but not the main test [^4]. You can get bootstrapped confidence intervals for moderation and mediation if you use the  `Process` plugin. `Process` also allows you to ask for robust standard errors (HC0 to HC4). You *can* get *M*-estimates for measures of location - they're hidden away under `Descriptives`, but you cannot use *M*-estimation for hypothesis testing. 

### JASP & Jamovi

Originally, this post was going to be a detailed overview of all the robust methods that can be applied in JASP and Jamovi. Their robust methods are, however, a little limited at the moment. The benefits of being open source far outweigh this though, and I wouldn't be surprised if they caught up soon. Especially JASP, which has a large team of developers who seem to be pushing updates almost daily. 

JASP can produce robust Median Absolute Deviation (MAD) under Descriptives. Marginal means can be bootstrapped for independent and for repeated-measures ANOVA, for ANCOVA, but not for mixed-designs. Estimates for linear and logistic regression can also be bootstrapped. 

Jamovi has no functionality for robust methods. It's greatest strength at the moment is the ability to [export R code for reproducibility](../reproducible-science-without-coding/), although in terms of robust methods, it seems to be lagging behind other software. 



### R Shiny Apps 

[**RobStatTM**](https://rdrr.io/cran/RobStatTM/f/inst/doc/ShinyUI.pdf) is an R package, but I'm including it in the non-coding section because it provides an interface to the code - basically you run a piece a code from R, and a point-and-click R Shiny interface opens up. The package can produce robust measures of scale and location. You can also fit linear models using *M*-estimators, compute robust covariance matrices, and run a robust principal components analysis. 

Shiny apps have recently replaced my obsession with organising every possible piece of data into spreadsheets - instead, I now organise data into apps that take me weeks to build and then never get used again. Still, it's good for learning, and for the past couple of weeks I've been trying to see how far I can get with an app that can fit robust models. It's very early days, but here's a preview: 

<img src="images/shiny_robust.gif" alt="gif showing uploading data and running an analysis in the Shiny App. Point-and-click interface allows selection of variables from boxes, including for interaction terms. Output gets automatically updated. Code syntax gets rendered at the bottom of the page." class="center">

Functionality is *very* limited at the moment, but it does the job. You can upload a .csv file and run a linear model that includes interaction terms. Two model outputs are produced - a least squares model and a robust model that uses the DAS *M*-estimation. Two main things I was going for are (1) automatic output updating - I think this is one of the best features of JASP and Jamovi as it removes the "I have no idea which piece of output this option is going to produce but I'm going to click it anyway" factor which SPSS so painfully encourages; and (2) code availability to [enable reproducibility](../reproducible-science-without-coding/), which Jamovi does really well. 

App access below (with the caveat that at the time of writing, random crashes and unpredictable behaviour are not entirely implausible):

**App access:** https://martinasladek.shinyapps.io/shiny_robust/  

**Full code:** https://github.com/martinasladek/shiny_robust 

I'm having quite a lot of fun with this app, so updates/bug fixes/additional functions are likely in the near future. 
    
<br>
<br>

[^1]:  Wilcox, R. R. (2017). *Introduction to robust estimation and hypothesis testing.* Academic press.  
[^2]:  Koller, M., & Stahel, W. A. (2011). Sharpening wald-type inference in robust regression for small samples. *Computational Statistics & Data Analysis*, 55(8), 2504-2515.
[^3]:  My answer is often actually "Talk to your supervisor" because I've been forbidden from recommending bootstrapping... `??\_(???)_/??` 

[^4]:  This was the reason I opened up R for the first time in my life during my undergrad. Needless to say, I failed quite spectacularly and didn't go anywhere near R for a few months after that. 
