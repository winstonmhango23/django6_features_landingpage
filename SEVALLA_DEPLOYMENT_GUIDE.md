# 🚀 Sevalla Deployment Guide
## Django 6 Features Landing Page

This guide will help you deploy the Django 6 Features Landing Page application to Sevalla (https://app.sevalla.com/).

## 📋 Prerequisites

1. **Sevalla Account**: Sign up at [app.sevalla.com](https://app.sevalla.com/)
2. **Git Repository**: Your application code should be in a Git repository
3. **Dockerfile**: The project includes a Dockerfile for containerized deployment

## 🎯 Deployment Steps

### Step 1: Prepare Your Repository

Make sure your repository includes all necessary files:
```
django6_features/
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Docker Compose configuration (for local development)
├── .dockerignore          # Files to exclude from Docker build
├── landingpage/
│   ├── manage.py          # Django management script
│   ├── requirements.txt   # Python dependencies
│   ├── landingpage/
│   │   ├── settings.py    # Django settings
│   │   ├── urls.py        # URL configuration
│   │   └── wsgi.py        # WSGI application
│   ├── subscriptions/     # Django app for email subscriptions
│   ├── templates/         # HTML templates
│   ├── static/            # CSS, JavaScript, and other static assets
│   └── db.sqlite3         # Development database (not used in production)
└── README.md              # Project documentation
```

### Step 2: Environment Variables

The application requires several environment variables for proper operation. These are already configured in your Docker setup:

```bash
# Django configuration
SECRET_KEY=your-super-secret-key-here-change-in-production
DEBUG=0
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=admin123
DJANGO_SUPERUSER_EMAIL=admin@example.com

# Database configuration
POSTGRES_DB=django6_features
POSTGRES_USER=django_user
POSTGRES_PASSWORD=django_password
POSTGRES_HOST=db
POSTGRES_PORT=5432
```

### Step 3: Deploy to Sevalla

1. **Connect Your Repository**:
   - Go to your Sevalla dashboard
   - Create a new application
   - Connect your Git repository

2. **Configure Build Settings**:
   - Sevalla will automatically detect the Dockerfile
   - No additional build configuration is needed

3. **Set Environment Variables in Sevalla**:
   In your Sevalla application settings, add the following environment variables:
   
   ```
   SECRET_KEY=your-very-secure-secret-key-here
   DEBUG=0
   DJANGO_SUPERUSER_USERNAME=admin
   DJANGO_SUPERUSER_PASSWORD=your-superuser-password
   DJANGO_SUPERUSER_EMAIL=admin@yourdomain.com
   POSTGRES_DB=sevalla_django6_features
   POSTGRES_USER=sevalla_django_user
   POSTGRES_PASSWORD=your-database-password
   POSTGRES_HOST=your-database-host
   POSTGRES_PORT=5432
   ```

4. **Deploy**:
   - Click "Deploy" in the Sevalla dashboard
   - Sevalla will build and deploy your application automatically

### Step 4: Initialize Database

After deployment, the database will be automatically initialized through the Docker entrypoint script.

## 🔧 Configuration Options

### Custom Domain
To use a custom domain:
1. Add your domain in Sevalla's domain settings
2. Configure DNS records as instructed by Sevalla
3. Sevalla will automatically provision SSL certificates

### Scaling
Sevalla automatically scales your application based on traffic. You can configure scaling limits in your application settings.

### Environment-Specific Settings

For different environments (development, staging, production), you can create separate applications in Sevalla with different environment variables.

## 🔍 Monitoring and Logs

### View Application Logs
```bash
# In Sevalla dashboard, navigate to your application
# Click on "Logs" to view real-time application logs
```

### Health Checks
The application includes a health check endpoint at `/` which Sevalla uses to monitor application status.

## 🔐 Security Considerations

### Secret Key
Make sure to change the `SECRET_KEY` environment variable to a strong, random value in production:
```bash
# Generate a strong secret key
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### Database Security
For production use, always use a managed database service instead of SQLite:
```bash
# Example PostgreSQL connection string
DATABASE_URL=postgresql://user:password@host:port/database
```

## 🚀 Performance Optimization

### CDN for Static Assets
Sevalla automatically serves static assets (CSS, JavaScript, images) through a CDN for better performance.

### Memory and CPU
Adjust the allocated resources in your Sevalla application settings based on your usage patterns.

## 📊 Troubleshooting

### Common Issues

1. **Application won't start**:
   - Check logs for missing environment variables
   - Verify Dockerfile is correct
   - Ensure all dependencies are in requirements.txt

2. **Database errors**:
   - Make sure database connection settings are correct
   - Check that the database service is running

3. **Static files not loading**:
   - Verify that `collectstatic` ran successfully
   - Check static files configuration in settings.py

### Debugging Commands
```bash
# Check if application is running
curl http://localhost:$PORT/

# Check environment variables
printenv

# Run Django management commands
python manage.py check
```

## 💡 Tips for Success

1. **Test Locally First**: Before deploying, test your application locally using Docker Compose
2. **Use Strong Secrets**: Always use strong, random values for SECRET_KEY
3. **Monitor Usage**: Keep an eye on resource usage and adjust as needed
4. **Backup Data**: Regularly backup your database
5. **Update Dependencies**: Keep your dependencies up to date

## 🆘 Support

If you encounter issues with deployment:
1. Check the Sevalla documentation
2. Review application logs
3. Verify all environment variables are set correctly
4. Ensure your Dockerfile is properly configured

Your Django 6 Features Landing Page should now be successfully deployed on Sevalla! 🎉