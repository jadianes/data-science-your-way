# Data Frames and Exploratory Data Analysis
Jose A. Dianes  
10 July 2015  

## Downloading files and reading CSV  

In R, you use `read.csv` to read CSV files into `data.frame` variables. Although the R function `read.csv` can work with URLs, https is a problem for R in many cases, so you need to use a package like RCurl to get around it.  


```r
library(RCurl)
```

```
## Loading required package: bitops
```

```r
existing_cases_file <- getURL("https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0&output=csv")
existing_df <- read.csv(text = existing_cases_file, row.names=1, stringsAsFactor=F)
str(existing_df)
```

```
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
we can see that, due to the `,` thousands separator, some of the columns hasn't been parsed as numbers but as character. If we want to properly work with our dataset we need to convert them to numbers.  

Once we know a bit more about indexing and mapping functions, I promise you will be able to understand the following piece of code. By know let's say that we convert a column and assign it again to its reference in the data frame.    


```r
existing_df[c(1,2,3,4,5,6,15,16,17,18)] <- 
    lapply( existing_df[c(1,2,3,4,5,6,15,16,17,18)], 
            function(x) { as.integer(gsub(',', '', x) )})
str(existing_df)
```

```
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

```
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

```
## [1] 207
```

```r
ncol(existing_df)
```

```
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

```
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
## X1990      12     1485       24                183     282    48
## X1991      12     1477       24                173     271    47
## X1992      11     1463       24                164     259    47
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
## X1990      10    62     19         95   125     1026     89         90
## X1991      10    60     18         87   120     1006     84         93
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

```
##  [1] "X1990" "X1991" "X1992" "X1993" "X1994" "X1995" "X1996" "X1997"
##  [9] "X1998" "X1999" "X2000" "X2001" "X2002" "X2003" "X2004" "X2005"
## [17] "X2006" "X2007"
```

In our data frame we see we have weird names for them. Every year is prefixed with an X. This is so because they started as column names. From the definition of a `data.frame` in R, we know that each column is a vector with a variable name. A name in R cannot start with a digit, so R automatically prefixes numbers with the letter X. Right know we will leave it like it is since it doesn't really stop us from doing our analysis.  

In the case of column names, they pretty much correspond to Pandas `.columns` attribute in a data frame.  


```r
colnames(existing_df)
```

```
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

## Data indexing  

Similarly to what we do in Pandas (actually Pandas is inspired in R), we can
access a `data.frame` column by its position.  


```r
existing_df[,1]
```

```
##  [1] 436 429 422 415 407 397 397 387 374 373 346 326 304 308 283 267 251
## [18] 238
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

```
##  [1] 436 429 422 415 407 397 397 387 374 373 346 326 304 308 283 267 251
## [18] 238
```

An finally, since a `data.frame` is a list of elements (its columns), we can access
columns as list elements using the list indexing operator `[[]]`.  


```r
existing_df[[1]]
```

```
##  [1] 436 429 422 415 407 397 397 387 374 373 346 326 304 308 283 267 251
## [18] 238
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

