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
existing_df <- read.csv(text = existing_cases_file, row.names=1)
```

Our dataset is a bit tricky. If we have a look at what we got into the data frame with `head`  


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



