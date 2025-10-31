# TerminSuite - Node rpi5d (Storage & Media)

## Table of Contents
- [Overview](#overview)
- [Service Overview](#service-overview)
- [Integration & Network Role](#integration--network-role)
- [Falco Integration](#falco-integration)
- [Performance & Resources](#performance--resources)
- [Related Nodes](#related-nodes)

---

## 🧭 Overview
**rpi5d** hosts TerminSuite’s **file storage and media streaming** services.  
It provides a personal cloud environment with integrated authentication and media management.

---

## 📚 Service Overview

| Service | Description | Docker Mode | Notes |
|----------|--------------|--------------|-------|
| **[Nextcloud](../../services/nextcloud)** | File sync, storage, and backup | Rootless | Integrated with SSO (Keycloak) |
| **[Emby](../../services/emby)** | DLNA server and media streaming | Rootless | Hardware-accelerated transcoding |
| **Falco** | File integrity and runtime detection | Normal | Monitors system and user access |

---

## 🔧 Integration & Network Role
Connected to **rpi5c (SSO)** for authentication and **rpi5b (Traefik)** for proxy access.  
Nextcloud backups are replicated to **rpi5e** for analysis and redundancy.

---

## 🔐 Falco Integration
Detects suspicious file manipulations, excessive downloads, or ransomware-like behavior.  
Logs are sent to **rpi5e**.

---

## 🚀 Performance & Resources
- **Memory:** 8GB RAM (required for upload/transcode peaks)  
- **CPU:** Moderate to high under streaming load  
- **Docker:** Rootless (Nextcloud, Emby) + Normal (Falco)

---

## 🌐 Related Nodes
- [rpi5a - DNS & Firewall](../rpi5a/README.md)  
- [rpi5b - Gateway & Proxy](../rpi5b/README.md)  
- [rpi5c - Authentication & Identity](../rpi5c/README.md)  
- [rpi5e - Analysis & Correlation](../rpi5e/README.md)
- [rpi5f - Tap & Collector](../rpi5f/README.md)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)