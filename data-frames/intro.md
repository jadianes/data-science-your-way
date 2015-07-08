# Data Science your way - R vs Python
# Episode I: Data Frames  

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
[Data section](http://www.gapminder.org/data/) contains a list of datasets that can be downloaded in
Microsoft Excel file format. Each indicator dataset is tagged with a *Data provider*, a *Category*, and
a *Subcategory*.  

For this tutorial, we will use the 
[Infectious TB, number of new cases - estimated](http://spreadsheets.google.com/pub?key=rOPfJcbTTIyS-vxDWbkfNLA&output=xls)
dataset. First thing we need to do is to download the file for later use within our R and Python environments.
There is a description of the dataset if we click in its title in the [list of datasets](http://www.gapminder.org/data/).
When performing any data analysis task, it is esential to understand our data as much as possible, so go
there and have a read. Basically each cell in the dataset contains the estimated number of new Tuberculosis cases (infectious) 
during the given year (column) for each country or region (row).      

