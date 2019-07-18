FROM python:3.6-alpine3.8
WORKDIR /opt/app/
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY requirements.txt /opt/app/
RUN apk --no-cache add --virtual .python-rundeps \
        libpq \
        postgresql-libs \
    && apk --no-cache add --virtual .build-deps \
        gcc \
        musl-dev \
        postgresql-dev \
    && python3 -m venv /opt/django-venv \
    && /opt/django-venv/bin/pip install -r /opt/app/requirements.txt --no-cache-dir\
    && apk --purge del .build-deps
ENV DOCKERIZE_VERSION v0.6.0
COPY config/docker-entry.sh /docker-entry.sh
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
RUN chown -R appuser:appgroup /opt/app
COPY . /opt/app/
ENV DATABASE_URL="sqlite:////var/app/db.sqlite3" \
    ADMIN_EMAIL="" \
    SECRET_KEY="" \
    EMAIL_HOST="" \
    EMAIL_HOST_USER="" \
    EMAIL_HOST_PASSWORD=""
USER appuser
EXPOSE 8000
VOLUME /var/app/static_serve
VOLUME /var/app/upload
VOLUME /var/lib/celery/
ENTRYPOINT ["/docker-entry.sh"]
CMD ["/opt/django-venv/bin/gunicorn", "heartbeat.wsgi:application", "--bind", "0.0.0.0:8000", "--workers=1"]
