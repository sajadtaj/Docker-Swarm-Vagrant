#!/usr/bin/env bash
set -euo pipefail

ROOT="swarm-todo-lab"

# helper: write file only if missing
write_if_missing() {
  local path="$1"; shift
  if [[ -f "$path" ]]; then
    echo "skip: $path (exists)"
  else
    mkdir -p "$(dirname "$path")"
    cat > "$path" <<'EOF'
'"$@"'
EOF
    echo "create: $path"
  fi
}

# helper: touch empty file if missing
touch_if_missing() {
  local path="$1"
  if [[ -f "$path" ]]; then
    echo "skip: $path (exists)"
  else
    mkdir -p "$(dirname "$path")"
    : > "$path"
    echo "create: $path"
  fi
}

# dirs
mkdir -p "$ROOT"/{provision,scripts,app/backend/app/routers}

# files (with minimal content where helpful)
touch_if_missing "$ROOT/.env"
write_if_missing "$ROOT/.env.swarm" 'POSTGRES_USER=todo
POSTGRES_DB=todo_db
# PG password via docker secret (pg_password)'

write_if_missing "$ROOT/README.md" '# Swarm Todo Lab

این پروژه یک لَب ۳ نودی Vagrant برای یادگیری Docker Swarm می‌سازد و یک سرویس Todo (FastAPI + PostgreSQL) را به‌صورت Stack دیپلوی می‌کند.

## ساخت لَب
```bash
vagrant up manager-1
vagrant up worker-1 worker-2
vagrant ssh manager-1 -c "docker node ls"
