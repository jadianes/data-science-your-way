- Intro

## Wine reviews and ratings

- Wine name: this can be further decomposed into vintage, country, type, etc.
- Rating: 0 to 5 rating system
- Review: a text based comment on the wine
- User

## A clustering-based recommendation engine  

Cluster users, then the process is as follows:
- Cluster the current user
- Get closest users within the cluster
- Get highest un-rated wines for the closest user, the the next one, etc

## Koding as a development server

- Sign up for free, invite a couple of "friends" until we get 4Gb of HD
- Install Anaconda
- Install Django using Anaconda pip and proceed to the next section 

## The core of our Django web application

- Introduce with an overview of the steps to create the project, add the model entity, create views, etc

### The `django-admin.py` script  

- Explain its role within the Django development cycle

### Starting up the project with `startproject`

```shell
django-admin.py startproject winerama
```
Let’s look at what we just created by running the `startproject` command.

```shell
tree winerama  

winerama
|-- manage.py
`-- winerama
    |-- __init__.py
    |-- settings.py
    |-- urls.py
    `-- wsgi.py
```

This requires a bit of an explanation:  

- The `winerama/` root directory is a container for our project.  
- `manage.py` is a command-line utility that allows us you interact with our project in various ways. We will use it all the time so its purpose will be clear in a minute.
- The inner `winerama/` directory is the actual Python package for our project. Its name is also the Python package name for the project files.  
- `mysite/__init__.py` is an empty file that tells Python that this directory should be considered a Python package.  
- `mysite/settings.py` is the settings/configuration file for our project.  
- `mysite/urls.py` contains the URL declarations for this Django project.  
- `mysite/wsgi.py` is an entry-point for WSGI-compatible web servers to serve our project.  

### Running the server with `runserver`  

```shell
python manage.py runserver 0.0.0.0:8000
```
Then we can go to our Koding server public URL `http://KODING_USERNAME.koding.io:8000` where we replace `KODING_USERNAME` with our Koding user and check how the website looks so far.  


### Database setup  

- See Django tutorial

```shell
python manage.py migrate
```

### Apps vs projects  

Now we are ready to start our wine reviews app. But wait, what is the difference between and app and a project? From the Django website:    

> What’s the difference between a project and an app? An app is a Web application that does something – e.g., a Weblog system, a database of public records or a simple poll app. A project is a collection of configuration and apps for a particular Web site. A project can contain multiple apps. An app can be in multiple projects. [...] Django apps are “pluggable”: You can use an app in multiple projects, and you can distribute apps, because they don’t have to be tied to a given Django installation.  

So in our case, our *Winerama* project will contain our first `reviews` app, that will allow users to add wine reviews. In order to do that, from the root `winerame` folder where `manage.py` is, we need to use the `startapp` command as follows.  

```shell
python manage.py startapp reviews
```  
This will create the following folder structure.  

```shell
tree reviews

reviews
|-- __init__.py
|-- admin.py
|-- migrations
|   `-- __init__.py
|-- models.py
|-- tests.py
`-- views.py
```

We will get to know those files in the following sections, while creating model entities, views, and seting up the admin interface.  

But first we need to activate our reviews app. Edit the `winerama/settings.py` file, and change the `INSTALLED_APPS` setting to include the string 'reviews' as follows.  

```python
INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'reviews',
)

```

### Adding model entities  

Our wine reviews app contains two model entities: Wine and Review. A Wine has just a name. A Review has three fields: a name for the user that made the review, a wine rating, and a text review.  

These two entities are represented by Python classes that we add to the `reviews/models.py` file as follows.  

```python
from django.db import models

class Wine(models.Model):
    name = models.CharField(max_length=200)
    def __unicode__(self):
        return self.name
        
class Review(models.Model):
    wine = models.ForeignKey(Wine)
    pub_date = models.DateTimeField('date published')
    user_name = models.CharField(max_length=100)
    review_text = models.CharField(max_length=200)
    rating = models.IntegerField(default=0)
```

Each of our two model entities is represented by a class that subclasses `django.db.models.Model`. Each model class variable represents a database field in the model and is represented by an instance of a Field sub-class. This specifies what type of data each field holds. The field name is its code reference in machine-friendly format, and our database will use it as the column name.

You can use an optional first positional argument to a Field to designate a human-readable name. If this field isn’t provided, Django will use the machine-readable name.  

Some field classes have required and optional arguments, such as `max_length` for `CharField`, etc. That’s used both, in the database schema, and in validation.

Finally, we specify relationships between entities by using a `ForeignKey` field. That tells Django each `Review` is related to a single `Wine`.  

Since we have made changes to our model, we need to propagate that to our database. We will do that by running the following command that creates migrations for our changes.  

```shell
python manage.py makemigrations reviews
```

And now we can aply our migrations to the data base as follows, without losing data.  

```shell
python manage.py migrate
```

## Providing an admin site  

First of all, we need to create an admin user by running the following command form the `winerama/` root folder that contains `manage.py`.  

```shell
python manage.py createsuperuser
```

You'll be prompted for a user name, email address, and password. Introduce those that work for you. You will use them to login and admin the system.  

The admin site is activated by default. Let's explore it. If your website is not up and running, use the following command.

```shell
python manage.py runserver 0.0.0.0:8000
```

And now you can navigate to `http://KODING_USERNAME:8000/admin/` (remember to replace KODING_USERNAME with your actual Koding user) and login with the user and passowrd that you specified before.  

You will notice that our model entities are not modifiable in the admin site. In order for them to be there, we need to add them in the `reviews/admin.py` file so it looks like this.  

```python
from django.contrib import admin

from .models import Wine, Review

class ReviewAdmin(admin.ModelAdmin):
    model = Review
    list_display = ('rating', 'user_name', 'review_text', 'pub_date')
    
admin.site.register(Wine)
admin.site.register(Review, ReviewAdmin)
```

We are basically importing the model classes we just defined, and then using `register()` to the Django that we want wines and reviews to be available in the admin site.  

If we navigate again to the admin site, we will see a new *Reviews* section with a *Wines* and **Reviews** elements inside. These element include two action buttons, **Add** and **Change**. Add can be used to introduce new wines or wine reviews. The forms are automatically generated from the `Wine` and `Review` models. 

But with wine reviews we have done a little extra work and defined a custom admin class. There are many things we can do with this class, but in our case we have specified:  

- what columns (and in what order) do we want to display in the entries list. That is, when using the **Change** button or when navigating to `admin/reviews/wine` or `admin/reviews/review`, we will see a list of all added entries. How the entries are listed when we go to the reviews section is specified by the `list_display` field in the `ReviewAdmin` class.  
- A list of filters that can be used to list reviews.  
- A list of fields that will be matched when using the search box.  

We suggest you experiment with this `ReviewAdmin` class (or create your own `WineAdmin` one) until your happy with the results.  

We have accomplished a lotjust by writing a few classes. Django it's really powerful when it comes to providing an admin interface. In the next section we will work on our actual user interface to add wine reviews.  

## Adding web views  

In Django, a view is a type of Web page that generally serves a specific function and has a specific template. The concept is taken from the [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) architectural pattern, so common in web application frameworks.  

In Django, a view is actually a Python function that delivers a web page (and other content). When a user navigates to a URL within our application, Django will choose a view by examining the URL that’s requested.

But let's show this in practice.    

Continue here, in the very last section: https://docs.djangoproject.com/en/1.8/intro/tutorial03/

Forms explained here: https://docs.djangoproject.com/en/1.8/intro/tutorial04/


## Conclusions and future works

- User management
- Sentiment analysis of reviews to predict ratings
- Scalable version using Spark
