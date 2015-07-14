## Motivation

These series of tutorials on Data Science will try to compare how different concepts
in the discipline can be implemented in the two dominant ecosystems nowadays: R and Python.
We will do this from a neutral point of view. Our opinion is that each environment has 
good and bad things, and any data scientist should know how to use both in order to be as 
prepared as posible for job market or to start personal project.  

To get a feeling of what is going on regarding this hot topic, we refer the reader to 
[DataCamp's Data Science War](http://blog.datacamp.com/r-or-python-for-data-analysis/)
infographic. Their infographic explores what the strengths of **R** are over **Python**
and vice versa, and aims to provide a basic comparison between these two programming 
languages from a data science and statistics perspective.  

Far from being a repetition from the previous, our series of tutorials will go hands-on
into how to actually perform different data science taks such as working with data frames,
doing aggregations, or creating different statistical models such in the areas of supervised
and unsupervised learning.  

As usual, we will use real-world datasets. This will help us to quickly transfer what we 
learn here to actual data analysis situations.  

The first tutorial in our series will deal the an important abstraction, that of a Data Frame.
In the very next tutorial we will introduce one of the first tasks we face when we have our data loaded, that of the Exploratory Data Analysis. This task can be performed using data frames and basic plots as we will show here for both, Python and R.    


## What is a DataFrame?  

A data frame is used for storing tabular data. It has labeled axes (rows and columns) that we can use to perform arithmetic operations at on levels.  

The concept was introduced in R before it was in Python [Pandas](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html) so the later repeats many of the ideas from the former. In R, a `data.frame` is a list of vector variables of the same number of elements (rows) with unique row names. That is, each column is a vector with an associated name, and each row is a series of vector elements that correspond to the same position in each of the column-vectors.  

In Pandas, a `DataFrame` can be thought of as a dict-like container for `Series` objects, where a `Series` is a one-dimensional [NumPy ndarray](http://docs.scipy.org/doc/numpy/reference/generated/numpy.ndarray.html) with axis labels (including time series). By default, each `Series` correspond with a column in the resulting `DataFrame`.  

But let's see both data types in practice. First of all we will introduce a data set that will be used in order to explain the data frame creation process and what data analysis tasks can be done with a data frame. Then we will have a separate section for each platform repeating every task for you to be able to move from one to the other easily in the future.     

## Introducing Gapminder World datasets  

The [Gapminder website](http://www.gapminder.org/) presents itself as *a fact-based worldview*. It is a comprehensive resource for data regarding different countries and territories indicators. Its [Data section](http://www.gapminder.org/data/) contains a list of datasets that can be accessed as Google Spreadsheet pages (add `&output=csv` to download as CSV). Each indicator dataset is tagged with a *Data provider*, a *Category*, and a *Subcategory*.  

For this tutorial, we will use different datasets related to Infectious Tuberculosis:  

- [All TB deaths per 100K](https://docs.google.com/spreadsheets/d/12uWVH_IlmzJX_75bJ3IH5E-Gqx6-zfbDKNvZqYjUuso/pub?gid=0)    
- [TB estimated prevalence (existing cases) per 100K](https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0)  
- [TB estimated incidence (new cases) per 100K](https://docs.google.com/spreadsheets/d/1Pl51PcEGlO9Hp4Uh0x2_QM0xVb53p2UDBMPwcnSjFTk/pub?gid=0)  

First thing we need to do is to download the files for later use within our R and Python environments. There is a description of each dataset if we click in its title in the [list of datasets](http://www.gapminder.org/data/). When performing any data analysis task, it is essential to understand our data as much as possible, so go there and have a read. Basically each cell in the dataset contains the data related to the number of tuberculosis cases per 100K people during the given year (column) for each country or region (row).      

We will use these datasets to better understand the TB incidence in different regions in time.  

## Downloading files and reading CSV  

### Python  

Download Google Spreadsheet data as CSV.

```python
import urllib

tb_deaths_url_csv = 'https://docs.google.com/spreadsheets/d/12uWVH_IlmzJX_75bJ3IH5E-Gqx6-zfbDKNvZqYjUuso/pub?gid=0&output=CSV'
tb_existing_url_csv = 'https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0&output=csv'
tb_new_url_csv = 'https://docs.google.com/spreadsheets/d/1Pl51PcEGlO9Hp4Uh0x2_QM0xVb53p2UDBMPwcnSjFTk/pub?gid=0&output=csv'

local_tb_deaths_file = 'tb_deaths_100.csv'
local_tb_existing_file = 'tb_existing_100.csv'
local_tb_new_file = 'tb_new_100.csv'

deaths_f = urllib.urlretrieve(tb_deaths_url_csv, local_tb_deaths_file)
existing_f = urllib.urlretrieve(tb_existing_url_csv, local_tb_existing_file)
new_f = urllib.urlretrieve(tb_new_url_csv, local_tb_new_file)
```

Read CSV into `DataFrame` by using `read_csv()`. 

```python
import pandas as pd

deaths_df = pd.read_csv(local_tb_deaths_file, index_col = 0, thousands  = ',').T
existing_df = pd.read_csv(local_tb_existing_file, index_col = 0, thousands  = ',').T
new_df = pd.read_csv(local_tb_new_file, index_col = 0, thousands  = ',').T
```

We have specified `index_col` to be 0 since we want the country names to be the row labels. We also specified the `thousands` separator to be ',' so Pandas automatically parses cells as numbers. Then, we transpose the table to make the time series for each country correspond to each column.

We will concentrate on the existing cases for a while. We can use `head()` to check the first few lines.  

```python
existing_df.head()
```

| TB prevalence, all forms (per 100 000 population per year) | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|------------------------------------------------------------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| 1990                                                       | 436         | 42      | 45      | 42             | 39      | 514    | 38       | 16                  | 96        | 52      | ... | 35      | 114        | 278     | 46        | 365      | 126              | 55                 | 265   | 436    | 409      |
| 1991                                                       | 429         | 40      | 44      | 14             | 37      | 514    | 38       | 15                  | 91        | 49      | ... | 34      | 105        | 268     | 45        | 361      | 352              | 54                 | 261   | 456    | 417      |
| 1992                                                       | 422         | 41      | 44      | 4              | 35      | 513    | 37       | 15                  | 86        | 51      | ... | 33      | 102        | 259     | 44        | 358      | 64               | 54                 | 263   | 494    | 415      |
| 1993                                                       | 415         | 42      | 43      | 18             | 33      | 512    | 37       | 14                  | 82        | 55      | ... | 32      | 118        | 250     | 43        | 354      | 174              | 52                 | 253   | 526    | 419      |
| 1994                                                       | 407         | 42      | 43      | 17             | 32      | 510    | 36       | 13                  | 78        | 60      | ... | 31      | 116        | 242     | 42        | 350      | 172              | 52                 | 250   | 556    | 426      |

###### 5 rows × 207 columns



By using the attribute `columns` we can read and write column names.

```python
existing_df.columns
```

```python
Index([u'Afghanistan', u'Albania', u'Algeria', u'American Samoa', u'Andorra', u'Angola', u'Anguilla', u'Antigua and Barbuda', u'Argentina', u'Armenia', u'Australia', u'Austria', u'Azerbaijan', u'Bahamas', u'Bahrain', u'Bangladesh', u'Barbados', u'Belarus', u'Belgium', u'Belize', u'Benin', u'Bermuda', u'Bhutan', u'Bolivia', u'Bosnia and Herzegovina', u'Botswana', u'Brazil', u'British Virgin Islands', u'Brunei Darussalam', u'Bulgaria', u'Burkina Faso', u'Burundi', u'Cambodia', u'Cameroon', u'Canada', u'Cape Verde', u'Cayman Islands', u'Central African Republic', u'Chad', u'Chile', u'China', u'Colombia', u'Comoros', u'Congo, Rep.', u'Cook Islands', u'Costa Rica', u'Croatia', u'Cuba', u'Cyprus', u'Czech Republic', u'Cote dIvoire', u'Korea, Dem. Rep.', u'Congo, Dem. Rep.', u'Denmark', u'Djibouti', u'Dominica', u'Dominican Republic', u'Ecuador', u'Egypt', u'El Salvador', u'Equatorial Guinea', u'Eritrea', u'Estonia', u'Ethiopia', u'Fiji', u'Finland', u'France', u'French Polynesia', u'Gabon', u'Gambia', u'Georgia', u'Germany', u'Ghana', u'Greece', u'Grenada', u'Guam', u'Guatemala', u'Guinea', u'Guinea-Bissau', u'Guyana', u'Haiti', u'Honduras', u'Hungary', u'Iceland', u'India', u'Indonesia', u'Iran', u'Iraq', u'Ireland', u'Israel', u'Italy', u'Jamaica', u'Japan', u'Jordan', u'Kazakhstan', u'Kenya', u'Kiribati', u'Kuwait', u'Kyrgyzstan', u'Laos', ...], dtype='object')
```


Similarly, we can access row names by using `index`.

```python
existing_df.index
```

```python
Index([u'1990', u'1991', u'1992', u'1993', u'1994', u'1995', u'1996', u'1997', u'1998', u'1999', u'2000', u'2001', u'2002', u'2003', u'2004', u'2005', u'2006', u'2007'], dtype='object')
```


We will use them to assign proper names to our column and index names.

```python
deaths_df.index.names = ['year']
deaths_df.columns.names = ['country']
existing_df.index.names = ['year']
existing_df.columns.names = ['country']
new_df.index.names = ['year']
new_df.columns.names = ['country']
existing_df
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | 436         | 42      | 45      | 42             | 39      | 514    | 38       | 16                  | 96        | 52      | ... | 35      | 114        | 278     | 46        | 365      | 126              | 55                 | 265   | 436    | 409      |
| 1991    | 429         | 40      | 44      | 14             | 37      | 514    | 38       | 15                  | 91        | 49      | ... | 34      | 105        | 268     | 45        | 361      | 352              | 54                 | 261   | 456    | 417      |
| 1992    | 422         | 41      | 44      | 4              | 35      | 513    | 37       | 15                  | 86        | 51      | ... | 33      | 102        | 259     | 44        | 358      | 64               | 54                 | 263   | 494    | 415      |
| 1993    | 415         | 42      | 43      | 18             | 33      | 512    | 37       | 14                  | 82        | 55      | ... | 32      | 118        | 250     | 43        | 354      | 174              | 52                 | 253   | 526    | 419      |
| 1994    | 407         | 42      | 43      | 17             | 32      | 510    | 36       | 13                  | 78        | 60      | ... | 31      | 116        | 242     | 42        | 350      | 172              | 52                 | 250   | 556    | 426      |
| 1995    | 397         | 43      | 42      | 22             | 30      | 508    | 35       | 12                  | 74        | 68      | ... | 30      | 119        | 234     | 42        | 346      | 93               | 50                 | 244   | 585    | 439      |
| 1996    | 397         | 42      | 43      | 0              | 28      | 512    | 35       | 12                  | 71        | 74      | ... | 28      | 111        | 226     | 41        | 312      | 123              | 49                 | 233   | 602    | 453      |
| 1997    | 387         | 44      | 44      | 25             | 23      | 363    | 36       | 11                  | 67        | 75      | ... | 27      | 122        | 218     | 41        | 273      | 213              | 46                 | 207   | 626    | 481      |
| 1998    | 374         | 43      | 45      | 12             | 24      | 414    | 36       | 11                  | 63        | 74      | ... | 28      | 129        | 211     | 40        | 261      | 107              | 44                 | 194   | 634    | 392      |
| 1999    | 373         | 42      | 46      | 8              | 22      | 384    | 36       | 9                   | 58        | 86      | ... | 28      | 134        | 159     | 39        | 253      | 105              | 42                 | 175   | 657    | 430      |
| 2000    | 346         | 40      | 48      | 8              | 20      | 530    | 35       | 8                   | 52        | 94      | ... | 27      | 139        | 143     | 39        | 248      | 103              | 40                 | 164   | 658    | 479      |
| 2001    | 326         | 34      | 49      | 6              | 20      | 335    | 35       | 9                   | 51        | 99      | ... | 25      | 148        | 128     | 41        | 243      | 13               | 39                 | 154   | 680    | 523      |
| 2002    | 304         | 32      | 50      | 5              | 21      | 307    | 35       | 7                   | 42        | 97      | ... | 27      | 144        | 149     | 41        | 235      | 275              | 37                 | 149   | 517    | 571      |
| 2003    | 308         | 32      | 51      | 6              | 18      | 281    | 35       | 9                   | 41        | 91      | ... | 25      | 152        | 128     | 39        | 234      | 147              | 36                 | 146   | 478    | 632      |
| 2004    | 283         | 29      | 52      | 9              | 19      | 318    | 35       | 8                   | 39        | 85      | ... | 23      | 149        | 118     | 38        | 226      | 63               | 35                 | 138   | 468    | 652      |
| 2005    | 267         | 29      | 53      | 11             | 18      | 331    | 34       | 8                   | 39        | 79      | ... | 24      | 144        | 131     | 38        | 227      | 57               | 33                 | 137   | 453    | 680      |
| 2006    | 251         | 26      | 55      | 9              | 17      | 302    | 34       | 9                   | 37        | 79      | ... | 25      | 134        | 104     | 38        | 222      | 60               | 32                 | 135   | 422    | 699      |
| 2007    | 238         | 22      | 56      | 5              | 19      | 294    | 34       | 9                   | 35        | 81      | ... | 23      | 140        | 102     | 39        | 220      | 25               | 31                 | 130   | 387    | 714      |


### R  

In R we use `read.csv` to read CSV files into `data.frame` variables. Although the R function `read.csv` can work with URLs, https is a problem for R in many cases, so you need to use a package like RCurl to get around it.  


```r
library(RCurl)
```

```r
## Loading required package: bitops
```

```r
existing_cases_file <- getURL("https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0&output=csv")
existing_df <- read.csv(text = existing_cases_file, row.names=1, stringsAsFactor=F)
str(existing_df)
```

```r
## 'data.frame':	207 obs. of  18 variables:
##  $ X1990: chr  "436" "42" "45" "42" ...
##  $ X1991: chr  "429" "40" "44" "14" ...
##  $ X1992: chr  "422" "41" "44" "4" ...
##  $ X1993: chr  "415" "42" "43" "18" ...
##  $ X1994: chr  "407" "42" "43" "17" ...
##  $ X1995: chr  "397" "43" "42" "22" ...
##  $ X1996: int  397 42 43 0 28 512 35 12 71 74 ...
##  $ X1997: int  387 44 44 25 23 363 36 11 67 75 ...
##  $ X1998: int  374 43 45 12 24 414 36 11 63 74 ...
##  $ X1999: int  373 42 46 8 22 384 36 9 58 86 ...
##  $ X2000: int  346 40 48 8 20 530 35 8 52 94 ...
##  $ X2001: int  326 34 49 6 20 335 35 9 51 99 ...
##  $ X2002: int  304 32 50 5 21 307 35 7 42 97 ...
##  $ X2003: int  308 32 51 6 18 281 35 9 41 91 ...
##  $ X2004: chr  "283" "29" "52" "9" ...
##  $ X2005: chr  "267" "29" "53" "11" ...
##  $ X2006: chr  "251" "26" "55" "9" ...
##  $ X2007: chr  "238" "22" "56" "5" ...
```

The `str()` function in R gives us information about a variable type. In this case
we can see that, due to the `,` thousands separator,
some of the columns hasn't been parsed as numbers but as character.
If we want to properly work with our dataset we need to convert them to numbers.
Once we know a bit more about indexing and mapping functions, I promise you will be 
able to understand the following piece of code. By know let's say that we convert 
a column and assign it again to its reference in the data frame.    


```r
existing_df[c(1,2,3,4,5,6,15,16,17,18)] <- 
    lapply( existing_df[c(1,2,3,4,5,6,15,16,17,18)], 
            function(x) { as.integer(gsub(',', '', x) )})
str(existing_df)
```

```r
## 'data.frame':	207 obs. of  18 variables:
##  $ X1990: int  436 42 45 42 39 514 38 16 96 52 ...
##  $ X1991: int  429 40 44 14 37 514 38 15 91 49 ...
##  $ X1992: int  422 41 44 4 35 513 37 15 86 51 ...
##  $ X1993: int  415 42 43 18 33 512 37 14 82 55 ...
##  $ X1994: int  407 42 43 17 32 510 36 13 78 60 ...
##  $ X1995: int  397 43 42 22 30 508 35 12 74 68 ...
##  $ X1996: int  397 42 43 0 28 512 35 12 71 74 ...
##  $ X1997: int  387 44 44 25 23 363 36 11 67 75 ...
##  $ X1998: int  374 43 45 12 24 414 36 11 63 74 ...
##  $ X1999: int  373 42 46 8 22 384 36 9 58 86 ...
##  $ X2000: int  346 40 48 8 20 530 35 8 52 94 ...
##  $ X2001: int  326 34 49 6 20 335 35 9 51 99 ...
##  $ X2002: int  304 32 50 5 21 307 35 7 42 97 ...
##  $ X2003: int  308 32 51 6 18 281 35 9 41 91 ...
##  $ X2004: int  283 29 52 9 19 318 35 8 39 85 ...
##  $ X2005: int  267 29 53 11 18 331 34 8 39 79 ...
##  $ X2006: int  251 26 55 9 17 302 34 9 37 79 ...
##  $ X2007: int  238 22 56 5 19 294 34 9 35 81 ...
```

Everything looks fine now. But still our dataset is a bit tricky. If we have a 
look at what we got into the data frame with `head`  

```r
head(existing_df,3)
```

```r
##             X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999
## Afghanistan   436   429   422   415   407   397   397   387   374   373
## Albania        42    40    41    42    42    43    42    44    43    42
## Algeria        45    44    44    43    43    42    43    44    45    46
##             X2000 X2001 X2002 X2003 X2004 X2005 X2006 X2007
## Afghanistan   346   326   304   308   283   267   251   238
## Albania        40    34    32    32    29    29    26    22
## Algeria        48    49    50    51    52    53    55    56
```

and `nrow` and `ncol`


```r
nrow(existing_df)
```

```r
## [1] 207
```

```r
ncol(existing_df)
```

```r
## [1] 18
```

we see that we have a data frame with 207 observations, one for each country, and 19 variables or features, one for each year. This doesn't seem the most natural shape for this dataset. It is very unlikely that we will add new countries (observations or rows in this case) to the dataset, while is quite possible to add additional years (variables or columns in this case). If we keep it like it is, we will end up with a dataset that grows in features and not in observations, and that seems counterintuitive (and unpractical depending of the analysis we will want to do).  

We won't need to do this preprocessing all the time, but there we go. Thankfully, R as a function `t()` similar to the method `T` in Pandas, that allows us to traspose a `data.frame` variable. The result is given as a `matrix`, so we need to convert it to a data frame again by using `as.data.frame`.    


```r
# we will save the "trasposed" original verison for later use if needed
existing_df_t <- existing_df 
existing_df <- as.data.frame(t(existing_df))
head(existing_df,3)
```

```r
##       Afghanistan Albania Algeria American Samoa Andorra Angola Anguilla
## X1990         436      42      45             42      39    514       38
## X1991         429      40      44             14      37    514       38
## X1992         422      41      44              4      35    513       37
##       Antigua and Barbuda Argentina Armenia Australia Austria Azerbaijan
## X1990                  16        96      52         7      18         58
## X1991                  15        91      49         7      17         55
## X1992                  15        86      51         7      16         57
##       Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin
## X1990      54     120        639        8      62      16     65   140
## X1991      53     113        623        8      54      15     64   138
## X1992      52     108        608        7      59      15     62   135
##       Bermuda Bhutan Bolivia Bosnia and Herzegovina Botswana Brazil
## X1990      10    924     377                    160      344    124
## X1991      10    862     362                    156      355    119
## X1992       9    804     347                    154      351    114
##       British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso
## X1990                     32                91       43          179
## X1991                     30                91       48          196
## X1992                     28                91       54          208
##       Burundi Cambodia Cameroon Canada Cape Verde Cayman Islands
## X1990     288      928      188      7        449             10
## X1991     302      905      199      7        438             10
## X1992     292      881      200      7        428              9
##       Central African Republic Chad Chile China Colombia Comoros
## X1990                      318  251    45   327       88     188
## X1991                      336  272    41   321       85     177
## X1992                      342  282    38   315       82     167
##       Congo, Rep. Cook Islands Costa Rica Croatia Cuba Cyprus
## X1990         209            0         30     126   32     14
## X1991         222           10         28     123   29     13
## X1992         231           57         27     121   26     13
##       Czech Republic Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep.
## X1990             22           292              841              275
## X1991             22           304              828              306
## X1992             22           306              815              327
##       Denmark Djibouti Dominica Dominican Republic Ecuador Egypt
## X1990      12    1,485       24                183     282    48
## X1991      12    1,477       24                173     271    47
## X1992      11    1,463       24                164     259    47
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990         133               169     245      50      312   68      14
## X1991         126               181     245      50      337   65      12
## X1992         119               187     242      56      351   62      11
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990     21               67   359    350      51      15   533     30
## X1991     20               55   340    350      48      15   519     29
## X1992     19               91   325    349      50      14   502     27
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990       7  103       113    241           404     39   479      141
## X1991       7  101       111    248           403     43   464      133
## X1992       7   96       108    255           402     34   453      128
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990      67       5   586       443   50   88      19     11    11
## X1991      68       4   577       430   51   88      18     10    10
## X1992      70       4   566       417   56   88      18     10    10
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990      10    62     19         95   125    1,026     89         90
## X1991      10    60     18         87   120    1,006     84         93
## X1992      10    58     17         85   134      986     80         93
##       Laos Latvia Lebanon Lesotho Liberia Libyan Arab Jamahiriya Lithuania
## X1990  428     56      64     225     476                     46        64
## X1991  424     57      64     231     473                     45        66
## X1992  420     59      63     229     469                     45        71
##       Luxembourg Madagascar Malawi Malaysia Maldives Mali Malta Mauritania
## X1990         19        367    380      159      143  640    10        585
## X1991         18        368    376      158      130  631     9        587
## X1992         17        369    365      156      118  621     9        590
##       Mauritius Mexico Micronesia, Fed. Sts. Monaco Mongolia Montserrat
## X1990        53    101                   263      3      477         14
## X1991        51     93                   253      3      477         14
## X1992        50     86                   244      3      477         14
##       Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## X1990     134        287     411     650   170   629          11
## X1991     130        313     400     685   285   607          10
## X1992     127        328     389     687   280   585          10
##       Netherlands Antilles New Caledonia New Zealand Nicaragua Niger
## X1990                   28           112          10       145   317
## X1991                   27           107          10       137   318
## X1992                   25           104           9       129   319
##       Nigeria Niue Northern Mariana Islands Norway Oman Pakistan Palau
## X1990     282  118                      142      8   40      430    96
## X1991     307  115                      201      8   36      428    66
## X1992     321  113                      301      8   29      427    43
##       Panama Papua New Guinea Paraguay Peru Philippines Poland Portugal
## X1990     74              498       95  394         799     88       51
## X1991     73              498       93  368         783     87       49
## X1992     71              497       92  343         766     86       47
##       Puerto Rico Qatar Korea, Rep. Moldova Romania Russian Federation
## X1990          17    71         223     105     118                 69
## X1991          15    69         196      99     125                 64
## X1992          17    69         174     103     134                 70
##       Rwanda Saint Kitts and Nevis Saint Lucia
## X1990    190                    17          26
## X1991    211                    17          26
## X1992    226                    16          25
##       Saint Vincent and the Grenadines Samoa San Marino
## X1990                               45    36          9
## X1991                               45    35          9
## X1992                               44    34          8
##       Sao Tome and Principe Saudi Arabia Senegal Seychelles Sierra Leone
## X1990                   346           68     380        113          465
## X1991                   335           60     379        110          479
## X1992                   325           59     379        106          492
##       Singapore Slovakia Slovenia Solomon Islands Somalia South Africa
## X1990        52       55       66             625     597          769
## X1991        52       56       62             593     587          726
## X1992        53       59       59             563     577          676
##       Spain Sri Lanka Sudan Suriname Swaziland Sweden Switzerland
## X1990    44       109   409      109       629      5          14
## X1991    42       106   404      100       590      5          13
## X1992    40       104   402       79       527      6          12
##       Syrian Arab Republic Tajikistan Thailand Macedonia, FYR Timor-Leste
## X1990                   94        193      336             92         706
## X1991                   89        162      319             90         694
## X1992                   84        112      307             89         681
##       Togo Tokelau Tonga Trinidad and Tobago Tunisia Turkey Turkmenistan
## X1990  702     139    45                  17      49     83          105
## X1991  687     140    44                  17      46     79           99
## X1992  668     143    43                  17      49     77          101
##       Turks and Caicos Islands Tuvalu Uganda Ukraine United Arab Emirates
## X1990                       42    593    206      67                   47
## X1991                       40    573    313      64                   44
## X1992                       37    554    342      67                   42
##       United Kingdom Tanzania Virgin Islands (U.S.)
## X1990              9      215                    30
## X1991              9      228                    28
## X1992             10      240                    27
##       United States of America Uruguay Uzbekistan Vanuatu Venezuela
## X1990                        7      35        114     278        46
## X1991                        7      34        105     268        45
## X1992                        7      33        102     259        44
##       Viet Nam Wallis et Futuna West Bank and Gaza Yemen Zambia Zimbabwe
## X1990      365              126                 55   265    436      409
## X1991      361              352                 54   261    456      417
## X1992      358               64                 54   263    494      415
```

Row names are sort of what in Pandas we get when we use the attribute `.index` in a data frame.


```r
rownames(existing_df)
```

```r
##  [1] "X1990" "X1991" "X1992" "X1993" "X1994" "X1995" "X1996" "X1997"
##  [9] "X1998" "X1999" "X2000" "X2001" "X2002" "X2003" "X2004" "X2005"
## [17] "X2006" "X2007"
```

In our data frame we see we have weird names for them. Every year is prefixed with an X. This is so because they started as column names. From the definition of a `data.frame` in R, we know that each column is a vector with a variable name. A name in R cannot start with a digit, so R automatically prefixes numbers with the letter X. Right know we will leave it like it is since it doesn't really stop us from doing our analysis.  

In the case of column names, they pretty much correspond to Pandas `.columns` attribute in a data frame.  


```r
colnames(existing_df)
```

```r
##   [1] "Afghanistan"                      "Albania"                         
##   [3] "Algeria"                          "American Samoa"                  
##   [5] "Andorra"                          "Angola"                          
##   [7] "Anguilla"                         "Antigua and Barbuda"             
##   [9] "Argentina"                        "Armenia"                         
##  [11] "Australia"                        "Austria"                         
##  [13] "Azerbaijan"                       "Bahamas"                         
##  [15] "Bahrain"                          "Bangladesh"                      
##  [17] "Barbados"                         "Belarus"                         
##  [19] "Belgium"                          "Belize"                          
##  [21] "Benin"                            "Bermuda"                         
##  [23] "Bhutan"                           "Bolivia"                         
##  [25] "Bosnia and Herzegovina"           "Botswana"                        
##  [27] "Brazil"                           "British Virgin Islands"          
##  [29] "Brunei Darussalam"                "Bulgaria"                        
##  [31] "Burkina Faso"                     "Burundi"                         
##  [33] "Cambodia"                         "Cameroon"                        
##  [35] "Canada"                           "Cape Verde"                      
##  [37] "Cayman Islands"                   "Central African Republic"        
##  [39] "Chad"                             "Chile"                           
##  [41] "China"                            "Colombia"                        
##  [43] "Comoros"                          "Congo, Rep."                     
##  [45] "Cook Islands"                     "Costa Rica"                      
##  [47] "Croatia"                          "Cuba"                            
##  [49] "Cyprus"                           "Czech Republic"                  
##  [51] "Cote d'Ivoire"                    "Korea, Dem. Rep."                
##  [53] "Congo, Dem. Rep."                 "Denmark"                         
##  [55] "Djibouti"                         "Dominica"                        
##  [57] "Dominican Republic"               "Ecuador"                         
##  [59] "Egypt"                            "El Salvador"                     
##  [61] "Equatorial Guinea"                "Eritrea"                         
##  [63] "Estonia"                          "Ethiopia"                        
##  [65] "Fiji"                             "Finland"                         
##  [67] "France"                           "French Polynesia"                
##  [69] "Gabon"                            "Gambia"                          
##  [71] "Georgia"                          "Germany"                         
##  [73] "Ghana"                            "Greece"                          
##  [75] "Grenada"                          "Guam"                            
##  [77] "Guatemala"                        "Guinea"                          
##  [79] "Guinea-Bissau"                    "Guyana"                          
##  [81] "Haiti"                            "Honduras"                        
##  [83] "Hungary"                          "Iceland"                         
##  [85] "India"                            "Indonesia"                       
##  [87] "Iran"                             "Iraq"                            
##  [89] "Ireland"                          "Israel"                          
##  [91] "Italy"                            "Jamaica"                         
##  [93] "Japan"                            "Jordan"                          
##  [95] "Kazakhstan"                       "Kenya"                           
##  [97] "Kiribati"                         "Kuwait"                          
##  [99] "Kyrgyzstan"                       "Laos"                            
## [101] "Latvia"                           "Lebanon"                         
## [103] "Lesotho"                          "Liberia"                         
## [105] "Libyan Arab Jamahiriya"           "Lithuania"                       
## [107] "Luxembourg"                       "Madagascar"                      
## [109] "Malawi"                           "Malaysia"                        
## [111] "Maldives"                         "Mali"                            
## [113] "Malta"                            "Mauritania"                      
## [115] "Mauritius"                        "Mexico"                          
## [117] "Micronesia, Fed. Sts."            "Monaco"                          
## [119] "Mongolia"                         "Montserrat"                      
## [121] "Morocco"                          "Mozambique"                      
## [123] "Myanmar"                          "Namibia"                         
## [125] "Nauru"                            "Nepal"                           
## [127] "Netherlands"                      "Netherlands Antilles"            
## [129] "New Caledonia"                    "New Zealand"                     
## [131] "Nicaragua"                        "Niger"                           
## [133] "Nigeria"                          "Niue"                            
## [135] "Northern Mariana Islands"         "Norway"                          
## [137] "Oman"                             "Pakistan"                        
## [139] "Palau"                            "Panama"                          
## [141] "Papua New Guinea"                 "Paraguay"                        
## [143] "Peru"                             "Philippines"                     
## [145] "Poland"                           "Portugal"                        
## [147] "Puerto Rico"                      "Qatar"                           
## [149] "Korea, Rep."                      "Moldova"                         
## [151] "Romania"                          "Russian Federation"              
## [153] "Rwanda"                           "Saint Kitts and Nevis"           
## [155] "Saint Lucia"                      "Saint Vincent and the Grenadines"
## [157] "Samoa"                            "San Marino"                      
## [159] "Sao Tome and Principe"            "Saudi Arabia"                    
## [161] "Senegal"                          "Seychelles"                      
## [163] "Sierra Leone"                     "Singapore"                       
## [165] "Slovakia"                         "Slovenia"                        
## [167] "Solomon Islands"                  "Somalia"                         
## [169] "South Africa"                     "Spain"                           
## [171] "Sri Lanka"                        "Sudan"                           
## [173] "Suriname"                         "Swaziland"                       
## [175] "Sweden"                           "Switzerland"                     
## [177] "Syrian Arab Republic"             "Tajikistan"                      
## [179] "Thailand"                         "Macedonia, FYR"                  
## [181] "Timor-Leste"                      "Togo"                            
## [183] "Tokelau"                          "Tonga"                           
## [185] "Trinidad and Tobago"              "Tunisia"                         
## [187] "Turkey"                           "Turkmenistan"                    
## [189] "Turks and Caicos Islands"         "Tuvalu"                          
## [191] "Uganda"                           "Ukraine"                         
## [193] "United Arab Emirates"             "United Kingdom"                  
## [195] "Tanzania"                         "Virgin Islands (U.S.)"           
## [197] "United States of America"         "Uruguay"                         
## [199] "Uzbekistan"                       "Vanuatu"                         
## [201] "Venezuela"                        "Viet Nam"                        
## [203] "Wallis et Futuna"                 "West Bank and Gaza"              
## [205] "Yemen"                            "Zambia"                          
## [207] "Zimbabwe"
```

These two functions show a common idiom in R, where we use the same function to get a value and to assign it. For example, if we want to change row names we will do something like:

`colnames(existing_df) <- new_col_names`  

But as we said we will leave them as they are by now.  

## Data Indexing   

### Python  

There is a [whole section](http://pandas.pydata.org/pandas-docs/stable/indexing.html) devoted to indexing and selecting data in `DataFrames` in the oficial documentation. Let's apply them to our Tuberculosis cases dataframe.

We can acces each data frame `Series` object by using its column name, as with a Python dictionary. In our case we can access each country series by its name.  

```python
existing_df['United Kingdom']
```

```python
    year
    1990     9
    1991     9
    1992    10
    1993    10
    1994     9
    1995     9
    1996     9
    1997     9
    1998     9
    1999     9
    2000     9
    2001     9
    2002     9
    2003    10
    2004    10
    2005    11
    2006    11
    2007    12
    Name: United Kingdom, dtype: int64
```


Or just using the key value as an attribute.  

```python
 existing_df.Spain
```

```python
    year
    1990    44
    1991    42
    1992    40
    1993    37
    1994    35
    1995    34
    1996    33
    1997    30
    1998    30
    1999    28
    2000    27
    2001    26
    2002    26
    2003    25
    2004    24
    2005    24
    2006    24
    2007    23
    Name: Spain, dtype: int64
```


Or we can access multiple series passing their column names as a Python list.

```python
existing_df[['Spain', 'United Kingdom']]
```

| ountry | Spain | United Kingdom |
|--------|-------|----------------|
| year   |       |                |
| 1990   | 44    | 9              |
| 1991   | 42    | 9              |
| 1992   | 40    | 10             |
| 1993   | 37    | 10             |
| 1994   | 35    | 9              |
| 1995   | 34    | 9              |
| 1996   | 33    | 9              |
| 1997   | 30    | 9              |
| 1998   | 30    | 9              |
| 1999   | 28    | 9              |
| 2000   | 27    | 9              |
| 2001   | 26    | 9              |
| 2002   | 26    | 9              |
| 2003   | 25    | 10             |
| 2004   | 24    | 10             |
| 2005   | 24    | 11             |
| 2006   | 24    | 11             |
| 2007   | 23    | 12             |


We can also access individual cells as follows.

```python
existing_df.Spain['1990']
```

````python
    44
```


Or using any Python list indexing for slicing the series.

```python
existing_df[['Spain', 'United Kingdom']][0:5]
```

| country | Spain | United Kingdom |
|---------|-------|----------------|
| year    |       |                |
| 1990    | 44    | 9              |
| 1991    | 42    | 9              |
| 1992    | 40    | 10             |
| 1993    | 37    | 10             |
| 1994    | 35    | 9              |


With the whole DataFrame, slicing inside of [] slices the rows. This is provided largely as a convenience since it is such a common operation.

```python
existing_df[0:5]
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | 436         | 42      | 45      | 42             | 39      | 514    | 38       | 16                  | 96        | 52      | ... | 35      | 114        | 278     | 46        | 365      | 126              | 55                 | 265   | 436    | 409      |
| 1991    | 429         | 40      | 44      | 14             | 37      | 514    | 38       | 15                  | 91        | 49      | ... | 34      | 105        | 268     | 45        | 361      | 352              | 54                 | 261   | 456    | 417      |
| 1992    | 422         | 41      | 44      | 4              | 35      | 513    | 37       | 15                  | 86        | 51      | ... | 33      | 102        | 259     | 44        | 358      | 64               | 54                 | 263   | 494    | 415      |
| 1993    | 415         | 42      | 43      | 18             | 33      | 512    | 37       | 14                  | 82        | 55      | ... | 32      | 118        | 250     | 43        | 354      | 174              | 52                 | 253   | 526    | 419      |
| 1994    | 407         | 42      | 43      | 17             | 32      | 510    | 36       | 13                  | 78        | 60      | ... | 31      | 116        | 242     | 42        | 350      | 172              | 52                 | 250   | 556    | 426      |

######5 rows × 207 columns


### Indexing in production Python code

As stated in the official documentation, the Python and NumPy indexing operators [] and attribute operator . provide quick and easy access to pandas data structures across a wide range of use cases. This makes interactive work intuitive, as there’s little new to learn if you already know how to deal with Python dictionaries and NumPy arrays. However, since the type of the data to be accessed isn’t known in advance, directly using standard operators has some optimization limits. For production code, it is recommended that you take advantage of the optimized pandas data access methods exposed in this section.

For example, the `.iloc` method can be used for **positional** index access.

```python
existing_df.iloc[0:2]
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | 436         | 42      | 45      | 42             | 39      | 514    | 38       | 16                  | 96        | 52      | ... | 35      | 114        | 278     | 46        | 365      | 126              | 55                 | 265   | 436    | 409      |
| 1991    | 429         | 40      | 44      | 14             | 37      | 514    | 38       | 15                  | 91        | 49      | ... | 34      | 105        | 268     | 45        | 361      | 352              | 54                 | 261   | 456    | 417      |

######2 rows × 207 columns


While `.loc` is used for **label** access.

```python
existing_df.loc['1992':'2005']
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1992    | 422         | 41      | 44      | 4              | 35      | 513    | 37       | 15                  | 86        | 51      | ... | 33      | 102        | 259     | 44        | 358      | 64               | 54                 | 263   | 494    | 415      |
| 1993    | 415         | 42      | 43      | 18             | 33      | 512    | 37       | 14                  | 82        | 55      | ... | 32      | 118        | 250     | 43        | 354      | 174              | 52                 | 253   | 526    | 419      |
| 1994    | 407         | 42      | 43      | 17             | 32      | 510    | 36       | 13                  | 78        | 60      | ... | 31      | 116        | 242     | 42        | 350      | 172              | 52                 | 250   | 556    | 426      |
| 1995    | 397         | 43      | 42      | 22             | 30      | 508    | 35       | 12                  | 74        | 68      | ... | 30      | 119        | 234     | 42        | 346      | 93               | 50                 | 244   | 585    | 439      |
| 1996    | 397         | 42      | 43      | 0              | 28      | 512    | 35       | 12                  | 71        | 74      | ... | 28      | 111        | 226     | 41        | 312      | 123              | 49                 | 233   | 602    | 453      |
| 1997    | 387         | 44      | 44      | 25             | 23      | 363    | 36       | 11                  | 67        | 75      | ... | 27      | 122        | 218     | 41        | 273      | 213              | 46                 | 207   | 626    | 481      |
| 1998    | 374         | 43      | 45      | 12             | 24      | 414    | 36       | 11                  | 63        | 74      | ... | 28      | 129        | 211     | 40        | 261      | 107              | 44                 | 194   | 634    | 392      |
| 1999    | 373         | 42      | 46      | 8              | 22      | 384    | 36       | 9                   | 58        | 86      | ... | 28      | 134        | 159     | 39        | 253      | 105              | 42                 | 175   | 657    | 430      |
| 2000    | 346         | 40      | 48      | 8              | 20      | 530    | 35       | 8                   | 52        | 94      | ... | 27      | 139        | 143     | 39        | 248      | 103              | 40                 | 164   | 658    | 479      |
| 2001    | 326         | 34      | 49      | 6              | 20      | 335    | 35       | 9                   | 51        | 99      | ... | 25      | 148        | 128     | 41        | 243      | 13               | 39                 | 154   | 680    | 523      |
| 2002    | 304         | 32      | 50      | 5              | 21      | 307    | 35       | 7                   | 42        | 97      | ... | 27      | 144        | 149     | 41        | 235      | 275              | 37                 | 149   | 517    | 571      |
| 2003    | 308         | 32      | 51      | 6              | 18      | 281    | 35       | 9                   | 41        | 91      | ... | 25      | 152        | 128     | 39        | 234      | 147              | 36                 | 146   | 478    | 632      |
| 2004    | 283         | 29      | 52      | 9              | 19      | 318    | 35       | 8                   | 39        | 85      | ... | 23      | 149        | 118     | 38        | 226      | 63               | 35                 | 138   | 468    | 652      |
| 2005    | 267         | 29      | 53      | 11             | 18      | 331    | 34       | 8                   | 39        | 79      | ... | 24      | 144        | 131     | 38        | 227      | 57               | 33                 | 137   | 453    | 680      |

######14 rows × 207 columns


And we can combine that with series indexing by column.

```python
existing_df[['Spain','United Kingdom']].loc[['1992','1998','2005']]
```

| country | Spain | United Kingdom |
|---------|-------|----------------|
| 1992    | 40    | 10             |
| 1998    | 30    | 9              |
| 2005    | 24    | 11             |


### R  

Similarly to what we do in Pandas (actually Pandas is inspired in R), we can
access a `data.frame` column by its position.  

```r
existing_df[,1]
```

```r
## X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999 X2000 X2001 
##   436   429   422   415   407   397   397   387   374   373   346   326 
## X2002 X2003 X2004 X2005 X2006 X2007 
##   304   308   283   267   251   238 
## 17 Levels: 238 251 267 283 304 308 326 346 373 374 387 397 407 415 ... 436
```

The position-based indexing in `R` uses the first element for the row number and
the second one for the column one. If left blank, we are telling R to get all
the row/columns. In the previous example we retrieved all the rows for the first
column (Afghanistan) in the `data.frame`. And yes, R has a **1-based** indexing 
schema.  

Like in Pandas, we can use column names to access columns (series in Pandas).
However R `data.frame` variables aren't exactly object and we don't use the `.`
operator but the `$` that allows accessing labels within a list.  

```r
existing_df$Afghanistan
```

```r
## X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999 X2000 X2001 
##   436   429   422   415   407   397   397   387   374   373   346   326 
## X2002 X2003 X2004 X2005 X2006 X2007 
##   304   308   283   267   251   238 
## 17 Levels: 238 251 267 283 304 308 326 346 373 374 387 397 407 415 ... 436
```

An finally, since a `data.frame` is a list of elements (its columns), we can access
columns as list elements using the list indexing operator `[[]]`.  

```r
existing_df[[1]]
```

```r
## X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999 X2000 X2001 
##   436   429   422   415   407   397   397   387   374   373   346   326 
## X2002 X2003 X2004 X2005 X2006 X2007 
##   304   308   283   267   251   238 
## 17 Levels: 238 251 267 283 304 308 326 346 373 374 387 397 407 415 ... 436
```

At this point you should have realised that in R there are multiple ways of doing
the same thing, and that this seems to happen more because of the language itself
than because somebody wanted to provide different ways of doing things. This strongly
contrasts with Python's philosophy of having one clear way of doing things (the 
Pythonic way).  

For row indexing we have the positional approach.  


```r
existing_df[1,]
```

```r
##       Afghanistan Albania Algeria American Samoa Andorra Angola Anguilla
## X1990         436      42      45             42      39    514       38
##       Antigua and Barbuda Argentina Armenia Australia Austria Azerbaijan
## X1990                  16        96      52         7      18         58
##       Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin
## X1990      54     120        639        8      62      16     65   140
##       Bermuda Bhutan Bolivia Bosnia and Herzegovina Botswana Brazil
## X1990      10    924     377                    160      344    124
##       British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso
## X1990                     32                91       43          179
##       Burundi Cambodia Cameroon Canada Cape Verde Cayman Islands
## X1990     288      928      188      7        449             10
##       Central African Republic Chad Chile China Colombia Comoros
## X1990                      318  251    45   327       88     188
##       Congo, Rep. Cook Islands Costa Rica Croatia Cuba Cyprus
## X1990         209            0         30     126   32     14
##       Czech Republic Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep.
## X1990             22           292              841              275
##       Denmark Djibouti Dominica Dominican Republic Ecuador Egypt
## X1990      12    1,485       24                183     282    48
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990         133               169     245      50      312   68      14
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990     21               67   359    350      51      15   533     30
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990       7  103       113    241           404     39   479      141
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990      67       5   586       443   50   88      19     11    11
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990      10    62     19         95   125    1,026     89         90
##       Laos Latvia Lebanon Lesotho Liberia Libyan Arab Jamahiriya Lithuania
## X1990  428     56      64     225     476                     46        64
##       Luxembourg Madagascar Malawi Malaysia Maldives Mali Malta Mauritania
## X1990         19        367    380      159      143  640    10        585
##       Mauritius Mexico Micronesia, Fed. Sts. Monaco Mongolia Montserrat
## X1990        53    101                   263      3      477         14
##       Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## X1990     134        287     411     650   170   629          11
##       Netherlands Antilles New Caledonia New Zealand Nicaragua Niger
## X1990                   28           112          10       145   317
##       Nigeria Niue Northern Mariana Islands Norway Oman Pakistan Palau
## X1990     282  118                      142      8   40      430    96
##       Panama Papua New Guinea Paraguay Peru Philippines Poland Portugal
## X1990     74              498       95  394         799     88       51
##       Puerto Rico Qatar Korea, Rep. Moldova Romania Russian Federation
## X1990          17    71         223     105     118                 69
##       Rwanda Saint Kitts and Nevis Saint Lucia
## X1990    190                    17          26
##       Saint Vincent and the Grenadines Samoa San Marino
## X1990                               45    36          9
##       Sao Tome and Principe Saudi Arabia Senegal Seychelles Sierra Leone
## X1990                   346           68     380        113          465
##       Singapore Slovakia Slovenia Solomon Islands Somalia South Africa
## X1990        52       55       66             625     597          769
##       Spain Sri Lanka Sudan Suriname Swaziland Sweden Switzerland
## X1990    44       109   409      109       629      5          14
##       Syrian Arab Republic Tajikistan Thailand Macedonia, FYR Timor-Leste
## X1990                   94        193      336             92         706
##       Togo Tokelau Tonga Trinidad and Tobago Tunisia Turkey Turkmenistan
## X1990  702     139    45                  17      49     83          105
##       Turks and Caicos Islands Tuvalu Uganda Ukraine United Arab Emirates
## X1990                       42    593    206      67                   47
##       United Kingdom Tanzania Virgin Islands (U.S.)
## X1990              9      215                    30
##       United States of America Uruguay Uzbekistan Vanuatu Venezuela
## X1990                        7      35        114     278        46
##       Viet Nam Wallis et Futuna West Bank and Gaza Yemen Zambia Zimbabwe
## X1990      365              126                 55   265    436      409
```

There we retrieved data for every country in 1990. We can combine this with a
column number.  


```r
existing_df[1,1]
```

```r
## X1990 
##   436 
## 17 Levels: 238 251 267 283 304 308 326 346 373 374 387 397 407 415 ... 436
```

Or its name.  


```r
existing_df$Afghanistan[1]
```

```r
## X1990 
##   436 
## 17 Levels: 238 251 267 283 304 308 326 346 373 374 387 397 407 415 ... 436
```

What did just do before? Basically we retrieved a column, that is a vector, and
accessed that vector first element. That way we got the value for Afghanistan for
the year 1990. We can do the same thing using the `[[]]` operator instead of the
list element label.  


```r
existing_df[[1]][1]
```

```r
## X1990 
##   436 
## 17 Levels: 238 251 267 283 304 308 326 346 373 374 387 397 407 415 ... 436
```

We can also select multiple columns and/or rows by passing R vectors.  


```r
existing_df[c(3,9,16),c(170,194)]
```

```r
##       Spain United Kingdom
## X1992    40             10
## X1998    30              9
## X2005    24             11
```

Finally, using names is also possible when using positional indexing.  


```r
existing_df["X1992","Spain"]
```

```r
## X1992 
##    40 
## Levels:  25  26  27  28  30  33 23 24 34 35 37 40 42 44
```

That we can combine with vectors.  


```r
existing_df[c("X1992", "X1998", "X2005"), c("Spain", "United Kingdom")]
```

```r
##       Spain United Kingdom
## X1992    40             10
## X1998    30              9
## X2005    24             11
```

So enough about indexing. In the [next[part of the tutorial on data frames]() we will see how to perform more complex data accessing using selection.  Additionally, we will explain how to apply functions to a data frame elements, and how to group them.  

