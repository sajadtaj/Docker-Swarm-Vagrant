#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# بارگذاری env فاز ۴
set -a
. ./.env.swarm
set +a

# بیلد ایمیج روی manager
docker image build -t swarm-todo-api:1.0.0 -f app/backend/Dockerfile .

# ساخت/جایگزینی Secret از POSTGRES_PASSWORD
if docker secret ls --format '{{.Name}}' | grep -qx 'pg_password'; then
  docker secret rm pg_password >/dev/null 2>&1 || true
fi
printf "%s" "${POSTGRES_PASSWORD}" | docker secret create pg_password -

# (اختیاری) پاکسازی ولوم dev قدیمی
docker volume rm todo_pg_data >/dev/null 2>&1 || true
docker volume rm app_todo_pg_data >/dev/null 2>&1 || true

# دیپلوی
docker stack deploy -c app/stack.yml todo

# وضعیت
docker stack services todo
