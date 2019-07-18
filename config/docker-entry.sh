#!/bin/sh
set -e

if [ "$1" = '/opt/django-venv/bin/gunicorn' ]; then
    #dockerize -wait tcp://postgres:5432
    /opt/django-venv/bin/python /opt/app/manage.py migrate --noinput
    /opt/django-venv/bin/python /opt/app/manage.py collectstatic --noinput
    exec "$@"
fi

exec "$@"
