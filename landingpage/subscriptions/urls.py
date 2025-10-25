from django.urls import path
from . import views

app_name = "subscriptions"

urlpatterns = [
    path("subscribe-ajax/", views.subscribe_ajax, name="subscribe_ajax"),
]