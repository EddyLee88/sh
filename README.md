# 常用脚本

### podman_mysql.sh
> 使用[Podman](https://github.com/containers/podman)配置MySQL数据库

```
wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_mysql.sh
# OR
curl -O https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_mysql.sh

# TODO replace UR_PWD/UR_DB with your actual config

chmod +x podman_mysql.sh

./podman_mysql.sh
```

### podman_pgsql.sh
> 使用[Podman](https://github.com/containers/podman)配置PostgreSQL数据库

```
wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_pgsql.sh
# OR
curl -O https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_pgsql.sh

# TODO replace UR_USER/UR_PWD/UR_DB with your actual config

chmod +x podman_pgsql.sh

./podman_pgsql.sh
```

### podman_cpa.sh
> 使用[Podman](https://github.com/containers/podman)配置[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)

```
wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_cpa.sh
# OR
curl -O https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_cpa.sh

# TODO replace PG_USER/PG_PWD/PG_HOST/PG_PORT/CPA_DB with your actual config

chmod +x podman_cpa.sh

./podman_cpa.sh
```

### podman_rustdesk.sh
> 使用[Podman](https://github.com/containers/podman)配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk.sh)"
# OR
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk.sh -O -)"
```
自定义配置请使用以下方式
```
wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk.sh
# OR
curl -O https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk.sh

# TODO replace HBBS_PORT/HBBR_PORT with your actual config

chmod +x podman_rustdesk.sh

./podman_rustdesk.sh
```

### podman_rustdesk_root.sh
> 使用[Podman](https://github.com/containers/podman)配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端(root运行)

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk_root.sh)"
# OR
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk_root.sh -O -)"
```
自定义配置请使用以下方式
```
wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk_root.sh
# OR
curl -O https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk_root.sh

# TODO replace HBBS_PORT/HBBR_PORT with your actual config

chmod +x podman_rustdesk_root.sh

./podman_rustdesk_root.sh
```