```
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
## X1990      12     1485       24                183     282    48
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990         133               169     245      50      312   68      14
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990     21               67   359    350      51      15   533     30
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990       7  103       113    241           404     39   479      141
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990      67       5   586       443   50   88      19     11    11
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990      10    62     19         95   125     1026     89         90
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

```
## [1] 436
```

Or its name.  


```r
existing_df$Afghanistan[1]
```

```
## [1] 436
```

What did just do before? Basically we retrieved a column, that is a vector, and
accessed that vector first element. That way we got the value for Afghanistan for
the year 1990. We can do the same thing using the `[[]]` operator instead of the
list element label.  


```r
existing_df[[1]][1]
```

```
## [1] 436
```

We can also select multiple columns and/or rows by passing R vectors.  


```r
existing_df[c(3,9,16),c(170,194)]
```

```
##       Spain United Kingdom
## X1992    40             10
## X1998    30              9
## X2005    24             11
```

Finally, using names is also possible when using positional indexing.  


```r
existing_df["X1992","Spain"]
```

```
## [1] 40
```

That we can combine with vectors.  


```r
existing_df[c("X1992", "X1998", "X2005"), c("Spain", "United Kingdom")]
```

```
##       Spain United Kingdom
## X1992    40             10
## X1998    30              9
## X2005    24             11
```

So enough about indexing. In the next section we will see how to perform more 
complex data accessing using conditional selection.  

## Data Selection  

As we did with Pandas, let's check the result of using a `data.frame` in a logical
or boolean expression.  


```r
existing_df_gt10 <- existing_df>10
head(existing_df_gt10,2) # check just a couple of rows
```

```
##       Afghanistan Albania Algeria American Samoa Andorra Angola Anguilla
## X1990        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
## X1991        TRUE    TRUE    TRUE           TRUE    TRUE   TRUE     TRUE
##       Antigua and Barbuda Argentina Armenia Australia Austria Azerbaijan
## X1990                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
## X1991                TRUE      TRUE    TRUE     FALSE    TRUE       TRUE
##       Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin
## X1990    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
## X1991    TRUE    TRUE       TRUE    FALSE    TRUE    TRUE   TRUE  TRUE
##       Bermuda Bhutan Bolivia Bosnia and Herzegovina Botswana Brazil
## X1990   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
## X1991   FALSE   TRUE    TRUE                   TRUE     TRUE   TRUE
##       British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso
## X1990                   TRUE              TRUE     TRUE         TRUE
## X1991                   TRUE              TRUE     TRUE         TRUE
##       Burundi Cambodia Cameroon Canada Cape Verde Cayman Islands
## X1990    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
## X1991    TRUE     TRUE     TRUE  FALSE       TRUE          FALSE
##       Central African Republic Chad Chile China Colombia Comoros
## X1990                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
## X1991                     TRUE TRUE  TRUE  TRUE     TRUE    TRUE
##       Congo, Rep. Cook Islands Costa Rica Croatia Cuba Cyprus
## X1990        TRUE        FALSE       TRUE    TRUE TRUE   TRUE
## X1991        TRUE        FALSE       TRUE    TRUE TRUE   TRUE
##       Czech Republic Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep.
## X1990           TRUE          TRUE             TRUE             TRUE
## X1991           TRUE          TRUE             TRUE             TRUE
##       Denmark Djibouti Dominica Dominican Republic Ecuador Egypt
## X1990    TRUE     TRUE     TRUE               TRUE    TRUE  TRUE
## X1991    TRUE     TRUE     TRUE               TRUE    TRUE  TRUE
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990        TRUE              TRUE    TRUE    TRUE     TRUE TRUE    TRUE
## X1991        TRUE              TRUE    TRUE    TRUE     TRUE TRUE    TRUE
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
## X1991   TRUE             TRUE  TRUE   TRUE    TRUE    TRUE  TRUE   TRUE
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
## X1991   FALSE TRUE      TRUE   TRUE          TRUE   TRUE  TRUE     TRUE
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE   TRUE  TRUE
## X1991    TRUE   FALSE  TRUE      TRUE TRUE TRUE    TRUE  FALSE FALSE
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
## X1991   FALSE  TRUE   TRUE       TRUE  TRUE     TRUE   TRUE       TRUE
##       Laos Latvia Lebanon Lesotho Liberia Libyan Arab Jamahiriya Lithuania
## X1990 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
## X1991 TRUE   TRUE    TRUE    TRUE    TRUE                   TRUE      TRUE
##       Luxembourg Madagascar Malawi Malaysia Maldives Mali Malta Mauritania
## X1990       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
## X1991       TRUE       TRUE   TRUE     TRUE     TRUE TRUE FALSE       TRUE
##       Mauritius Mexico Micronesia, Fed. Sts. Monaco Mongolia Montserrat
## X1990      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
## X1991      TRUE   TRUE                  TRUE  FALSE     TRUE       TRUE
##       Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## X1990    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE        TRUE
## X1991    TRUE       TRUE    TRUE    TRUE  TRUE  TRUE       FALSE
##       Netherlands Antilles New Caledonia New Zealand Nicaragua Niger
## X1990                 TRUE          TRUE       FALSE      TRUE  TRUE
## X1991                 TRUE          TRUE       FALSE      TRUE  TRUE
##       Nigeria Niue Northern Mariana Islands Norway Oman Pakistan Palau
## X1990    TRUE TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
## X1991    TRUE TRUE                     TRUE  FALSE TRUE     TRUE  TRUE
##       Panama Papua New Guinea Paraguay Peru Philippines Poland Portugal
## X1990   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
## X1991   TRUE             TRUE     TRUE TRUE        TRUE   TRUE     TRUE
##       Puerto Rico Qatar Korea, Rep. Moldova Romania Russian Federation
## X1990        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
## X1991        TRUE  TRUE        TRUE    TRUE    TRUE               TRUE
##       Rwanda Saint Kitts and Nevis Saint Lucia
## X1990   TRUE                  TRUE        TRUE
## X1991   TRUE                  TRUE        TRUE
##       Saint Vincent and the Grenadines Samoa San Marino
## X1990                             TRUE  TRUE      FALSE
## X1991                             TRUE  TRUE      FALSE
##       Sao Tome and Principe Saudi Arabia Senegal Seychelles Sierra Leone
## X1990                  TRUE         TRUE    TRUE       TRUE         TRUE
## X1991                  TRUE         TRUE    TRUE       TRUE         TRUE
##       Singapore Slovakia Slovenia Solomon Islands Somalia South Africa
## X1990      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
## X1991      TRUE     TRUE     TRUE            TRUE    TRUE         TRUE
##       Spain Sri Lanka Sudan Suriname Swaziland Sweden Switzerland
## X1990  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE        TRUE
## X1991  TRUE      TRUE  TRUE     TRUE      TRUE  FALSE        TRUE
##       Syrian Arab Republic Tajikistan Thailand Macedonia, FYR Timor-Leste
## X1990                 TRUE       TRUE     TRUE           TRUE        TRUE
## X1991                 TRUE       TRUE     TRUE           TRUE        TRUE
##       Togo Tokelau Tonga Trinidad and Tobago Tunisia Turkey Turkmenistan
## X1990 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
## X1991 TRUE    TRUE  TRUE                TRUE    TRUE   TRUE         TRUE
##       Turks and Caicos Islands Tuvalu Uganda Ukraine United Arab Emirates
## X1990                     TRUE   TRUE   TRUE    TRUE                 TRUE
## X1991                     TRUE   TRUE   TRUE    TRUE                 TRUE
##       United Kingdom Tanzania Virgin Islands (U.S.)
## X1990          FALSE     TRUE                  TRUE
## X1991          FALSE     TRUE                  TRUE
##       United States of America Uruguay Uzbekistan Vanuatu Venezuela
## X1990                    FALSE    TRUE       TRUE    TRUE      TRUE
## X1991                    FALSE    TRUE       TRUE    TRUE      TRUE
##       Viet Nam Wallis et Futuna West Bank and Gaza Yemen Zambia Zimbabwe
## X1990     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
## X1991     TRUE             TRUE               TRUE  TRUE   TRUE     TRUE
```

In this case we get a `matrix` variable, with boolean values. When applied to
individual columns.  


```r
existing_df['United Kingdom'] > 10
```

```
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

