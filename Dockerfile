# Use an official Python runtime as the base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        netcat \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY ./landingpage/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY ./landingpage /app

# Expose port
EXPOSE 8000

# Create a script to run the application
COPY <<'EOF' /app/start.sh
#!/bin/bash

# Wait for the database to be ready
while ! nc -z db 5432; do
  echo "Waiting for database..."
  sleep 1
done

# Apply database migrations
python manage.py migrate --noinput

# Collect static files
python manage.py collectstatic --noinput --clear

# Create superuser if it doesn't exist
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${DJANGO_SUPERUSER_USERNAME}', '${DJANGO_SUPERUSER_EMAIL}', '${DJANGO_SUPERUSER_PASSWORD}') if not User.objects.filter(username='${DJANGO_SUPERUSER_USERNAME}').exists() else None" | python manage.py shell

# Start the server
python manage.py runserver 0.0.0.0:8000
EOF

RUN chmod +x /app/start.sh

# Run the start script
CMD ["/app/start.sh"]