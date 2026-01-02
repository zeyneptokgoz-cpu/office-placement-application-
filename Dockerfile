FROM python:3.10-slim

WORKDIR /app

# Postgres için gerekli sistem kütüphaneleri
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Bağımlılıkları yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Projeyi kopyala
COPY . .

EXPOSE 8000

# Server başlatma komutu
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]