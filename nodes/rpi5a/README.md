# TerminSuite - Node rpi5a (DNS & Firewall)

## Table of Contents
- [Overview](#overview)
- [Service Overview](#service-overview)
- [Integration & Network Role](#integration--network-role)
- [Falco Integration](#falco-integration)
- [Performance & Resources](#performance--resources)
- [Related Nodes](#related-nodes)

---

## 🧭 Overview
**rpi5a** serves as the **local DNS resolver and first security layer** in the TerminSuite network.  
It provides DNS-based filtering, ad-blocking, and DNSSEC validation for all internal systems.

---

## 📚 Service Overview

| Service | Description | Docker Mode | Notes |
|----------|--------------|--------------|-------|
| **[Pi-hole](../../services/pihole)** | DNS filtering and blocking for ads, trackers, and malicious domains | Normal | Requires privileged ports |
| **[Unbound](../../services/unbound)** | Validating recursive DNS resolver | Normal | Works as Pi-hole upstream resolver |
| **Falco** | Runtime security and anomaly detection | Normal | Monitors all host-level events |

---

## 🔧 Integration & Network Role
This node provides filtered DNS resolution for all TerminSuite components.  
It acts as the **primary resolver** for both internal services and user devices through Pi-hole and Unbound.  
Logs and Falco alerts are sent to **rpi5e** for analysis.

---

## 🔐 Falco Integration
Falco monitors direct system access, configuration changes, and privilege escalations.  
All alerts are securely forwarded via syslog (TLS) to **rpi5e**.

---

## 🚀 Performance & Resources
- **Memory:** 2GB RAM (typical usage < 1.2GB)  
- **CPU:** Very low  
- **Docker:** All containers run in normal mode due to network privilege requirements.

---

## 🌐 Related Nodes
- [rpi5b - Gateway & Proxy](../rpi5b/README.md)  
- [rpi5c - Authentication & Identity](../rpi5c/README.md)  
- [rpi5d - Storage & Media](../rpi5d/README.md) 
- [rpi5e - Analysis & Correlation](../rpi5e/README.md)
- [rpi5f - Tap & Collector](../rpi5f/README.md)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)