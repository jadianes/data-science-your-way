The purpose of many data science projects is to end up with a model that can be used within an organisation to solve a particular problem. If this is our case, we need to determine the right representation of that model so it can be shared in the easiest, cheapest, and most effective way. Web data products are an ideal vahicle for delivering machine learning models. The Web can be accessed almost everywhere and by multiple users. Moreoever, the typical web application deployment cycle allows us to do easy updates.  

In this tutorial we will introduce [Shiny](http://shiny.rstudio.com/) a web development framework and [application server](http://www.shinyapps.io/) for the R language. This might seem counterintuititve at first. The R language is not the best language for software design or enterprise systems. But if our web application requirements are simple enough, we can benefit of well known architectural patterns such as [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) being implemented in the framework and leave us just with the tast of defining the necessary user interface elements and their interactions with our R models and data strcutures.  

This tutorial will make use of some of the techniques we used to build a sentiment classifier in a [previous tutorial](https://www.codementor.io/python/tutorial/data-science-python-r-sentiment-classification-machine-learning). We will repeat the code here, since we are using a different algorithm (random forest), together with some improvements on model selection. But if you are interested about the fundamentals of such a model, and how to build it using Python, have a look at that tutorial.

In the end, we will end up building an [application like this one](https://jadianes.shinyapps.io/sentimentclassifier). Hopefuly you will find it exciting!  

*Note: the app hosted at [Shinyapps.io](https://www.shinyapps.io) is running on a free account. That means that is very restricted in computational resources and will show to be unresponsible either when a lot of connections are made, or when large files / large number of trees are used. The best way to follow the tutorial is to try the app yourself locally using RStudio.*  

## Building a classifier   

### Model selection  

- About intersection of features  

### Random Forests  

- We don't need to interpret our model but to improve it's efficacy 
- Why do we need to re-train the model every time new data comes in? Because we need to decide what are the most common variables to consider and this depends not just on the train data but on the new data.  

## User Interface  

- UI elements: location and purpose, include screenshot or link to app  
- Shiny implementation

## Server part


### Reactive actions and even flow   


## Usage examples

## Conclusions  

- It is not the definitive framework for web applications
- However it is perfect for rapid delivery of data products where the UI is relatively straightforward and the power is in an R model
- Personally I see a lot of possibilities for freelancing
