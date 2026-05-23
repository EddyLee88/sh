# 常用脚本

请先创建或更新`~/.env`

```bash
cat > ~/.env <<EOF
MYSQL_ROOT_PWD=root
MYSQL_DB=mysql

PGSQL_USER=postgres
PGSQL_PWD=postgres
PGSQL_DB=postgres

PG_HOST=127.0.0.1
PG_PORT=5432
PG_USER=cpa
PG_PWD=cpa
CPA_DB=cpa

MS_HOST=127.0.0.1
MS_PORT=3306
MS_USER=codex
MS_PWD=codex
CODEX_DB=codex

HBBS_PORT=21116
HBBR_PORT=21117
EOF
```

- ### init.sh
> 初始化服务器(apt/Podman/SWAP/ZRAM/DNS/FireWall/OMZ)

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/init.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/init.sh)"
```

- ### podman_mysql.sh
> 使用[Podman](https://github.com/containers/podman)配置MySQL数据库

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_mysql.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_mysql.sh)"
```

- ### podman_pgsql.sh
> 使用[Podman](https://github.com/containers/podman)配置PostgreSQL数据库

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_pgsql.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_pgsql.sh)"
```

- ### podman_cpa.sh
> 使用[Podman](https://github.com/containers/podman)配置[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_cpa.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_cpa.sh)"
```

- ### podman_codex_manager.sh
> 使用[Podman](https://github.com/containers/podman)配置[Codex Manager](https://github.com/wenfxl/openai-cpa)

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_codex_manager.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_codex_manager.sh)"
```

- ### podman_caddy.sh
> 使用[Podman](https://github.com/containers/podman)配置Caddy

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_caddy.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_caddy.sh)"
```

- ### podman_rustdesk.sh
> 使用[Podman](https://github.com/containers/podman)配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk.sh)"
```

- ### podman_rustdesk_root.sh
> 使用[Podman](https://github.com/containers/podman)配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端(root运行)

```bash
bash -c "$(wget https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk_root.sh -O -)"
# OR
bash -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/ubuntu_sh/main/scripts/podman_rustdesk_root.sh)"
```
