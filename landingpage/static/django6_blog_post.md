# Exploring Django 6.0 New Features: A Practical Landing Page with Template Partials, CSP, and Background Tasks

## Introduction

Django 6.0 represents one of the most significant updates to the framework in recent years, introducing several powerful features that enhance developer experience, security, and performance. In this comprehensive guide, we'll explore the key new features of Django 6.0 by building a practical landing page example that demonstrates:

1. Template Partials for modular template design
2. Built-in Content Security Policy (CSP) support
3. Native Background Tasks framework
4. Modern Email API adoption

Our landing page will showcase these features in a real-world context, providing you with practical examples you can implement in your own projects.

## Key Features of Django 6.0

### 1. Template Partials

Template partials are one of the most anticipated features in Django 6.0. This feature allows developers to define reusable template fragments inline within the same template file, eliminating the need to split related code into separate files.

#### How Template Partials Work

Template partials introduce two new template tags:
- `{% partialdef %}` - to define a partial
- `{% partial %}` - to render a partial

Here's how we've implemented template partials in our landing page:

```django
{% partialdef subscription_modal %}
<div id="modal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
  <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-md mx-4">
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-xl font-bold text-gray-800">Get Your Django 6 Guide</h2>
      <button id="close-modal" class="text-gray-500 hover:text-gray-700">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>
    </div>
    <p class="text-gray-600 mb-6">Enter your email to receive the Django 6 Features Guide instantly.</p>
    <form id="subscribe-form">
      {% csrf_token %}
      <div class="mb-4">
        <label for="{{ form.email.id_for_label }}" class="block text-gray-700 text-sm font-bold mb-2">
          {{ form.email.label }}
        </label>
        {{ form.email }}
      </div>
      <div id="error-email" class="mt-2 text-red-600 text-sm"></div>
      <button type="submit" class="mt-4 w-full bg-[#10B981] hover:bg-[#059669] text-white font-bold py-3 px-4 rounded-full shadow focus:outline-none focus:shadow-outline">
        Send My Free Guide
      </button>
    </form>
    <p class="text-xs text-gray-500 text-center mt-4">
      We respect your privacy. Unsubscribe at any time.
    </p>
  </div>
</div>
{% endpartialdef %}

<!-- Usage in the same template -->
{% partial subscription_modal %}
```

#### Benefits of Template Partials

1. **Keep related template code together** - No need to create separate files for small components
2. **Reduce file clutter** - Eliminates proliferation of small template files
3. **Improve template maintainability** - Related code stays together
4. **Enable better component organization** - Easier to understand and modify

### 2. Content Security Policy (CSP)

Django 6.0 introduces built-in support for Content Security Policy (CSP), a security standard that helps prevent cross-site scripting (XSS), clickjacking, and other code injection attacks.

#### Implementation in Our Landing Page

In our project, we've configured CSP in `settings.py`:

```python
# settings.py
from django.utils.csp import CSP

MIDDLEWARE = [
    # ... other middleware
    'django.middleware.content_security_policy.ContentSecurityPolicyMiddleware',
]

SECURE_CSP = {
    "default-src": [CSP.SELF],
    "script-src": [CSP.SELF, 'https://cdn.tailwindcss.com'],
    "style-src": [CSP.SELF, 'https://fonts.googleapis.com'],
    "img-src": [CSP.SELF, 'data:', 'https:'],
    "font-src": [CSP.SELF, 'https://fonts.gstatic.com'],
}

# Report-only mode for testing
SECURE_CSP_REPORT_ONLY = False
```

#### Benefits of Built-in CSP

1. **Enhanced security** - Protection against XSS and content injection attacks
2. **Easy configuration** - Simple dictionary-based policy definition
3. **Built-in middleware** - No need for third-party packages
4. **Nonce support** - Secure handling of inline scripts

### 3. Background Tasks Framework

Django 6.0 introduces a native Tasks framework for running code outside the HTTP request-response cycle. This is particularly useful for long-running operations that would otherwise block the user interface.

#### Implementation in Our Landing Page

We've created a simple task to send a welcome email to subscribers:

```python
# tasks.py
from django.core.mail import send_mail
from django.tasks import task

@task
def send_welcome_email(user_id):
    from myapp.models import User
    user = User.objects.get(id=user_id)
    return send_mail(
        subject="Welcome to Our Django 6 Guide",
        message=f"Hello {user.name}, thank you for downloading our Django 6 Features Guide!",
        from_email="noreply@example.com",
        recipient_list=[user.email],
    )
```

In our view, we enqueue the task after a successful subscription:

```python
# views.py
from .tasks import send_welcome_email

def subscribe_ajax(request):
    if request.method == "POST":
        form = SubscriptionForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data["email"]
            obj, created = Subscription.objects.get_or_create(email=email)
            
            # Enqueue the welcome email task
            send_welcome_email.enqueue(user_id=obj.id)
            
            return JsonResponse({"success": True})
        else:
            return JsonResponse({"success": False, "errors": form.errors})
    return JsonResponse({"success": False, "errors": {"__all__": "Invalid request"}})
```

#### Benefits of Native Background Tasks

1. **No external dependencies** - Built into Django core
2. **Simplified setup** - Easy to define and enqueue tasks
3. **Better integration** - Seamless with Django's existing architecture
4. **Improved performance** - Non-blocking operations for better UX

### 4. Modern Email API

