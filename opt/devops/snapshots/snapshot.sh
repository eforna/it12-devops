#!/bin/bash
# Snapshots BTRFS diaris de tots els serveis
# Cron: 0 1 * * * /opt/devops/snapshots/snapshot.sh

DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/snapshot-it12.log"
SNAP_DIR="/mnt/btrfs-snapshots"

echo "========================================" | tee -a $LOG_FILE
echo "Snapshot iniciat: ${DATE}" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE

for dir in portainer gitea jenkins grafana prometheus keycloak harbor; do
    echo "  Snapshot ${dir}..." | tee -a $LOG_FILE
    mkdir -p ${SNAP_DIR}/${dir}
    btrfs subvolume snapshot -r \
        /mnt/btrfs-data/${dir} \
        ${SNAP_DIR}/${dir}/${dir}-${DATE}
    echo "  OK ${dir}: ${SNAP_DIR}/${dir}/${dir}-${DATE}" | tee -a $LOG_FILE
done

# Netejar snapshots antics (més de 7 dies)
echo "Netejant snapshots antics..." | tee -a $LOG_FILE
for dir in portainer gitea jenkins grafana prometheus keycloak harbor; do
    find ${SNAP_DIR}/${dir} -maxdepth 1 -type d -mtime +7 | while read snap; do
        echo "  Eliminant ${snap}..." | tee -a $LOG_FILE
        btrfs subvolume delete ${snap}
    done
done

echo "Snapshot completat: ${DATE}" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE
