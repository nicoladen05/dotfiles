---
name: homelab
description: Operate and maintain my homelab hosts and services. Use whenever a task concerns the docker, agents, homeassistant, pihole, or vps hosts; Docker Compose services; Tailscale Serve; Cloudflare tunnels; Minecraft hosting; or any homelab deployment, configuration, troubleshooting, or architecture question.
---

# Homelab

## Safety and access

- Run homelab commands on the target host over Tailscale SSH, never on the local machine: `ssh nico@<host> -- '<command>'`. The exception is `homeassistant`, which uses `ssh root@homeassistant -- '<command>'`.
- Confirm the target host from the inventory below. Ask if it is ambiguous.
- Do not modify `/opt/scripts` on `docker`, especially its critical backup script, without explicit permission.
- Do not open a firewall port on `vps` without explicit permission.
- Preserve data and inspect the existing configuration before editing. Never recreate, remove, prune, or reset stateful services unless the user explicitly approves it.
- Do not run remote commands that require `sudo`. Give the command to the user, wait for them to run it, and then continue. Do not copy secrets into chat or the final report.

## Workflow

1. Select the host and connect over SSH as `nico` (`root` on `homeassistant`).
2. Inspect the relevant remote files, service state, and existing conventions before proposing or making changes.
3. Before changing anything, record enough remote state to report the task's machine diff:
   - installed packages relevant to the task;
   - files that will be created, updated, or removed (save checksums or copies of existing versions when useful);
   - enabled and active services relevant to the task;
   - Docker Compose services, images, and published ports when relevant;
   - Tailscale Serve configuration when working on a user-facing service.
4. Make the smallest safe change on the remote host.
5. Validate on the remote host. For Compose changes, run `docker compose config` before applying them and then verify container health/logs.
6. Compare the final state with the recorded state and include a **Machine diff** in the response with:
   - target host;
   - packages installed and removed;
   - files created, updated, and removed;
   - services enabled, disabled, started, stopped, or restarted;
   - containers/images and network exposure changed;
   - validation performed.
     Write `None` for unchanged categories. Do not claim a change that was not observed.
7. If a service was added or substantially changed, update this skill's inventory through the `update-dotfiles` workflow. Do not record secrets, versions, or transient operational state here.

## Shared conventions

- Expose every user-facing service privately with Tailscale Serve at `https://<service>.coati-newton.ts.net`.
- On Docker hosts, store each Compose project at `/opt/containers/<service>/compose.yml`.
- Store user data at `/srv/<service>`. Small state files may live beside `compose.yml`.
- Prefer environment variables directly in `compose.yml`, not a separate `.env` file. Never inline secrets that are already managed securely.
- Use `cloudflared` for public HTTP services.

## Hosts

### `docker`

Main Docker host.

Services:

- `botify` — custom Discord bot; source: <https://github.com/nicoladen05/botify>
- `cloudflared`
- `immich` — photo library; public: `https://immich.nicoladen.dev`
- `norish` — recipe library
- `ocis` — file storage; public: `https://cloud.nicoladen.dev`
- `packwiz-suggestion-bot` — Discord bot for Minecraft mod suggestions; source: <https://github.com/nicoladen05/packwiz-suggestion-bot>
- `paperless` — scanned-document library
- `shelfmark` — ebook downloader
- `superlocal` — private email client; Tailscale: `https://superlocal.coati-newton.ts.net`
- `vaultwarden` — password manager; public: `https://vaultwarden.nicoladen.dev`
- `watchtower` — automatic updates for Docker containers

### `agents`

Dedicated AI and coding-agent host.

Services:

- `hermes-agent`
- `openclaw` — remote Gateway; Tailscale: `https://agents.coati-newton.ts.net`

### `homeassistant`

Runs Home Assistant OS.

Services:

- `homeassistant` — public: `https://homeassistant.nicoladen.dev`, protected with mutual TLS

Manage Home Assistant over SSH as `root@homeassistant`. No Home Assistant MCP server is configured.

- The SSH session runs in the SSH app container and has a zsh login shell, so quote arguments such as `===`.
- The configuration is at `/config`, custom integrations are at `/config/custom_components`, and internal state is at `/config/.storage`. Do not edit `.storage` files while Home Assistant is running, and do not print secrets from them.
- Run commands in the Home Assistant container with `docker exec homeassistant <command>`.
- Read logs with `docker logs homeassistant`, because `ha core logs` returns only the last 100 lines.
- Validate configuration changes with `ha core check` before you restart with `ha core restart`.

### `pihole`

Dedicated Pi-hole host.

Services:

- `pihole`

### `pve`

Proxmox VE host. Manage it through the Proxmox API at `https://pve:8006/api2/json`, not over SSH.

Access:

- Use the API token `agent@pve!claude`. It has `PVEVMAdmin` on `/pool/agents`, `PVEDatastoreUser` on the storage, and `PVESDNUser` on the bridge.
- You can create, change, and remove guests only in the pool `agents`. Pass `pool=agents` when you create a VM or container. You cannot access guests outside the pool. Do not try to work around this.
- The token is in 1Password, in the API Credential item `Proxmox Agents` in the vault `Personal`:
  - `username`: token ID
  - `credential`: token secret
  - `hostname`: API URL
- Load the token with `op run`. The 1Password desktop app then shows an approval prompt to the user. Do not use `op read`, and do not print the secret.

### `vps`

Publicly accessible Oracle Cloud VPS for public non-HTTP services.

It is not reachable over Tailscale from `tag:homelab` devices (such as `docker`) unless the Tailscale ACL allows it.

Services:

- `minecraft-server` — Minecraft server at `/opt/containers/minecraft-server`; Java clients connect through SRV `_minecraft._tcp.mc.nicoladen.dev` → `vps.nicoladen.dev:25566`
- `mc-dashboard` — status page in the `minecraft-server` Compose project; source: <https://github.com/nicoladen05/mc-dashboard>; Tailscale only on `vps:8080`; public: `https://mc.nicoladen.dev` through `cloudflared` on `docker`
- TCP forwarding from the Tailscale host `minecraft-server` to the VPS public IP
- `cloudflared` — own tunnel `vps` (separate from the `docker` tunnel) at `/opt/containers/cloudflared`; host network so routes can target `localhost`; token in `.secrets/tunnel_token`
- `moodle-alt` — Moodle/Artemis client; runs from `~/claude-sandbox/moodle-alt` with `npm start` on port 8001; public: `https://uni.nicoladen.dev` through the `vps` tunnel