```
## [1] 24 24 23
```

As we did in Python/Pandas, let's use the whole boolean matrix we got before.  


```r
head(existing_df[ existing_df_gt10 ]) # check first few elements
```

```
## [1] 436 429 422 415 407 397
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
head(existing_df_2,2)
```

```
##       Afghanistan Albania Algeria American Samoa Andorra Angola Anguilla
## X1990          -1      -1      -1             -1      -1     -1       -1
## X1991          -1      -1      -1             -1      -1     -1       -1
##       Antigua and Barbuda Argentina Armenia Australia Austria Azerbaijan
## X1990                  -1        -1      -1         7      -1         -1
## X1991                  -1        -1      -1         7      -1         -1
##       Bahamas Bahrain Bangladesh Barbados Belarus Belgium Belize Benin
## X1990      -1      -1         -1        8      -1      -1     -1    -1
## X1991      -1      -1         -1        8      -1      -1     -1    -1
##       Bermuda Bhutan Bolivia Bosnia and Herzegovina Botswana Brazil
## X1990      10     -1      -1                     -1       -1     -1
## X1991      10     -1      -1                     -1       -1     -1
##       British Virgin Islands Brunei Darussalam Bulgaria Burkina Faso
## X1990                     -1                -1       -1           -1
## X1991                     -1                -1       -1           -1
##       Burundi Cambodia Cameroon Canada Cape Verde Cayman Islands
## X1990      -1       -1       -1      7         -1             10
## X1991      -1       -1       -1      7         -1             10
##       Central African Republic Chad Chile China Colombia Comoros
## X1990                       -1   -1    -1    -1       -1      -1
## X1991                       -1   -1    -1    -1       -1      -1
##       Congo, Rep. Cook Islands Costa Rica Croatia Cuba Cyprus
## X1990          -1            0         -1      -1   -1     -1
## X1991          -1           10         -1      -1   -1     -1
##       Czech Republic Cote d'Ivoire Korea, Dem. Rep. Congo, Dem. Rep.
## X1990             -1            -1               -1               -1
## X1991             -1            -1               -1               -1
##       Denmark Djibouti Dominica Dominican Republic Ecuador Egypt
## X1990      -1       -1       -1                 -1      -1    -1
## X1991      -1       -1       -1                 -1      -1    -1
##       El Salvador Equatorial Guinea Eritrea Estonia Ethiopia Fiji Finland
## X1990          -1                -1      -1      -1       -1   -1      -1
## X1991          -1                -1      -1      -1       -1   -1      -1
##       France French Polynesia Gabon Gambia Georgia Germany Ghana Greece
## X1990     -1               -1    -1     -1      -1      -1    -1     -1
## X1991     -1               -1    -1     -1      -1      -1    -1     -1
##       Grenada Guam Guatemala Guinea Guinea-Bissau Guyana Haiti Honduras
## X1990       7   -1        -1     -1            -1     -1    -1       -1
## X1991       7   -1        -1     -1            -1     -1    -1       -1
##       Hungary Iceland India Indonesia Iran Iraq Ireland Israel Italy
## X1990      -1       5    -1        -1   -1   -1      -1     -1    -1
## X1991      -1       4    -1        -1   -1   -1      -1     10    10
##       Jamaica Japan Jordan Kazakhstan Kenya Kiribati Kuwait Kyrgyzstan
## X1990      10    -1     -1         -1    -1       -1     -1         -1
## X1991      10    -1     -1         -1    -1       -1     -1         -1
##       Laos Latvia Lebanon Lesotho Liberia Libyan Arab Jamahiriya Lithuania
## X1990   -1     -1      -1      -1      -1                     -1        -1
## X1991   -1     -1      -1      -1      -1                     -1        -1
##       Luxembourg Madagascar Malawi Malaysia Maldives Mali Malta Mauritania
## X1990         -1         -1     -1       -1       -1   -1    10         -1
## X1991         -1         -1     -1       -1       -1   -1     9         -1
##       Mauritius Mexico Micronesia, Fed. Sts. Monaco Mongolia Montserrat
## X1990        -1     -1                    -1      3       -1         -1
## X1991        -1     -1                    -1      3       -1         -1
##       Morocco Mozambique Myanmar Namibia Nauru Nepal Netherlands
## X1990      -1         -1      -1      -1    -1    -1          -1
## X1991      -1         -1      -1      -1    -1    -1          10
##       Netherlands Antilles New Caledonia New Zealand Nicaragua Niger
## X1990                   -1            -1          10        -1    -1
## X1991                   -1            -1          10        -1    -1
##       Nigeria Niue Northern Mariana Islands Norway Oman Pakistan Palau
## X1990      -1   -1                       -1      8   -1       -1    -1
## X1991      -1   -1                       -1      8   -1       -1    -1
##       Panama Papua New Guinea Paraguay Peru Philippines Poland Portugal
## X1990     -1               -1       -1   -1          -1     -1       -1
## X1991     -1               -1       -1   -1          -1     -1       -1
##       Puerto Rico Qatar Korea, Rep. Moldova Romania Russian Federation
## X1990          -1    -1          -1      -1      -1                 -1
## X1991          -1    -1          -1      -1      -1                 -1
##       Rwanda Saint Kitts and Nevis Saint Lucia
## X1990     -1                    -1          -1
## X1991     -1                    -1          -1
##       Saint Vincent and the Grenadines Samoa San Marino
## X1990                               -1    -1          9
## X1991                               -1    -1          9
##       Sao Tome and Principe Saudi Arabia Senegal Seychelles Sierra Leone
## X1990                    -1           -1      -1         -1           -1
## X1991                    -1           -1      -1         -1           -1
##       Singapore Slovakia Slovenia Solomon Islands Somalia South Africa
## X1990        -1       -1       -1              -1      -1           -1
## X1991        -1       -1       -1              -1      -1           -1
##       Spain Sri Lanka Sudan Suriname Swaziland Sweden Switzerland
## X1990    -1        -1    -1       -1        -1      5          -1
## X1991    -1        -1    -1       -1        -1      5          -1
##       Syrian Arab Republic Tajikistan Thailand Macedonia, FYR Timor-Leste
## X1990                   -1         -1       -1             -1          -1
## X1991                   -1         -1       -1             -1          -1
##       Togo Tokelau Tonga Trinidad and Tobago Tunisia Turkey Turkmenistan
## X1990   -1      -1    -1                  -1      -1     -1           -1
## X1991   -1      -1    -1                  -1      -1     -1           -1
##       Turks and Caicos Islands Tuvalu Uganda Ukraine United Arab Emirates
## X1990                       -1     -1     -1      -1                   -1
## X1991                       -1     -1     -1      -1                   -1
##       United Kingdom Tanzania Virgin Islands (U.S.)
## X1990              9       -1                    -1
## X1991              9       -1                    -1
##       United States of America Uruguay Uzbekistan Vanuatu Venezuela
## X1990                        7      -1         -1      -1        -1
## X1991                        7      -1         -1      -1        -1
##       Viet Nam Wallis et Futuna West Bank and Gaza Yemen Zambia Zimbabwe
## X1990       -1               -1                 -1    -1     -1       -1
## X1991       -1               -1                 -1    -1     -1       -1
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

```
##       United Kingdom Spain Colombia
## X2005             11    24       53
## X2006             11    24       44
## X2007             12    23       43
```

We can do the same thing using `[ ]` as follows.  


```r
existing_df[existing_df["United Kingdom"]>10, c('United Kingdom', 'Spain','Colombia')]
```

```
##       United Kingdom Spain Colombia
## X2005             11    24       53
## X2006             11    24       44
## X2007             12    23       43
```

## Function mapping and grouping  

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

```
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