Django 6.0 adopts Python's modern email API, offering a cleaner and Unicode-friendly interface for composing and sending emails.

#### Implementation Example

```python
from django.core.mail import EmailMessage

# Create a message with the modern API
message = EmailMessage(
    subject="Hello from Django 6",
    body="This is the email body",
    from_email="sender@example.com",
    to=["recipient@example.com"],
)

# Add attachments
message.attach("document.pdf", pdf_content, "application/pdf")

# Send the message
message.send()
```

#### Benefits of Modern Email API

1. **Cleaner interface** - Uses `email.message.EmailMessage`
2. **Better Unicode support** - Proper handling of international characters
3. **Simplified composition** - More intuitive API
4. **Modern standards** - Compatible with current email protocols

## Project Structure and Implementation

Let's examine how these features come together in our landing page project.

### Project Setup

First, we created a standard Django project with a subscriptions app:

```bash
django-admin startproject landingpage
cd landingpage
python manage.py startapp subscriptions
```

We then added the necessary apps to `INSTALLED_APPS` in `settings.py`:

```python
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "subscriptions",
]
```

### Models

We created a simple model to store subscriber information:

```python
# models.py
from django.db import models

class Subscription(models.Model):
    email = models.EmailField(unique=True)
    subscribed_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.email
```

### Forms

We implemented a form for email validation:

```python
# forms.py
from django import forms

class SubscriptionForm(forms.Form):
    email = forms.EmailField(
        label="Email Address",
        widget=forms.EmailInput(attrs={
            "class": "w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition",
            "placeholder": "you@example.com"
        })
    )
```

### Views

Our views handle both the landing page display and AJAX subscription:

```python
# views.py
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
```

### Templates

Our main template uses Tailwind CSS for styling and implements all the new Django 6.0 features:

```django
<!-- landingpage.html -->
{% extends "base.html" %}
{% load static %}
{% block content %}
<div class="min-h-screen">
  <!-- Hero Section with Template Partials -->
  <section class="bg-[#1A2B4A] text-white relative overflow-hidden">
    <!-- Content here -->
    
    <!-- Using our defined partial -->
    {% partial subscription_modal %}
  </section>
  
  <!-- Template partial definition -->
  {% partialdef subscription_modal %}
  <div id="modal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <!-- Modal content -->
  </div>
  {% endpartialdef %}
</div>

<script>
// JavaScript for handling the subscription form with AJAX
document.getElementById('subscribe-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  // AJAX submission logic
});
</script>
{% endblock %}
```

## Best Practices and Migration Guide

### Template Partials Best Practices

1. **Use descriptive names** for your partials to make them self-documenting
2. **Keep partials focused** on a single responsibility
3. **Pass context explicitly** rather than relying on global context
4. **Consider reusability** when designing partials

### CSP Best Practices

1. **Start with report-only mode** (`SECURE_CSP_REPORT_ONLY = True`) to identify issues
2. **Use specific sources** rather than wildcards when possible
3. **Implement nonce-based CSP** for inline scripts
4. **Regularly review and update** your CSP policies

### Background Tasks Best Practices

1. **Handle exceptions** in your tasks to prevent silent failures
2. **Keep tasks idempotent** when possible to handle retries
3. **Monitor task execution** and set appropriate TTL values
4. **Use appropriate backends** for your deployment environment

## Migration from Previous Versions

If you're upgrading from an earlier version of Django, here are some key migration steps:

### From Third-Party Template Partials

If you were using the `django-template-partials` third-party package:

1. Remove the package from your requirements:
   ```bash
   pip uninstall django-template-partials
   ```

2. Remove it from `INSTALLED_APPS`:
   ```python
   # Remove this line
   # 'template_partials',
   ```

3. Update your templates to use the built-in syntax (usually no changes needed).

### CSP Migration

If you were using a third-party CSP package:

1. Remove the third-party package:
   ```bash
   pip uninstall django-csp
   ```

2. Update your settings to use the new built-in configuration.

## Conclusion

Django 6.0 brings significant improvements that will enhance your development experience and application security. The features we've explored in this guide demonstrate how Django continues to evolve with the needs of modern web development:

1. **Template Partials** simplify template organization and reduce file clutter
2. **Built-in CSP** improves application security without external dependencies
3. **Native Background Tasks** eliminate the need for Celery in simple use cases
4. **Modern Email API** provides better Unicode support and cleaner interfaces

Our landing page example showcases how these features work together to create a robust, secure, and maintainable application. By implementing these patterns in your own projects, you can take full advantage of what Django 6.0 has to offer.

Whether you're building a simple landing page or a complex web application, Django 6.0's new features provide powerful tools to help you create better applications faster.

## About the Author

**Winston Mhango** is a senior Django developer with over 8 years of experience building web applications. He has contributed to numerous open-source Django projects and has also written a Django guide titled [ILLUSTRATED GUIDE TO DJANGO](https://marvelous-founder-1838.kit.com/1c997bd676). His expertise in Django internals and best practices makes him the perfect guide for mastering Django 6.

**Contact Information:**
- Email: [winstonmhango23@gmail.com](mailto:winstonmhango23@gmail.com)
- LinkedIn: [Winston Mhango](https://www.linkedin.com/in/winston-mhango-401980ab/)
- GitHub: [winstonmhango23](https://github.com/winstonmhango23/)

---

*This guide is © 2025 Winston Mhango. All rights reserved.*