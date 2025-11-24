# Render backend image for Odoo.
FROM python:3.11-slim

# System dependencies needed by psycopg2, lxml, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev libxml2-dev libxslt1-dev libjpeg-dev zlib1g-dev \
    libffi-dev libssl-dev libldap2-dev libsasl2-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install Python deps first for better layer caching.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application source.
COPY . .

# Expose the default Odoo HTTP port.
EXPOSE 8069

# Start Odoo using the provided config file (override with RENDER env vars as needed).
CMD ["python", "odoo-bin", "-c", "odoo.conf"]
