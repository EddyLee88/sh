#!/bin/bash

set -eu

echo "当前用户:${USER:-$(id -un)}"
cd ~
[ -f ~/.env ] && source ~/.env

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/

echo "--------------------------------------------------"
echo "配置PostgreSQL服务..."

cat > ~/.config/containers/systemd/postgres.container <<EOF
[Unit]
Description=PostgreSQL

[Container]
Timezone=local
AutoUpdate=registry
Image=docker.io/library/postgres:18
ContainerName=postgres
HostName=postgres
Network=host

Environment="POSTGRES_USER=${PGSQL_USER:-postgres}"
Environment="POSTGRES_PASSWORD=${PGSQL_PWD:-postgres}"
Environment="POSTGRES_DB=${PGSQL_DB:-postgres}"
Environment="POSTGRES_INITDB_ARGS=--encoding=UTF8 --lc-collate=C.UTF-8 --lc-ctype=C.UTF-8 --auth-host=scram-sha-256 --auth-local=scram-sha-256"

Volume=pgdata:/var/lib/postgresql

[Service]
Restart=always
RestartSec=30

[Install]
WantedBy=default.target
EOF

echo "--------------------------------------------------"
echo "刷新服务列表..."

systemctl --user daemon-reload

echo "--------------------------------------------------"
echo "启动服务..."

systemctl --user start postgres.service
# systemctl --user enable --now postgres.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
