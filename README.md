# Django 6.0 Landing Page with New Features Demo

This project demonstrates the key new features of Django 6.0 through a practical landing page implementation. It showcases template partials, Content Security Policy (CSP), background tasks, and the modern email API.

## Features Demonstrated

1. **Template Partials** - Reusable inline template fragments without separate files
2. **Content Security Policy (CSP)** - Built-in security middleware for XSS protection
3. **Background Tasks Framework** - Native task processing without external dependencies
4. **Modern Email API** - Cleaner and Unicode-friendly email composition

## Blog Series

This project is part of a blog series that explains Django 6.0 features in detail:

- **Main Blog Post**: [Exploring Django 6.0 New Features](https://www.codetips.blog/posts/exploring-django-6-0-new-features-a-practical-landing-page-with-template-partials-csp-and-background-tasks)
- **Comprehensive Guide**: [DJANGO6_FEATURES.html](landingpage/static/DJANGO6_FEATURES.html) (Downloadable HTML guide)
- **Markdown Version**: [DJANGO6_FEATURES.md](landingpage/static/DJANGO6_FEATURES.md)

## Author

**Winston Mhango**
- Email: [winstonmhango23@gmail.com](mailto:winstonmhango23@gmail.com)
- LinkedIn: [Winston Mhango](https://www.linkedin.com/in/winston-mhango-401980ab/)
- GitHub: [winstonmhango23](https://github.com/winstonmhango23/)

## Prerequisites

- Python 3.8 or higher
- Django 6.0 beta (installed via `pip install --pre django`)
- Virtual environment (recommended)

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd django6_features
   ```

2. **Create a virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install Django 6.0**:
   ```bash
   pip install --pre django
   ```

4. **Navigate to the project directory**:
   ```bash
   cd landingpage
   ```

5. **Apply migrations**:
   ```bash
   python manage.py migrate
   ```

## Running the Project

1. **Start the development server**:
   ```bash
   python manage.py runserver
   ```

2. **Access the landing page**:
   Open your browser and go to `http://127.0.0.1:8000/`

## Project Structure

```
landingpage/
├── landingpage/           # Main project settings
│   ├── __init__.py
│   ├── settings.py        # Project settings with CSP configuration
│   ├── urls.py            # Main URL configuration
│   └── wsgi.py
├── subscriptions/         # App for handling email subscriptions
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── forms.py           # Subscription form
│   ├── models.py          # Subscription model
│   ├── urls.py            # App URLs
│   └── views.py           # Views for landing page and AJAX subscription
├── templates/             # HTML templates
│   ├── base.html          # Base template with Tailwind CSS
│   └── landingpage.html   # Main landing page with template partials
├── static/                # Static files (images, guides, etc.)
│   ├── DJANGO6_FEATURES.html  # Comprehensive Django 6 guide
│   ├── DJANGO6_FEATURES.md    # Markdown version of the guide
│   ├── winstonjs-full-image.png  # Author full image
│   └── winstonmhango-headshot.jpg  # Author headshot
└── manage.py              # Django management script
```

## Key Django 6.0 Features Implementation

### Template Partials

Template partials allow defining reusable template fragments inline:

```django
{% partialdef subscription_modal %}
<!-- Modal content -->
{% endpartialdef %}

<!-- Usage -->
{% partial subscription_modal %}
```

### Content Security Policy (CSP)

CSP is configured in `settings.py`:

```python
SECURE_CSP = {
    "default-src": [CSP.SELF],
    "script-src": [CSP.SELF, 'https://cdn.tailwindcss.com'],
    "style-src": [CSP.SELF, 'https://fonts.googleapis.com'],
    "img-src": [CSP.SELF, 'data:', 'https:'],
    "font-src": [CSP.SELF, 'https://fonts.gstatic.com'],
}
```

### Background Tasks

Native background tasks are implemented in `tasks.py`:

```python
from django.tasks import task

@task
def send_welcome_email(user_id):
    # Task implementation
    pass
```

## Customization

### Updating CSP Settings

Modify the CSP configuration in `landingpage/settings.py`:

```python
SECURE_CSP = {
    # Your custom CSP policy
}
```

### Modifying Template Partials

Edit the modal partial in `templates/landingpage.html`:

```django
{% partialdef subscription_modal %}
<!-- Your custom modal content -->
{% endpartialdef %}
```

## Downloadable Resources

The following resources are available in the `static/` directory:

1. **DJANGO6_FEATURES.html** - Complete HTML guide to Django 6 features
2. **DJANGO6_FEATURES.md** - Markdown version of the Django 6 guide
3. **winstonjs-full-image.png** - Author full image
4. **winstonmhango-headshot.jpg** - Author headshot

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the Django team for the amazing work on Django 6.0
<<<<<<< HEAD
- Special thanks to Winston Mhango for the comprehensive Django 6 guide
=======
- Special thanks to Winston Mhango for the comprehensive Django 6 guide
>>>>>>> 852a57fef630dd624fe59f3081a6c795c23b1d59
