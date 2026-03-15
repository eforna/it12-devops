#!/bin/bash
# Backup diari dels snapshots BTRFS al NAS
# Cron: 0 3 * * * /opt/devops/backup/backup_snapshots.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/mnt/nas-backup/it12-devops/${DATE}_snapshots"
LOG_FILE="/var/log/backup-it12.log"

echo "========================================" | tee -a $LOG_FILE
echo "Backup snapshots iniciat: ${DATE}" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE

mkdir -p ${BACKUP_DIR}/btrfs-snapshots

echo "Backup /mnt/btrfs-snapshots..." | tee -a $LOG_FILE
for dir in portainer gitea jenkins grafana prometheus keycloak harbor; do
    echo "  Backup snapshots ${dir}..." | tee -a $LOG_FILE
    tar -czf ${BACKUP_DIR}/btrfs-snapshots/${dir}-snapshots-${DATE}.tar.gz \
        -C /mnt/btrfs-snapshots ${dir}/
    echo "  OK snapshots ${dir}" | tee -a $LOG_FILE
done

echo "Netejant backups snapshots antics (>7 dies)..." | tee -a $LOG_FILE
find /mnt/nas-backup/it12-devops -maxdepth 1 -type d -mtime +7 \
    -name "*_snapshots" -exec rm -rf {} \;

echo "Backup snapshots completat: ${DATE}" | tee -a $LOG_FILE
echo "Espai total: $(du -sh ${BACKUP_DIR})" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE
