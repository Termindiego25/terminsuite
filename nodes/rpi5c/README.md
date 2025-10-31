# TerminSuite - Node rpi5c (Authentication & Identity)

## Table of Contents
- [Overview](#overview)
- [Service Overview](#service-overview)
- [Integration & Network Role](#integration--network-role)
- [Falco Integration](#falco-integration)
- [Performance & Resources](#performance--resources)
- [Related Nodes](#related-nodes)

---

## 🧭 Overview
**rpi5c** provides **centralized authentication and identity management** across TerminSuite.  
It integrates directory services, RADIUS-based Wi-Fi auth, and SSO via Keycloak.

---

## 📚 Service Overview

| Service | Description | Docker Mode | Notes |
|----------|--------------|--------------|-------|
| **[OpenLDAP](../../services/openldap)** | User and group directory | Rootless | Secure LDAP structure |
| **FreeRADIUS** | Network and VPN authentication | Rootless | Validates users through OpenLDAP |
| **[Keycloak](../../services/keycloak)** | SSO and SCIM identity federation | Rootless | Single realm for all services |
| **[Passbolt](../../services/passbolt)** | Credential and password manager | Rootless | Protected with GPG encryption |
| **Falco** | Runtime and access anomaly detection | Normal | Monitors all processes and containers |

---

## 🔧 Integration & Network Role
Acts as the **auth backend** for all TerminSuite components.  
Integrates with **Traefik**, **Nextcloud**, **Emby**, and others through OpenID Connect.  
All authentication logs are sent to **rpi5e** for aggregation.

---

## 🔐 Falco Integration
Falco monitors access attempts, config file changes, and unauthorized modifications in Keycloak or OpenLDAP.  
Alerts are sent securely to **rpi5e**.

---

## 🚀 Performance & Resources
- **Memory:** 4GB RAM (stable operation; peak <2.5GB)  
- **CPU:** Low  
- **Docker:** All core services run in Rootless; Falco runs in Normal mode.

---

## 🌐 Related Nodes
- [rpi5a - DNS & Firewall](../rpi5a/README.md)  
- [rpi5b - Gateway & Proxy](../rpi5b/README.md)  
- [rpi5d - Storage & Media](../rpi5d/README.md) 
- [rpi5e - Analysis & Correlation](../rpi5e/README.md)
- [rpi5f - Tap & Collector](../rpi5f/README.md)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)