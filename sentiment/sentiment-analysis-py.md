
## Getting and Preparing data

Although later on we will use `sklearn.feature_extraction.text.CountVectorizer`
to create a bag-of-words set of features, and this library directly accepts a
file name, we need to pass instead a secuence of documents since our training
file contains not just text but also sentiment tags (that we need to strip out).


    import urllib
    
    # define URLs
    test_data_url = "https://kaggle2.blob.core.windows.net/competitions-data/inclass/2558/testdata.txt?sv=2012-02-12&se=2015-08-06T10%3A32%3A23Z&sr=b&sp=r&sig=a8lqVKO0%2FLjN4hMrFo71sPcnMzltKk1HN8m7OPolArw%3D"
    train_data_url = "https://kaggle2.blob.core.windows.net/competitions-data/inclass/2558/training.txt?sv=2012-02-12&se=2015-08-06T10%3A34%3A08Z&sr=b&sp=r&sig=meGjVzfSsvayeJiDdKY9S6C9ep7qW8v74M6XzON0YQk%3D"
    
    # define local file names
    test_data_file_name = 'test_data.csv'
    train_data_file_name = 'train_data.csv'
    
    # download files using urlib
    test_data_f = urllib.urlretrieve(test_data_url, test_data_file_name)
    train_data_f = urllib.urlretrieve(train_data_url, train_data_file_name)

Now that we have our files downloaded locally, we can load them into data frames
for processing.


    import pandas as pd
    
    test_data_df = pd.read_csv(test_data_file_name, header=None, delimiter="\t", quoting=3)
    test_data_df.columns = ["Text"]
    train_data_df = pd.read_csv(train_data_file_name, header=None, delimiter="\t", quoting=3)
    train_data_df.columns = ["Sentiment","Text"]


    train_data_df.shape




    (7086, 2)




    test_data_df.shape




    (33052, 1)



Here, `header=0` indicates that the first line of the file contains column
names, `delimiter=\t` indicates that the fields are separated by tabs, and
`quoting=3` tells Python to ignore doubled quotes, otherwise you may encounter
errors trying to read the file.

Let's check the first few lines of the train data.


    train_data_df.head()




<div style="max-height:1000px;max-width:1500px;overflow:auto;">
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Sentiment</th>
      <th>Text</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td> 1</td>
      <td>           The Da Vinci Code book is just awesome.</td>
    </tr>
    <tr>
      <th>1</th>
      <td> 1</td>
      <td> this was the first clive cussler i've ever rea...</td>
    </tr>
    <tr>
      <th>2</th>
      <td> 1</td>
      <td>                  i liked the Da Vinci Code a lot.</td>
    </tr>
    <tr>
      <th>3</th>
      <td> 1</td>
      <td>                  i liked the Da Vinci Code a lot.</td>
    </tr>
    <tr>
      <th>4</th>
      <td> 1</td>
      <td> I liked the Da Vinci Code but it ultimatly did...</td>
    </tr>
  </tbody>
</table>
</div>



And the test data.


    test_data_df.head()




<div style="max-height:1000px;max-width:1500px;overflow:auto;">
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Text</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td> " I don't care what anyone says, I like Hillar...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>                 have an awesome time at purdue!..</td>
    </tr>
    <tr>
      <th>2</th>
      <td> Yep, I'm still in London, which is pretty awes...</td>
    </tr>
    <tr>
      <th>3</th>
      <td> Have to say, I hate Paris Hilton's behavior bu...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>                           i will love the lakers.</td>
    </tr>
  </tbody>
</table>
</div>



Let's count how many labels do we have for each sentiment class.


    train_data_df.Sentiment.value_counts()




    1    3995
    0    3091
    dtype: int64



Finally, let's calculate the average number of words per sentence. We could do
the following using a list comprehension with the number of words per sentence.


    import numpy as np 
    
    np.mean([len(s.split(" ")) for s in train_data_df.Text])




    10.886819079875812



## Preparing a *corpus*

The class [sklearn.feature_extraction.text.CountVectorizer](http://scikit-learn.
org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.htm
l) in the wonderful `scikit learn` Python library converts a collection of text
documents to a matrix of token counts. This is just what we need to implement
later on our bag-of-words linear classifier.

