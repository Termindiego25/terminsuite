# TerminSuite: Raspberry Pi Network with Open-Source Applications

**TerminSuite** is a modular infrastructure built on **Raspberry Pi 5** devices and **Docker containers**, designed to host and secure a suite of open-source services.  
It provides centralized authentication, DNS filtering, secure remote access, and self-hosted media capabilities — optimized for **home labs**, **educational environments**, or **small-scale networks**.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Device Infrastructure](#2-device-infrastructure)
3. [Device Interconnection](#3-device-interconnection)
4. [Connection Flow](#4-connection-flow)
5. [Authentication and Application Access](#5-authentication-and-application-access)
6. [Security Overview](#6-security-overview)
7. [Security Enhancements and Best Practices](#7-security-enhancements-and-best-practices)
8. [Planned Services](#8-planned-services)

---

## 1. Introduction

**TerminSuite** provides a secure and efficient environment for managing open-source applications through a distributed network of **Raspberry Pi 5** devices.  
The setup is containerized using **Docker**, ensuring modularity, easy updates, and resource isolation.

The core services currently implemented include:

* **DNS filtering and privacy protection (Pi-hole + Unbound)**
* **Reverse proxy and TLS termination (Traefik)**
* **Secure tunnel access (Cloudflared + Connector)**
* **Centralized authentication (OpenLDAP + Keycloak)**
* **Password management (Passbolt)**
* **Self-hosted media service (Emby)**

Each Raspberry Pi serves a specific purpose and communicates internally through a private Docker network managed by **Traefik**.

---

## 2. Device Infrastructure

### 🧠 [**RPi5A — DNS and Network Filtering (4 GB)**](./nodes/rpi5a)

This node handles DNS resolution, ad-blocking, and privacy enforcement across the internal network.

* **[Pi-hole](./services/pihole)** — Local DNS resolver and network-wide ad-blocker, filtering unwanted domains and telemetry.  
* **[Unbound](./services/unbound)** — Recursive DNS resolver that ensures encrypted, independent lookups without relying on external providers.

---

### 🌐 [**RPi5B — Secure Entry and Routing (4 GB)**](./nodes/rpi5b)

This device manages secure ingress to the TerminSuite network via Cloudflare tunnels and routes traffic internally.

* **[Cloudflared](./services/cloudflared)** — Establishes encrypted tunnels for secure external access without port forwarding.  
* **[Connector](./services/connector)** — Simplifies Cloudflared configuration management and tunnel maintenance.  
* **[Traefik](./services/traefik)** — Reverse proxy that handles SSL termination and routes requests to internal containers.

---

### 🔐 [**RPi5C — Identity and Access Management (4 GB)**](./nodes/rpi5c)

This node manages user authentication, directory services, and credential storage for the entire suite.

* **[OpenLDAP](./services/openldap)** — Centralized directory for user and group management.  
* **[Keycloak](./services/keycloak)** — Unified Single Sign-On (SSO) platform integrated with OpenLDAP for identity validation.  
* **[Passbolt](./services/passbolt)** — Self-hosted password manager enabling secure storage and sharing of credentials.

---

### 🎬 [**RPi5D — Media Server (8 GB)**](./nodes/rpi5d)

This node is responsible for hosting multimedia services within the internal network.

* **[Emby](./services/emby)** — DLNA-compatible media server for private streaming, transcoding, and library organization.

---

## 3. Device Interconnection

* **Router**  
  Acts as the main gateway and firewall, routing DNS queries to **Pi-hole** and managing inbound/outbound traffic.

* **Internal Docker Network**  
  Enables isolated communication between containers across devices.  
  No service is directly exposed — all external access passes through:  
  **Cloudflared → Traefik → Application**

---

## 4. Connection Flow

1. **External Access** — Users connect via **Cloudflared**, establishing a secure tunnel managed by Cloudflare.  
2. **Traffic Routing** — **Traefik** receives incoming requests, applies routing rules, and forwards them to the target container.  
3. **DNS Resolution** — **Pi-hole** filters unwanted domains, and **Unbound** performs recursive lookups.  
4. **Authentication** — **Keycloak** manages logins and validates identities against **OpenLDAP**.  
5. **Service Access** — Authenticated users can securely access services such as **Passbolt** or **Emby**.

---

## 5. Authentication and Application Access

* **Single Sign-On (SSO)** via **Keycloak**, using **OpenLDAP** as the identity source.  
* **Role-Based Access Control (RBAC)** implemented through Keycloak groups.  
* **Passbolt** enables encrypted credential sharing among authenticated users.  
* All sensitive data remains confined within the internal network.

---

## 6. Security Overview

TerminSuite applies **defense-in-depth** and the **principle of least privilege** across all layers:

* **Cloudflared** eliminates the need for open ports, minimizing external attack surfaces.  
* **Traefik** provides SSL termination and routing exclusively through Cloudflare tunnels.  
* **Pi-hole + Unbound** enforce DNS privacy and block malicious domains.  
* **OpenLDAP + Keycloak** centralize authentication and authorization.  
* **Passbolt** secures credential storage and sharing via strong cryptography.

---

## 7. Security Enhancements and Best Practices

* **Rootless Docker Mode** — Reduces privilege escalation risks.  
  → [Rootless Docker Guide](https://docs.docker.com/engine/security/rootless/)  
* **Docker Secrets** — Protects credentials such as LDAP binds and API keys.  
  → [Docker Secrets Documentation](https://docs.docker.com/engine/swarm/secrets/)  
* **TLS Certificates via Cloudflare** — Ensures end-to-end encryption and automatic renewal.  
* **Automated Backups** — LDAP and Passbolt databases are periodically backed up for disaster recovery.

---

## 8. Planned Services

The following components are under consideration or planned for future releases:

| Area | Planned Service | Description |
|------|------------------|-------------|
| **Security Monitoring** | **Falco** | Host and container activity monitoring for intrusion detection. |
| **Remote Access** | **RustDesk** | Self-hosted remote desktop (relay + rendezvous) over Cloudflared tunnels. |
| **Network IDS** | **Nzyme (Node + Tap)** | Network telemetry and packet analysis for IDS and NIDS use cases. |
| **WAF** | **ModSecurity** | Web Application Firewall integrated with Traefik for HTTP inspection. |
| **SIEM & IR** | **TheHive + Cortex + Elasticsearch** | Incident response and log correlation stack. |
| **File Storage** | **Nextcloud** | Internal NAS for file storage and collaboration. |
| **Media Expansion** | **AzuraCast** | Internal radio and audio streaming service. |

---

✅ **Status:** Stable  
🔧 **Last Updated:** October 2025  
📦 **Maintainer:** [Termindiego25](https://github.com/Termindiego25)