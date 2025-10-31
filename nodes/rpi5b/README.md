# TerminSuite - Node rpi5b (Gateway & Reverse Proxy)

## Table of Contents
- [Overview](#overview)
- [Service Overview](#service-overview)
- [Integration & Network Role](#integration--network-role)
- [Falco Integration](#falco-integration)
- [Performance & Resources](#performance--resources)
- [Related Nodes](#related-nodes)

---

## 🧭 Overview
**rpi5b** acts as the **entry point for all external traffic**.  
It manages secure tunneling, routing, and reverse proxying for TerminSuite’s exposed services.

---

## 📚 Service Overview

| Service | Description | Docker Mode | Notes |
|----------|--------------|--------------|-------|
| **[Cloudflared](../../services/cloudflared)** | Secure Cloudflare Tunnel for inbound/outbound access | Normal | Avoids port exposure to the Internet |
| **[Traefik](../../services/traefik)** | Reverse proxy and router for HTTP/HTTPS services | Rootless | Handles routing, TLS, and headers |
| **[Connector](../../services/connector)** | Internal connector for local network bridges | Rootless | Handles internal service discovery |
| **Falco** | Security monitoring and anomaly detection | Normal | Monitors system and containers |

---

## 🔧 Integration & Network Role
This node is the **main gateway** between Cloudflare and the internal TerminSuite environment.  
All requests pass through the Cloudflare tunnel and are routed by Traefik to the appropriate backend service.  
It communicates directly with **rpi5a (DNS)** and **rpi5c (SSO)**.

---

## 🔐 Falco Integration
Falco tracks abnormal network activity, unexpected port bindings, or container restarts.  
Events are forwarded to **rpi5e** for correlation.

---

## 🚀 Performance & Resources
- **Memory:** 4GB RAM (recommended for concurrency under heavy load)  
- **CPU:** Medium under parallel streaming or uploads  
- **Docker:** Mixed — Traefik and Connector run in Rootless mode; Cloudflared and Falco require Normal mode.

---

## 🌐 Related Nodes
- [rpi5a - DNS & Firewall](../rpi5a/README.md)  
- [rpi5c - Authentication & Identity](../rpi5c/README.md)  
- [rpi5d - Storage & Media](../rpi5d/README.md) 
- [rpi5e - Analysis & Correlation](../rpi5e/README.md)
- [rpi5f - Tap & Collector](../rpi5f/README.md)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)