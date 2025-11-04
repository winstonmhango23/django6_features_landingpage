# Use an official Python runtime as the base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PORT 8000

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install --pre -r requirements.txt

# Copy project
COPY landingpage /app/

# Expose port
EXPOSE $PORT

# Run the application
CMD ["sh", "-c", "cd landingpage && python manage.py migrate --noinput && gunicorn landingpage.wsgi:application --bind 0.0.0.0:$PORT"]