#!/bin/bash

set -eu

echo "当前用户:${USER:-$(id -un)}"
cd ~
[ -f ~/.env ] && source ~/.env

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/

echo "--------------------------------------------------"
echo "配置Codex Manager服务..."

cat > ~/.config/containers/systemd/codex.container <<EOF
[Unit]
Description=Codex Manager(openai-cpa)

[Container]
AutoUpdate=registry
Image=docker.io/wenfxl/wenfxl-codex-manager:latest
ContainerName=codex
HostName=codex
Network=host
Timezone=local

Environment="HOST_PROJECT_PATH=%h/openai-cpa"
Environment="TZ=Asia/Shanghai"
Environment="WEB_HOST=127.0.0.1"
Environment="DB_TYPE=mysql"
Environment="DB_HOST=${MS_HOST:-127.0.0.1}"
Environment="DB_PORT=${MS_PORT:-3306}"
Environment="DB_USER=${MS_USER:-codex}"
Environment="DB_PASS=${MS_PWD:-codex}"
Environment="DB_NAME=${CODEX_DB:-codex}"

Volume=codexdata:/app/data

[Service]
# ExecStartPre=/usr/bin/git -C %h/openai-cpa pull
ExecStartPre=/usr/bin/bash -c 'if [ ! -d %h/openai-cpa/.git ]; then /usr/bin/git clone -b main https://github.com/wenfxl/openai-cpa.git %h/openai-cpa; else /usr/bin/git -C %h/openai-cpa pull; fi'
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

systemctl --user start codex.service
# systemctl --user enable --now codex.service

echo "--------------------------------------------------"
echo "配置自动启动/后台运行..."

sudo loginctl enable-linger $USER

echo "--------------------------------------------------"
echo "配置自动更新..."

systemctl --user enable --now podman-auto-update.timer

echo "--------------------------------------------------"
echo "DONE"
