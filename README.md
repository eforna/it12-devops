# it12-devops

Fitxers de configuració del servidor DevOps (IT12-DEVOPS, 192.168.2.5).

Conté els `docker-compose.yml`, scripts i configuracions del sistema que s'apliquen
directament al servidor. Es clona a `/opt/devops/` a la màquina Ubuntu.

## Estructura

L'estructura del repo és un **mirror** de `/opt/devops/` al servidor.
Clonar a `/opt/devops/` fa que cada fitxer quedi al path correcte directament.

```
it12-devops/              →  /opt/devops/
├── traefik/              →  /opt/devops/traefik/
├── gitea/                →  /opt/devops/gitea/
├── jenkins/              →  /opt/devops/jenkins/
├── portainer/            →  /opt/devops/portainer/
├── grafana/              →  /opt/devops/grafana/
├── keycloak/             →  /opt/devops/keycloak/
├── harbor/               →  /opt/devops/harbor/
├── backup.sh             →  /opt/devops/backup.sh
├── backup_snapshots.sh   →  /opt/devops/backup_snapshots.sh
├── snapshot.sh           →  /opt/devops/snapshot.sh
├── restore-snapshot.sh   →  /opt/devops/restore-snapshot.sh
├── .env.example          →  /opt/devops/.env  (copiar i omplir)
└── config/               →  referència — deploy manual (veure més avall)
    ├── netplan/99-dns.yaml     →  /etc/netplan/99-dns.yaml
    └── docker/daemon.json      →  /etc/docker/daemon.json
```

## Ús

```bash
# Primera vegada al servidor
git clone git@github.com:eforna/it12-devops.git /opt/devops
cd /opt/devops
cp .env.example .env && nano .env   # omplir les contrasenyes

# Arrancar un servei
cd /opt/devops/traefik && docker compose up -d

# Actualitzar després d'un canvi des del Mac
cd /opt/devops && git pull
```

## Fitxers de sistema (config/)

Aquests fitxers no es poden desplegar amb `git pull` perquè van a `/etc/`.
Cal copiar-los manualment la primera vegada (o quan canviïn):

```bash
sudo cp /opt/devops/config/netplan/99-dns.yaml /etc/netplan/
sudo chmod 600 /etc/netplan/99-dns.yaml
sudo netplan apply

sudo cp /opt/devops/config/docker/daemon.json /etc/docker/
sudo systemctl restart docker
```

## Documentació

Consulta el repo [devops-lab-doc](https://github.com/eforna/devops-lab-doc)
per a guies pas a pas, notes d'instal·lació i resolució d'errors.
