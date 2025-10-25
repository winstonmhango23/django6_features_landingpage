# Mastering Django 6: A Comprehensive Guide to New Features
## By Winston Mhango

Welcome to the definitive guide to Django 6's groundbreaking features! This comprehensive resource will walk you through all the major updates and show you how to leverage them to build better web applications.

## Table of Contents
1. Introduction to Django 6
2. Template Partials
3. Content Security Policy (CSP)
4. Background Tasks Framework
5. Modern Email API
6. AsyncPaginator
7. Other Notable Features
8. Migration Guide
9. Best Practices
10. Conclusion

## 1. Introduction to Django 6

Django 6 represents one of the most significant updates to the framework in recent years. With a focus on developer experience, security, and performance, this release introduces several powerful features that will transform how we build Django applications.

Key highlights include:
- Template Partials for modular template design
- Built-in Content Security Policy support
- Native Background Tasks framework
- Adoption of Python's modern email API
- AsyncPaginator for improved async performance

## 2. Template Partials

### What are Template Partials?

Template partials are reusable template fragments that can be defined and used within the same template file. This feature eliminates the need to split related template code into separate files, making templates more maintainable and organized.

### How to Use Template Partials

```django
{% load partials %}

{% partialdef user_card %}
<div class="card">
  <h3>{{ user.name }}</h3>
  <p>{{ user.email }}</p>
  <p>Joined: {{ user.date_joined|date:"M d, Y" }}</p>
</div>
{% endpartialdef %}

<!-- Usage -->
{% for user in users %}
  {% partial user_card %}
{% endfor %}
```

### Advanced Usage

#### Inline Partials
You can render a partial's content inline at the point of definition:

```django
{% partialdef alert_message inline %}
<div class="alert alert-{{ level }}">
  {{ message }}
</div>
{% endpartialdef %}
```

#### Partial Loading
Partials can also be loaded via the template loader:

```python
from django.template.loader import get_template

# Load an entire template
template = get_template("example.html")

# Load a specific fragment from a template
partial = get_template("example.html#partial_name")
```

### Benefits
- Keep related template code together
- Reduce file clutter
- Improve template maintainability
- Enable better component organization
- Simplify template inheritance patterns

## 3. Content Security Policy (CSP)

### What is CSP?

Content Security Policy (CSP) is a security standard that helps prevent cross-site scripting (XSS), clickjacking, and other code injection attacks. Django 6 introduces built-in support for CSP, making it easier than ever to secure your applications.

### Configuration

```python
# settings.py
from django.utils.csp import CSP

MIDDLEWARE = [
    # ... other middleware
    'django.middleware.content_security_policy.ContentSecurityPolicyMiddleware',
]

SECURE_CSP = {
    "default-src": [CSP.SELF],
    "script-src": [CSP.SELF, 'https://cdn.example.com'],
    "style-src": [CSP.SELF, 'https://fonts.googleapis.com'],
    "img-src": [CSP.SELF, 'data:', 'https:'],
    "font-src": [CSP.SELF, 'https://fonts.gstatic.com'],
    "connect-src": [CSP.SELF],
}

# Report-only mode for testing
SECURE_CSP_REPORT_ONLY = True
```

### Using Nonces

For inline scripts, you can use nonces:

```python
# views.py
from django.utils.csp import csp_nonce

def my_view(request):
    nonce = csp_nonce()
    return render(request, 'template.html', {'nonce': nonce})
```

```django
<!-- template.html -->
<script nonce="{{ nonce }}">
  console.log('This script is allowed by CSP');
</script>
```

### Benefits
- Protection against XSS attacks
- Control over resource loading
- Improved security posture
- Easy configuration
- Built-in middleware support

## 4. Background Tasks Framework

### Overview

Django 6 introduces a native Tasks framework for running code outside the HTTP request-response cycle. This is particularly useful for long-running operations that would otherwise block the user interface.

### Defining Tasks

```python
# tasks.py
from django.core.mail import send_mail
from django.tasks import task

@task
def send_welcome_email(user_id):
    from myapp.models import User
    user = User.objects.get(id=user_id)
    return send_mail(
        subject="Welcome to Our Platform",
        message=f"Hello {user.name}, welcome to our platform!",
        from_email="noreply@example.com",
        recipient_list=[user.email],
    )

@task
def process_large_dataset(dataset_id):
    from myapp.models import Dataset
    dataset = Dataset.objects.get(id=dataset_id)
    # Process the dataset
    # ...
    dataset.status = 'processed'
    dataset.save()
```

