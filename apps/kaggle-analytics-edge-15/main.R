source("loader.R")
# source("add_corpus_headline.R")
# source("add_corpus_snippet.R")
# source("add_corpus_abstract.R")
source("add_corpus_all.R")

# Remove these as needed
newsTrain$Headline <- NULL
newsTest$Headline <- NULL

newsTrain$Abstract <- NULL
newsTest$Abstract <- NULL

newsTrain$Snippet <- NULL
newsTest$Snippet <- NULL

source("split_eval.R")
source("train_random_forest.R")
source("train_glm.R")

# 0.9472158 without any corpus at all, ntree=500
# 0.9473081 ntree=1000
# 0.9474844 ntree=5000
# 0.9475809 ntree=10000
# 0.9474634 ntree=25000
# 0.9474508 ntree=50000

# 0.9463428 just header at .99 (42 terms)
# 0.944299 just header at .995 (142 terms)
# 0.9449369 top 100 terms diff, ntree=10000 (30 terms)
# 0.9446683 top 100 terms diff, ntree=500 (30 terms)
# 0.9474214 top 50 terms diff, ntree=500 (27 terms)
# 0.9477488 top 25 terms diff, ntree=500 (15 terms)
# 0.9484497 top 20 terms diff, ntree=500 (13 terms)
# 0.9487225 top 20 terms diff, ntree=10000 (13 terms)
# 0.9463932 top 15 terms diff, ntree=500 (9 terms)
# 0.9481391 top 17 terms diff, ntree=500 (10 terms)
# 0.9483322 top 21 terms (12 terms)


# 0.9375378 just snippet at .99 (229 vars)
# 0.9415668 just snippet at .995 (532 vars)

# 0.9376007 just abstract at .99 (223 vars)
# 0.9387507 just abstract at .995 (525 vars)

# 0.9387549 with header+snippet at .995/.995
# 0.939013 with header+snippet at .99/.99
