#!/bin/bash

set -eu

echo "当前用户:$USER"

echo "--------------------------------------------------"
echo "创建Podman服务配置目录..."

mkdir -p ~/.config/containers/systemd/

echo "--------------------------------------------------"
echo "配置Codex Manager服务..."

cat > ~/.config/containers/systemd/codex.container <<'EOF'
[Unit]
Description=Codex Manager(openai-cpa)

[Container]
AutoUpdate=registry
Image=docker.io/wenfxl/wenfxl-codex-manager:latest
ContainerName=codex
Network=host

Environment="HOST_PROJECT_PATH=%h/openai-cpa"

Volume=codexdata:/app/data

[Service]
# ExecStartPre="/usr/bin/git -C %h/openai-cpa pull"
ExecStartPre="/usr/bin/bash -c 'if [ ! -d %h/openai-cpa/.git ]; then git clone -b main https://github.com/wenfxl/openai-cpa.git %h/openai-cpa; else git -C %h/openai-cpa pull; fi'"
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
