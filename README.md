# 常用脚本

### podman_rustdesk.sh
> 使用Podman配置[RustDesk](https://github.com/rustdesk/rustdesk-server)服务端

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk.sh)"
# OR
sh -c "$(wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_rustdesk.sh -O -)"
```

### podman_db.sh
> 使用Podman配置数据库(MySQL/PostgreSQL)

```
wget https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_db.sh
# OR
curl -O https://raw.githubusercontent.com/EddyLee88/sh/main/scripts/podman_db.sh

# TODO replace UR_USER/UR_PWD/UR_DB with your actual config

chmod +x podman_db.sh

./podman_db.sh
```
