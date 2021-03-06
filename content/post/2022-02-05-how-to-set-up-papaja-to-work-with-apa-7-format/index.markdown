---
title: How to set up {papaja} to work with the APA 7 format
author: Martina Sladekova
date: '2022-02-05'
slug: how-to-set-up-papaja-to-work-with-apa-7-format
categories: []
tags: ["reproducibility", "LaTeX"]
subtitle: ''
summary: ''
authors: []
lastmod: '2022-02-05T14:23:21Z'
featured: no
toc: true
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

<img src="images/great_plan.jpg" alt="Gru's evil plan meme. Panel 1: Get up early to work on a manuscript; Panel 2: All the figures and inline code are already prepared so I can focus on writing; Panel 3: !LaTeX Error: File `apa7.cls` not found. Panel 4: !LaTeX Error: File `apa7.cls` not found.">

I've recently updated R to version 4.1 for a side project that required it. Postponing updates until the situation demands it is absolutely not a good approach to life, but I'd be lying if I said that I've learned my lesson and will be altering my behaviour in any way whatsoever. Long story short, my side project with 4.1 went swimmingly, while the set up for the rest of my projects broke. This included the set up I had for the package `papaja`, which I use for writing manuscripts (and my PhD thesis. So really, not a big deal).   

This post is mostly a reminder for myself on how to fix things when I inevitably break them again. Instead of writing, I spent a full day tracking down bits of instructions as they weren't always written in a way that my brain could effortlessly understand. So, if you're also running into brick walls when trying to get `papaja` to produce an APA 7 manuscript, you may find this useful.  


## 1. Install the development version of `papaja`

