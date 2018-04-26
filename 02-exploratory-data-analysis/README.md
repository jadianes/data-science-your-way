# Exploratory Data Analysis  

Here we are again, with a new episode in our series about doing data science with the two most popular open-source platforms you can use for the job nowadays. In this case we will have a look at a crucial step of the data analytics process, that of the [*Exploratory Data Analysis*](https://en.wikipedia.org/wiki/Exploratory_data_analysis). And with that idea in mind we will explain how to use descriptive statistics and basic plotting, together with data frames, in order to answer some questions and guide our further data analysis.  

*Note: The notebooks for this tutorial are part of those for the data frames ones.*  

### Getting data  

We will continue using the same datasets we already loaded in the part introducing data frames. So you can either continue where you left in that tutorial, or re-run the [section that gets and prepares the data](https://www.codementor.io/python/tutorial/python-vs-r-for-data-science-data-frames-i).  

## Questions we want to answer  

In any data analysis process, there is one or more questions we want to answer. That is the most basic and important step in the whole process, to define these questions. Since we are going to perform some Exploratory Data Analysis in our TB dataset, these are the questions we want to answer:  

- Which are the countries with the highest and infectious TB incidence?  
- What is the general world tendency in the period from 1990 to 2007?  
- What countries don't follow that tendency?  
- What other facts about the disease do we know that we can check with our data?  


## Descriptive Statistics  

### Python  

The basic data descriptive statistics method for a `pandas.DataFrame` is `describe()`. It is the equivalent to R `data.frame` function `summary()`.  

```python
df_summary = existing_df.describe()
df_summary
```

| country | Afghanistan | Albania   | Algeria   | American Samoa | Andorra   | Angola     | Anguilla  | Antigua and Barbuda | Argentina | Armenia   | ... | Uruguay   | Uzbekistan | Vanuatu    | Venezuela | Viet Nam   | Wallis et Futuna | West Bank and Gaza | Yemen      | Zambia     | Zimbabwe   |
|---------|-------------|-----------|-----------|----------------|-----------|------------|-----------|---------------------|-----------|-----------|-----|-----------|------------|------------|-----------|------------|------------------|--------------------|------------|------------|------------|
| count   | 18.000000   | 18.000000 | 18.000000 | 18.000000      | 18.000000 | 18.000000  | 18.000000 | 18.000000           | 18.000000 | 18.000000 | ... | 18.000000 | 18.000000  | 18.000000  | 18.000000 | 18.000000  | 18.000000        | 18.000000          | 18.000000  | 18.000000  | 18.000000  |
| mean    | 353.333333  | 36.944444 | 47.388889 | 12.277778      | 25.277778 | 413.444444 | 35.611111 | 10.833333           | 61.222222 | 74.944444 | ... | 28.055556 | 128.888889 | 186.000000 | 40.888889 | 282.666667 | 126.222222       | 43.388889          | 194.333333 | 535.277778 | 512.833333 |
| std     | 64.708396   | 6.915220  | 4.487091  | 9.886447       | 7.274497  | 97.751318  | 1.243283  | 2.812786            | 20.232634 | 16.129885 | ... | 3.717561  | 15.911109  | 62.027508  | 2.422660  | 57.322616  | 86.784083        | 8.332353           | 52.158131  | 91.975576  | 113.411925 |
| min     | 238.000000  | 22.000000 | 42.000000 | 0.000000       | 17.000000 | 281.000000 | 34.000000 | 7.000000            | 35.000000 | 49.000000 | ... | 23.000000 | 102.000000 | 102.000000 | 38.000000 | 220.000000 | 13.000000        | 31.000000          | 130.000000 | 387.000000 | 392.000000 |
| 25%     | 305.000000  | 32.000000 | 44.000000 | 6.000000       | 19.250000 | 321.250000 | 35.000000 | 9.000000            | 41.250000 | 62.000000 | ... | 25.000000 | 116.500000 | 128.750000 | 39.000000 | 234.250000 | 63.250000        | 36.250000          | 146.750000 | 459.000000 | 420.750000 |
| 50%     | 373.500000  | 40.500000 | 45.500000 | 9.000000       | 22.500000 | 399.000000 | 35.000000 | 10.000000           | 60.500000 | 77.000000 | ... | 27.500000 | 131.500000 | 185.000000 | 41.000000 | 257.000000 | 106.000000       | 43.000000          | 184.500000 | 521.500000 | 466.000000 |
| 75%     | 404.500000  | 42.000000 | 50.750000 | 16.250000      | 31.500000 | 512.000000 | 36.000000 | 12.750000           | 77.000000 | 85.750000 | ... | 30.750000 | 143.000000 | 240.000000 | 42.000000 | 349.000000 | 165.750000       | 51.500000          | 248.500000 | 620.000000 | 616.750000 |
| max     | 436.000000  | 44.000000 | 56.000000 | 42.000000      | 39.000000 | 530.000000 | 38.000000 | 16.000000           | 96.000000 | 99.000000 | ... | 35.000000 | 152.000000 | 278.000000 | 46.000000 | 365.000000 | 352.000000       | 55.000000          | 265.000000 | 680.000000 | 714.000000 |  

###### 8 rows × 207 columns  

There is a lot of information there. We can access individual summaries as follows.

```python
df_summary[['Spain','United Kingdom']]
```

| country | Spain     | United Kingdom |
|---------|-----------|----------------|
| count   | 18.000000 | 18.000000      |
| mean    | 30.666667 | 9.611111       |
| std     | 6.677442  | 0.916444       |
| min     | 23.000000 | 9.000000       |
| 25%     | 25.250000 | 9.000000       |
| 50%     | 29.000000 | 9.000000       |
| 75%     | 34.750000 | 10.000000      |
| max     | 44.000000 | 12.000000      |  

There is a plethora of descriptive statistics methods in Pandas (check the [documentation](http://pandas.pydata.org/pandas-docs/stable/api.html#api-dataframe-stats)). Some of them are already included in our summary object, but there are many more. In following tutorials we will make good use of them in order to better understand our data.  

For example, we can obtain the percentage change over the years for the number of tuberculosis cases in Spain.

```python
tb_pct_change_spain = existing_df.Spain.pct_change()
tb_pct_change_spain
```
```python
    year
    1990         NaN
    1991   -0.045455
    1992   -0.047619
    1993   -0.075000
    1994   -0.054054
    1995   -0.028571
    1996   -0.029412
    1997   -0.090909
    1998    0.000000
    1999   -0.066667
    2000   -0.035714
    2001   -0.037037
    2002    0.000000
    2003   -0.038462
    2004   -0.040000
    2005    0.000000
    2006    0.000000
    2007   -0.041667
    Name: Spain, dtype: float64
```

And from there get the maximum value.

```python
tb_pct_change_spain.max()
```
```python
    0.0
```

And do the same for the United Kingdom.

```python
existing_df['United Kingdom'].pct_change().max()
```
```python
    0.11111111111111116
```

If we want to know the index value (year) we use `argmax` (callex `idmax` in later versions of Pandas) as follows.

```python
existing_df['Spain'].pct_change().argmax()
```
```python
    '1998'
```
```python
existing_df['United Kingdom'].pct_change().argmax()
```
```python
    '1992'
```

That is, 1998 and 1992 were the worst years in Spain and the UK respectibely regarding the increase of infectious TB cases.  

### R  

The basic descriptive statistics method in R is, as we said, the function `summary()`.  


```r
existing_summary <- summary(existing_df)
str(existing_summary)
```

```
##  'table' chr [1:6, 1:207] "Min.   :238.0  " "1st Qu.:305.0  " ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : chr [1:6] "" "" "" "" ...
##   ..$ : chr [1:207] " Afghanistan" "   Albania" "   Algeria" "American Samoa" ...
```

It returns a table object where we have summary statistics for each of the columns in a data frame. A table object is good for visualising data, but not so good for accessing and indexing it as a data frame. Basically we access it as a matrix, using positional indexing. If we want the first column, that corresponding to Afghanistan, we do.      


```r
existing_summary[,1]
```

```
##                                                                         
## "Min.   :238.0  " "1st Qu.:305.0  " "Median :373.5  " "Mean   :353.3  " 
##                                     
## "3rd Qu.:404.5  " "Max.   :436.0  "
```

A trick we can use to access by column name is use the column names in the original data frame together with `which()`. We also can build a new data frame with the results.    


```r
data.frame(
    Spain=existing_summary[,which(colnames(existing_df)=='Spain')],
    UK=existing_summary[,which(colnames(existing_df)=='United Kingdom')])
```

```
##             Spain               UK
## 1 Min.   :23.00   Min.   : 9.000  
## 2 1st Qu.:25.25   1st Qu.: 9.000  
## 3 Median :29.00   Median : 9.000  
## 4 Mean   :30.67   Mean   : 9.611  
## 5 3rd Qu.:34.75   3rd Qu.:10.000  
## 6 Max.   :44.00   Max.   :12.000
```

Being R a functional language, we can apply functions such as `sum`, `mean`, `sd`, etc. to vectors. Remember that a data frame is a list of vectors (i.e. each column is a vector of values), so we can easily use these functions with columns. We can finally combine these functions with `lapply` or `sapply` and apply them to multiple columns in a data frame.  

However, there is a family of functions in R that can be applied to columns or rows in order to get means and sums directly. These are more efficient than using apply functions, and also allows us to apply them not just by columns but also by row. If you type `?colSums' for example, the help page describes all of them.  

Let's say we wan to obtain the average number of existing cases per year. We need a single function call.  


```r
rowMeans(existing_df)
```

```
##    X1990    X1991    X1992    X1993    X1994    X1995    X1996    X1997 
## 196.9662 196.4686 192.8116 191.1739 188.7246 187.9420 178.8986 180.9758 
##    X1998    X1999    X2000    X2001    X2002    X2003    X2004    X2005 
## 178.1208 180.4734 177.5217 177.7971 179.5169 176.4058 173.9227 171.1836 
##    X2006    X2007 
## 169.0193 167.2560
```

## Plotting  

In this section we will take a look at the basic plotting functionality in Python/Pandas and R. However, there are more powerful alternatives like [**ggplot2**](http://ggplot2.org/) that, although originally created for R, has its own [implementation for Python](http://ggplot.yhathq.com/) from the [Yhat](https://yhathq.com/) guys.  

### Python  

Pandas DataFrames implement up to three plotting methods out of the box (check the [documentation](http://pandas.pydata.org/pandas-docs/stable/api.html#id11)). The first one is a basic line plot for each of the series we include in the indexing.  The first line might be needed when plotting while using IPython notebook.    

```python
%matplotlib inline

 existing_df[['United Kingdom', 'Spain', 'Colombia']].plot()
```

![enter image description here](https://www.filepicker.io/api/file/1d39RktiTBKjxFinIjbc "enter image title here")

Or we can use box plots to obtain a summarised view of a given series as follows.

```python
 existing_df[['United Kingdom', 'Spain', 'Colombia']].boxplot()
```
![enter image description here](https://www.filepicker.io/api/file/sT3RjWQQtS9DuSgcNOSi "enter image title here")

There is also a `histogram()` method, but we can't use it with this type of data right now. 

### R  

Base plotting in R is not very sophisticated when compared with [ggplot2](http://ggplot2.org/), but still is powerful and handy because many data types have implemented custom `plot()` methods that allow us to plot them with a single method call. However this is not always the case, and more often than not we will need to pass the right set of elements to our basic plotting functions.  

Let's start with a basic line chart like we did with Python/Pandas.  


```r
uk_series <- existing_df[,c("United Kingdom")]
spain_series <- existing_df[,c("Spain")]
colombia_series <- existing_df[,c("Colombia")]
```


```r
xrange <- 1990:2007
plot(xrange, uk_series, 
     type='l', xlab="Year", 
     ylab="Existing cases per 100K", 
     col = "blue", 
     ylim=c(0,100))
lines(xrange, spain_series, 
      col = "darkgreen")
lines(xrange, colombia_series,
      col = "red")
legend(x=2003, y=100, 
       lty=1, 
       col=c("blue","darkgreen","red"), 
       legend=c("UK","Spain","Colombia"))
```

![enter image description here](https://www.filepicker.io/api/file/lzenqp1Q2xiQgC3nvUuw "enter image title here")

You can compare how easy was to plot three series in Pandas, and how doing the
same thing **with basic plotting** in R gets more verbose. At least we need
three function calls, those for plot and line, and then we have the legend, etc. The base plotting in R is really intended to make quick and dirty charts.  

Let's use now box plots.  


```r
boxplot(uk_series, spain_series, colombia_series, 
        names=c("UK","Spain","Colombia"),
        xlab="Year", 
        ylab="Existing cases per 100K")
```

![enter image description here](https://www.filepicker.io/api/file/Epk8593ZRRGlq0mMCB5o "enter image title here")

This one was way shorter, and we don't even need colours or a legend.

## Answering Questions  

Let's now start with the real fun. Once we know our tools (from the previous tutorial about data frames and this one), let's use them to answer some questions about the incidence and prevalence of infectious tuberculosis in the world.   

**Question**: *We want to know, per year, what country has the highest number of existing and new TB cases.*

### Python  

If we want just the top ones we can make use of `apply` and `argmax`. Remember that, by default, `apply` works with columns (the countries in our case), and we want to apply it to each year. Therefore we need to transpose the data frame before using it, or we can pass the argument `axis=1`.

```python
 existing_df.apply(pd.Series.argmax, axis=1)
```

```python
    year
    1990            Djibouti
    1991            Djibouti
    1992            Djibouti
    1993            Djibouti
    1994            Djibouti
    1995            Djibouti
    1996            Kiribati
    1997            Kiribati
    1998            Cambodia
    1999    Korea, Dem. Rep.
    2000            Djibouti
    2001           Swaziland
    2002            Djibouti
    2003            Djibouti
    2004            Djibouti
    2005            Djibouti
    2006            Djibouti
    2007            Djibouti
    dtype: object
```

But this is too simplistic. Instead, we want to get those countries that are in the fourth quartile. But first we need to find out the world general tendency.

###### World trends in TB cases  


In order to explore the world general tendency, we need to sum up every countries' values for the three datasets, per year.

```python
deaths_total_per_year_df = deaths_df.sum(axis=1)
existing_total_per_year_df = existing_df.sum(axis=1)
new_total_per_year_df = new_df.sum(axis=1)
```

Now we will create a new `DataFrame` with each sum in a series that we will plot using the data frame `plot()` method.

```python
world_trends_df = pd.DataFrame({
           'Total deaths per 100K' : deaths_total_per_year_df, 
           'Total existing cases per 100K' : existing_total_per_year_df, 
           'Total new cases per 100K' : new_total_per_year_df}, 
       index=deaths_total_per_year_df.index)
```
```python
world_trends_df.plot(figsize=(12,6)).legend(
    loc='center left', 
    bbox_to_anchor=(1, 0.5))
```
![enter image description here](https://www.filepicker.io/api/file/CUKWAdPcTeul0jhrtx6z "enter image title here")

It seems that the general tendency is for a decrease in the total number of **existing cases** per 100K. However the number of **new cases** has been increasing, although it seems reverting from 2005. So how is possible that the total number of existing cases is decreasing if the total number of new cases has been growing? One of the reasons could be the observed increae in the number of **deaths** per 100K, but the main reason we have to consider is that people recovers form tuberculosis thanks to treatment. The sum of the recovery rate plus the death rate is greater than the new cases rate. In any case, it seems that there are more new cases, but also that we cure them better. We need to improve prevention and epidemics control.      

###### Countries out of tendency

So the previous was the general tendency of the world as a whole. So what countries are out of that tendency (for bad)? In order to find this out, first we need to know the distribution of countries in an average year.

```python
deaths_by_country_mean = deaths_df.mean()
deaths_by_country_mean_summary = deaths_by_country_mean.describe()
existing_by_country_mean = existing_df.mean()
existing_by_country_mean_summary = existing_by_country_mean.describe()
new_by_country_mean = new_df.mean()
new_by_country_mean_summary = new_by_country_mean.describe()
```

We can plot these distributions to have an idea of how the countries are distributed in an average year.

```python
deaths_by_country_mean.sort_values().plot(kind='bar', figsize=(24,6))
```
![enter image description here](https://www.filepicker.io/api/file/r8PqqNwESKmWupnf1pLQ "enter image title here")

We want those countries beyond 1.5 times the inter quartile range (50%). We have these values in:  

```python
deaths_outlier = deaths_by_country_mean_summary['50%']*1.5
existing_outlier = existing_by_country_mean_summary['50%']*1.5
new_outlier = new_by_country_mean_summary['50%']*1.5
```

Now we can use these values to get those countries that, across the period 1990-2007 has been beyond those levels.

```python
# Now compare with the outlier threshold
outlier_countries_by_deaths_index = 
    deaths_by_country_mean > deaths_outlier
outlier_countries_by_existing_index = 
   existing_by_country_mean > existing_outlier
outlier_countries_by_new_index = 
    new_by_country_mean > new_outlier
```

What proportion of countries do we have out of trend? For deaths:

```python
num_countries = len(deaths_df.T)
sum(outlier_countries_by_deaths_index)/num_countries
```
```python
    0.39613526570048307
```

For existing cases (prevalence):

```python
 sum(outlier_countries_by_existing_index)/num_countries
```
```python
    0.39613526570048307
```

For new cases (incidence):

```python
 sum(outlier_countries_by_new_index)/num_countries
```
```python
    0.38647342995169082
```

Now we can use these indices to filter our original data frames.

```python
outlier_deaths_df = deaths_df.T[ outlier_countries_by_deaths_index ].T
outlier_existing_df = existing_df.T[ outlier_countries_by_existing_index ].T
outlier_new_df = new_df.T[ outlier_countries_by_new_index ].T
```

This is serious stuff. We have more than one third of the world being outliers on the distribution of existings cases, new cases, and deaths by infectious tuberculosis. But what if we consider an outlier to be 5 times the IQR? Let's repeat the previous process.

```python
deaths_super_outlier = deaths_by_country_mean_summary['50%']*5
existing_super_outlier = existing_by_country_mean_summary['50%']*5
new_super_outlier = new_by_country_mean_summary['50%']*5
    
super_outlier_countries_by_deaths_index = 
    deaths_by_country_mean > deaths_super_outlier
super_outlier_countries_by_existing_index = 
    existing_by_country_mean > existing_super_outlier
super_outlier_countries_by_new_index = 
    new_by_country_mean > new_super_outlier
```

What proportion do we have now?

```python
sum(super_outlier_countries_by_deaths_index)/num_countries
```
```python
    0.21739130434782608
```

Let's get the data frames.

```python
super_outlier_deaths_df = 
    deaths_df.T[ super_outlier_countries_by_deaths_index ].T
super_outlier_existing_df = 
    existing_df.T[ super_outlier_countries_by_existing_index ].T
super_outlier_new_df = 
    new_df.T[ super_outlier_countries_by_new_index ].T
```

Let's concentrate on epidemics control and have a look at the new cases data frame.

```python
super_outlier_new_df
```  

| country | Bhutan | Botswana | Cambodia | Congo, Rep. | Cote d'Ivoire | Korea, Dem. Rep. | Djibouti | Kiribati | Lesotho | Malawi | ... | Philippines | Rwanda | Sierra Leone | South Africa | Swaziland | Timor-Leste | Togo | Uganda | Zambia | Zimbabwe |
|---------|--------|----------|----------|-------------|---------------|------------------|----------|----------|---------|--------|-----|-------------|--------|--------------|--------------|-----------|-------------|------|--------|--------|----------|
| year    |        |          |          |             |               |                  |          |          |         |        |     |             |        |              |              |           |             |      |        |        |          |
| 1990    | 540    | 307      | 585      | 169         | 177           | 344              | 582      | 513      | 184     | 258    | ... | 393         | 167    | 207          | 301          | 267       | 322         | 308  | 163    | 297    | 329      |
| 1991    | 516    | 341      | 579      | 188         | 196           | 344              | 594      | 503      | 201     | 286    | ... | 386         | 185    | 220          | 301          | 266       | 322         | 314  | 250    | 349    | 364      |
| 1992    | 492    | 364      | 574      | 200         | 209           | 344              | 606      | 493      | 218     | 314    | ... | 380         | 197    | 233          | 302          | 260       | 322         | 320  | 272    | 411    | 389      |
| 1993    | 470    | 390      | 568      | 215         | 224           | 344              | 618      | 483      | 244     | 343    | ... | 373         | 212    | 248          | 305          | 267       | 322         | 326  | 296    | 460    | 417      |
| 1994    | 449    | 415      | 563      | 229         | 239           | 344              | 630      | 474      | 280     | 373    | ... | 366         | 225    | 263          | 309          | 293       | 322         | 333  | 306    | 501    | 444      |
| 1995    | 428    | 444      | 557      | 245         | 255           | 344              | 642      | 464      | 323     | 390    | ... | 360         | 241    | 279          | 317          | 337       | 322         | 339  | 319    | 536    | 474      |
| 1996    | 409    | 468      | 552      | 258         | 269           | 344              | 655      | 455      | 362     | 389    | ... | 353         | 254    | 297          | 332          | 398       | 322         | 346  | 314    | 554    | 501      |
| 1997    | 391    | 503      | 546      | 277         | 289           | 344              | 668      | 446      | 409     | 401    | ... | 347         | 273    | 315          | 360          | 474       | 322         | 353  | 320    | 576    | 538      |
| 1998    | 373    | 542      | 541      | 299         | 312           | 344              | 681      | 437      | 461     | 412    | ... | 341         | 294    | 334          | 406          | 558       | 322         | 360  | 326    | 583    | 580      |
| 1999    | 356    | 588      | 536      | 324         | 338           | 344              | 695      | 428      | 519     | 417    | ... | 335         | 319    | 355          | 479          | 691       | 322         | 367  | 324    | 603    | 628      |
| 2000    | 340    | 640      | 530      | 353         | 368           | 344              | 708      | 420      | 553     | 425    | ... | 329         | 348    | 377          | 576          | 801       | 322         | 374  | 340    | 602    | 685      |
| 2001    | 325    | 692      | 525      | 382         | 398           | 344              | 722      | 412      | 576     | 414    | ... | 323         | 376    | 400          | 683          | 916       | 322         | 382  | 360    | 627    | 740      |
| 2002    | 310    | 740      | 520      | 408         | 425           | 344              | 737      | 403      | 613     | 416    | ... | 317         | 402    | 425          | 780          | 994       | 322         | 389  | 386    | 632    | 791      |
| 2003    | 296    | 772      | 515      | 425         | 444           | 344              | 751      | 396      | 635     | 410    | ... | 312         | 419    | 451          | 852          | 1075      | 322         | 397  | 396    | 652    | 825      |
| 2004    | 283    | 780      | 510      | 430         | 448           | 344              | 766      | 388      | 643     | 405    | ... | 306         | 423    | 479          | 898          | 1127      | 322         | 405  | 385    | 623    | 834      |
| 2005    | 270    | 770      | 505      | 425         | 443           | 344              | 781      | 380      | 639     | 391    | ... | 301         | 418    | 509          | 925          | 1141      | 322         | 413  | 370    | 588    | 824      |
| 2006    | 258    | 751      | 500      | 414         | 432           | 344              | 797      | 372      | 638     | 368    | ... | 295         | 408    | 540          | 940          | 1169      | 322         | 421  | 350    | 547    | 803      |
| 2007    | 246    | 731      | 495      | 403         | 420           | 344              | 813      | 365      | 637     | 346    | ... | 290         | 397    | 574          | 948          | 1198      | 322         | 429  | 330    | 506    | 782      |  


###### 18 rows × 22 columns  


Let's make some plots to get a better imppression.

```python
super_outlier_new_df.plot(figsize=(12,4)).legend(loc='center left', bbox_to_anchor=(1, 0.5))
```
![enter image description here](https://www.filepicker.io/api/file/cJ335ldPQvmhZJweNngB "enter image title here")

We have 22 countries where the number of new cases on an average year is greater than 5 times the median value of the distribution. Let's create a country that represents on average these 22.

```python
average_super_outlier_country = super_outlier_new_df.mean(axis=1)
average_super_outlier_country
```
```python
    year
    1990    314.363636
    1991    330.136364
    1992    340.681818
    1993    352.909091
    1994    365.363636
    1995    379.227273
    1996    390.863636
    1997    408.000000
    1998    427.000000
    1999    451.409091
    2000    476.545455
    2001    502.409091
    2002    525.727273
    2003    543.318182
    2004    548.909091
    2005    546.409091
    2006    540.863636
    2007    535.181818
    dtype: float64
```

Now let's create a country that represents the rest of the world.

```python
avearge_better_world_country = 
    new_df.T[ - super_outlier_countries_by_new_index ].T.mean(axis=1)
avearge_better_world_country
```
```python
    year
    1990    80.751351
    1991    81.216216
    1992    80.681081
    1993    81.470270
    1994    81.832432
    1995    82.681081
    1996    82.589189
    1997    84.497297
    1998    85.189189
    1999    86.232432
    2000    86.378378
    2001    86.551351
    2002    89.848649
    2003    87.778378
    2004    87.978378
    2005    87.086022
    2006    86.559140
    2007    85.605405
    dtype: float64
```

Now let's plot this country with the average world country.

```python
two_world_df = 
    pd.DataFrame({ 
            'Average Better World Country': avearge_better_world_country,
            'Average Outlier Country' : average_super_outlier_country},
        index = new_df.index)
two_world_df.plot(title="Estimated new TB cases per 100K",figsize=(12,8))
```
![enter image description here](https://www.filepicker.io/api/file/TepcmbKSKiqZt6fmLulo "enter image title here")

The increase in new cases tendency is really stronger in the average super outlier country, so stronger that is difficult to perceive that same tendency in the *better world* country. The 90's decade brought a terrible increase in the number of TB cases in those countries. But let's have a look at the exact numbers.

```python
two_world_df.pct_change().plot(title="Percentage change in estimated new TB cases", figsize=(12,8))
```
![enter image description here](https://www.filepicker.io/api/file/AcmGyyhmSfursmmhiH6q "enter image title here")

The deceleration and reversion of that tendency seem to happen at the same time in both average countries, something around 2002? We will try to find out in the next section.

### R  

We already know that we can use `max` with a data frame column in R and get the maximum value. Additionally, we can use `which.max` in order to get its position (similarly to the use og `argmax` in Pandas). If we use the transposed data frame, we can use `lapply` or `sapply` to perform this operation in every year column, getting then either a list or a vector of indices (we will use `sapply` that returns a vector). We just need a little tweak and use a countries vector that we will index to get the country name instead of the index as a result.  


```r
country_names <- rownames(existing_df_t)
sapply(existing_df_t, function(x) {country_names[which.max(x)]})
```

```
##              X1990              X1991              X1992 
##         "Djibouti"         "Djibouti"         "Djibouti" 
##              X1993              X1994              X1995 
##         "Djibouti"         "Djibouti"         "Djibouti" 
##              X1996              X1997              X1998 
##         "Kiribati"         "Kiribati"         "Cambodia" 
##              X1999              X2000              X2001 
## "Korea, Dem. Rep."         "Djibouti"        "Swaziland" 
##              X2002              X2003              X2004 
##         "Djibouti"         "Djibouti"         "Djibouti" 
##              X2005              X2006              X2007 
##         "Djibouti"         "Djibouti"         "Djibouti"
```

###### World trends in TB cases  

Again, in order to explore the world general tendency, we need to sum up every countries’ values for the three datasets, per year. 

But first we need to load the other two datasets for number of deaths and number of new cases. 


```r
# Download files
deaths_file <- getURL("https://docs.google.com/spreadsheets/d/12uWVH_IlmzJX_75bJ3IH5E-Gqx6-zfbDKNvZqYjUuso/pub?gid=0&output=CSV")
new_cases_file <- getURL("https://docs.google.com/spreadsheets/d/1Pl51PcEGlO9Hp4Uh0x2_QM0xVb53p2UDBMPwcnSjFTk/pub?gid=0&output=csv")

# Read into data frames
deaths_df <- read.csv(
    text = deaths_file, 
    row.names=1, 
    stringsAsFactor=F)
new_df <- read.csv(
    text = new_cases_file, 
    row.names=1, 
    stringsAsFactor=F)

# Cast data to int (deaths doesn't need it)
new_df[1:18] <- lapply(
    new_df[1:18], 
    function(x) { as.integer(gsub(',', '', x) )})

# Transpose
deaths_df_t <- deaths_df
deaths_df <- as.data.frame(t(deaths_df))
new_df_t <- new_df
new_df <- as.data.frame(t(new_df))
```

And now the sums by row. We need to convert to a data frame since the function returns a numeric vector.  


```r
deaths_total_per_year_df <- data.frame(total=rowSums(deaths_df))
existing_total_per_year_df <- data.frame(total=rowSums(existing_df))
# We pass na.rm = TRUE in order to ignore missing values in the new
# cases data frame when summing (no missing values in other dataframes though)
new_total_per_year_df <- data.frame(total=rowSums(new_df, na.rm = TRUE))
```

Now we can plot each line using what we have learnt so far. In order to get a vector with the counts to pass to each plotting function, we use R data frame indexing by column name.  


```r
xrange <- 1990:2007
plot(xrange, deaths_total_per_year_df$total, 
     type='l', xlab="Year", 
     ylab="Count per 100K", 
     col = "blue", 
     ylim=c(0,50000))
lines(xrange, existing_total_per_year_df$total,
      col = "darkgreen")
lines(xrange, new_total_per_year_df$total, 
      col = "red")
legend(x=1992, y=52000, 
       lty=1, 
       cex = .7,
       ncol = 3,
       col=c("blue","darkgreen","red"), 
       legend=c("Deaths","Existing cases","New cases"))
```

![enter image description here](https://www.filepicker.io/api/file/8jYeuVFCRsaU2cG57Zu2 "enter image title here")

The conclusions are obviously the same as when using Python.  

###### Countries out of tendency  

So what countries are out of that tendency (for bad)? Again, in order to find this out, first we need to know the distribution of countries in an average year. We use `colMeans` for that purpose.    


```r
deaths_by_country_mean <- data.frame(mean=colMeans(deaths_df))
existing_by_country_mean <- data.frame(mean=colMeans(existing_df))
new_by_country_mean <- data.frame(mean=colMeans(new_df, na.rm=TRUE))
```

We can plot these distributions to have an idea of how the countries are distributed in an average year. We are not so interested about the individual countries but about the distribution itself.    


```r
barplot(sort(deaths_by_country_mean$mean))
```

![enter image description here](https://www.filepicker.io/api/file/ncDFjd5aTUif1zX81SHK "enter image title here")

Again we can see there are someway three sections, with a slowly decreasing part at the beginning, a second more step section, and a final peak that is clearly apart from the rest.  

Let's skip this time the 1.5-outlier part and go diretcly to the 5.0-outliers. In R we will use a different approach we will use the `quantile()` function in order to get the inter-quartile range and determine the outlier threshold.  

Since we already know the results from our Python section, let's do it just for the new cases, so we generate also the plots we did before.  


```r
new_super_outlier <- 
    quantile(new_by_country_mean$mean, probs = c(.5)) * 5.0
super_outlier_countries_by_new_index <- 
    new_by_country_mean > new_super_outlier
```

And the proportion is.  


```r
sum(super_outlier_countries_by_new_index)/208
```

```
## [1] 0.1057692
```

Let's obtain a data frame from this, with just those countries we consider to be outliers.  


```r
super_outlier_new_df <- 
    new_df[, super_outlier_countries_by_new_index ]
```

Now we are ready to plot them.  


```r
xrange <- 1990:2007
plot(xrange, super_outlier_new_df[,1], 
     type='l', xlab="Year", 
     ylab="New cases per 100K", 
     col = 1, 
     ylim=c(0,1800))
for (i in seq(2:ncol(super_outlier_new_df))) {
    lines(xrange, super_outlier_new_df[,i],
    col = i)
}
legend(x=1990, y=1800, 
       lty=1, cex = 0.5,
       ncol = 7,
       col=1:22,
       legend=colnames(super_outlier_new_df))
```

![enter image description here](https://www.filepicker.io/api/file/SjGa0JiqTyKJrouXYYOl "enter image title here")

Definitely we can see here an advantage of using Pandas basic plotting versus R basic plotting!  

So far our results match. We have 22 countries where the number of new cases on an average year is greater than 5 times the median value of the distribution. Let’s create a country that represents on average these 22. We will use `rowMeans()` here.    


```r
average_countries_df <- 
    data.frame(
        averageOutlierMean=rowMeans(super_outlier_new_df, na.rm=T)
    )
average_countries_df
```

```
##       averageOutlierMean
## X1990           314.3636
## X1991           330.1364
## X1992           340.6818
## X1993           352.9091
## X1994           365.3636
## X1995           379.2273
## X1996           390.8636
## X1997           408.0000
## X1998           427.0000
## X1999           451.4091
## X2000           476.5455
## X2001           502.4091
## X2002           525.7273
## X2003           543.3182
## X2004           548.9091
## X2005           546.4091
## X2006           540.8636
## X2007           535.1818
```

Now let’s create a country that represents the rest of the world.  


```r
average_countries_df$averageBetterWorldMean <- 
    rowMeans(new_df[ ,- super_outlier_countries_by_new_index ], na.rm=T)
average_countries_df
```

```
##       averageOutlierMean averageBetterWorldMean
## X1990           314.3636               105.2767
## X1991           330.1364               107.3786
## X1992           340.6818               108.0243
## X1993           352.9091               110.0388
## X1994           365.3636               111.6942
## X1995           379.2273               113.9369
## X1996           390.8636               115.0971
## X1997           408.0000               118.6408
## X1998           427.0000               121.2913
## X1999           451.4091               124.8350
## X2000           476.5455               127.6505
## X2001           502.4091               130.5680
## X2002           525.7273               136.0194
## X2003           543.3182               136.0388
## X2004           548.9091               136.8155
## X2005           546.4091               135.5121
## X2006           540.8636               134.4493
## X2007           535.1818               133.2184
```

Now let’s plot the outlier country with the average world country.  


```r
xrange <- 1990:2007
plot(xrange, average_countries_df$averageOutlierMean, 
     type='l', xlab="Year", 
     ylab="New cases per 100K", 
     col = "darkgreen", 
     ylim=c(0,600))
lines(xrange, average_countries_df$averageBetterWorldMean, col = "blue")
legend(x=1990, y=600, 
       lty=1, cex = 0.7,
       ncol = 2,
       col=c("darkgreen","blue"),
       legend=c("Average outlier country", "Average World Country"))
```

![enter image description here](https://www.filepicker.io/api/file/etQ5YtRCSE20emH8ZC6w "enter image title here")


### Googling about events and dates in Tuberculosis

We will use just Python in this section. About googling, actually we just went straight to [Wikipedia's entry about the disease](https://en.wikipedia.org/wiki/Tuberculosis#Epidemiology). In the epidemics sections we found the following: 

- The total number of tuberculosis cases has been decreasing since 2005, while **new cases** have decreased since 2002.  
 - This is confirmed by our previous analysis.    

- China has achieved particularly dramatic progress, with about an 80% reduction in its TB mortality rate between 1990 and 2010. Let's check it:  

```python
existing_df.China.plot(title="Estimated existing TB cases in China")
```
![enter image description here](https://www.filepicker.io/api/file/DM29iQNVSquV5PxoGbu3 "enter image title here")

- In 2007, the country with the highest estimated incidence rate of TB was Swaziland, with 1,200 cases per 100,000 people.  

```python
new_df.apply(pd.Series.argmax, axis=1)['2007']
```
```python
    'Swaziland'
```

There are many more findings Wikipedia that we can confirm with these or other datasets from Gapminder world. For example, TB and HIV are frequently associated, together with poverty levels. It would be interesting to join datasets and explore tendencies in each of them. We challenge the reader to give them a try and share with us their findings. 

### Other web pages to explore

Some interesting resources about tuberculosis apart from the Gapminder website: 

- Gates foundation:  
 - http://www.gatesfoundation.org/What-We-Do/Global-Health/Tuberculosis  
 - http://www.gatesfoundation.org/Media-Center/Press-Releases/2007/09/New-Grants-to-Fight-Tuberculosis-Epidemic  

## Conclusions  

Exploratory data analysis is a key step in data analysis. It is during this stage when we start shaping any later work. It precedes any data visualisation or machine learning work, by showing us good or bad our data and our hypothesis are.   

Traditionally, R has been the weapon of choice for most EDA work, although the use of a more expressive plotting library such as gglot2 is quite convenient. In fact, the base plotting functionality incorporated in Pandas makes the process cleaner and quicker when using Python. However, the questions we have answered here were very simple and didn't include multiple variables and encodings. In such cases an advanced library like ggplot2 will shine. Apart from providing nicer charts, it will saves us quite a lot of time due to its expressiveness and reusability.  

But as simple as our analysis and charts are, we have been able to make the point about how serious the humanitarian crisis is regarding a disease like tuberculosis, specially when considering that the disease is relatively well controlled in more developed countries. We have seen how some coding skills and a good amount of curiosity allows us to create awareness in these and other world issues.   