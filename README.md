# 常用脚本

请先创建或更新`~/.env`

```bash
cat > ~/.env <<EOF
MYSQL_ROOT_PWD=root
MYSQL_DB=mysql
PG_USER=postgres
PG_PWD=postgres
PG_DB=postgres
PG_HOST=127.0.0.1
PG_PORT=5432
CPA_DB=cpa
HBBS_PORT=8443
HBBR_PORT=8444
EOF
```

- ### init.sh
> 初始化服务器(apt/Podman/SWAP/ZRAM/DNS/FireWall/OMZ)

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/init.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/init.sh)"
```

- ### podman_mysql.sh
> 使用[Podman](https://github.com/containers/podman)配置MySQL数据库

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_mysql.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_mysql.sh)"
```

- ### podman_pgsql.sh
> 使用[Podman](https://github.com/containers/podman)配置PostgreSQL数据库

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_pgsql.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_pgsql.sh)"
```

- ### podman_cpa.sh
> 使用[Podman](https://github.com/containers/podman)配置[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_cpa.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_cpa.sh)"
```

- ### podman_codex_manager.sh
> 使用[Podman](https://github.com/containers/podman)配置[Codex Manager](https://github.com/wenfxl/openai-cpa)

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_codex_manager.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_codex_manager.sh)"
```

- ### podman_caddy.sh
> 使用[Podman](https://github.com/containers/podman)配置Caddy

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_caddy.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_caddy.sh)"
```

- ### podman_rustdesk.sh
> 使用[Podman](https://github.com/containers/podman)配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk.sh)"
```

- ### podman_rustdesk_root.sh
> 使用[Podman](https://github.com/containers/podman)配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端(root运行)

```bash
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk_root.sh -O -)"
# OR
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk_root.sh)"
```
