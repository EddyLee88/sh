#!/bin/bash

set -eu

echo "当前用户:$USER"

echo "--------------------------------------------------"
echo "初始化配置目录..."

mkdir -p ~/.config/containers/systemd/
mkdir -p ~/rustdesk-server/data

echo "--------------------------------------------------"
echo "配置rustdesk-hbbs服务..."

cat > ~/.config/containers/systemd/rustdesk-hbbs.container <<'EOF'
[Unit]
Description=RustDesk ID Server(hbbs)

[Container]
AutoUpdate=registry
Image=ghcr.io/rustdesk/rustdesk-server:latest
ContainerName=rustdesk-hbbs
Network=host

Exec=hbbs -p8443

Volume=%h/rustdesk-server/data:/root

[Service]
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "--------------------------------------------------"
echo "配置rustdesk-hbbr服务..."

cat > ~/.config/containers/systemd/rustdesk-hbbr.container <<'EOF'
[Unit]
Description=RustDesk Relay Server(hbbr)
After=rustdesk-hbbs.service

[Container]
AutoUpdate=registry
Image=ghcr.io/rustdesk/rustdesk-server:latest
ContainerName=rustdesk-hbbr
Network=host

Exec=hbbr -p8444

Volume=%h/rustdesk-server/data:/root

[Service]
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "--------------------------------------------------"
echo "刷新服务列表..."

systemctl --user daemon-reload

echo "--------------------------------------------------"
echo "启动服务..."

systemctl --user start rustdesk-hbbs.service
# systemctl --user enable --now rustdesk-hbbs.service

systemctl --user start rustdesk-hbbr.service
# systemctl --user enable --now rustdesk-hbbr.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
