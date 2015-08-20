from django.conf.urls import url

from . import views

urlpatterns = [
    # ex: /review/
    url(r'^$', views.index, name='index'),
    # ex: /reviews/5/
    url(r'^(?P<review_id>[0-9]+)/$', views.detail, name='detail'),
]