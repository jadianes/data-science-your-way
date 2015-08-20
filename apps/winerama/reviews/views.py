from django.shortcuts import get_object_or_404, render
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse

from .models import Review, Wine
import datetime

def index(request):
    latest_review_list = Review.objects.order_by('-pub_date')[:5]
    context = {'latest_review_list':latest_review_list}
    return render(request, 'reviews/index.html', context)


def review_detail(request, review_id):
    review = get_object_or_404(Review, pk=review_id)
    return render(request, 'reviews/review_detail.html', {'review': review})


def wine_detail(request, wine_id):
    wine = get_object_or_404(Wine, pk=wine_id)
    return render(request, 'reviews/wine_detail.html', {'wine': wine})


def add_review(request, wine_id):
    wine = get_object_or_404(Wine, pk=wine_id)
    rating = request.POST['review_rating']
    comment = request.POST['review_comment']
    review = Review()
    review.wine = wine
    review.rating = rating
    review.review_text = comment
    review.pub_date = datetime.datetime.now()
    review.save()
    # Always return an HttpResponseRedirect after successfully dealing
    # with POST data. This prevents data from being posted twice if a
    # user hits the Back button.
    return HttpResponseRedirect(reverse('reviews:wine_detail', args=(wine.id,)))