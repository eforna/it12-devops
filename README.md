# it12-devops

Fitxers de configuració del servidor DevOps (IT12-DEVOPS, 192.168.2.5).

Conté els `docker-compose.yml`, scripts i configuracions del sistema que s'apliquen
directament al servidor. Es clona a `/opt/devops/` a la màquina Ubuntu.

## Estructura

```
it12-devops/
├── services/        ← docker-compose.yml per servei
│   ├── traefik/
│   ├── gitea/
│   ├── jenkins/
│   ├── portainer/
│   ├── grafana/
│   ├── keycloak/
│   └── harbor/
├── scripts/         ← snapshot.sh, backup.sh, restore-snapshot.sh
└── config/          ← netplan, daemon.json i altres configs del sistema
```

## Ús

```bash
# Clonar al servidor
git clone https://github.com/eforna/it12-devops.git /opt/devops

# Arrancar un servei
cd /opt/devops/services/traefik
docker compose up -d
```

## Documentació

Consulta el repo [devops-lab-doc](https://github.com/eforna/devops-lab-doc)
per a guies pas a pas, notes d'instal·lació i resolució d'errors.
