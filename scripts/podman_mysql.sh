#!/bin/bash

set -eu

echo "当前用户:${USER:-$(id -un)}"
cd ~
[ -f ~/.env ] && source ~/.env

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/

echo "--------------------------------------------------"
echo "配置MySQL服务..."

cat > ~/.config/containers/systemd/mysql.container <<EOF
[Unit]
Description=MySQL

[Container]
AutoUpdate=registry
Image=docker.io/library/mysql:8
ContainerName=mysql
HostName=mysql
Network=host
Timezone=local

# Environment="MYSQL_ROOT_HOST=%"
Environment="MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PWD:-root}"
Environment="MYSQL_DATABASE=${MYSQL_DB:-mysql}"

Exec=--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

Volume=mysqldata:/var/lib/mysql

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

systemctl --user start mysql.service
# systemctl --user enable --now mysql.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
