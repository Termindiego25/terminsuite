# Emby setup (TerminSuite Media Server)

## 🧭 Overview

Emby is a personal media server that organizes and streams your movies, series, and music across devices.
Within **TerminSuite**, Emby serves as the **DLNA/NAS media frontend**, operating behind **Traefik** and accessible securely through the **Cloudflare Tunnel**.

---

## 📁 Directory Structure

```
/emby
├── docker-compose.yaml    # Docker stack definition
├── emby.env               # Environment variables (UID/GID configuration)
├── config/                # Persistent Emby configuration and metadata

(optional)
├── favicon.ico            # Web UI icon
├── logowhite.png          # app-branded logo
└── images/                # Images pack for web dashboard
    ├── icon-128x128.png
    ├── icon-144x144.png
    ├── icon-152x152.png
    ├── icon-192x192.png
    ├── icon-384x384.png
    ├── icon-512x512.png
    ├── icon-72x72.png
    ├── icon-96x96.png
    └── splash.png
```

---

## 🔧 Configuration

### Environment Variables

The container inherits user and group permissions from the `.env` file:

```env
UID=1000
GID=100
GIDLIST=$OWNER_GID,$VIDEO_GID,$RENDER_GID
```

* `$OWNER_GID` → group owning the NAS or media directory
* `$VIDEO_GID` → video group for VAAPI acceleration
* `$RENDER_GID` → render group for GPU device access

> These values can be dynamically sourced from TerminSuite’s environment files or Docker secrets.

---

### Hardware Acceleration

Hardware acceleration is enabled by mapping the GPU device:

```yaml
devices:
  - /dev/dri:/dev/dri
```

This configuration supports **Intel VAAPI**, used by the **Raspberry Pi 5** for hardware-accelerated transcoding.

---

### Logo Customization

To apply app’s branding in the Emby web interface, the following assets are mounted:

```yaml
volumes:
  - ./favicon.ico:/system/dashboard-ui/favicon.ico
  - ./images:/system/dashboard-ui/images
  - ./logowhite.png:/system/dashboard-ui/modules/themes/logowhite.png
```

You can replace these files to apply your own logo or icons without modifying Emby’s internal files permanently.

---

### Network Configuration

The container listens only on the local interface:

```yaml
ports:
  - "127.0.0.1:22443:8096"
```

This ensures:

* Emby is **not directly accessible** from the LAN or Internet.
* **Traefik** handles all external access via HTTPS.
* **Connector** maintains the SSH tunnel between Traefik and the Emby host.

---

### Traefik Integration

Traefik routes traffic securely using Cloudflare-issued certificates:

```yaml
http:
  routers:
    emby:
      rule: "Host(`emby.domain.com`)"
      entryPoints: [websecure]
      tls:
        certresolver: cloudflare
      service: emby

  services:
    emby:
      loadBalancer:
        servers:
          - url: "http://emby:22443"
```

> Emby traffic flow:
> **Cloudflare Tunnel → Traefik → Connector → Emby**

---

## 🚀 Deployment

Deploy the container:

```bash
cd /apps/emby
docker compose up -d
```

Verify that the service is running:

```bash
docker ps | grep emby
```

Access the dashboard through your Cloudflare-protected domain:

```
https://emby.domain.com
```

---

## 🧰 Maintenance

* **Update the service:**

  ```bash
  docker compose pull && docker compose up -d
  ```

* **Check logs:**

  ```bash
  docker logs -f emby
  ```

* **Persistent data:**
  Configuration and UI assets are stored in `config/` and `images/`.

---

## 📚 References

* 🔗 [Emby Official Documentation](https://emby.media/support/articles/Home.html)
* 🔗 [Docker Hub – Emby Server](https://hub.docker.com/r/emby/embyserver/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)