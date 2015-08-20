from django.contrib import admin

from .models import Wine, Review

class ReviewAdmin(admin.ModelAdmin):
    model = Review
    list_display = ('wine', 'rating', 'user_name', 'review_text', 'pub_date')
    list_filter = ['pub_date', 'user_name']
    search_fields = ['review_text']
    
admin.site.register(Wine)
admin.site.register(Review, ReviewAdmin)