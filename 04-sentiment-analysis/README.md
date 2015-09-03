# Sentiment Analysis  

In this tutorial we will introduce one of those applications of machine learning that leaves you thinking about how to put it into some product or service and build a company around it (and surely some of you with the right set of genes will). [Sentiment analysis](https://en.wikipedia.org/wiki/Sentiment_analysis) refers to the use of *natural language processing*, *text analysis* and *statistical learning* to identify and extract subjective information in source materials.  

In simple terms, sentiment analysis aims to determine the attitude of a speaker or a writer with respect to some topic or the overall contextual polarity of a document. In our case we will use it to determine if a text has a positive, negative, or neutral mood or animosity. Imagine for example that we apply it to entries in Twitter about the hashtag #Windows10. We will be able to determine how people feels about the new version of Microsoft operating system. Of course this is not a big deal applied to an individual piece of text. I believe that the average person will always make a better judgement than what we will build here. However our model will show its benefits when automatically processing large amounts of text very quickly, or processing a large number of entries.     

So in the sentiment analysis process there are a couple of stages more or less differentiated. The first is about *processing natural language*, and the second about *training a model*. The first stage is in charge of processing text in a way that, when we are ready to train our model, we already know what variables the model needs to consider as inputs. The model itself is in charge of learning how to determine the sentiment of a piece of text based on these variables. This might sound a bit complicated right now, but I promise it will be crystal-clear by the end of the tutorial.  

For the model part we will introduce and use linear models. They aren't the most powerful methods in terms of accuracy, but they are simple enough to be interpreted in their results as we will see. Linear methods allow us to define our input variable as a linear combination of input variables.  In tis case we will introduce [logistic regression](https://en.wikipedia.org/wiki/Logistic_regression). 

Finally we will need some data to train our model. For this we will use data from the Kaggle competition [UMICH SI650](https://inclass.kaggle.com/c/si650winter11). As described there, it is a sentiment classification task. Every document (a line in the data file) is a sentence extracted from social media. The files contain:  
 
- Training data: 7086 lines. Format: 1|0 (tab) sentence
- Test data: 33052 lines, each contains one sentence.   

The data was originally collected from opinmind.com (which is no longer active). Our goal is to classify the sentiment of each sentence into "positive" or "negative". So let's have a look at how to load and prepare our data using both, Python and R.  

## Loading and preparing data

As usual, we will first download our datasets locally, and then we will load them into data frames in both, R and Python.  

### R 

In R, we use `read.csv` to read CSV files into `data.frame` variables. Although the R function `read.csv` can work with URLs, https is a problem for R in many cases, so you need to use a package like RCurl to get around it. Moreover, from the Kaggle page description we know that the file is tab-separated, there is not header, and we need to disable quoting since some sentences include quotes and that will stop file parsing at some point.  


```r
library(RCurl)
```

```
## Loading required package: bitops
```

```r
test_data_url <- "https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/testdata.txt"
train_data_url <- "https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/training.txt"

test_data_file <- getURL(test_data_url)
train_data_file <- getURL(train_data_url)

train_data_df <- read.csv(
    text = train_data_file, 
    sep='\t', 
    header=FALSE, 
    quote = "",
    stringsAsFactor=F,
    col.names=c("Sentiment", "Text"))
test_data_df <- read.csv(
    text = test_data_file, 
    sep='\t', 
    header=FALSE, 
    quote = "",
    stringsAsFactor=F,
    col.names=c("Text"))
# we need to convert Sentiment to factor
train_data_df$Sentiment <- as.factor(train_data_df$Sentiment)
```

Now we have our data in data frames. We have 7086 sentences for the training data and 33052 sentences for the test data. The sentences are in a column named `Text` and the sentiment tag (just for training data) in a column named `Sentiment`. Let's have a look at the first few lines of the training data.  


```r
head(train_data_df)
```

```
##   Sentiment
## 1         1
## 2         1
## 3         1
## 4         1
## 5         1
## 6         1
##                                                                                                                           Text
## 1                                                                                      The Da Vinci Code book is just awesome.
## 2 this was the first clive cussler i've ever read, but even books like Relic, and Da Vinci code were more plausible than this.
## 3                                                                                             i liked the Da Vinci Code a lot.
## 4                                                                                             i liked the Da Vinci Code a lot.
## 5                                                     I liked the Da Vinci Code but it ultimatly didn't seem to hold it's own.
## 6  that's not even an exaggeration ) and at midnight we went to Wal-Mart to buy the Da Vinci Code, which is amazing of course.
```

We can also get a glimpse at how tags ar distributed. In R we can use `table`.  


```r
table(train_data_df$Sentiment)
```

```
## 
##    0    1 
## 3091 3995
```

That is, we have data more or less evenly distributed, with 3091 negatively tagged sentences, and 3995 positively tagged sentences. How long on average are our sentences in words?    


```r
mean(sapply(sapply(train_data_df$Text, strsplit, " "), length))
```

```
## [1] 10.88682
```

About 10.8 words in length.  

### Python  

Although we will end up using `sklearn.feature_extraction.text.CountVectorizer`
to create a bag-of-words set of features, and this library directly accepts a
file name, we need to pass instead a sequence of documents since our training
file contains not just text but also sentiment tags (that we need to strip out).

```python
import urllib
    
# define URLs
test_data_url = "https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/testdata.txt"
train_data_url = "https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/training.txt"
    
# define local file names
test_data_file_name = 'test_data.csv'
train_data_file_name = 'train_data.csv'
    
# download files using urlib
test_data_f = urllib.urlretrieve(test_data_url, test_data_file_name)
train_data_f = urllib.urlretrieve(train_data_url, train_data_file_name)
```

Now that we have our files downloaded locally, we can load them into data frames
for processing.

```python
import pandas as pd
    
test_data_df = pd.read_csv(test_data_file_name, header=None, delimiter="\t", quoting=3)
test_data_df.columns = ["Text"]
train_data_df = pd.read_csv(train_data_file_name, header=None, delimiter="\t", quoting=3)
train_data_df.columns = ["Sentiment","Text"]
```
```python
train_data_df.shape
```
```python
    (7086, 2)
```
```python
test_data_df.shape
```
```python
    (33052, 1)
```

Here, `header=0` indicates that the first line of the file contains column names, `delimiter=\t` indicates that the fields are separated by tabs, and `quoting=3` tells Python to ignore doubled quotes, otherwise you may encounter errors trying to read the file.

Let's check the first few lines of the train data.

```python
 train_data_df.head()
```

|.    | Sentiment | Text |
|---|-----------------|---------------------------------------------------|
| 0 | 1         | The Da Vinci Code book is just awesome.           |
| 1 | 1         | this was the first clive cussler i've ever rea... |
| 2 | 1         | i liked the Da Vinci Code a lot.                  |
| 3 | 1         | i liked the Da Vinci Code a lot.                  |
| 4 | 1         | I liked the Da Vinci Code but it ultimatly did... |


And the test data.

```python
test_data_df.head()
```


| . | Text                                                  |
|------|---------------------------------------------------|
| 0    | " I don't care what anyone says, I like Hillar... |
| 1    | have an awesome time at purdue!..                 |
| 2    | Yep, I'm still in London, which is pretty awes... |
| 3    | Have to say, I hate Paris Hilton's behavior bu... |
| 4    | i will love the lakers.                           |


Let's count how many labels do we have for each sentiment class.

```python
train_data_df.Sentiment.value_counts()
```
```python
    1    3995
    0    3091
    dtype: int64
```

Finally, let's calculate the average number of words per sentence. We could do
the following using a list comprehension with the number of words per sentence.

```python
import numpy as np 
np.mean([len(s.split(" ")) for s in train_data_df.Text])
```
```python
    10.886819079875812
```


## Preparing a corpus  

In linguistics, a corpus or text corpus is a large and structured set of texts (nowadays usually electronically stored and processed). They are used to do statistical analysis and hypothesis testing, checking occurrences or validating linguistic rules within a specific language territory. In our particular case, we are talking about the collection of text fragments that we want to classify in either positive or negative sentiment.  

Working with text corpora involves using natural language processing techniques. Bot, R and Python are capable of performing really powerful transformation with textual data. However we will use just some basic ones. The requirements of a bag-of-words classifier are minimal in that sense. We just need to count words, so the process is reduced to do some simplification and unification of terms and then count them. The simplification process mostly includes removing punctuation, lowercasing, removing stop-words, and reducing words to its lexical roots (i.e. [stemming](https://en.wikipedia.org/wiki/Stemming)).    

So in this section we will process our text sentences and create a corpus. We will also extract important words and establish them as input variables for our classifier.  


### R  

In R we will use the [tm](https://cran.r-project.org/web/packages/tm/index.html) package for text mining, so let's import it first and then create a corpus.  
 
```r
library(tm)
```

```
## Loading required package: NLP
```

```r
corpus <- Corpus(VectorSource(c(train_data_df$Text, test_data_df$Text)))
```

Let's explain what we just did. First we used both, test and train data. We need to consider all possible words in our corpus. Then we create a `VectorSource`, that is the input type for the `Corpus` function defined in the package `tm`. That gives us a `VCorpus` object that basically is a collection of content+metadata objects, where the content contains our sentences. For example, the content on the first document looks like this.    


```r
corpus[1]$content
```

```
## [[1]]
## The Da Vinci Code book is just awesome.
```

In order to make use of this corpus, we need to transform its contents as follows.  


```r
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, PlainTextDocument)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, stemDocument)
```

First we put everything in lowercase. The second transformation is needed in order to have each document in the format we will need later on. Then we remove punctuation, english stop words, strip white spaces, and [stem](https://en.wikipedia.org/wiki/Stemming) each word. Right now, the first entry now looks like this.  


```r
corpus[1]$content
```

```
## [[1]]
##  da vinci code book just awesom
```

In our way to find document input features for our classifier, we want to put this corpus in the shape of a document matrix. A document matrix is a numeric matrix containing a column for each different word in our whole corpus, and a row for each document. A given cell equals to the frequency in a document for a given term.  

This is how we do it in R.  


```r
dtm <- DocumentTermMatrix(corpus)
dtm
```

```
## DocumentTermMatrix (documents: 40138, terms: 8383)
## Non-/sparse entries: 244159/336232695
## Sparsity           : 100%
## Maximal term length: 614
## Weighting          : term frequency (tf)
```

If we consider each column as a term for our model, we will end up with a very complex model with 8383 different features. This will make the model slow and probably not very efficient. Some terms or words are more important than others, and we want to remove those that are not so much. We can use the function `removeSparseTerms` from the `tm` package where we pass the matrix and a number that gives the maximal allowed sparsity for a term in our corpus. For example, if we want terms that appear in at least 1% of the documents we can do as follows.  


```r
sparse <- removeSparseTerms(dtm, 0.99)
sparse
```

```
## DocumentTermMatrix (documents: 40138, terms: 85)
## Non-/sparse entries: 119686/3292044
## Sparsity           : 96%
## Maximal term length: 9
## Weighting          : term frequency (tf)
```

We end up with just 85 terms. The closer that value is to 1, the more terms we will have in our `sparse` object, since the number of documents we need a term to be in is smaller.  

Now we want to convert this matrix into a data frame that we can use to train a classifier in the next section.  


```r
important_words_df <- as.data.frame(as.matrix(sparse))
colnames(important_words_df) <- make.names(colnames(important_words_df))
# split into train and test
important_words_train_df <- head(important_words_df, nrow(train_data_df))
important_words_test_df <- tail(important_words_df, nrow(test_data_df))

# Add to original dataframes
train_data_words_df <- cbind(train_data_df, important_words_train_df)
test_data_words_df <- cbind(test_data_df, important_words_test_df)

# Get rid of the original Text field
train_data_words_df$Text <- NULL
test_data_words_df$Text <- NULL
```

Now we are ready to train our first classifier, but first let's see how to work with corpora in Python.    

### Python  

Now in Python. The class [sklearn.feature_extraction.text.CountVectorizer](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html) in the wonderful `scikit learn` Python library converts a collection of text documents to a matrix of token counts. This is just what we need to implement later on our bag-of-words linear classifier.

First we need to init the *vectoriser*. We need to remove punctuations, lowercase,
remove stop words, and stem words. All these steps can be directly performed by
`CountVectorizer` if we pass the right [parameter values](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html). We can do this as follows. Notice that for the stemming step, we need to provide a stemmer ourselves. We will use a basic implementation of a [Porter Stemmer](http://tartarus.org/martin/PorterStemmer/), a stemmer widely used named after its creator.  

```python
import re, nltk
from sklearn.feature_extraction.text import CountVectorizer        
from nltk.stem.porter import PorterStemmer

#######
# based on http://www.cs.duke.edu/courses/spring14/compsci290/assignments/lab02.html
stemmer = PorterStemmer()
def stem_tokens(tokens, stemmer):
    stemmed = []
    for item in tokens:
        stemmed.append(stemmer.stem(item))
    return stemmed

def tokenize(text):
    # remove non letters
    text = re.sub("[^a-zA-Z]", " ", text)
    # tokenize
    tokens = nltk.word_tokenize(text)
    # stem
    stems = stem_tokens(tokens, stemmer)
    return stems
######## 

vectorizer = CountVectorizer(
    analyzer = 'word',
    tokenizer = tokenize,
    lowercase = True,
    stop_words = 'english',
    max_features = 85
)
```

We pas a few parameters to the vectoriser including our `tokenizer` that removes non-letters and performs the stemming, together with lowercasing and removing english stop-words. Although we can also pass a sparsity coefficient to this class, we hace decided to directly specify how many terms to we want in our final vectors (i.e. 85).  

The method `fit_transform` does two functions: First, it fits the model and learns the vocabulary; second, it transforms our corpus data into feature vectors. The input to `fit_transform` should be a list of strings, so we concatenate train and test data as follows.

```python
corpus_data_features = vectorizer.fit_transform(
    train_data_df.Text.tolist() + test_data_df.Text.tolist())
```

`Numpy` arrays are easy to work with, so convert the result to an array.

```python
corpus_data_features_nd = corpus_data_features.toarray()
corpus_data_features_nd.shape
```
```python
    (40138, 85)
```

Let take a look at the words in the vocabulary.

```python
vocab = vectorizer.get_feature_names()
print vocab
```
```python
    [u'aaa', u'amaz', u'angelina', u'awesom', u'beauti', u'becaus', u'boston', u'brokeback', u'citi', u'code', u'cool', u'cruis', u'd', u'da', u'drive', u'francisco', u'friend', u'fuck', u'geico', u'good', u'got', u'great', u'ha', u'harri', u'harvard', u'hate', u'hi', u'hilton', u'honda', u'imposs', u'joli', u'just', u'know', u'laker', u'left', u'like', u'littl', u'london', u'look', u'lot', u'love', u'm', u'macbook', u'make', u'miss', u'mission', u'mit', u'mountain', u'movi', u'need', u'new', u'oh', u'onli', u'pari', u'peopl', u'person', u'potter', u'purdu', u'realli', u'right', u'rock', u's', u'said', u'san', u'say', u'seattl', u'shanghai', u'stori', u'stupid', u'suck', u't', u'thi', u'thing', u'think', u'time', u'tom', u'toyota', u'ucla', u've', u'vinci', u'wa', u'want', u'way', u'whi', u'work']
```

We can also print the counts of each word in the vocabulary as follows.

```python
# Sum up the counts of each vocabulary word
dist = np.sum(corpus_data_features_nd, axis=0)
    
# For each, print the vocabulary word and the number of times it 
# appears in the data set
for tag, count in zip(vocab, dist):
    print count, tag
```

```python
    1179 aaa
    485 amaz
    1765 angelina
    3170 awesom
    2146 beauti
    1694 becaus
    2190 boston
    2000 brokeback
    423 citi
    2003 code
    481 cool
    2031 cruis
    439 d
    2087 da
    433 drive
    1926 francisco
    477 friend
    452 fuck
    1085 geico
    773 good
    571 got
    1178 great
    776 ha
    2094 harri
    2103 harvard
    4492 hate
    794 hi
    2086 hilton
    2192 honda
    1098 imposs
    1764 joli
    1054 just
    896 know
    2019 laker
    425 left
    4080 like
    507 littl
    2233 london
    811 look
    421 lot
    10334 love
    1568 m
    1059 macbook
    631 make
    1098 miss
    1101 mission
    1340 mit
    2081 mountain
    1207 movi
    1220 need
    459 new
    551 oh
    674 onli
    2094 pari
    1018 peopl
    454 person
    2093 potter
    1167 purdu
    2126 realli
    661 right
    475 rock
    3914 s
    495 said
    2038 san
    627 say
    2019 seattl
    1189 shanghai
    467 stori
    2886 stupid
    4614 suck
    1455 t
    1705 thi
    662 thing
    1524 think
    781 time
    2117 tom
    2028 toyota
    2008 ucla
    774 ve
    2001 vinci
    3703 wa
    1656 want
    932 way
    547 whi
    512 work
```

## A bag-of-words linear classifier   

Now we get to the exciting part: building a classifier. The approach we will be using here is called a [bag-of-words model](https://en.wikipedia.org/wiki/Bag-of-words_model). In this kind of model we simplify documents to a multi-set of terms frequencies. That means that, for our model, a document sentiment tag will depend on what words appear in that document, discarding any grammar or word order but keeping multiplicity.  

This is what we just did before, use our text entries to build term frequencies. We ended up with the same entries in our dataset but, instead of having them defined by a whole text, they are now defined by a series of counts of the most frequent words in our whole corpus. Now we are going to use these vectors as features to train a classifier.     

First of all we need to split our train data into train and test data. Why we do that if we already have a testing set? Simple. The test set from the Kaggle competition doesn't have tags at all (obviously). If we want to asses our model accuracy we need a test set with sentiment tags to compare our results.  

### R  

So in order to obtain our evaluation set, we will split using `sample.split` from the [`caTools`](https://cran.r-project.org/web/packages/caTools/index.html) package.    


```r
library(caTools)
set.seed(1234)
# first we create an index with 80% True values based on Sentiment
spl <- sample.split(train_data_words_df$Sentiment, .85)
# now we use it to split our data into train and test
eval_train_data_df <- train_data_words_df[spl==T,]
eval_test_data_df <- train_data_words_df[spl==F,]
```

Building linear models is something that is at the very heart of R. Therefore is very easy, and it requires just a single function call.  


```r
log_model <- glm(Sentiment~., data=eval_train_data_df, family=binomial)
```

```
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
```

```r
summary(log_model)
```

```
## 
## Call:
## glm(formula = Sentiment ~ ., family = binomial, data = eval_train_data_df)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.9361   0.0000   0.0000   0.0035   3.1025  
## 
## Coefficients: (21 not defined because of singularities)
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  6.791e-01  1.674e+00   0.406 0.685023    
## aaa                 NA         NA      NA       NA    
## also         8.611e-01  9.579e-01   0.899 0.368690    
## amaz         2.877e+00  1.708e+00   1.684 0.092100 .  
## angelina            NA         NA      NA       NA    
## anyway      -1.987e+00  1.934e+00  -1.028 0.304163    
## awesom       2.963e+01  3.231e+03   0.009 0.992682    
## back        -1.227e+00  2.494e+00  -0.492 0.622807    
## beauti       2.946e+01  1.095e+04   0.003 0.997853    
## big          2.096e+01  2.057e+03   0.010 0.991871    
## boston              NA         NA      NA       NA    
## brokeback   -2.051e+00  2.559e+00  -0.801 0.423005    
## can         -2.175e+00  1.383e+00  -1.573 0.115695    
## citi                NA         NA      NA       NA    
## code         7.755e+00  3.029e+00   2.561 0.010451 *  
## cool         1.768e+01  2.879e+03   0.006 0.995101    
## crappi      -2.750e+01  4.197e+04  -0.001 0.999477    
## cruis       -3.008e+01  1.405e+04  -0.002 0.998292    
## dont        -5.064e+00  1.720e+00  -2.943 0.003247 ** 
## even        -1.982e+00  2.076e+00  -0.955 0.339653    
## francisco           NA         NA      NA       NA    
## friend       1.251e+01  1.693e+03   0.007 0.994102    
## fuck        -2.613e+00  2.633e+00  -0.992 0.321041    
## geico               NA         NA      NA       NA    
## get          4.405e+00  1.821e+00   2.419 0.015548 *  
## good         4.704e+00  1.260e+00   3.734 0.000188 ***
## got          1.725e+01  2.038e+03   0.008 0.993247    
## great        2.096e+01  1.249e+04   0.002 0.998660    
## harri       -3.054e-01  2.795e+00  -0.109 0.912999    
## harvard             NA         NA      NA       NA    
## hate        -1.364e+01  1.596e+00  -8.544  < 2e-16 ***
## hilton              NA         NA      NA       NA    
## honda               NA         NA      NA       NA    
## imposs      -6.952e+00  1.388e+01  -0.501 0.616601    
## ive          2.420e+00  2.148e+00   1.127 0.259888    
## joli                NA         NA      NA       NA    
## just        -4.374e+00  2.380e+00  -1.838 0.066077 .  
## know        -2.700e+00  1.088e+00  -2.482 0.013068 *  
## laker               NA         NA      NA       NA    
## like         5.296e+00  7.276e-01   7.279 3.36e-13 ***
## littl       -8.384e-01  1.770e+00  -0.474 0.635760    
## london              NA         NA      NA       NA    
## look        -2.235e+00  1.599e+00  -1.398 0.162120    
## lot          8.641e-01  1.665e+00   0.519 0.603801    
## love         1.220e+01  1.396e+00   8.735  < 2e-16 ***
## macbook             NA         NA      NA       NA    
## make        -1.053e-01  1.466e+00  -0.072 0.942710    
## miss         2.693e+01  4.574e+04   0.001 0.999530    
## mission      9.138e+00  1.378e+01   0.663 0.507236    
## mit                 NA         NA      NA       NA    
## mountain    -2.847e+00  2.042e+00  -1.394 0.163256    
## movi        -2.433e+00  6.101e-01  -3.988 6.67e-05 ***
## much         1.874e+00  1.516e+00   1.237 0.216270    
## need        -6.816e-01  2.168e+00  -0.314 0.753196    
## new         -2.709e+00  1.718e+00  -1.577 0.114797    
## now          1.416e+00  3.029e+00   0.468 0.640041    
## one         -4.691e+00  1.641e+00  -2.858 0.004262 ** 
## pari                NA         NA      NA       NA    
## peopl       -3.243e+00  1.808e+00  -1.794 0.072869 .  
## person       3.824e+00  1.643e+00   2.328 0.019907 *  
## potter      -5.702e-01  2.943e+00  -0.194 0.846372    
## purdu               NA         NA      NA       NA    
## realli       5.897e-02  7.789e-01   0.076 0.939651    
## right        6.194e+00  3.075e+00   2.014 0.043994 *  
## said        -2.173e+00  1.927e+00  -1.128 0.259326    
## san                 NA         NA      NA       NA    
## say         -2.584e+00  1.948e+00  -1.326 0.184700    
## seattl              NA         NA      NA       NA    
## see          2.743e+00  1.821e+00   1.506 0.132079    
## shanghai            NA         NA      NA       NA    
## still        1.531e+00  1.478e+00   1.036 0.300146    
## stori       -7.405e-01  1.806e+00  -0.410 0.681783    
## stupid      -4.408e+01  4.838e+03  -0.009 0.992731    
## suck        -5.333e+01  2.885e+03  -0.018 0.985252    
## thing       -2.562e+00  1.534e+00  -1.671 0.094798 .  
## think       -8.548e-01  7.275e-01  -1.175 0.239957    
## though       1.432e+00  2.521e+00   0.568 0.570025    
## time         2.997e+00  1.739e+00   1.723 0.084811 .  
## tom          2.673e+01  1.405e+04   0.002 0.998482    
## toyota              NA         NA      NA       NA    
## ucla                NA         NA      NA       NA    
## vinci       -7.760e+00  3.501e+00  -2.216 0.026671 *  
## want         3.642e+00  9.589e-01   3.798 0.000146 ***
## way          1.966e+01  7.745e+03   0.003 0.997975    
## well         2.338e+00  1.895e+01   0.123 0.901773    
## work         1.715e+01  3.967e+04   0.000 0.999655    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 8251.20  on 6022  degrees of freedom
## Residual deviance:  277.97  on 5958  degrees of freedom
## AIC: 407.97
## 
## Number of Fisher Scoring iterations: 23
```

The first parameter is a formula in the form `Output~Input` where the `.` at the input side means to use every single variable but the output one. Then we pass the data frame and `family=binomial` that means we want to use logistic regression.  

The summary function gives us really good insight into the model we just built. The coefficient section lists all the input variables used in the model. A series of asterisks at the very end of them gives us the importance of each one, with `***` being the greatest significance level, and `**` or `*` being also important. These starts relate to the values in `Pr`. for example, we get that the stem `awesom` has a great significance, with a high positive `Estimate` value. That means that a document with that stem is very likely to be tagged with sentiment 1 (positive). We see the oposite case with the stem `hate`. We also see that there are many terms that doesn't seem to have a great significance.    

So let's use our model with the test data.  


```r
log_pred <- predict(log_model, newdata=eval_test_data_df, type="response")
```

```
## Warning in predict.lm(object, newdata, se.fit, scale = 1, type =
## ifelse(type == : prediction from a rank-deficient fit may be misleading
```

The previous `predict` called with `type="response"` will return probabilities (see [logistic regression](https://en.wikipedia.org/wiki/Logistic_regression)). Let's say that we want a .5 threshold for a document to be classified as positive (Sentiment tag equals 1). Then we can calculate accuracy as follows.   


```r
# Calculate accuracy based on prob
table(eval_test_data_df$Sentiment, log_pred>.5)
```

```
##    
##     FALSE TRUE
##   0   453   11
##   1     9  590
```

The cases where our model performed properly are given by the diagonal.  


```r
(453 + 590) / nrow(eval_test_data_df)
```

```
## [1] 0.9811853
```

This is a very good accuracy. It seems that our bag of words approach works nicely with this particular problem.  

We know we don't have tags on the given test dataset. Still we will try something. We will use our model to tag their entries and then get a random sample of entries and visually inspect how are they tagged. We can do this quickly in R as follows.  


```r
log_pred_test <- predict(log_model, newdata=test_data_words_df, type="response")
```

```
## Warning in predict.lm(object, newdata, se.fit, scale = 1, type =
## ifelse(type == : prediction from a rank-deficient fit may be misleading
```

```r
test_data_df$Sentiment <- log_pred_test>.5
    
set.seed(1234)
spl_test <- sample.split(test_data_df$Sentiment, .0005)
test_data_sample_df <- test_data_df[spl_test==T,]
```

So lest check what has been classified as positive entries.  


```r
test_data_sample_df[test_data_sample_df$Sentiment==T, c('Text')]
```

```
##  [1] "Love Story At Harvard [ awesome drama!"                                                                                                                                                                                              
##  [2] "boston's been cool and wet..."                                                                                                                                                                                                       
##  [3] "On a lighter note, I love my macbook."                                                                                                                                                                                               
##  [4] "Angelina Jolie was a great actress in Girl, Interrupted."                                                                                                                                                                            
##  [5] "I love Angelina Jolie and i love you even more, also your music on your site is my fav."                                                                                                                                             
##  [6] "And Tom Cruise is beautiful...."                                                                                                                                                                                                     
##  [7] "i love Kappo Honda, which is across the street.."                                                                                                                                                                                    
##  [8] "It's about the MacBook Pro, which is awesome and I want one, but I have my beloved iBook, and believe you me, I love it.."                                                                                                           
##  [9] "I mean, we knew Harvard was dumb anyway -- right, B-girls? -- but this is further proof)..."                                                                                                                                         
## [10] "anyway, shanghai is really beautiful ï¼\u008c æ»¨æ±\u009få¤§é\u0081\u0093æ\u0098¯å¾\u0088ç\u0081µç\u009a\u0084å\u0095¦ ï¼\u008c é\u0082£ä¸ªstarbucksæ\u0098¯ä¸\u008aæµ·é£\u008eæ\u0099¯æ\u009c\u0080å¥½ç\u009a\u0084starbucks ~ ~!!!"
## [11] "i love shanghai too =)."
```

And negative ones.  


```r
test_data_sample_df[test_data_sample_df$Sentiment==F, c('Text')]
```

```
## [1] "the stupid honda lol or a BUG!.."                                                                                                               
## [2] "Angelina Jolie says that being self-destructive is selfish and you ought to think of the poor, starving, mutilated people all around the world."
## [3] "thats all i want from u capital one!"                                                                                                           
## [4] "DAY NINE-SAN FRANCISCO, CA. 8am sucks."                                                                                                         
## [5] "I hate myself \" \" omg MIT sucks!"                                                                                                             
## [6] "Hate London, Hate London....."
```

### Python  

In order to perform logistic regression in Python we use [LogisticRegression](http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html). But first let's split our training data in order to get an evaluation set. Wether we use R or Python, the problem with not having labels in our original test set still persists, and we need to create a separate evaluation set from our original training data if we want to evaluate our classifier. We will use [train test split](http://scikit-learn.org/stable/modules/generated/sklearn.cross_validation.train_test_split.html).

```python
from sklearn.cross_validation import train_test_split
    
# remember that corpus_data_features_nd contains all of our 
# original train and test data, so we need to exclude
# the unlabeled test entries
X_train, X_test, y_train, y_test  = train_test_split(
        corpus_data_features_nd[0:len(train_data_df)], 
        train_data_df.Sentiment,
        train_size=0.85, 
        random_state=1234)
```

Now we are ready to train our classifier.

```python
from sklearn.linear_model import LogisticRegression
    
log_model = LogisticRegression()
log_model = log_model.fit(X=X_train, y=y_train)
```

Now we use the classifier to label our evaluation set. We can use either
`predict` for classes or `predict_proba` for probabilities.

```python
y_pred = log_model.predict(X_test)
```

There is a function for classification called [sklearn.metrics.classification_report](http://scikit-learn.org/stable/modules/generated/sklearn.metrics.classification_report.html) which calculates several types of (predictive) scores on a classification model. Check also [sklearn.metrics](http://scikit-learn.org/stable/modules/classes.html#sklearn-metrics-metrics). In this case we want to know our classifier's precision.

```python
from sklearn.metrics import classification_report
print(classification_report(y_test, y_pred))
```

```python
                 precision    recall  f1-score   support
    
              0       0.98      0.99      0.98       467
              1       0.99      0.98      0.99       596
    
    avg / total       0.98      0.98      0.98      1063
```   


Finally, we can re-train our model with all the training data and use it for
sentiment classification with the original (unlabeled) test set.

```python
# train classifier
log_model = LogisticRegression()
log_model = log_model.fit(X=corpus_data_features_nd[0:len(train_data_df)], y=train_data_df.Sentiment)
    
# get predictions
test_pred = log_model.predict(corpus_data_features_nd[len(train_data_df):])
    
# sample some of them
import random
spl = random.sample(xrange(len(test_pred)), 15)
    
# print text and labels
for text, sentiment in zip(test_data_df.Text[spl], test_pred[spl]):
    print sentiment, text
```

```python
    1 I love paris hilton...
    1 i love seattle..
    1 I love those GEICO commercials especially the one with Mini-Me doing that little rap dance.; )..
    1 However you look at it, I've been here almost two weeks now and so far I absolutely love UCLA...
    0 By the time I left the Hospital, I had no time to drive to Boston-which sucked because 1)
    1 Before I left Missouri, I thought London was going to be so good and cool and fun and a really great experience and I was really excited.
    0 I know you're way too smart and way too cool to let stupid UCLA get to you...
    0 PARIS HILTON SUCKS!
    1 Geico was really great.
    0 hy I Hate San Francisco, # 29112...
    0 I need to pay Geico and a host of other bills but that is neither here nor there.
    1 As much as I love the Lakers and Kobe, I still have to state the facts...
    1 I'm biased, I love Angelina Jolie..
    0 I despise Hillary Clinton, but I don't think she's cold.
    0 i hate geico and old navy.
```

## Conclusions  

So judge by yourself. Is our classifier doing a good job at all? Considering how small our training data is, first we are getting a decent accuracy in the eval split, and second, when getting a sample of predictions for the test set, most of the tags make sense. It would be great to find a larger training dataset with labels. Doing so we will be able to train a better model and also to have more data to split into train/eval sets and check our model accuracy.   

In any case, we have used very simple methods here. And mostly using default parameters. There is a lot of space for improvement in both areas. We can fine tune each library parameters and we can also try more sophisticated parameters (e.g. Random Forests are very powerful).  Additionally, we can use a different sparsity coefficient when selecting important words. Our models just considered 85 words. We might try increasing this number to take into account more words (or less?) and see how the accuracy changes.  

Finally, although the purpose of these tutorials is not to find a winer between R and Python  but to show that there are just problems to solve and methods that can use with both platforms, we find here some differences. In the case of R for example we have a nice `summary` function that we can use with the result of training a linear classifier. This summary shows us very important information regarding how significative each feature is (i.e. each word in our case). Also the text analysis process seems more straightforward in R. But Python as usual is more structured and granular, and is easier to adapt to our particular needs by plugging and pipelining different parts of the process.  

Where to go from here? The next step should be to put one of our models into a data product people can use. For example, we could use the R model we just built to create a web application where we can submit text and get a sentiment classification estimate. For that we could use the [Shiny](http://shiny.rstudio.com/) platform, a great way to quickly create and share data products as web applications.   

If you read here, you can learn how we have done just that:  

- [Building a web-based sentiment classifier using Shiny]()