### Enqueuing Tasks

```python
# views.py
from .tasks import send_welcome_email, process_large_dataset

def register_user(request):
    # ... user registration logic ...
    user = User.objects.create(...)
    
    # Enqueue the welcome email task
    send_welcome_email.enqueue(user_id=user.id)
    
    return redirect('welcome')

def upload_dataset(request):
    # ... dataset upload logic ...
    dataset = Dataset.objects.create(...)
    
    # Enqueue the processing task
    process_large_dataset.enqueue(dataset_id=dataset.id)
    
    return redirect('processing')
```

### Task Configuration

```python
# settings.py
TASKS = {
    'backend': 'django.tasks.backends.database.DatabaseBackend',
    'task_ttl': 3600,  # Tasks expire after 1 hour
    'result_ttl': 1800,  # Results expire after 30 minutes
}
```

### Benefits
- Native task handling without external dependencies
- Simplified background processing
- Better integration with Django
- Improved performance for long-running operations
- Easy task management and monitoring

## 5. Modern Email API

### Overview

Django 6 adopts Python's modern email API, offering a cleaner and Unicode-friendly interface for composing and sending emails. This update replaces the older legacy API with the more modern `email.message.EmailMessage` class.

### New Features

#### Using EmailMessage

```python
from django.core.mail import EmailMessage

# Create a message
message = EmailMessage(
    subject="Hello from Django 6",
    body="This is the email body",
    from_email="sender@example.com",
    to=["recipient@example.com"],
    cc=["cc@example.com"],
    bcc=["bcc@example.com"],
)

# Add attachments
message.attach("document.pdf", pdf_content, "application/pdf")

# Send the message
message.send()
```

#### HTML Emails

```python
from django.core.mail import EmailMessage

message = EmailMessage(
    subject="HTML Email Example",
    body="<h1>Welcome!</h1><p>This is an HTML email.</p>",
    from_email="sender@example.com",
    to=["recipient@example.com"],
)
message.content_subtype = "html"  # Set content type to HTML
message.send()
```

#### Using MIMEPart

```python
from email.mime.text import MIMEText
from django.core.mail import EmailMessage

# Create alternative parts
text_part = MIMEText("This is the plain text version", "plain")
html_part = MIMEText("<p>This is the <b>HTML</b> version</p>", "html")

# Create the message
message = EmailMessage(
    subject="Multipart Email",
    from_email="sender@example.com",
    to=["recipient@example.com"],
)

# Attach the parts
message.attach(text_part)
message.attach(html_part)

message.send()
```

### Benefits
- Uses Python's modern `email.message.EmailMessage`
- Cleaner interface
- Better Unicode support
- Simplified email composition
- Improved compatibility with modern email standards

## 6. AsyncPaginator

### Overview

Django 6 introduces `AsyncPaginator` and `AsyncPage` for async implementations of pagination. This is particularly useful for async views and improves performance when dealing with large datasets.

### Usage

```python
# views.py
from django.core.paginator import AsyncPaginator
from django.http import JsonResponse
from asgiref.sync import sync_to_async

async def async_paginated_view(request):
    # Get the page number from the request
    page_number = request.GET.get('page', 1)
    
    # Create an async paginator
    async_paginator = AsyncPaginator(MyModel.objects.all(), 25)
    
    # Get the page
    page = await async_paginator.aget_page(page_number)
    
    # Convert objects to dictionaries for JSON response
    objects = [await sync_to_async(lambda obj: {
        'id': obj.id,
        'name': obj.name,
        # ... other fields
    })(obj) for obj in page]
    
    return JsonResponse({
        'objects': objects,
        'has_next': page.has_next(),
        'has_previous': page.has_previous(),
        'page_number': page.number,
    })
```

### Template Usage

```django
<!-- In your template -->
{% for item in page %}
  <div>{{ item.name }}</div>
{% endfor %}

<div class="pagination">
  {% if page.has_previous %}
    <a href="?page={{ page.previous_page_number }}">Previous</a>
  {% endif %}
  
  <span>Page {{ page.number }} of {{ page.paginator.num_pages }}</span>
  
  {% if page.has_next %}
    <a href="?page={{ page.next_page_number }}">Next</a>
  {% endif %}
</div>
```