```
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

```
##  [1] "1990-99" "1990-99" "1990-99" "1990-99" "1990-99" "1990-99" "1990-99"
##  [8] "1990-99" "1990-99" "1990-99" "2000-07" "2000-07" "2000-07" "2000-07"
## [15] "2000-07" "2000-07" "2000-07" "2000-07"
```

Then we can use that column as groping element and use the function `mean`.  


```r
mean_cases_by_period <- aggregate(existing_df, list(Period = before_2000), mean)
mean_cases_by_period
```

```
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

```
##   United Kingdom  Spain Colombia
## 1          9.200 35.300    75.10
## 2         10.125 24.875    53.25
```

## Descriptive statistics  

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

A trick we can to access by column name is use the column names in the original data frame. We also can build a new data frame with the results.    


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

For example, we can easily obtain the average number of existing cases per year with a single call.  


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

Base plotting in R is not very sophisticated when compared with ggplot2, but still
is powerful and handy because many data types have implemented custom `plot()` methods
that allow us to plot them with a single method call. However this is not always the
case and more often than not we will need to pass the right set of elements to our basic plotting functions.  

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
       lty=1, cex=.7,
       col=c("blue","darkgreen","red"), 
       legend=c("UK","Spain","Colombia"))
```

![](R-data-frames_files/figure-html/unnamed-chunk-35-1.png) 

You can compare how easy was to plot three series in Pandas, and how doing the
same thing **with basic plotting** in R gets more verbose. At least we need
three function calls, those for plot and line, and then we have the legend, etc. The base plotting in R is really intended to make quick and dirty charts.  

Now with box plots.  


```r
boxplot(uk_series, spain_series, colombia_series, 
        names=c("UK","Spain","Colombia"),
        xlab="Year", 
        ylab="Existing cases per 100K")
