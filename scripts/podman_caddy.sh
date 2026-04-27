#!/bin/bash

set -eu

echo "当前用户:$USER"

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/
mkdir -p ~/caddy

echo "--------------------------------------------------"
echo "配置Caddy服务..."

cat > ~/.config/containers/systemd/caddy.container <<'EOF'
[Unit]
Description=Caddy
# After=cpa.service

[Container]
AutoUpdate=registry
Image=docker.io/library/caddy:latest
ContainerName=caddy
Network=host

Volume=%h/caddy/Caddyfile:/etc/caddy/Caddyfile
Volume=caddydata:/data
Volume=caddyconfig:/config

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

systemctl --user start caddy.service
# systemctl --user enable --now caddy.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
