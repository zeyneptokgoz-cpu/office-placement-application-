# 1. Python'un resmi ve hafif bir sürümünü temel alıyoruz
FROM python:3.10-slim

# 2. Python çıktılarının anında terminale düşmesini sağlıyoruz (Logları görmek için)
ENV PYTHONUNBUFFERED=1

# 3. Konteyner içinde çalışacağımız klasörü oluşturuyoruz
WORKDIR /app

# 4. Gerekli sistem kütüphanelerini kuruyoruz (PostgreSQL ve GCC derleyicisi için)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 5. Önce requirements dosyasını kopyalayıp paketleri kuruyoruz
# (Bunu ayrı adım yapmak, Docker'ın önbellek (cache) kullanmasını sağlar)
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# 6. Projenin geri kalan tüm kodlarını kopyalıyoruz
COPY . /app/

# 7. Projenin çalışacağı portu belirtiyoruz
EXPOSE 8000

# 8. Konteyner başlatıldığında çalışacak komut
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]