```

![](R-data-frames_files/figure-html/unnamed-chunk-36-1.png) 

This one was way shorter, and we don't even need colours or a legend.  

## Answering questions

We already know that we can use `max` with a data frame column in R and get the maximum value. Additionally, we can use `which.max` in order to get its position (similarly to the use og `argmax` in Pandas). If we use the trasposed dataframe, we can use `lapply` or `sapply` to perform this operation in every year column, getting then either a list or a vector of indices (we will use `sapply` that returns a vector). We just need a little tweak and use a countries vector that we will index to get the country name instead of the index as a result.  


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

###### World trens in TB cases  

Again, in order to explore the world general tendency, we need to sum up every countries’ values for the three datasets, per year. 

But first we need to load the other two datasets for number of deaths and number of new cases. 


```r
# Download files
deaths_file <- getURL("https://docs.google.com/spreadsheets/d/12uWVH_IlmzJX_75bJ3IH5E-Gqx6-zfbDKNvZqYjUuso/pub?gid=0&output=CSV")
new_cases_file <- getURL("https://docs.google.com/spreadsheets/d/1Pl51PcEGlO9Hp4Uh0x2_QM0xVb53p2UDBMPwcnSjFTk/pub?gid=0&output=csv")

# Read into data frames
deaths_df <- read.csv(text = deaths_file, row.names=1, stringsAsFactor=F)
new_df <- read.csv(text = new_cases_file, row.names=1, stringsAsFactor=F)

# Cast data to int (deaths doesn't need it)
new_df[1:18] <- lapply(new_df[1:18], function(x) { as.integer(gsub(',', '', x) )})

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

Now we can plot each line using what we have learnt so far. In order to get a vector with the counts to pass to each plotting function, we use R data frame indexing selecting the first row and all the columns (`[1,]`).  


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

![](R-data-frames_files/figure-html/unnamed-chunk-40-1.png) 

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

![](R-data-frames_files/figure-html/unnamed-chunk-42-1.png) 

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
super_outlier_new_df <- new_df[, super_outlier_countries_by_new_index ]
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

![](R-data-frames_files/figure-html/unnamed-chunk-46-1.png) 

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

![](R-data-frames_files/figure-html/unnamed-chunk-49-1.png) 

