# Django 6 Features Landing Page

A landing page for promoting the new features in Django 6, including template partials, CSP, and background tasks.

## 🚀 Quick Start with Docker

1. **Build and run the application**:
   ```bash
   docker-compose up --build
   ```

2. **Access the application**:
   Open your browser and go to http://localhost:8000

3. **Access the admin panel**:
   Go to http://localhost:8000/admin
   - Username: admin
   - Password: admin123

## 🛠️ Local Development Without Docker

1. **Install dependencies**:
   ```bash
   cd landingpage
   pip install -r requirements.txt
   ```

2. **Run migrations**:
   ```bash
   python manage.py migrate
   ```

3. **Create a superuser**:
   ```bash
   python manage.py createsuperuser
   ```

4. **Run the development server**:
   ```bash
   python manage.py runserver
   ```

## 📁 Project Structure

```
landingpage/
├── landingpage/           # Django project settings
├── subscriptions/         # Django app for email subscriptions
├── templates/             # HTML templates
├── static/                # Static assets (CSS, JS, images)
└── manage.py              # Django management script
```

## 🎯 Features

- Email subscription form with AJAX
- Responsive design with Tailwind CSS
- Template partials for reusable components
- Docker support for easy deployment
- PostgreSQL database integration

## 🚀 Deployment

See [SEVALLA_DEPLOYMENT_GUIDE.md](SEVALLA_DEPLOYMENT_GUIDE.md) for detailed deployment instructions.

## 📄 License

This project is licensed under the MIT License.
