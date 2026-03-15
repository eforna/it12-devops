# it12-devops

Fitxers de configuració del servidor DevOps (IT12-DEVOPS, 192.168.2.5).

L'estructura del repo és un **mirror complet del filesystem** del servidor.
Cada fitxer del repo té el mateix path relatiu que al servidor:

```
it12-devops/               →   /  (arrel del servidor)
├── opt/devops/            →   /opt/devops/
│   ├── traefik/
│   ├── gitea/
│   ├── jenkins/
│   ├── grafana/
│   ├── keycloak/
│   ├── portainer/
│   ├── harbor/
│   ├── backup/
│   │   ├── backup.sh
│   │   └── backup_snapshots.sh
│   └── snapshots/
│       ├── snapshot.sh
│       └── restore-snapshot.sh
├── etc/
│   ├── netplan/99-dns.yaml
│   └── docker/daemon.json
└── home/edu/
    └── deploy.sh
```

## Primera instal·lació al servidor

```bash
# 1. Clonar el repo
git clone git@github.com:eforna/it12-devops.git ~/it12-devops

# 2. Copiar el deploy.sh al lloc correcte
cp ~/it12-devops/home/edu/deploy.sh ~/deploy.sh
chmod +x ~/deploy.sh

# 3. Preparar les credencials
cp ~/it12-devops/opt/devops/.env.example /opt/devops/.env
nano /opt/devops/.env   # omplir les contrasenyes

# 4. Fer el deploy
bash ~/deploy.sh
```

## Flux de treball habitual

```bash
# Al Mac (VSCode): editar fitxers → commit → push

# Al servidor: actualitzar i desplegar
cd ~/it12-devops && git pull
bash ~/deploy.sh

# Si cal reiniciar un servei
cd /opt/devops/traefik && docker compose up -d
```

## deploy.sh

Sincronitza el repo amb el filesystem via `rsync`. Suporta `--dry-run` per previsualitzar canvis sense aplicar-los:

```bash
bash ~/deploy.sh --dry-run   # previsualitzar
bash ~/deploy.sh             # aplicar
```

## Documentació

Consulta el repo [devops-lab-doc](https://github.com/eforna/devops-lab-doc)
per a guies pas a pas, notes d'instal·lació i resolució d'errors.
