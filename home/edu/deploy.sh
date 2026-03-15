#!/bin/bash
# deploy.sh — Sincronitza el repo it12-devops amb el filesystem del servidor
# Ubicació: /home/edu/deploy.sh
# Ús: bash ~/deploy.sh [--dry-run]
#
# El repo és un mirror de l'arrel del servidor:
#   repo/opt/devops/   →  /opt/devops/
#   repo/etc/netplan/  →  /etc/netplan/
#   repo/etc/docker/   →  /etc/docker/

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DRY_RUN=""

if [ "$1" == "--dry-run" ]; then
    DRY_RUN="--dry-run"
    echo ">>> MODE DRY-RUN: no s'aplicarà cap canvi"
fi

echo "========================================="
echo "Deploy it12-devops → filesystem"
echo "Repo: ${REPO_DIR}"
echo "========================================="

# /opt/devops/
echo ""
echo "[1/3] Sincronitzant /opt/devops/..."
sudo rsync -av --relative $DRY_RUN \
    --exclude='.git' \
    --exclude='.env.example' \
    --exclude='harbor/harbor.yml.example' \
    "${REPO_DIR}/opt/devops/" /opt/devops/

# Permisos scripts
if [ -z "$DRY_RUN" ]; then
    sudo chmod +x /opt/devops/backup/*.sh
    sudo chmod +x /opt/devops/snapshots/*.sh
fi

# /etc/netplan/
echo ""
echo "[2/3] Sincronitzant /etc/netplan/..."
sudo rsync -av $DRY_RUN \
    "${REPO_DIR}/etc/netplan/99-dns.yaml" /etc/netplan/
if [ -z "$DRY_RUN" ]; then
    sudo chmod 600 /etc/netplan/99-dns.yaml
fi

# /etc/docker/
echo ""
echo "[3/3] Sincronitzant /etc/docker/..."
sudo rsync -av $DRY_RUN \
    "${REPO_DIR}/etc/docker/daemon.json" /etc/docker/

echo ""
echo "========================================="
echo "Deploy completat."
if [ -z "$DRY_RUN" ]; then
    echo ""
    echo "Si has canviat netplan: sudo netplan apply"
    echo "Si has canviat daemon.json: sudo systemctl restart docker"
fi
echo "========================================="
