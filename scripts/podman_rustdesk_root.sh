#!/bin/bash

set -eu

echo "当前用户:$USER"

if [ "$(id -u)" -ne 0 ]; then
    echo "--------------------------------------------------"
    echo "请root运行..."
    exit 1
fi

echo "--------------------------------------------------"
echo "初始化配置目录..."

mkdir -p /opt/rustdesk-server/data
mkdir -p /etc/containers/systemd

echo "--------------------------------------------------"
echo "配置rustdesk-hbbs服务..."

cat > /etc/containers/systemd/rustdesk-hbbs.container <<'EOF'
[Unit]
Description=RustDesk ID Server(hbbs)

[Container]
AutoUpdate=registry
Image=ghcr.io/rustdesk/rustdesk-server:latest
ContainerName=rustdesk-hbbs
Network=host

Exec=hbbs -p8443

Volume=/opt/rustdesk-server/data:/root

[Service]
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "--------------------------------------------------"
echo "配置rustdesk-hbbr服务..."

cat > /etc/containers/systemd/rustdesk-hbbr.container <<'EOF'
[Unit]
Description=RustDesk Relay Server(hbbr)
After=rustdesk-hbbs.service

[Container]
AutoUpdate=registry
Image=ghcr.io/rustdesk/rustdesk-server:latest
ContainerName=rustdesk-hbbr
Network=host

Exec=hbbr -p8444

Volume=/opt/rustdesk-server/data:/root

[Service]
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "--------------------------------------------------"
echo "刷新服务列表..."

systemctl daemon-reload

echo "--------------------------------------------------"
echo "启动服务..."

systemctl start rustdesk-hbbs.service
# systemctl enable --now rustdesk-hbbs.service

systemctl start rustdesk-hbbr.service
# systemctl enable --now rustdesk-hbbr.service

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
