FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    FORWARDED_ALLOW_IPS="*" \
    WEB_CONCURRENCY=2

WORKDIR /app

# Install Python deps first for better layer caching
COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd -m appuser

# Copy app source (includes app.py, templates/, static/)
COPY --chown=appuser:appuser app/ .

USER appuser

EXPOSE 8000

CMD bash -lc 'exec gunicorn \
  -k uvicorn.workers.UvicornWorker \
  -w ${WEB_CONCURRENCY:-2} \
  -b 0.0.0.0:8000 \
  --access-logfile - \
  --error-logfile - \
  app:app'