First we need to init the vectorizer. We need to remove puntuations, lowercase,
remove stop words, and stem words. All these steps can be directly performed by
`CountVectorizer` if we pass the right parameter values. We can do as follows.


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

The method `fit_transform` does two functions: First, it fits the model and
learns the vocabulary; second, it transforms our corpus data into feature
vectors. The input to `fit_transform` should be a list of strings, so we
concatenate train and test data as follows.


    corpus_data_features = vectorizer.fit_transform(train_data_df.Text.tolist() + test_data_df.Text.tolist(),)

Numpy arrays are easy to work with, so convert the result to an array.


    corpus_data_features_nd = corpus_data_features.toarray()
    corpus_data_features_nd.shape




    (40138, 85)




    # Take a look at the words in the vocabulary
    vocab = vectorizer.get_feature_names()
    print vocab

    [u'aaa', u'amaz', u'angelina', u'awesom', u'beauti', u'becaus', u'boston', u'brokeback', u'citi', u'code', u'cool', u'cruis', u'd', u'da', u'drive', u'francisco', u'friend', u'fuck', u'geico', u'good', u'got', u'great', u'ha', u'harri', u'harvard', u'hate', u'hi', u'hilton', u'honda', u'imposs', u'joli', u'just', u'know', u'laker', u'left', u'like', u'littl', u'london', u'look', u'lot', u'love', u'm', u'macbook', u'make', u'miss', u'mission', u'mit', u'mountain', u'movi', u'need', u'new', u'oh', u'onli', u'pari', u'peopl', u'person', u'potter', u'purdu', u'realli', u'right', u'rock', u's', u'said', u'san', u'say', u'seattl', u'shanghai', u'stori', u'stupid', u'suck', u't', u'thi', u'thing', u'think', u'time', u'tom', u'toyota', u'ucla', u've', u'vinci', u'wa', u'want', u'way', u'whi', u'work']


We can also print the counts of each word in the vocabulary as follows.


    # Sum up the counts of each vocabulary word
    dist = np.sum(corpus_data_features_nd, axis=0)
    
    # For each, print the vocabulary word and the number of times it 
    # appears in the training set
    for tag, count in zip(vocab, dist):
        print count, tag

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


## A bag-of-words linear classifier

In order to perform logistic regression in Python we use
[sklearn.linear_model.LogisticRegression](http://scikit-learn.org/stable/modules
/generated/sklearn.linear_model.LogisticRegression.html). But first let's split
our training data in order to get an evaluation set. We will use
[sklearn.cross_validation.train_test_split](http://scikit-learn.org/stable/modul
es/generated/sklearn.cross_validation.train_test_split.html).


    from sklearn.cross_validation import train_test_split
    
    # remember that corpus_data_features_nd contains all of our original train and test data, so we need to exclude
    # the unlabeled test entries
    X_train, X_test, y_train, y_test  = train_test_split(
        corpus_data_features_nd[0:len(train_data_df)], 
        train_data_df.Sentiment,
        train_size=0.85, 
        random_state=1234)

Now we are ready to train our classifier.


    from sklearn.linear_model import LogisticRegression
    
    log_model = LogisticRegression()
    log_model = log_model.fit(X=X_train, y=y_train)

Now we use the classifier to label our evaluation set. We can use either
`predict` for classes or `predict_proba` for probabilities.


    y_pred = log_model.predict(X_test)

There is a function for classification called
[sklearn.metrics.classification_report](http://scikit-
learn.org/stable/modules/generated/sklearn.metrics.classification_report.html)
which calculates several types of (predictive) scores on a classification model.
Check also [sklearn.metrics](http://scikit-learn.org/stable/modules/classes.html
#sklearn-metrics-metrics). In this case we want to check our classifier
accuracy.


    from sklearn.metrics import classification_report
    
    print(classification_report(y_test, y_pred))

                 precision    recall  f1-score   support
    
              0       0.98      0.99      0.98       467
              1       0.99      0.98      0.99       596
    
    avg / total       0.98      0.98      0.98      1063
    


Finally, we can re-train our model with all the training data and use it for
sentiment classification with the original (unlabeled) test set.


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

