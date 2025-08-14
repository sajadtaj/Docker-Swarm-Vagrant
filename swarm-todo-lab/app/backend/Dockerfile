FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app

# gcc برای بعضی وابستگی‌ها؛ bash, curl, postgresql-client برای wait & healthcheck
RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc bash curl postgresql-client \
 && rm -rf /var/lib/apt/lists/*

COPY app/backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY app/backend/app ./app

EXPOSE 8000

# CMD ساده؛ ساخت DATABASE_URL را به command در stack.yml می‌سپاریم
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
