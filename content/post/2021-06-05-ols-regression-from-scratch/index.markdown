---
title: "OLS regression from scratch"
author: "Martina Sladekova"
date: '2022-06-05'
slug: ols-regression-from-scratch
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2022-06-05'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---


```r
library(ggplot2)
library(magrittr)
options(sci_pen = 666)
```


Simulate data 


```r
set.seed(050621)
data <- faux::rnorm_multi(
  n = 5,
  vars = 2,
  mu = c(10, 30), # means of the variables 
  sd = c(5, 7), # sds of the variables 
  r = c(0.5),
  varnames = c("predictor", "outcome")
)
```


```r
lm(outcome ~ predictor, data = data) %>% summary()
```

```
## 
## Call:
## lm(formula = outcome ~ predictor, data = data)
## 
## Residuals:
##       1       2       3       4       5 
## -4.9981 -5.7548 -2.6680  0.5496 12.8713 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)  
## (Intercept)  25.6173    10.4989   2.440   0.0925 .
## predictor     0.7141     0.8448   0.845   0.4600  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 8.779 on 3 degrees of freedom
## Multiple R-squared:  0.1924,	Adjusted R-squared:  -0.07682 
## F-statistic: 0.7147 on 1 and 3 DF,  p-value: 0.46
```

calculate beta for the predictor


```r
predictor_mean <- mean(data$predictor)
outcome_mean <- mean(data$outcome)

predictor_mean
```

```
## [1] 11.52668
```

```r
outcome_mean
```

```
## [1] 33.84885
```
<br>

`$$b = \frac{\sum(x - \bar{x}) \times (y - \bar{y})}{\sum(x - \bar{x})^2}$$`
<br>


```r
b1 = (
  sum((data$predictor - predictor_mean) * (data$outcome - outcome_mean))
) / (
  sum((data$predictor - predictor_mean)^2)
)
 b1
```

```
## [1] 0.7141341
```

get intercept 

`$$y = b_0 + b_1x$$`
`$$b_0 = y - b_1x$$`
<br>

`$$b_0 = \text{outcome} - 0.40 \times \text{predictor}$$`
<br>


```r
b0 = outcome_mean - (b1*predictor_mean)

b0
```

```
## [1] 25.61725
```

### standard errors

get predicted values for each data point


```r
pred = b0 + b1*data$predictor

pred
```

```
## [1] 36.85255 29.31594 32.20659 38.41601 32.45314
```

residual standard error

`$$\sigma_{est} = \sqrt{\frac{\sum(y - y')^2}{df}}$$`


```r
squared_error = (data$outcome - pred)^2
sum_squared_error = sum(squared_error)

df = length(pred) - 2 
sigma = sqrt(sum_squared_error / df)
sigma
```

```
## [1] 8.778562
```


```r
ggplot2::ggplot(data = data, aes(y = data$outcome, x = data$predictor)) + 
  geom_point(alpha = 0.2) + 
  geom_point(aes(x = data$predictor, y = pred), colour = "red", alpha = 0.2) + 
  
  stat_smooth(formula = y ~ x, method = "lm", colour = "red", se = FALSE, size = 0.5, fullrange = TRUE) +

  geom_point(aes(x = predictor_mean, y = outcome_mean), colour = "green") + 
  geom_point(aes(x = 0, y = b0), colour = "green") + 
    
  theme_light()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

```r
pred
```

```
## [1] 36.85255 29.31594 32.20659 38.41601 32.45314
```


```r
residual = (data$outcome - pred)


residual %*% t(residual)
```

```
##            [,1]       [,2]       [,3]       [,4]       [,5]
## [1,]  24.981388  28.763141  13.335008 -2.7469823 -64.332555
## [2,]  28.763141  33.117387  15.353699 -3.1628283 -74.071399
## [3,]  13.335008  15.353699   7.118197 -1.4663329 -34.340571
## [4,]  -2.746982  -3.162828  -1.466333  0.3020614   7.074082
## [5,] -64.332555 -74.071399 -34.340571  7.0740821 165.670442
```

