---
name: homelab
description: Operate and maintain my homelab hosts and services. Use whenever a task concerns the docker, agents, homeassistant, pihole, or vps hosts; Docker Compose services; Tailscale Serve; Cloudflare tunnels; Minecraft hosting; or any homelab deployment, configuration, troubleshooting, or architecture question.
---

# Homelab

## Safety and access

- Run homelab commands on the target host over Tailscale SSH, never on the local machine: `ssh nico@<host> -- '<command>'`.
- Confirm the target host from the inventory below. Ask if it is ambiguous.
- Do not modify `/opt/scripts` on `docker`, especially its critical backup script, without explicit permission.
- Do not open a firewall port on `vps` without explicit permission.
- Preserve data and inspect the existing configuration before editing. Never recreate, remove, prune, or reset stateful services unless the user explicitly approves it.
- Do not run remote commands that require `sudo`. Give the command to the user, wait for them to run it, and then continue. Do not copy secrets into chat or the final report.

## Workflow

1. Select the host and connect as `nico` over SSH.
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

### `homeassistant`

Runs Home Assistant OS.

Services:

- `homeassistant` — public: `https://homeassistant.nicoladen.dev`, protected with mutual TLS

Use the Home Assistant MCP server for Home Assistant changes. If it is unavailable and the task needs it, ask the user to set it up rather than attempting an unsupported workaround.

### `pihole`

Dedicated Pi-hole host.

Services:

- `pihole`

### `vps`

Publicly accessible Oracle Cloud VPS for public non-HTTP services.

Services:

- Minecraft server
- TCP forwarding from the Tailscale host `minecraft-server` to the VPS public IP
