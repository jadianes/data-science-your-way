# Data Frames  

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

deaths_f = urllib.request.urlretrieve(tb_deaths_url_csv, local_tb_deaths_file)
existing_f = urllib.request.urlretrieve(tb_existing_url_csv, local_tb_existing_file)
new_f = urllib.request.urlretrieve(tb_new_url_csv, local_tb_new_file)
```

Read CSV into `DataFrame` by using `read_csv()`. 


```python
import pandas as pd

deaths_df = pd.read_csv(local_tb_deaths_file, index_col = 0, thousands  = ',').T
existing_df = pd.read_csv(local_tb_existing_file, index_col = 0, thousands  = ',').T
new_df = pd.read_csv(local_tb_new_file, index_col = 0, thousands  = ',').T
```

We have specified `index_col` to be 0 since we want the country names to be the row labels. We also specified the `thousands` separator to be ',' so Pandas automatially parses cells as numbers. Then, we `traspose()` the table to make the time series for each country correspond to each column.

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
existing_df.loc[['1992','1998','2005'],['Spain','United Kingdom']]
```

| country | Spain | United Kingdom |
|---------|-------|----------------|
| 1992    | 40    | 10             |
| 1998    | 30    | 9              |
| 2005    | 24    | 11             |

This last approach is the recommended when using Pandas data frames, specially when doing assignments (something we are not doing here). Otherwise, we might have assignment problems as described [here](http://pandas-docs.github.io/pandas-docs-travis/indexing.html#why-does-the-assignment-when-using-chained-indexing-fail).

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

So enough about indexing. In the next section we will see how to perform more complex data accessing using selection.  Additionally, we will explain how to apply functions to a data frame elements, and how to group them.  

## Data Selection  

We continue here our [tutorial on data frames with python and R](). The first part introduced the concepts of Data Frame and explained how to create them and index them in Python and R. This part will concentrate on data selection and function mapping.  

## Data Selection   

In this section we will show how to select data from data frames based on their values, by using logical expressions.

### Python  

With Pandas, we can use logical expression to select just data that satisfy certain conditions. So first, let's see what happens when we use logical operators with data frames or series objects.  

```python
existing_df>10
```


| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1991    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1992    | True        | True    | True    | False          | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1993    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1994    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1995    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1996    | True        | True    | True    | False          | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1997    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1998    | True        | True    | True    | True           | True    | True   | True     | True                | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 1999    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2000    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2001    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2002    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2003    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2004    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2005    | True        | True    | True    | True           | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2006    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |
| 2007    | True        | True    | True    | False          | True    | True   | True     | False               | True      | True    | ... | True    | True       | True    | True      | True     | True             | True               | True  | True   | True     |

######18 rows × 207 columns  


And if applied to individual series.

```python
existing_df['United Kingdom'] > 10
```

```python
    year
    1990    False
    1991    False
    1992    False
    1993    False
    1994    False
    1995    False
    1996    False
    1997    False
    1998    False
    1999    False
    2000    False
    2001    False
    2002    False
    2003    False
    2004    False
    2005     True
    2006     True
    2007     True
    Name: United Kingdom, dtype: bool
```

The result of these expressions can be used as a indexing vector (with `[]` or `.iloc') as follows.

```python
existing_df.Spain[existing_df['United Kingdom'] > 10]
```

```python
    year
    2005    24
    2006    24
    2007    23
    Name: Spain, dtype: int64
```


An interesting case happens when indexing several series and some of them happen to have `False` as index and other `True` at the same position. For example:

```python
existing_df[ existing_df > 10 ]
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | 436         | 42      | 45      | 42             | 39      | 514    | 38       | 16                  | 96        | 52      | ... | 35      | 114        | 278     | 46        | 365      | 126              | 55                 | 265   | 436    | 409      |
| 1991    | 429         | 40      | 44      | 14             | 37      | 514    | 38       | 15                  | 91        | 49      | ... | 34      | 105        | 268     | 45        | 361      | 352              | 54                 | 261   | 456    | 417      |
| 1992    | 422         | 41      | 44      | NaN            | 35      | 513    | 37       | 15                  | 86        | 51      | ... | 33      | 102        | 259     | 44        | 358      | 64               | 54                 | 263   | 494    | 415      |
| 1993    | 415         | 42      | 43      | 18             | 33      | 512    | 37       | 14                  | 82        | 55      | ... | 32      | 118        | 250     | 43        | 354      | 174              | 52                 | 253   | 526    | 419      |
| 1994    | 407         | 42      | 43      | 17             | 32      | 510    | 36       | 13                  | 78        | 60      | ... | 31      | 116        | 242     | 42        | 350      | 172              | 52                 | 250   | 556    | 426      |
| 1995    | 397         | 43      | 42      | 22             | 30      | 508    | 35       | 12                  | 74        | 68      | ... | 30      | 119        | 234     | 42        | 346      | 93               | 50                 | 244   | 585    | 439      |
| 1996    | 397         | 42      | 43      | NaN            | 28      | 512    | 35       | 12                  | 71        | 74      | ... | 28      | 111        | 226     | 41        | 312      | 123              | 49                 | 233   | 602    | 453      |
| 1997    | 387         | 44      | 44      | 25             | 23      | 363    | 36       | 11                  | 67        | 75      | ... | 27      | 122        | 218     | 41        | 273      | 213              | 46                 | 207   | 626    | 481      |
| 1998    | 374         | 43      | 45      | 12             | 24      | 414    | 36       | 11                  | 63        | 74      | ... | 28      | 129        | 211     | 40        | 261      | 107              | 44                 | 194   | 634    | 392      |
| 1999    | 373         | 42      | 46      | NaN            | 22      | 384    | 36       | NaN                 | 58        | 86      | ... | 28      | 134        | 159     | 39        | 253      | 105              | 42                 | 175   | 657    | 430      |
| 2000    | 346         | 40      | 48      | NaN            | 20      | 530    | 35       | NaN                 | 52        | 94      | ... | 27      | 139        | 143     | 39        | 248      | 103              | 40                 | 164   | 658    | 479      |
| 2001    | 326         | 34      | 49      | NaN            | 20      | 335    | 35       | NaN                 | 51        | 99      | ... | 25      | 148        | 128     | 41        | 243      | 13               | 39                 | 154   | 680    | 523      |
| 2002    | 304         | 32      | 50      | NaN            | 21      | 307    | 35       | NaN                 | 42        | 97      | ... | 27      | 144        | 149     | 41        | 235      | 275              | 37                 | 149   | 517    | 571      |
| 2003    | 308         | 32      | 51      | NaN            | 18      | 281    | 35       | NaN                 | 41        | 91      | ... | 25      | 152        | 128     | 39        | 234      | 147              | 36                 | 146   | 478    | 632      |
| 2004    | 283         | 29      | 52      | NaN            | 19      | 318    | 35       | NaN                 | 39        | 85      | ... | 23      | 149        | 118     | 38        | 226      | 63               | 35                 | 138   | 468    | 652      |
| 2005    | 267         | 29      | 53      | 11             | 18      | 331    | 34       | NaN                 | 39        | 79      | ... | 24      | 144        | 131     | 38        | 227      | 57               | 33                 | 137   | 453    | 680      |
| 2006    | 251         | 26      | 55      | NaN            | 17      | 302    | 34       | NaN                 | 37        | 79      | ... | 25      | 134        | 104     | 38        | 222      | 60               | 32                 | 135   | 422    | 699      |
| 2007    | 238         | 22      | 56      | NaN            | 19      | 294    | 34       | NaN                 | 35        | 81      | ... | 23      | 140        | 102     | 39        | 220      | 25               | 31                 | 130   | 387    | 714      |

######18 rows × 207 columns  


Those cells where `existing_df` doesn't happen to have more than 10 cases per 100K give `False` for indexing. The resulting data frame have a `NaN` value for those cells. A way of solving that (if we need to) is by using the `where()` method that, apart from providing a more expressive way of reading data selection, acceps a second argument that we can use to impute the `NaN` values. For example, if we want to have 0 as a value.

```python
existing_df.where(existing_df > 10, 0)
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | 436         | 42      | 45      | 42             | 39      | 514    | 38       | 16                  | 96        | 52      | ... | 35      | 114        | 278     | 46        | 365      | 126              | 55                 | 265   | 436    | 409      |
| 1991    | 429         | 40      | 44      | 14             | 37      | 514    | 38       | 15                  | 91        | 49      | ... | 34      | 105        | 268     | 45        | 361      | 352              | 54                 | 261   | 456    | 417      |
| 1992    | 422         | 41      | 44      | 0              | 35      | 513    | 37       | 15                  | 86        | 51      | ... | 33      | 102        | 259     | 44        | 358      | 64               | 54                 | 263   | 494    | 415      |
| 1993    | 415         | 42      | 43      | 18             | 33      | 512    | 37       | 14                  | 82        | 55      | ... | 32      | 118        | 250     | 43        | 354      | 174              | 52                 | 253   | 526    | 419      |
| 1994    | 407         | 42      | 43      | 17             | 32      | 510    | 36       | 13                  | 78        | 60      | ... | 31      | 116        | 242     | 42        | 350      | 172              | 52                 | 250   | 556    | 426      |
| 1995    | 397         | 43      | 42      | 22             | 30      | 508    | 35       | 12                  | 74        | 68      | ... | 30      | 119        | 234     | 42        | 346      | 93               | 50                 | 244   | 585    | 439      |
| 1996    | 397         | 42      | 43      | 0              | 28      | 512    | 35       | 12                  | 71        | 74      | ... | 28      | 111        | 226     | 41        | 312      | 123              | 49                 | 233   | 602    | 453      |
| 1997    | 387         | 44      | 44      | 25             | 23      | 363    | 36       | 11                  | 67        | 75      | ... | 27      | 122        | 218     | 41        | 273      | 213              | 46                 | 207   | 626    | 481      |
| 1998    | 374         | 43      | 45      | 12             | 24      | 414    | 36       | 11                  | 63        | 74      | ... | 28      | 129        | 211     | 40        | 261      | 107              | 44                 | 194   | 634    | 392      |
| 1999    | 373         | 42      | 46      | 0              | 22      | 384    | 36       | 0                   | 58        | 86      | ... | 28      | 134        | 159     | 39        | 253      | 105              | 42                 | 175   | 657    | 430      |
| 2000    | 346         | 40      | 48      | 0              | 20      | 530    | 35       | 0                   | 52        | 94      | ... | 27      | 139        | 143     | 39        | 248      | 103              | 40                 | 164   | 658    | 479      |
| 2001    | 326         | 34      | 49      | 0              | 20      | 335    | 35       | 0                   | 51        | 99      | ... | 25      | 148        | 128     | 41        | 243      | 13               | 39                 | 154   | 680    | 523      |
| 2002    | 304         | 32      | 50      | 0              | 21      | 307    | 35       | 0                   | 42        | 97      | ... | 27      | 144        | 149     | 41        | 235      | 275              | 37                 | 149   | 517    | 571      |
| 2003    | 308         | 32      | 51      | 0              | 18      | 281    | 35       | 0                   | 41        | 91      | ... | 25      | 152        | 128     | 39        | 234      | 147              | 36                 | 146   | 478    | 632      |
| 2004    | 283         | 29      | 52      | 0              | 19      | 318    | 35       | 0                   | 39        | 85      | ... | 23      | 149        | 118     | 38        | 226      | 63               | 35                 | 138   | 468    | 652      |
| 2005    | 267         | 29      | 53      | 11             | 18      | 331    | 34       | 0                   | 39        | 79      | ... | 24      | 144        | 131     | 38        | 227      | 57               | 33                 | 137   | 453    | 680      |
| 2006    | 251         | 26      | 55      | 0              | 17      | 302    | 34       | 0                   | 37        | 79      | ... | 25      | 134        | 104     | 38        | 222      | 60               | 32                 | 135   | 422    | 699      |
| 2007    | 238         | 22      | 56      | 0              | 19      | 294    | 34       | 0                   | 35        | 81      | ... | 23      | 140        | 102     | 39        | 220      | 25               | 31                 | 130   | 387    | 714      |

######18 rows × 207 columns  

### R  

As we did with Pandas, let's check the result of using a `data.frame` in a logical
or boolean expression.  


```r
existing_df_gt10 <- existing_df>10
existing_df_gt10
```

```r
##       Afghanistan Albania Algeria American Samoa Andorra Angola Anguilla
## X1990        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1991        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1992        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X1993        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1994        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1995        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1996        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X1997        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1998        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1999        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2000        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2001        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2002        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2003        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2004        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2005        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X2006        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
## X2007        TRUE    TRUE    TRUE          FALSE    TRUE   TRUE     TRUE
##       Antigua and Barbuda Argentina Armenia Australia Austria Azerbaijan
## X1990                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1991                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1992                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1993                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1994                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1995                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1996                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1997                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1998                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1999               FALSE      TRUE    TRUE     FALSE    TRUE       TRUE
## X2000               FALSE      TRUE    TRUE     FALSE    TRUE       TRUE
## X2001               FALSE      TRUE    TRUE     FALSE    TRUE       TRUE
## X2002               FALSE      TRUE    TRUE     FALSE    TRUE       TRUE
## X2003               FALSE      TRUE    TRUE     FALSE   FALSE       TRUE
## X2004               FALSE      TRUE    TRUE     FALSE   FALSE       TRUE
## X2005               FALSE      TRUE    TRUE     FALSE   FALSE       TRUE
## X2006               FALSE      TRUE    TRUE     FALSE   FALSE       TRUE
## X2007               FALSE      TRUE    TRUE     FALSE   FALSE       TRUE
##       Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin
## X1990    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1991    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1992    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1993    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1994    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1995    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1996    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1997    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1998    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1999    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2000    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2001    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2002    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2003    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2004    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2005    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X2006    TRUE    TRUE       TRUE    FALSE    TRUE   FALSE   TRUE  TRUE
## X2007    TRUE    TRUE       TRUE    FALSE    TRUE   FALSE   TRUE  TRUE
##       Bermuda Bhutan Bolivia Bosnia and Herzegovina Botswana Brazil
## X1990   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1991   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1992   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1993   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1994   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1995   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1996   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1997   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1998   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1999   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2000   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2001   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2002   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2003   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2004   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2005   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2006   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X2007   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
##       British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso
## X1990                   TRUE              TRUE     TRUE         TRUE
## X1991                   TRUE              TRUE     TRUE         TRUE
## X1992                   TRUE              TRUE     TRUE         TRUE
## X1993                   TRUE              TRUE     TRUE         TRUE
## X1994                   TRUE              TRUE     TRUE         TRUE
## X1995                   TRUE              TRUE     TRUE         TRUE
## X1996                   TRUE              TRUE     TRUE         TRUE
## X1997                   TRUE              TRUE     TRUE         TRUE
## X1998                   TRUE              TRUE     TRUE         TRUE
## X1999                   TRUE              TRUE     TRUE         TRUE
## X2000                   TRUE              TRUE     TRUE         TRUE
## X2001                   TRUE              TRUE     TRUE         TRUE
## X2002                   TRUE              TRUE     TRUE         TRUE
## X2003                   TRUE              TRUE     TRUE         TRUE
## X2004                   TRUE              TRUE     TRUE         TRUE
## X2005                   TRUE              TRUE     TRUE         TRUE
## X2006                   TRUE              TRUE     TRUE         TRUE
## X2007                   TRUE              TRUE     TRUE         TRUE
##       Burundi Cambodia Cameroon Canada Cape Verde Cayman Islands
## X1990    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1991    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1992    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1993    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1994    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1995    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1996    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1997    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1998    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1999    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2000    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2001    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2002    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2003    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2004    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2005    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2006    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X2007    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
##       Central African Republic Chad Chile China Colombia Comoros
## X1990                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1991                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1992                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1993                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1994                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1995                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1996                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1997                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1998                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1999                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2000                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2001                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2002                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2003                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2004                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2005                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2006                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X2007                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
##       Congo, Rep. Cook Islands Costa Rica Croatia  Cuba Cyprus
## X1990        TRUE        FALSE       TRUE    TRUE  TRUE   TRUE
## X1991        TRUE        FALSE       TRUE    TRUE  TRUE   TRUE
## X1992        TRUE         TRUE       TRUE    TRUE  TRUE   TRUE
## X1993        TRUE         TRUE       TRUE    TRUE  TRUE   TRUE
## X1994        TRUE         TRUE       TRUE    TRUE  TRUE   TRUE
## X1995        TRUE         TRUE       TRUE    TRUE  TRUE   TRUE
## X1996        TRUE        FALSE       TRUE    TRUE  TRUE   TRUE
## X1997        TRUE         TRUE       TRUE    TRUE  TRUE  FALSE
## X1998        TRUE        FALSE       TRUE    TRUE  TRUE  FALSE
## X1999        TRUE         TRUE       TRUE    TRUE  TRUE  FALSE
## X2000        TRUE         TRUE       TRUE    TRUE  TRUE  FALSE
## X2001        TRUE         TRUE       TRUE    TRUE  TRUE  FALSE
## X2002        TRUE         TRUE       TRUE    TRUE  TRUE  FALSE
## X2003        TRUE        FALSE       TRUE    TRUE FALSE  FALSE
## X2004        TRUE         TRUE       TRUE    TRUE FALSE  FALSE
## X2005        TRUE        FALSE       TRUE    TRUE FALSE  FALSE
## X2006        TRUE         TRUE       TRUE    TRUE FALSE  FALSE
## X2007        TRUE         TRUE       TRUE    TRUE FALSE  FALSE
##       Czech Republic Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep.
## X1990           TRUE          TRUE             TRUE             TRUE
## X1991           TRUE          TRUE             TRUE             TRUE
## X1992           TRUE          TRUE             TRUE             TRUE
## X1993           TRUE          TRUE             TRUE             TRUE
## X1994           TRUE          TRUE             TRUE             TRUE
## X1995           TRUE          TRUE             TRUE             TRUE
## X1996           TRUE          TRUE             TRUE             TRUE
## X1997           TRUE          TRUE             TRUE             TRUE
## X1998           TRUE          TRUE             TRUE             TRUE
## X1999           TRUE          TRUE             TRUE             TRUE
## X2000           TRUE          TRUE             TRUE             TRUE
## X2001           TRUE          TRUE             TRUE             TRUE
## X2002           TRUE          TRUE             TRUE             TRUE
## X2003           TRUE          TRUE             TRUE             TRUE
## X2004           TRUE          TRUE             TRUE             TRUE
## X2005           TRUE          TRUE             TRUE             TRUE
## X2006          FALSE          TRUE             TRUE             TRUE
## X2007          FALSE          TRUE             TRUE             TRUE
##       Denmark Djibouti Dominica Dominican Republic Ecuador Egypt
## X1990    TRUE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1991    TRUE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1992    TRUE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1993   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1994   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1995   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1996   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1997   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1998   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1999   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2000   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2001   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2002   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2003   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2004   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2005   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2006   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
## X2007   FALSE     TRUE     TRUE               TRUE    TRUE  TRUE
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990        TRUE              TRUE    TRUE    TRUE     TRUE TRUE    TRUE
## X1991        TRUE              TRUE    TRUE    TRUE     TRUE TRUE    TRUE
## X1992        TRUE              TRUE    TRUE    TRUE     TRUE TRUE    TRUE
## X1993        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X1994        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X1995        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X1996        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X1997        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X1998        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X1999        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2000        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2001        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2002        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2003        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2004        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2005        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2006        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
## X2007        TRUE              TRUE    TRUE    TRUE     TRUE TRUE   FALSE
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1991   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1992   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1993   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1994   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1995   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1996   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1997   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1998   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1999   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2000   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2001   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2002   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2003   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2004   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2005   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2006   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
## X2007   TRUE             TRUE  TRUE   TRUE    TRUE   FALSE  TRUE   TRUE
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1991   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1992   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1993   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1994   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1995   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1996   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1997   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1998   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1999   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2000   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2001   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2002   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2003   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2004   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2005   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2006   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X2007   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE   TRUE  TRUE
## X1991    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1992    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1993    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1994    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1995    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1996    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1997    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1998    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X1999    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X2000    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X2001    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
## X2002    TRUE   FALSE  TRUE      TRUE TRUE TRUE   FALSE  FALSE FALSE
## X2003    TRUE   FALSE  TRUE      TRUE TRUE TRUE   FALSE  FALSE FALSE
## X2004    TRUE   FALSE  TRUE      TRUE TRUE TRUE   FALSE  FALSE FALSE
## X2005    TRUE   FALSE  TRUE      TRUE TRUE TRUE   FALSE  FALSE FALSE
## X2006    TRUE   FALSE  TRUE      TRUE TRUE TRUE   FALSE  FALSE FALSE
## X2007    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1991   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1992   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1993   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1994   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1995   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1996   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1997   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1998   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1999   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2000   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2001   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2002   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2003   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2004   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2005   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2006   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
## X2007   FALSE  TRUE  FALSE       TRUE  TRUE     TRUE   TRUE       TRUE
##       Laos Latvia Lebanon Lesotho Liberia Libyan Arab Jamahiriya Lithuania
## X1990 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1991 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1992 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1993 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1994 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1995 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1996 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1997 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1998 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1999 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2000 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2001 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2002 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2003 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2004 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2005 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2006 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X2007 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
##       Luxembourg Madagascar Malawi Malaysia Maldives Mali Malta Mauritania
## X1990       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1991       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1992       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1993       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1994       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1995       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1996       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1997       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1998       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1999       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2000       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2001       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2002       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2003      FALSE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2004      FALSE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2005      FALSE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2006      FALSE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X2007      FALSE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
##       Mauritius Mexico Micronesia, Fed. Sts. Monaco Mongolia Montserrat
## X1990      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1991      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1992      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1993      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1994      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1995      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1996      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1997      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1998      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1999      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X2000      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X2001      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X2002      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X2003      TRUE   TRUE                  TRUE  FALSE     TRUE      FALSE
## X2004      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X2005      TRUE   TRUE                  TRUE  FALSE     TRUE      FALSE
## X2006      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X2007      TRUE   TRUE                  TRUE  FALSE     TRUE      FALSE
##       Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## X1990    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE        TRUE
## X1991    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1992    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1993    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1994    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1995    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1996    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1997    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1998    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X1999    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2000    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2001    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2002    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2003    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2004    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2005    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2006    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
## X2007    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
##       Netherlands Antilles New Caledonia New Zealand Nicaragua Niger
## X1990                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1991                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1992                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1993                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1994                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1995                 TRUE          TRUE        TRUE      TRUE  TRUE
## X1996                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1997                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1998                 TRUE          TRUE        TRUE      TRUE  TRUE
## X1999                 TRUE          TRUE        TRUE      TRUE  TRUE
## X2000                 TRUE          TRUE        TRUE      TRUE  TRUE
## X2001                 TRUE          TRUE       FALSE      TRUE  TRUE
## X2002                 TRUE          TRUE       FALSE      TRUE  TRUE
## X2003                 TRUE          TRUE       FALSE      TRUE  TRUE
## X2004                 TRUE          TRUE       FALSE      TRUE  TRUE
## X2005                 TRUE          TRUE       FALSE      TRUE  TRUE
## X2006                 TRUE          TRUE       FALSE      TRUE  TRUE
## X2007                 TRUE          TRUE       FALSE      TRUE  TRUE
##       Nigeria  Niue Northern Mariana Islands Norway Oman Pakistan Palau
## X1990    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1991    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1992    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1993    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1994    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1995    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1996    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1997    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1998    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1999    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2000    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2001    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2002    TRUE  TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2003    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2004    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2005    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2006    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
## X2007    TRUE FALSE                     TRUE  FALSE TRUE     TRUE  TRUE
##       Panama Papua New Guinea Paraguay Peru Philippines Poland Portugal
## X1990   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1991   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1992   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1993   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1994   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1995   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1996   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1997   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1998   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1999   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2000   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2001   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2002   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2003   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2004   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2005   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2006   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X2007   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
##       Puerto Rico Qatar Korea, Rep. Moldova Romania Russian Federation
## X1990        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1991        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1992        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1993        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1994        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1995        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1996        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1997        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1998        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1999       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2000       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2001       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2002       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2003       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2004       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2005       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2006       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
## X2007       FALSE  TRUE        TRUE    TRUE    TRUE               TRUE
##       Rwanda Saint Kitts and Nevis Saint Lucia
## X1990   TRUE                  TRUE        TRUE
## X1991   TRUE                  TRUE        TRUE
## X1992   TRUE                  TRUE        TRUE
## X1993   TRUE                  TRUE        TRUE
## X1994   TRUE                  TRUE        TRUE
## X1995   TRUE                  TRUE        TRUE
## X1996   TRUE                  TRUE        TRUE
## X1997   TRUE                  TRUE        TRUE
## X1998   TRUE                  TRUE        TRUE
## X1999   TRUE                  TRUE        TRUE
## X2000   TRUE                  TRUE        TRUE
## X2001   TRUE                  TRUE        TRUE
## X2002   TRUE                  TRUE        TRUE
## X2003   TRUE                  TRUE        TRUE
## X2004   TRUE                  TRUE        TRUE
## X2005   TRUE                  TRUE        TRUE
## X2006   TRUE                  TRUE        TRUE
## X2007   TRUE                  TRUE        TRUE
##       Saint Vincent and the Grenadines Samoa San Marino
## X1990                             TRUE  TRUE      FALSE
## X1991                             TRUE  TRUE      FALSE
## X1992                             TRUE  TRUE      FALSE
## X1993                             TRUE  TRUE      FALSE
## X1994                             TRUE  TRUE      FALSE
## X1995                             TRUE  TRUE      FALSE
## X1996                             TRUE  TRUE      FALSE
## X1997                             TRUE  TRUE      FALSE
## X1998                             TRUE  TRUE      FALSE
## X1999                             TRUE  TRUE      FALSE
## X2000                             TRUE  TRUE      FALSE
## X2001                             TRUE  TRUE      FALSE
## X2002                             TRUE  TRUE      FALSE
## X2003                             TRUE  TRUE      FALSE
## X2004                             TRUE  TRUE      FALSE
## X2005                             TRUE  TRUE      FALSE
## X2006                             TRUE  TRUE      FALSE
## X2007                             TRUE  TRUE      FALSE
##       Sao Tome and Principe Saudi Arabia Senegal Seychelles Sierra Leone
## X1990                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1991                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1992                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1993                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1994                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1995                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1996                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1997                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1998                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1999                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2000                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2001                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2002                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2003                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2004                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2005                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2006                  TRUE         TRUE    TRUE       TRUE         TRUE
## X2007                  TRUE         TRUE    TRUE       TRUE         TRUE
##       Singapore Slovakia Slovenia Solomon Islands Somalia South Africa
## X1990      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1991      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1992      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1993      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1994      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1995      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1996      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1997      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1998      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1999      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2000      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2001      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2002      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2003      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2004      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2005      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2006      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X2007      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
##       Spain Sri Lanka Sudan Suriname Swaziland Sweden Switzerland
## X1990  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE        TRUE
## X1991  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE        TRUE
## X1992  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE        TRUE
## X1993  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE        TRUE
## X1994  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X1995  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X1996  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X1997  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X1998  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X1999  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2000  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2001  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2002  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2003  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2004  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2005  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2006  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
## X2007  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE       FALSE
##       Syrian Arab Republic Tajikistan Thailand Macedonia, FYR Timor-Leste
## X1990                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1991                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1992                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1993                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1994                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1995                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1996                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1997                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1998                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1999                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2000                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2001                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2002                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2003                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2004                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2005                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2006                 TRUE       TRUE     TRUE           TRUE        TRUE
## X2007                 TRUE       TRUE     TRUE           TRUE        TRUE
##       Togo Tokelau Tonga Trinidad and Tobago Tunisia Turkey Turkmenistan
## X1990 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1991 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1992 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1993 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1994 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1995 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1996 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1997 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1998 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1999 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2000 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2001 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2002 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2003 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2004 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2005 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2006 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
## X2007 TRUE   FALSE  TRUE                TRUE    TRUE   TRUE         TRUE
##       Turks and Caicos Islands Tuvalu Uganda Ukraine United Arab Emirates
## X1990                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1991                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1992                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1993                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1994                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1995                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1996                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1997                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1998                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1999                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2000                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2001                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2002                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2003                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2004                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2005                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2006                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X2007                     TRUE   TRUE   TRUE    TRUE                 TRUE
##       United Kingdom Tanzania Virgin Islands (U.S.)
## X1990          FALSE     TRUE                  TRUE
## X1991          FALSE     TRUE                  TRUE
## X1992          FALSE     TRUE                  TRUE
## X1993          FALSE     TRUE                  TRUE
## X1994          FALSE     TRUE                  TRUE
## X1995          FALSE     TRUE                  TRUE
## X1996          FALSE     TRUE                  TRUE
## X1997          FALSE     TRUE                  TRUE
## X1998          FALSE     TRUE                  TRUE
## X1999          FALSE     TRUE                  TRUE
## X2000          FALSE     TRUE                  TRUE
## X2001          FALSE     TRUE                  TRUE
## X2002          FALSE     TRUE                  TRUE
## X2003          FALSE     TRUE                  TRUE
## X2004          FALSE     TRUE                  TRUE
## X2005           TRUE     TRUE                  TRUE
## X2006           TRUE     TRUE                  TRUE
## X2007           TRUE     TRUE                  TRUE
##       United States of America Uruguay Uzbekistan Vanuatu Venezuela
## X1990                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1991                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1992                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1993                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1994                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1995                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1996                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1997                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1998                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1999                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2000                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2001                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2002                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2003                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2004                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2005                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2006                    FALSE    TRUE       TRUE    TRUE      TRUE
## X2007                    FALSE    TRUE       TRUE    TRUE      TRUE
##       Viet Nam Wallis et Futuna West Bank and Gaza Yemen Zambia Zimbabwe
## X1990     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1991     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1992     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1993     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1994     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1995     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1996     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1997     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1998     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1999     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2000     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2001     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2002     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2003     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2004     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2005     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2006     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X2007     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
```

In this case we get a `matrix` variable, with boolean values. When applied to
individual columns.  


```r
existing_df['United Kingdom'] > 10
```

```r
##       United Kingdom
## X1990          FALSE
## X1991          FALSE
## X1992          FALSE
## X1993          FALSE
## X1994          FALSE
## X1995          FALSE
## X1996          FALSE
## X1997          FALSE
## X1998          FALSE
## X1999          FALSE
## X2000          FALSE
## X2001          FALSE
## X2002          FALSE
## X2003          FALSE
## X2004          FALSE
## X2005           TRUE
## X2006           TRUE
## X2007           TRUE
```

The result (and the syntax) is equivalent to that of Pandas, and can be used for
indexing as follows.  


```r
existing_df$Spain[existing_df['United Kingdom'] > 10]
```

```r
## [1] 24 24 23
```

As we did in Python/Pandas, let's use the whole boolean matrix we got before.  


```r
existing_df[ existing_df_gt10 ]
```

```r
##    [1]  436  429  422  415  407  397  397  387  374  373  346  326  304
##   [14]  308  283  267  251  238   42   40   41   42   42   43   42   44
##   [27]   43   42   40   34   32   32   29   29   26   22   45   44   44
##   [40]   43   43   42   43   44   45   46   48   49   50   51   52   53
##   [53]   55   56   42   14   18   17   22   25   12   11   39   37   35
##   [66]   33   32   30   28   23   24   22   20   20   21   18   19   18
##   [79]   17   19  514  514  513  512  510  508  512  363  414  384  530
##   [92]  335  307  281  318  331  302  294   38   38   37   37   36   35
##  [105]   35   36   36   36   35   35   35   35   35   34   34   34   16
##  [118]   15   15   14   13   12   12   11   11   96   91   86   82   78
##  [131]   74   71   67   63   58   52   51   42   41   39   39   37   35
##  [144]   52   49   51   55   60   68   74   75   74   86   94   99   97
##  [157]   91   85   79   79   81   18   17   16   15   15   14   13   13
##  [170]   12   12   11   11   11   58   55   57   61   67   76   85   91
##  [183]  100  106  113  117   99  109   90   85   86   86   54   53   52
##  [196]   52   53   54   54   54   55   46   45   45   51   51   50   50
##  [209]   50   51  120  113  108  101   97   92   89   86   83   67   57
##  [222]   56   55   53   48   45   45   60  639  623  608  594  579  576
##  [235]  550  535  516  492  500  491  478  458  444  416  392  387   62
##  [248]   54   59   62   75   82   91   98  109  113  110  100   89   68
##  [261]   68   68   69   69   16   15   15   15   15   14   13   13   12
##  [274]   12   12   13   12   11   11   11   65   64   62   59   57   55
##  [287]   37   41   53   53   39   36   36   40   42   38   41   46  140
##  [300]  138  135  132  129  125  127  129  130  128  128  129  137  139
##  [313]  134  135  134  135  924  862  804  750  699  651  620  597  551
##  [326]  538  515  512  472  460  443  412  406  363  377  362  347  333
##  [339]  320  306  271  264  254  248  238  229  223  218  211  205  202
##  [352]  198  160  156  154  150  143  134  131  125   96   80   70   63
##  [365]   66   63   55   58   58   55  344  355  351  349  347  349  336
##  [378]  349  371  413  445  497  535  586  598  599  621  622  124  119
##  [391]  114  109  104  100   97   93   88   86   83   80   77   72   63
##  [404]   60   56   60   32   30   28   26   25   23   22   21   20   19
##  [417]   19   18   18   17   16   17   16   16   91   91   91   91   91
##  [430]   91   91   88   88   93  108   85   78   73   63   55   59   65
##  [443]   43   48   54   57   58   57   59   65   68   68   64   63   52
##  [456]   42   40   41   40   41  179  196  208  221  233  246  251  271
##  [469]  286  308  338  368  398  419  426  421  411  403  288  302  292
##  [482]  293  305  322  339  346  424  412  455  522  581  619  639  654
##  [495]  657  647  928  905  881  858  836  811  810  789  777  764  758
##  [508]  750  728  712  696  676  672  664  188  199  200  199  197  197
##  [521]  196  207  212  219  228  241  240  227  228  213  201  195  449
##  [534]  438  428  418  408  398  394  391  387  384  380  283  374  370
##  [547]  367  278  285  280  318  336  342  350  356  365  270  395  419
##  [560]  449  485  495  468  566  574  507  437  425  251  272  282  294
##  [573]  304  315  354  408  433  390  420  450  502  573  548  518  505
##  [586]  497   45   41   38   35   32   30   28   25   24   22   21   19
##  [599]   19   18   15   15   13   12  327  321  315  309  303  303  290
##  [612]  283  276  273  269  265  259  241  220  206  200  194   88   85
##  [625]   82   79   76   73   71   69   67   61   51   62   60   58   55
##  [638]   53   44   43  188  177  167  157  148  140  130  155  120  143
##  [651]  112  103  104  107   99   91   86   83  209  222  231  243  255
##  [664]  269  424  457  367  545  313  354  402  509  477  482  511  485
##  [677]   57   47   38   19   13   40   12   29   11   15   16   31   30
##  [690]   28   27   26   25   24   23   22   21   19   14   14   15   14
##  [703]   12   12   12   11  126  123  121  118  113  106  103  102   99
##  [716]   89   76   73   69   68   67   65   65   54   32   29   26   24
##  [729]   22   20   18   17   15   14   13   12   11   14   13   13   12
##  [742]   11   11   11   22   22   22   21   21   21   21   21   19   18
##  [755]   16   14   13   12   11   11  292  304  306  309  312  319  329
##  [768]  350  376  413  472  571  561  590  604  613  597  582  841  828
##  [781]  815  802  788  775  775  775  775  770  713  650  577  527  499
##  [794]  508  500  441  275  306  327  352  376  411  420  466  472  528
##  [807]  592  643  697  708  710  702  692  666   12   12   11 1485 1477
##  [820] 1463 1442 1414 1381  720  669  698  701  761  775  932  960 1034
##  [833] 1046 1093 1104   24   24   24   23   23   22   22   18   20   20
##  [846]   20   22   20   20   20   21   13   19  183  173  164  156  148
##  [859]  141  135  132  128  122  119  115  102   93   90   85   84   82
##  [872]  282  271  259  249  238  228  221  212  207  200  194  185  170
##  [885]  162  155  155  148  140   48   47   47   45   45   44   51   46
##  [898]   43   40   36   34   32   31   29   28   27   27  133  126  119
##  [911]  112  105   99   97   80   76   72   69   66   62   60   57   52
##  [924]   50   48  169  181  187  194  200  207  216  222  236  253  274
##  [937]  441  470  490  370  366  358  469  245  245  242  239  235  232
##  [950]  232  225  203  114  114  111  118  110  122  127  133  134   50
##  [963]   50   56   66   77   85   88   98  102  105   72   68   62   56
##  [976]   50   46   44   39  312  337  351  366  383  403  396  397  420
##  [989]  464  486  539  569  601  613  612  604  579   68   65   62   58
## [1002]   55   53   49   49   46   40   42   35   36   29   33   31   30
## [1015]   30   14   12   11   21   20   19   18   17   16   15   15   14
## [1028]   14   13   12   12   12   12   11   11   11   67   55   91   83
## [1041]   93  107   55   48   56   54   40   42   32   29   28   31   31
## [1054]   32  359  340  325  318  316  293  312  320  359  366  434  249
## [1067]  302  299  288  332  358  379  350  350  349  347  344  341  324
## [1080]  321  311  485  491  499  335  343  341  366  399  404   51   48
## [1093]   50   54   59   66   73  104   87   90   98   95   95   94   90
## [1106]   86   83   83   15   15   14   14   13   13   12   11   11  533
## [1119]  519  502  480  455  432  426  388  384  382  368  358  359  358
## [1132]  359  357  355  353   30   29   27   25   24   23   22   22   21
## [1145]   20   19   18   18   17   17   16   16   16  103  101   96  110
## [1158]  146   93   91   89   87   86   44   45   44   47   41   42   39
## [1171]   36  113  111  108  106  103  100   95   94   93   92   90   91
## [1184]   89   89   86   85   84   87  241  248  255  262  269  275  277
## [1197]  293  305  317  332  346  363  380  391  425  426  448  404  403
## [1210]  402  399  395  390  390  387  385  386  273  276  305  296  287
## [1223]  283  270  276   39   43   34   43   50   67   78   81   90   93
## [1236]   98  112  126  136  130  132  133  136  479  464  453  443  435
## [1249]  429  428  426  417  407  403  397  388  380  377  368  368  366
## [1262]  141  133  128  123  119  115  114  112  106   98   70   70   72
## [1275]   71   72   71   70   71   67   68   70   72   73   73   74   72
## [1288]   67   47   43   39   36   33   29   26   22   19  586  577  566
## [1301]  555  542  525  517  501  487  476  443  411  389  349  311  299
## [1314]  290  283  443  430  417  404  392  380  369  359  348  335  326
## [1327]  314  297  287  274  261  251  244   50   51   56   54   55   55
## [1340]   61   52   45   41   40   38   37   35   32   31   29   27   88
## [1353]   88   88   88   88   88   84   84   82   80   71   69   65   67
## [1366]   71   75   78   79   19   18   18   17   15   14   12   12   12
## [1379]   12   12   11   11   11   11   62   60   58   56   53   51   50
## [1392]   50   49   48   45   41   39   36   34   32   30   28   19   18
## [1405]   17   17   16   15   20   18   12   11   11   95   87   85   84
## [1418]   85   94  109  137  163  134  141  148  150  155  152  147  144
## [1431]  139  125  120  134  152  177  207  233  277  313  351  393  384
## [1444]  392  402  410  388  340  319 1026 1006  986  966  947  928  910
## [1457]  853  571  556  546  607  587  477  439  419  405  423   89   84
## [1470]   80   75   72   68   66   64   61   35   33   33   30   29   29
## [1483]   30   25   25   90   93   93   93  101  118  141  165  147  146
## [1496]  156  169  153  145  139  136  135  134  428  424  420  415  411
## [1509]  407  373  360  352  344  344  337  330  324  313  298  291  289
## [1522]   56   57   59   63   75   91   77   89   92   95   91   89   85
## [1535]   78   72   66   61   55   64   64   63   62   62   59   64   54
## [1548]   50   37   35   30   26   24   22   21   23   23  225  231  229
## [1561]  228  232  242  248  264  298  518  356  370  399  408  414  421
## [1574]  408  568  476  473  469  465  462  461  418  424  396  403  435
## [1587]  437  382  429  370  416  393  398   46   45   45   43   43   42
## [1600]   41   38   36   23   22   22   21   20   19   18   18   17   64
## [1613]   66   71   79   89   98  110  119  125  120  115   96   83   72
## [1626]   72   66   65   69   19   18   17   16   15   14   14   13   13
## [1639]   12   11   11   11  367  368  369  369  370  370  339  345  346
## [1652]  352  359  371  382  375  384  408  400  417  380  376  365  355
## [1665]  353  348  337  342  345  349  362  350  358  353  346  342  324
## [1678]  305  159  158  156  155  153  151  147  173  170  167  135  133
## [1691]  132  128  128  126  123  121  143  130  118  107   97   88   88
## [1704]  101   89   94   96   84   83   69   71   63   69   48  640  631
## [1717]  621  609  597  583  573  566  565  567  571  573  572  578  584
## [1730]  589  593  599  585  587  590  592  594  595  622  615  612  615
## [1743]  619  624  632  642  494  565  556  559   53   51   50   48   47
## [1756]   45   62   61   45   40   39   42   40   39   38   39   39   39
## [1769]  101   93   86   80   74   68   64   58   52   48   42   38   35
## [1782]   33   31   27   25   23  263  253  244  234  225  217  204  287
## [1795]  276  265  173  171  152  142  128  124  112  100  477  477  477
## [1808]  477  477  477  333  342  307  281  297  273  258  258  233  232
## [1821]  217  234   14   14   14   14   14   13   13   13   13   13   13
## [1834]   13   13   13   12  134  130  127  123  119  116  107  106  105
## [1847]   99   98   95   87   91   89   85   82   80  287  313  328  343
## [1860]  356  369  386  408  432  461  499  535  556  569  567  551  528
## [1873]  504  411  400  389  379  370  361  298  309  312  298  267  238
## [1886]  202  175  168  161  161  162  650  685  687  683  671  658  387
## [1899]  395  411  442  481  506  544  560  572  570  556  532  170  285
## [1912]  280  274   90  263  258  253  248   44   44   56   57   48  162
## [1925]  121  174   33  629  607  585  564  543  523  498  473  448  363
## [1938]  312  304  285  271  260  247  246  240   11   28   27   25   24
## [1951]   23   22   21   20   19   18   17   17   17   16   16   15   15
## [1964]   15  112  107  104   76   69   60   58   97   97   51   51   43
## [1977]   34   28   29   29   25   25   11   11   11   11  145  137  129
## [1990]  122  114  108  100   97   93   89   85   80   79   73   69   68
## [2003]   64   56  317  318  319  319  319  318  322  292  281  281  278
## [2016]  280  288  275  287  285  289  292  282  307  321  336  350  366
## [2029]  379  399  423  452  489  526  563  575  573  563  543  521  118
## [2042]  115  113  111  109  106  202  114  506  142  201  301  194  186
## [2055]  185  188  331  334  220  135  120   95   83   80   83   83   72
## [2068]   40   36   29   25   22   22   15   15   14   14   13   14   13
## [2081]   13   12   13   13   14  430  428  427  426  424  422  421  421
## [2094]  415  420  413  406  376  355  333  289  260  223   96   66   43
## [2107]  260  414  187   53   92   54  376  104  102   69   64   31  102
## [2120]   74   71   74   73   71   70   69   68   67   67   65   64   60
## [2133]   51   48   49   44   44   44   45  498  498  497  497  496  496
## [2146]  494  493  491  489  486  482  477  471  463  453  441  430   95
## [2159]   93   92   91   89   88   71   92   92   91   90   89   88   85
## [2172]   85   81   74   73  394  368  343  320  298  278  270  251  230
## [2185]  222  210  198  187  182  167  155  143  136  799  783  766  750
## [2198]  735  719  705  689  669  649  600  578  561  542  534  520  505
## [2211]  500   88   87   86   85   83   79   74   68   63   58   53   50
## [2224]   35   34   33   31   29   28   51   49   47   45   44   43   42
## [2237]   41   39   38   36   34   33   32   29   27   24   23   17   15
## [2250]   17   18   18   18   15   13   12   71   69   69   74   84   89
## [2263]   87   84   75   78   78   78   75   71   71   69   77   81  223
## [2276]  196  174  150  142  132  105   98   89  107  113  112  126  108
## [2289]  112  118  122  126  105   99  103  111  122  138  157  171  191
## [2302]  203  215  174  211  176  152  151  151  151  118  125  134  147
## [2315]  159  167  174  184  129  194  197  206  180  185  178  148  138
## [2328]  128   69   64   70   78   91  111  132  142  155  160  164  158
## [2341]  148  140  135  121  117  115  190  211  226  243  259  278  297
## [2354]  316  339  383  442  503  549  581  607  607  595  590   17   17
## [2367]   16   16   16   15   16   15   11   12   15   13   12   14   13
## [2380]   15   14   12   26   26   25   25   25   24   23   17   16   18
## [2393]   20   18   17   19   18   18   18   18   45   45   44   43   42
## [2406]   42   42   41   38   41   35   36   36   34   36   36   34   39
## [2419]   36   35   34   33   32   31   35   33   50   31   27   33   28
## [2432]   28   24   27   26   25  346  335  325  315  304  295  290  285
## [2445]  290  276  272  266  261  266  255  256  252  240   68   60   59
## [2458]   60   64   67   71   73   76   72   67   65   62   60   60   60
## [2471]   62   65  380  379  379  378  377  376  372  388  397  424  420
## [2484]  430  443  441  454  456  461  468  113  110  106  103  100   96
## [2497]   66   59   71   90   52   53   42   66   52   57   56   55  465
## [2510]  479  492  504  517  534  525  565  602  636  675  696  743  784
## [2523]  830  866  902  941   52   52   53   50   49   49   50   50   48
## [2536]   44   39   36   34   32   31   28   27   27   55   56   59   59
## [2549]   56   51   46   42   38   35   32   30   29   26   25   21   20
## [2562]   20   66   62   59   57   53   50   35   35   32   29   27   25
## [2575]   22   21   19   16   16   15  625  593  563  534  506  480  380
## [2588]  354  339  322  300  286  277  254  229  204  197  180  597  587
## [2601]  577  566  555  543  465  444  446  431  414  398  391  362  334
## [2614]  325  341  352  769  726  676  620  562  502  480  466  465  426
## [2627]  515  581  586  649  676  707  690  692   44   42   40   37   35
## [2640]   34   33   30   30   28   27   26   26   25   24   24   24   23
## [2653]  109  106  104  102   99   97  102   93   90   89  107   99   88
## [2666]   89   87   75   80   79  409  404  402  402  403  405  409  417
## [2679]  378  382  375  389  363  371  376  384  391  402  109  100   79
## [2692]   80   76   78   88  101  118  122  115  113  113  120  126  136
## [2705]  146  155  629  590  527  477  448  441  460  504  556  647  740
## [2718]  832  693  739  776  788  801  812   14   13   12   11   94   89
## [2731]   84   80   75   71   67   61   54   48   41   37   35   33   31
## [2744]   30   29   27  193  162  112   79   85  106  134  141  159  169
## [2757]  191  221  248  256  277  282  301  322  336  319  307  297  291
## [2770]  285  285  279  256  231  223  194  197  189  188  184  189  192
## [2783]   92   90   89   86   83   77   74   73   72   65   56   39   40
## [2796]   37   34   34   34   33  706  694  681  669  656  644  644  644
## [2809]  644  644  644  644  345  359  367  370  385  378  702  687  668
## [2822]  647  628  614  613  658  637  647  656  669  701  693  702  713
## [2835]  726  750  139  140  143  112  301  112  112  112  112   45   44
## [2848]   43   43   42   41   38   38   31   34   34   42   35   36   39
## [2861]   32   34   28   17   17   17   16   16   16   16   16   15   15
## [2874]   15   16   15   15   15   15   15   15   49   46   49   51   51
## [2887]   49   48   46   44   31   30   28   27   26   27   27   28   28
## [2900]   83   79   77   73   68   62   62   63   64   57   49   45   44
## [2913]   43   44   44   32   34  105   99  101   97   92   80   92  114
## [2926]  137  142  130  115  110  103   98   91   85   75   42   40   37
## [2939]   35   33   31   30   29   28   17   16   23   23   22   22   22
## [2952]   18   17  593  573  554  535  518  500  484  467  452  437  422
## [2965]  408  394  381  368  245  261  203  206  313  342  377  394  418
## [2978]  419  342  357  359  391  411  447  476  472  469  450  426   67
## [2991]   64   67   72   75   78   87   93  104  109  120  128  133  135
## [3004]  132  113   99  102   47   44   42   39   38   36   34   33   31
## [3017]   30   27   27   27   25   25   24   24   24   11   11   12  215
## [3030]  228  240  252  269  283  301  324  333  347  364  367  383  380
## [3043]  373  364  353  337   30   28   27   25   24   23   19   18   17
## [3056]   19   19   18   18   17   17   16   16   16   35   34   33   32
## [3069]   31   30   28   27   28   28   27   25   27   25   23   24   25
## [3082]   23  114  105  102  118  116  119  111  122  129  134  139  148
## [3095]  144  152  149  144  134  140  278  268  259  250  242  234  226
## [3108]  218  211  159  143  128  149  128  118  131  104  102   46   45
## [3121]   44   43   42   42   41   41   40   39   39   41   41   39   38
## [3134]   38   38   39  365  361  358  354  350  346  312  273  261  253
## [3147]  248  243  235  234  226  227  222  220  126  352   64  174  172
## [3160]   93  123  213  107  105  103   13  275  147   63   57   60   25
## [3173]   55   54   54   52   52   50   49   46   44   42   40   39   37
## [3186]   36   35   33   32   31  265  261  263  253  250  244  233  207
## [3199]  194  175  164  154  149  146  138  137  135  130  436  456  494
## [3212]  526  556  585  602  626  634  657  658  680  517  478  468  453
## [3225]  422  387  409  417  415  419  426  439  453  481  392  430  479
## [3238]  523  571  632  652  680  699  714
```

But hey, the results are quite different from what we would expect comming from
using Pandas. We got a long vector of values, not a data frame. The problem is 
that the `[ ]` operator, when passed a matrix, first coherces the data frame to a
matrix. Basically we cannot seamlessly work with R data.frames and boolean matrices
as we did with Pandas. We should instead index in both dimensions, columns and rows,
separatelly.  

But still, we can use matrix indexing with a data frame to replace elements.  


```r
existing_df_2 <- existing_df
existing_df_2[ existing_df_gt10 ] <- -1
head(existing_df_2)
```

```r
##       Afghanistan Albania Algeria American Samoa Andorra Angola Anguilla
## X1990          -1      -1      -1             -1      -1     -1       -1
## X1991          -1      -1      -1             -1      -1     -1       -1
## X1992          -1      -1      -1              4      -1     -1       -1
## X1993          -1      -1      -1             -1      -1     -1       -1
## X1994          -1      -1      -1             -1      -1     -1       -1
## X1995          -1      -1      -1             -1      -1     -1       -1
##       Antigua and Barbuda Argentina Armenia Australia Austria Azerbaijan
## X1990                  -1        -1      -1         7      -1         -1
## X1991                  -1        -1      -1         7      -1         -1
## X1992                  -1        -1      -1         7      -1         -1
## X1993                  -1        -1      -1         7      -1         -1
## X1994                  -1        -1      -1         7      -1         -1
## X1995                  -1        -1      -1         7      -1         -1
##       Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin
## X1990      -1      -1         -1        8      -1      -1     -1    -1
## X1991      -1      -1         -1        8      -1      -1     -1    -1
## X1992      -1      -1         -1        7      -1      -1     -1    -1
## X1993      -1      -1         -1        7      -1      -1     -1    -1
## X1994      -1      -1         -1        6      -1      -1     -1    -1
## X1995      -1      -1         -1        6      -1      -1     -1    -1
##       Bermuda Bhutan Bolivia Bosnia and Herzegovina Botswana Brazil
## X1990      10     -1      -1                     -1       -1     -1
## X1991      10     -1      -1                     -1       -1     -1
## X1992       9     -1      -1                     -1       -1     -1
## X1993       9     -1      -1                     -1       -1     -1
## X1994       8     -1      -1                     -1       -1     -1
## X1995       8     -1      -1                     -1       -1     -1
##       British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso
## X1990                     -1                -1       -1           -1
## X1991                     -1                -1       -1           -1
## X1992                     -1                -1       -1           -1
## X1993                     -1                -1       -1           -1
## X1994                     -1                -1       -1           -1
## X1995                     -1                -1       -1           -1
##       Burundi Cambodia Cameroon Canada Cape Verde Cayman Islands
## X1990      -1       -1       -1      7         -1             10
## X1991      -1       -1       -1      7         -1             10
## X1992      -1       -1       -1      7         -1              9
## X1993      -1       -1       -1      6         -1              9
## X1994      -1       -1       -1      6         -1              8
## X1995      -1       -1       -1      6         -1              8
##       Central African Republic Chad Chile China Colombia Comoros
## X1990                       -1   -1    -1    -1       -1      -1
## X1991                       -1   -1    -1    -1       -1      -1
## X1992                       -1   -1    -1    -1       -1      -1
## X1993                       -1   -1    -1    -1       -1      -1
## X1994                       -1   -1    -1    -1       -1      -1
## X1995                       -1   -1    -1    -1       -1      -1
##       Congo, Rep. Cook Islands Costa Rica Croatia Cuba Cyprus
## X1990          -1            0         -1      -1   -1     -1
## X1991          -1           10         -1      -1   -1     -1
## X1992          -1           -1         -1      -1   -1     -1
## X1993          -1           -1         -1      -1   -1     -1
## X1994          -1           -1         -1      -1   -1     -1
## X1995          -1           -1         -1      -1   -1     -1
##       Czech Republic Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep.
## X1990             -1            -1               -1               -1
## X1991             -1            -1               -1               -1
## X1992             -1            -1               -1               -1
## X1993             -1            -1               -1               -1
## X1994             -1            -1               -1               -1
## X1995             -1            -1               -1               -1
##       Denmark Djibouti Dominica Dominican Republic Ecuador Egypt
## X1990      -1       -1       -1                 -1      -1    -1
## X1991      -1       -1       -1                 -1      -1    -1
## X1992      -1       -1       -1                 -1      -1    -1
## X1993      10       -1       -1                 -1      -1    -1
## X1994      10       -1       -1                 -1      -1    -1
## X1995       9       -1       -1                 -1      -1    -1
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990          -1                -1      -1      -1       -1   -1      -1
## X1991          -1                -1      -1      -1       -1   -1      -1
## X1992          -1                -1      -1      -1       -1   -1      -1
## X1993          -1                -1      -1      -1       -1   -1      10
## X1994          -1                -1      -1      -1       -1   -1       9
## X1995          -1                -1      -1      -1       -1   -1      10
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990     -1               -1    -1     -1      -1      -1    -1     -1
## X1991     -1               -1    -1     -1      -1      -1    -1     -1
## X1992     -1               -1    -1     -1      -1      -1    -1     -1
## X1993     -1               -1    -1     -1      -1      -1    -1     -1
## X1994     -1               -1    -1     -1      -1      -1    -1     -1
## X1995     -1               -1    -1     -1      -1      -1    -1     -1
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990       7   -1        -1     -1            -1     -1    -1       -1
## X1991       7   -1        -1     -1            -1     -1    -1       -1
## X1992       7   -1        -1     -1            -1     -1    -1       -1
## X1993       7   -1        -1     -1            -1     -1    -1       -1
## X1994       7   -1        -1     -1            -1     -1    -1       -1
## X1995       7   -1        -1     -1            -1     -1    -1       -1
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990      -1       5    -1        -1   -1   -1      -1     -1    -1
## X1991      -1       4    -1        -1   -1   -1      -1     10    10
## X1992      -1       4    -1        -1   -1   -1      -1     10    10
## X1993      -1       4    -1        -1   -1   -1      -1      9     9
## X1994      -1       4    -1        -1   -1   -1      -1      9     9
## X1995      -1       4    -1        -1   -1   -1      -1      8     8
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990      10    -1     -1         -1    -1       -1     -1         -1
## X1991      10    -1     -1         -1    -1       -1     -1         -1
## X1992      10    -1     -1         -1    -1       -1     -1         -1
## X1993      10    -1     -1         -1    -1       -1     -1         -1
## X1994       9    -1     -1         -1    -1       -1     -1         -1
## X1995       9    -1     -1         -1    -1       -1     -1         -1
##       Laos Latvia Lebanon Lesotho Liberia Libyan Arab Jamahiriya Lithuania
## X1990   -1     -1      -1      -1      -1                     -1        -1
## X1991   -1     -1      -1      -1      -1                     -1        -1
## X1992   -1     -1      -1      -1      -1                     -1        -1
## X1993   -1     -1      -1      -1      -1                     -1        -1
## X1994   -1     -1      -1      -1      -1                     -1        -1
## X1995   -1     -1      -1      -1      -1                     -1        -1
##       Luxembourg Madagascar Malawi Malaysia Maldives Mali Malta Mauritania
## X1990         -1         -1     -1       -1       -1   -1    10         -1
## X1991         -1         -1     -1       -1       -1   -1     9         -1
## X1992         -1         -1     -1       -1       -1   -1     9         -1
## X1993         -1         -1     -1       -1       -1   -1     8         -1
## X1994         -1         -1     -1       -1       -1   -1     8         -1
## X1995         -1         -1     -1       -1       -1   -1     7         -1
##       Mauritius Mexico Micronesia, Fed. Sts. Monaco Mongolia Montserrat
## X1990        -1     -1                    -1      3       -1         -1
## X1991        -1     -1                    -1      3       -1         -1
## X1992        -1     -1                    -1      3       -1         -1
## X1993        -1     -1                    -1      3       -1         -1
## X1994        -1     -1                    -1      3       -1         -1
## X1995        -1     -1                    -1      3       -1         -1
##       Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## X1990      -1         -1      -1      -1    -1    -1          -1
## X1991      -1         -1      -1      -1    -1    -1          10
## X1992      -1         -1      -1      -1    -1    -1          10
## X1993      -1         -1      -1      -1    -1    -1           9
## X1994      -1         -1      -1      -1    -1    -1           9
## X1995      -1         -1      -1      -1    -1    -1           8
##       Netherlands Antilles New Caledonia New Zealand Nicaragua Niger
## X1990                   -1            -1          10        -1    -1
## X1991                   -1            -1          10        -1    -1
## X1992                   -1            -1           9        -1    -1
## X1993                   -1            -1           9        -1    -1
## X1994                   -1            -1          10        -1    -1
## X1995                   -1            -1          -1        -1    -1
##       Nigeria Niue Northern Mariana Islands Norway Oman Pakistan Palau
## X1990      -1   -1                       -1      8   -1       -1    -1
## X1991      -1   -1                       -1      8   -1       -1    -1
## X1992      -1   -1                       -1      8   -1       -1    -1
## X1993      -1   -1                       -1      7   -1       -1    -1
## X1994      -1   -1                       -1      7   -1       -1    -1
## X1995      -1   -1                       -1      6   -1       -1    -1
##       Panama Papua New Guinea Paraguay Peru Philippines Poland Portugal
## X1990     -1               -1       -1   -1          -1     -1       -1
## X1991     -1               -1       -1   -1          -1     -1       -1
## X1992     -1               -1       -1   -1          -1     -1       -1
## X1993     -1               -1       -1   -1          -1     -1       -1
## X1994     -1               -1       -1   -1          -1     -1       -1
## X1995     -1               -1       -1   -1          -1     -1       -1
##       Puerto Rico Qatar Korea, Rep. Moldova Romania Russian Federation
## X1990          -1    -1          -1      -1      -1                 -1
## X1991          -1    -1          -1      -1      -1                 -1
## X1992          -1    -1          -1      -1      -1                 -1
## X1993          -1    -1          -1      -1      -1                 -1
## X1994          -1    -1          -1      -1      -1                 -1
## X1995          -1    -1          -1      -1      -1                 -1
##       Rwanda Saint Kitts and Nevis Saint Lucia
## X1990     -1                    -1          -1
## X1991     -1                    -1          -1
## X1992     -1                    -1          -1
## X1993     -1                    -1          -1
## X1994     -1                    -1          -1
## X1995     -1                    -1          -1
##       Saint Vincent and the Grenadines Samoa San Marino
## X1990                               -1    -1          9
## X1991                               -1    -1          9
## X1992                               -1    -1          8
## X1993                               -1    -1          8
## X1994                               -1    -1          7
## X1995                               -1    -1          7
##       Sao Tome and Principe Saudi Arabia Senegal Seychelles Sierra Leone
## X1990                    -1           -1      -1         -1           -1
## X1991                    -1           -1      -1         -1           -1
## X1992                    -1           -1      -1         -1           -1
## X1993                    -1           -1      -1         -1           -1
## X1994                    -1           -1      -1         -1           -1
## X1995                    -1           -1      -1         -1           -1
##       Singapore Slovakia Slovenia Solomon Islands Somalia South Africa
## X1990        -1       -1       -1              -1      -1           -1
## X1991        -1       -1       -1              -1      -1           -1
## X1992        -1       -1       -1              -1      -1           -1
## X1993        -1       -1       -1              -1      -1           -1
## X1994        -1       -1       -1              -1      -1           -1
## X1995        -1       -1       -1              -1      -1           -1
##       Spain Sri Lanka Sudan Suriname Swaziland Sweden Switzerland
## X1990    -1        -1    -1       -1        -1      5          -1
## X1991    -1        -1    -1       -1        -1      5          -1
## X1992    -1        -1    -1       -1        -1      6          -1
## X1993    -1        -1    -1       -1        -1      6          -1
## X1994    -1        -1    -1       -1        -1      5          10
## X1995    -1        -1    -1       -1        -1      5          10
##       Syrian Arab Republic Tajikistan Thailand Macedonia, FYR Timor-Leste
## X1990                   -1         -1       -1             -1          -1
## X1991                   -1         -1       -1             -1          -1
## X1992                   -1         -1       -1             -1          -1
## X1993                   -1         -1       -1             -1          -1
## X1994                   -1         -1       -1             -1          -1
## X1995                   -1         -1       -1             -1          -1
##       Togo Tokelau Tonga Trinidad and Tobago Tunisia Turkey Turkmenistan
## X1990   -1      -1    -1                  -1      -1     -1           -1
## X1991   -1      -1    -1                  -1      -1     -1           -1
## X1992   -1      -1    -1                  -1      -1     -1           -1
## X1993   -1      -1    -1                  -1      -1     -1           -1
## X1994   -1       0    -1                  -1      -1     -1           -1
## X1995   -1      -1    -1                  -1      -1     -1           -1
##       Turks and Caicos Islands Tuvalu Uganda Ukraine United Arab Emirates
## X1990                       -1     -1     -1      -1                   -1
## X1991                       -1     -1     -1      -1                   -1
## X1992                       -1     -1     -1      -1                   -1
## X1993                       -1     -1     -1      -1                   -1
## X1994                       -1     -1     -1      -1                   -1
## X1995                       -1     -1     -1      -1                   -1
##       United Kingdom Tanzania Virgin Islands (U.S.)
## X1990              9       -1                    -1
## X1991              9       -1                    -1
## X1992             10       -1                    -1
## X1993             10       -1                    -1
## X1994              9       -1                    -1
## X1995              9       -1                    -1
##       United States of America Uruguay Uzbekistan Vanuatu Venezuela
## X1990                        7      -1         -1      -1        -1
## X1991                        7      -1         -1      -1        -1
## X1992                        7      -1         -1      -1        -1
## X1993                        7      -1         -1      -1        -1
## X1994                        6      -1         -1      -1        -1
## X1995                        6      -1         -1      -1        -1
##       Viet Nam Wallis et Futuna West Bank and Gaza Yemen Zambia Zimbabwe
## X1990       -1               -1                 -1    -1     -1       -1
## X1991       -1               -1                 -1    -1     -1       -1
## X1992       -1               -1                 -1    -1     -1       -1
## X1993       -1               -1                 -1    -1     -1       -1
## X1994       -1               -1                 -1    -1     -1       -1
## X1995       -1               -1                 -1    -1     -1       -1
```

We can see how many of the elements, those where we had more than 10 cases, where
assigned a -1 value.  

The most expressive way of selecting form a `data.frame` in R is by using the 
`subset` function (type `?subset` in your R console to
read about this function). The function is applied by row in the data frame. 
The second argument can include any condition using column names. The third argument
can include a list of columns. The resulting dataframe will contain those rows
that satisfy the second argument conditions, including just those columns listed
in the third argument (all of them bt default). For example, if we want to select
those years when the United Kingdom had more than 10 cases, and list the resulting
rows for three countries (UK, Spain, and Colombia) we will use:    


```r
# If a column name contains blanks, we can have to use ` `
subset(existing_df,  `United Kingdom`>10, c('United Kingdom', 'Spain','Colombia'))
```

```r
##       United Kingdom Spain Colombia
## X2005             11    24       53
## X2006             11    24       44
## X2007             12    23       43
```

We can do the same thing using `[ ]` as follows.  


```r
existing_df[existing_df["United Kingdom"]>10, c('United Kingdom', 'Spain','Colombia')]
```

```r
##       United Kingdom Spain Colombia
## X2005             11    24       53
## X2006             11    24       44
## X2007             12    23       43
```

## Function mapping and data grouping   

### Python  

The `pandas.DataFrame` class defines several [ways of applying functions](http://pandas.pydata.org/pandas-docs/stable/api.html#id5) both, index-wise and element-wise. Some of them are already predefined, and are part of the descriptive statistics methods we will talk about when performing exploratory data analysis.

```python
existing_df.sum()
```

```python
    country
    Afghanistan            6360
    Albania                 665
    Algeria                 853
    American Samoa          221
    Andorra                 455
    Angola                 7442
    Anguilla                641
    Antigua and Barbuda     195
    Argentina              1102
    Armenia                1349
    Australia               116
    Austria                 228
    Azerbaijan             1541
    Bahamas                 920
    Bahrain                1375
    ...
    United Arab Emirates         577
    United Kingdom               173
    Tanzania                    5713
    Virgin Islands (U.S.)        367
    United States of America      88
    Uruguay                      505
    Uzbekistan                  2320
    Vanuatu                     3348
    Venezuela                    736
    Viet Nam                    5088
    Wallis et Futuna            2272
    West Bank and Gaza           781
    Yemen                       3498
    Zambia                      9635
    Zimbabwe                    9231
    Length: 207, dtype: int64
```


We have just calculated the total number of TB cases from 1990 to 2007 for each country. We can do the same by year if we pass `axis=1` to use `columns` instead of `index` as axis.  

```python
existing_df.sum(axis=1)
```


```python
    year
    1990    40772
    1991    40669
    1992    39912
    1993    39573
    1994    39066
    1995    38904
    1996    37032
    1997    37462
    1998    36871
    1999    37358
    2000    36747
    2001    36804
    2002    37160
    2003    36516
    2004    36002
    2005    35435
    2006    34987
    2007    34622
    dtype: int64
```


It looks like there is a descent in the existing number of TB cases per 100K across the world. 

Pandas also provides methods to apply other functions to data frames. They are three: `apply`, `applymap`, and `groupby`.  

#### apply and applymap

By using [`apply()`](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.apply.html#pandas.DataFrame.apply) we can apply a function along an input axis of a `DataFrame`. Objects passed to the functions we apply are `Series` objects having as index either the DataFrame’s **index** (axis=0) or the **columns** (axis=1). Return type depends on whether passed function aggregates, or the reduce argument if the DataFrame is empty. For example, if we want to obtain the number of existing cases per million (instead of 100K) we can use the following.    

```python
from __future__ import division # we need this to have float division without using a cast
existing_df.apply(lambda x: x/10)
```

| country | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen | Zambia | Zimbabwe |
|---------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|-------|--------|----------|
| year    |             |         |         |                |         |        |          |                     |           |         |     |         |            |         |           |          |                  |                    |       |        |          |
| 1990    | 43.6        | 4.2     | 4.5     | 4.2            | 3.9     | 51.4   | 3.8      | 1.6                 | 9.6       | 5.2     | ... | 3.5     | 11.4       | 27.8    | 4.6       | 36.5     | 12.6             | 5.5                | 26.5  | 43.6   | 40.9     |
| 1991    | 42.9        | 4.0     | 4.4     | 1.4            | 3.7     | 51.4   | 3.8      | 1.5                 | 9.1       | 4.9     | ... | 3.4     | 10.5       | 26.8    | 4.5       | 36.1     | 35.2             | 5.4                | 26.1  | 45.6   | 41.7     |
| 1992    | 42.2        | 4.1     | 4.4     | 0.4            | 3.5     | 51.3   | 3.7      | 1.5                 | 8.6       | 5.1     | ... | 3.3     | 10.2       | 25.9    | 4.4       | 35.8     | 6.4              | 5.4                | 26.3  | 49.4   | 41.5     |
| 1993    | 41.5        | 4.2     | 4.3     | 1.8            | 3.3     | 51.2   | 3.7      | 1.4                 | 8.2       | 5.5     | ... | 3.2     | 11.8       | 25.0    | 4.3       | 35.4     | 17.4             | 5.2                | 25.3  | 52.6   | 41.9     |
| 1994    | 40.7        | 4.2     | 4.3     | 1.7            | 3.2     | 51.0   | 3.6      | 1.3                 | 7.8       | 6.0     | ... | 3.1     | 11.6       | 24.2    | 4.2       | 35.0     | 17.2             | 5.2                | 25.0  | 55.6   | 42.6     |
| 1995    | 39.7        | 4.3     | 4.2     | 2.2            | 3.0     | 50.8   | 3.5      | 1.2                 | 7.4       | 6.8     | ... | 3.0     | 11.9       | 23.4    | 4.2       | 34.6     | 9.3              | 5.0                | 24.4  | 58.5   | 43.9     |
| 1996    | 39.7        | 4.2     | 4.3     | 0.0            | 2.8     | 51.2   | 3.5      | 1.2                 | 7.1       | 7.4     | ... | 2.8     | 11.1       | 22.6    | 4.1       | 31.2     | 12.3             | 4.9                | 23.3  | 60.2   | 45.3     |
| 1997    | 38.7        | 4.4     | 4.4     | 2.5            | 2.3     | 36.3   | 3.6      | 1.1                 | 6.7       | 7.5     | ... | 2.7     | 12.2       | 21.8    | 4.1       | 27.3     | 21.3             | 4.6                | 20.7  | 62.6   | 48.1     |
| 1998    | 37.4        | 4.3     | 4.5     | 1.2            | 2.4     | 41.4   | 3.6      | 1.1                 | 6.3       | 7.4     | ... | 2.8     | 12.9       | 21.1    | 4.0       | 26.1     | 10.7             | 4.4                | 19.4  | 63.4   | 39.2     |
| 1999    | 37.3        | 4.2     | 4.6     | 0.8            | 2.2     | 38.4   | 3.6      | 0.9                 | 5.8       | 8.6     | ... | 2.8     | 13.4       | 15.9    | 3.9       | 25.3     | 10.5             | 4.2                | 17.5  | 65.7   | 43.0     |
| 2000    | 34.6        | 4.0     | 4.8     | 0.8            | 2.0     | 53.0   | 3.5      | 0.8                 | 5.2       | 9.4     | ... | 2.7     | 13.9       | 14.3    | 3.9       | 24.8     | 10.3             | 4.0                | 16.4  | 65.8   | 47.9     |
| 2001    | 32.6        | 3.4     | 4.9     | 0.6            | 2.0     | 33.5   | 3.5      | 0.9                 | 5.1       | 9.9     | ... | 2.5     | 14.8       | 12.8    | 4.1       | 24.3     | 1.3              | 3.9                | 15.4  | 68.0   | 52.3     |
| 2002    | 30.4        | 3.2     | 5.0     | 0.5            | 2.1     | 30.7   | 3.5      | 0.7                 | 4.2       | 9.7     | ... | 2.7     | 14.4       | 14.9    | 4.1       | 23.5     | 27.5             | 3.7                | 14.9  | 51.7   | 57.1     |
| 2003    | 30.8        | 3.2     | 5.1     | 0.6            | 1.8     | 28.1   | 3.5      | 0.9                 | 4.1       | 9.1     | ... | 2.5     | 15.2       | 12.8    | 3.9       | 23.4     | 14.7             | 3.6                | 14.6  | 47.8   | 63.2     |
| 2004    | 28.3        | 2.9     | 5.2     | 0.9            | 1.9     | 31.8   | 3.5      | 0.8                 | 3.9       | 8.5     | ... | 2.3     | 14.9       | 11.8    | 3.8       | 22.6     | 6.3              | 3.5                | 13.8  | 46.8   | 65.2     |
| 2005    | 26.7        | 2.9     | 5.3     | 1.1            | 1.8     | 33.1   | 3.4      | 0.8                 | 3.9       | 7.9     | ... | 2.4     | 14.4       | 13.1    | 3.8       | 22.7     | 5.7              | 3.3                | 13.7  | 45.3   | 68.0     |
| 2006    | 25.1        | 2.6     | 5.5     | 0.9            | 1.7     | 30.2   | 3.4      | 0.9                 | 3.7       | 7.9     | ... | 2.5     | 13.4       | 10.4    | 3.8       | 22.2     | 6.0              | 3.2                | 13.5  | 42.2   | 69.9     |
| 2007    | 23.8        | 2.2     | 5.6     | 0.5            | 1.9     | 29.4   | 3.4      | 0.9                 | 3.5       | 8.1     | ... | 2.3     | 14.0       | 10.2    | 3.9       | 22.0     | 2.5              | 3.1                | 13.0  | 38.7   | 71.4     |

######18 rows × 207 columns  


We have seen how `apply` works element-wise. If the function we pass is applicable to single elements (e.g. division) pandas will broadcast that to every single element and we will get again a Series with the function applied to each element and hence, a data frame as a result in our case. However, the function intended to be used for element-wise maps is `applymap`.

#### groupby

Grouping is a powerful an important data frame operation in Exploratory Data Analysis. In Pandas we can do this easily. For example, imagine we want the mean number of existing cases per year in two different periods, before and after the year 2000. We can do the following.

```python
mean_cases_by_period = existing_df.groupby(lambda x: int(x)>1999).mean()
mean_cases_by_period.index = ['1990-1999', '2000-2007']
mean_cases_by_period
```


| country   | Afghanistan | Albania | Algeria | American Samoa | Andorra | Angola | Anguilla | Antigua and Barbuda | Argentina | Armenia | ... | Uruguay | Uzbekistan | Vanuatu | Venezuela | Viet Nam | Wallis et Futuna | West Bank and Gaza | Yemen   | Zambia  | Zimbabwe |
|-----------|-------------|---------|---------|----------------|---------|--------|----------|---------------------|-----------|---------|-----|---------|------------|---------|-----------|----------|------------------|--------------------|---------|---------|----------|
| 1990-1999 | 403.700     | 42.1    | 43.90   | 16.200         | 30.3    | 474.40 | 36.400   | 12.800              | 76.6      | 64.400  | ... | 30.600  | 117.00     | 234.500 | 42.300    | 323.300  | 152.900          | 49.800             | 234.500 | 557.200 | 428.10   |
| 2000-2007 | 290.375     | 30.5    | 51.75   | 7.375          | 19.0    | 337.25 | 34.625   | 8.375               | 42.0      | 88.125  | ... | 24.875  | 143.75     | 125.375 | 39.125    | 231.875  | 92.875           | 35.375             | 144.125 | 507.875 | 618.75   |

######2 rows × 207 columns  


The `groupby` method accepts different types of grouping, including a mapping function as we passed, a dictionary, a Series, or a tuple / list of column names. The mapping function for example will be called on each element of the object `.index` (the year string in our case) to determine the groups. If a `dict` or `Series` is passed, the `Series` or `dict` values are used to determine the groups (e.g. we can pass a column that contains categorical values). 

We can index the resulting data frame as usual.

```python
 mean_cases_by_period[['United Kingdom', 'Spain', 'Colombia']]
```

| country   | United Kingdom | Spain  | Colombia |
|-----------|----------------|--------|----------|
| 1990-1999 | 9.200          | 35.300 | 75.10    |
| 2000-2007 | 10.125         | 24.875 | 53.25    |


### R  

### `lapply`  

R has a long collection of *apply* functions that can be used to apply functions to
elements within vectors, matrices, lists, and data frames. The one we will introduce here
is **lapply** (type `?lapply` in your R console). It is the one we use with lists and, 
since a data frame is a list of column vectors, will work with them as well.  

For example, we can repeat the by year sum we did with Pandas as follows.  


```r
existing_df_sum_years <- lapply(existing_df, function(x) { sum(x) })
existing_df_sum_years <- as.data.frame(existing_df_sum_years)
existing_df_sum_years
```

```r
##   Afghanistan Albania Algeria American.Samoa Andorra Angola Anguilla
## 1        6360     665     853            221     455   7442      641
##   Antigua.and.Barbuda Argentina Armenia Australia Austria Azerbaijan
## 1                 195      1102    1349       116     228       1541
##   Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin Bermuda
## 1     920    1375       9278       95    1446     229    864  2384     133
##   Bhutan Bolivia Bosnia.and.Herzegovina Botswana Brazil
## 1  10579    4806                   1817     8067   1585
##   British.Virgin.Islands Brunei.Darussalam Bulgaria Burkina.Faso Burundi
## 1                    383              1492      960         5583    8097
##   Cambodia Cameroon Canada Cape.Verde Cayman.Islands
## 1    14015     3787     92       6712            129
##   Central.African.Republic Chad Chile China Colombia Comoros Congo..Rep.
## 1                     7557 7316   452  4854     1177    2310        6755
##   Cook.Islands Costa.Rica Croatia Cuba Cyprus Czech.Republic Cote.d.Ivoire
## 1          357        349    1637  295    163            304          7900
##   Korea..Dem..Rep. Congo..Dem..Rep. Denmark Djibouti Dominica
## 1            12359             9343     151    19155      375
##   Dominican.Republic Ecuador Egypt El.Salvador Equatorial.Guinea Eritrea
## 1               2252    3676   700        1483              5303    3181
##   Estonia Ethiopia Fiji Finland France French.Polynesia Gabon Gambia
## 1    1214     8432  811     153    263              974  5949   6700
##   Georgia Germany Ghana Greece Grenada Guam Guatemala Guinea Guinea.Bissau
## 1    1406     180  7368    380     125 1340      1716   5853          6207
##   Guyana Haiti Honduras Hungary Iceland India Indonesia Iran Iraq Ireland
## 1   1621  7428     1756     930      58  8107      6131  789 1433     233
##   Israel Italy Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait
## 1    138   139     142   822    236       2249  5117    12652    928
##   Kyrgyzstan Laos Latvia Lebanon Lesotho Liberia Libyan.Arab.Jamahiriya
## 1       2354 6460   1351     783    6059    7707                    559
##   Lithuania Luxembourg Madagascar Malawi Malaysia Maldives  Mali Malta
## 1      1579        233       6691   6290     2615     1638 10611   120
##   Mauritania Mauritius Mexico Micronesia..Fed..Sts. Monaco Mongolia
## 1      10698       817    978                  3570     44     6127
##   Montserrat Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## 1        227    1873       7992    5061    9990  2860  7398         138
##   Netherlands.Antilles New.Caledonia New.Zealand Nicaragua Niger Nigeria
## 1                  355          1095         176      1708  5360    7968
##   Niue Northern.Mariana.Islands Norway Oman Pakistan Palau Panama
## 1 1494                     3033    103  337     6889  2258   1073
##   Papua.New.Guinea Paraguay Peru Philippines Poland Portugal Puerto.Rico
## 1             8652     1559 4352       11604   1064      677         206
##   Qatar Korea..Rep. Moldova Romania Russian.Federation Rwanda
## 1  1380        2353    2781    2891               2170   7216
##   Saint.Kitts.and.Nevis Saint.Lucia Saint.Vincent.and.the.Grenadines Samoa
## 1                   259         371                              709   568
##   San.Marino Sao.Tome.and.Principe Saudi.Arabia Senegal Seychelles
## 1        118                  5129         1171    7423       1347
##   Sierra.Leone Singapore Slovakia Slovenia Solomon.Islands Somalia
## 1        11756       751      700      639            6623    8128
##   South.Africa Spain Sri.Lanka Sudan Suriname Swaziland Sweden Switzerland
## 1        10788   552      1695  7062     1975     11460     82         149
##   Syrian.Arab.Republic Tajikistan Thailand Macedonia..FYR Timor.Leste
## 1                  986       3438     4442           1108       10118
##    Togo Tokelau Tonga Trinidad.and.Tobago Tunisia Turkey Turkmenistan
## 1 12111    1283   679                 282     685   1023         1866
##   Turks.and.Caicos.Islands Tuvalu Uganda Ukraine United.Arab.Emirates
## 1                      485   7795   7069    1778                  577
##   United.Kingdom Tanzania Virgin.Islands..U.S.. United.States.of.America
## 1            173     5713                   367                       88
##   Uruguay Uzbekistan Vanuatu Venezuela Viet.Nam Wallis.et.Futuna
## 1     505       2320    3348       736     5088             2272
##   West.Bank.and.Gaza Yemen Zambia Zimbabwe
## 1                781  3498   9635     9231
```

What did we do there? Very simple. the `lapply` function gets a list and a function
that will be applied to each element. It returns the result as a list. The function 
is defined in-line (i.e. as a lambda in Python). For a given `x` if sums its elements.  

If we want to sum by year, for every country, we can use the trasposed data frame
we stored before.  


```r
existing_df_sum_countries <- lapply(existing_df_t, function(x) { sum(x) })
existing_df_sum_countries <- as.data.frame(existing_df_sum_countries)
existing_df_sum_countries
```

```r
##   X1990 X1991 X1992 X1993 X1994 X1995 X1996 X1997 X1998 X1999 X2000 X2001
## 1 40772 40669 39912 39573 39066 38904 37032 37462 36871 37358 36747 36804
##   X2002 X2003 X2004 X2005 X2006 X2007
## 1 37160 36516 36002 35435 34987 34622
```

#### aggregate  

R provided basic grouping functionality by using `aggregate`. Another option is
to have alook at the powerful [dplyr](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html) library that I highly recommend.  

But `aggregate` is quite powerful as well. It accepts a data frame, a list of 
grouping elements, and a function to apply to each group. First we need to define
a grouping vector.  


```r
before_2000 <- c('1990-99','1990-99','1990-99','1990-99','1990-99',
                 '1990-99','1990-99','1990-99','1990-99','1990-99',
                 '2000-07','2000-07','2000-07','2000-07','2000-07',
                 '2000-07','2000-07','2000-07')
before_2000
```

```r
##  [1] "1990-99" "1990-99" "1990-99" "1990-99" "1990-99" "1990-99" "1990-99"
##  [8] "1990-99" "1990-99" "1990-99" "2000-07" "2000-07" "2000-07" "2000-07"
## [15] "2000-07" "2000-07" "2000-07" "2000-07"
```

Then we can use that column as groping element and use the function `mean`.  


```r
mean_cases_by_period <- aggregate(existing_df, list(Period = before_2000), mean)
mean_cases_by_period
```

```r
##    Period Afghanistan Albania Algeria American Samoa Andorra Angola
## 1 1990-99     403.700    42.1   43.90         16.200    30.3 474.40
## 2 2000-07     290.375    30.5   51.75          7.375    19.0 337.25
##   Anguilla Antigua and Barbuda Argentina Armenia Australia Austria
## 1   36.400              12.800      76.6  64.400       6.8  14.500
## 2   34.625               8.375      42.0  88.125       6.0  10.375
##   Azerbaijan Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize
## 1     75.600  52.700  95.600     571.20    6.400  80.500  14.000  54.60
## 2     98.125  49.125  52.375     445.75    3.875  80.125  11.125  39.75
##     Benin Bermuda  Bhutan Bolivia Bosnia and Herzegovina Botswana  Brazil
## 1 131.300   8.400 699.600   308.2                  132.9  356.400 103.400
## 2 133.875   6.125 447.875   215.5                   61.0  562.875  68.875
##   British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso Burundi
## 1                 24.600             90.60   57.700        239.9  332.30
## 2                 17.125             73.25   47.875        398.0  596.75
##   Cambodia Cameroon Canada Cape Verde Cayman Islands
## 1    835.9  201.400  5.900    409.500          8.400
## 2    707.0  221.625  4.125    327.125          5.625
##   Central African Republic    Chad Chile  China Colombia Comoros
## 1                  360.000 330.300  32.0 300.00    75.10 152.500
## 2                  494.625 501.625  16.5 231.75    53.25  98.125
##   Congo, Rep. Cook Islands Costa Rica Croatia  Cuba Cyprus Czech Republic
## 1     322.200       23.400       24.5 110.000 21.70  10.90           20.8
## 2     441.625       15.375       13.0  67.125  9.75   6.75           12.0
##   Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep. Denmark Djibouti
## 1        331.00          794.400           393.30    9.70 1145.000
## 2        573.75          551.875           676.25    6.75  963.125
##   Dominica Dominican Republic Ecuador Egypt El Salvador Equatorial Guinea
## 1   22.000             148.20 236.700  45.6       101.9            206.50
## 2   19.375              96.25 163.625  30.5        58.0            404.75
##   Eritrea Estonia Ethiopia  Fiji Finland France French Polynesia   Gabon
## 1 221.200  77.700  382.900 54.50  10.400  16.90           70.900 330.800
## 2 121.125  54.625  575.375 33.25   6.125  11.75           33.125 330.125
##   Gambia Georgia Germany   Ghana Greece Grenada   Guam Guatemala  Guinea
## 1 352.20    68.2    12.8 450.100 24.300   7.000 100.20   101.500 274.200
## 2 397.25    90.5     6.5 358.375 17.125   6.875  42.25    87.625 388.875
##   Guinea-Bissau  Guyana   Haiti Honduras Hungary Iceland   India Indonesia
## 1        394.10  61.800 438.100  118.900  68.300   3.700 533.200    387.70
## 2        283.25 125.375 380.875   70.875  30.875   2.625 346.875    281.75
##     Iran   Iraq Ireland Israel Italy Jamaica  Japan Jordan Kazakhstan
## 1 52.000 85.800    14.9   8.80 8.800     8.6 53.700 16.300      107.3
## 2 33.625 71.875    10.5   6.25 6.375     7.0 35.625  9.125      147.0
##   Kenya Kiribati Kuwait Kyrgyzstan   Laos Latvia Lebanon Lesotho Liberia
## 1 208.9  874.900  69.40    118.700 393.40 75.400    57.9   271.5   444.7
## 2 378.5  487.875  29.25    145.875 315.75 74.625    25.5   418.0   407.5
##   Libyan Arab Jamahiriya Lithuania Luxembourg Madagascar Malawi Malaysia
## 1                 40.200     94.10      15.10      359.5  355.0   158.90
## 2                 19.625     79.75      10.25      387.0  342.5   128.25
##   Maldives    Mali Malta Mauritania Mauritius Mexico Micronesia, Fed. Sts.
## 1  105.500 595.200  7.80    600.700    50.200  72.40                246.80
## 2   72.875 582.375  5.25    586.375    39.375  31.75                137.75
##   Monaco Mongolia Montserrat Morocco Mozambique Myanmar Namibia   Nauru
## 1    2.8   412.50       13.5 116.600    368.300  352.70 566.900 216.500
## 2    2.0   250.25       11.5  88.375    538.625  191.75 540.125  86.875
##     Nepal Netherlands Netherlands Antilles New Caledonia New Zealand
## 1 523.300        8.80                 22.7          83.1      10.100
## 2 270.625        6.25                 16.0          33.0       9.375
##   Nicaragua  Niger Nigeria  Niue Northern Mariana Islands Norway   Oman
## 1    113.40 308.60 361.500 98.80                  228.200    6.7 23.200
## 2     71.75 284.25 544.125 63.25                   93.875    4.5 13.125
##   Pakistan   Palau Panama Papua New Guinea Paraguay   Peru Philippines
## 1  423.400 164.100 68.800          494.900   89.400 297.40       726.4
## 2  331.875  77.125 48.125          462.875   83.125 172.25       542.5
##   Poland Portugal Puerto Rico Qatar Korea, Rep. Moldova Romania
## 1 77.100    43.90      15.300    78     141.600 140.000   153.1
## 2 36.625    29.75       6.625    75     117.125 172.625   170.0
##   Russian Federation Rwanda Saint Kitts and Nevis Saint Lucia
## 1             107.20 274.20                  15.1       22.50
## 2             137.25 559.25                  13.5       18.25
##   Saint Vincent and the Grenadines Samoa San Marino Sao Tome and Principe
## 1                            42.30 35.00      7.500                 306.1
## 2                            35.75 27.25      5.375                 258.5
##   Saudi Arabia Senegal Seychelles Sierra Leone Singapore Slovakia Slovenia
## 1       67.000 385.000     91.400      531.900     49.70   49.700   47.800
## 2       62.625 446.625     54.125      804.625     31.75   25.375   20.125
##   Solomon Islands Somalia South Africa  Spain Sri Lanka   Sudan Suriname
## 1         469.600 521.100        569.2 35.300      99.1 401.100     95.1
## 2         240.875 364.625        637.0 24.875      88.0 381.375    128.0
##   Swaziland Sweden Switzerland Syrian Arab Republic Tajikistan Thailand
## 1   527.900  4.900       10.30               72.300     134.00    288.6
## 2   772.625  4.125        5.75               32.875     262.25    194.5
##   Macedonia, FYR Timor-Leste   Togo Tokelau Tonga Trinidad and Tobago
## 1         80.100       662.6 650.10   105.9  39.9              16.100
## 2         38.375       436.5 701.25    28.0  35.0              15.125
##   Tunisia Turkey Turkmenistan Turks and Caicos Islands Tuvalu Uganda
## 1  46.400 68.800      105.900                   32.200 511.30 352.70
## 2  27.625 41.875      100.875                   20.375 335.25 442.75
##   Ukraine United Arab Emirates United Kingdom Tanzania
## 1   81.60               37.400          9.200  279.200
## 2  120.25               25.375         10.125  365.125
##   Virgin Islands (U.S.) United States of America Uruguay Uzbekistan
## 1                23.000                      6.0  30.600     117.00
## 2                17.125                      3.5  24.875     143.75
##   Vanuatu Venezuela Viet Nam Wallis et Futuna West Bank and Gaza   Yemen
## 1 234.500    42.300  323.300          152.900             49.800 234.500
## 2 125.375    39.125  231.875           92.875             35.375 144.125
##    Zambia Zimbabwe
## 1 557.200   428.10
## 2 507.875   618.75
```

The `aggregate` function allows subsetting the dataframe we pass as first parameter
of course, and also to pass multiple grouping elements and define our own functions
(either as lambda or predefined functions). And again, the result is a data frame
that we can index as usual.  


```r
mean_cases_by_period[,c('United Kingdom','Spain','Colombia')]
```

```r
##   United Kingdom  Spain Colombia
## 1          9.200 35.300    75.10
## 2         10.125 24.875    53.25
```

## Conclusions   

This tutorial has introduced the concept of **data frame**, together with how to use them in the two most popular Data Science ecosystems nowadays, R and Python. Together, we have introduced a few datasets from Gapminder World related with Infectious Tuberculosis, a very serious epidemic disease sometimes forgotten in developed countries but that nowadays is the second cause of death of its kind just after HIV (and many times associated to HIV). In the next tutorial in the series, we will use these datasets in order to perform some Exploratory Analysis in both, Python and R, to better understand the world situation regarding the disease.
