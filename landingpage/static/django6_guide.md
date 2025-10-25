# Django 6 Features Guide
## By Winston Mhango

Welcome to the comprehensive guide to Django 6's new features! This guide will walk you through the most important updates and show you how to leverage them in your projects.

## Table of Contents
1. Template Partials
2. Content Security Policy (CSP)
3. Background Tasks Framework
4. Modern Email API
5. AsyncPaginator
6. Other Notable Features

## 1. Template Partials

One of the most exciting features in Django 6 is the introduction of template partials. This feature allows you to define reusable template fragments inline without having to split them into separate files.

### How to Use Template Partials

```django
{% partialdef my_partial %}
<div class="card">
  <h3>{{ title }}</h3>
  <p>{{ content }}</p>
</div>
{% endpartialdef %}

<!-- Usage -->
{% partial my_partial %}
```

### Benefits
- Keep related template code together
- Reduce file clutter
- Improve template maintainability
- Enable better component organization

## 2. Content Security Policy (CSP)

Django 6 introduces built-in support for Content Security Policy, making it easier to protect your applications against XSS attacks.

### Configuration

```python
# settings.py
from django.utils.csp import CSP

SECURE_CSP = {
    "default-src": [CSP.SELF],
    "script-src": [CSP.SELF, CSP.NONCE],
    "img-src": [CSP.SELF, "https:"],
}
```

### Benefits
- Protection against XSS attacks
- Control over resource loading
- Improved security posture
- Easy configuration

## 3. Background Tasks Framework

Django 6 now includes a native Tasks framework for running code outside the HTTP request-response cycle.

### Defining Tasks

```python
from django.core.mail import send_mail
from django.tasks import task

@task
def email_users(emails, subject, message):
    return send_mail(subject, message, None, emails)
```

### Enqueuing Tasks

```python
email_users.enqueue(
    emails=["user@example.com"],
    subject="You have a message",
    message="Hello there!",
)
```

### Benefits
- Native task handling
- Simplified background processing
- Better integration with Django
- Improved performance for long-running operations

## 4. Modern Email API

Django 6 adopts Python's modern email API, offering a cleaner and Unicode-friendly interface for composing and sending emails.

### New Features
- Uses email.message.EmailMessage
- Cleaner interface
- Better Unicode support
- Simplified email composition

## 5. AsyncPaginator

Django 6 introduces AsyncPaginator and AsyncPage for async implementations of pagination.

### Usage

```python
from django.core.paginator import AsyncPaginator

async_paginator = AsyncPaginator(queryset, 25)
page = await async_paginator.aget_page(1)
```

### Benefits
- Better performance for async views
- Improved user experience
- Native async support

## 6. Other Notable Features

### Improved Password Hashing
The default iteration count for the PBKDF2 password hasher is increased from 1,000,000 to 1,200,000.

### Enhanced GIS Support
New functions and lookups for geographic data processing.

### Better Static Files Handling
ManifestStaticFilesStorage ensures consistent path ordering in manifest files.

---

## Conclusion

Django 6 brings significant improvements that will enhance your development experience and application security. Template partials offer a cleaner way to organize your templates, while CSP provides better security out of the box. The background tasks framework simplifies async processing, and the modern email API makes email handling more robust.

Start implementing these features in your projects today to take full advantage of what Django 6 has to offer!

---
*This guide was created by Winston Mhango. For more Django tutorials and resources, visit [your website/contact info].*