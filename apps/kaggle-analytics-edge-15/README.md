# Kaggle 15.071x - The Analytics Edge (Spring 2015)

Files for my solution to [this Kaggle competition](https://www.kaggle.com/c/15-071x-the-analytics-edge-competition-spring-2015)

## Task description  

The task description can be found [here](https://www.kaggle.com/c/15-071x-the-analytics-edge-competition-spring-2015):  

*In this competition, we challenge you to develop an analytics model that will help the New York Times understand the features of a blog post that make it popular.*

## Files description  

### `main.R`  

The main script calling the others in order to generate a prediction.  


### `loader.R`  

Loads data into a dataframe.  


### `add_corpus_XXX.R`  

Different scripts that generate a corpus from text fields and add them as
predictors.  

This process includes creating linear models to determine significative terms in order to do variable selection.  

### `split_eval.R`  

Splits training data into training and test. TODO: do cross validation.  

### `train_random_forest.R`  

Trains a **Random Forest** and makes predictions.  


### `results` folder  

Contains different predictions as CSV files.  

## Future works  

- Use ensemble methods.  
- Do cross-validation for better parameter selection.  
- Impute missing values for section/subsection. Right now empty values are taking as a factor level and therefore as meaninful for predictions.    
- Do more exploratory data analysis, specially for missclassified cases (e.g. use word clouds).  
- Filter out non memingful frequent terms in corpus (e.g. *new*, *york*, etc.)
