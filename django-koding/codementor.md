# Using Django and Koding to deploy a Wine reviews & recommenation website

## Intro

## Wine reviews and ratings

- Wine name: this can be firther decomposed into vintage, country, type, etc.
- Rating: 0 to 5 rating system
- Review: a text based comment on the wine
- User

## A clustering-based recommendation engine  

Cluster users, then the process is as follows:
- Cluster the current user
- Get closest users within the cluster
- Get highest un-rated wines for the closest user, the the next one, etc

## Koding as a development server

- Install Django using kpm and proceed to the next section 

## Using Django to build our website

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

> What’s the difference between a project and an app? An app is a Web application that does something – e.g., a Weblog system, a database of public records or a simple poll app. A project is a collection of configuration and apps for a particular Web site. A project can contain multiple apps. An app can be in multiple projects.  

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

## Conclusions and future works


- Sentiment analysis of reviews to predict ratings
- Scalable version using Spark

