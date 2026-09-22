#!/bin/sh
set -e

echo "Running migrations..."
uv run python manage.py migrate

echo "Creating superuser if it does not exist..."
uv run python manage.py shell <<'PY'
import os
from django.contrib.auth import get_user_model

User = get_user_model()

username = os.environ.get("DJANGO_SUPERUSER_USERNAME", "admin")
email = os.environ.get("DJANGO_SUPERUSER_EMAIL", "admin@example.com")
password = os.environ.get("DJANGO_SUPERUSER_PASSWORD")

if password and not User.objects.filter(username=username).exists():
    User.objects.create_superuser(
        username=username,
        email=email,
        password=password,
    )
    print(f"Superuser '{username}' created.")
else:
    print(f"Superuser '{username}' already exists or password is not set.")
PY

echo "Starting Django..."
exec uv run python manage.py runserver 0.0.0.0:8000
