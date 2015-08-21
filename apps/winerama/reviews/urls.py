from django.conf.urls import url

from . import views

urlpatterns = [
    # ex: /
    url(r'^$', views.review_list, name='review_list'),
    # ex: /review/5/
    url(r'^review/(?P<review_id>[0-9]+)/$', views.review_detail, name='review_detail'),
    # ex: /wine/
    url(r'^wine$', views.wine_list, name='wine_list'),
    # ex: /wine/5/
    url(r'^wine/(?P<wine_id>[0-9]+)/$', views.wine_detail, name='wine_detail'),
    url(r'^wine/(?P<wine_id>[0-9]+)/add_review/$', views.add_review, name='add_review'),
]