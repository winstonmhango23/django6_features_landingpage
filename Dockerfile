# Use an official Python runtime as the base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PORT 8000

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        netcat \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies with --pre flag
COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --pre -r requirements.txt

# Copy project
COPY ./landingpage /app

# Expose port (use environment variable)
EXPOSE $PORT

# Create a script to run the application
COPY <<'EOF' /app/start.sh
#!/bin/bash

# Wait for the database to be ready (if DATABASE_URL is set)
if [ -n "$DATABASE_URL" ]; then
  echo "Waiting for database..."
  # Extract host and port from DATABASE_URL if possible
  # This is a simplified check, in production you might want a more robust solution
fi

# Apply database migrations
python manage.py migrate --noinput

# Collect static files
python manage.py collectstatic --noinput --clear

# Create superuser if environment variables are set
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
  echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${DJANGO_SUPERUSER_USERNAME}', '${DJANGO_SUPERUSER_EMAIL:-admin@example.com}', '${DJANGO_SUPERUSER_PASSWORD}') if not User.objects.filter(username='${DJANGO_SUPERUSER_USERNAME}').exists() else None" | python manage.py shell
fi

# Start the server using the PORT environment variable
python manage.py runserver 0.0.0.0:$PORT
EOF

RUN chmod +x /app/start.sh

# Run the start script
CMD ["/app/start.sh"]