`papaja` is currently not on CRAN. [The stable version can be grabbed from GitHub](https://github.com/crsh/papaja) and works great for APA 6 formatting, but we need the **development version** if we want to use APA 7. In R, you can install it using: 


```r
remotes::install_github("crsh/papaja@devel")
```
  
  
## 2. Edit the YAML header 

Open up a new .Rmd file using the papaja template. We need to make sure that the **YAML header** includes the following: 

```
header-includes:
  - |
    \makeatletter
    \renewcommand{\paragraph}{\@startsection{paragraph}{4}{\parindent}%
      {0\baselineskip \@plus 0.2ex \@minus 0.2ex}%
      {-1em}%
      {\normalfont\normalsize\bfseries\typesectitle}}
    
    \renewcommand{\subparagraph}[1]{\@startsection{subparagraph}{5}{1em}%
      {0\baselineskip \@plus 0.2ex \@minus 0.2ex}%
      {-\z@\relax}%
      {\normalfont\normalsize\bfseries\itshape\hspace{\parindent}{#1}\textit{\addperi}}{\relax}}
    \makeatother

csl               : "`r system.file('rmd', 'apa7.csl', package = 'papaja')`"
documentclass     : "apa7"
output            : papaja::apa6_pdf
```

Most R users will probably use the **tinytex** LaTeX distribution. [The instructions on the APA 7 development page for papaja](https://github.com/crsh/papaja/issues/342) say that tinytex users shouldn't need to complete any further steps. So it's possible that you'll be able to knit at this stage. Or you'll get an error along the lines of:

```
!LaTeX Error: File `apa7.cls` not found.
```

If that's the case, you'll need to either install tinytex, or make changes to your existing installation. 


## 3. Install tinytex

Installing tinytex involves 2 steps: 

1. Installing the r package `tinytex` and 
1. Installing the tinytex LaTeX distribution 

Run the following code to check if the R package is installed - if it's not, the code will install it: 


```r
if("tinytex" %in% rownames(installed.packages()) == FALSE) {
  install.packages("tinytex")
}
```

Now use the R package to check if the LaTeX distribution is installed: 


```r
tinytex::is_tinytex()
```

If the code returns TRUE, you can move on to the next step. If it's FALSE, use the package to install it: 


```r
tinytex::install_tinytex()
```

Depending on what kind of user set up you have on your computer, and when you're doing this, this might get tinytex installed without issues. I don't use my computer as an admin, so I got prompted to enter the admin user name and password. This is because R was trying to install tinytex into a directory that is not writeable by non-admins (for context, I'm on a Mac with Mojave OS, and yes, I know. *I know*. I should update it. Point being, it seems like whether or not the tinytex installation goes into a writeable directory depends on the operating system). 

If you get prompted for a password, enter it. R will then try to download tinytex from server. At this point, I hit another hurdle with this error: 

```
trying URL 'https://yihui.org/tinytex/TinyTeX-1.tgz'
trying URL 'https://yihui.org/tinytex/TinyTeX-1.tgz'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
curl: (60) SSL certificate problem: certificate has expired
More details here: https://curl.haxx.se/docs/sslcerts.html

curl performs SSL certificate verification by default, using a "bundle"
 of Certificate Authority (CA) public keys (CA certs). If the default
 bundle file isn't adequate, you can specify an alternate file
 using the --cacert option.
If this HTTPS server uses a certificate signed by a CA represented in
 the bundle, the certificate verification probably failed due to a
 problem with the certificate (it might be expired, or the name might
 not match the domain name in the URL).
If you'd like to turn off curl's verification of the certificate, use
 the -k (or --insecure) option.
HTTPS-proxy has similar options --proxy-cacert and --proxy-insecure.
Error in xfun::download_file(..., quiet = Sys.getenv("APPVEYOR") != "") : 
  No download method works (auto/wininet/wget/curl/lynx)
```

Based on this, it seems like the SSL certificate of the default server has expired. We can get around this by specifying an alternative repository from which to download tinytex: 


```r
tinytex::install_tinytex(repository = "http://mirrors.tuna.tsinghua.edu.cn/CTAN/", version = "latest")
```

Restart R and check again if tinytex is installed:


```r
tinytex::is_tinytex()
```

Ideally, this will return TRUE now. Try knitting again. Some versions of tinytex have the APA 7 class installed by default, in which case the document should knit. In my case, I had to complete another step, which is to manually install the APA 7 class. 


## 4. Install the APA 7 LaTeX class

The original LaTeX error was complaining about not being able to locate the **apa7.cls** file. We need to download it, and then place it somewhere where R can locate it. 

The APA 7 class can be downloaded from CTAN: https://ctan.org/pkg/apa7 . This will download as a zip file. After unzipping, the folder should contain a file called **apa7.ins**. This is an installation file that can be used to produce the **apa7.cls** file that we're after. It's effectively a LaTeX script, so we need to open this and run it as a code. By default, the file opens in TeXShop for me, which is fine. You can also open this in RStudio. When you compile the document, additional files will be generated into the original folder where we found the apa7.ins file. There will be a **apa7.cls** file, but also **apa7.csl** file. We want the former, "cls" standing for "class". The **.csl** file is already installed as part of the development version of `papaja`, so we don't need it to get things working. 

Finally, we need to copy this file into an appropriate folder of the tinytex installation. I followed this [tutorial on installing custom LaTeX classes:](https://weibeld.net/latex/installing-packages.html), specifically steps 4 and 5. The tutorial refers to TexLive, which in our case is TinyTex. The location on my computer was: 

```
/Users/martina/Library/TinyTex/texmf-local/tex/latex/base
```

I had to create the `base` folder myself. Copy the **apa7.cls** class into the base folder and restart R. Try knitting - `papaja` should now be able to locate the APA 7 LaTeX class and compile a PDF. 



## Keep an eye on the developments 

Massive thanks to [Frederik Aust (crsh)](https://github.com/crsh), who created `papaja` and has done some great work so far on updating the package to incorporate APA 7 formatting out of the box (or out of the GitHub repo, I suppose). They were also very efficient in releasing an emergency workaround fix for the users shortly after APA 7 came out, which meant that I was able to quickly reformat my then APA 6 [masters thesis](/project_info/proj_pb) into the new format and submit to a journal. 

The development of `papaja` can be tracked here: https://github.com/crsh/papaja/issues/342 .  

