#!/usr/bin/env bash
set -euo pipefail
if docker info 2>/dev/null | grep -q 'Swarm: active'; then
  exit 0
fi

if [[ -x /vagrant/provision/join-worker.sh ]]; then
  /vagrant/provision/join-worker.sh || true
else
  echo "join-worker.sh not ready yet. Run 'vagrant provision' again after manager is up."
fi
