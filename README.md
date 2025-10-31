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

**TerminSuite** provides a secure and efficient environment for managing open-source applications through a distributed network of Raspberry Pi devices.
The setup is containerized using **Docker**, ensuring modularity, easy updates, and resource isolation.

The core services currently implemented include:

* **DNS filtering and privacy protection (Pi-hole + Unbound)**
* **Reverse proxy and TLS termination (Traefik)**
* **Secure tunnel access (Cloudflared)**
* **Centralized authentication (OpenLDAP + Keycloak)**
* **Password management (Passbolt)**
* **Self-hosted media service (Emby)**

Each Raspberry Pi serves a specific purpose, and all communicate internally through a private Docker network managed by **Traefik**.

---

## 2. Device Infrastructure

### 🧠 **[RPi5A](https://github.com/Termindiego25/terminsuite/tree/main/nodes/rpi5a) — DNS and Network Filtering**

* **[Pi-hole](https://github.com/Termindiego25/terminsuite/tree/main/services/pihole)**: Local DNS resolver and ad-blocker, filtering unwanted domains and providing privacy across the network.
* **[Unbound](https://github.com/Termindiego25/terminsuite/tree/main/services/unbound)**: Recursive DNS resolver working alongside Pi-hole to ensure encrypted, independent DNS resolution.

---

### 🌐 **[RPi5B](https://github.com/Termindiego25/terminsuite/tree/main/nodes/rpi5b) — Secure Entry and Routing**

* **[Cloudflared](https://github.com/Termindiego25/terminsuite/tree/main/services/cloudflared)**: Provides encrypted tunnels to expose internal services securely through Cloudflare without port forwarding.
* **[Connector](https://github.com/Termindiego25/terminsuite/tree/main/services/connector)**: Manages Cloudflared tunnel configurations and connections.
* **[Traefik](https://github.com/Termindiego25/terminsuite/tree/main/services/traefik)**: Acts as the reverse proxy, handling SSL termination and routing traffic to internal containers.

---

### 🔐 **[RPi5C](./nodes/rpi5c) — Identity and Access Management**

* **[OpenLDAP](./services/openldap)**: Directory service for managing users, groups, and authentication records.
* **[Keycloak](./services/keycloak)**: Centralized SSO platform integrating with OpenLDAP for unified access management.
* **[Passbolt](./services/passbolt)**: Self-hosted password manager for secure credential storage and sharing.

---

### 🎬 **[RPi5D](https://github.com/Termindiego25/terminsuite/tree/main/nodes/rpi5d) — Media Server**

* **[Emby](https://github.com/Termindiego25/terminsuite/tree/main/services/emby)**: DLNA-compatible media server for internal streaming and library management.

---

## 3. Device Interconnection

* **Router**:

  * Acts as the main gateway and firewall.
  * Handles all outbound/inbound traffic and routes DNS queries to the Pi-hole instance.

* **Internal Docker Network**:

  * Enables isolated communication between containers on the same Raspberry Pi or across devices.
  * **No direct exposure** — all external access is handled via **Cloudflared** → **Traefik** → **Application**.

---

## 4. Connection Flow

1. **External Access**

   * Users connect through **Cloudflared**, establishing a secure tunnel managed by Cloudflare.

2. **Traffic Routing**

   * **Traefik** receives incoming requests, validates routing rules, and forwards them to the correct container.

3. **DNS Resolution**

   * **Pi-hole** handles DNS requests, filtering ads and trackers.
   * **Unbound** recursively resolves domains, ensuring privacy and independence from third-party DNS servers.

4. **Authentication**

   * **Keycloak** manages logins and integrates with **OpenLDAP** for user validation.

5. **Service Access**

   * Once authenticated, users can access services such as **Passbolt** (for password management) or **Emby** (for internal media streaming).

---

## 5. Authentication and Application Access

* **SSO (Single Sign-On)** via **Keycloak**, referencing **OpenLDAP** as the identity provider.
* **Role-based Access Control (RBAC)** managed through Keycloak groups.
* **Passbolt** provides encrypted password sharing among authenticated users.
* **All user data and credentials remain within the internal network**, never exposed externally.

---

## 6. Security Overview

TerminSuite’s security model is based on **defense-in-depth** and the **principle of least privilege**:

* **Cloudflared** eliminates the need for open ports, reducing the external attack surface.
* **Traefik** automatically manages TLS certificates and reverse proxy routing through Cloudflare tunnels.
* **Pi-hole + Unbound** enforce local DNS privacy and prevent exposure to public resolvers.
* **OpenLDAP + Keycloak** centralize authentication and user control.

---

## 7. Security Enhancements and Best Practices

* **Docker Rootless Mode**: Minimizes privilege escalation risks.
  → [Rootless Docker Guide](https://docs.docker.com/engine/security/rootless/)
* **Docker Secrets**: Protects sensitive credentials (LDAP binds, API keys, SSO secrets).
  → [Docker Secrets Documentation](https://docs.docker.com/engine/swarm/secrets/)
* **TLS Certificates via Cloudflare**: All traffic is encrypted end-to-end using Cloudflare-managed certificates.
* **Automated Backups**: LDAP and Passbolt databases are periodically backed up for disaster recovery.

---

## 8. Planned Services

The following services are planned or under development for future TerminSuite versions:

| Area                    | Planned Service                      | Description                                                                       |
| ----------------------- | ------------------------------------ | --------------------------------------------------------------------------------- |
| **Security Monitoring** | **Falco**                            | Host and container activity monitoring for intrusion detection.                   |
| **Remote Access**       | **RustDesk**                         | Self-hosted remote desktop server (rendezvous + relay) using Cloudflared tunnels. |
| **Monitoring**          | **Nzyme (Node + Tap)**               | Network packet analysis and IDS telemetry for intrusion detection.                |
| **WAF**                 | **ModSecurity**                      | Web Application Firewall integrated into Traefik for HTTP filtering.              |
| **SIEM & IR**           | **TheHive + Cortex + Elasticsearch** | Centralized incident response and log correlation.                                |
| **Media Expansion**     | **AzuraCast**                        | Internal streaming and radio broadcasting service.                                |
| **File Storage**        | **Nextcloud**                        | Internal NAS for file storage and user collaboration.                             |

---

✅ **Status:** Stable <br />
🔧 **Last Updated:** October 2025 <br />
📦 **Maintainer:** [Termindiego25](https://github.com/Termindiego25)