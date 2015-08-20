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
    