### Benefits
- Better performance for async views
- Improved user experience
- Native async support
- Seamless integration with existing pagination patterns

## 7. Other Notable Features

### Improved Password Hashing

The default iteration count for the PBKDF2 password hasher is increased from 1,000,000 to 1,200,000, providing better security:

```python
# settings.py
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.PBKDF2PasswordHasher',  # Uses 1,200,000 iterations
    # ... other hashers
]
```

### Enhanced GIS Support

New functions and lookups for geographic data processing:

```python
from django.contrib.gis.db.models import PointField
from django.contrib.gis.geos import Point

# New Rotate database function
from django.contrib.gis.db.models.functions import Rotate

# New lookups
queryset = MyModel.objects.filter(
    location__coveredby=some_polygon,
    location__isvalid=True,
)
```

### Better Static Files Handling

`ManifestStaticFilesStorage` ensures consistent path ordering in manifest files:

```python
# settings.py
STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.ManifestStaticFilesStorage'
```

### Font Awesome Icons in Admin

The Django admin now uses Font Awesome Free icon set (version 6.7.2) for a more modern interface.

### New Admin Customizations

```python
# admin.py
from django.contrib import admin

class MyModelAdmin(admin.ModelAdmin):
    # New attribute for customizing password change form
    password_change_form = MyCustomPasswordChangeForm

admin.site.register(MyModel, MyModelAdmin)
```

## 8. Migration Guide

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

3. Update your templates to use the built-in syntax (no changes needed in most cases).

### CSP Migration

If you were using a third-party CSP package:

1. Remove the third-party package:
   ```bash
   pip uninstall django-csp
   ```

2. Update your settings to use the new built-in configuration:
   ```python
   # Replace the old configuration with:
   from django.utils.csp import CSP
   
   MIDDLEWARE = [
       # ... remove old CSP middleware
       'django.middleware.content_security_policy.ContentSecurityPolicyMiddleware',
   ]
   
   SECURE_CSP = {
       # ... your CSP policy
   }
   ```

## 9. Best Practices

### Template Partials Best Practices

1. **Use descriptive names** for your partials:
   ```django
   {% partialdef user_profile_card %}
   {% partialdef product_thumbnail %}
   ```

2. **Keep partials focused** on a single responsibility.

3. **Pass context explicitly** rather than relying on global context.

### CSP Best Practices

1. **Start with report-only mode** to identify issues:
   ```python
   SECURE_CSP_REPORT_ONLY = True
   ```

2. **Use specific sources** rather than wildcards when possible.

3. **Implement nonce-based CSP** for inline scripts.

### Background Tasks Best Practices

1. **Handle exceptions** in your tasks:
   ```python
   @task
   def my_task():
       try:
           # Task logic
           pass
       except Exception as e:
           # Log the error
           logger.error(f"Task failed: {e}")
           # Re-raise if needed
           raise
   ```

2. **Keep tasks idempotent** when possible.

3. **Monitor task execution** and set appropriate TTL values.

## 10. Conclusion

Django 6 brings significant improvements that will enhance your development experience and application security. Template partials offer a cleaner way to organize your templates, while CSP provides better security out of the box. The background tasks framework simplifies async processing, and the modern email API makes email handling more robust.

Key takeaways:
- Template partials simplify template organization
- Built-in CSP improves application security
- Native background tasks eliminate external dependencies
- Modern email API provides better Unicode support
- AsyncPaginator enhances async view performance

Start implementing these features in your projects today to take full advantage of what Django 6 has to offer!

---

## About the Author

**Winston Mhango** is a senior Django developer with over 8 years of experience building web applications. He has contributed to numerous open-source Django projects and regularly speaks at DjangoCon events. His expertise in Django internals and best practices makes him the perfect guide for mastering Django 6.

**Contact Information:**
- Email: winstonmhango23@gmail.com
- LinkedIn: [Winston Mhango](https://www.linkedin.com/in/winston-mhango-401980ab/)
- GitHub: [winstonmhango23](https://github.com/winstonmhango23/)

---

*This guide is © 2025 Winston Mhango. All rights reserved.*