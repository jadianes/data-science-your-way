# Data Science your way - R vs Python
# Episode I: Data Frames & Exploratory Data Analysis    

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
We will also introduce one of the first tasks we face when we have our data loaded, that of
the Exploratory Data Analysis. This task can be performed using data frames and basic plots 
as we will show here for both, Python and R.    


## What is a DataFrame?  

A data frame is used for storing tabular data. It has labeled axes (rows and columns) that we
can use to perform arithmetic operations at on levels.  

The concept was introduced in R before it was in Python 
[Pandas](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html) so the later
repeats many of the ideas from the former. In R, a `data.frame` is a list of vector variables of 
the same number of elements (rows) with unique row names. That is, each column is a vector with an
associated name, and each row is a series of vector elements that correspond to the same position
in each of the column-vectors.  

In Pandas, a `DataFrame` can be thought of as a dict-like container for `Series` objects, where a 
`Series` is a one-dimensional [NumPy ndarray](http://docs.scipy.org/doc/numpy/reference/generated/numpy.ndarray.html)
with axis labels (including time series). By default, each `Series` correspond with a column in the 
resulting `DataFrame`.  

But let's see both data types in practice. First of all we will introduce a data set that will be used 
in order to explain the data frame creation process and what data analysis tasks can be done with 
a data frame. Then we will have a separate section for each platform repeating every task for you to
be able to move from one to the other easily in the future.     

## Introducing Gapminder World datasets  

The [Gapminder website](http://www.gapminder.org/) presents itself as *a fact-based worldview*. It is
a comprehensive resource for data regarding different countries and terrotiries indicators. Its
[Data section](http://www.gapminder.org/data/) contains a list of datasets that can be accessed as
Google Spreadsheet pages (add `&output=csv` to download as CSV). Each indicator dataset is tagged 
with a *Data provider*, a *Category*, and a *Subcategory*.  

For this tutorial, we will use different datasets related to Infectious Tuberculosis:  

- All TB deaths per 100K: https://docs.google.com/spreadsheets/d/12uWVH_IlmzJX_75bJ3IH5E-Gqx6-zfbDKNvZqYjUuso/pub?gid=0    
- TB estimated prevalence (existing cases) per 100K: https://docs.google.com/spreadsheets/d/1X5Jp7Q8pTs3KLJ5JBWKhncVACGsg5v4xu6badNs4C7I/pub?gid=0  
- TB estimated incidence (new cases) per 100K: https://docs.google.com/spreadsheets/d/1Pl51PcEGlO9Hp4Uh0x2_QM0xVb53p2UDBMPwcnSjFTk/pub?gid=0  

First thing we need to do is to download the files for later use within our R and Python environments.
There is a description of each dataset if we click in its title in the [list of datasets](http://www.gapminder.org/data/).
When performing any data analysis task, it is esential to understand our data as much as possible, so go
there and have a read. Basically each cell in the dataset contains the data related to the number of 
Tuberculosis cases per 100K people during the given year (column) for each country or region (row).      

We will use these datasets to better understand the TB incidence in different regions in time.  

## Questions we want to answer  

In any data analysis process, there is one or more questions we want to answer. That is the most
basic and important step in the whole process, to define these questions. Since we are going to perform
some Exploratory Data Analysis in our TB dataset, these are the questions we want to answer:  

- Which are the countries with the highest and infectious TB incidence?  
- What is the general world tendency in the period from 1990 to 2007?  
- What countries don't follow that tendency?  
- What events might have defined that world tendency and why do we have countries out of tendency?  
