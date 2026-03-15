#!/bin/bash
# Restauració interactiva d'un snapshot BTRFS per a un servei
# Ús: sudo /opt/devops/restore-snapshot.sh

echo "Snapshots disponibles:"
for dir in portainer gitea jenkins grafana prometheus keycloak harbor; do
    echo ""
    echo "  ${dir}:"
    ls /mnt/btrfs-snapshots/${dir}/ 2>/dev/null || echo "    (cap snapshot)"
done

echo ""
echo "Introdueix el servei a restaurar (ex: gitea):"
read SERVICE

if [ ! -d "/mnt/btrfs-snapshots/${SERVICE}" ]; then
    echo "ERROR: Servei '${SERVICE}' no trobat"
    exit 1
fi

echo "Introdueix el snapshot a restaurar:"
ls /mnt/btrfs-snapshots/${SERVICE}/
read SNAPSHOT

SNAP_PATH="/mnt/btrfs-snapshots/${SERVICE}/${SNAPSHOT}"

if [ ! -d "${SNAP_PATH}" ]; then
    echo "ERROR: No existeix el snapshot ${SNAP_PATH}"
    exit 1
fi

echo ""
echo "ATENCIÓ: Es restaurarà ${SERVICE} des de ${SNAPSHOT}"
echo "Continuar? (s/N):"
read CONFIRM
if [ "$CONFIRM" != "s" ] && [ "$CONFIRM" != "S" ]; then
    echo "Cancel·lat."
    exit 0
fi

echo "Parant servei ${SERVICE}..."
cd /opt/devops/${SERVICE}
docker compose down

# Backup de seguretat de l'estat actual
echo "Creant snapshot de seguretat previ a la restauració..."
btrfs subvolume snapshot \
    /mnt/btrfs-data/${SERVICE} \
    /mnt/btrfs-snapshots/${SERVICE}/${SERVICE}-before-restore-$(date +%Y%m%d_%H%M%S)

echo "Restaurant ${SERVICE}..."
btrfs subvolume delete /mnt/btrfs-data/${SERVICE}
btrfs subvolume snapshot ${SNAP_PATH} /mnt/btrfs-data/${SERVICE}

echo "Arrencant servei ${SERVICE}..."
docker compose up -d

echo ""
echo "Restauració completada!"
echo "Verificar: docker compose ps"
