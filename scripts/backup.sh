#!/bin/bash
# Backup setmanal complet al NAS Synology
# Cron: 0 2 * * 0 /opt/devops/backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/mnt/nas-backup/it12-devops/${DATE}"
LOG_FILE="/var/log/backup-it12.log"

echo "========================================" | tee -a $LOG_FILE
echo "Backup iniciat: ${DATE}" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE

mkdir -p ${BACKUP_DIR}/{docker-configs,btrfs-data,system,home}

echo "Backup /opt/devops..." | tee -a $LOG_FILE
tar -czf ${BACKUP_DIR}/docker-configs/opt-devops-${DATE}.tar.gz -C / opt/devops/

echo "Backup /mnt/btrfs-data..." | tee -a $LOG_FILE
for dir in portainer gitea grafana prometheus keycloak harbor; do
    echo "  Backup ${dir}..." | tee -a $LOG_FILE
    tar -czf ${BACKUP_DIR}/btrfs-data/${dir}-${DATE}.tar.gz -C /mnt/btrfs-data ${dir}/
    echo "  OK ${dir}" | tee -a $LOG_FILE
done

echo "  Backup jenkins (sense war i plugins)..." | tee -a $LOG_FILE
tar -czf ${BACKUP_DIR}/btrfs-data/jenkins-${DATE}.tar.gz \
    --exclude=jenkins/war \
    --exclude=jenkins/plugins \
    -C /mnt/btrfs-data jenkins/
echo "  OK jenkins" | tee -a $LOG_FILE

echo "Backup /etc..." | tee -a $LOG_FILE
tar -czf ${BACKUP_DIR}/system/etc-${DATE}.tar.gz -C / etc/

echo "Backup /home/edu..." | tee -a $LOG_FILE
tar -czf ${BACKUP_DIR}/home/home-${DATE}.tar.gz -C /home edu/

# Documentar imatges Docker en ús
docker images --format "{{.Repository}}:{{.Tag}}" > ${BACKUP_DIR}/docker-images-list.txt

echo "Netejant backups antics (>7 dies)..." | tee -a $LOG_FILE
find /mnt/nas-backup/it12-devops -maxdepth 1 -type d -mtime +7 \
    ! -name "*_snapshots" -exec rm -rf {} \;

echo "Backup completat: ${DATE}" | tee -a $LOG_FILE
echo "Espai total: $(du -sh ${BACKUP_DIR})" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE
