# AGENTS.md

## Repo Shape
- This repo is a small collection of Ubuntu/Podman provisioning scripts, not an app/package workspace. There are no package manifests or lockfiles; do not invent npm/pnpm/go/cargo workflows.
- `README.md` is the user-facing script catalog, canonical remote-run snippets, and the only documented `~/.env` variable reference.
- `scripts/github_actions_upstream_sync.yaml` is a workflow template stored as a script asset, not an active workflow unless copied under `.github/workflows/`.

## Script Conventions
- All runnable scripts are Bash with `#!/bin/bash` and `set -eu`; keep new scripts consistent unless there is a verified reason not to.
- Status messages and README descriptions are Chinese; preserve that style for user-facing script output/docs.
- Podman scripts `cd ~` and load per-machine config with `[ -f ~/.env ] && source ~/.env`; keep README env docs in sync when adding or renaming config variables.
- Current `~/.env` variables/defaults are `MYSQL_ROOT_PWD=root`, `MYSQL_DB=mysql`, `PG_USER=postgres`, `PG_PWD=postgres`, `PG_DB=postgres`, `PG_HOST=127.0.0.1`, `PG_PORT=5432`, `CPA_DB=cpa`, `HBBS_PORT=8443`, and `HBBR_PORT=8444`.
- Use inline Bash defaults in generated Quadlets, e.g. `${VAR:-default}`. Keep heredocs quoted (`<<'EOF'`) unless shell interpolation is required; switch to `<<EOF` only for generated files that actually need env/default expansion.
- Most rootless Podman scripts write Quadlet `.container` files under `~/.config/containers/systemd/` with `AutoUpdate=registry`, `Network=host`, named volumes, `systemctl --user daemon-reload`, explicit `systemctl --user start`, linger, and `podman-auto-update.timer`; direct `systemctl --user enable --now <service>` lines are intentionally commented out.
- `podman_rustdesk_root.sh` is the root/system-wide exception: it requires UID 0, writes to `/etc/containers/systemd`, stores data in `/opt/rustdesk-server/data`, uses system `systemctl`, and targets `multi-user.target`.
- README snippets are remote execution forms (`sh -c "$(wget ... -O -)"` / `sh -c "$(curl -fsSL ...)"`); do not reintroduce download-edit-chmod-run instructions for normal configuration.

## Verification
- Safe local syntax check: `bash -n scripts/*.sh`.
- Do not run provisioning scripts directly on the host during routine verification: they mutate apt packages, swap/zram, DNS, firewall state, Podman Quadlet files, systemd services, `/etc`, `~`, and sometimes `/opt`.

## Operational Gotchas
- `scripts/init.sh` is invasive: it upgrades apt packages, installs Podman and FastFetch, sets `net.ipv4.ip_unprivileged_port_start=23`, rewrites swap/zram/sysctl/DNS config, resets iptables/ip6tables, disables/purges ufw, and may install Oh My Zsh.
- `podman_caddy.sh` creates `~/caddy/Caddyfile` and bind-mounts it to `/etc/caddy/Caddyfile`; preserve that host-side config path in docs and script changes.
- `podman_codex_manager.sh` embeds an `ExecStartPre` that clones or pulls `https://github.com/wenfxl/openai-cpa.git` into `%h/openai-cpa` before starting the container.
- RustDesk uses two generated services (`rustdesk-hbbs` and `rustdesk-hbbr`); `hbbr` has `After=rustdesk-hbbs.service`, both share one data directory, and ports come from `HBBS_PORT`/`HBBR_PORT` defaults.
- The upstream sync workflow template uses `UPSTREAM_REPO_SECRET` and falls back to `OWNER/REPO`; update those placeholders if the template is made active.
