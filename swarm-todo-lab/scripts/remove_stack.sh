#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

docker stack rm todo || true
sleep 3
# در صورت نیاز برای ری‌اینیت DB:
docker volume rm todo_pg_data >/dev/null 2>&1 || true
docker volume rm app_todo_pg_data >/dev/null 2>&1 || true
echo "Removed stack 'todo'."
