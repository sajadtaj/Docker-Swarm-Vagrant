#!/usr/bin/env bash
set -euo pipefail

# اگر متغیر SWARM_ADVERTISE_IP ست شده باشد، همان را استفاده کن؛ وگرنه auto-detect از شبکه های 192.168.*
MANAGER_IP="${SWARM_ADVERTISE_IP:-$(ip -4 addr show | awk '/inet 192\.168\./ {print $2}' | cut -d/ -f1 | head -n1)}"

if [[ -z "${MANAGER_IP}" ]]; then
  echo "Cannot detect manager IP automatically. Set SWARM_ADVERTISE_IP."
  exit 1
fi

if ! docker info 2>/dev/null | grep -q "Swarm: active"; then
  docker swarm init --advertise-addr "${MANAGER_IP}"
fi

docker network ls | grep -q "app-net" || docker network create -d overlay --attachable app-net

WORKER_TOKEN=$(docker swarm join-token -q worker)
cat > /vagrant/provision/join-worker.sh <<EOF
#!/usr/bin/env bash
docker swarm join --token ${WORKER_TOKEN} ${MANAGER_IP}:2377
EOF
chmod +x /vagrant/provision/join-worker.sh

echo "Swarm initialized on ${MANAGER_IP} and app-net created."
