#!/bin/bash

set -eu

echo "当前用户:$USER"

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/

echo "--------------------------------------------------"
echo "配置CLIProxyAPI服务..."

cat > ~/.config/containers/systemd/cpa.container <<'EOF'
[Unit]
Description=CLIProxyAPI

[Container]
AutoUpdate=registry
Image=docker.io/eceasy/cli-proxy-api:latest
ContainerName=cpa
Network=host

Environment="DEPLOY=cloud"
Environment="PGSTORE_DSN='postgresql://PG_USER:PG_PWD@PG_HOST:PG_PORT/CPA_DB'"
Environment="PGSTORE_SCHEMA=public"
Environment="PGSTORE_LOCAL_PATH='/var/lib/cliproxy'"

Volume=cpadata:/var/lib/cliproxy/pgstore

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

systemctl --user start cpa.service
# systemctl --user enable --now cpa.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
