# Dimensionality Reduction and Clustering  

An important step in data analysis is data exploration and representation. We have already seen some concepts in Exploratory Data Analysis and how to use them with both, Python and R. In this tutorial we will see how by combining a technique called [Principal Component Analysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis) together with [Cluster Analysis](https://en.wikipedia.org/wiki/Cluster_analysis) we can **represent in a two dimensional space data defined in a higher dimensional one** while, at the same time, being able to group this data in similar groups or clusters and **find hidden relationships in our data**.  

More concretely, PCA reduces data dimensionality by finding **principal components**. These are the directions of maximum variation in a dataset. By reducing a dataset original features or variables to a reduced set of new ones based on the principal components, we end up with the minimum number of variables that keep the **maximum amount of variation or information about how the data is distributed**.  If we end up with just two of these new variables, we will be able to represent each sample in our data in a two dimensional chart (e.g. a scatterplot).   

As an unsupervised data analysis technique, clustering organises data samples by proximity based on its variables. By doing so we will be able to understand how each data point relates to each other and discover groups of similar ones. Once we have each of this groups or clusters, we will be able to define a centroid for them, an ideal data sample that minimises the sum of the distances to each of the data points in a cluster. By analysing these centroids variables we will be able to define each cluster in terms of its characteristics.  

But enough theory for today. Let's put these ideas in practice by using Python and R so we better understand them in order to apply them in the future.  

## Preparing our TB data  

We will continue using the same datasets we already loaded in the part [introducing data frames](https://www.codementor.io/python/tutorial/python-vs-r-for-data-science-data-frames-i). The [Gapminder website](http://www.gapminder.org/) presents itself as *a fact-based worldview*. It is a comprehensive resource for data regarding different countries and territories indicators. Its [Data section](http://www.gapminder.org/data/) contains a list of datasets that can be accessed as Google Spreadsheet pages (add `&output=csv` to download as CSV). Each indicator dataset is tagged with a *Data provider*, a *Category*, and a *Subcategory*.  

For this tutorial, we will use a dataset related to prevalence of Infectious Tuberculosis:  


- [TB estimated prevalence (existing cases) per 100K](https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0)  

We invite the reader to repeat the process with the new cases and deaths datasets and share the results.  

For the sake of making the tutorial self-contained, we will repeat here the code that gets and prepared the datasets bot, in Python and R. This tutorial is about exploring countries. Therefore we will work with datasets where each sample is a country and each variable is a year.    

### R  

In R, you use `read.csv` to read CSV files into `data.frame` variables. Although the R function `read.csv` can work with URLs, https is a problem for R in many cases, so you need to use a package like RCurl to get around it.  

```r
library(RCurl)
```

```
## Loading required package: bitops
```

```r
# Get and process existing cases file
existing_cases_file <- getURL("https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0&output=csv")
existing_df <- read.csv(text = existing_cases_file, row.names=1, stringsAsFactor=F)
existing_df[c(1,2,3,4,5,6,15,16,17,18)] <- 
    lapply( existing_df[c(1,2,3,4,5,6,15,16,17,18)], 
            function(x) { as.integer(gsub(',', '', x) )})
```


###  Python  

So first, we need to download Google Spreadsheet data as CSV.

```python
import urllib
    
tb_existing_url_csv = 'https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0&output=csv'
local_tb_existing_file = 'tb_existing_100.csv'
existing_f = urllib.urlretrieve(tb_existing_url_csv, local_tb_existing_file)
```

Now that we have it locally, we need to read the CSV file as a data frame.

```python
import pandas as pd
    
existing_df = pd.read_csv(
    local_tb_existing_file, 
    index_col = 0, 
    thousands  = ',')
existing_df.index.names = ['country']
existing_df.columns.names = ['year']
```

We have specified `index_col` to be 0 since we want the country names to be the
row labels. We also specified the `thousands` separator to be ',' so Pandas
automatically parses cells as numbers. We can use `head()` to check the first
few lines.

```python
existing_df.head()
```

| year           | 1990 | 1991 | 1992 | 1993 | 1994 | 1995 | 1996 | 1997 | 1998 | 1999 | 2000 | 2001 | 2002 | 2003 | 2004 | 2005 | 2006 | 2007 |
|----------------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|
| country        |      |      |      |      |      |      |      |      |      |      |      |      |      |      |      |      |      |      |
| Afghanistan    | 436  | 429  | 422  | 415  | 407  | 397  | 397  | 387  | 374  | 373  | 346  | 326  | 304  | 308  | 283  | 267  | 251  | 238  |
| Albania        | 42   | 40   | 41   | 42   | 42   | 43   | 42   | 44   | 43   | 42   | 40   | 34   | 32   | 32   | 29   | 29   | 26   | 22   |
| Algeria        | 45   | 44   | 44   | 43   | 43   | 42   | 43   | 44   | 45   | 46   | 48   | 49   | 50   | 51   | 52   | 53   | 55   | 56   |
| American Samoa | 42   | 14   | 4    | 18   | 17   | 22   | 0    | 25   | 12   | 8    | 8    | 6    | 5    | 6    | 9    | 11   | 9    | 5    |
| Andorra        | 39   | 37   | 35   | 33   | 32   | 30   | 28   | 23   | 24   | 22   | 20   | 20   | 21   | 18   | 19   | 18   | 17   | 19   |


## Dimensionality reduction with PCA  
 
In this section we want to be able to represent each country in a two dimensional space. In our dataset, each sample is a country defined by 18 different variables, each one corresponding to TB cases counts per 100K (existing, new, deaths) for a given year from 1990 to 2007.  These variables represent not just the total counts or average in the 1990-2007 range but also all the variation in the time series and relationships within countries in a given year. By using PCA we will be able to reduce these 18 variables to just the two of them that best captures that information.  

In order to do so, we will first how to perform PCA and plot the first two PCs in both, Python and R. We will close the section by analysing the resulting plot and each of the two PCs.  

### R    

The default R package `stats` comes with function `prcomp()` to perform principal component analysis. This means that we don’t need to install anything (although there are other options using external packages). This is perhaps the quickest way to do a PCA, and I recommend you to call `?prcomp` in your R console if you're interested in the details of how to fine tune the PCA process with this function.  

```r
pca_existing <- prcomp(existing_df, scale. = TRUE)
```

The resulting object contains several pieces of information related with principal component analysis. We are interested in the scores, that we have in `pca_existing$x`. We got 18 different principal components. Remember that the total number of PCs corresponds to the total number of variables in the dataset, although we normally don't want to use all of them but the subset that corresponds to our purposes.  

In our case we will use the first two. How much variation is explained by each one? In R we can use the `plot` function that comes with the PCA result for that.  


```r
plot(pca_existing)
```

![enter image description here](https://www.filepicker.io/api/file/lvhdQkTRwKljN1VWUiEP "enter image title here")

Most variation is explained by the first PC. So let's use the first two PCs to represent all of our countries in a scatterplot.  


```r
scores_existing_df <- as.data.frame(pca_existing$x)
# Show first two PCs for head countries
head(scores_existing_df[1:2])
```

```
##                      PC1          PC2
## Afghanistan    -3.490274  0.973495650
## Albania         2.929002  0.012141345
## Algeria         2.719073 -0.184591877
## American Samoa  3.437263  0.005609367
## Andorra         3.173621  0.033839606
## Angola         -4.695625  1.398306461
```

Now that we have them in a data frame, we can use them with `plot`.  


```r
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid")
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8)
```

![enter image description here](https://www.filepicker.io/api/file/3FIQuXQwymNm9GkGSAkL "enter image title here")

Let's set the color associated with the mean value for all the years. We will use functions `rgb`, `ramp`, and `rescale` to create a color palette from yellow (lower values) to blue (higher values).    


```r
library(scales)
ramp <- colorRamp(c("yellow", "blue"))
colours_by_mean <- rgb( 
    ramp( as.vector(rescale(rowMeans(existing_df),c(0,1)))), 
    max = 255 )
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=colours_by_mean)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=colours_by_mean)
```

![enter image description here](https://www.filepicker.io/api/file/CucSx0UQZGgNqJJctYrY "enter image title here")

Now let's associate colour with total sum.  


```r
ramp <- colorRamp(c("yellow", "blue"))
colours_by_sum <- rgb( 
    ramp( as.vector(rescale(rowSums(existing_df),c(0,1)))), 
    max = 255 )
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=colours_by_sum)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=colours_by_sum)
```

![enter image description here](https://www.filepicker.io/api/file/GXfizhZVTN2LzUfub8cO "enter image title here")

And finally let's associate it with the difference between first and last year, as a simple way to measure the change in time.  



```r
existing_df_change <- existing_df$X2007 - existing_df$X1990
ramp <- colorRamp(c("yellow", "blue"))
colours_by_change <- rgb( 
    ramp( as.vector(rescale(existing_df_change,c(0,1)))), 
    max = 255 )
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=colours_by_change)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=colours_by_change)
```

![enter image description here](https://www.filepicker.io/api/file/Xmin5urEQBe5QamSerzA "enter image title here")

We have some interesting conclusions already, but first let's repeat the process using Python.    

### Python   

Python's sklearn machine learning library comes with a [PCA implementation](http
://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html).
This implementation uses the `scipy.linalg` implementation of the [singular value decomposition](https://en.wikipedia.org/wiki/Singular_value_decomposition). It
only works for dense arrays (see [numPy dense arrays](http://docs.scipy.org/doc/numpy/reference/generated/numpy.array.html) or
[sparse array PCA](http://scikit-learn.org/stable/modules/generated/sklearn.decomposition.SparsePCA.html#sklearn.decomposition.SparsePCA) if you are using sparse arrays) and is not scalable to large dimensional data. For large dimensional data we should consider something such as [Spark's dimensionality reduction features](http://spark.apache.org/docs/latest/mllib-dimensionality-reduction.html). In our case we just have 18 variables, and that is far from being a large number of features for today's machine learning libraries and computer capabilities.

When using this implementation of PCA we need to specify in advance the number
of principal components we want to use. Then we can just call the `fit()` method
with our data frame and check the results.

```python
from sklearn.decomposition import PCA
    
pca = PCA(n_components=2)
pca.fit(existing_df)
```
```python
    PCA(copy=True, n_components=2, whiten=False)
```


This gives us an object we can use to transform our data by calling `transform`.

```python
existing_2d = pca.transform(existing_df)
```

Or we could have just called `fit_transform` to perform both steps in one single
call.

In both cases we will end up with a lower dimension representation of our data
frame, as a numPy array. Let's put it in a new data frame.

```python
existing_df_2d = pd.DataFrame(existing_2d)
existing_df_2d.index = existing_df.index
existing_df_2d.columns = ['PC1','PC2']
existing_df_2d.head()
```

| PC1            | PC2         |            |
|----------------|-------------|------------|
| country        |             |            |
| Afghanistan    | -732.215864 | 203.381494 |
| Albania        | 613.296510  | 4.715978   |
| Algeria        | 569.303713  | -36.837051 |
| American Samoa | 717.082766  | 5.464696   |
| Andorra        | 661.802241  | 11.037736  |


We can also print the explained variance ratio as follows.

```python
print(pca.explained_variance_ratio_) 
```
```python
    [ 0.91808789  0.060556  ]
```

We see that the first PC already explains almost 92% of the variance, while the
second one accounts for another 6% for a total of almost 98% between the two of
them.

Now we are ready to plot the lower dimensionality version of our dataset. We just need to call plot on the data frame, by passing the kind of plot we want (see [here](http://pandas.pydata.org/pandas-docs/version/0.15.0/visualization.html) for more on plotting data frames) and what columns correspond to each axis. We also add an annotation loop that tags every point with its country name.

```python
%matplotlib inline
    
ax = existing_df_2d.plot(kind='scatter', x='PC2', y='PC1', figsize=(16,8))
    
for i, country in enumerate(existing_df.index):
    ax.annotate(
        country, 
        (existing_df_2d.iloc[i].PC2, existing_df_2d.iloc[i].PC1)
    )
```

![enter image description here](https://www.filepicker.io/api/file/PPomuIILRdGBVLyfMOZU "enter image title here")


Let's now create a bubble chart, by setting the point size to a value proportional to the mean value for all the years in that particular country. First we need to add a new column containing the re-scaled mean per country across all the years.

```python
from sklearn.preprocessing import normalize
    
existing_df_2d['country_mean'] = pd.Series(existing_df.mean(axis=1), index=existing_df_2d.index)
country_mean_max = existing_df_2d['country_mean'].max()
country_mean_min = existing_df_2d['country_mean'].min()
country_mean_scaled = 
    (existing_df_2d.country_mean-country_mean_min) / country_mean_max
existing_df_2d['country_mean_scaled'] = pd.Series(
        country_mean_scaled, 
        index=existing_df_2d.index) 
existing_df_2d.head()
```

| PC1            | PC2         | country_mean | country_mean_scaled |          |
|----------------|-------------|--------------|---------------------|----------|
| country        |             |              |                     |          |
| Afghanistan    | -732.215864 | 203.381494   | 353.333333          | 0.329731 |
| Albania        | 613.296510  | 4.715978     | 36.944444           | 0.032420 |
| Algeria        | 569.303713  | -36.837051   | 47.388889           | 0.042234 |
| American Samoa | 717.082766  | 5.464696     | 12.277778           | 0.009240 |
| Andorra        | 661.802241  | 11.037736    | 25.277778           | 0.021457 |


Now we are ready to plot using this variable size (we will omit the country names this time since we are not so interested in them).

```python
existing_df_2d.plot(
    kind='scatter', 
    x='PC2', 
    y='PC1', 
    s=existing_df_2d['country_mean_scaled']*100, 
    figsize=(16,8))
```

![enter image description here](https://www.filepicker.io/api/file/qWOGxtCMTDYFTHk3uwaw "enter image title here")


Let's do the same with the sum instead of the mean.

```python
existing_df_2d['country_sum'] = pd.Series(
    existing_df.sum(axis=1), 
    index=existing_df_2d.index)
country_sum_max = existing_df_2d['country_sum'].max()
country_sum_min = existing_df_2d['country_sum'].min()
country_sum_scaled =
    (existing_df_2d.country_sum-country_sum_min) / country_sum_max
existing_df_2d['country_sum_scaled'] = pd.Series(
        country_sum_scaled, 
        index=existing_df_2d.index)
existing_df_2d.plot(
    kind='scatter', 
    x='PC2', y='PC1', 
    s=existing_df_2d['country_sum_scaled']*100, 
    figsize=(16,8))
```

![enter image description here](https://www.filepicker.io/api/file/oH9GfaOQTvWDLcEW2Hmi "enter image title here")


And finally let's associate the size with the change between 1990 and 2007. Note that in the scaled version, those values close to zero will make reference to those with negative values in the original non-scaled version, since we are scaling to a [0,1] range.

```python
existing_df_2d['country_change'] = pd.Series(
    existing_df['2007']-existing_df['1990'], 
    index=existing_df_2d.index)
country_change_max = existing_df_2d['country_change'].max()
country_change_min = existing_df_2d['country_change'].min()
country_change_scaled = 
    (existing_df_2d.country_change - country_change_min) / country_change_max
existing_df_2d['country_change_scaled'] = pd.Series(
        country_change_scaled, 
        index=existing_df_2d.index)
existing_df_2d[['country_change','country_change_scaled']].head()
```

| country_change | country_change_scaled |          |
|----------------|-----------------------|----------|
| country        |                       |          |
| Afghanistan    | -198                  | 0.850840 |
| Albania        | -20                   | 1.224790 |
| Algeria        | 11                    | 1.289916 |
| American Samoa | -37                   | 1.189076 |
| Andorra        | -20                   | 1.224790 |


```python
existing_df_2d.plot(
    kind='scatter', 
    x='PC2', y='PC1', 
    s=existing_df_2d['country_change_scaled']*100, 
    figsize=(16,8))
```

![enter image description here](https://www.filepicker.io/api/file/7M91LztARI2wT7Aya9Yx "enter image title here")

### PCA Results  

From the plots we have done in Python and R, we can confirm that most variation happens along the y axis, that we have assigned to PC1.  We saw that the first PC already explains almost 92% of the variance, while the second one accounts for another 6% for a total of almost 98% between the two of them. At the very top of our charts we could see an important concentration of countries, mostly developed. While we descend that axis, the number of countries is more sparse, and they belong to less developed regions of the world.   

When colouring/sizing points using two absolute magnitudes such as average and total number of cases, we can see that the directions also correspond to a variation in these magnitudes.  

Moreover, when using color/size to code the difference in the number of cases over time (2007 minus 1990), the color gradient mostly changed along the direction of the second principal component, with more positive values (i.e. increase in the number of cases) coloured in blue or with bigger size . That is, while the first PC captures most of the variation within our dataset and this variation is based on the total cases in the 1990-2007 range, the second PC is largely affected by the change over time. 

In the next section we will try to discover other relationships between countries.  

## Exploring data structure with k-means clustering   

In this section we will use [k-means clustering](https://en.wikipedia.org/wiki/K-means_clustering) to group countries based on how similar their situation has been year-by-year. That is, we will cluster the data based in the 18 variables that we have. Then we will use the cluster assignment to colour the previous 2D chart, in order to discover hidden relationship within our data and better understand the world situation regarding the tuberculosis disease.  

When using k-means, we need to determine the right number of groups for our case. This can be done more or less accurately by iterating through different values for the number of groups and compare an amount called the within-cluster sum of square distances for each iteration. This is the squared sum of distances to the cluster center for each cluster member. Of course this distance is minimal when the number of clusters gets equal to the number of samples, but we don't want to get there. We normally stop when the improvement in this value starts decreasing at a lower rate.   
 
However, we will use a more intuitive approach based on our understanding of the world situation and the nature of the results that we want to achieve. Sometimes this is the way to go in data analysis, specially when doing exploration tasks. To use the knowledge that we have about the nature of our data is always a good thing to do.  

### R  

Obtaining clusters in R is as simple as calling to `kmeans`. The function has several parameters, but we will just use all the defaults and start trying with different values of k.  

Let's start with determining how many clusters we should be looking for in our dataset. A really simple method is to use the elbow criterion (https://en.wikipedia.org/wiki/Determining_the_number_of_clusters_in_a_data_set).

```r
wss <- (nrow(existing_df)-1)*sum(apply(existing_df,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(existing_df,
                                     centers=i, iter.max=1000)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")
```

![enter image description here](https://www.filepicker.io/api/file/ILkP2zacTju7GR4AHDgL "enter image title here")

We can see most variance is explained with 3 clusters (the "elbow" of the curve) so let's start with `k=3`, which can let us assume that at least, the are countries in a really bad situation, countries in a good situation, and some of them in between.  


```r
set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 3)
```

The result contains a list with components:  

- `cluster`: A vector of integers indicating the cluster to which each point is allocated.  
- `centers`: A matrix of cluster centres.  
- `withinss`: The within-cluster sum of square distances for each cluster.  
- `size`: The number of points in each cluster.  

Let's colour our previous scatter plot based on what cluster each country belongs to.  


```r
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)
```
![enter image description here](https://www.filepicker.io/api/file/VWaWguhMR9m89cSQLa7N "enter image title here")

Most clusters are based on the first PC. That means that clusters are just defined in terms of the total number of cases per 100K and not how the data evolved on time (PC2). So let's try with `k=4` and see if some of these cluster are refined in the direction of the second PC.  


```r
set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 4)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)
```

![enter image description here](https://www.filepicker.io/api/file/kSxaKxDXRVivJ3zjGHfe "enter image title here")

There is more refinement, but again in the direction of the first PC. Let's try then with `k=5`.  


```r
set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 5)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)
```

![enter image description here](https://www.filepicker.io/api/file/Ap2HCB3TmfO67wSazyQG "enter image title here")

There we have it. Right in the middle we have a cluster that has been split in two different ones in the direction of the second PC. What if we try with `k=6`?  


```r
set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 6)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)
```

![enter image description here](https://www.filepicker.io/api/file/Dv4M0yzRTdqDaxcJ2PLF "enter image title here")

We get some diagonal split in the second top cluster. That surely contains some interesting information, but let's revert to our `k=5` case and later on we will see how to use a different refinement process with clusters are too tight like we have at the top of the plot.  


```r
set.seed(1234)
existing_clustering <- kmeans(existing_df, centers = 5)
existing_cluster_groups <- existing_clustering$cluster
plot(PC1~PC2, data=scores_existing_df, 
     main= "Existing TB cases per 100K distribution",
     cex = .1, lty = "solid", col=existing_cluster_groups)
text(PC1~PC2, data=scores_existing_df, 
     labels=rownames(existing_df),
     cex=.8, col=existing_cluster_groups)
```

![enter image description here](https://www.filepicker.io/api/file/sjzk5BRwRqK2twLPKLB1 "enter image title here")

### Python  

Again we will use `sklearn`, in this case its [k-means clustering](http://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html) implementation, in order to perform our clustering on the TB data. Since we already decided on a number of clusters of 5, we will use it here straightaway.

```python
from sklearn.cluster import KMeans
    
kmeans = KMeans(n_clusters=5)
clusters = kmeans.fit(existing_df)
```

Now we need to store the cluster assignments together with each country in our
data frame. The cluster labels are returned in `clusters.labels_`.

```python
existing_df_2d['cluster'] = pd.Series(clusters.labels_, index=existing_df_2d.index)
```

And now we are ready to plot, using the cluster column as color.

```python
import numpy as np
    
existing_df_2d.plot(
        kind='scatter',
        x='PC2',y='PC1',
        c=existing_df_2d.cluster.astype(np.float), 
        figsize=(16,8))
```

![enter image description here](https://www.filepicker.io/api/file/Ob67rnLiRHuabdX71mE1 "enter image title here")

The result is pretty much as the one obtained with R, with the color differences
and without the country names that we decided not to include here so we can better see the colours. In the next section we will analyse each cluster in detail.  

## Cluster interpretation  

Most of the work in this section is about data frame indexing and plotting. There isn't anything sophisticated about the code itself, so we will pick up one of our languages and perform the whole thing (we will use R this time).  

In order to analyse each cluster, let's add a column in our data frame containing the cluster ID. We will use that for subsetting.  

```r
existing_df$cluster <- existing_clustering$cluster
table(existing_df$cluster)
```

```
## 
##  1  2  3  4  5 
## 16 30 20 51 90
```

The last line shows how many countries do we have in each cluster.  

### Centroids comparison chart  

Let's start by creating a line chart that compares the time series for each cluster centroid. This chart will helps us better understand our cluster results.  


```r
xrange <- 1990:2007
plot(xrange, existing_clustering$centers[1,], 
     type='l', xlab="Year", 
     ylab="New cases per 100K", 
     col = 1, 
     ylim=c(0,1000))
for (i in 2:nrow(existing_clustering$centers)) {
    lines(xrange, existing_clustering$centers[i,],
    col = i)
}
legend(x=1990, y=1000, 
       lty=1, cex = 0.5,
       ncol = 5,
       col=1:(nrow(existing_clustering$centers)+1),
       legend=paste("Cluster",1:nrow(existing_clustering$centers)))
```

![enter image description here](https://www.filepicker.io/api/file/NZkBWawSQCfkYRggNd3E "enter image title here")

### Cluster 1  

Cluster 1 contains just 16 countries. These are:  


```r
rownames(subset(existing_df, cluster==1))
```

```
##  [1] "Bangladesh"       "Bhutan"           "Cambodia"        
##  [4] "Korea, Dem. Rep." "Djibouti"         "Kiribati"        
##  [7] "Mali"             "Mauritania"       "Namibia"         
## [10] "Philippines"      "Sierra Leone"     "South Africa"    
## [13] "Swaziland"        "Timor-Leste"      "Togo"            
## [16] "Zambia"
```

The centroid that represents them is:


```r
existing_clustering$centers[1,]
```

```
##    X1990    X1991    X1992    X1993    X1994    X1995    X1996    X1997 
## 764.0000 751.1875 734.9375 718.0625 701.6875 687.3125 624.7500 621.6250 
##    X1998    X1999    X2000    X2001    X2002    X2003    X2004    X2005 
## 605.1875 609.4375 622.0000 635.5000 604.2500 601.1250 597.3750 601.1250 
##    X2006    X2007 
## 600.2500 595.7500
```

These are by all means the countries with the most tuberculosis cases every year. We can see in the chart that this is the top line, although the number of cases descends progressively.  

### Cluster 2  

Cluster 2 contains 30 countries. These are:  


```r
rownames(subset(existing_df, cluster==2))
```

```
##  [1] "Afghanistan"           "Angola"               
##  [3] "Bolivia"               "Cape Verde"           
##  [5] "China"                 "Gabon"                
##  [7] "Gambia"                "Ghana"                
##  [9] "Guinea-Bissau"         "Haiti"                
## [11] "India"                 "Indonesia"            
## [13] "Laos"                  "Liberia"              
## [15] "Madagascar"            "Malawi"               
## [17] "Mongolia"              "Myanmar"              
## [19] "Nepal"                 "Niger"                
## [21] "Pakistan"              "Papua New Guinea"     
## [23] "Peru"                  "Sao Tome and Principe"
## [25] "Solomon Islands"       "Somalia"              
## [27] "Sudan"                 "Thailand"             
## [29] "Tuvalu"                "Viet Nam"
```

The centroid that represents them is:


```r
existing_clustering$centers[2,]
```

```
##    X1990    X1991    X1992    X1993    X1994    X1995    X1996    X1997 
## 444.5000 435.2000 426.1667 417.4000 409.2333 400.5667 378.6000 365.3667 
##    X1998    X1999    X2000    X2001    X2002    X2003    X2004    X2005 
## 358.0333 354.4333 350.6000 326.7333 316.1667 308.5000 297.8667 288.8000 
##    X2006    X2007 
## 284.9667 280.8000
```

It is a relatively large cluster. Still countries with lots of cases, but definitively less than the first cluster. We see countries such as India or China here, the larger countries on earth (from a previous tutorial we know that China itself has reduced its cases by 85%) and american countries such as Peru or Bolivia. In fact, this is the cluster with the fastest decrease in the number of existing cases as we see in the line chart.   

### Cluster 3  

This is an important one. Cluster 3 contains just 20 countries. These are:  


```r
rownames(subset(existing_df, cluster==3))
```

```
##  [1] "Botswana"                 "Burkina Faso"            
##  [3] "Burundi"                  "Central African Republic"
##  [5] "Chad"                     "Congo, Rep."             
##  [7] "Cote d'Ivoire"            "Congo, Dem. Rep."        
##  [9] "Equatorial Guinea"        "Ethiopia"                
## [11] "Guinea"                   "Kenya"                   
## [13] "Lesotho"                  "Mozambique"              
## [15] "Nigeria"                  "Rwanda"                  
## [17] "Senegal"                  "Uganda"                  
## [19] "Tanzania"                 "Zimbabwe"
```

The centroid that represents them is:


```r
existing_clustering$centers[3,]
```

```
##  X1990  X1991  X1992  X1993  X1994  X1995  X1996  X1997  X1998  X1999 
## 259.85 278.90 287.30 298.05 309.00 322.95 335.00 357.65 369.65 410.85 
##  X2000  X2001  X2002  X2003  X2004  X2005  X2006  X2007 
## 422.25 463.75 492.45 525.25 523.60 519.90 509.80 513.50
```

This is the only cluster where the number of cases has increased over the years, and is about to overtake the first position by 2007. Each of these countries are probably in the middle of an humanitarian crisis and probably beeing affected by other infectious diseases such as HIV. We can confirm here that PC2 is coding mostly that, the percentage of variation over time of the number of exiting cases.  

### Cluster 4  

The fourth cluster contains 51 countries.  


```r
rownames(subset(existing_df, cluster==4))
```

```
##  [1] "Armenia"                  "Azerbaijan"              
##  [3] "Bahrain"                  "Belarus"                 
##  [5] "Benin"                    "Bosnia and Herzegovina"  
##  [7] "Brazil"                   "Brunei Darussalam"       
##  [9] "Cameroon"                 "Comoros"                 
## [11] "Croatia"                  "Dominican Republic"      
## [13] "Ecuador"                  "El Salvador"             
## [15] "Eritrea"                  "Georgia"                 
## [17] "Guam"                     "Guatemala"               
## [19] "Guyana"                   "Honduras"                
## [21] "Iraq"                     "Kazakhstan"              
## [23] "Kyrgyzstan"               "Latvia"                  
## [25] "Lithuania"                "Malaysia"                
## [27] "Maldives"                 "Micronesia, Fed. Sts."   
## [29] "Morocco"                  "Nauru"                   
## [31] "Nicaragua"                "Niue"                    
## [33] "Northern Mariana Islands" "Palau"                   
## [35] "Paraguay"                 "Qatar"                   
## [37] "Korea, Rep."              "Moldova"                 
## [39] "Romania"                  "Russian Federation"      
## [41] "Seychelles"               "Sri Lanka"               
## [43] "Suriname"                 "Tajikistan"              
## [45] "Tokelau"                  "Turkmenistan"            
## [47] "Ukraine"                  "Uzbekistan"              
## [49] "Vanuatu"                  "Wallis et Futuna"        
## [51] "Yemen"
```

Represented by its centroid.  


```r
existing_clustering$centers[4,]
```

```
##     X1990     X1991     X1992     X1993     X1994     X1995     X1996 
## 130.60784 133.41176 125.60784 127.54902 124.82353 127.70588 121.68627 
##     X1997     X1998     X1999     X2000     X2001     X2002     X2003 
## 130.50980 125.82353 124.45098 110.58824 106.60784 121.09804 103.01961 
##     X2004     X2005     X2006     X2007 
## 101.80392  97.29412  96.17647  91.68627
```

This cluster is pretty close to the last and larger one. It contains many american countries, some european countries, etc. Some of them are large and rich, such as Russia or Brazil. Structurally the differece with the countries in Cluster 5 may reside in a larger number of cases per 100K. They also seem to be decreasing the number of cases slightly faster than Cluster 5. These two reasons made k-means cluster them in a different group.  

### Cluster 5  

The last and bigger cluster contains 90 countries.  


```r
rownames(subset(existing_df, cluster==5))
```

```
##  [1] "Albania"                          "Algeria"                         
##  [3] "American Samoa"                   "Andorra"                         
##  [5] "Anguilla"                         "Antigua and Barbuda"             
##  [7] "Argentina"                        "Australia"                       
##  [9] "Austria"                          "Bahamas"                         
## [11] "Barbados"                         "Belgium"                         
## [13] "Belize"                           "Bermuda"                         
## [15] "British Virgin Islands"           "Bulgaria"                        
## [17] "Canada"                           "Cayman Islands"                  
## [19] "Chile"                            "Colombia"                        
## [21] "Cook Islands"                     "Costa Rica"                      
## [23] "Cuba"                             "Cyprus"                          
## [25] "Czech Republic"                   "Denmark"                         
## [27] "Dominica"                         "Egypt"                           
## [29] "Estonia"                          "Fiji"                            
## [31] "Finland"                          "France"                          
## [33] "French Polynesia"                 "Germany"                         
## [35] "Greece"                           "Grenada"                         
## [37] "Hungary"                          "Iceland"                         
## [39] "Iran"                             "Ireland"                         
## [41] "Israel"                           "Italy"                           
## [43] "Jamaica"                          "Japan"                           
## [45] "Jordan"                           "Kuwait"                          
## [47] "Lebanon"                          "Libyan Arab Jamahiriya"          
## [49] "Luxembourg"                       "Malta"                           
## [51] "Mauritius"                        "Mexico"                          
## [53] "Monaco"                           "Montserrat"                      
## [55] "Netherlands"                      "Netherlands Antilles"            
## [57] "New Caledonia"                    "New Zealand"                     
## [59] "Norway"                           "Oman"                            
## [61] "Panama"                           "Poland"                          
## [63] "Portugal"                         "Puerto Rico"                     
## [65] "Saint Kitts and Nevis"            "Saint Lucia"                     
## [67] "Saint Vincent and the Grenadines" "Samoa"                           
## [69] "San Marino"                       "Saudi Arabia"                    
## [71] "Singapore"                        "Slovakia"                        
## [73] "Slovenia"                         "Spain"                           
## [75] "Sweden"                           "Switzerland"                     
## [77] "Syrian Arab Republic"             "Macedonia, FYR"                  
## [79] "Tonga"                            "Trinidad and Tobago"             
## [81] "Tunisia"                          "Turkey"                          
## [83] "Turks and Caicos Islands"         "United Arab Emirates"            
## [85] "United Kingdom"                   "Virgin Islands (U.S.)"           
## [87] "United States of America"         "Uruguay"                         
## [89] "Venezuela"                        "West Bank and Gaza"
```

Represented by its centroid.  


```r
existing_clustering$centers[5,]
```

```
##    X1990    X1991    X1992    X1993    X1994    X1995    X1996    X1997 
## 37.27778 35.68889 35.73333 34.40000 33.51111 32.42222 30.80000 30.51111 
##    X1998    X1999    X2000    X2001    X2002    X2003    X2004    X2005 
## 29.30000 26.77778 24.35556 23.57778 22.02222 20.93333 20.48889 19.92222 
##    X2006    X2007 
## 19.25556 19.11111
```

This cluster is too large and heterogeneous and probably needs further refinement. However, it is a good grouping when compared to other distant clusters. In any case it contains those countries with less number of existing cases in our set.    

### A second level of clustering  

So let's do just that quickly. Let's re-cluster the 90 countries in our Cluster 5 in order to firther refine them. As the number of clusters let's use 2. We are just interested in seeing if there are actually two different clusters withing Cluster 5. The reader can of course try to go further and use more than 2 centers.  


```r
# subset the original dataset
cluster5_df <- subset(existing_df, cluster==5)
# do the clustering
set.seed(1234)
cluster5_clustering <- kmeans(cluster5_df[,-19], centers = 2)
# assign sub-cluster number to the data set for Cluster 5
cluster5_df$cluster <- cluster5_clustering$cluster
```

Now we can plot them in order to see if there are actual differences.  


```r
xrange <- 1990:2007
plot(xrange, cluster5_clustering$centers[1,], 
     type='l', xlab="Year", 
     ylab="Existing cases per 100K", 
     col = 1, 
     ylim=c(0,200))
for (i in 2:nrow(cluster5_clustering$centers)) {
    lines(xrange, cluster5_clustering$centers[i,],
    col = i)
}
legend(x=1990, y=200, 
       lty=1, cex = 0.5,
       ncol = 5,
       col=1:(nrow(cluster5_clustering$centers)+1),
       legend=paste0("Cluster 5.",1:nrow(cluster5_clustering$centers)))
```

![enter image description here](https://www.filepicker.io/api/file/ow3KTYtQUeB7l1SplZoe "enter image title here")

There are actually different tendencies in our data. We can see that there is a group of countries in our original Cluster 5 that is decreasing the number cases at a faster rate, trying to catch up with those countries with a lower number of existing TB cases per 100K.  


```r
rownames(subset(cluster5_df, cluster5_df$cluster==2))
```

```
##  [1] "Albania"                          "Algeria"                         
##  [3] "Anguilla"                         "Argentina"                       
##  [5] "Bahamas"                          "Belize"                          
##  [7] "Bulgaria"                         "Colombia"                        
##  [9] "Egypt"                            "Estonia"                         
## [11] "Fiji"                             "French Polynesia"                
## [13] "Hungary"                          "Iran"                            
## [15] "Japan"                            "Kuwait"                          
## [17] "Lebanon"                          "Libyan Arab Jamahiriya"          
## [19] "Mauritius"                        "Mexico"                          
## [21] "New Caledonia"                    "Panama"                          
## [23] "Poland"                           "Portugal"                        
## [25] "Saint Vincent and the Grenadines" "Samoa"                           
## [27] "Saudi Arabia"                     "Singapore"                       
## [29] "Slovakia"                         "Slovenia"                        
## [31] "Spain"                            "Syrian Arab Republic"            
## [33] "Macedonia, FYR"                   "Tonga"                           
## [35] "Tunisia"                          "Turkey"                          
## [37] "United Arab Emirates"             "Venezuela"                       
## [39] "West Bank and Gaza"
```

While the countries with less number of cases and also slower decreasing rate is.  


```r
rownames(subset(cluster5_df, cluster5_df$cluster==1))
```

```
##  [1] "American Samoa"           "Andorra"                 
##  [3] "Antigua and Barbuda"      "Australia"               
##  [5] "Austria"                  "Barbados"                
##  [7] "Belgium"                  "Bermuda"                 
##  [9] "British Virgin Islands"   "Canada"                  
## [11] "Cayman Islands"           "Chile"                   
## [13] "Cook Islands"             "Costa Rica"              
## [15] "Cuba"                     "Cyprus"                  
## [17] "Czech Republic"           "Denmark"                 
## [19] "Dominica"                 "Finland"                 
## [21] "France"                   "Germany"                 
## [23] "Greece"                   "Grenada"                 
## [25] "Iceland"                  "Ireland"                 
## [27] "Israel"                   "Italy"                   
## [29] "Jamaica"                  "Jordan"                  
## [31] "Luxembourg"               "Malta"                   
## [33] "Monaco"                   "Montserrat"              
## [35] "Netherlands"              "Netherlands Antilles"    
## [37] "New Zealand"              "Norway"                  
## [39] "Oman"                     "Puerto Rico"             
## [41] "Saint Kitts and Nevis"    "Saint Lucia"             
## [43] "San Marino"               "Sweden"                  
## [45] "Switzerland"              "Trinidad and Tobago"     
## [47] "Turks and Caicos Islands" "United Kingdom"          
## [49] "Virgin Islands (U.S.)"    "United States of America"
## [51] "Uruguay"
```

However, we won't likely obtain this clusters by just increasing in 1 the number of centers in our first clustering process with the original dataset. As we said, Cluster 5 seemed like a very cohesive group when compared with more distant countries. This two step clustering process is a useful technique that we can use with any dataset we want to explore.  

## Conclusions  

I hope you enjoyed this data exploration as much as I did. We have seen how to use Python and R to perform Principal Componen Analysis and Clustering on our Tuberculosis data.   

The first technique allowed us to plot the distribution of all the countries in a two dimensional space based on their evolution of number of cases in a range of 18 years. by doing so we saw how the total number of cases mostly defines the principal component (i.e. the direction of largest variation) while the percentage of change in time affects the second component.  

Then we used k-means clustering to group countries by how similar their number of cases in each year are. By doing so we uncovered some interesting relationships and, most importantly, better understood the world situation regarding this important disease. We saw how most countries improved in the time lapse we considered, but we were also able to discover a group of countries with a high prevalence of the disease that, far from improving their situation, are increasing the number of cases.   
 
