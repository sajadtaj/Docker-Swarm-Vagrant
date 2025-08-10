#!/usr/bin/env bash
set -euo pipefail

# --- بهبود پایداری apt ---
cat >/etc/apt/apt.conf.d/99retries <<'CFG'
Acquire::Retries "5";
Acquire::http::Timeout "30";
Acquire::https::Timeout "30";
CFG

# --- تشخیص توزیع و کدنام ---
. /etc/os-release
OS_ID="${ID:-}"
CODENAME="${VERSION_CODENAME:-}"

if [[ -z "${OS_ID}" || -z "${CODENAME}" ]]; then
  echo "Cannot detect OS or codename from /etc/os-release"
  exit 1
fi

# --- پاکسازی تنظیمات خراب قبلی (اگر وجود دارد) ---
rm -f /etc/apt/sources.list.d/docker.list || true
install -m 0755 -d /etc/apt/keyrings

# --- پیش‌نیازها ---
apt-get update -y || true
apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release apt-transport-https

# --- کلید Docker ---
curl -fsSL https://download.docker.com/linux/${OS_ID}/gpg | gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# --- ریپوی Docker متناسب با توزیع ---
case "${OS_ID}" in
  ubuntu)
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list
    ;;
  debian)
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian ${CODENAME} stable" > /etc/apt/sources.list.d/docker.list
    ;;
  *)
    echo "Unsupported OS: ${OS_ID}"
    exit 1
    ;;
esac

# --- آپدیت و نصب Docker ---
if ! apt-get update -y; then
  # در صورت مشکل HTTPS، به HTTP سوییچ کن (فقط mirror های Debian/Ubuntu اصلی)
  sed -i 's|https://deb.debian.org|http://deb.debian.org|g' /etc/apt/sources.list 2>/dev/null || true
  sed -i 's|https://security.debian.org|http://security.debian.org|g' /etc/apt/sources.list 2>/dev/null || true
  apt-get update -y
fi

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker vagrant || true
systemctl enable docker
systemctl restart docker

echo "Docker installed on ${OS_ID} (${CODENAME})."
