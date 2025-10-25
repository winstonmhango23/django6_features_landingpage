from django.shortcuts import render
from django.http import JsonResponse
from .forms import SubscriptionForm
from .models import Subscription

def landing(request):
    form = SubscriptionForm()
    return render(request, "landingpage.html", {"form": form})

def subscribe_ajax(request):
    if request.method == "POST":
        form = SubscriptionForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data["email"]
            obj, created = Subscription.objects.get_or_create(email=email)
            return JsonResponse({"success": True})
        else:
            return JsonResponse({"success": False, "errors": form.errors})
    return JsonResponse({"success": False, "errors": {"__all__": "Invalid request"}})