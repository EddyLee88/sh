#!/bin/bash

set -eu

echo "当前用户:$USER"

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/

echo "--------------------------------------------------"
echo "配置PostgreSQL服务..."

cat > ~/.config/containers/systemd/postgres18.container <<'EOF'
[Unit]
Description=PostgreSQL

[Container]
AutoUpdate=registry
Image=docker.io/library/postgres:18
ContainerName=postgres18
Network=host

Environment="POSTGRES_USER=UR_USER"
Environment="POSTGRES_PASSWORD=UR_PWD"
Environment="POSTGRES_DB=UR_DB"
Environment="POSTGRES_INITDB_ARGS=--encoding=UTF8 --lc-collate=C.UTF-8 --lc-ctype=C.UTF-8"

Exec=-c listen_addresses="*"

Volume=pgdata18:/var/lib/postgresql

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

systemctl --user start postgres18.service
# systemctl --user enable --now postgres18.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
